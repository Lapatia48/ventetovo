package service;

import entity.MouvementStock;
import entity.Lot;
import entity.ConfigValorisationArticle;
import entity.Stock;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import repository.MouvementStockRepository;
import java.math.BigDecimal;
import java.math.RoundingMode;

import java.time.LocalDateTime;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.List;
import java.util.Optional;

@Service
public class MouvementStockService {
    
    @Autowired
    private MouvementStockRepository mouvementStockRepository;
    
    @Autowired
    private LotService lotService;
    
    @Autowired
    private StockService stockService;
    
    @Autowired
    private ConfigValorisationArticleService configValorisationArticleService;
    
    public List<MouvementStock> findAll() {
        return mouvementStockRepository.findAll();
    }
    
    public Optional<MouvementStock> findById(Integer id) {
        return mouvementStockRepository.findById(id);
    }
    
    public MouvementStock save(MouvementStock mouvement) {
        return mouvementStockRepository.save(mouvement);
    }
    
    public List<MouvementStock> findByIdArticle(Integer idArticle) {
        return mouvementStockRepository.findByIdArticle(idArticle);
    }
    
    public List<MouvementStock> findByPeriode(LocalDateTime dateDebut, LocalDateTime dateFin) {
        return mouvementStockRepository.findByPeriode(dateDebut, dateFin);
    }
    
    /**
     * Enregistrer une entrée de stock (réception fournisseur)
     */
    @Transactional
    public MouvementStock enregistrerEntreeStock(Integer idArticle, Integer quantite, 
                                                  Double coutUnitaire, Integer idUtilisateur,
                                                  String referenceDocument, String typeDocument,
                                                  LocalDate dluo, LocalDate dlc,
                                                  Integer idFournisseur) {
        
        // Vérifier si l'article nécessite une gestion par lot
        Optional<ConfigValorisationArticle> configOpt = configValorisationArticleService.findByIdArticle(idArticle);
        
        Integer idLot = null;
        if (configOpt.isPresent() && configOpt.get().getGestionLot()) {
            // Créer un nouveau lot
            Lot lot = lotService.creerLot(idArticle, quantite, coutUnitaire, idFournisseur, 
                                          referenceDocument, dluo, dlc);
            idLot = lot.getIdLot();
        }
        
        // Créer le mouvement
        MouvementStock mouvement = new MouvementStock();
        mouvement.setNumeroMouvement(genererNumeroMouvement());
        mouvement.setIdTypeMouvement(1); // RECEP_FOURN
        mouvement.setIdArticle(idArticle);
        mouvement.setIdLot(idLot);
        mouvement.setQuantite(quantite);
        mouvement.setCoutUnitaire(BigDecimal.valueOf(coutUnitaire));
        mouvement.setCoutTotal(BigDecimal.valueOf(quantite * coutUnitaire));
        mouvement.setReferenceDocument(referenceDocument);
        mouvement.setTypeDocument(typeDocument);
        mouvement.setIdUtilisateur(idUtilisateur);
        mouvement.setDateMouvement(LocalDateTime.now());
        
        mouvement = save(mouvement);
        
        // Mettre à jour le stock
        stockService.ajouterStock(idArticle, quantite);
        
        // Mettre à jour la valorisation
        mettreAJourValorisationApresEntree(idArticle, quantite, coutUnitaire);
        
        return mouvement;
    }
    
    /**
     * Enregistrer une sortie de stock (livraison client)
     */
    @Transactional
    public MouvementStock enregistrerSortieStock(Integer idArticle, Integer quantite,
                                                  Integer idUtilisateur,
                                                  String referenceDocument, String typeDocument) {
        
        // Vérifier le stock disponible
        if (!stockService.verifierDisponibilite(idArticle, quantite)) {
            throw new RuntimeException("Stock insuffisant pour l'article " + idArticle);
        }
        
        // Déterminer la méthode de valorisation
        ConfigValorisationArticle config = configValorisationArticleService.findByIdArticle(idArticle)
            .orElse(new ConfigValorisationArticle(idArticle, "CMUP"));
        
        Integer idLot = null;
        Double coutUnitaire;
        
        if ("FIFO".equals(config.getMethodeValorisation()) && config.getGestionLot()) {
            // Sélectionner le lot selon FIFO
            Lot lot = lotService.selectionnerLotFIFO(idArticle, quantite);
            if (lot == null) {
                throw new RuntimeException("Aucun lot disponible pour l'article " + idArticle);
            }
            
            idLot = lot.getIdLot();
            coutUnitaire = lot.getCoutUnitaire().doubleValue();
            
            // Consommer le lot
            lotService.consommerLot(idLot, quantite);
        } else {
            // Utiliser le CMUP
            coutUnitaire = calculerCMUP(idArticle);
        }
        
        // Créer le mouvement
        MouvementStock mouvement = new MouvementStock();
        mouvement.setNumeroMouvement(genererNumeroMouvement());
        mouvement.setIdTypeMouvement(5); // LIV_CLIENT
        mouvement.setIdArticle(idArticle);
        mouvement.setIdLot(idLot);
        mouvement.setQuantite(quantite);
        mouvement.setCoutUnitaire(BigDecimal.valueOf(coutUnitaire));
        mouvement.setCoutTotal(BigDecimal.valueOf(quantite * coutUnitaire));
        mouvement.setReferenceDocument(referenceDocument);
        mouvement.setTypeDocument(typeDocument);
        mouvement.setIdUtilisateur(idUtilisateur);
        mouvement.setDateMouvement(LocalDateTime.now());
        
        mouvement = save(mouvement);
        
        // Mettre à jour le stock
        stockService.retirerStock(idArticle, quantite);
        
        // Mettre à jour la valorisation
        mettreAJourValorisationApresSortie(idArticle, quantite, coutUnitaire);
        
        return mouvement;
    }
    
    /**
     * Calculer le coût moyen pondéré (CMUP)
     */
    private Double calculerCMUP(Integer idArticle) {
        Optional<Stock> stockOpt = stockService.findByIdArticle(idArticle);
        if (stockOpt.isPresent() && stockOpt.get().getCoutMoyenUnitaire() != null) {
            return stockOpt.get().getCoutMoyenUnitaire();
        }
        
        // Si pas de CMUP existant, calculer à partir des mouvements récents
        LocalDateTime debutMois = LocalDate.now().withDayOfMonth(1).atStartOfDay();
        List<MouvementStock> mouvements = mouvementStockRepository.findByArticleEtPeriode(
            idArticle, debutMois, LocalDateTime.now());
        
        if (mouvements.isEmpty()) {
            return 0.0;
        }
        
        double valeurTotale = 0;
        int quantiteTotale = 0;
        
        for (MouvementStock mvt : mouvements) {
            // Uniquement les entrées pour calculer le CMUP
            if (mvt.getIdTypeMouvement() <= 4) { // Types ENTREE
                valeurTotale += mvt.getCoutTotal() != null ? mvt.getCoutTotal().doubleValue() : 0.0;
                quantiteTotale += mvt.getQuantite();
            }
        }
        
        return quantiteTotale > 0 ? valeurTotale / quantiteTotale : 0.0;
    }
    
    /**
     * Mettre à jour la valorisation après une entrée
     */
    private void mettreAJourValorisationApresEntree(Integer idArticle, Integer quantite, Double coutUnitaire) {
        Optional<Stock> stockOpt = stockService.findByIdArticle(idArticle);
        if (stockOpt.isPresent()) {
            Stock stock = stockOpt.get();
            
            // Calculer le nouveau CMUP
            double valeurActuelle = stock.getValeurStock() != null ? stock.getValeurStock() : 0.0;
            double nouvelleValeur = valeurActuelle + (quantite * coutUnitaire);
            int nouvelleQuantite = stock.getQuantiteDisponible();
            
            double nouveauCMUP = nouvelleQuantite > 0 ? nouvelleValeur / nouvelleQuantite : coutUnitaire;
            
            stock.setCoutMoyenUnitaire(nouveauCMUP);
            stock.setValeurStock(nouvelleValeur);
            stockService.save(stock);
        }
    }
    
    /**
     * Mettre à jour la valorisation après une sortie
     */
    private void mettreAJourValorisationApresSortie(Integer idArticle, Integer quantite, Double coutUnitaire) {
        Optional<Stock> stockOpt = stockService.findByIdArticle(idArticle);
        if (stockOpt.isPresent()) {
            Stock stock = stockOpt.get();
            
            double valeurActuelle = stock.getValeurStock() != null ? stock.getValeurStock() : 0.0;
            double valeurSortie = quantite * coutUnitaire;
            double nouvelleValeur = Math.max(0, valeurActuelle - valeurSortie);
            
            stock.setValeurStock(nouvelleValeur);
            
            // Recalculer le CMUP si nécessaire
            if (stock.getQuantiteDisponible() > 0) {
                double nouveauCMUP = nouvelleValeur / stock.getQuantiteDisponible();
                stock.setCoutMoyenUnitaire(nouveauCMUP);
            }
            
            stockService.save(stock);
        }
    }
    
    /**
     * Générer un numéro de mouvement unique
     */
    private String genererNumeroMouvement() {
        long count = mouvementStockRepository.countAll() + 1;
        return "MVT-" + LocalDateTime.now().getYear() + "-" + String.format("%06d", count);
    }
    
    /**
     * Obtenir l'historique des mouvements pour un article
     */
    public List<MouvementStock> getHistoriqueMouvements(Integer idArticle, 
                                                        LocalDate dateDebut, 
                                                        LocalDate dateFin) {
        LocalDateTime debut = dateDebut.atStartOfDay();
        LocalDateTime fin = dateFin.atTime(23, 59, 59);
        return mouvementStockRepository.findByArticleEtPeriode(idArticle, debut, fin);
    }
}

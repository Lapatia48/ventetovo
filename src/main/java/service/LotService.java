package service;

import entity.Lot;
import entity.ConfigValorisationArticle;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import repository.LotRepository;
import repository.ConfigValorisationArticleRepository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class LotService {
    
    @Autowired
    private LotRepository lotRepository;
    
    @Autowired
    private ConfigValorisationArticleRepository configValorisationArticleRepository;
    
    public List<Lot> findAll() {
        return lotRepository.findAll();
    }
    
    public Optional<Lot> findById(Integer id) {
        return lotRepository.findById(id);
    }
    
    public Lot save(Lot lot) {
        return lotRepository.save(lot);
    }
    
    public List<Lot> findByIdArticle(Integer idArticle) {
        return lotRepository.findByIdArticle(idArticle);
    }
    
    public List<Lot> findLotsActifsParArticle(Integer idArticle) {
        return lotRepository.findByIdArticleAndStatut(idArticle, "ACTIF");
    }
    
    public Lot creerLot(Integer idArticle, Integer quantite, Double coutUnitaire, 
                        Integer idFournisseur, String referenceDocument,
                        LocalDate dluo, LocalDate dlc) {
        
        String numeroLot = genererNumeroLot();
        
        Lot lot = new Lot(numeroLot, idArticle, quantite, coutUnitaire);
        lot.setIdFournisseur(idFournisseur);
        lot.setReferenceDocument(referenceDocument);
        lot.setDluo(dluo);
        lot.setDlc(dlc);
        lot.setDateFabrication(LocalDate.now());
        
        // Vérifier si le lot est déjà périmé
        if (lot.estPerime()) {
            lot.setStatut("EXPIRE");
        }
        
        return save(lot);
    }
    
    /**
     * Sélectionner le lot à utiliser selon la méthode FIFO/FEFO
     */
    public Lot selectionnerLotFIFO(Integer idArticle, Integer quantiteDemandee) {
        List<Lot> lotsActifs = lotRepository.findLotsActifsParArticleFIFO(idArticle);
        
        for (Lot lot : lotsActifs) {
            if (lot.getQuantiteRestante() >= quantiteDemandee) {
                return lot;
            }
        }
        
        // Si aucun lot unique ne suffit, retourner le premier lot disponible
        return lotsActifs.isEmpty() ? null : lotsActifs.get(0);
    }
    
    /**
     * Consommer une quantité d'un lot
     */
    public void consommerLot(Integer idLot, Integer quantite) {
        Lot lot = findById(idLot)
            .orElseThrow(() -> new RuntimeException("Lot non trouvé: " + idLot));
        
        if (!"ACTIF".equals(lot.getStatut())) {
            throw new RuntimeException("Le lot " + lot.getNumeroLot() + " n'est pas actif (statut: " + lot.getStatut() + ")");
        }
        
        if (lot.estPerime()) {
            lot.setStatut("EXPIRE");
            save(lot);
            throw new RuntimeException("Le lot " + lot.getNumeroLot() + " est périmé");
        }
        
        lot.consommer(quantite);
        save(lot);
    }
    
    /**
     * Bloquer automatiquement les lots expirés
     */
    public void bloquerLotsExpires() {
        // Pour DLUO, on considère expiré si dépassé de 30 jours
        LocalDate dateLimiteDLUO = LocalDate.now().minusDays(30);
        List<Lot> lotsExpires = lotRepository.findLotsExpires(dateLimiteDLUO);
        
        for (Lot lot : lotsExpires) {
            lot.setStatut("EXPIRE");
            save(lot);
        }
    }
    
    /**
     * Obtenir les lots proches de la péremption
     */
    public List<Lot> getLotsProchesPeremption(int joursAvant) {
        LocalDate dateAlerte = LocalDate.now().plusDays(joursAvant);
        
        List<Lot> lots = lotRepository.findLotsProchesPeremptionDLC(dateAlerte);
        lots.addAll(lotRepository.findLotsProchesPeremptionDLUO(dateAlerte));
        
        return lots;
    }
    
    /**
     * Générer un numéro de lot unique
     */
    private String genererNumeroLot() {
        long count = lotRepository.count() + 1;
        return "LOT-" + LocalDateTime.now().getYear() + "-" + String.format("%06d", count);
    }
    
    /**
     * Bloquer un lot (non-conforme, problème qualité, etc.)
     */
    public void bloquerLot(Integer idLot, String raison) {
        Lot lot = findById(idLot)
            .orElseThrow(() -> new RuntimeException("Lot non trouvé"));
        
        lot.setStatut("BLOQUE");
        save(lot);
    }
}

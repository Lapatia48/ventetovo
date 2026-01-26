package service;

import entity.BonLivraisonClient;
import entity.FactureClient;
import entity.BonCommandeClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import repository.BonLivraisonClientRepository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class BonLivraisonClientService {
    
    @Autowired
    private BonLivraisonClientRepository bonLivraisonClientRepository;
    
    @Autowired
    private FactureClientService factureClientService;
    
    @Autowired
    private BonCommandeClientService bonCommandeClientService;
    
    @Autowired
    private StockService stockService;
    
    public List<BonLivraisonClient> findAll() {
        return bonLivraisonClientRepository.findAll();
    }
    
    public Optional<BonLivraisonClient> findById(Integer id) {
        return bonLivraisonClientRepository.findById(id);
    }
    
    public BonLivraisonClient save(BonLivraisonClient bonLivraisonClient) {
        return bonLivraisonClientRepository.save(bonLivraisonClient);
    }
    
    public List<BonLivraisonClient> findByIdClient(Integer idClient) {
        return bonLivraisonClientRepository.findByIdClient(idClient);
    }
    
    public List<BonLivraisonClient> findByStatut(String statut) {
        return bonLivraisonClientRepository.findByStatut(statut);
    }
    
    public BonLivraisonClient creerBonLivraisonFromFacture(Integer idFactureClient) {
        FactureClient facture = factureClientService.findById(idFactureClient)
            .orElseThrow(() -> new RuntimeException("Facture non trouvée"));
        
        if (!"PAYE_TOTAL".equals(facture.getStatutPaiement())) {
            throw new RuntimeException("La facture doit être payée avant de créer un bon de livraison");
        }
        
        // Récupérer le bon de commande pour obtenir les détails de l'article
        BonCommandeClient bonCommande = bonCommandeClientService.findById(facture.getIdBonCommandeClient())
            .orElseThrow(() -> new RuntimeException("Bon de commande non trouvé"));
        
        BonLivraisonClient bonLivraison = new BonLivraisonClient();
        bonLivraison.setNumeroBlClient(genererNumeroBonLivraison());
        bonLivraison.setIdFactureClient(idFactureClient);
        bonLivraison.setIdClient(facture.getIdClient());
        bonLivraison.setQuantiteLivree(bonCommande.getQuantite());
        // Champs non persistés dans final.sql (transient)
        bonLivraison.setIdArticle(bonCommande.getIdArticle());
        bonLivraison.setDateLivraisonPrevue(LocalDate.now().plusDays(7)); // indicatif UI
        
        return save(bonLivraison);
    }
    
    public void expedierLivraison(Integer idBonLivraisonClient, Integer idLivreur) {
        BonLivraisonClient bonLivraison = findById(idBonLivraisonClient)
            .orElseThrow(() -> new RuntimeException("Bon de livraison non trouvé"));
        
        bonLivraison.setStatut("EXPEDIE");

        // Champs non persistés dans final.sql
        bonLivraison.setIdLivreur(idLivreur);
        bonLivraison.setDateExpedition(LocalDateTime.now());

        Integer idArticle = resolveIdArticle(bonLivraison);
        
        // Retirer le stock et libérer la réservation
        stockService.retirerStock(idArticle, bonLivraison.getQuantiteLivree());
        stockService.libererReservation(idArticle, bonLivraison.getQuantiteLivree());
        
        save(bonLivraison);
    }
    
    public void marquerCommeLivre(Integer idBonLivraisonClient) {
        BonLivraisonClient bonLivraison = findById(idBonLivraisonClient)
            .orElseThrow(() -> new RuntimeException("Bon de livraison non trouvé"));
        
        bonLivraison.setStatut("LIVRE");
        bonLivraison.setDateLivraison(LocalDate.now());
        save(bonLivraison);
    }

    private Integer resolveIdArticle(BonLivraisonClient bonLivraison) {
        FactureClient facture = factureClientService.findById(bonLivraison.getIdFactureClient())
            .orElseThrow(() -> new RuntimeException("Facture non trouvée"));
        BonCommandeClient bonCommande = bonCommandeClientService.findById(facture.getIdBonCommandeClient())
            .orElseThrow(() -> new RuntimeException("Bon de commande non trouvé"));
        return bonCommande.getIdArticle();
    }
    
    private String genererNumeroBonLivraison() {
        long count = bonLivraisonClientRepository.count() + 1;
        return "BLC-" + LocalDateTime.now().getYear() + "-" + String.format("%05d", count);
    }
}

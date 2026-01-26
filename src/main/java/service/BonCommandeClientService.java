package service;

import entity.BonCommandeClient;
import entity.ProformaClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import repository.BonCommandeClientRepository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class BonCommandeClientService {
    
    @Autowired
    private BonCommandeClientRepository bonCommandeClientRepository;
    
    @Autowired
    private ProformaClientService proformaClientService;
    
    @Autowired
    private StockService stockService;
    
    public List<BonCommandeClient> findAll() {
        return bonCommandeClientRepository.findAll();
    }
    
    public Optional<BonCommandeClient> findById(Integer id) {
        return bonCommandeClientRepository.findById(id);
    }
    
    public BonCommandeClient save(BonCommandeClient bonCommandeClient) {
        return bonCommandeClientRepository.save(bonCommandeClient);
    }
    
    public List<BonCommandeClient> findByIdClient(Integer idClient) {
        return bonCommandeClientRepository.findByIdClient(idClient);
    }
    
    public List<BonCommandeClient> findByStatut(String statut) {
        return bonCommandeClientRepository.findByStatut(statut);
    }
    
    public BonCommandeClient creerBonCommandeFromProforma(Integer idProformaClient) {
        ProformaClient proforma = proformaClientService.findById(idProformaClient)
            .orElseThrow(() -> new RuntimeException("Proforma non trouvée"));
        
        if (!"ACCEPTE".equals(proforma.getStatut())) {
            throw new RuntimeException("La proforma doit être acceptée avant de créer un bon de commande");
        }
        
        BonCommandeClient bonCommande = new BonCommandeClient();
        bonCommande.setNumeroBcClient(genererNumeroBonCommande());
        bonCommande.setIdProformaClient(idProformaClient);
        bonCommande.setIdClient(proforma.getIdClient());
        bonCommande.setIdArticle(proforma.getIdArticle());
        bonCommande.setQuantite(proforma.getQuantite());
        bonCommande.setPrixUnitaire(proforma.getPrixUnitaire());
        bonCommande.setMontantTotal(proforma.getMontantTotal());
        bonCommande.setStatut("EN_COURS");
        
        return save(bonCommande);
    }
    
    public void verifierStock(Integer idBonCommandeClient) {
        BonCommandeClient bonCommande = findById(idBonCommandeClient)
            .orElseThrow(() -> new RuntimeException("Bon de commande non trouvé"));
        
        boolean stockDisponible = stockService.verifierDisponibilite(
            bonCommande.getIdArticle(), 
            bonCommande.getQuantite()
        );
        
        bonCommande.setStockVerifie(true);
        bonCommande.setStockSuffisant(stockDisponible);
        
        if (stockDisponible) {
            // Réserver le stock
            stockService.reserverStock(bonCommande.getIdArticle(), bonCommande.getQuantite());
            // final.sql: statut IN ('EN_COURS', 'LIVRE_PARTIEL', 'LIVRE_TOTAL', 'ANNULE')
            // On conserve EN_COURS pour indiquer une commande active.
            bonCommande.setStatut("EN_COURS");
        }
        
        save(bonCommande);
    }
    
    public void annulerBonCommande(Integer idBonCommandeClient) {
        BonCommandeClient bonCommande = findById(idBonCommandeClient)
            .orElseThrow(() -> new RuntimeException("Bon de commande non trouvé"));
        
        // Libérer le stock réservé si nécessaire
        if (bonCommande.getStockSuffisant()) {
            stockService.libererReservation(bonCommande.getIdArticle(), bonCommande.getQuantite());
        }
        
        bonCommande.setStatut("ANNULE");
        save(bonCommande);
    }
    
    private String genererNumeroBonCommande() {
        long count = bonCommandeClientRepository.count() + 1;
        return "BCC-" + LocalDateTime.now().getYear() + "-" + String.format("%05d", count);
    }
}

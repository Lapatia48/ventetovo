package service;

import entity.FactureClient;
import entity.BonCommandeClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import repository.FactureClientRepository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class FactureClientService {
    
    @Autowired
    private FactureClientRepository factureClientRepository;
    
    @Autowired
    private BonCommandeClientService bonCommandeClientService;
    
    public List<FactureClient> findAll() {
        return factureClientRepository.findAll();
    }
    
    public Optional<FactureClient> findById(Integer id) {
        return factureClientRepository.findById(id);
    }
    
    public FactureClient save(FactureClient factureClient) {
        return factureClientRepository.save(factureClient);
    }
    
    public List<FactureClient> findByIdClient(Integer idClient) {
        return factureClientRepository.findByIdClient(idClient);
    }
    
    public List<FactureClient> findByStatutPaiement(String statutPaiement) {
        return factureClientRepository.findByStatutPaiement(statutPaiement);
    }
    
    public Optional<FactureClient> findByIdBonCommandeClient(Integer idBonCommandeClient) {
        return factureClientRepository.findByIdBonCommandeClient(idBonCommandeClient);
    }
    
    public FactureClient creerFactureFromBonCommande(Integer idBonCommandeClient) {
        BonCommandeClient bonCommande = bonCommandeClientService.findById(idBonCommandeClient)
            .orElseThrow(() -> new RuntimeException("Bon de commande non trouvé"));

        if ("ANNULE".equals(bonCommande.getStatut())) {
            throw new RuntimeException("Le bon de commande est annulé");
        }
        
        // Vérifier qu'une facture n'existe pas déjà
        if (findByIdBonCommandeClient(idBonCommandeClient).isPresent()) {
            throw new RuntimeException("Une facture existe déjà pour ce bon de commande");
        }
        
        FactureClient facture = new FactureClient();
        facture.setNumeroFactureClient(genererNumeroFacture());
        facture.setIdBonCommandeClient(idBonCommandeClient);
        facture.setIdClient(bonCommande.getIdClient());
        // final.sql: montant_ht/montant_tva/montant_ttc
        facture.setMontantHt(bonCommande.getMontantTotal());
        facture.setMontantTva(0.0);
        facture.setMontantTotal(bonCommande.getMontantTotal());
        facture.setDateEcheance(LocalDate.now().plusDays(30)); // 30 jours pour payer
        
        return save(facture);
    }
    
    public void enregistrerPaiement(Integer idFactureClient, Double montantPaye) {
        FactureClient facture = findById(idFactureClient)
            .orElseThrow(() -> new RuntimeException("Facture non trouvée"));
        
        facture.enregistrerPaiement(montantPaye);
        save(facture);
    }
    
    private String genererNumeroFacture() {
        long count = factureClientRepository.count() + 1;
        return "FC-" + LocalDateTime.now().getYear() + "-" + String.format("%05d", count);
    }
}

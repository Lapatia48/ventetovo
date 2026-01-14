package service;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import entity.BonCommande;
import entity.FactureFournisseur;
import repository.BonCommandeRepository;
import repository.FactureFournisseurRepository;

@Service
public class FactureFournisseurService {
    
    @Autowired
    private FactureFournisseurRepository factureFournisseurRepository;
    
    @Autowired
    private BonCommandeRepository bonCommandeRepository;
    
    @Autowired
    private BonCommandeService bonCommandeService;
    
    // Find by ID Bon Commande
    public Optional<FactureFournisseur> findByIdBonCommande(Integer idBonCommande) {
        Optional<FactureFournisseur> factureOpt = factureFournisseurRepository.findByIdBonCommande(idBonCommande);
        factureOpt.ifPresent(this::enrichirAvecBonCommande);
        return factureOpt;
    }
    
    // Find All
    public List<FactureFournisseur> findAll() {
        List<FactureFournisseur> factures = factureFournisseurRepository.findAll();
        for (FactureFournisseur facture : factures) {
            enrichirAvecBonCommande(facture);
        }
        return factures;
    }
    
    // Save
    public FactureFournisseur save(FactureFournisseur factureFournisseur) {
        return factureFournisseurRepository.save(factureFournisseur);
    }
    
    // Créer une facture à partir d'un bon de commande
    public FactureFournisseur creerFactureFromBonCommande(Integer idBonCommande, Double montant) {
        // Vérifier si une facture existe déjà
        Optional<FactureFournisseur> existing = factureFournisseurRepository.findByIdBonCommande(idBonCommande);
        if (existing.isPresent()) {
            return existing.get();
        }
        
        // Générer un numéro de facture
        String numeroFacture = "FAC-" + LocalDate.now().getYear() + "-" + 
                              String.format("%04d", (int)(Math.random() * 10000));
        
        // Créer la facture
        FactureFournisseur facture = new FactureFournisseur(numeroFacture, idBonCommande, montant);
        facture.setDateEcheance(LocalDate.now().plusDays(30)); // Échéance dans 30 jours
        
        FactureFournisseur saved = factureFournisseurRepository.save(facture);
        enrichirAvecBonCommande(saved);
        
        return saved;
    }
    
    // Marquer comme réglée
    public void marquerCommeReglee(Integer idFacture) {
        Optional<FactureFournisseur> factureOpt = factureFournisseurRepository.findById(idFacture);
        factureOpt.ifPresent(facture -> {
            facture.setStatut("REGLEE");
            factureFournisseurRepository.save(facture);
        });
    }
    
    private void enrichirAvecBonCommande(FactureFournisseur facture) {
        if (facture != null && facture.getIdBonCommande() != null) {
            Optional<BonCommande> bonCommandeOpt = bonCommandeRepository.findById(facture.getIdBonCommande());
            if (bonCommandeOpt.isPresent()) {
                // Utiliser le service pour enrichir avec proforma (qui enrichit aussi article et fournisseur)
                if (bonCommandeOpt.get().getIdProforma() != null) {
                    bonCommandeService.findByIdProforma(bonCommandeOpt.get().getIdProforma()).ifPresent(enriched -> {
                        facture.setBonCommande(enriched);
                    });
                } else {
                    facture.setBonCommande(bonCommandeOpt.get());
                }
            }
        }
    }

    public Optional<FactureFournisseur> findById(Integer idFacture) {
        Optional<FactureFournisseur> factureOpt = factureFournisseurRepository.findById(idFacture);
        factureOpt.ifPresent(this::enrichirAvecBonCommande);
        return factureOpt;
    }
}
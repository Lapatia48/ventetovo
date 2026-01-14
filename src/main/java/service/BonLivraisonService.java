package service;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import entity.BonLivraison;
import repository.BonCommandeRepository;
import repository.BonLivraisonRepository;

@Service
public class BonLivraisonService {
    
    @Autowired
    private BonLivraisonRepository bonLivraisonRepository;
    
    @Autowired
    private BonCommandeRepository bonCommandeRepository;
    
    @Autowired
    private BonCommandeService bonCommandeService;
    
    // Find by ID Bon Commande
    public List<BonLivraison> findByIdBonCommande(Integer idBonCommande) {
        List<BonLivraison> livraisons = bonLivraisonRepository.findByIdBonCommande(idBonCommande);
        for (BonLivraison livraison : livraisons) {
            enrichirAvecBonCommande(livraison);
        }
        return livraisons;
    }
    
    // Find All
    public List<BonLivraison> findAll() {
        List<BonLivraison> livraisons = bonLivraisonRepository.findAll();
        for (BonLivraison livraison : livraisons) {
            enrichirAvecBonCommande(livraison);
        }
        return livraisons;
    }
    
    // Save
    public BonLivraison save(BonLivraison bonLivraison) {
        return bonLivraisonRepository.save(bonLivraison);
    }
    
    // Créer un bon de livraison à partir d'un bon de commande
    public BonLivraison creerBonLivraisonFromBonCommande(Integer idBonCommande) {
        // Générer un numéro de livraison
        String numeroLivraison = "BL-" + LocalDate.now().getYear() + "-" + 
                                String.format("%04d", (int)(Math.random() * 10000));
        
        // Créer le bon de livraison
        BonLivraison bonLivraison = new BonLivraison(numeroLivraison, idBonCommande);
        bonLivraison.setTransporteur("Transporteur par défaut");
        
        BonLivraison saved = bonLivraisonRepository.save(bonLivraison);
        enrichirAvecBonCommande(saved);
        
        return saved;
    }
    
    // Marquer comme reçu
    public void marquerCommeRecu(Integer idBonLivraison) {
        Optional<BonLivraison> bonLivraisonOpt = bonLivraisonRepository.findById(idBonLivraison);
        bonLivraisonOpt.ifPresent(livraison -> {
            livraison.setStatut("RECU");
            bonLivraisonRepository.save(livraison);
        });
    }
    
    private void enrichirAvecBonCommande(BonLivraison bonLivraison) {
        if (bonLivraison != null && bonLivraison.getIdBonCommande() != null) {
            // Utiliser le service pour obtenir le bon de commande enrichi avec proforma, article et fournisseur
            bonCommandeRepository.findById(bonLivraison.getIdBonCommande()).ifPresent(bc -> {
                if (bc.getIdProforma() != null) {
                    bonCommandeService.findByIdProforma(bc.getIdProforma()).ifPresent(bonLivraison::setBonCommande);
                } else {
                    bonLivraison.setBonCommande(bc);
                }
            });
        }
    }

    public Optional<BonLivraison> findById(Integer idBonLivraison) {
        Optional<BonLivraison> bonLivraisonOpt = bonLivraisonRepository.findById(idBonLivraison);
        bonLivraisonOpt.ifPresent(this::enrichirAvecBonCommande);
        return bonLivraisonOpt;
    }
}
package service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import entity.BonCommande;
import entity.Proforma;
import repository.BonCommandeRepository;
import repository.ProformaRepository;
import java.util.List;
import java.util.Optional;

@Service
public class BonCommandeService {
    
    @Autowired
    private BonCommandeRepository bonCommandeRepository;
    
    @Autowired
    private ProformaRepository proformaRepository;
    
    // Find by ID Proforma
    public Optional<BonCommande> findByIdProforma(Integer idProforma) {
        Optional<BonCommande> bonCommandeOpt = bonCommandeRepository.findByIdProforma(idProforma);
        bonCommandeOpt.ifPresent(this::enrichirAvecProforma);
        return bonCommandeOpt;
    }
    
    // Find All
    public List<BonCommande> findAll() {
        List<BonCommande> bonCommandes = bonCommandeRepository.findAll();
        for (BonCommande bc : bonCommandes) {
            enrichirAvecProforma(bc);
        }
        return bonCommandes;
    }
    
    // Save
    public BonCommande save(BonCommande bonCommande) {
        return bonCommandeRepository.save(bonCommande);
    }
    
    // Create BonCommande from Proforma
    public BonCommande creerBonCommandeFromProforma(Integer idProforma) {
        // Vérifier si un bon de commande existe déjà pour cette proforma
        Optional<BonCommande> existing = bonCommandeRepository.findByIdProforma(idProforma);
        if (existing.isPresent()) {
            return existing.get();
        }
        
        // Créer un nouveau bon de commande
        BonCommande bonCommande = new BonCommande(idProforma);
        BonCommande saved = bonCommandeRepository.save(bonCommande);
        
        // Enrichir avec les infos de la proforma
        enrichirAvecProforma(saved);
        
        return saved;
    }
    
    // Méthode utilitaire pour enrichir avec la proforma
    private void enrichirAvecProforma(BonCommande bonCommande) {
        if (bonCommande != null && bonCommande.getIdProforma() != null) {
            Optional<Proforma> proformaOpt = proformaRepository.findById(bonCommande.getIdProforma());
            proformaOpt.ifPresent(bonCommande::setProforma);
        }
    }
}
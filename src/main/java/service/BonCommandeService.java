package service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import entity.BonCommande;
import entity.Proforma;
import repository.ArticleRepository;
import repository.BonCommandeRepository;
import repository.FournisseurRepository;
import repository.ProformaRepository;

@Service
public class BonCommandeService {
    
    @Autowired
    private BonCommandeRepository bonCommandeRepository;
    
    @Autowired
    private ProformaRepository proformaRepository;
    
    @Autowired
    private ArticleRepository articleRepository;
    
    @Autowired
    private FournisseurRepository fournisseurRepository;
    
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
            if (proformaOpt.isPresent()) {
                Proforma proforma = proformaOpt.get();
                
                // Enrichir la proforma avec l'article et le fournisseur
                if (proforma.getIdArticle() != null) {
                    articleRepository.findById(proforma.getIdArticle()).ifPresent(proforma::setArticle);
                }
                if (proforma.getIdFournisseur() != null) {
                    fournisseurRepository.findById(proforma.getIdFournisseur()).ifPresent(proforma::setFournisseur);
                }
                
                bonCommande.setProforma(proforma);
            }
        }
    }
}
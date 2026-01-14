package service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import entity.VBonCommande;
import repository.VBonCommandeRepository;
import java.util.List;

@Service
public class VBonCommandeService {
    
    @Autowired
    private VBonCommandeRepository vBonCommandeRepository;
    
    // Find All
    public List<VBonCommande> findAll() {
        return vBonCommandeRepository.findAll();
    }
    
    // Find by ID Proforma
    public List<VBonCommande> findByIdProforma(Integer idProforma) {
        return vBonCommandeRepository.findByIdProforma(idProforma);
    }
    
    // Find by Statut
    public List<VBonCommande> findByStatut(String statut) {
        return vBonCommandeRepository.findByStatut(statut);
    }
    
    // Find by Fournisseur
    public List<VBonCommande> findByNomFournisseur(String nomFournisseur) {
        return vBonCommandeRepository.findByNomFournisseurContainingIgnoreCase(nomFournisseur);
    }
    
    // Find by Code Article
    public List<VBonCommande> findByCodeArticle(String codeArticle) {
        return vBonCommandeRepository.findByCodeArticle(codeArticle);
    }
    
    // Get by ID
    public VBonCommande findById(Integer idBonCommande) {
        return vBonCommandeRepository.findById(idBonCommande).orElse(null);
    }
}
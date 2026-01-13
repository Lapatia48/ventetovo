package service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import entity.Article;
import entity.Fournisseur;
import entity.Prix;
import repository.ArticleRepository;
import repository.FournisseurRepository;
import repository.PrixRepository;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
public class PrixService {
    
    @Autowired
    private PrixRepository prixRepository;
    
    @Autowired
    private ArticleRepository articleRepository;
    
    @Autowired
    private FournisseurRepository fournisseurRepository;
    
    public List<Prix> findAll() {
        List<Prix> prixList = prixRepository.findAll();
        for (Prix prix : prixList) {
            enrichirPrix(prix);
        }
        return prixList;
    }
    
    public Optional<Prix> findById(Integer id) {
        Optional<Prix> prixOpt = prixRepository.findById(id);
        prixOpt.ifPresent(this::enrichirPrix);
        return prixOpt;
    }
    
    public List<Prix> findPrixAchatByArticle(Integer idArticle) {
        List<Prix> prixList = prixRepository.findByIdArticleAndType(idArticle, "ACHAT");
        for (Prix prix : prixList) {
            enrichirPrix(prix);
        }
        return prixList;
    }
    
    public List<Prix> findPrixVenteByArticle(Integer idArticle) {
        List<Prix> prixList = prixRepository.findByIdArticleAndType(idArticle, "VENTE");
        for (Prix prix : prixList) {
            enrichirPrix(prix);
        }
        return prixList;
    }
    
    public Optional<Prix> findDernierPrixAchat(Integer idArticle) {
        List<Prix> prixList = prixRepository.findDernierPrixByArticleAndType(idArticle, "ACHAT");
        if (!prixList.isEmpty()) {
            Prix prix = prixList.get(0);
            enrichirPrix(prix);
            return Optional.of(prix);
        }
        return Optional.empty();
    }
    
    public Prix save(Prix prix) {
        if (prix.getDatePrix() == null) {
            prix.setDatePrix(LocalDate.now());
        }
        return prixRepository.save(prix);
    }
    
    public void delete(Integer id) {
        prixRepository.deleteById(id);
    }
    
    private void enrichirPrix(Prix prix) {
        if (prix != null) {
            // Enrichir avec l'article
            if (prix.getIdArticle() != null) {
                Optional<Article> articleOpt = articleRepository.findById(prix.getIdArticle());
                articleOpt.ifPresent(prix::setArticle);
            }
            
            // Enrichir avec le fournisseur
            if (prix.getIdFournisseur() != null) {
                Optional<Fournisseur> fournisseurOpt = fournisseurRepository.findById(prix.getIdFournisseur());
                fournisseurOpt.ifPresent(prix::setFournisseur);
            }
        }
    }
}
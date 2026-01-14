package service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import entity.BonReception;
import entity.BonLivraison;
import entity.Article;
import repository.BonReceptionRepository;
import repository.BonLivraisonRepository;
import repository.ArticleRepository;
import java.util.List;
import java.util.Optional;

@Service
public class BonReceptionService {
    
    @Autowired
    private BonReceptionRepository bonReceptionRepository;
    
    @Autowired
    private BonLivraisonRepository bonLivraisonRepository;
    
    @Autowired
    private ArticleRepository articleRepository;
    
    // Find by ID Bon Livraison
    public List<BonReception> findByIdBonLivraison(Integer idBonLivraison) {
        List<BonReception> receptions = bonReceptionRepository.findByIdBonLivraison(idBonLivraison);
        for (BonReception reception : receptions) {
            enrichirAvecInfos(reception);
        }
        return receptions;
    }
    
    // Find All
    public List<BonReception> findAll() {
        List<BonReception> receptions = bonReceptionRepository.findAll();
        for (BonReception reception : receptions) {
            enrichirAvecInfos(reception);
        }
        return receptions;
    }
    
    // Save
    public BonReception save(BonReception bonReception) {
        return bonReceptionRepository.save(bonReception);
    }
    
    // Créer un bon de réception à partir d'un bon de livraison
    public BonReception creerBonReceptionFromBonLivraison(Integer idBonLivraison, 
                                                         Integer idArticle, 
                                                         Integer quantiteCommandee) {
        // Par défaut, on reçoit toute la quantité commandée
        BonReception bonReception = new BonReception(idBonLivraison, idArticle, 
                                                    quantiteCommandee, quantiteCommandee);
        
        BonReception saved = bonReceptionRepository.save(bonReception);
        enrichirAvecInfos(saved);
        
        return saved;
    }
    
    // Enregistrer une réception partielle
    public BonReception enregistrerReception(Integer idBonLivraison, Integer idArticle,
                                            Integer quantiteCommandee, Integer quantiteRecue,
                                            Integer quantiteNonConforme, String commentaire) {
        BonReception bonReception = new BonReception();
        bonReception.setIdBonLivraison(idBonLivraison);
        bonReception.setIdArticle(idArticle);
        bonReception.setQuantiteCommandee(quantiteCommandee);
        bonReception.setQuantiteRecue(quantiteRecue);
        bonReception.setQuantiteNonConforme(quantiteNonConforme);
        bonReception.setCommentaire(commentaire);
        
        BonReception saved = bonReceptionRepository.save(bonReception);
        enrichirAvecInfos(saved);
        
        return saved;
    }
    
    private void enrichirAvecInfos(BonReception bonReception) {
        if (bonReception != null) {
            if (bonReception.getIdBonLivraison() != null) {
                Optional<BonLivraison> livraisonOpt = bonLivraisonRepository.findById(bonReception.getIdBonLivraison());
                livraisonOpt.ifPresent(bonReception::setBonLivraison);
            }
            
            if (bonReception.getIdArticle() != null) {
                Optional<Article> articleOpt = articleRepository.findById(bonReception.getIdArticle());
                articleOpt.ifPresent(bonReception::setArticle);
            }
        }
    }
}
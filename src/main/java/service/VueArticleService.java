package service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import entity.VueArticle;
import repository.VueArticleRepository;

@Service
public class VueArticleService {
    
    @Autowired
    private VueArticleRepository VueArticleRepository;
    
    public List<VueArticle> findAll() {
        return VueArticleRepository.findAll();
    }
    
    public List<VueArticle> findByFournisseur(Integer idFournisseur) {
        return VueArticleRepository.findByIdFournisseur(idFournisseur);
    }
    
    public List<VueArticle> findByArticle(Integer idArticle) {
        return VueArticleRepository.findByIdArticle(idArticle);
    }
    
    public Optional<VueArticle> findByArticleAndFournisseur(Integer idArticle, Integer idFournisseur) {
        return VueArticleRepository.findByArticleAndFournisseur(idArticle, idFournisseur);
    }
}
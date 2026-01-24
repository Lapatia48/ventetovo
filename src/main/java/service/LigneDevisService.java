package service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import entity.Article;
import entity.Devis;
import entity.LigneDevis;
import repository.ArticleRepository;
import repository.DevisRepository;
import repository.LigneDevisRepository;

@Service
public class LigneDevisService {
    
    @Autowired
    private LigneDevisRepository ligneDevisRepository;
    
    @Autowired
    private DevisRepository devisRepository;
    
    @Autowired
    private ArticleRepository articleRepository;
    
    public List<LigneDevis> findAll() {
        List<LigneDevis> lignes = ligneDevisRepository.findAll();
        for (LigneDevis ligne : lignes) {
            enrichirAvecDevis(ligne);
            enrichirAvecArticle(ligne);
        }
        return lignes;
    }
    
    public Optional<LigneDevis> findById(Integer id) {
        Optional<LigneDevis> ligne = ligneDevisRepository.findById(id);
        ligne.ifPresent(l -> {
            enrichirAvecDevis(l);
            enrichirAvecArticle(l);
        });
        return ligne;
    }
    
    public LigneDevis save(LigneDevis ligneDevis) {
        return ligneDevisRepository.save(ligneDevis);
    }
    
    public void deleteById(Integer id) {
        ligneDevisRepository.deleteById(id);
    }
    
    public List<LigneDevis> findByIdDevis(Integer idDevis) {
        List<LigneDevis> lignes = ligneDevisRepository.findByIdDevis(idDevis);
        for (LigneDevis ligne : lignes) {
            enrichirAvecDevis(ligne);
            enrichirAvecArticle(ligne);
        }
        return lignes;
    }
    
    public List<LigneDevis> findByIdArticle(Integer idArticle) {
        List<LigneDevis> lignes = ligneDevisRepository.findByIdArticle(idArticle);
        for (LigneDevis ligne : lignes) {
            enrichirAvecDevis(ligne);
            enrichirAvecArticle(ligne);
        }
        return lignes;
    }
    
    private void enrichirAvecDevis(LigneDevis ligneDevis) {
        if (ligneDevis.getIdDevis() != null) {
            Optional<Devis> devis = devisRepository.findById(ligneDevis.getIdDevis());
            devis.ifPresent(ligneDevis::setDevis);
        }
    }
    
    private void enrichirAvecArticle(LigneDevis ligneDevis) {
        if (ligneDevis.getIdArticle() != null) {
            Optional<Article> article = articleRepository.findById(ligneDevis.getIdArticle());
            article.ifPresent(ligneDevis::setArticle);
        }
    }
}
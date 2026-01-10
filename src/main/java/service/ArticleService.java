package service;

import entity.Article;
import repository.ArticleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class ArticleService {

    @Autowired
    private ArticleRepository articleRepository;

    public List<Article> findAll() {
        return articleRepository.findAll();
    }

    public Optional<Article> findById(Long id) {
        return articleRepository.findById(id);
    }

    public Optional<Article> findByCode(String code) {
        return articleRepository.findByCode(code);
    }

    public Article save(Article article) {
        // Validation de base
        if (article.getCode() == null || article.getCode().trim().isEmpty()) {
            throw new IllegalArgumentException("Le code de l'article est obligatoire");
        }
        if (article.getDesignation() == null || article.getDesignation().trim().isEmpty()) {
            throw new IllegalArgumentException("La désignation de l'article est obligatoire");
        }
        if (article.getPrixVente() == null || article.getPrixVente().compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Le prix de vente doit être supérieur à 0");
        }
        if (article.getPrixAchat() != null && article.getPrixAchat().compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Le prix d'achat ne peut pas être négatif");
        }

        // Vérifier l'unicité du code
        if (article.getIdArticle() == null && existsByCode(article.getCode())) {
            throw new IllegalArgumentException("Un article avec ce code existe déjà");
        }

        return articleRepository.save(article);
    }

    public void deleteById(Long id) {
        articleRepository.deleteById(id);
    }

    public boolean existsByCode(String code) {
        return articleRepository.existsByCode(code);
    }

    // Méthodes métier spécifiques
    public List<Article> findByDesignationContainingIgnoreCase(String designation) {
        return articleRepository.findByDesignationContainingIgnoreCase(designation);
    }

    public List<Article> findByPrixVenteBetween(BigDecimal prixMin, BigDecimal prixMax) {
        return articleRepository.findByPrixVenteBetween(prixMin, prixMax);
    }

    public List<Article> findArticlesWithProfit() {
        return articleRepository.findArticlesWithProfit();
    }

    public List<Article> findArticlesBelowStockLevel(Integer seuil) {
        return articleRepository.findArticlesBelowStockLevel(seuil);
    }

    // Méthode pour calculer la marge
    public BigDecimal calculerMarge(Article article) {
        if (article.getPrixVente() == null || article.getPrixAchat() == null) {
            return BigDecimal.ZERO;
        }
        return article.getPrixVente().subtract(article.getPrixAchat());
    }

    // Méthode pour calculer le taux de marge
    public BigDecimal calculerTauxMarge(Article article) {
        if (article.getPrixVente() == null || article.getPrixVente().compareTo(BigDecimal.ZERO) == 0) {
            return BigDecimal.ZERO;
        }
        BigDecimal marge = calculerMarge(article);
        return marge.divide(article.getPrixVente(), 4, BigDecimal.ROUND_HALF_UP).multiply(BigDecimal.valueOf(100));
    }
}
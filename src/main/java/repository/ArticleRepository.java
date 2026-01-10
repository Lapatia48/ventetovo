package repository;

import entity.Article;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Repository
public interface ArticleRepository extends JpaRepository<Article, Long> {

    Optional<Article> findByCode(String code);

    boolean existsByCode(String code);

    List<Article> findByDesignationContainingIgnoreCase(String designation);

    List<Article> findByPrixVenteBetween(BigDecimal prixMin, BigDecimal prixMax);

    @Query("SELECT a FROM Article a WHERE a.prixVente > a.prixAchat ORDER BY a.prixVente - a.prixAchat DESC")
    List<Article> findArticlesWithProfit();

    @Query("SELECT a FROM Article a WHERE a.idArticle IN (" +
           "SELECT s.article.idArticle FROM Stock s GROUP BY s.article.idArticle HAVING SUM(s.quantite) <= :seuil)")
    List<Article> findArticlesBelowStockLevel(@Param("seuil") Integer seuil);
}
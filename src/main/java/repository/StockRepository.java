package repository;

import entity.Article;
import entity.Depot;
import entity.Stock;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface StockRepository extends JpaRepository<Stock, Long> {

    List<Stock> findByArticle(Article article);

    Optional<Stock> findByArticleAndDepot(Article article, Depot depot);

    @Query("SELECT COALESCE(SUM(s.quantite), 0) FROM Stock s WHERE s.article = :article")
    Integer sumQuantiteByArticle(@Param("article") Article article);
}
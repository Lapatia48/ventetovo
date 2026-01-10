package repository;

import entity.Article;
import entity.LigneReception;
import entity.Reception;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface LigneReceptionRepository extends JpaRepository<LigneReception, Long> {

    List<LigneReception> findByReception(Reception reception);

    List<LigneReception> findByArticle(Article article);

    List<LigneReception> findByReceptionAndArticle(Reception reception, Article article);

    @Query("SELECT SUM(lr.quantiteRecue) FROM LigneReception lr WHERE lr.reception = :reception")
    Long sumQuantiteRecueByReception(@Param("reception") Reception reception);

    @Query("SELECT lr FROM LigneReception lr WHERE lr.reception.idReception = :idReception ORDER BY lr.idLigne")
    List<LigneReception> findByReceptionIdOrderByIdLigne(@Param("idReception") Long idReception);

    boolean existsByReceptionAndArticle(Reception reception, Article article);
}
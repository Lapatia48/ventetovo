package repository;

import entity.Article;
import entity.BonCommande;
import entity.LigneBonCommande;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;

@Repository
public interface LigneBonCommandeRepository extends JpaRepository<LigneBonCommande, Long> {

    List<LigneBonCommande> findByBonCommande(BonCommande bonCommande);

    List<LigneBonCommande> findByArticle(Article article);

    List<LigneBonCommande> findByBonCommandeAndArticle(BonCommande bonCommande, Article article);

    @Query("SELECT SUM(l.quantite) FROM LigneBonCommande l WHERE l.bonCommande = :bonCommande")
    Long sumQuantiteByBonCommande(@Param("bonCommande") BonCommande bonCommande);

    @Query("SELECT SUM(l.quantite * l.prixUnitaire) FROM LigneBonCommande l WHERE l.bonCommande = :bonCommande")
    BigDecimal sumMontantTotalByBonCommande(@Param("bonCommande") BonCommande bonCommande);

    @Query("SELECT l FROM LigneBonCommande l WHERE l.bonCommande.idCommande = :idCommande ORDER BY l.idLigne")
    List<LigneBonCommande> findByBonCommandeIdOrderByIdLigne(@Param("idCommande") Long idCommande);

    boolean existsByBonCommandeAndArticle(BonCommande bonCommande, Article article);
}
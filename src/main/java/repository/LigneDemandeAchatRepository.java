package repository;

import entity.Article;
import entity.DemandeAchat;
import entity.LigneDemandeAchat;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface LigneDemandeAchatRepository extends JpaRepository<LigneDemandeAchat, Long> {

    List<LigneDemandeAchat> findByDemande(DemandeAchat demande);

    List<LigneDemandeAchat> findByArticle(Article article);

    List<LigneDemandeAchat> findByDemandeAndArticle(DemandeAchat demande, Article article);

    @Query("SELECT SUM(l.quantite) FROM LigneDemandeAchat l WHERE l.demande = :demande")
    Long sumQuantiteByDemande(@Param("demande") DemandeAchat demande);

    @Query("SELECT l FROM LigneDemandeAchat l WHERE l.demande.idDemande = :idDemande ORDER BY l.idLigne")
    List<LigneDemandeAchat> findByDemandeIdOrderByIdLigne(@Param("idDemande") Long idDemande);

    boolean existsByDemandeAndArticle(DemandeAchat demande, Article article);
}
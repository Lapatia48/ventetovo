package repository;

import entity.Lot;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface LotRepository extends JpaRepository<Lot, Integer> {
    
    List<Lot> findByIdArticle(Integer idArticle);
    
    List<Lot> findByStatut(String statut);
    
    List<Lot> findByIdArticleAndStatut(Integer idArticle, String statut);
    
    @Query("SELECT l FROM Lot l WHERE l.idArticle = :idArticle AND l.statut = 'ACTIF' AND l.quantiteRestante > 0 ORDER BY l.dlc ASC, l.dluo ASC, l.dateCreation ASC")
    List<Lot> findLotsActifsParArticleFIFO(@Param("idArticle") Integer idArticle);
    
    @Query("SELECT l FROM Lot l WHERE l.dlc IS NOT NULL AND l.dlc <= :dateAlerte AND l.statut = 'ACTIF'")
    List<Lot> findLotsProchesPeremptionDLC(@Param("dateAlerte") LocalDate dateAlerte);
    
    @Query("SELECT l FROM Lot l WHERE l.dluo IS NOT NULL AND l.dluo <= :dateAlerte AND l.statut = 'ACTIF'")
    List<Lot> findLotsProchesPeremptionDLUO(@Param("dateAlerte") LocalDate dateAlerte);
    
    @Query("SELECT l FROM Lot l WHERE l.statut = 'ACTIF' AND ((l.dlc IS NOT NULL AND l.dlc < CURRENT_DATE) OR (l.dluo IS NOT NULL AND l.dluo < :dateLimiteDLUO))")
    List<Lot> findLotsExpires(@Param("dateLimiteDLUO") LocalDate dateLimiteDLUO);
    
    // Version sans paramètre - retourne les lots expirés basé sur DLC uniquement
    @Query("SELECT l FROM Lot l WHERE l.statut = 'ACTIF' AND l.dlc IS NOT NULL AND l.dlc < CURRENT_DATE")
    List<Lot> findLotsExpiresDLC();
}

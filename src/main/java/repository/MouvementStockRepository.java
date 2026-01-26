package repository;

import entity.MouvementStock;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface MouvementStockRepository extends JpaRepository<MouvementStock, Integer> {
    
    List<MouvementStock> findByIdArticle(Integer idArticle);
    
    List<MouvementStock> findByIdLot(Integer idLot);
    
    List<MouvementStock> findByIdTypeMouvement(Integer idTypeMouvement);
    
    @Query("SELECT m FROM MouvementStock m WHERE m.dateMouvement BETWEEN :dateDebut AND :dateFin ORDER BY m.dateMouvement DESC")
    List<MouvementStock> findByPeriode(LocalDateTime dateDebut, LocalDateTime dateFin);
    
    @Query("SELECT m FROM MouvementStock m WHERE m.idArticle = :idArticle AND m.dateMouvement BETWEEN :dateDebut AND :dateFin ORDER BY m.dateMouvement ASC")
    List<MouvementStock> findByArticleEtPeriode(Integer idArticle, LocalDateTime dateDebut, LocalDateTime dateFin);
    
    List<MouvementStock> findByCloture(Boolean cloture);
    
    @Query("SELECT COUNT(m) FROM MouvementStock m")
    Long countAll();
}

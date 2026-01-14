package repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import entity.BonReception;
import java.util.List;

@Repository
public interface BonReceptionRepository extends JpaRepository<BonReception, Integer> {
    
    List<BonReception> findByIdBonLivraison(Integer idBonLivraison);
    
    List<BonReception> findByIdArticle(Integer idArticle);
}
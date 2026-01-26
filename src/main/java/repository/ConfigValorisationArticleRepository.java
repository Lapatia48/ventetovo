package repository;

import entity.ConfigValorisationArticle;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface ConfigValorisationArticleRepository extends JpaRepository<ConfigValorisationArticle, Integer> {
    
    Optional<ConfigValorisationArticle> findByIdArticle(Integer idArticle);
    
    List<ConfigValorisationArticle> findByMethodeValorisation(String methodeValorisation);
    
    List<ConfigValorisationArticle> findByGestionLot(Boolean gestionLot);
}

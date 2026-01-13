package repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import entity.Proforma;
import java.util.List;
import java.util.Optional;

@Repository
public interface ProformaRepository extends JpaRepository<Proforma, Integer> {
    
    List<Proforma> findByTokenDemande(String tokenDemande);
    
    List<Proforma> findByIdArticle(Integer idArticle);
    
    List<Proforma> findByIdFournisseur(Integer idFournisseur);
    
    Optional<Proforma> findByNumero(String numero);
    
    @Query("SELECT p FROM Proforma p WHERE p.tokenDemande = :token AND p.statut = :statut")
    List<Proforma> findByTokenDemandeAndStatut(@Param("token") String tokenDemande, 
                                              @Param("statut") String statut);
    
    @Query("SELECT DISTINCT p.tokenDemande FROM Proforma p WHERE p.idArticle = :idArticle")
    List<String> findTokensByArticle(@Param("idArticle") Integer idArticle);
}
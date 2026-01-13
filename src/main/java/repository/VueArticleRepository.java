package repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import entity.VueArticle;

@Repository
public interface VueArticleRepository extends JpaRepository<VueArticle, Integer> {
    
    List<VueArticle> findAll();
    
    List<VueArticle> findByIdFournisseur(Integer idFournisseur);
    
    List<VueArticle> findByIdArticle(Integer idArticle);
    
    @Query("SELECT v FROM VueArticle v WHERE v.idArticle = :idArticle AND v.idFournisseur = :idFournisseur")
    Optional<VueArticle> findByArticleAndFournisseur(@Param("idArticle") Integer idArticle, 
                                                            @Param("idFournisseur") Integer idFournisseur);
}
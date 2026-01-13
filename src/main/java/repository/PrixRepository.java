package repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import entity.Prix;

@Repository
public interface PrixRepository extends JpaRepository<Prix, Integer> {
    List<Prix> findByIdArticleAndType(Integer idArticle, String type);
    
    List<Prix> findByIdFournisseurAndType(Integer idFournisseur, String type);
    
    @Query("SELECT p FROM Prix p WHERE p.idArticle = :idArticle AND p.type = :type ORDER BY p.datePrix DESC")
    List<Prix> findDernierPrixByArticleAndType(@Param("idArticle") Integer idArticle, @Param("type") String type);
    
    @Query("SELECT p FROM Prix p WHERE p.idArticle = :idArticle AND p.idFournisseur = :idFournisseur AND p.type = :type AND p.datePrix = :datePrix")
    Optional<Prix> findByArticleFournisseurTypeDate(@Param("idArticle") Integer idArticle, 
                                                    @Param("idFournisseur") Integer idFournisseur,
                                                    @Param("type") String type,
                                                    @Param("datePrix") LocalDate datePrix);
}
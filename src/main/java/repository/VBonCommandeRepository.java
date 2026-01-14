package repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import entity.VBonCommande;
import java.util.List;

@Repository
public interface VBonCommandeRepository extends JpaRepository<VBonCommande, Integer> {
    
    List<VBonCommande> findAll();
    
    List<VBonCommande> findByIdProforma(Integer idProforma);
    
    List<VBonCommande> findByNomFournisseurContainingIgnoreCase(String nomFournisseur);
    
    List<VBonCommande> findByStatut(String statut);
    
    List<VBonCommande> findByCodeArticle(String codeArticle);
}
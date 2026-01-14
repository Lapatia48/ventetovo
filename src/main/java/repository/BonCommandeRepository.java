package repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import entity.BonCommande;
import java.util.List;
import java.util.Optional;

@Repository
public interface BonCommandeRepository extends JpaRepository<BonCommande, Integer> {
    
    Optional<BonCommande> findByIdProforma(Integer idProforma);
    
    List<BonCommande> findByStatut(String statut);
}
package repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import entity.BonCommandeClient;

@Repository
public interface BonCommandeClientRepository extends JpaRepository<BonCommandeClient, Integer> {
    
    List<BonCommandeClient> findByIdClient(Integer idClient);
    
    List<BonCommandeClient> findByStatut(String statut);
    
    Optional<BonCommandeClient> findByIdProformaClient(Integer idProformaClient);
}

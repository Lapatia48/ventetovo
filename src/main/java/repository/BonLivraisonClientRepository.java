package repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import entity.BonLivraisonClient;

@Repository
public interface BonLivraisonClientRepository extends JpaRepository<BonLivraisonClient, Integer> {
    
    List<BonLivraisonClient> findByIdClient(Integer idClient);
    
    List<BonLivraisonClient> findByStatut(String statut);
    
    Optional<BonLivraisonClient> findByIdFactureClient(Integer idFactureClient);
}

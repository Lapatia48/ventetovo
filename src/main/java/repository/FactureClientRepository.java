package repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import entity.FactureClient;

@Repository
public interface FactureClientRepository extends JpaRepository<FactureClient, Integer> {
    
    List<FactureClient> findByIdClient(Integer idClient);
    
    List<FactureClient> findByStatutPaiement(String statutPaiement);
    
    Optional<FactureClient> findByIdBonCommandeClient(Integer idBonCommandeClient);
}

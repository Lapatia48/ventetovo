package repository;

import entity.FactureClient;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface FactureClientRepository
        extends JpaRepository<FactureClient, Integer> {

    Optional<FactureClient> findByNumeroFacture(String numeroFacture);
    
}

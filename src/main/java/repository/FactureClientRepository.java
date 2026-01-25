package repository;

import entity.FactureClient;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.List;

public interface FactureClientRepository
        extends JpaRepository<FactureClient, Integer> {

    Optional<FactureClient> findByNumeroFacture(String numeroFacture);
        
    List<FactureClient> findByStatut(String statut);

    List<FactureClient> findByStatutIn(List<String> statuts);

}

package repository;

import entity.ReglementClient;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ReglementClientRepository extends JpaRepository<ReglementClient, Integer> {
    Optional<ReglementClient> findByNumeroReglement(String numeroReglement);
}

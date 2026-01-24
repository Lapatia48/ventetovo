package repository;

import entity.CommandeClient;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface CommandeClientRepository
        extends JpaRepository<CommandeClient, Integer> {

    Optional<CommandeClient> findByNumeroCommande(String numeroCommande);
}

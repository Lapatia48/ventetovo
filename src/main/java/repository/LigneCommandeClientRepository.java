package repository;

import entity.LigneCommandeClient;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface LigneCommandeClientRepository
        extends JpaRepository<LigneCommandeClient, Integer> {

    List<LigneCommandeClient> findByIdCommande(Integer idCommande);
}

package repository;

import entity.LivraisonClient;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface LivraisonClientRepository 
        extends JpaRepository<LivraisonClient, Integer> {

    Optional<LivraisonClient> findByNumeroLivraison(String numeroLivraison);

    List<LivraisonClient> findByIdCommande(Integer idCommande);
}

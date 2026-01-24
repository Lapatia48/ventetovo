package repository;

import entity.LigneFactureClient;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface LigneFactureClientRepository
        extends JpaRepository<LigneFactureClient, Integer> {

    List<LigneFactureClient> findByIdFacture(Integer idFacture);

    List<LigneFactureClient> findByIdFactureIsNull();
}

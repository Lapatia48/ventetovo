package repository;

import entity.Depot;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface DepotRepository extends JpaRepository<Depot, Long> {

    Optional<Depot> findByNom(String nom);
}
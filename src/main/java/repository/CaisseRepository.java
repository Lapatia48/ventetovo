package repository;

import entity.Caisse;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CaisseRepository extends JpaRepository<Caisse, Long> {

    // Méthode pour trouver la caisse principale (première)
    Caisse findFirstByOrderByIdCaisseAsc();
}
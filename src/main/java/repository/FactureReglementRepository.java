package repository;

import entity.FactureReglement;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface FactureReglementRepository extends JpaRepository<FactureReglement, Integer> {

    List<FactureReglement> findByIdFacture(Integer idFacture);
    List<FactureReglement> findByIdReglement(Integer idReglement);
}
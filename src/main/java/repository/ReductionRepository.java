package repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import entity.Reduction;

@Repository
public interface ReductionRepository extends JpaRepository<Reduction, Integer> {
    
    Optional<Reduction> findByCodeReduction(String codeReduction);
    
    List<Reduction> findByActif(Boolean actif);
    
    @Query("SELECT r FROM Reduction r WHERE r.actif = true AND (r.dateDebut IS NULL OR r.dateDebut <= :date) AND (r.dateFin IS NULL OR r.dateFin >= :date)")
    List<Reduction> findReductionsValides(@Param("date") LocalDate date);
}

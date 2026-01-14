package repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import entity.AchatFinance;
import java.util.Optional;

@Repository
public interface AchatFinanceRepository extends JpaRepository<AchatFinance, Integer> {
    
    @Query("SELECT af FROM AchatFinance af WHERE af.actif = true ORDER BY af.dateMaj DESC")
    Optional<AchatFinance> findActiveConfiguration();
}
package repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import entity.Devis;

@Repository
public interface DevisRepository extends JpaRepository<Devis, Integer> {
    Optional<Devis> findByNumeroDevis(String numeroDevis);
    
    List<Devis> findByIdClient(Integer idClient);
    
    List<Devis> findByStatut(String statut);
    
    List<Devis> findByIdCommercial(Integer idCommercial);

    // Générer le prochain numéro
    @Query("SELECT MAX(d.numeroDevis) FROM Devis d WHERE d.numeroDevis LIKE :anneePrefix%")
    Optional<String> findLastNumeroDevis(@Param("anneePrefix") String anneePrefix);

    List<Devis> findByStatutIn(List<String> statuts);
}
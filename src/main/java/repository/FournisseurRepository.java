package repository;

import entity.Fournisseur;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface FournisseurRepository extends JpaRepository<Fournisseur, Long> {

    Optional<Fournisseur> findByNom(String nom);

    List<Fournisseur> findByNomContainingIgnoreCase(String nom);

    boolean existsByNom(String nom);

    Optional<Fournisseur> findByEmail(String email);

    List<Fournisseur> findByTelephone(String telephone);
}
package repository;

import entity.Utilisateur;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UtilisateurRepo extends JpaRepository<Utilisateur, Long> {

    Optional<Utilisateur> findByEmailAndMotDePasseAndActifTrue(
            String email,
            String motDePasse
    );
    
}

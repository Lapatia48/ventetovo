package repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import entity.Utilisateur;

public interface UtilisateurRepo extends JpaRepository<Utilisateur, Long> {

    @Query("""
        SELECT u
        FROM Utilisateur u
        WHERE u.email = :email
          AND u.motDePasse = :motDePasse
          AND u.actif = true
    """)
    Optional<Utilisateur> findActiveUserWithRole(
        @Param("email") String email,
        @Param("motDePasse") String motDePasse
    );

        
}

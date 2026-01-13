package repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import entity.Utilisateur;

@Repository
public interface UtilisateurRepository extends JpaRepository<Utilisateur, Integer> {
    Optional<Utilisateur> findByEmail(String email);
    
    List<Utilisateur> findByActifTrue();
    
    @Query("SELECT u FROM Utilisateur u WHERE u.email = :email AND u.motDePasse = :motDePasse AND u.actif = true")
    Optional<Utilisateur> findByEmailAndMotDePasse(@Param("email") String email, @Param("motDePasse") String motDePasse);
}
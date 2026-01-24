package repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import entity.VUtilisateurRole;

@Repository
public interface VUtilisateurRoleRepository 
        extends JpaRepository<VUtilisateurRole, Integer> {

    Optional<VUtilisateurRole> findByEmail(String email);
}

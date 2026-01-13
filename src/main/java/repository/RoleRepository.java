package repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import entity.Role;

@Repository
public interface RoleRepository extends JpaRepository<Role, Integer> {
    // Pas de méthodes spécifiques nécessaires pour le moment
}
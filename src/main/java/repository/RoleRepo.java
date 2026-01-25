package repository;

import org.springframework.data.jpa.repository.JpaRepository;

import entity.Role;

public interface RoleRepo extends JpaRepository<Role, Integer> {
    
}

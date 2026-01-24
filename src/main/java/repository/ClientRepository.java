package repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import entity.Client;

@Repository
public interface ClientRepository extends JpaRepository<Client, Integer> {
    Optional<Client> findByCodeClient(String codeClient);
    
    Optional<Client> findByEmail(String email);
    
    List<Client> findByNomContainingIgnoreCase(String nom);
}
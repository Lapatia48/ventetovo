package repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import entity.ProformaClient;

@Repository
public interface ProformaClientRepository extends JpaRepository<ProformaClient, Integer> {
    
    List<ProformaClient> findByIdClient(Integer idClient);
    
    List<ProformaClient> findByStatut(String statut);
    
    List<ProformaClient> findByIdClientAndStatut(Integer idClient, String statut);
}

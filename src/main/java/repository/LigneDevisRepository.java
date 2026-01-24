package repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import entity.LigneDevis;

@Repository
public interface LigneDevisRepository extends JpaRepository<LigneDevis, Integer> {
    List<LigneDevis> findByIdDevis(Integer idDevis);
    
    List<LigneDevis> findByIdArticle(Integer idArticle);
}
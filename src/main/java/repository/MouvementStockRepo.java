package repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import entity.MouvementStock;

@Repository
public interface MouvementStockRepo extends JpaRepository<MouvementStock, Integer> {
    
}

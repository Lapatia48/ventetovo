package repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import entity.Stock;

@Repository
public interface StockRepository extends JpaRepository<Stock, Integer> {
    
    Optional<Stock> findByIdArticle(Integer idArticle);
}

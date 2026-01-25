package service;

import entity.StockActuel;
import org.springframework.stereotype.Service;
import repository.StockActuelRepo;

import java.util.List;

@Service
public class StockService {

    private final StockActuelRepo stockRepo;

    public StockService(StockActuelRepo stockRepo) {
        this.stockRepo = stockRepo;
    }

    public List<StockActuel> getAllCurrentStock() {
        return stockRepo.findAll();
    }
}

package service;

import entity.Article;
import entity.Depot;
import entity.Stock;
import repository.StockRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class StockService {

    @Autowired
    private StockRepository stockRepository;

    public List<Stock> findAll() {
        return stockRepository.findAll();
    }

    public Optional<Stock> findById(Long id) {
        return stockRepository.findById(id);
    }

    public List<Stock> findByArticle(Article article) {
        return stockRepository.findByArticle(article);
    }

    public Optional<Stock> findByArticleAndDepot(Article article, Depot depot) {
        return stockRepository.findByArticleAndDepot(article, depot);
    }

    public Stock save(Stock stock) {
        return stockRepository.save(stock);
    }

    // Méthode pour ajuster le stock
    public void ajusterStock(Article article, Depot depot, Integer quantite) {
        Optional<Stock> stockOpt = findByArticleAndDepot(article, depot);
        if (stockOpt.isPresent()) {
            Stock stock = stockOpt.get();
            stock.setQuantite(stock.getQuantite() + quantite);
            save(stock);
        } else if (quantite > 0) {
            // Créer un nouveau stock si positif
            Stock newStock = new Stock(article, depot, quantite);
            save(newStock);
        }
    }

    // Méthode pour obtenir le stock total d'un article
    public Integer getStockTotal(Article article) {
        return stockRepository.sumQuantiteByArticle(article);
    }
}
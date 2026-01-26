package service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import entity.Stock;
import repository.StockRepository;

@Service
public class StockService {
    
    @Autowired
    private StockRepository stockRepository;
    
    public List<Stock> findAll() {
        return stockRepository.findAll();
    }
    
    public Optional<Stock> findById(Integer id) {
        return stockRepository.findById(id);
    }
    
    public Optional<Stock> findByIdArticle(Integer idArticle) {
        return stockRepository.findByIdArticle(idArticle);
    }
    
    public Stock save(Stock stock) {
        return stockRepository.save(stock);
    }
    
    public boolean verifierDisponibilite(Integer idArticle, Integer quantiteDemandee) {
        Optional<Stock> stockOpt = findByIdArticle(idArticle);
        return stockOpt.map(stock -> stock.estDisponible(quantiteDemandee)).orElse(false);
    }
    
    public void reserverStock(Integer idArticle, Integer quantite) {
        Stock stock = findByIdArticle(idArticle)
            .orElseThrow(() -> new RuntimeException("Stock non trouvé pour l'article " + idArticle));
        stock.reserver(quantite);
        save(stock);
    }
    
    public void libererReservation(Integer idArticle, Integer quantite) {
        Stock stock = findByIdArticle(idArticle)
            .orElseThrow(() -> new RuntimeException("Stock non trouvé pour l'article " + idArticle));
        stock.libererReservation(quantite);
        save(stock);
    }
    
    public void retirerStock(Integer idArticle, Integer quantite) {
        Stock stock = findByIdArticle(idArticle)
            .orElseThrow(() -> new RuntimeException("Stock non trouvé pour l'article " + idArticle));
        stock.retirer(quantite);
        save(stock);
    }
    
    public void ajouterStock(Integer idArticle, Integer quantite) {
        Optional<Stock> stockOpt = findByIdArticle(idArticle);
        
        if (stockOpt.isPresent()) {
            Stock stock = stockOpt.get();
            stock.ajouter(quantite);
            save(stock);
        } else {
            // Créer un nouveau stock si aucun n'existe
            Stock nouveauStock = new Stock(idArticle, quantite);
            save(nouveauStock);
        }
    }
}

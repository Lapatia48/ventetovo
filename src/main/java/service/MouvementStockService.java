package service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import entity.MouvementStock;
import repository.MouvementStockRepo;

@Service
@Transactional
public class MouvementStockService {

    private final MouvementStockRepo mouvementStockRepo;

    public MouvementStockService(MouvementStockRepo mouvementStockRepo) {
        this.mouvementStockRepo = mouvementStockRepo;
    }

    public List<MouvementStock> getAllMovements() {
        return mouvementStockRepo.findAll();
    }

    public MouvementStock getMovementById(Integer id) {
        return mouvementStockRepo.findById(id).orElse(null);
    }

    public MouvementStock saveMovement(MouvementStock mouvementStock) {
        return mouvementStockRepo.save(mouvementStock);
    }

    public void deleteMovement(Integer id) {
        mouvementStockRepo.deleteById(id);
    }
}

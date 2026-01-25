package controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import entity.MouvementStock;
import service.MouvementStockService;

@Controller
public class StockController {

    private final MouvementStockService mouvementStockService;

    public StockController(MouvementStockService mouvementStockService) {
        this.mouvementStockService = mouvementStockService;
    }

    @GetMapping("/mouvements")
    public String listAllMovements(Model model) {
        List<MouvementStock> mouvements = mouvementStockService.getAllMovements();
        model.addAttribute("mouvements", mouvements);
        return "historique";
    }
}

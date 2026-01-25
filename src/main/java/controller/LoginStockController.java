package controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import entity.Role;
import entity.StockActuel;
import entity.Utilisateur;
import service.AuthServiceStock;
import service.RoleServicee;
import service.StockService;

@Controller
public class LoginStockController {
    
    private final AuthServiceStock authService;
    private final StockService stockService;  
    private final RoleServicee roleService;

    public LoginStockController(
            AuthServiceStock authService,
            StockService stockService,
            RoleServicee roleService
    ) {
        this.authService = authService;
        this.stockService = stockService;
        this.roleService = roleService;
    }

    @PostMapping("/login")
    public String login(
            @RequestParam("username") String username,
            @RequestParam("password") String password,
            HttpSession session,
            Model model
    ) {
        Utilisateur user = authService.login(username, password);

        if (user == null) {
            model.addAttribute("error", "Nom d'utilisateur ou mot de passe incorrect");
            return "login_stock";
        }

        session.setAttribute("user", user);

        // fetch role using RoleService
        Role role = roleService.getRoleById(user.getIdRole());
        if(role == null) {
            throw new RuntimeException("Role not found");
        }

        user.setRole(role);  // populate transient role

        if(user.getRole().getNiveauValidation() > 0) {
            List<StockActuel> stockList = stockService.getAllCurrentStock();
            model.addAttribute("stockList", stockList);

            return "dashboard"; 
        } else {
            return "operateur";
        }
    }


    @GetMapping("/articles")
    public String listArticles(HttpSession session, Model model) {
        Utilisateur user = (Utilisateur) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login_stock"; // redirect to login if not logged in
        }

        // Fetch stock list
        List<StockActuel> stockList = stockService.getAllCurrentStock();
        model.addAttribute("stockList", stockList);

        return "dashboard"; 
    }

}

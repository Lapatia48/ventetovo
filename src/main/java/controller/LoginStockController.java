package controller;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import entity.Utilisateur;
import service.AuthServiceStock;

@Controller
public class LoginStockController {
    
    private final AuthServiceStock authService;

    public LoginStockController(AuthServiceStock authService) {
        this.authService = authService;
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
        return "dashboard";
    }

}

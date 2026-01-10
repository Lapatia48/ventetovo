package controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.ui.Model;
import service.UtilisateurService;
import entity.Utilisateur;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.Optional;

@Controller
@RequestMapping("/user")
public class UtilisateurController {

    @Autowired
    private UtilisateurService utilisateurService;

    @GetMapping("/login")
    public String login(){
        return "user/login";
    }

    @PostMapping("/logRh")
    public String login(@RequestParam("email") String email,
                        @RequestParam("motDePasse") String motDePasse,
                        Model model) {
        Optional<Utilisateur> userOpt = utilisateurService.findByEmail(email);
        if (userOpt.isPresent()) {
            Utilisateur user = userOpt.get();
            if (user.getActif() != null && user.getActif() && user.getMotDePasse().equals(motDePasse)) {
                // Login successful
                return "redirect:/user/accueil";
            }
        }
        model.addAttribute("error", "Email ou mot de passe incorrect, ou utilisateur inactif.");
        return "user/login";
    }

    @GetMapping("/accueil")
    public String accueil() {
        return "user/accueil";
    }
}

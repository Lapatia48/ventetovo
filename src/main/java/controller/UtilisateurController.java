package controller;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import entity.Utilisateur;
import jakarta.servlet.http.HttpSession;
import service.ArticleService;
import service.UtilisateurService;

@Controller
public class UtilisateurController {

    @Autowired
    private UtilisateurService utilisateurService;

    @Autowired
    private ArticleService articleService;

    @GetMapping("/user/accueil")
    public String accueil(){
        return "accueil";
    }

    @GetMapping("/user/login")
    public String login(@RequestParam("id") int id, Model model){
        List<String> emails = utilisateurService.findByActifTrue().stream()
                .map(Utilisateur::getEmail)
                .collect(Collectors.toList());
        model.addAttribute("emails", emails);
        model.addAttribute("id", id);
        return "user/login";
    }

    @PostMapping("/user/login")
    public String login(@RequestParam("email") String email,
                        @RequestParam("motDePasse") String motDePasse,
                        @RequestParam("id") int id,
                        Model model,
                        HttpSession session) {
        Optional<Utilisateur> userOpt = utilisateurService.findByEmail(email);
        if (userOpt.isPresent()) {
            Utilisateur user = userOpt.get();
            if (user.getActif() != null && user.getActif() && user.getMotDePasse().equals(motDePasse) && id==0) {
                // Login successful
                session.setAttribute("utilisateur", user);
                return "redirect:/achat/achat";
            }

            if (user.getActif() != null && user.getActif() && user.getMotDePasse().equals(motDePasse) && id==1) {
                // Login successful
                session.setAttribute("utilisateur", user);
                return "redirect:/vente/accueil";
            }
        }
        model.addAttribute("error", "Email ou mot de passe incorrect, ou utilisateur inactif.");
        return "user/login";
    }

    @GetMapping("/user/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "accueil";
    }



   
}

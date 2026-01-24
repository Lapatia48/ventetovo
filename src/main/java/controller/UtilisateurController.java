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
import entity.VUtilisateurRole;
import jakarta.servlet.http.HttpSession;
import repository.VUtilisateurRoleRepository;
import service.ArticleService;
import service.UtilisateurService;

@Controller
public class UtilisateurController {

    @Autowired
    private UtilisateurService utilisateurService;

    @Autowired
    private ArticleService articleService;

    @Autowired
    private VUtilisateurRoleRepository vUtilisateurRoleRepository;

    @GetMapping("/user/accueil")
    public String accueil() {
        return "accueil";
    }

    @GetMapping("/user/login")
    public String showLogin(@RequestParam("id") int id, Model model) {

        List<String> emails = utilisateurService.findByActifTrue()
                .stream()
                .map(Utilisateur::getEmail)
                .collect(Collectors.toList());

        model.addAttribute("emails", emails);
        model.addAttribute("id", id);

        return "user/login";
    }

    @PostMapping("/user/login")
    public String login(@RequestParam String email,
                        @RequestParam String motDePasse,
                        @RequestParam int id,
                        Model model,
                        HttpSession session) {

        Optional<VUtilisateurRole> opt =
                vUtilisateurRoleRepository.findByEmail(email);

        if (opt.isEmpty()) {
            model.addAttribute("error", "Utilisateur introuvable");
            return "user/login";
        }

        VUtilisateurRole user = opt.get();

        if (!Boolean.TRUE.equals(user.getActif()) ||
            !user.getMotDePasse().equals(motDePasse)) {
            model.addAttribute("error", "Identifiants incorrects");
            return "user/login";
        }

        session.setAttribute("utilisateur", user);

        if (id == 0) return "redirect:/achat/achat";
        if (id == 1) return "redirect:/vente/accueil";

        return "user/login";
    }


    @GetMapping("/user/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "accueil";
    }
}

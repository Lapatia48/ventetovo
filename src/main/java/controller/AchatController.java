package controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import service.ArticleService;
import service.ProformaService;
import java.util.List;

@Controller
public class AchatController {

    @Autowired
    private ArticleService articleService;
    
    @Autowired
    private ProformaService proformaService;

    @GetMapping("/achat/achat")
    public String achat(Model model) {
        model.addAttribute("articles", articleService.findAll());
        model.addAttribute("bob", "bob");
        return "achat/achat";
    }

    @GetMapping("/achat/quantite")
    public String commande(@RequestParam("idArticle") Integer idArticle, Model model) {
        model.addAttribute("idArticle", idArticle);
        // Récupérer l'article pour afficher ses informations
        articleService.findById(idArticle).ifPresent(article -> {
            model.addAttribute("article", article);
        });
        return "achat/quantite";
    }

    @PostMapping("/achat/quantite")
    public String quantite(@RequestParam("idArticle") Integer idArticle, 
                          @RequestParam("quantite") Integer quantite,
                          Model model) {
        
        // Créer les proformas pour cette demande
        List<entity.Proforma> proformas = proformaService.creerProformasPourDemande(idArticle, quantite);
        
        if (!proformas.isEmpty()) {
            // Récupérer le token de la première proforma (toutes ont le même token)
            String tokenDemande = proformas.get(0).getTokenDemande();
            
            // Ajouter les informations au modèle
            model.addAttribute("proformas", proformas);
            model.addAttribute("tokenDemande", tokenDemande);
            model.addAttribute("idArticle", idArticle);
            model.addAttribute("quantite", quantite);
            
            // Récupérer l'article pour afficher ses informations
            articleService.findById(idArticle).ifPresent(article -> {
                model.addAttribute("article", article);
            });
            
            return "achat/proformas";
        } else {
            model.addAttribute("error", "Aucun prix disponible pour cet article.");
            return "achat/quantite";
        }
    }
    
    @GetMapping("/achat/proformas")
    public String listeProformas(@RequestParam("token") String tokenDemande, Model model) {
        List<entity.Proforma> proformas = proformaService.getProformasByToken(tokenDemande);
        model.addAttribute("proformas", proformas);
        model.addAttribute("tokenDemande", tokenDemande);
        
        if (!proformas.isEmpty()) {
            model.addAttribute("idArticle", proformas.get(0).getIdArticle());
            model.addAttribute("quantite", proformas.get(0).getQuantite());
        }
        
        return "achat/proformas";
    }
    
    @PostMapping("/achat/selectionner")
    public String selectionnerProforma(@RequestParam("idProforma") Integer idProforma,
                                      @RequestParam("tokenDemande") String tokenDemande) {
        proformaService.selectionnerProforma(idProforma);
        return "redirect:/achat/proformas?token=" + tokenDemande;
    }
    
    @GetMapping("/achat/demandes")
    public String listeDemandes(Model model) {
        model.addAttribute("demandes", proformaService.getAllDemandes());
        return "achat/demandes";
    }
}
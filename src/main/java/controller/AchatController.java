package controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import entity.Proforma;
import entity.Utilisateur;
import jakarta.servlet.http.HttpSession;
import service.AchatFinanceService;
import service.ArticleService;
import service.ProformaService;

@Controller
public class AchatController {

    @Autowired
    private ArticleService articleService;
    
    @Autowired
    private ProformaService proformaService;

    @Autowired
    private AchatFinanceService achatFinanceService;

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
                                      @RequestParam("tokenDemande") String tokenDemande,
                                      Model model) {
        
        // Récupérer la proforma sélectionnée
        Optional<Proforma> proformaOpt = proformaService.findById(idProforma);
        
        if (proformaOpt.isPresent()) {
            Proforma proforma = proformaOpt.get();
            
            // Récupérer le montant seuil actif
            Double montantSeuil = achatFinanceService.getMontantSeuilActif();
            Double montantProforma = proforma.getMontantTotal();
            
            // Déterminer le statut (validation requise ou non)
            boolean validationRequise = montantProforma > montantSeuil;
            
            // Ajouter les informations au modèle
            model.addAttribute("idProforma", idProforma);
            model.addAttribute("tokenDemande", tokenDemande);
            model.addAttribute("proforma", proforma);
            model.addAttribute("montantProforma", montantProforma);
            model.addAttribute("montantSeuil", montantSeuil);
            model.addAttribute("validationRequise", validationRequise);
            model.addAttribute("ecart", montantProforma - montantSeuil);
            
            return "achat/finance";
        } else {
            model.addAttribute("error", "Proforma introuvable.");
            return "redirect:/achat/proformas?token=" + tokenDemande;
        }
    }

    @PostMapping("/achat/validerProforma")
    public String validerProforma(@RequestParam("idProforma") Integer idProforma,
                                @RequestParam("tokenDemande") String tokenDemande,
                                @RequestParam(value = "confirmation", required = false) String confirmation,
                                @RequestParam("emailAutorise") String emailAutorise,
                                HttpSession session,
                                Model model) {
        
        // Vérifier si l'utilisateur est connecté
        Utilisateur utilisateurConnecte = (Utilisateur) session.getAttribute("utilisateur");
        if (utilisateurConnecte == null) {
            model.addAttribute("error", "Vous devez être connecté pour valider une proforma.");
            return "redirect:/user/login";
        }
        
        // Vérifier la confirmation
        if (!"oui".equalsIgnoreCase(confirmation)) {
            model.addAttribute("error", "Confirmation requise pour valider la proforma.");
            return selectionnerProforma(idProforma, tokenDemande, model);
        }
        
        // Vérifier si l'utilisateur a le droit de valider
        if (!utilisateurConnecte.getEmail().equals(emailAutorise)) {
            model.addAttribute("error", 
                "Vous n'avez pas les droits nécessaires pour valider cette proforma. " +
                "Email requis: " + emailAutorise);
            return selectionnerProforma(idProforma, tokenDemande, model);
        }
        
        // Valider la proforma
        proformaService.selectionnerProforma(idProforma);
        
        // Ajouter un message de succès
        model.addAttribute("success", "Proforma validée avec succès !");
        
        return "redirect:/achat/proformas?token=" + tokenDemande;
    }

    @GetMapping("/achat/demandes")
    public String listeDemandes(Model model) {
        model.addAttribute("demandes", proformaService.getAllDemandes());
        return "achat/demandes";
    }
}
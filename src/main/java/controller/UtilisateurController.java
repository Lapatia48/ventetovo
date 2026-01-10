package controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.ui.Model;
import service.ArticleService;
import service.UtilisateurService;
import service.CaisseService;
import service.StockService;
import service.DepotService;
import entity.Article;
import entity.Utilisateur;
import entity.Caisse;
import entity.Stock;
import entity.Depot;
import org.springframework.beans.factory.annotation.Autowired;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.math.BigDecimal;

@Controller
@RequestMapping("/user")
public class UtilisateurController {

    @Autowired
    private UtilisateurService utilisateurService;

    @Autowired
    private ArticleService articleService;

    @Autowired
    private CaisseService caisseService;

    @Autowired
    private StockService stockService;

    @Autowired
    private DepotService depotService;

    @GetMapping("/login")
    public String login(Model model){
        List<String> emails = utilisateurService.findByActifTrue().stream()
                .map(Utilisateur::getEmail)
                .collect(Collectors.toList());
        model.addAttribute("emails", emails);
        return "user/login";
    }

    @PostMapping("/login")
    public String login(@RequestParam("email") String email,
                        @RequestParam("motDePasse") String motDePasse,
                        Model model) {
        Optional<Utilisateur> userOpt = utilisateurService.findByEmail(email);
        if (userOpt.isPresent()) {
            Utilisateur user = userOpt.get();
            if (user.getActif() != null && user.getActif() && user.getMotDePasse().equals(motDePasse)) {
                // Login successful
                return "redirect:/user/listProduits";
            }
        }
        model.addAttribute("error", "Email ou mot de passe incorrect, ou utilisateur inactif.");
        return "user/login";
    }

    @GetMapping("/listProduits")
    public String listProduits(@RequestParam(value = "search", required = false) String search,
                               @RequestParam(value = "minPrice", required = false) BigDecimal minPrice,
                               @RequestParam(value = "maxPrice", required = false) BigDecimal maxPrice,
                               @RequestParam(value = "seuilFilter", required = false) String seuilFilter,
                               Model model) {
        List<Article> allArticles = articleService.findAll();
        
        // Appliquer les filtres
        List<Article> filteredArticles = allArticles.stream()
            .filter(article -> {
                // Filtre recherche générale
                if (search != null && !search.trim().isEmpty()) {
                    String searchLower = search.toLowerCase();
                    boolean matchesCode = article.getCode() != null && article.getCode().toLowerCase().contains(searchLower);
                    boolean matchesDesignation = article.getDesignation() != null && article.getDesignation().toLowerCase().contains(searchLower);
                    if (!matchesCode && !matchesDesignation) {
                        return false;
                    }
                }
                
                // Filtre prix min
                if (minPrice != null && article.getPrixVente() != null && article.getPrixVente().compareTo(minPrice) < 0) {
                    return false;
                }
                
                // Filtre prix max
                if (maxPrice != null && article.getPrixVente() != null && article.getPrixVente().compareTo(maxPrice) > 0) {
                    return false;
                }
                
                // Filtre seuil d'alerte
                if (seuilFilter != null && !seuilFilter.trim().isEmpty()) {
                    if ("low".equals(seuilFilter) && article.getSeuilAlerte() >= 10) {
                        return false;
                    }
                    if ("normal".equals(seuilFilter) && article.getSeuilAlerte() < 10) {
                        return false;
                    }
                }
                
                return true;
            })
            .collect(Collectors.toList());
        
        // Calculer les statistiques
        int totalProducts = allArticles.size();
        long lowStockProducts = allArticles.stream()
            .filter(article -> article.getSeuilAlerte() < 10)
            .count();
        double avgPrice = allArticles.stream()
            .filter(article -> article.getPrixVente() != null)
            .mapToDouble(article -> article.getPrixVente().doubleValue())
            .average()
            .orElse(0.0);
        int filteredCount = filteredArticles.size();
        
        // Ajouter au modèle
        model.addAttribute("articles", filteredArticles);
        model.addAttribute("totalProducts", totalProducts);
        model.addAttribute("lowStockProducts", (int) lowStockProducts);
        model.addAttribute("avgPrice", String.format("%.2f", avgPrice));
        model.addAttribute("filteredCount", filteredCount);
        model.addAttribute("lastUpdate", java.time.LocalDateTime.now().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")));
        
        return "user/accueil";
    }

    @PostMapping("/achat/{id}")
    public String achat(@PathVariable Long id) {
        Optional<Article> articleOpt = articleService.findById(id);
        if (articleOpt.isPresent()) {
            Article article = articleOpt.get();
            // Dépôt principal par défaut
            Optional<Depot> depotOpt = depotService.findByNom("Depot Principal");
            if (depotOpt.isPresent()) {
                Depot depot = depotOpt.get();
                // +1 en stock
                stockService.ajusterStock(article, depot, 1);
                // - prixAchat en caisse
                caisseService.soustraireDuSolde(article.getPrixAchat());
            }
        }
        return "redirect:/user/listProduits";
    }

    @PostMapping("/vente/{id}")
    public String vente(@PathVariable Long id) {
        Optional<Article> articleOpt = articleService.findById(id);
        if (articleOpt.isPresent()) {
            Article article = articleOpt.get();
            // Dépôt principal par défaut
            Optional<Depot> depotOpt = depotService.findByNom("Depot Principal");
            if (depotOpt.isPresent()) {
                Depot depot = depotOpt.get();
                // Vérifier si stock disponible
                Optional<Stock> stockOpt = stockService.findByArticleAndDepot(article, depot);
                if (stockOpt.isPresent() && stockOpt.get().getQuantite() > 0) {
                    // -1 en stock
                    stockService.ajusterStock(article, depot, -1);
                    // + prixVente en caisse
                    caisseService.ajouterAuSolde(article.getPrixVente());
                }
            }
        }
        return "redirect:/user/listProduits";
    }
}

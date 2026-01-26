package controller;

import entity.*;
import service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/gestionstock")
public class GestionStockController {
    
    @Autowired
    private StockService stockService;
    
    @Autowired
    private ArticleService articleService;
    
    @Autowired
    private MouvementStockService mouvementStockService;
    
    @Autowired
    private LotService lotService;
    
    @Autowired
    private ConfigValorisationArticleService configValorisationArticleService;
    
    /**
     * Tableau de bord de gestion de stock
     */
    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        // Stock total
        List<Stock> stocks = stockService.findAll();
        double valeurStockTotal = stocks.stream()
            .mapToDouble(s -> s.getValeurStock() != null ? s.getValeurStock() : 0.0)
            .sum();
        
        // Alertes stock faible
        List<Stock> stocksFaibles = stocks.stream()
            .filter(s -> s.getQuantiteDisponible() <= s.getStockMinimum())
            .collect(Collectors.toList());
        
        // Alertes péremption (30 jours)
        List<Lot> lotsProchesPeremption = lotService.getLotsProchesPeremption(30);
        
        // Bloquer automatiquement les lots expirés
        lotService.bloquerLotsExpires();
        
        // Mouvements du jour
        LocalDateTime debutJour = LocalDate.now().atStartOfDay();
        LocalDateTime finJour = LocalDate.now().atTime(23, 59, 59);
        List<MouvementStock> mouvementsJour = mouvementStockService.findByPeriode(debutJour, finJour);
        
        model.addAttribute("valeurStockTotal", valeurStockTotal);
        model.addAttribute("nombreArticles", stocks.size());
        model.addAttribute("stocksFaibles", stocksFaibles);
        model.addAttribute("lotsProchesPeremption", lotsProchesPeremption);
        model.addAttribute("mouvementsJour", mouvementsJour);
        
        return "gestionstock/dashboard";
    }
    
    /**
     * Liste des stocks avec filtres
     */
    @GetMapping("/stocks")
    public String listeStocks(@RequestParam(required = false) String recherche,
                              @RequestParam(required = false) String filtre,
                              Model model) {
        List<Stock> stocks = stockService.findAll();
        
        // Filtrer selon les critères
        if ("faible".equals(filtre)) {
            stocks = stocks.stream()
                .filter(s -> s.getQuantiteDisponible() <= s.getStockMinimum())
                .collect(Collectors.toList());
        } else if ("critique".equals(filtre)) {
            stocks = stocks.stream()
                .filter(s -> s.getQuantiteDisponible() == 0)
                .collect(Collectors.toList());
        }
        
        // Enrichir avec les informations articles
        Map<Integer, Article> articlesMap = new HashMap<>();
        for (Stock stock : stocks) {
            articleService.findById(stock.getIdArticle())
                .ifPresent(a -> articlesMap.put(a.getIdArticle(), a));
        }
        
        model.addAttribute("stocks", stocks);
        model.addAttribute("articlesMap", articlesMap);
        model.addAttribute("filtreActif", filtre);
        
        return "gestionstock/stocks";
    }
    
    /**
     * Détail d'un stock avec historique
     */
    @GetMapping("/stocks/{id}")
    public String detailStock(@PathVariable Integer id,
                              @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateDebut,
                              @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateFin,
                              Model model) {
        Stock stock = stockService.findById(id)
            .orElseThrow(() -> new RuntimeException("Stock non trouvé"));
        
        Article article = articleService.findById(stock.getIdArticle())
            .orElseThrow(() -> new RuntimeException("Article non trouvé"));
        
        // Dates par défaut (30 derniers jours)
        if (dateDebut == null) dateDebut = LocalDate.now().minusDays(30);
        if (dateFin == null) dateFin = LocalDate.now();
        
        // Historique des mouvements
        List<MouvementStock> mouvements = mouvementStockService.getHistoriqueMouvements(
            article.getIdArticle(), dateDebut, dateFin);
        
        // Lots actifs
        List<Lot> lots = lotService.findLotsActifsParArticle(article.getIdArticle());
        
        // Configuration valorisation
        Optional<ConfigValorisationArticle> config = 
            configValorisationArticleService.findByIdArticle(article.getIdArticle());
        
        model.addAttribute("stock", stock);
        model.addAttribute("article", article);
        model.addAttribute("mouvements", mouvements);
        model.addAttribute("lots", lots);
        model.addAttribute("config", config.orElse(null));
        model.addAttribute("dateDebut", dateDebut);
        model.addAttribute("dateFin", dateFin);
        
        return "gestionstock/stock-detail";
    }
    
    /**
     * Liste des mouvements avec filtres
     */
    @GetMapping("/mouvements")
    public String listeMouvements(@RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateDebut,
                                   @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateFin,
                                   @RequestParam(required = false) Integer idArticle,
                                   Model model) {
        // Dates par défaut (mois en cours)
        if (dateDebut == null) dateDebut = LocalDate.now().withDayOfMonth(1);
        if (dateFin == null) dateFin = LocalDate.now();
        
        LocalDateTime debut = dateDebut.atStartOfDay();
        LocalDateTime fin = dateFin.atTime(23, 59, 59);
        
        List<MouvementStock> mouvements;
        if (idArticle != null) {
            mouvements = mouvementStockService.getHistoriqueMouvements(idArticle, dateDebut, dateFin);
        } else {
            mouvements = mouvementStockService.findByPeriode(debut, fin);
        }
        
        // Charger tous les articles pour l'affichage
        List<Article> articles = articleService.findAll();
        Map<Integer, Article> articlesMap = articles.stream()
            .collect(Collectors.toMap(Article::getIdArticle, a -> a));
        
        model.addAttribute("mouvements", mouvements);
        model.addAttribute("articlesMap", articlesMap);
        model.addAttribute("articles", articles);
        model.addAttribute("dateDebut", dateDebut);
        model.addAttribute("dateFin", dateFin);
        model.addAttribute("idArticleFiltre", idArticle);
        
        return "gestionstock/mouvements";
    }
    
    /**
     * Liste des lots
     */
    @GetMapping("/lots")
    public String listeLots(@RequestParam(required = false) Integer idArticle,
                           @RequestParam(required = false) String statut,
                           Model model) {
        List<Lot> lots;
        if (idArticle != null) {
            if (statut != null && !statut.isEmpty()) {
                lots = lotService.findByIdArticle(idArticle).stream()
                    .filter(l -> statut.equals(l.getStatut()))
                    .collect(Collectors.toList());
            } else {
                lots = lotService.findByIdArticle(idArticle);
            }
        } else {
            lots = lotService.findAll();
            if (statut != null && !statut.isEmpty()) {
                lots = lots.stream()
                    .filter(l -> statut.equals(l.getStatut()))
                    .collect(Collectors.toList());
            }
        }
        
        // Charger tous les articles
        List<Article> articles = articleService.findAll();
        Map<Integer, Article> articlesMap = articles.stream()
            .collect(Collectors.toMap(Article::getIdArticle, a -> a));
        
        // Alertes péremption
        List<Lot> lotsAlertes = lotService.getLotsProchesPeremption(30);
        
        model.addAttribute("lots", lots);
        model.addAttribute("articlesMap", articlesMap);
        model.addAttribute("articles", articles);
        model.addAttribute("lotsAlertes", lotsAlertes);
        model.addAttribute("idArticleFiltre", idArticle);
        model.addAttribute("statutFiltre", statut);
        
        return "gestionstock/lots";
    }
    
    /**
     * Bloquer un lot
     */
    @PostMapping("/lots/{id}/bloquer")
    @ResponseBody
    public Map<String, Object> bloquerLot(@PathVariable Integer id,
                                          @RequestParam String raison) {
        Map<String, Object> response = new HashMap<>();
        try {
            lotService.bloquerLot(id, raison);
            response.put("success", true);
            response.put("message", "Lot bloqué avec succès");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
        }
        return response;
    }
    
    /**
     * Configuration des méthodes de valorisation
     */
    @GetMapping("/configuration")
    public String configuration(Model model) {
        List<Article> articles = articleService.findAll();
        List<ConfigValorisationArticle> configs = configValorisationArticleService.findAll();
        
        Map<Integer, ConfigValorisationArticle> configsMap = configs.stream()
            .collect(Collectors.toMap(ConfigValorisationArticle::getIdArticle, c -> c));
        
        model.addAttribute("articles", articles);
        model.addAttribute("configsMap", configsMap);
        
        return "gestionstock/configuration";
    }
    
    /**
     * Sauvegarder la configuration d'un article
     */
    @PostMapping("/configuration/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> sauvegarderConfiguration(@RequestParam Integer idArticle,
                                                         @RequestParam String methodeValorisation,
                                                         @RequestParam Boolean gestionLot,
                                                         @RequestParam(required = false) String typePeremption,
                                                         @RequestParam(required = false) Integer delaiAlerte) {
        Map<String, Object> response = new HashMap<>();
        try {
            configValorisationArticleService.creerOuMettreAJourConfig(
                idArticle, methodeValorisation, gestionLot, typePeremption, delaiAlerte);
            
            response.put("success", true);
            response.put("message", "Configuration enregistrée");
            return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_JSON)
                .body(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest()
                .contentType(MediaType.APPLICATION_JSON)
                .body(response);
        }
    }
    
    /**
     * Rapport: Chiffre d'affaires par article
     */
    @GetMapping("/rapports/chiffre-affaires")
    public String rapportChiffreAffaires(@RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateDebut,
                                         @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateFin,
                                         Model model) {
        // Dates par défaut (mois en cours)
        if (dateDebut == null) dateDebut = LocalDate.now().withDayOfMonth(1);
        if (dateFin == null) dateFin = LocalDate.now();
        
        LocalDateTime debut = dateDebut.atStartOfDay();
        LocalDateTime fin = dateFin.atTime(23, 59, 59);
        
        // Récupérer tous les mouvements de sortie (livraisons clients)
        List<MouvementStock> sorties = mouvementStockService.findByPeriode(debut, fin).stream()
            .filter(m -> m.getIdTypeMouvement() == 5) // LIV_CLIENT
            .collect(Collectors.toList());
        
        // Grouper par article et calculer le CA
        Map<Integer, Double> caParArticle = new HashMap<>();
        Map<Integer, Integer> quantitesParArticle = new HashMap<>();
        
        for (MouvementStock mouvement : sorties) {
            Integer idArticle = mouvement.getIdArticle();
            Double ca = caParArticle.getOrDefault(idArticle, 0.0);
            caParArticle.put(idArticle, ca + mouvement.getCoutTotal().doubleValue());
            
            Integer quantite = quantitesParArticle.getOrDefault(idArticle, 0);
            quantitesParArticle.put(idArticle, quantite + mouvement.getQuantite());
        }
        
        // Charger les articles
        Map<Integer, Article> articlesMap = new HashMap<>();
        for (Integer idArticle : caParArticle.keySet()) {
            articleService.findById(idArticle)
                .ifPresent(a -> articlesMap.put(idArticle, a));
        }
        
        // Calculer le CA total
        double caTotal = caParArticle.values().stream().mapToDouble(Double::doubleValue).sum();
        
        model.addAttribute("caParArticle", caParArticle);
        model.addAttribute("quantitesParArticle", quantitesParArticle);
        model.addAttribute("articlesMap", articlesMap);
        model.addAttribute("caTotal", caTotal);
        model.addAttribute("dateDebut", dateDebut);
        model.addAttribute("dateFin", dateFin);
        
        return "gestionstock/rapport-ca";
    }
    
    /**
     * Rapport: Valorisation du stock
     */
    @GetMapping("/rapports/valorisation")
    public String rapportValorisation(Model model) {
        List<Stock> stocks = stockService.findAll();
        
        // Grouper par méthode de valorisation
        Map<String, List<Stock>> stocksParMethode = new HashMap<>();
        Map<String, Double> valeurParMethode = new HashMap<>();
        
        for (Stock stock : stocks) {
            Optional<ConfigValorisationArticle> configOpt = 
                configValorisationArticleService.findByIdArticle(stock.getIdArticle());
            
            String methode = configOpt.map(ConfigValorisationArticle::getMethodeValorisation)
                .orElse("CMUP");
            
            stocksParMethode.computeIfAbsent(methode, k -> new ArrayList<>()).add(stock);
            
            double valeur = valeurParMethode.getOrDefault(methode, 0.0);
            valeur += stock.getValeurStock() != null ? stock.getValeurStock() : 0.0;
            valeurParMethode.put(methode, valeur);
        }
        
        double valeurTotale = stocks.stream()
            .mapToDouble(s -> s.getValeurStock() != null ? s.getValeurStock() : 0.0)
            .sum();
        
        // Charger tous les articles
        Map<Integer, Article> articlesMap = new HashMap<>();
        for (Stock stock : stocks) {
            articleService.findById(stock.getIdArticle())
                .ifPresent(a -> articlesMap.put(a.getIdArticle(), a));
        }
        
        model.addAttribute("stocksParMethode", stocksParMethode);
        model.addAttribute("valeurParMethode", valeurParMethode);
        model.addAttribute("valeurTotale", valeurTotale);
        model.addAttribute("articlesMap", articlesMap);
        
        return "gestionstock/rapport-valorisation";
    }
}

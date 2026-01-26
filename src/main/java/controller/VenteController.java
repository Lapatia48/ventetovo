package controller;

import entity.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import service.*;

import java.util.List;
import java.util.Optional;

@Controller
public class VenteController {

    @Autowired
    private ClientService clientService;

    @Autowired
    private ArticleService articleService;

    @Autowired
    private ProformaClientService proformaClientService;

    @Autowired
    private BonCommandeClientService bonCommandeClientService;

    @Autowired
    private FactureClientService factureClientService;

    @Autowired
    private BonLivraisonClientService bonLivraisonClientService;

    @Autowired
    private StockService stockService;

    @Autowired
    private ReductionService reductionService;

    // Page d'accueil du module vente - Liste des articles
    @GetMapping("/vente/vente")
    public String vente(Model model) {
        model.addAttribute("articles", articleService.findAll());
        model.addAttribute("clients", clientService.findByActif(true));
        return "vente/vente";
    }

    // Formulaire de création de proforma client
    @GetMapping("/vente/proforma/form")
    public String formulaireProforma(@RequestParam("idArticle") Integer idArticle, Model model) {
        model.addAttribute("idArticle", idArticle);
        
        articleService.findById(idArticle).ifPresent(article -> {
            model.addAttribute("article", article);
        });
        
        // Récupérer le stock disponible
        stockService.findByIdArticle(idArticle).ifPresent(stock -> {
            model.addAttribute("stock", stock);
            model.addAttribute("stockDisponible", stock.getQuantiteReellementDisponible());
        });
        
        model.addAttribute("clients", clientService.findByActif(true));
        model.addAttribute("reductions", reductionService.findReductionsValides());
        
        return "vente/proforma-client-form";
    }

    // Créer une proforma client
    @PostMapping("/vente/proforma/creer")
    public String creerProformaClient(@RequestParam("idClient") Integer idClient,
                                     @RequestParam("idArticle") Integer idArticle,
                                     @RequestParam("quantite") Integer quantite,
                                     @RequestParam(value = "codeReduction", required = false) String codeReduction,
                                     HttpSession session,
                                     Model model) {
        
        Utilisateur utilisateurConnecte = (Utilisateur) session.getAttribute("utilisateur");
        if (utilisateurConnecte == null) {
            model.addAttribute("error", "Vous devez être connecté.");
            return "redirect:/user/login";
        }
        
        // Vérifier le stock disponible
        boolean stockDisponible = stockService.verifierDisponibilite(idArticle, quantite);
        if (!stockDisponible) {
            model.addAttribute("error", "Stock insuffisant pour la quantité demandée.");
            return "redirect:/vente/proforma/form?idArticle=" + idArticle;
        }
        
        // Créer la proforma
        ProformaClient proforma = proformaClientService.creerProformaClient(idClient, idArticle, quantite, codeReduction);
        
        model.addAttribute("success", "Proforma créée: " + proforma.getNumeroProforma());
        return "redirect:/vente/proforma/detail/" + proforma.getIdProformaClient();
    }

    // Liste des proformas clients
    @GetMapping("/vente/proforma/list")
    public String listeProformasClients(@RequestParam(value = "statut", required = false) String statut, Model model) {
        List<ProformaClient> proformas;
        
        if (statut != null && !statut.isEmpty()) {
            proformas = proformaClientService.findByStatut(statut);
        } else {
            proformas = proformaClientService.findAll();
        }
        
        model.addAttribute("proformas", proformas);
        model.addAttribute("statutFiltre", statut);
        
        return "vente/proforma-client-liste";
    }

    // Détail d'une proforma client
    @GetMapping("/vente/proforma/detail/{id}")
    public String detailProformaClient(@PathVariable("id") Integer idProformaClient, Model model) {
        Optional<ProformaClient> proformaOpt = proformaClientService.findById(idProformaClient);
        
        if (proformaOpt.isPresent()) {
            ProformaClient proforma = proformaOpt.get();
            model.addAttribute("proforma", proforma);
            
            // Récupérer les infos du client et de l'article
            clientService.findById(proforma.getIdClient()).ifPresent(client -> 
                model.addAttribute("client", client));
            articleService.findById(proforma.getIdArticle()).ifPresent(article -> 
                model.addAttribute("article", article));
            
            // Vérifier le stock
            stockService.findByIdArticle(proforma.getIdArticle()).ifPresent(stock -> {
                model.addAttribute("stock", stock);
                model.addAttribute("stockDisponible", stock.getQuantiteReellementDisponible());
            });
            
            return "vente/proforma-client-detail";
        } else {
            model.addAttribute("error", "Proforma non trouvée.");
            return "redirect:/vente/proforma/list";
        }
    }

    // Accepter une proforma client
    @PostMapping("/vente/proforma/accepter")
    public String accepterProformaClient(@RequestParam("idProformaClient") Integer idProformaClient,
                                        HttpSession session,
                                        Model model) {
        
        Utilisateur utilisateurConnecte = (Utilisateur) session.getAttribute("utilisateur");
        if (utilisateurConnecte == null) {
            model.addAttribute("error", "Vous devez être connecté.");
            return "redirect:/user/login";
        }
        
        try {
            proformaClientService.accepterProforma(idProformaClient);
            
            // Créer automatiquement le bon de commande
            BonCommandeClient bonCommande = bonCommandeClientService.creerBonCommandeFromProforma(idProformaClient);
            
            model.addAttribute("success", "Proforma acceptée et bon de commande créé: " + bonCommande.getNumeroBcClient());
            return "redirect:/vente/bc/detail/" + bonCommande.getIdBonCommandeClient();
        } catch (Exception e) {
            model.addAttribute("error", "Erreur: " + e.getMessage());
            return "redirect:/vente/proforma/detail/" + idProformaClient;
        }
    }

    // Liste des bons de commande clients
    @GetMapping("/vente/bc/list")
    public String listeBonCommandesClients(Model model) {
        List<BonCommandeClient> bonsCommande = bonCommandeClientService.findAll();
        model.addAttribute("bonsCommande", bonsCommande);
        return "vente/bc-client-liste";
    }

    // Détail d'un bon de commande client
    @GetMapping("/vente/bc/detail/{id}")
    public String detailBonCommandeClient(@PathVariable("id") Integer idBonCommandeClient, Model model) {
        Optional<BonCommandeClient> bonCommandeOpt = bonCommandeClientService.findById(idBonCommandeClient);
        
        if (bonCommandeOpt.isPresent()) {
            BonCommandeClient bonCommande = bonCommandeOpt.get();
            model.addAttribute("bonCommande", bonCommande);
            
            // Récupérer les infos du client et de l'article
            clientService.findById(bonCommande.getIdClient()).ifPresent(client -> 
                model.addAttribute("client", client));
            articleService.findById(bonCommande.getIdArticle()).ifPresent(article -> 
                model.addAttribute("article", article));
            
            // Vérifier le stock
            stockService.findByIdArticle(bonCommande.getIdArticle()).ifPresent(stock -> {
                model.addAttribute("stock", stock);
                model.addAttribute("stockDisponible", stock.getQuantiteReellementDisponible());
            });
            
            return "vente/bc-client-detail";
        } else {
            model.addAttribute("error", "Bon de commande non trouvé.");
            return "redirect:/vente/bc/list";
        }
    }

    // Vérifier le stock pour un bon de commande
    @PostMapping("/vente/bc/verifier-stock")
    public String verifierStockBonCommande(@RequestParam("idBonCommandeClient") Integer idBonCommandeClient,
                                          HttpSession session,
                                          Model model) {
        
        Utilisateur utilisateurConnecte = (Utilisateur) session.getAttribute("utilisateur");
        if (utilisateurConnecte == null) {
            model.addAttribute("error", "Vous devez être connecté.");
            return "redirect:/user/login";
        }
        
        try {
            bonCommandeClientService.verifierStock(idBonCommandeClient);
            model.addAttribute("success", "Stock vérifié et réservé avec succès.");
        } catch (Exception e) {
            model.addAttribute("error", "Erreur: " + e.getMessage());
        }
        
        return "redirect:/vente/bc/detail/" + idBonCommandeClient;
    }

    // Créer une facture à partir d'un bon de commande
    @PostMapping("/vente/facture/creer")
    public String creerFactureClient(@RequestParam("idBonCommandeClient") Integer idBonCommandeClient,
                                    HttpSession session,
                                    Model model) {
        
        Utilisateur utilisateurConnecte = (Utilisateur) session.getAttribute("utilisateur");
        if (utilisateurConnecte == null) {
            model.addAttribute("error", "Vous devez être connecté.");
            return "redirect:/user/login";
        }
        
        try {
            FactureClient facture = factureClientService.creerFactureFromBonCommande(idBonCommandeClient);
            model.addAttribute("success", "Facture créée: " + facture.getNumeroFactureClient());
            return "redirect:/vente/facture/detail/" + facture.getIdFactureClient();
        } catch (Exception e) {
            model.addAttribute("error", "Erreur: " + e.getMessage());
            return "redirect:/vente/bc/detail/" + idBonCommandeClient;
        }
    }

    // Liste des factures clients
    @GetMapping("/vente/facture/list")
    public String listeFacturesClients(@RequestParam(value = "statut", required = false) String statut, Model model) {
        List<FactureClient> factures;
        
        if (statut != null && !statut.isEmpty()) {
            factures = factureClientService.findByStatutPaiement(statut);
        } else {
            factures = factureClientService.findAll();
        }
        
        model.addAttribute("factures", factures);
        model.addAttribute("statutFiltre", statut);
        
        return "vente/facture-client-liste";
    }

    // Détail d'une facture client
    @GetMapping("/vente/facture/detail/{id}")
    public String detailFactureClient(@PathVariable("id") Integer idFactureClient, Model model) {
        Optional<FactureClient> factureOpt = factureClientService.findById(idFactureClient);
        
        if (factureOpt.isPresent()) {
            FactureClient facture = factureOpt.get();
            model.addAttribute("facture", facture);
            
            // Récupérer le client
            clientService.findById(facture.getIdClient()).ifPresent(client -> 
                model.addAttribute("client", client));
            
            // Récupérer le bon de commande
            bonCommandeClientService.findById(facture.getIdBonCommandeClient()).ifPresent(bc -> {
                model.addAttribute("bonCommande", bc);
                // Récupérer l'article
                articleService.findById(bc.getIdArticle()).ifPresent(article -> 
                    model.addAttribute("article", article));
            });
            
            return "vente/facture-client-detail";
        } else {
            model.addAttribute("error", "Facture non trouvée.");
            return "redirect:/vente/facture/list";
        }
    }

    // Enregistrer un paiement pour une facture
    @PostMapping("/vente/facture/payer")
    public String payerFactureClient(@RequestParam("idFactureClient") Integer idFactureClient,
                                    @RequestParam("montantPaye") Double montantPaye,
                                    HttpSession session,
                                    Model model) {
        
        Utilisateur utilisateurConnecte = (Utilisateur) session.getAttribute("utilisateur");
        if (utilisateurConnecte == null) {
            model.addAttribute("error", "Vous devez être connecté.");
            return "redirect:/user/login";
        }
        
        try {
            factureClientService.enregistrerPaiement(idFactureClient, montantPaye);
            
            // Vérifier si la facture est maintenant payée
            FactureClient facture = factureClientService.findById(idFactureClient).get();
            if ("PAYE".equals(facture.getStatutPaiement())) {
                // Créer automatiquement le bon de livraison
                BonLivraisonClient bonLivraison = bonLivraisonClientService.creerBonLivraisonFromFacture(idFactureClient);
                model.addAttribute("success", "Paiement enregistré et bon de livraison créé: " + bonLivraison.getNumeroBlClient());
            } else {
                model.addAttribute("success", "Paiement enregistré. Montant restant: " + facture.getMontantRestant());
            }
            
            return "redirect:/vente/facture/detail/" + idFactureClient;
        } catch (Exception e) {
            model.addAttribute("error", "Erreur: " + e.getMessage());
            return "redirect:/vente/facture/detail/" + idFactureClient;
        }
    }

    // Liste des bons de livraison clients
    @GetMapping("/vente/bl/list")
    public String listeBonLivraisonsClients(@RequestParam(value = "statut", required = false) String statut, Model model) {
        List<BonLivraisonClient> bonLivraisons;
        
        if (statut != null && !statut.isEmpty()) {
            bonLivraisons = bonLivraisonClientService.findByStatut(statut);
        } else {
            bonLivraisons = bonLivraisonClientService.findAll();
        }
        
        model.addAttribute("bonLivraisons", bonLivraisons);
        model.addAttribute("statutFiltre", statut);
        
        return "vente/bl-client-liste";
    }

    // Détail d'un bon de livraison client
    @GetMapping("/vente/bl/detail/{id}")
    public String detailBonLivraisonClient(@PathVariable("id") Integer idBonLivraisonClient, Model model) {
        Optional<BonLivraisonClient> bonLivraisonOpt = bonLivraisonClientService.findById(idBonLivraisonClient);
        
        if (bonLivraisonOpt.isPresent()) {
            BonLivraisonClient bonLivraison = bonLivraisonOpt.get();
            model.addAttribute("bonLivraison", bonLivraison);
            
            // Récupérer le client
            clientService.findById(bonLivraison.getIdClient()).ifPresent(client -> 
                model.addAttribute("client", client));
            
            // Récupérer l'article
            articleService.findById(bonLivraison.getIdArticle()).ifPresent(article -> 
                model.addAttribute("article", article));
            
            return "vente/bl-client-detail";
        } else {
            model.addAttribute("error", "Bon de livraison non trouvé.");
            return "redirect:/vente/bl/list";
        }
    }

    // Expédier un bon de livraison
    @PostMapping("/vente/bl/expedier")
    public String expedierBonLivraison(@RequestParam("idBonLivraisonClient") Integer idBonLivraisonClient,
                                      @RequestParam("idLivreur") Integer idLivreur,
                                      HttpSession session,
                                      Model model) {
        
        Utilisateur utilisateurConnecte = (Utilisateur) session.getAttribute("utilisateur");
        if (utilisateurConnecte == null) {
            model.addAttribute("error", "Vous devez être connecté.");
            return "redirect:/user/login";
        }
        
        try {
            bonLivraisonClientService.expedierLivraison(idBonLivraisonClient, idLivreur);
            model.addAttribute("success", "Bon de livraison expédié. Le stock a été mis à jour.");
            return "redirect:/vente/bl/detail/" + idBonLivraisonClient;
        } catch (Exception e) {
            model.addAttribute("error", "Erreur: " + e.getMessage());
            return "redirect:/vente/bl/detail/" + idBonLivraisonClient;
        }
    }

    // Marquer un bon de livraison comme livré
    @PostMapping("/vente/bl/livrer")
    public String livrerBonLivraison(@RequestParam("idBonLivraisonClient") Integer idBonLivraisonClient,
                                    HttpSession session,
                                    Model model) {
        
        Utilisateur utilisateurConnecte = (Utilisateur) session.getAttribute("utilisateur");
        if (utilisateurConnecte == null) {
            model.addAttribute("error", "Vous devez être connecté.");
            return "redirect:/user/login";
        }
        
        bonLivraisonClientService.marquerCommeLivre(idBonLivraisonClient);
        model.addAttribute("success", "Livraison confirmée.");
        
        return "redirect:/vente/bl/detail/" + idBonLivraisonClient;
    }

    // Page de gestion du stock
    @GetMapping("/vente/stock")
    public String gestionStock(Model model) {
        List<Stock> stocks = stockService.findAll();
        model.addAttribute("stocks", stocks);
        
        // Récupérer les articles pour afficher leurs noms
        List<Article> articles = articleService.findAll();
        model.addAttribute("articles", articles);
        
        return "vente/stock-liste";
    }

    // Gestion des clients
    @GetMapping("/vente/clients")
    public String listeClients(Model model) {
        List<Client> clients = clientService.findAll();
        model.addAttribute("clients", clients);
        return "vente/client-liste";
    }

    @GetMapping("/vente/client/form")
    public String formulaireClient(Model model) {
        return "vente/client-form";
    }

    @PostMapping("/vente/client/creer")
    public String creerClient(@RequestParam("nom") String nom,
                             @RequestParam(value = "prenom", required = false) String prenom,
                             @RequestParam("email") String email,
                             @RequestParam(value = "telephone", required = false) String telephone,
                             @RequestParam(value = "adresse", required = false) String adresse,
                             HttpSession session,
                             Model model) {
        
        Utilisateur utilisateurConnecte = (Utilisateur) session.getAttribute("utilisateur");
        if (utilisateurConnecte == null) {
            model.addAttribute("error", "Vous devez être connecté.");
            return "redirect:/user/login";
        }
        
        Client client = new Client(nom, prenom, email, telephone, adresse);
        clientService.save(client);
        
        model.addAttribute("success", "Client créé avec succès.");
        return "redirect:/vente/clients";
    }
}

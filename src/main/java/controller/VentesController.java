package controller;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import entity.*;
import jakarta.servlet.http.HttpSession;
import service.*;

@Controller
@RequestMapping("/vente")
public class VentesController {

    @Autowired
    private ArticleService articleService;

    @Autowired
    private ClientService clientService;

    @Autowired
    private DevisService devisService;

    @Autowired
    private VUtilisateurRoleService vUtilisateurRoleService;

    @Autowired
    private PrixService prixService;

    @Autowired
    private CommandeClientService commandeClientService;

    @Autowired
    private LivraisonClientService livraisonClientService;

    @Autowired
    private LigneLivraisonClientService ligneLivraisonClientService;

    @Autowired
    private LigneCommandeClientService ligneCommandeClientService;

    @Autowired
    private LigneDevisService ligneDevisService;

    @Autowired
    private FactureClientService factureClientService;

    @Autowired
    private ReglementClientService reglementClientService;


    private VUtilisateurRole getUser(HttpSession session) {
        VUtilisateurRole user = (VUtilisateurRole) session.getAttribute("utilisateur");
        if (user == null) return null;
        
        // Recharger depuis la vue pour avoir les données à jour
        return vUtilisateurRoleService.findById(user.getIdUtilisateur())
                .orElse(null);
    }


    @GetMapping("/accueil")
    public String accueil(Model model, HttpSession session) {
        VUtilisateurRole user = getUser(session);

        if (user == null || user.getNomRole() == null) {
            session.invalidate();
            return "redirect:/user/login?id=1";
        }

        model.addAttribute("utilisateur", user);
        return "vente/accueil";
    }


    @GetMapping("/articles")
    public String listArticles(Model model, HttpSession session) {
        VUtilisateurRole user = getUser(session);
        if (user == null || user.getNomRole() == null) {
            session.invalidate();
            return "redirect:/user/login?id=1";
        }
        List<Article> articles = articleService.findAll();
        // Filtrer les articles pour éviter les valeurs null
        articles = articles.stream()
                .filter(a -> a.getIdArticle() != null && (a.getDesignation() != null || a.getCode() != null))
                .collect(Collectors.toList());
        
        model.addAttribute("articles", articles);
        model.addAttribute("utilisateur", user);
        return "vente/liste_articles";
    }

    @PostMapping("/devis/nouveau")
    public String nouveauDevis(@RequestParam String selectedArticles,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {

        VUtilisateurRole user = getUser(session);
        if (user == null) return "redirect:/user/login?id=1";

        ObjectMapper mapper = new ObjectMapper();
        try {
            List<Integer> selectedIds = mapper.readValue(
                    selectedArticles,
                    new TypeReference<List<Integer>>() {}
            );

            if (selectedIds == null || selectedIds.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Aucun article sélectionné");
                return "redirect:/vente/articles";
            }

            session.setAttribute("selectedArticles", selectedIds);
            return "redirect:/vente/devis/nouveau";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Format JSON invalide");
            return "redirect:/vente/articles";
        }
    }

    @GetMapping("/devis/nouveau")
    public String nouveauDevisForm(Model model,
                                   HttpSession session,
                                   RedirectAttributes redirectAttributes) {

        VUtilisateurRole user = getUser(session);
        if (user == null || user.getNomRole() == null) {
            session.invalidate();
            return "redirect:/user/login?id=1";
        }

        @SuppressWarnings("unchecked")
        List<Integer> selectedIds =
                (List<Integer>) session.getAttribute("selectedArticles");

        if (selectedIds == null || selectedIds.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Aucune sélection");
            return "redirect:/vente/articles";
        }

        List<Article> selectedArticlesList = new ArrayList<>();
        Map<Integer, BigDecimal> unitPrices = new java.util.HashMap<>();

        for (Integer id : selectedIds) {
            articleService.findById(id).ifPresent(a -> {
                // Ne pas ajouter les articles avec des propriétés critiques null
                if (a.getIdArticle() != null && (a.getDesignation() != null || a.getCode() != null)) {
                    selectedArticlesList.add(a);
                    prixService.findDernierPrixVente(a.getIdArticle())
                            .ifPresent(p ->
                                    unitPrices.put(a.getIdArticle(),
                                            BigDecimal.valueOf(p.getMontant())));
                }
            });
        }

        List<Client> clients = clientService.findAll();
        // Filtrer les clients pour éviter les valeurs null
        clients = clients.stream()
                .filter(c -> c.getIdClient() != null && (c.getNom() != null || c.getCodeClient() != null))
                .collect(Collectors.toList());
        
        model.addAttribute("clients", clients);
        model.addAttribute("selectedArticles", selectedArticlesList);
        model.addAttribute("unitPrices", unitPrices);
        model.addAttribute("utilisateur", user);

        boolean isCommercial = "COMMERCIAL".equals(user.getNomRole());

        model.addAttribute("isCommercial", isCommercial);

        if (!isCommercial) {
            List<VUtilisateurRole> commerciaux =
                    vUtilisateurRoleService.findByActifTrue()
                            .stream()
                            .filter(u -> "COMMERCIAL".equals(u.getNomRole()))
                            .filter(u -> u.getIdUtilisateur() != null && u.getNom() != null && u.getPrenom() != null && u.getEmail() != null)
                            .collect(Collectors.toList());

            model.addAttribute("commerciaux", commerciaux);
        }

        return "vente/nouveau_devis";
    }

    @PostMapping("/devis/creer")
    public String creerDevis(@RequestParam Integer idClient,
                            @RequestParam(required = false) Integer idCommercial,
                            HttpSession session,
                            RedirectAttributes redirectAttributes,
                            jakarta.servlet.http.HttpServletRequest request) {

        VUtilisateurRole user = getUser(session);
        if (user == null || user.getNomRole() == null) {
            session.invalidate();
            return "redirect:/user/login?id=1";
        }

        try {
            @SuppressWarnings("unchecked")
            List<Integer> selectedIds =
                    (List<Integer>) session.getAttribute("selectedArticles");

            if (selectedIds == null || selectedIds.isEmpty()) {
                throw new RuntimeException("Aucun article sélectionné");
            }

            // ✅ Détermination du commercial
            Integer commercialId;
            if ("COMMERCIAL".equals(user.getNomRole())) {
                commercialId = user.getIdUtilisateur();
            } else {
                if (idCommercial == null) {
                    throw new RuntimeException("Commercial requis");
                }
                commercialId = idCommercial;
            }

            // ✅ Construction des lignes de devis
            List<Object[]> lignes = new ArrayList<>();

            for (Integer articleId : selectedIds) {

                String qtyParam = request.getParameter("qty_" + articleId);
                if (qtyParam == null || qtyParam.isBlank()) continue;

                int quantite = Integer.parseInt(qtyParam);
                if (quantite <= 0) continue;

                // ✅ Récupération du prix depuis la base
                BigDecimal prixUnitaire = prixService
                        .findDernierPrixVente(articleId)
                        .map(p -> BigDecimal.valueOf(p.getMontant()))
                        .orElseThrow(() ->
                            new RuntimeException("Prix introuvable pour l'article " + articleId)
                        );

                // ✅ Valeurs par défaut
                BigDecimal remise = BigDecimal.ZERO;
                BigDecimal tva = new BigDecimal("20.0");

                // Format attendu par le service
                Object[] ligne = new Object[]{
                        articleId,
                        quantite,
                        prixUnitaire,
                        remise,
                        tva
                };

                lignes.add(ligne);
            }

            if (lignes.isEmpty()) {
                throw new RuntimeException("Aucune ligne de devis valide");
            }

            // ✅ Date de validité par défaut : 30 jours
            LocalDate dateValidite = LocalDate.now().plusDays(30);
            String notes = request.getParameter("notes");

            // ✅ Création du devis
            devisService.creerDevisAvecLignes(
                    idClient,
                    commercialId,
                    dateValidite,
                    notes,
                    lignes
            );

            // Nettoyage session
            session.removeAttribute("selectedArticles");

            redirectAttributes.addFlashAttribute(
                    "message", "Devis créé avec succès"
            );

            return "redirect:/vente/devis";

        } catch (Exception e) {
            e.printStackTrace(); // utile pour debug serveur
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/vente/devis/nouveau";
        }
    }


    @GetMapping("/devis")
    public String listeDevis(Model model, HttpSession session) {
        VUtilisateurRole user = getUser(session);
        if (user == null || user.getNomRole() == null) {
            session.invalidate();
            return "redirect:/user/login?id=1";
        }

        List<Devis> devisList = devisService.findAll();

        model.addAttribute("devisList", devisList);
        model.addAttribute("utilisateur", user);   // 👈 IMPORTANT pour la JSP
        return "vente/liste_devis";
    }


    @PostMapping("/devis/valider")
    public String validerDevis(@RequestParam Integer idDevis,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {

        VUtilisateurRole user = getUser(session);
        if (user == null || user.getNomRole() == null) {
            session.invalidate();
            return "redirect:/user/login?id=1";
        }

        try {
            // Convertir VUtilisateurRole en Utilisateur pour le service
            Utilisateur utilisateur = new Utilisateur();
            utilisateur.setIdUtilisateur(user.getIdUtilisateur());
            utilisateur.setIdRole(user.getIdRole());
            Role role = new Role();
            role.setIdRole(user.getIdRole());
            role.setNomRole(user.getNomRole());
            role.setNiveauValidation(user.getNiveauValidation());
            utilisateur.setRole(role);
            
            devisService.validerDevis(idDevis, utilisateur);
            redirectAttributes.addFlashAttribute("message", "Devis validé avec succès");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/vente/devis";
    }

    @PostMapping("/devis/refuser")
    public String refuserDevis(@RequestParam Integer idDevis,
                              @RequestParam String motif,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {

        VUtilisateurRole user = getUser(session);
        if (user == null || user.getNomRole() == null) {
            session.invalidate();
            return "redirect:/user/login?id=1";
        }

        try {
            // Convertir VUtilisateurRole en Utilisateur pour le service
            Utilisateur utilisateur = new Utilisateur();
            utilisateur.setIdUtilisateur(user.getIdUtilisateur());
            utilisateur.setIdRole(user.getIdRole());
            Role role = new Role();
            role.setIdRole(user.getIdRole());
            role.setNomRole(user.getNomRole());
            role.setNiveauValidation(user.getNiveauValidation());
            utilisateur.setRole(role);
            
            devisService.refuserDevis(idDevis, utilisateur, motif);
            redirectAttributes.addFlashAttribute("message", "Devis refusé");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/vente/devis";
    }

    @GetMapping("/commandes")
    public String listeDevisCommande(Model model, HttpSession session) {
        VUtilisateurRole user = getUser(session);
        if (user == null || user.getNomRole() == null) {
            session.invalidate();
            return "redirect:/user/login?id=1";
        }

        // Liste des devis acceptés (transformables en commande)
        List<Devis> devisList = devisService.findByStatut("ACCEPTE");
        model.addAttribute("devisList", devisList);
        model.addAttribute("utilisateur", user);
        return "vente/liste_devis_commande";
    }

    @GetMapping("/commandes/nouveau")
    public String nouveauCommandeForm(@RequestParam Integer idDevis,
                                     Model model,
                                     HttpSession session,
                                     RedirectAttributes redirectAttributes) {

        VUtilisateurRole user = getUser(session);
        if (user == null || user.getNomRole() == null) {
            session.invalidate();
            return "redirect:/user/login?id=1";
        }

        Devis devis = devisService.findById(idDevis).orElse(null);
        if (devis == null) {
            redirectAttributes.addFlashAttribute("error", "Devis introuvable");
            return "redirect:/vente/commandes";
        }

        if (!"ACCEPTE".equals(devis.getStatut())) {
            redirectAttributes.addFlashAttribute("error", "Ce devis n'est pas accepté");
            return "redirect:/vente/commandes";
        }

        model.addAttribute("devis", devis);
        model.addAttribute("utilisateur", user);
        return "vente/commande_confirmation";
    }

    @PostMapping("/commandes/creer")
    public String creerCommande(@RequestParam Integer idDevis,
                            @RequestParam(required = false) String dateLivraison,
                            HttpSession session,
                            RedirectAttributes redirectAttributes) {

        VUtilisateurRole user = getUser(session);
        if (user == null || user.getNomRole() == null) {
            session.invalidate();
            return "redirect:/user/login?id=1";
        }

        try {
            LocalDateTime dateLivraisonSouhaitee = LocalDateTime.now().plusDays(7);
            if (dateLivraison != null && !dateLivraison.isBlank()) {
                LocalDate date = LocalDate.parse(dateLivraison);
                dateLivraisonSouhaitee = date.atStartOfDay();
            }

            // ⚠️ Création en A_VALIDER (pas encore validée)
            commandeClientService.creerCommandeDepuisDevis(
                    idDevis,
                    dateLivraisonSouhaitee
            );

            redirectAttributes.addFlashAttribute(
                    "message", "Commande créée et envoyée pour validation.");

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/vente/commandes/nouveau?idDevis=" + idDevis;
        }

        return "redirect:/vente/commandes";
    }


    @GetMapping("/livraisons")
    public String listeCommandesALivrer(Model model, HttpSession session) {

        VUtilisateurRole user = getUser(session);

        if (user == null || user.getNomRole() == null) {
            session.invalidate();
            return "redirect:/user/login?id=1";
        }

        String role = user.getNomRole();
        if (!"MAGASINIER".equals(role) && !"ADMIN".equals(role)) {
            model.addAttribute("error", "Accès refusé");
            return "vente/accueil";
        }

        List<CommandeClient> commandes =
                commandeClientService.findLivrables();

        model.addAttribute("commandes", commandes);
        model.addAttribute("utilisateur", user);
        return "vente/liste_commandes_livraison";
    }

    @PostMapping("/commandes/valider")
    public String validerCommande(@RequestParam Integer idCommande,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {

        VUtilisateurRole user = getUser(session);
        if (user == null) {
            session.invalidate();
            return "redirect:/user/login?id=1";
        }

        try {
            // ✅ Construire l'utilisateur validateur
            Utilisateur validateur = new Utilisateur();
            validateur.setIdUtilisateur(user.getIdUtilisateur());
            validateur.setIdRole(user.getIdRole());

            Role role = new Role();
            role.setIdRole(user.getIdRole());
            role.setNomRole(user.getNomRole());
            role.setNiveauValidation(user.getNiveauValidation());
            validateur.setRole(role);

            commandeClientService.validerCommande(idCommande, validateur);

            redirectAttributes.addFlashAttribute("message", "Commande validée");

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/vente/commandes/a-valider";
    }



    @PostMapping("/commandes/refuser")
    public String refuserCommande(@RequestParam Integer idCommande,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {

        VUtilisateurRole user = getUser(session);
        if (user == null) {
            session.invalidate();
            return "redirect:/user/login?id=1";
        }

        try {
            commandeClientService.refuserCommande(idCommande);
            redirectAttributes.addFlashAttribute("message", "Commande refusée");

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/vente/commandes/a-valider";
    }



    @GetMapping("/commandes/a-valider")
    public String listeCommandesAValider(Model model, HttpSession session) {

        VUtilisateurRole user = getUser(session);
        if (user == null || user.getNomRole() == null) {
            session.invalidate();
            return "redirect:/user/login?id=1";
        }

        String role = user.getNomRole();
        if (!"ADMIN".equals(role) && !role.startsWith("VALIDEUR")) {
            model.addAttribute("error", "Accès interdit");
            return "vente/accueil";
        }

        List<CommandeClient> commandes =
                commandeClientService.findAll()
                        .stream()
                        .filter(c -> "A_VALIDER".equals(c.getStatut()))
                        .toList();

        model.addAttribute("commandes", commandes);
        model.addAttribute("utilisateur", user);
        return "vente/liste_commandes_validation";
    }


    @GetMapping("/livraisons/nouveau")
    public String formLivraison(@RequestParam Integer idCommande,
                                Model model,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {

        VUtilisateurRole user = getUser(session);
        
        if (user == null || user.getNomRole() == null) {
            session.invalidate();
            return "redirect:/user/login?id=1";
        }

        String role = user.getNomRole();

        if (!"MAGASINIER".equals(role) && !"ADMIN".equals(role)) {
            redirectAttributes.addFlashAttribute("error", "Accès refusé");
            return "redirect:/vente/livraisons";
        }

        CommandeClient commande =
                commandeClientService.findById(idCommande).orElse(null);

        if (commande == null) {
            redirectAttributes.addFlashAttribute("error", "Commande introuvable");
            return "redirect:/vente/livraisons";
        }

        List<LigneCommandeClient> lignes =
                ligneCommandeClientService.findByIdCommande(idCommande);
        
        // Initialiser quantiteLivree à 0 si null
        for (LigneCommandeClient ligne : lignes) {
            if (ligne.getQuantiteLivree() == null) {
                ligne.setQuantiteLivree(0);
            }
        }

        model.addAttribute("lignesCommande", lignes);
        model.addAttribute("commande", commande);
        model.addAttribute("utilisateur", user);
        return "vente/livraison_form";
    }

    @PostMapping("/livraisons/creer")
    public String creerLivraison(@RequestParam Integer idCommande,
                                 @RequestParam String transporteur,
                                 @RequestParam(required = false) String numeroSuivi,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes,
                                 jakarta.servlet.http.HttpServletRequest request) {

        VUtilisateurRole user = getUser(session);
        if (user == null || user.getNomRole() == null) {
            redirectAttributes.addFlashAttribute("error", "Session invalide ou rôle manquant");
            session.invalidate();
            return "redirect:/user/login?id=1";
        }

        try {
            if (transporteur == null || transporteur.trim().isEmpty()) {
                throw new RuntimeException("Transporteur obligatoire");
            }

            List<LigneCommandeClient> lignesCommande =
                    ligneCommandeClientService.findByIdCommande(idCommande);

            if (lignesCommande.isEmpty()) {
                throw new RuntimeException("Aucune ligne de commande");
            }

            List<LigneLivraisonClient> lignesLivraison = new ArrayList<>();

            for (LigneCommandeClient ligneCmd : lignesCommande) {
                String param = request.getParameter(
                        "qty_" + ligneCmd.getIdLigneCommande());

                if (param == null || param.isBlank()) continue;

                int qty = Integer.parseInt(param);
                if (qty <= 0) continue;

                LigneLivraisonClient ligne = new LigneLivraisonClient();
                ligne.setIdLigneCommande(ligneCmd.getIdLigneCommande());
                ligne.setQuantiteLivree(qty);
                lignesLivraison.add(ligne);
            }

            if (lignesLivraison.isEmpty()) {
                throw new RuntimeException("Aucune quantité saisie");
            }

            livraisonClientService.creerLivraison(
                    idCommande,
                    user.getIdUtilisateur(),
                    transporteur.trim(),
                    numeroSuivi,
                    lignesLivraison
            );

            redirectAttributes.addFlashAttribute(
                    "message", "Livraison créée avec succès");

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/vente/livraisons";
    }

    @GetMapping("/factures")
    public String listeFactures(Model model, HttpSession session) {

        VUtilisateurRole user = getUser(session);
        if (user == null) return "redirect:/user/login?id=1";

        List<FactureClient> factures = factureClientService.findAll();

        model.addAttribute("factures", factures);
        model.addAttribute("utilisateur", user);
        return "vente/liste_factures";
    }

    @GetMapping("/factures/livraisons-facturables")
    public String livraisonsFacturables(Model model, HttpSession session) {

        VUtilisateurRole user = getUser(session);
        if (user == null) return "redirect:/user/login?id=1";

        List<LivraisonClient> livraisons =
                livraisonClientService.findAll()
                        .stream()
                        .filter(l ->
                            "LIVREE".equals(l.getStatut()) ||
                            "PARTIELLE".equals(l.getStatut()))
                        .toList();

        model.addAttribute("livraisons", livraisons);
        model.addAttribute("utilisateur", user);
        return "vente/liste_livraisons_facturables";
    }

    @PostMapping("/factures/creer")
    public String creerFacture(@RequestParam Integer idLivraison,
                            HttpSession session,
                            RedirectAttributes redirectAttributes) {

        VUtilisateurRole user = getUser(session);
        if (user == null) return "redirect:/user/login?id=1";

        try {
            factureClientService.creerFactureDepuisLivraison(
                    idLivraison,
                    user.getIdUtilisateur()
            );

            redirectAttributes.addFlashAttribute(
                    "message", "Facture créée avec succès");

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/vente/factures";
    }

    @GetMapping("/factures/{id}")
    public String detailFacture(@PathVariable Integer id,
                                Model model,
                                HttpSession session) {

        VUtilisateurRole user = getUser(session);
        if (user == null) {
            session.invalidate();
            return "redirect:/user/login?id=1";
        }

        FactureClient facture = factureClientService.findById(id);
        List<LigneFactureClient> lignes =
                factureClientService.findLignes(id);

        java.math.BigDecimal montantPaye =
                java.util.Optional.ofNullable(facture.getMontantPaye())
                        .orElse(java.math.BigDecimal.ZERO);
        java.math.BigDecimal montantTtc =
                java.util.Optional.ofNullable(facture.getMontantTtc())
                        .orElse(java.math.BigDecimal.ZERO);
        java.math.BigDecimal resteAPayer = montantTtc.subtract(montantPaye);

        model.addAttribute("facture", facture);
        model.addAttribute("lignes", lignes);
        model.addAttribute("montantPaye", montantPaye);
        model.addAttribute("resteAPayer", resteAPayer.compareTo(java.math.BigDecimal.ZERO) < 0 ? java.math.BigDecimal.ZERO : resteAPayer);
        model.addAttribute("utilisateur", user);

        return "vente/facture_detail";
    }

    @PostMapping("/factures/{id}/encaisser")
    public String encaisserFacture(@PathVariable Integer id,
                                   @RequestParam("montant") java.math.BigDecimal montant,
                                   @RequestParam("modeReglement") String modeReglement,
                                   @RequestParam(value = "referencePaiement", required = false) String referencePaiement,
                                   HttpSession session,
                                   RedirectAttributes redirectAttributes) {

        VUtilisateurRole user = getUser(session);
        if (user == null) {
            session.invalidate();
            return "redirect:/user/login?id=1";
        }

        try {
            reglementClientService.encaisserFacture(
                    id,
                    montant,
                    modeReglement,
                    referencePaiement,
                    user.getIdUtilisateur()
            );
            redirectAttributes.addFlashAttribute("message", "Encaissement enregistré");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/vente/factures/" + id;
    }

    @GetMapping("/vente/dashboard")
    public String dashboardVente(Model model, HttpSession session) {
        Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
        if (user == null) {
            return "redirect:/user/login?id=1";
        }
        
        // Statistiques réelles du module Vente
        // 1. Nombre de clients
        List<Client> clients = clientService.findAll();
        long nbClients = clients != null ? clients.size() : 0;
        
        // 2. Nombre de devis
        List<Devis> devis = devisService.findAll();
        long nbDevis = devis != null ? devis.size() : 0;
        
        // 3. Nombre de commandes clients
        List<CommandeClient> commandes = commandeClientService.findAll();
        long nbCommandes = commandes != null ? commandes.size() : 0;
        
        // 4. Nombre de livraisons
        List<LivraisonClient> livraisons = livraisonClientService.findAll();
        long nbLivraisons = livraisons != null ? livraisons.size() : 0;
        
        // 5. Nombre de factures
        List<FactureClient> factures = factureClientService.findAll();
        long nbFactures = factures != null ? factures.size() : 0;
        
        // 6. Chiffre d'affaires total
        BigDecimal chiffreAffaires = BigDecimal.ZERO;
        if (factures != null) {
            for (FactureClient f : factures) {
                if (f.getMontantTtc() != null) {
                    chiffreAffaires = chiffreAffaires.add(f.getMontantTtc());
                }
            }
        }
        
        model.addAttribute("nbClients", nbClients);
        model.addAttribute("nbDevis", nbDevis);
        model.addAttribute("nbCommandes", nbCommandes);
        model.addAttribute("nbLivraisons", nbLivraisons);
        model.addAttribute("nbFactures", nbFactures);
        model.addAttribute("chiffreAffaires", chiffreAffaires);
        model.addAttribute("utilisateur", user);
        
        return "vente/dashboard";
    }

}

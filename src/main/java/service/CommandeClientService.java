package service;

import entity.CommandeClient;
import entity.Devis;
import entity.LigneCommandeClient;
import entity.LigneDevis;
import entity.Utilisateur;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import repository.CommandeClientRepository;
import repository.DevisRepository;
import repository.LigneCommandeClientRepository;
import repository.LigneDevisRepository;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class CommandeClientService {

    @Autowired
    private CommandeClientRepository commandeClientRepository;

    @Autowired
    private LigneCommandeClientRepository ligneCommandeClientRepository;

    @Autowired
    private DevisRepository devisRepository;

    @Autowired
    private LigneDevisRepository ligneDevisRepository;

    public List<CommandeClient> findAll() {
        return commandeClientRepository.findAll();
    }

    public Optional<CommandeClient> findById(Integer id) {
        return commandeClientRepository.findById(id);
    }

    public Optional<CommandeClient> findByNumeroCommande(String numeroCommande) {
        return commandeClientRepository.findByNumeroCommande(numeroCommande);
    }

    @Transactional
    public CommandeClient creerCommandeDepuisDevis(Integer idDevis, LocalDateTime dateLivraisonSouhaitee) {
        // Récupérer le devis
        Devis devis = devisRepository.findById(idDevis)
            .orElseThrow(() -> new IllegalArgumentException("Devis introuvable: " + idDevis));

        // Vérifier que le devis est accepté
        if (!"ACCEPTE".equals(devis.getStatut())) {
            throw new IllegalArgumentException("Le devis doit être accepté pour créer une commande");
        }

        // Créer la commande client
        CommandeClient commande = new CommandeClient();
        commande.setNumeroCommande(generateNumeroCommande());
        commande.setIdDevis(idDevis);
        commande.setIdClient(devis.getIdClient());
        commande.setDateCommande(LocalDateTime.now());
        commande.setDateLivraisonSouhaitee(dateLivraisonSouhaitee.toLocalDate());
        commande.setStatut("A_VALIDER");
        commande.setIdValidateur(null);
        commande.setDateValidation(null);
        commande.setMontantTotalHt(devis.getMontantTotalHt());
        commande.setMontantTotalTtc(devis.getMontantTtc());
        commande.setIdCommercial(devis.getIdCommercial());

        commande = commandeClientRepository.save(commande);

        // Créer les lignes de commande depuis les lignes de devis
        List<LigneDevis> lignesDevis = ligneDevisRepository.findByIdDevis(idDevis);
        for (LigneDevis ligneDevis : lignesDevis) {
            LigneCommandeClient ligneCommande = new LigneCommandeClient();
            ligneCommande.setIdCommande(commande.getIdCommande());
            ligneCommande.setIdArticle(ligneDevis.getIdArticle());
            ligneCommande.setQuantiteCommandee(ligneDevis.getQuantite());
            ligneCommande.setPrixUnitaireHt(ligneDevis.getPrixUnitaireHt());
            ligneCommande.setRemise(ligneDevis.getRemise());
            // ligneCommande.setMontantHt(ligneDevis.getPrixUnitaireHt()
            //     .multiply(BigDecimal.valueOf(ligneDevis.getQuantite()))
            //     .multiply(BigDecimal.ONE.subtract(ligneDevis.getRemise().divide(BigDecimal.valueOf(100)))));
            ligneCommandeClientRepository.save(ligneCommande);
        }

        return commande;
    }

    private String generateNumeroCommande() {
        // Générer un numéro unique, par exemple CMD-YYYYMMDD-XXX
        String date = LocalDateTime.now().toLocalDate().toString().replace("-", "");
        // Pour simplifier, utiliser un compteur ou UUID, mais ici on utilise une logique simple
        return "CMD-" + date + "-" + System.currentTimeMillis() % 1000;
    }

    public CommandeClient save(CommandeClient commandeClient) {
        return commandeClientRepository.save(commandeClient);
    }

    public void deleteById(Integer id) {
        commandeClientRepository.deleteById(id);
    }

    public List<CommandeClient> findLivrables() {
        return commandeClientRepository.findAll()
                .stream()
                .filter(c ->
                        "VALIDEE".equals(c.getStatut()) ||
                        "EN_PREPARATION".equals(c.getStatut()) ||
                        "PARTIELLEMENT_LIVREE".equals(c.getStatut())
                )
                .toList();  
    }


    @Transactional
    public void validerCommande(Integer idCommande, Utilisateur validateur) {

        CommandeClient commande = commandeClientRepository.findById(idCommande)
                .orElseThrow(() -> new RuntimeException("Commande introuvable"));

        if (!"A_VALIDER".equals(commande.getStatut())) {
            throw new RuntimeException("Seules les commandes à valider peuvent être validées.");
        }

        // Charger rôle
        // ⚠️ à adapter selon votre logique
        // enrichirAvecRole(validateur);

        Integer roleId = validateur.getIdRole();

        // Exemple :
        // 1 = ADMIN
        // 6 = RESPONSABLE_VENTES
        if (roleId != 1 && roleId != 6) {
            throw new RuntimeException("Vous n'avez pas le droit de valider cette commande.");
        }

        commande.setStatut("VALIDEE");
        commande.setIdValidateur(validateur.getIdUtilisateur());
        commande.setDateValidation(LocalDateTime.now());

        commandeClientRepository.save(commande);
    }

    public List<CommandeClient> findByStatut(String statut) {
        return commandeClientRepository.findByStatut(statut);
    }

    @Transactional
    public void refuserCommande(Integer idCommande, Utilisateur validateur, String motif) {

        CommandeClient commande = commandeClientRepository.findById(idCommande)
                .orElseThrow(() -> new RuntimeException("Commande introuvable"));

        if (!"A_VALIDER".equals(commande.getStatut())) {
            throw new RuntimeException("Seules les commandes à valider peuvent être refusées.");
        }

        Integer roleId = validateur.getIdRole();

        if (roleId != 1 && roleId != 6) {
            throw new RuntimeException("Vous n'avez pas le droit de refuser cette commande.");
        }

        commande.setStatut("ANNULEE");   // ou REFUSEE selon votre choix métier
        commande.setIdValidateur(validateur.getIdUtilisateur());
        commande.setDateValidation(LocalDateTime.now());

        commandeClientRepository.save(commande);

        // Plus tard : stocker le motif dans une table d'audit
    }





}
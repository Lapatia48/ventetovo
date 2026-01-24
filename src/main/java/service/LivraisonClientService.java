package service;

import entity.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import repository.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Service
@Transactional
public class LivraisonClientService {

    @Autowired
    private LivraisonClientRepository livraisonRepository;

    @Autowired
    private LigneLivraisonClientRepository ligneLivraisonRepository;

    @Autowired
    private CommandeClientRepository commandeRepository;

    @Autowired
    private LigneCommandeClientRepository ligneCommandeRepository;

    @Autowired
    private UtilisateurRepository utilisateurRepository;

    @Autowired
    private VUtilisateurRoleRepository vUtilisateurRoleRepository;

    /**
     * Création d'une livraison depuis une commande
     */
    public LivraisonClient creerLivraison(Integer idCommande,
                                           Integer idPreparateur,
                                           String transporteur,
                                           String numeroSuivi,
                                           List<LigneLivraisonClient> lignes) {

        // 🔐 Vérifier préparateur
        VUtilisateurRole preparateur =
        vUtilisateurRoleRepository.findById(idPreparateur)
                .orElseThrow(() -> new RuntimeException("Préparateur introuvable"));

        if (!"MAGASINIER".equals(preparateur.getNomRole())) {
            throw new RuntimeException("Seul un magasinier peut préparer une livraison");
        }


        // 📦 Charger commande
        CommandeClient commande = commandeRepository.findById(idCommande)
                .orElseThrow(() -> new RuntimeException("Commande introuvable"));

        if (!"VALIDEE".equals(commande.getStatut()) &&
            !"EN_PREPARATION".equals(commande.getStatut()) &&
            !"PARTIELLEMENT_LIVREE".equals(commande.getStatut())) {

            throw new RuntimeException("Commande non livrable dans son état actuel : "
                    + commande.getStatut());
        }
        if ("VALIDEE".equals(commande.getStatut())) {
            commande.setStatut("EN_PREPARATION");
            commandeRepository.save(commande);
        }


        // 🚚 Créer livraison
        LivraisonClient livraison = new LivraisonClient();
        livraison.setNumeroLivraison(genererNumeroLivraison());
        livraison.setIdCommande(idCommande);
        livraison.setDateLivraison(LocalDate.now());
        livraison.setTransporteur(transporteur);
        livraison.setNumeroSuivi(numeroSuivi);
        livraison.setStatut("EN_PREPARATION");
        livraison.setIdPreparateur(idPreparateur);
        livraison.setCreatedAt(LocalDateTime.now());

        livraison = livraisonRepository.save(livraison);

        boolean livraisonComplete = true;

        // 📦 Créer lignes livraison
        for (LigneLivraisonClient ligne : lignes) {

            LigneCommandeClient ligneCmd = ligneCommandeRepository
                    .findById(ligne.getIdLigneCommande())
                    .orElseThrow(() -> new RuntimeException("Ligne commande introuvable"));

            int resteALivrer =
                    ligneCmd.getQuantiteCommandee() - ligneCmd.getQuantiteLivree();

            if (ligne.getQuantiteLivree() > resteALivrer) {
                throw new RuntimeException("Quantité livrée dépasse le restant à livrer");
            }

            // Mise à jour quantité livrée commande
            ligneCmd.setQuantiteLivree(
                    ligneCmd.getQuantiteLivree() + ligne.getQuantiteLivree());

            ligneCommandeRepository.save(ligneCmd);

            // Sauvegarde ligne livraison
            ligne.setIdLivraison(livraison.getIdLivraison());
            ligne.setCreatedAt(LocalDateTime.now());
            ligneLivraisonRepository.save(ligne);

            if (ligneCmd.getQuantiteLivree() < ligneCmd.getQuantiteCommandee()) {
                livraisonComplete = false;
            }
        }

        // 🔄 Mise à jour statut commande
        commande.setStatut(livraisonComplete ? "LIVREE" : "PARTIELLEMENT_LIVREE");
        commandeRepository.save(commande);

        // 🔄 Mise à jour statut livraison
        livraison.setStatut(livraisonComplete ? "LIVREE" : "PARTIELLE");
        return livraisonRepository.save(livraison);
    }

    // -----------------------

    public List<LivraisonClient> findByCommande(Integer idCommande) {
        return livraisonRepository.findByIdCommande(idCommande);
    }

    public List<LivraisonClient> findAll() {
        return livraisonRepository.findAll();
    }

    // -----------------------

    private String genererNumeroLivraison() {
        return "BL-" + System.currentTimeMillis();
    }
}

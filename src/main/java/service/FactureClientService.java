package service;

import entity.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import repository.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Service
@Transactional
public class FactureClientService {

    @Autowired private FactureClientRepository factureRepository;
    @Autowired private LigneFactureClientRepository ligneFactureRepository;
    @Autowired private LivraisonClientRepository livraisonRepository;
    @Autowired private LigneLivraisonClientRepository ligneLivraisonRepository;
    @Autowired private CommandeClientRepository commandeRepository;
    @Autowired private LigneCommandeClientRepository ligneCommandeRepository;


    public FactureClient creerFactureDepuisLivraison(
        Integer idLivraison,
        Integer idUtilisateur
    ) {

        LivraisonClient livraison = livraisonRepository.findById(idLivraison)
                .orElseThrow(() -> new RuntimeException("Livraison introuvable"));

        if (!"LIVREE".equals(livraison.getStatut()) &&
            !"PARTIELLE".equals(livraison.getStatut())) {
            throw new RuntimeException("La livraison n'est pas facturable");
        }

        CommandeClient commande = commandeRepository
                .findById(livraison.getIdCommande())
                .orElseThrow(() -> new RuntimeException("Commande introuvable"));

        // =========================
        // Création facture (sans totaux)
        // =========================
        FactureClient facture = new FactureClient();
        facture.setNumeroFacture(genererNumeroFacture());
        facture.setIdLivraison(idLivraison);
        facture.setIdCommande(commande.getIdCommande());
        facture.setIdClient(commande.getIdClient());
        facture.setDateFacture(LocalDate.now());
        facture.setStatut("BROUILLON");
        facture.setMontantPaye(BigDecimal.ZERO);
        facture.setCreatedAt(LocalDateTime.now());
        facture.setCreatedBy(idUtilisateur);

        BigDecimal totalHt = BigDecimal.ZERO;
        BigDecimal totalTva = BigDecimal.ZERO;

        List<LigneLivraisonClient> lignesLivraison =
                ligneLivraisonRepository.findByIdLivraison(idLivraison);

        if (lignesLivraison.isEmpty()) {
            throw new RuntimeException("Aucune ligne de livraison à facturer");
        }

        // =========================
        // Calcul des lignes (sans sauvegarde)
        // =========================
        List<LigneFactureClient> lignesFacture = new java.util.ArrayList<>();
        
        for (LigneLivraisonClient ll : lignesLivraison) {

            LigneCommandeClient ligneCmd =
                    ligneCommandeRepository.findById(ll.getIdLigneCommande())
                            .orElseThrow(() ->
                                new RuntimeException("Ligne commande introuvable"));

            LigneFactureClient lf = new LigneFactureClient();
            lf.setIdArticle(ligneCmd.getIdArticle());
            lf.setQuantite(ll.getQuantiteLivree());
            lf.setPrixUnitaireHt(ligneCmd.getPrixUnitaireHt());
            lf.setRemise(ligneCmd.getRemise());
            lf.setTvaTaux(new BigDecimal("20"));

            BigDecimal montantHt =
                    lf.getPrixUnitaireHt()
                            .multiply(BigDecimal.valueOf(lf.getQuantite()))
                            .multiply(
                                BigDecimal.ONE.subtract(
                                    lf.getRemise().divide(new BigDecimal("100"))
                                )
                            );

            BigDecimal montantTva =
                    montantHt.multiply(
                            lf.getTvaTaux().divide(new BigDecimal("100"))
                    );

            lf.setMontantHt(montantHt);
            lf.setMontantTva(montantTva);
            lf.setMontantTtc(montantHt.add(montantTva));

            totalHt = totalHt.add(montantHt);
            totalTva = totalTva.add(montantTva);

            lignesFacture.add(lf);
        }

        // =========================
        // Totaux facture
        // =========================
        facture.setMontantTotalHt(totalHt);
        facture.setMontantTva(totalTva);
        facture.setMontantTtc(totalHt.add(totalTva));

        // =========================
        // Sauvegarde facture
        // =========================
        facture = factureRepository.save(facture);

        // =========================
        // Sauvegarde des lignes avec id_facture
        // =========================
        for (LigneFactureClient lf : lignesFacture) {
            lf.setIdFacture(facture.getIdFacture());
            ligneFactureRepository.save(lf);
        }

        return facture;
    }


    private String genererNumeroFacture() {
        return "FAC-" + System.currentTimeMillis();
    }

    public FactureClient findById(Integer idFacture) {
        return factureRepository.findById(idFacture)
                .orElseThrow(() -> new RuntimeException("Facture introuvable"));
    }

    public List<LigneFactureClient> findLignes(Integer idFacture) {
        return ligneFactureRepository.findByIdFacture(idFacture);
    }

    public List<FactureClient> findAll() {
        return factureRepository.findAll();
    }
   
}

package service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import entity.Article;
import entity.Client;
import entity.Devis;
import entity.LigneDevis;
import entity.Utilisateur;
import repository.ArticleRepository;
import repository.ClientRepository;
import repository.DevisRepository;
import repository.LigneDevisRepository;
import repository.RoleRepository;
import repository.UtilisateurRepository;

@Service
@Transactional
public class DevisService {
    
    @Autowired
    private DevisRepository devisRepository;
    
    @Autowired
    private ClientRepository clientRepository;
    
    @Autowired
    private UtilisateurRepository utilisateurRepository;
    
    @Autowired
    private ArticleRepository articleRepository;
    
    @Autowired
    private LigneDevisRepository ligneDevisRepository;
    
    @Autowired
    private RoleRepository roleRepository;

    private static final BigDecimal SEUIL_N2 = new BigDecimal("1000000");

    
    // 1. CRUD Basique
    public List<Devis> findAll() {
        return devisRepository.findAll();
    }
    
    public Optional<Devis> findById(Integer id) {
        return devisRepository.findById(id);
    }
    
    public Devis save(Devis devis) {
        return devisRepository.save(devis);
    }
    
    public void deleteById(Integer id) {
        devisRepository.deleteById(id);
    }
    
    // 2. Méthodes Spécifiques
    public Optional<Devis> findByNumeroDevis(String numeroDevis) {
        return devisRepository.findByNumeroDevis(numeroDevis);
    }
    
    public List<Devis> findByStatut(String statut) {
        return devisRepository.findByStatut(statut);
    }
    
    // 3. LOGIQUE MÉTIER (CRITIQUE) - Ces méthodes vont dans le Service
    
    public Devis creerDevisAvecLignes(Integer idClient, Integer idCommercial, 
                                      LocalDate dateValidite, String notes,
                                      List<Object[]> lignesDevis) {
        // Récupérer les entités
        Client client = clientRepository.findById(idClient)
            .orElseThrow(() -> new RuntimeException("Client non trouvé"));
        
        Utilisateur commercial = utilisateurRepository.findById(idCommercial)
            .orElseThrow(() -> new RuntimeException("Commercial non trouvé"));
                // Enrichir le commercial avec son rôle
        enrichirAvecRole(commercial);
                // Vérifier les droits
        if (!"COMMERCIAL".equals(commercial.getRole().getNomRole())) {
            throw new RuntimeException("Seuls les commerciaux peuvent créer des devis");
        }
        
        // Créer le devis
        Devis devis = new Devis();
        devis.setNumeroDevis(genererNumeroDevis());
        devis.setIdClient(client.getIdClient());
        devis.setIdCommercial(commercial.getIdUtilisateur());
        devis.setDateDevis(LocalDateTime.now());
        devis.setDateValidite(dateValidite);
        devis.setNotes(notes);
        devis.setStatut("A_VALIDER");
        devis.setCreatedBy(commercial.getIdUtilisateur());
        devis.setCreatedAt(LocalDateTime.now());

        devis.setIdValidateur(null);
        devis.setDateValidation(null);
        
        // Ajouter les lignes
        BigDecimal totalHt = BigDecimal.ZERO;
        BigDecimal totalTva = BigDecimal.ZERO;
        List<LigneDevis> lignes = new ArrayList<>();
        
        for (Object[] ligneData : lignesDevis) {
            Integer idArticle = (Integer) ligneData[0];
            Integer quantite = (Integer) ligneData[1];
            BigDecimal prixUnitaire = new BigDecimal(ligneData[2].toString());
            BigDecimal remise = new BigDecimal(ligneData[3].toString());
            BigDecimal tvaTaux = new BigDecimal(ligneData[4].toString());
            
            Article article = articleRepository.findById(idArticle)
                .orElseThrow(() -> new RuntimeException("Article non trouvé: " + idArticle));
            
            LigneDevis ligne = new LigneDevis();
            ligne.setDevis(devis);
            ligne.setArticle(article);
            ligne.setQuantite(quantite);
            ligne.setPrixUnitaireHt(prixUnitaire);
            ligne.setRemise(remise);
            ligne.setTvaTaux(tvaTaux);
            
            // Calculer les montants
            BigDecimal montantHt = prixUnitaire
                .multiply(BigDecimal.valueOf(quantite))
                .multiply(BigDecimal.ONE.subtract(remise.divide(BigDecimal.valueOf(100))));
            
            BigDecimal montantTva = montantHt.multiply(tvaTaux.divide(BigDecimal.valueOf(100)));
            
            ligne.setMontantHt(montantHt);
            ligne.setMontantTtc(montantHt.add(montantTva));
            
            lignes.add(ligne);
            totalHt = totalHt.add(montantHt);
            totalTva = totalTva.add(montantTva);
        }
        
        // Calculer les totaux
        devis.setMontantTotalHt(totalHt);
        devis.setMontantTva(totalTva);
        devis.setMontantTtc(totalHt.add(totalTva));
        
        // Sauvegarder le devis avec cascade
        devis.setLignes(lignes);
        return devisRepository.save(devis);
    }
    
    public Devis ajouterLigneDevis(Integer idDevis, Integer idArticle, 
                                  Integer quantite, BigDecimal prixUnitaire, 
                                  BigDecimal remise, BigDecimal tvaTaux) {
        Devis devis = devisRepository.findById(idDevis)
            .orElseThrow(() -> new RuntimeException("Devis non trouvé"));
        
        if (!"BROUILLON".equals(devis.getStatut())) {
            throw new RuntimeException("Seuls les devis brouillons peuvent être modifiés");
        }
        
        Article article = articleRepository.findById(idArticle)
            .orElseThrow(() -> new RuntimeException("Article non trouvé"));
        
        LigneDevis ligne = new LigneDevis();
        ligne.setDevis(devis);
        ligne.setArticle(article);
        ligne.setQuantite(quantite);
        ligne.setPrixUnitaireHt(prixUnitaire);
        ligne.setRemise(remise);
        ligne.setTvaTaux(tvaTaux);
        
        // Calculer les montants
        BigDecimal montantHt = prixUnitaire
            .multiply(BigDecimal.valueOf(quantite))
            .multiply(BigDecimal.ONE.subtract(remise.divide(BigDecimal.valueOf(100))));
        
        BigDecimal montantTva = montantHt.multiply(tvaTaux.divide(BigDecimal.valueOf(100)));
        
        ligne.setMontantHt(montantHt);
        ligne.setMontantTtc(montantHt.add(montantTva));
        
        // Mettre à jour les totaux du devis
        devis.setMontantTotalHt(devis.getMontantTotalHt().add(montantHt));
        devis.setMontantTva(devis.getMontantTva().add(montantTva));
        devis.setMontantTtc(devis.getMontantTtc().add(montantHt.add(montantTva)));
        
        ligneDevisRepository.save(ligne);
        return devisRepository.save(devis);
    }
    
    
    public Devis envoyerDevis(Integer idDevis) {
        Devis devis = devisRepository.findById(idDevis)
            .orElseThrow(() -> new RuntimeException("Devis non trouvé"));
        
        if (!"VALIDE".equals(devis.getStatut())) {
            throw new RuntimeException("Seuls les devis validés peuvent être envoyés");
        }
        
        devis.setStatut("ENVOYE");
        return devisRepository.save(devis);
    }
    
    // 4. Méthodes utilitaires privées
    private String genererNumeroDevis() {
        String annee = String.valueOf(LocalDate.now().getYear());
        String prefix = "DEV-" + annee + "-";
        
        Optional<String> dernierNumero = devisRepository.findLastNumeroDevis(prefix);
        
        if (dernierNumero.isPresent()) {
            String dernier = dernierNumero.get();
            int dernierNum = Integer.parseInt(dernier.substring(dernier.lastIndexOf('-') + 1));
            return prefix + String.format("%04d", dernierNum + 1);
        } else {
            return prefix + "0001";
        }
    }
    
    private void enrichirAvecRole(Utilisateur utilisateur) {
        if (utilisateur.getIdRole() != null) {
            roleRepository.findById(utilisateur.getIdRole()).ifPresent(utilisateur::setRole);
        }
    }

    @Transactional
    public void validerDevis(Integer idDevis, Utilisateur validateur) {

        Devis devis = devisRepository.findById(idDevis)
                .orElseThrow(() -> new RuntimeException("Devis introuvable"));

        // Séparation des tâches
        if (devis.getCreatedBy() != null &&
            devis.getCreatedBy().equals(validateur.getIdUtilisateur())) {
            throw new RuntimeException("Vous ne pouvez pas valider votre propre devis.");
        }

        // Charger rôle si nécessaire
        enrichirAvecRole(validateur);

        BigDecimal montant = devis.getMontantTtc();
        boolean besoinN2 = montant.compareTo(SEUIL_N2) > 0;

        Integer roleId = validateur.getRole().getIdRole();

        // ROLE IDS :
        // 1 = ADMIN
        // 3 = VALIDEUR_N1
        // 4 = VALIDEUR_N2

        if (besoinN2) {
            if (roleId != 1 && roleId != 4) {
                throw new RuntimeException("Validation N2 requise pour ce devis.");
            }
            devis.setStatut("ACCEPTE");
        } else {
            if (roleId != 1 && roleId != 3) {
                throw new RuntimeException("Validation N1 requise pour ce devis.");
            }
            devis.setStatut("ACCEPTE");
            devis.setIdValidateur(validateur.getIdUtilisateur());
            devis.setDateValidation(LocalDateTime.now());

            devisRepository.save(devis);

        }
    }

    public List<Devis> findByStatuts(List<String> statuts) {
        return devisRepository.findByStatutIn(statuts);
    }

    @Transactional
    public void refuserDevis(Integer idDevis, Utilisateur user, String motif) {

        Devis devis = devisRepository.findById(idDevis)
                .orElseThrow(() -> new RuntimeException("Devis introuvable"));

        enrichirAvecRole(user);

        Integer roleId = user.getRole().getIdRole();
        if (roleId != 1 && roleId != 3 && roleId != 4) {
            throw new RuntimeException("Vous n'avez pas le droit de refuser un devis.");
        }

        devis.setStatut("REFUSE");
        devis.setIdValidateur(user.getIdUtilisateur());
        devis.setDateValidation(LocalDateTime.now());

        devisRepository.save(devis);


        // (Plus tard tu pourras enregistrer le motif dans une table d'audit)
    }

    public List<Devis> findAllEnrichi() {
    List<Devis> devisList = devisRepository.findAll();

    for (Devis devis : devisList) {
        if (devis.getIdValidateur() != null) {
            utilisateurRepository.findById(devis.getIdValidateur())
                .ifPresent(devis::setCreatedByUser); // ou créer setValidateurUser
        }
    }
    return devisList;
}

}
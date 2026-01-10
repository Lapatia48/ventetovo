package service;

import entity.Article;
import entity.BonCommande;
import entity.LigneBonCommande;
import repository.LigneBonCommandeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class LigneBonCommandeService {

    @Autowired
    private LigneBonCommandeRepository ligneBonCommandeRepository;

    public List<LigneBonCommande> findAll() {
        return ligneBonCommandeRepository.findAll();
    }

    public Optional<LigneBonCommande> findById(Long id) {
        return ligneBonCommandeRepository.findById(id);
    }

    public LigneBonCommande save(LigneBonCommande ligneBonCommande) {
        // Validation de base
        if (ligneBonCommande.getQuantite() == null || ligneBonCommande.getQuantite() <= 0) {
            throw new IllegalArgumentException("La quantité doit être supérieure à 0");
        }
        if (ligneBonCommande.getPrixUnitaire() == null || ligneBonCommande.getPrixUnitaire().compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Le prix unitaire doit être supérieur à 0");
        }
        if (ligneBonCommande.getBonCommande() == null) {
            throw new IllegalArgumentException("Le bon de commande est obligatoire");
        }
        if (ligneBonCommande.getArticle() == null) {
            throw new IllegalArgumentException("L'article est obligatoire");
        }
        return ligneBonCommandeRepository.save(ligneBonCommande);
    }

    public void deleteById(Long id) {
        ligneBonCommandeRepository.deleteById(id);
    }

    // Méthodes métier spécifiques
    public List<LigneBonCommande> findByBonCommande(BonCommande bonCommande) {
        return ligneBonCommandeRepository.findByBonCommande(bonCommande);
    }

    public List<LigneBonCommande> findByArticle(Article article) {
        return ligneBonCommandeRepository.findByArticle(article);
    }

    public List<LigneBonCommande> findByBonCommandeAndArticle(BonCommande bonCommande, Article article) {
        return ligneBonCommandeRepository.findByBonCommandeAndArticle(bonCommande, article);
    }

    public Long getTotalQuantiteByBonCommande(BonCommande bonCommande) {
        Long total = ligneBonCommandeRepository.sumQuantiteByBonCommande(bonCommande);
        return total != null ? total : 0L;
    }

    public BigDecimal getTotalMontantByBonCommande(BonCommande bonCommande) {
        BigDecimal total = ligneBonCommandeRepository.sumMontantTotalByBonCommande(bonCommande);
        return total != null ? total : BigDecimal.ZERO;
    }

    public List<LigneBonCommande> findByBonCommandeIdOrderByIdLigne(Long idCommande) {
        return ligneBonCommandeRepository.findByBonCommandeIdOrderByIdLigne(idCommande);
    }

    public boolean existsByBonCommandeAndArticle(BonCommande bonCommande, Article article) {
        return ligneBonCommandeRepository.existsByBonCommandeAndArticle(bonCommande, article);
    }

    // Méthode pour ajouter une ligne à un bon de commande
    public LigneBonCommande ajouterLigne(BonCommande bonCommande, Article article, Integer quantite, BigDecimal prixUnitaire) {
        // Vérifier si l'article existe déjà dans le bon de commande
        if (existsByBonCommandeAndArticle(bonCommande, article)) {
            throw new IllegalArgumentException("Cet article est déjà présent dans le bon de commande");
        }

        LigneBonCommande ligne = new LigneBonCommande(bonCommande, article, quantite, prixUnitaire);
        return save(ligne);
    }

    // Méthode pour modifier la quantité d'une ligne
    public LigneBonCommande modifierQuantite(Long idLigne, Integer nouvelleQuantite) {
        Optional<LigneBonCommande> ligneOpt = findById(idLigne);
        if (ligneOpt.isEmpty()) {
            throw new IllegalArgumentException("Ligne de bon de commande non trouvée");
        }

        LigneBonCommande ligne = ligneOpt.get();
        ligne.setQuantite(nouvelleQuantite);
        return save(ligne);
    }

    // Méthode pour modifier le prix unitaire d'une ligne
    public LigneBonCommande modifierPrixUnitaire(Long idLigne, BigDecimal nouveauPrix) {
        Optional<LigneBonCommande> ligneOpt = findById(idLigne);
        if (ligneOpt.isEmpty()) {
            throw new IllegalArgumentException("Ligne de bon de commande non trouvée");
        }

        LigneBonCommande ligne = ligneOpt.get();
        ligne.setPrixUnitaire(nouveauPrix);
        return save(ligne);
    }

    // Méthode pour supprimer toutes les lignes d'un bon de commande
    public void supprimerLignesParBonCommande(BonCommande bonCommande) {
        List<LigneBonCommande> lignes = findByBonCommande(bonCommande);
        ligneBonCommandeRepository.deleteAll(lignes);
    }
}
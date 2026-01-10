package service;

import entity.Article;
import entity.DemandeAchat;
import entity.LigneDemandeAchat;
import repository.LigneDemandeAchatRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class LigneDemandeAchatService {

    @Autowired
    private LigneDemandeAchatRepository ligneDemandeAchatRepository;

    public List<LigneDemandeAchat> findAll() {
        return ligneDemandeAchatRepository.findAll();
    }

    public Optional<LigneDemandeAchat> findById(Long id) {
        return ligneDemandeAchatRepository.findById(id);
    }

    public LigneDemandeAchat save(LigneDemandeAchat ligneDemandeAchat) {
        // Validation de base
        if (ligneDemandeAchat.getQuantite() == null || ligneDemandeAchat.getQuantite() <= 0) {
            throw new IllegalArgumentException("La quantité doit être supérieure à 0");
        }
        if (ligneDemandeAchat.getDemande() == null) {
            throw new IllegalArgumentException("La demande d'achat est obligatoire");
        }
        if (ligneDemandeAchat.getArticle() == null) {
            throw new IllegalArgumentException("L'article est obligatoire");
        }
        return ligneDemandeAchatRepository.save(ligneDemandeAchat);
    }

    public void deleteById(Long id) {
        ligneDemandeAchatRepository.deleteById(id);
    }

    // Méthodes métier spécifiques
    public List<LigneDemandeAchat> findByDemande(DemandeAchat demande) {
        return ligneDemandeAchatRepository.findByDemande(demande);
    }

    public List<LigneDemandeAchat> findByArticle(Article article) {
        return ligneDemandeAchatRepository.findByArticle(article);
    }

    public List<LigneDemandeAchat> findByDemandeAndArticle(DemandeAchat demande, Article article) {
        return ligneDemandeAchatRepository.findByDemandeAndArticle(demande, article);
    }

    public Long getTotalQuantiteByDemande(DemandeAchat demande) {
        Long total = ligneDemandeAchatRepository.sumQuantiteByDemande(demande);
        return total != null ? total : 0L;
    }

    public List<LigneDemandeAchat> findByDemandeIdOrderByIdLigne(Long idDemande) {
        return ligneDemandeAchatRepository.findByDemandeIdOrderByIdLigne(idDemande);
    }

    public boolean existsByDemandeAndArticle(DemandeAchat demande, Article article) {
        return ligneDemandeAchatRepository.existsByDemandeAndArticle(demande, article);
    }

    // Méthode pour ajouter une ligne à une demande
    public LigneDemandeAchat ajouterLigne(DemandeAchat demande, Article article, Integer quantite) {
        // Vérifier si l'article existe déjà dans la demande
        if (existsByDemandeAndArticle(demande, article)) {
            throw new IllegalArgumentException("Cet article est déjà présent dans la demande d'achat");
        }

        LigneDemandeAchat ligne = new LigneDemandeAchat(demande, article, quantite);
        return save(ligne);
    }

    // Méthode pour modifier la quantité d'une ligne
    public LigneDemandeAchat modifierQuantite(Long idLigne, Integer nouvelleQuantite) {
        Optional<LigneDemandeAchat> ligneOpt = findById(idLigne);
        if (ligneOpt.isEmpty()) {
            throw new IllegalArgumentException("Ligne de demande d'achat non trouvée");
        }

        LigneDemandeAchat ligne = ligneOpt.get();
        ligne.setQuantite(nouvelleQuantite);
        return save(ligne);
    }

    // Méthode pour supprimer toutes les lignes d'une demande
    public void supprimerLignesParDemande(DemandeAchat demande) {
        List<LigneDemandeAchat> lignes = findByDemande(demande);
        ligneDemandeAchatRepository.deleteAll(lignes);
    }
}
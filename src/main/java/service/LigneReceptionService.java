package service;

import entity.Article;
import entity.LigneReception;
import entity.Reception;
import repository.LigneReceptionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class LigneReceptionService {

    @Autowired
    private LigneReceptionRepository ligneReceptionRepository;

    public List<LigneReception> findAll() {
        return ligneReceptionRepository.findAll();
    }

    public Optional<LigneReception> findById(Long id) {
        return ligneReceptionRepository.findById(id);
    }

    public LigneReception save(LigneReception ligneReception) {
        // Validation de base
        if (ligneReception.getQuantiteCommandee() == null || ligneReception.getQuantiteCommandee() < 0) {
            throw new IllegalArgumentException("La quantité commandée doit être positive ou nulle");
        }
        if (ligneReception.getQuantiteRecue() == null || ligneReception.getQuantiteRecue() < 0) {
            throw new IllegalArgumentException("La quantité reçue doit être positive ou nulle");
        }
        if (ligneReception.getReception() == null) {
            throw new IllegalArgumentException("La réception est obligatoire");
        }
        if (ligneReception.getArticle() == null) {
            throw new IllegalArgumentException("L'article est obligatoire");
        }
        return ligneReceptionRepository.save(ligneReception);
    }

    public void deleteById(Long id) {
        ligneReceptionRepository.deleteById(id);
    }

    // Méthodes métier spécifiques
    public List<LigneReception> findByReception(Reception reception) {
        return ligneReceptionRepository.findByReception(reception);
    }

    public List<LigneReception> findByArticle(Article article) {
        return ligneReceptionRepository.findByArticle(article);
    }

    public List<LigneReception> findByReceptionAndArticle(Reception reception, Article article) {
        return ligneReceptionRepository.findByReceptionAndArticle(reception, article);
    }

    public Long getTotalQuantiteRecueByReception(Reception reception) {
        Long total = ligneReceptionRepository.sumQuantiteRecueByReception(reception);
        return total != null ? total : 0L;
    }

    public List<LigneReception> findByReceptionIdOrderByIdLigne(Long idReception) {
        return ligneReceptionRepository.findByReceptionIdOrderByIdLigne(idReception);
    }

    public boolean existsByReceptionAndArticle(Reception reception, Article article) {
        return ligneReceptionRepository.existsByReceptionAndArticle(reception, article);
    }

    // Méthode pour ajouter une ligne à une réception
    public LigneReception ajouterLigne(Reception reception, Article article, Integer quantiteCommandee, Integer quantiteRecue) {
        // Vérifier si l'article existe déjà dans la réception
        if (existsByReceptionAndArticle(reception, article)) {
            throw new IllegalArgumentException("Cet article est déjà présent dans la réception");
        }

        LigneReception ligne = new LigneReception(reception, article, quantiteCommandee, quantiteRecue);
        return save(ligne);
    }

    // Méthode pour modifier la quantité reçue
    public LigneReception modifierQuantiteRecue(Long idLigne, Integer nouvelleQuantiteRecue) {
        Optional<LigneReception> ligneOpt = findById(idLigne);
        if (ligneOpt.isEmpty()) {
            throw new IllegalArgumentException("Ligne de réception non trouvée");
        }

        LigneReception ligne = ligneOpt.get();
        ligne.setQuantiteRecue(nouvelleQuantiteRecue);
        return save(ligne);
    }

    // Méthode pour supprimer toutes les lignes d'une réception
    public void supprimerLignesParReception(Reception reception) {
        List<LigneReception> lignes = findByReception(reception);
        ligneReceptionRepository.deleteAll(lignes);
    }
}
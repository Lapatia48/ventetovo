package service;

import entity.BonCommande;
import entity.Reception;
import entity.Utilisateur;
import repository.ReceptionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class ReceptionService {

    @Autowired
    private ReceptionRepository receptionRepository;

    public List<Reception> findAll() {
        return receptionRepository.findAll();
    }

    public Optional<Reception> findById(Long id) {
        return receptionRepository.findById(id);
    }

    public Optional<Reception> findByNumero(String numero) {
        return receptionRepository.findByNumero(numero);
    }

    public Reception save(Reception reception) {
        // Validation de base
        if (reception.getNumero() == null || reception.getNumero().trim().isEmpty()) {
            throw new IllegalArgumentException("Le numéro de réception est obligatoire");
        }
        if (reception.getCommande() == null) {
            throw new IllegalArgumentException("Le bon de commande est obligatoire");
        }
        if (reception.getReceptionnaire() == null) {
            throw new IllegalArgumentException("Le réceptionnaire est obligatoire");
        }

        // Vérifier l'unicité du numéro
        if (reception.getIdReception() == null && existsByNumero(reception.getNumero())) {
            throw new IllegalArgumentException("Une réception avec ce numéro existe déjà");
        }

        return receptionRepository.save(reception);
    }

    public void deleteById(Long id) {
        receptionRepository.deleteById(id);
    }

    public boolean existsByNumero(String numero) {
        return receptionRepository.existsByNumero(numero);
    }

    // Méthodes métier spécifiques
    public List<Reception> findByCommande(BonCommande commande) {
        return receptionRepository.findByCommande(commande);
    }

    public List<Reception> findByReceptionnaire(Utilisateur receptionnaire) {
        return receptionRepository.findByReceptionnaire(receptionnaire);
    }

    public List<Reception> findByStatut(String statut) {
        return receptionRepository.findByStatut(statut);
    }

    public List<Reception> findByDateReceptionBetween(LocalDate dateDebut, LocalDate dateFin) {
        return receptionRepository.findByDateReceptionBetween(dateDebut, dateFin);
    }

    public List<Reception> findByCommandeAndStatut(BonCommande commande, String statut) {
        return receptionRepository.findByCommandeAndStatut(commande, statut);
    }

    public List<Reception> findByReceptionnaireAndStatut(Utilisateur receptionnaire, String statut) {
        return receptionRepository.findByReceptionnaireAndStatut(receptionnaire, statut);
    }

    public List<Reception> findByFournisseurId(Long idFournisseur) {
        return receptionRepository.findByFournisseurId(idFournisseur);
    }

    public long countByStatut(String statut) {
        return receptionRepository.countByStatut(statut);
    }

    public List<Reception> findByCommandeOrderByDateReceptionDesc(BonCommande commande) {
        return receptionRepository.findByCommandeOrderByDateReceptionDesc(commande);
    }

    // Méthodes de workflow
    public Reception marquerCommeConforme(Long idReception) {
        Optional<Reception> receptionOpt = findById(idReception);
        if (receptionOpt.isEmpty()) {
            throw new IllegalArgumentException("Réception non trouvée");
        }

        Reception reception = receptionOpt.get();
        reception.setStatut("CONFORME");
        return save(reception);
    }

    public Reception marquerCommeNonConforme(Long idReception) {
        Optional<Reception> receptionOpt = findById(idReception);
        if (receptionOpt.isEmpty()) {
            throw new IllegalArgumentException("Réception non trouvée");
        }

        Reception reception = receptionOpt.get();
        reception.setStatut("NON_CONFORME");
        return save(reception);
    }

    // Méthode pour vérifier si une commande a été entièrement réceptionnée
    public boolean estCommandeEntierementRecue(BonCommande commande) {
        List<Reception> receptions = findByCommande(commande);
        // Logique simplifiée : si au moins une réception existe et est conforme, considérer comme reçue
        return receptions.stream().anyMatch(r -> "CONFORME".equals(r.getStatut()));
    }
}
package service;

import entity.DemandeAchat;
import entity.Utilisateur;
import repository.DemandeAchatRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class DemandeAchatService {

    @Autowired
    private DemandeAchatRepository demandeAchatRepository;

    public List<DemandeAchat> findAll() {
        return demandeAchatRepository.findAll();
    }

    public Optional<DemandeAchat> findById(Long id) {
        return demandeAchatRepository.findById(id);
    }

    public Optional<DemandeAchat> findByNumero(String numero) {
        return demandeAchatRepository.findByNumero(numero);
    }

    public DemandeAchat save(DemandeAchat demandeAchat) {
        // Vérification de la règle métier : pas d'auto-validation
        if (demandeAchat.getValideur() != null &&
            demandeAchat.getValideur().getIdUtilisateur().equals(demandeAchat.getDemandeur().getIdUtilisateur())) {
            throw new IllegalArgumentException("Un utilisateur ne peut pas valider sa propre demande d'achat");
        }
        return demandeAchatRepository.save(demandeAchat);
    }

    public void deleteById(Long id) {
        demandeAchatRepository.deleteById(id);
    }

    public boolean existsByNumero(String numero) {
        return demandeAchatRepository.existsByNumero(numero);
    }

    // Méthodes métier spécifiques
    public List<DemandeAchat> findByDemandeur(Utilisateur demandeur) {
        return demandeAchatRepository.findByDemandeur(demandeur);
    }

    public List<DemandeAchat> findByValideur(Utilisateur valideur) {
        return demandeAchatRepository.findByValideur(valideur);
    }

    public List<DemandeAchat> findByStatut(String statut) {
        return demandeAchatRepository.findByStatut(statut);
    }

    public List<DemandeAchat> findByDateDemandeBetween(LocalDate dateDebut, LocalDate dateFin) {
        return demandeAchatRepository.findByDateDemandeBetween(dateDebut, dateFin);
    }

    public List<DemandeAchat> findByDemandeurAndStatut(Utilisateur demandeur, String statut) {
        return demandeAchatRepository.findByDemandeurAndStatut(demandeur, statut);
    }

    public List<DemandeAchat> findByValideurAndStatut(Utilisateur valideur, String statut) {
        return demandeAchatRepository.findByValideurAndStatut(valideur, statut);
    }

    public long countByStatut(String statut) {
        return demandeAchatRepository.countByStatut(statut);
    }

    // Méthodes de validation
    public DemandeAchat validerDemande(Long idDemande, Utilisateur valideur, String commentaire) {
        Optional<DemandeAchat> demandeOpt = demandeAchatRepository.findById(idDemande);
        if (demandeOpt.isEmpty()) {
            throw new IllegalArgumentException("Demande d'achat non trouvée");
        }

        DemandeAchat demande = demandeOpt.get();

        // Vérification que ce n'est pas une auto-validation
        if (valideur.getIdUtilisateur().equals(demande.getDemandeur().getIdUtilisateur())) {
            throw new IllegalArgumentException("Un utilisateur ne peut pas valider sa propre demande d'achat");
        }

        demande.setValideur(valideur);
        demande.setStatut("VALIDE");
        demande.setDateValidation(LocalDateTime.now());
        demande.setCommentaire(commentaire);

        return demandeAchatRepository.save(demande);
    }

    public DemandeAchat rejeterDemande(Long idDemande, Utilisateur valideur, String commentaire) {
        Optional<DemandeAchat> demandeOpt = demandeAchatRepository.findById(idDemande);
        if (demandeOpt.isEmpty()) {
            throw new IllegalArgumentException("Demande d'achat non trouvée");
        }

        DemandeAchat demande = demandeOpt.get();

        // Vérification que ce n'est pas une auto-validation
        if (valideur.getIdUtilisateur().equals(demande.getDemandeur().getIdUtilisateur())) {
            throw new IllegalArgumentException("Un utilisateur ne peut pas valider sa propre demande d'achat");
        }

        demande.setValideur(valideur);
        demande.setStatut("REJETE");
        demande.setDateValidation(LocalDateTime.now());
        demande.setCommentaire(commentaire);

        return demandeAchatRepository.save(demande);
    }
}
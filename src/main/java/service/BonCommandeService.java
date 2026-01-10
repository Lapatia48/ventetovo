package service;

import entity.BonCommande;
import entity.DemandeAchat;
import entity.Fournisseur;
import repository.BonCommandeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class BonCommandeService {

    @Autowired
    private BonCommandeRepository bonCommandeRepository;

    public List<BonCommande> findAll() {
        return bonCommandeRepository.findAll();
    }

    public Optional<BonCommande> findById(Long id) {
        return bonCommandeRepository.findById(id);
    }

    public Optional<BonCommande> findByNumero(String numero) {
        return bonCommandeRepository.findByNumero(numero);
    }

    public BonCommande save(BonCommande bonCommande) {
        // Validation de base
        if (bonCommande.getNumero() == null || bonCommande.getNumero().trim().isEmpty()) {
            throw new IllegalArgumentException("Le numéro du bon de commande est obligatoire");
        }
        if (bonCommande.getDemande() == null) {
            throw new IllegalArgumentException("La demande d'achat est obligatoire");
        }
        if (bonCommande.getFournisseur() == null) {
            throw new IllegalArgumentException("Le fournisseur est obligatoire");
        }
        if (bonCommande.getMontantTotal() == null || bonCommande.getMontantTotal().compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Le montant total doit être supérieur à 0");
        }

        // Vérifier l'unicité du numéro
        if (bonCommande.getIdCommande() == null && existsByNumero(bonCommande.getNumero())) {
            throw new IllegalArgumentException("Un bon de commande avec ce numéro existe déjà");
        }

        return bonCommandeRepository.save(bonCommande);
    }

    public void deleteById(Long id) {
        bonCommandeRepository.deleteById(id);
    }

    public boolean existsByNumero(String numero) {
        return bonCommandeRepository.existsByNumero(numero);
    }

    // Méthodes métier spécifiques
    public List<BonCommande> findByDemande(DemandeAchat demande) {
        return bonCommandeRepository.findByDemande(demande);
    }

    public List<BonCommande> findByFournisseur(Fournisseur fournisseur) {
        return bonCommandeRepository.findByFournisseur(fournisseur);
    }

    public List<BonCommande> findByStatut(String statut) {
        return bonCommandeRepository.findByStatut(statut);
    }

    public List<BonCommande> findByDateCommandeBetween(LocalDate dateDebut, LocalDate dateFin) {
        return bonCommandeRepository.findByDateCommandeBetween(dateDebut, dateFin);
    }

    public List<BonCommande> findByDemandeAndStatut(DemandeAchat demande, String statut) {
        return bonCommandeRepository.findByDemandeAndStatut(demande, statut);
    }

    public List<BonCommande> findByFournisseurAndStatut(Fournisseur fournisseur, String statut) {
        return bonCommandeRepository.findByFournisseurAndStatut(fournisseur, statut);
    }

    public BigDecimal getTotalMontantByStatut(String statut) {
        BigDecimal total = bonCommandeRepository.sumMontantTotalByStatut(statut);
        return total != null ? total : BigDecimal.ZERO;
    }

    public List<BonCommande> findRecentByFournisseur(Fournisseur fournisseur, LocalDate dateDebut) {
        return bonCommandeRepository.findRecentByFournisseur(fournisseur, dateDebut);
    }

    public long countByStatut(String statut) {
        return bonCommandeRepository.countByStatut(statut);
    }

    // Méthodes de workflow
    public BonCommande annulerBonCommande(Long idBonCommande) {
        Optional<BonCommande> bonCommandeOpt = findById(idBonCommande);
        if (bonCommandeOpt.isEmpty()) {
            throw new IllegalArgumentException("Bon de commande non trouvé");
        }

        BonCommande bonCommande = bonCommandeOpt.get();
        if (!"EN_COURS".equals(bonCommande.getStatut())) {
            throw new IllegalArgumentException("Seuls les bons de commande en cours peuvent être annulés");
        }

        bonCommande.setStatut("ANNULE");
        return save(bonCommande);
    }

    public BonCommande receptionnerBonCommande(Long idBonCommande) {
        Optional<BonCommande> bonCommandeOpt = findById(idBonCommande);
        if (bonCommandeOpt.isEmpty()) {
            throw new IllegalArgumentException("Bon de commande non trouvé");
        }

        BonCommande bonCommande = bonCommandeOpt.get();
        if (!"EN_COURS".equals(bonCommande.getStatut())) {
            throw new IllegalArgumentException("Seuls les bons de commande en cours peuvent être réceptionnés");
        }

        bonCommande.setStatut("RECEPTIONNE");
        return save(bonCommande);
    }
}
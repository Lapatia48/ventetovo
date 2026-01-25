package service;

import entity.FactureClient;
import entity.FactureReglement;
import entity.ReglementClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import repository.FactureClientRepository;
import repository.FactureReglementRepository;
import repository.ReglementClientRepository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class ReglementClientService {

    @Autowired
    private ReglementClientRepository reglementRepository;
    @Autowired
    private FactureClientRepository factureRepository;
    @Autowired
    private FactureReglementRepository factureReglementRepository;

    public void encaisserFacture(
            Integer idFacture,
            BigDecimal montant,
            String modePaiement,
            Integer idUtilisateur
    ) {

        FactureClient facture = factureRepository.findById(idFacture)
                .orElseThrow(() -> new RuntimeException("Facture introuvable"));

        if (!"ENVOYEE".equals(facture.getStatut())
            && !"PARTIELLEMENT_PAYEE".equals(facture.getStatut())) {
            throw new RuntimeException("Facture non encaissable");
        }

        if (montant.compareTo(BigDecimal.ZERO) <= 0) {
            throw new RuntimeException("Montant invalide");
        }

        if (montant.compareTo(facture.getSoldeRestant()) > 0) {
            throw new RuntimeException("Le montant dépasse le solde restant");
        }

        // 1️⃣ Création règlement
        ReglementClient reglement = new ReglementClient();
        reglement.setNumeroReglement("REG-" + System.currentTimeMillis());
        reglement.setIdClient(facture.getIdClient());
        reglement.setDateReglement(LocalDate.now());
        reglement.setModeReglement(modePaiement);
        reglement.setMontant(montant);
        reglement.setStatut("ENCAISSE");
        reglement.setCreatedBy(idUtilisateur);

        reglement = reglementRepository.save(reglement);

        // 2️⃣ Lien facture ↔ règlement
        FactureReglement fr = new FactureReglement();
        fr.setIdFacture(idFacture);
        fr.setIdReglement(reglement.getIdReglement());
        fr.setMontantAffecte(montant);

        factureReglementRepository.save(fr);

        // 3️⃣ Mise à jour facture
        BigDecimal nouveauPaye =
                facture.getMontantPaye().add(montant);

        facture.setMontantPaye(nouveauPaye);

        // ✅ La base calcule automatiquement solde_restant

        if (nouveauPaye.compareTo(facture.getMontantTtc()) >= 0) {
            facture.setStatut("PAYEE");
        } else {
            facture.setStatut("PARTIELLEMENT_PAYEE");
        }

        factureRepository.save(facture);

    }

    public List<ReglementClient> findAll() {
        return reglementRepository.findAll();
    }

    public Optional<ReglementClient> findById(Integer id) {
        return reglementRepository.findById(id);
    }

    public ReglementClient save(ReglementClient reglement) {
        return reglementRepository.save(reglement);
    }

    public void deleteById(Integer id) {
        reglementRepository.deleteById(id);
    }
}
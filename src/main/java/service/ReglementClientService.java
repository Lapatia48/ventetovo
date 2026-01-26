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
import java.time.LocalDateTime;
import java.util.Optional;

@Service
@Transactional
public class ReglementClientService {

    @Autowired private ReglementClientRepository reglementRepository;
    @Autowired private FactureReglementRepository factureReglementRepository;
    @Autowired private FactureClientRepository factureClientRepository;

    public ReglementClient encaisserFacture(Integer idFacture,
                                            BigDecimal montant,
                                            String modeReglement,
                                            String referencePaiement,
                                            Integer idUtilisateur) {
        if (idFacture == null || montant == null || montant.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Montant invalide");
        }

        FactureClient facture = factureClientRepository.findById(idFacture)
                .orElseThrow(() -> new RuntimeException("Facture introuvable"));

        ReglementClient reglement = new ReglementClient();
        reglement.setNumeroReglement(genererNumeroReglement());
        reglement.setIdClient(facture.getIdClient());
        reglement.setDateReglement(LocalDate.now());
        reglement.setModeReglement(modeReglement);
        reglement.setMontant(montant);
        reglement.setStatut("VALIDE");
        reglement.setReferencePaiement(referencePaiement);
        reglement.setCreatedAt(LocalDateTime.now());
        reglement.setCreatedBy(idUtilisateur);

        reglement = reglementRepository.save(reglement);

        FactureReglement liaison = new FactureReglement();
        liaison.setIdFacture(idFacture);
        liaison.setIdReglement(reglement.getIdReglement());
        liaison.setMontantAffecte(montant);
        liaison.setDateAffectation(LocalDateTime.now());
        factureReglementRepository.save(liaison);

        BigDecimal paye = Optional.ofNullable(facture.getMontantPaye()).orElse(BigDecimal.ZERO);
        BigDecimal nouveauPaye = paye.add(montant);
        facture.setMontantPaye(nouveauPaye);

        BigDecimal totalTtc = Optional.ofNullable(facture.getMontantTtc()).orElse(BigDecimal.ZERO);
        if (totalTtc.compareTo(BigDecimal.ZERO) > 0) {
            if (nouveauPaye.compareTo(totalTtc) >= 0) {
                facture.setStatut("PAYEE");
            } else {
                facture.setStatut("PARTIELLEMENT_PAYEE");
            }
        }

        factureClientRepository.save(facture);

        return reglement;
    }

    private String genererNumeroReglement() {
        return "REG-" + System.currentTimeMillis();
    }
}

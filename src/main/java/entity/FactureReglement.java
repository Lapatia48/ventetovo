package entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "facture_reglement", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"id_facture", "id_reglement"})
})
public class FactureReglement {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_facture_reglement")
    private Integer idFactureReglement;

    @Column(name = "id_facture", nullable = false)
    private Integer idFacture;

    @Column(name = "id_reglement", nullable = false)
    private Integer idReglement;

    @Column(name = "montant_affecte", nullable = false)
    private BigDecimal montantAffecte;

    @Column(name = "date_affectation")
    private LocalDateTime dateAffectation;

    // Getters and Setters

    public Integer getIdFactureReglement() {
        return idFactureReglement;
    }

    public void setIdFactureReglement(Integer idFactureReglement) {
        this.idFactureReglement = idFactureReglement;
    }

    public Integer getIdFacture() {
        return idFacture;
    }

    public void setIdFacture(Integer idFacture) {
        this.idFacture = idFacture;
    }

    public Integer getIdReglement() {
        return idReglement;
    }

    public void setIdReglement(Integer idReglement) {
        this.idReglement = idReglement;
    }

    public BigDecimal getMontantAffecte() {
        return montantAffecte;
    }

    public void setMontantAffecte(BigDecimal montantAffecte) {
        this.montantAffecte = montantAffecte;
    }

    public LocalDateTime getDateAffectation() {
        return dateAffectation;
    }

    public void setDateAffectation(LocalDateTime dateAffectation) {
        this.dateAffectation = dateAffectation;
    }
}
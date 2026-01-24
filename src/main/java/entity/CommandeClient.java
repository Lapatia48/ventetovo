package entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "commande_client")
public class CommandeClient {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_commande")
    private Integer idCommande;

    @Column(name = "numero_commande", nullable = false, unique = true)
    private String numeroCommande;

    @Column(name = "id_devis")
    private Integer idDevis;

    @Column(name = "id_client", nullable = false)
    private Integer idClient;

    @Column(name = "date_commande")
    private LocalDateTime dateCommande;

    @Column(name = "date_livraison_souhaitee")
    private LocalDate dateLivraisonSouhaitee;

    @Column(name = "statut")
    private String statut = "EN_ATTENTE";

    @Column(name = "montant_total_ht", precision = 15, scale = 2)
    private BigDecimal montantTotalHt = BigDecimal.ZERO;

    @Column(name = "montant_total_ttc", precision = 15, scale = 2)
    private BigDecimal montantTotalTtc = BigDecimal.ZERO;

    @Column(name = "id_commercial")
    private Integer idCommercial;

    @Column(name = "id_validateur")
    private Integer idValidateur;

    
    @Column(name = "date_validation")
    private LocalDateTime dateValidation;

    public Integer getIdValidateur() {
        return idValidateur;
    }
    public void setIdValidateur(Integer idValidateur) {
        this.idValidateur = idValidateur;
    }
    public LocalDateTime getDateValidation() {
        return dateValidation;
    }
    public void setDateValidation(LocalDateTime dateValidation) {
        this.dateValidation = dateValidation;
    }


    // Getters / Setters
    public Integer getIdCommande() { return idCommande; }
    public void setIdCommande(Integer idCommande) { this.idCommande = idCommande; }

    public String getNumeroCommande() { return numeroCommande; }
    public void setNumeroCommande(String numeroCommande) { this.numeroCommande = numeroCommande; }

    public Integer getIdDevis() { return idDevis; }
    public void setIdDevis(Integer idDevis) { this.idDevis = idDevis; }

    public Integer getIdClient() { return idClient; }
    public void setIdClient(Integer idClient) { this.idClient = idClient; }

    public LocalDateTime getDateCommande() { return dateCommande; }
    public void setDateCommande(LocalDateTime dateCommande) { this.dateCommande = dateCommande; }

    public LocalDate getDateLivraisonSouhaitee() { return dateLivraisonSouhaitee; }
    public void setDateLivraisonSouhaitee(LocalDate dateLivraisonSouhaitee) {
        this.dateLivraisonSouhaitee = dateLivraisonSouhaitee;
    }

    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }

    public BigDecimal getMontantTotalHt() { return montantTotalHt; }
    public void setMontantTotalHt(BigDecimal montantTotalHt) {
        this.montantTotalHt = montantTotalHt;
    }

    public BigDecimal getMontantTotalTtc() { return montantTotalTtc; }
    public void setMontantTotalTtc(BigDecimal montantTotalTtc) {
        this.montantTotalTtc = montantTotalTtc;
    }

    public Integer getIdCommercial() { return idCommercial; }
    public void setIdCommercial(Integer idCommercial) { this.idCommercial = idCommercial; }
}

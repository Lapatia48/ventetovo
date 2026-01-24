package entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "facture_client")
public class FactureClient {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_facture")
    private Integer idFacture;

    @Column(name = "numero_facture", nullable = false, unique = true)
    private String numeroFacture;

    @Column(name = "id_livraison", nullable = false)
    private Integer idLivraison;

    @Column(name = "id_commande", nullable = false)
    private Integer idCommande;

    @Column(name = "id_client", nullable = false)
    private Integer idClient;

    @Column(name = "date_facture")
    private LocalDate dateFacture;

    @Column(name = "statut")
    private String statut;

    @Column(name = "montant_total_ht")
    private BigDecimal montantTotalHt;

    @Column(name = "montant_tva")
    private BigDecimal montantTva;

    @Column(name = "montant_ttc")
    private BigDecimal montantTtc;

    @Column(name = "montant_paye")
    private BigDecimal montantPaye;

    @Column(name = "mode_paiement")
    private String modePaiement;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "created_by")
    private Integer createdBy;

    @Transient
    private List<LigneFactureClient> lignes;

    /* ================= GETTERS / SETTERS ================= */

    public Integer getIdFacture() { return idFacture; }
    public void setIdFacture(Integer idFacture) { this.idFacture = idFacture; }

    public String getNumeroFacture() { return numeroFacture; }
    public void setNumeroFacture(String numeroFacture) { this.numeroFacture = numeroFacture; }

    public Integer getIdLivraison() { return idLivraison; }
    public void setIdLivraison(Integer idLivraison) { this.idLivraison = idLivraison; }

    public Integer getIdCommande() { return idCommande; }
    public void setIdCommande(Integer idCommande) { this.idCommande = idCommande; }

    public Integer getIdClient() { return idClient; }
    public void setIdClient(Integer idClient) { this.idClient = idClient; }

    public LocalDate getDateFacture() { return dateFacture; }
    public void setDateFacture(LocalDate dateFacture) { this.dateFacture = dateFacture; }

    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }

    public BigDecimal getMontantTotalHt() { return montantTotalHt; }
    public void setMontantTotalHt(BigDecimal montantTotalHt) { this.montantTotalHt = montantTotalHt; }

    public BigDecimal getMontantTva() { return montantTva; }
    public void setMontantTva(BigDecimal montantTva) { this.montantTva = montantTva; }

    public BigDecimal getMontantTtc() { return montantTtc; }
    public void setMontantTtc(BigDecimal montantTtc) { this.montantTtc = montantTtc; }

    public BigDecimal getMontantPaye() { return montantPaye; }
    public void setMontantPaye(BigDecimal montantPaye) { this.montantPaye = montantPaye; }

    public String getModePaiement() { return modePaiement; }
    public void setModePaiement(String modePaiement) { this.modePaiement = modePaiement; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public Integer getCreatedBy() { return createdBy; }
    public void setCreatedBy(Integer createdBy) { this.createdBy = createdBy; }

    public List<LigneFactureClient> getLignes() { return lignes; }
    public void setLignes(List<LigneFactureClient> lignes) { this.lignes = lignes; }
}

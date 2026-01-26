package entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "reglement_client")
public class ReglementClient {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_reglement")
    private Integer idReglement;

    @Column(name = "numero_reglement", nullable = false, unique = true)
    private String numeroReglement;

    @Column(name = "id_client", nullable = false)
    private Integer idClient;

    @Column(name = "date_reglement")
    private LocalDate dateReglement;

    @Column(name = "mode_reglement")
    private String modeReglement;

    @Column(name = "montant", nullable = false)
    private BigDecimal montant;

    @Column(name = "statut")
    private String statut;

    @Column(name = "reference_paiement")
    private String referencePaiement;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "created_by")
    private Integer createdBy;

    public Integer getIdReglement() { return idReglement; }
    public void setIdReglement(Integer idReglement) { this.idReglement = idReglement; }

    public String getNumeroReglement() { return numeroReglement; }
    public void setNumeroReglement(String numeroReglement) { this.numeroReglement = numeroReglement; }

    public Integer getIdClient() { return idClient; }
    public void setIdClient(Integer idClient) { this.idClient = idClient; }

    public LocalDate getDateReglement() { return dateReglement; }
    public void setDateReglement(LocalDate dateReglement) { this.dateReglement = dateReglement; }

    public String getModeReglement() { return modeReglement; }
    public void setModeReglement(String modeReglement) { this.modeReglement = modeReglement; }

    public BigDecimal getMontant() { return montant; }
    public void setMontant(BigDecimal montant) { this.montant = montant; }

    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }

    public String getReferencePaiement() { return referencePaiement; }
    public void setReferencePaiement(String referencePaiement) { this.referencePaiement = referencePaiement; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public Integer getCreatedBy() { return createdBy; }
    public void setCreatedBy(Integer createdBy) { this.createdBy = createdBy; }
}

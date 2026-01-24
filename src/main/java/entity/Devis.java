package entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.Transient;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "devis")
public class Devis {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_devis")
    private Integer idDevis;
    
    @Column(name = "numero_devis", unique = true, nullable = false)
    private String numeroDevis;
    
    @Column(name = "id_client", nullable = false)
    private Integer idClient;
    
    @Column(name = "date_devis")
    private LocalDateTime dateDevis;
    
    @Column(name = "date_validite")
    private LocalDate dateValidite;
    
    @Column(name = "statut")
    private String statut = "BROUILLON";
    
    @Column(name = "montant_total_ht", precision = 15, scale = 2)
    private BigDecimal montantTotalHt = BigDecimal.ZERO;
    
    @Column(name = "montant_tva", precision = 15, scale = 2)
    private BigDecimal montantTva = BigDecimal.ZERO;
    
    @Column(name = "montant_ttc", precision = 15, scale = 2)
    private BigDecimal montantTtc = BigDecimal.ZERO;
    
    @Column(name = "id_commercial", nullable = false)
    private Integer idCommercial;
    
    @Column(name = "notes")
    private String notes;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "created_by")
    private Integer createdBy;

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
    
    
    // Transient pour les jointures
    // @Transient
    // private Client client;
    
    // @Transient
    // private Utilisateur commercial;
    
    @Transient
    private Utilisateur createdByUser;
    
    @Transient
    private List<LigneDevis> lignes;
    
    // Constructeurs
    public Devis() {
        this.dateDevis = LocalDateTime.now();
    }
    
    public Devis(String numeroDevis, Integer idClient, LocalDate dateValidite, Integer idCommercial) {
        this.numeroDevis = numeroDevis;
        this.idClient = idClient;
        this.dateDevis = LocalDateTime.now();
        this.dateValidite = dateValidite;
        this.statut = "BROUILLON";
        this.montantTotalHt = BigDecimal.ZERO;
        this.montantTva = BigDecimal.ZERO;
        this.montantTtc = BigDecimal.ZERO;
        this.idCommercial = idCommercial;
    }

    // Méthode pour calculer les totaux
    public void calculerTotaux() {
        this.montantTotalHt = lignes.stream()
            .map(LigneDevis::getMontantHt)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        this.montantTva = lignes.stream()
            .map(LigneDevis::getMontantTva)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        this.montantTtc = montantTotalHt.add(montantTva);
    }
    
    // Getters et Setters
    public Integer getIdDevis() { return idDevis; }
    public void setIdDevis(Integer idDevis) { this.idDevis = idDevis; }
    
    public String getNumeroDevis() { return numeroDevis; }
    public void setNumeroDevis(String numeroDevis) { this.numeroDevis = numeroDevis; }
    
    public Integer getIdClient() { return idClient; }
    public void setIdClient(Integer idClient) { this.idClient = idClient; }
    
    public LocalDateTime getDateDevis() { return dateDevis; }
    public void setDateDevis(LocalDateTime dateDevis) { this.dateDevis = dateDevis; }
    
    public LocalDate getDateValidite() { return dateValidite; }
    public void setDateValidite(LocalDate dateValidite) { this.dateValidite = dateValidite; }
    
    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }
    
    public BigDecimal getMontantTotalHt() { return montantTotalHt; }
    public void setMontantTotalHt(BigDecimal montantTotalHt) { this.montantTotalHt = montantTotalHt; }
    
    public BigDecimal getMontantTva() { return montantTva; }
    public void setMontantTva(BigDecimal montantTva) { this.montantTva = montantTva; }
    
    public BigDecimal getMontantTtc() { return montantTtc; }
    public void setMontantTtc(BigDecimal montantTtc) { this.montantTtc = montantTtc; }
    
    public Integer getIdCommercial() { return idCommercial; }
    public void setIdCommercial(Integer idCommercial) { this.idCommercial = idCommercial; }
    
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    
    // public Client getClient() { return client; }
    // public void setClient(Client client) { this.client = client; }
    
    // public Utilisateur getCommercial() { return commercial; }
    // public void setCommercial(Utilisateur commercial) { this.commercial = commercial; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public Integer getCreatedBy() { return createdBy; }
    public void setCreatedBy(Integer createdBy) { this.createdBy = createdBy; }
    
    public Utilisateur getCreatedByUser() { return createdByUser; }
    public void setCreatedByUser(Utilisateur createdByUser) { this.createdByUser = createdByUser; }
    
    public List<LigneDevis> getLignes() { return lignes; }
    public void setLignes(List<LigneDevis> lignes) { this.lignes = lignes; }

}
package entity;

import java.time.LocalDate;
import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "proforma_client")
public class ProformaClient {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_proforma_client")
    private Integer idProformaClient;
    
    @Column(name = "numero_proforma", unique = true, nullable = false, length = 50)
    private String numeroProforma;
    
    @Column(name = "id_client", nullable = false)
    private Integer idClient;
    
    @Column(name = "id_article", nullable = false)
    private Integer idArticle;
    
    @Column(name = "quantite", nullable = false)
    private Integer quantite;
    
    @Column(name = "prix_unitaire", nullable = false)
    private Double prixUnitaire;
    
    @Column(name = "id_reduction")
    private Integer idReduction;
    
    @Column(name = "montant_reduction")
    private Double montantReduction;
    
    @Column(name = "montant_total", nullable = false)
    private Double montantTotal;
    
    @Column(name = "date_proforma")
    private LocalDateTime dateProforma;
    
    @Column(name = "date_validite", nullable = false)
    private LocalDate dateValidite;
    
    @Column(name = "statut", length = 20)
    private String statut; // EN_ATTENTE, ACCEPTE, REFUSE, EXPIRE
    
    // Constructeurs
    public ProformaClient() {
        this.dateProforma = LocalDateTime.now();
        this.statut = "EN_ATTENTE";
        this.montantReduction = 0.0;
    }
    
    // Getters et Setters
    public Integer getIdProformaClient() {
        return idProformaClient;
    }
    
    public void setIdProformaClient(Integer idProformaClient) {
        this.idProformaClient = idProformaClient;
    }
    
    public String getNumeroProforma() {
        return numeroProforma;
    }
    
    public void setNumeroProforma(String numeroProforma) {
        this.numeroProforma = numeroProforma;
    }
    
    public Integer getIdClient() {
        return idClient;
    }
    
    public void setIdClient(Integer idClient) {
        this.idClient = idClient;
    }
    
    public Integer getIdArticle() {
        return idArticle;
    }
    
    public void setIdArticle(Integer idArticle) {
        this.idArticle = idArticle;
    }
    
    public Integer getQuantite() {
        return quantite;
    }
    
    public void setQuantite(Integer quantite) {
        this.quantite = quantite;
    }
    
    public Double getPrixUnitaire() {
        return prixUnitaire;
    }
    
    public void setPrixUnitaire(Double prixUnitaire) {
        this.prixUnitaire = prixUnitaire;
    }
    
    public Integer getIdReduction() {
        return idReduction;
    }
    
    public void setIdReduction(Integer idReduction) {
        this.idReduction = idReduction;
    }
    
    public Double getMontantReduction() {
        return montantReduction;
    }
    
    public void setMontantReduction(Double montantReduction) {
        this.montantReduction = montantReduction;
    }
    
    public Double getMontantTotal() {
        return montantTotal;
    }
    
    public void setMontantTotal(Double montantTotal) {
        this.montantTotal = montantTotal;
    }
    
    public LocalDateTime getDateProforma() {
        return dateProforma;
    }
    
    public void setDateProforma(LocalDateTime dateProforma) {
        this.dateProforma = dateProforma;
    }
    
    public LocalDate getDateValidite() {
        return dateValidite;
    }
    
    public void setDateValidite(LocalDate dateValidite) {
        this.dateValidite = dateValidite;
    }
    
    public String getStatut() {
        return statut;
    }
    
    public void setStatut(String statut) {
        this.statut = statut;
    }
    
    // Méthodes utilitaires
    public boolean estExpire() {
        return LocalDate.now().isAfter(dateValidite);
    }
    
    public void calculerMontantTotal() {
        Double montantBrut = prixUnitaire * quantite;
        this.montantTotal = montantBrut - (montantReduction != null ? montantReduction : 0.0);
    }
}

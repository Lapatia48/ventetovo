package entity;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "facture_fournisseur")
public class FactureFournisseur {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_facture")
    private Integer idFacture;
    
    @Column(name = "numero_facture", nullable = false, unique = true)
    private String numeroFacture;
    
    @Column(name = "id_bon_commande", nullable = false)
    private Integer idBonCommande;
    
    @Column(name = "montant_total", nullable = false)
    private Double montantTotal;
    
    @Column(name = "date_facture", nullable = false)
    private LocalDate dateFacture;
    
    @Column(name = "date_echeance")
    private LocalDate dateEcheance;
    
    @Column(name = "statut")
    private String statut = "EN_ATTENTE";
    
    // Transient pour jointures
    @Transient
    private BonCommande bonCommande;
    
    // Constructeurs
    public FactureFournisseur() {
        this.dateFacture = LocalDate.now();
    }
    
    public FactureFournisseur(String numeroFacture, Integer idBonCommande, Double montantTotal) {
        this.numeroFacture = numeroFacture;
        this.idBonCommande = idBonCommande;
        this.montantTotal = montantTotal;
        this.dateFacture = LocalDate.now();
        this.statut = "EN_ATTENTE";
    }
    
    // Getters et Setters
    public Integer getIdFacture() { return idFacture; }
    public void setIdFacture(Integer idFacture) { this.idFacture = idFacture; }
    
    public String getNumeroFacture() { return numeroFacture; }
    public void setNumeroFacture(String numeroFacture) { this.numeroFacture = numeroFacture; }
    
    public Integer getIdBonCommande() { return idBonCommande; }
    public void setIdBonCommande(Integer idBonCommande) { this.idBonCommande = idBonCommande; }
    
    public Double getMontantTotal() { return montantTotal; }
    public void setMontantTotal(Double montantTotal) { this.montantTotal = montantTotal; }
    
    public LocalDate getDateFacture() { return dateFacture; }
    public void setDateFacture(LocalDate dateFacture) { this.dateFacture = dateFacture; }
    
    public LocalDate getDateEcheance() { return dateEcheance; }
    public void setDateEcheance(LocalDate dateEcheance) { this.dateEcheance = dateEcheance; }
    
    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }
    
    public BonCommande getBonCommande() { return bonCommande; }
    public void setBonCommande(BonCommande bonCommande) { this.bonCommande = bonCommande; }
}
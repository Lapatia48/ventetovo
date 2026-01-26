package entity;

import java.time.LocalDate;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "facture_client")
public class FactureClient {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_facture_client")
    private Integer idFactureClient;
    
    @Column(name = "numero_facture", unique = true, nullable = false, length = 50)
    private String numeroFactureClient;
    
    @Column(name = "id_bon_commande_client", nullable = false)
    private Integer idBonCommandeClient;
    
    @Column(name = "id_client", nullable = false)
    private Integer idClient;
    
    @Column(name = "montant_ht", nullable = false)
    private Double montantHt;

    @Column(name = "montant_tva", nullable = false)
    private Double montantTva = 0.0;

    @Column(name = "montant_ttc", nullable = false)
    private Double montantTotal;
    
    @Column(name = "date_facture", nullable = false)
    private LocalDate dateFacture;
    
    @Column(name = "date_echeance", nullable = false)
    private LocalDate dateEcheance;
    
    @Column(name = "statut_paiement", length = 20)
    private String statutPaiement; // NON_PAYE, PAYE_PARTIEL, PAYE_TOTAL
    
    @Column(name = "montant_paye")
    private Double montantPaye;
    
    // Constructeurs
    public FactureClient() {
        this.dateFacture = LocalDate.now();
        this.statutPaiement = "NON_PAYE";
        this.montantPaye = 0.0;
    }
    
    // Getters et Setters
    public Integer getIdFactureClient() {
        return idFactureClient;
    }
    
    public void setIdFactureClient(Integer idFactureClient) {
        this.idFactureClient = idFactureClient;
    }
    
    public String getNumeroFactureClient() {
        return numeroFactureClient;
    }
    
    public void setNumeroFactureClient(String numeroFactureClient) {
        this.numeroFactureClient = numeroFactureClient;
    }
    
    public Integer getIdBonCommandeClient() {
        return idBonCommandeClient;
    }
    
    public void setIdBonCommandeClient(Integer idBonCommandeClient) {
        this.idBonCommandeClient = idBonCommandeClient;
    }
    
    public Integer getIdClient() {
        return idClient;
    }
    
    public void setIdClient(Integer idClient) {
        this.idClient = idClient;
    }
    
    public Double getMontantTotal() {
        return montantTotal;
    }
    
    public void setMontantTotal(Double montantTotal) {
        this.montantTotal = montantTotal;
    }

    public Double getMontantHt() {
        return montantHt;
    }

    public void setMontantHt(Double montantHt) {
        this.montantHt = montantHt;
    }

    public Double getMontantTva() {
        return montantTva;
    }

    public void setMontantTva(Double montantTva) {
        this.montantTva = montantTva;
    }
    
    public LocalDate getDateFacture() {
        return dateFacture;
    }
    
    public void setDateFacture(LocalDate dateFacture) {
        this.dateFacture = dateFacture;
    }
    
    public LocalDate getDateEcheance() {
        return dateEcheance;
    }
    
    public void setDateEcheance(LocalDate dateEcheance) {
        this.dateEcheance = dateEcheance;
    }
    
    public String getStatutPaiement() {
        return statutPaiement;
    }
    
    public void setStatutPaiement(String statutPaiement) {
        this.statutPaiement = statutPaiement;
    }
    
    public Double getMontantPaye() {
        return montantPaye;
    }
    
    public void setMontantPaye(Double montantPaye) {
        this.montantPaye = montantPaye;
    }
    
    // Méthodes utilitaires
    public Double getMontantRestant() {
        return montantTotal - montantPaye;
    }
    
    public boolean estEnRetard() {
        return dateEcheance != null && LocalDate.now().isAfter(dateEcheance) && !"PAYE_TOTAL".equals(statutPaiement);
    }
    
    public void enregistrerPaiement(Double montant) {
        this.montantPaye += montant;
        
        if (this.montantPaye >= this.montantTotal) {
            this.statutPaiement = "PAYE_TOTAL";
        } else if (this.montantPaye > 0) {
            this.statutPaiement = "PAYE_PARTIEL";
        }
    }
}

package entity;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.Transient;

@Entity
@Table(name = "bon_commande_client")
public class BonCommandeClient {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_bon_commande_client")
    private Integer idBonCommandeClient;
    
    @Column(name = "numero_bc", unique = true, nullable = false, length = 50)
    private String numeroBcClient;
    
    @Column(name = "id_proforma_client", nullable = false)
    private Integer idProformaClient;
    
    @Column(name = "id_client", nullable = false)
    private Integer idClient;
    
    @Column(name = "id_article", nullable = false)
    private Integer idArticle;
    
    @Column(name = "quantite", nullable = false)
    private Integer quantite;

    @Column(name = "prix_unitaire", nullable = false)
    private Double prixUnitaire;
    
    @Column(name = "montant_total", nullable = false)
    private Double montantTotal;
    
    @Column(name = "date_commande")
    private LocalDateTime dateCommande;
    
    @Column(name = "statut", length = 20)
    private String statut; // EN_COURS, CONFIRME, ANNULE
    
    @Transient
    private Boolean stockVerifie;
    
    @Transient
    private Boolean stockSuffisant;
    
    // Constructeurs
    public BonCommandeClient() {
        this.dateCommande = LocalDateTime.now();
        this.statut = "EN_COURS";
        this.stockVerifie = false;
        this.stockSuffisant = false;
    }
    
    // Getters et Setters
    public Integer getIdBonCommandeClient() {
        return idBonCommandeClient;
    }
    
    public void setIdBonCommandeClient(Integer idBonCommandeClient) {
        this.idBonCommandeClient = idBonCommandeClient;
    }
    
    public String getNumeroBcClient() {
        return numeroBcClient;
    }
    
    public void setNumeroBcClient(String numeroBcClient) {
        this.numeroBcClient = numeroBcClient;
    }
    
    public Integer getIdProformaClient() {
        return idProformaClient;
    }
    
    public void setIdProformaClient(Integer idProformaClient) {
        this.idProformaClient = idProformaClient;
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
    
    public Double getMontantTotal() {
        return montantTotal;
    }
    
    public void setMontantTotal(Double montantTotal) {
        this.montantTotal = montantTotal;
    }

    public Double getPrixUnitaire() {
        return prixUnitaire;
    }

    public void setPrixUnitaire(Double prixUnitaire) {
        this.prixUnitaire = prixUnitaire;
    }
    
    public LocalDateTime getDateCommande() {
        return dateCommande;
    }
    
    public void setDateCommande(LocalDateTime dateCommande) {
        this.dateCommande = dateCommande;
    }
    
    public String getStatut() {
        return statut;
    }
    
    public void setStatut(String statut) {
        this.statut = statut;
    }
    
    public Boolean getStockVerifie() {
        return stockVerifie;
    }
    
    public void setStockVerifie(Boolean stockVerifie) {
        this.stockVerifie = stockVerifie;
    }
    
    public Boolean getStockSuffisant() {
        return stockSuffisant;
    }
    
    public void setStockSuffisant(Boolean stockSuffisant) {
        this.stockSuffisant = stockSuffisant;
    }
}

package entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "proforma")
public class Proforma {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_proforma")
    private Integer idProforma;
    
    @Column(name = "numero", nullable = false, unique = true)
    private String numero;
    
    @Column(name = "token_demande", nullable = false)
    private String tokenDemande;
    
    @Column(name = "id_article", nullable = false)
    private Integer idArticle;
    
    @Column(name = "id_fournisseur", nullable = false)
    private Integer idFournisseur;
    
    @Column(name = "quantite", nullable = false)
    private Integer quantite;
    
    @Column(name = "prix_unitaire", nullable = false)
    private Double prixUnitaire;
    
    @Column(name = "montant_total", nullable = false)
    private Double montantTotal;
    
    @Column(name = "date_proforma")
    private LocalDateTime dateProforma;
    
    @Column(name = "statut")
    private String statut = "EN_ATTENTE";
    
    // Transient pour les jointures
    @Transient
    private Article article;
    
    @Transient
    private Fournisseur fournisseur;
    
    // Constructeurs
    public Proforma() {
        this.dateProforma = LocalDateTime.now();
    }
    
    public Proforma(String numero, String tokenDemande, Integer idArticle, 
                   Integer idFournisseur, Integer quantite, Double prixUnitaire) {
        this.numero = numero;
        this.tokenDemande = tokenDemande;
        this.idArticle = idArticle;
        this.idFournisseur = idFournisseur;
        this.quantite = quantite;
        this.prixUnitaire = prixUnitaire;
        this.montantTotal = quantite * prixUnitaire;
        this.dateProforma = LocalDateTime.now();
        this.statut = "EN_ATTENTE";
    }
    
    // Getters et Setters
    public Integer getIdProforma() { return idProforma; }
    public void setIdProforma(Integer idProforma) { this.idProforma = idProforma; }
    
    public String getNumero() { return numero; }
    public void setNumero(String numero) { this.numero = numero; }
    
    public String getTokenDemande() { return tokenDemande; }
    public void setTokenDemande(String tokenDemande) { this.tokenDemande = tokenDemande; }
    
    public Integer getIdArticle() { return idArticle; }
    public void setIdArticle(Integer idArticle) { this.idArticle = idArticle; }
    
    public Integer getIdFournisseur() { return idFournisseur; }
    public void setIdFournisseur(Integer idFournisseur) { this.idFournisseur = idFournisseur; }
    
    public Integer getQuantite() { return quantite; }
    public void setQuantite(Integer quantite) { 
        this.quantite = quantite;
        calculerMontantTotal();
    }
    
    public Double getPrixUnitaire() { return prixUnitaire; }
    public void setPrixUnitaire(Double prixUnitaire) { 
        this.prixUnitaire = prixUnitaire;
        calculerMontantTotal();
    }
    
    public Double getMontantTotal() { return montantTotal; }
    public void setMontantTotal(Double montantTotal) { this.montantTotal = montantTotal; }
    
    public LocalDateTime getDateProforma() { return dateProforma; }
    public void setDateProforma(LocalDateTime dateProforma) { this.dateProforma = dateProforma; }
    
    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }
    
    public Article getArticle() { return article; }
    public void setArticle(Article article) { this.article = article; }
    
    public Fournisseur getFournisseur() { return fournisseur; }
    public void setFournisseur(Fournisseur fournisseur) { this.fournisseur = fournisseur; }
    
    // Méthode pour calculer automatiquement le montant total
    private void calculerMontantTotal() {
        if (this.quantite != null && this.prixUnitaire != null) {
            this.montantTotal = this.quantite * this.prixUnitaire;
        }
    }
}
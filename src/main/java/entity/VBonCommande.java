package entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "v_bon_commande")
public class VBonCommande {
    
    @Id
    @Column(name = "id_bon_commande")
    private Integer idBonCommande;
    
    @Column(name = "id_proforma")
    private Integer idProforma;
    
    @Column(name = "date_commande")
    private LocalDateTime dateCommande;
    
    @Column(name = "statut")
    private String statut;
    
    @Column(name = "numero_proforma")
    private String numeroProforma;
    
    @Column(name = "token_demande")
    private String tokenDemande;
    
    @Column(name = "quantite")
    private Integer quantite;
    
    @Column(name = "prix_unitaire")
    private Double prixUnitaire;
    
    @Column(name = "montant_total")
    private Double montantTotal;
    
    @Column(name = "nom_fournisseur")
    private String nomFournisseur;
    
    @Column(name = "email_fournisseur")
    private String emailFournisseur;
    
    @Column(name = "telephone_fournisseur")
    private String telephoneFournisseur;
    
    @Column(name = "code_article")
    private String codeArticle;
    
    @Column(name = "designation_article")
    private String designationArticle;
    
    // Constructeur
    public VBonCommande() {}
    
    // Getters et Setters
    public Integer getIdBonCommande() { return idBonCommande; }
    public void setIdBonCommande(Integer idBonCommande) { this.idBonCommande = idBonCommande; }
    
    public Integer getIdProforma() { return idProforma; }
    public void setIdProforma(Integer idProforma) { this.idProforma = idProforma; }
    
    public LocalDateTime getDateCommande() { return dateCommande; }
    public void setDateCommande(LocalDateTime dateCommande) { this.dateCommande = dateCommande; }
    
    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }
    
    public String getNumeroProforma() { return numeroProforma; }
    public void setNumeroProforma(String numeroProforma) { this.numeroProforma = numeroProforma; }
    
    public String getTokenDemande() { return tokenDemande; }
    public void setTokenDemande(String tokenDemande) { this.tokenDemande = tokenDemande; }
    
    public Integer getQuantite() { return quantite; }
    public void setQuantite(Integer quantite) { this.quantite = quantite; }
    
    public Double getPrixUnitaire() { return prixUnitaire; }
    public void setPrixUnitaire(Double prixUnitaire) { this.prixUnitaire = prixUnitaire; }
    
    public Double getMontantTotal() { return montantTotal; }
    public void setMontantTotal(Double montantTotal) { this.montantTotal = montantTotal; }
    
    public String getNomFournisseur() { return nomFournisseur; }
    public void setNomFournisseur(String nomFournisseur) { this.nomFournisseur = nomFournisseur; }
    
    public String getEmailFournisseur() { return emailFournisseur; }
    public void setEmailFournisseur(String emailFournisseur) { this.emailFournisseur = emailFournisseur; }
    
    public String getTelephoneFournisseur() { return telephoneFournisseur; }
    public void setTelephoneFournisseur(String telephoneFournisseur) { this.telephoneFournisseur = telephoneFournisseur; }
    
    public String getCodeArticle() { return codeArticle; }
    public void setCodeArticle(String codeArticle) { this.codeArticle = codeArticle; }
    
    public String getDesignationArticle() { return designationArticle; }
    public void setDesignationArticle(String designationArticle) { this.designationArticle = designationArticle; }
}
package entity;

import java.time.LocalDate;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "vue_article")
public class VueArticle {
    @Id
    @Column(name = "id_article")
    private Integer idArticle;
    
    @Column(name = "code")
    private String code;
    
    @Column(name = "designation")
    private String designation;
    
    @Column(name = "id_fournisseur")
    private Integer idFournisseur;
    
    @Column(name = "nom_fournisseur")
    private String nomFournisseur;
    
    @Column(name = "prix_achat")
    private Double prixAchat;
    
    @Column(name = "date_dernier_prix")
    private LocalDate dateDernierPrix;
    
    // Constructeur par défaut
    public VueArticle() {}
    
    // Getters et Setters
    public Integer getIdArticle() { return idArticle; }
    public void setIdArticle(Integer idArticle) { this.idArticle = idArticle; }
    
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    
    public String getDesignation() { return designation; }
    public void setDesignation(String designation) { this.designation = designation; }
    
    public Integer getIdFournisseur() { return idFournisseur; }
    public void setIdFournisseur(Integer idFournisseur) { this.idFournisseur = idFournisseur; }
    
    public String getNomFournisseur() { return nomFournisseur; }
    public void setNomFournisseur(String nomFournisseur) { this.nomFournisseur = nomFournisseur; }
    
    public Double getPrixAchat() { return prixAchat; }
    public void setPrixAchat(Double prixAchat) { this.prixAchat = prixAchat; }
    
    public LocalDate getDateDernierPrix() { return dateDernierPrix; }
    public void setDateDernierPrix(LocalDate dateDernierPrix) { this.dateDernierPrix = dateDernierPrix; }
}
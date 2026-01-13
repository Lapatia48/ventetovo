package entity;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "prix")
public class Prix {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_prix")
    private Integer idPrix;
    
    @Column(name = "id_article", nullable = false)
    private Integer idArticle;
    
    @Column(name = "id_fournisseur", nullable = false)
    private Integer idFournisseur;
    
    @Column(name = "type", nullable = false)
    private String type; // 'ACHAT' ou 'VENTE'
    
    @Column(name = "montant", nullable = false)
    private Double montant;
    
    @Column(name = "date_prix", nullable = false)
    private LocalDate datePrix;
    
    // Transient pour la jointure (pas de relation JPA)
    @Transient
    private Article article;
    
    @Transient
    private Fournisseur fournisseur;
    
    // Constructeurs
    public Prix() {}
    
    public Prix(Integer idArticle, Integer idFournisseur, String type, Double montant, LocalDate datePrix) {
        this.idArticle = idArticle;
        this.idFournisseur = idFournisseur;
        this.type = type;
        this.montant = montant;
        this.datePrix = datePrix;
    }
    
    // Getters et Setters
    public Integer getIdPrix() { return idPrix; }
    public void setIdPrix(Integer idPrix) { this.idPrix = idPrix; }
    
    public Integer getIdArticle() { return idArticle; }
    public void setIdArticle(Integer idArticle) { this.idArticle = idArticle; }
    
    public Integer getIdFournisseur() { return idFournisseur; }
    public void setIdFournisseur(Integer idFournisseur) { this.idFournisseur = idFournisseur; }
    
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    
    public Double getMontant() { return montant; }
    public void setMontant(Double montant) { this.montant = montant; }
    
    public LocalDate getDatePrix() { return datePrix; }
    public void setDatePrix(LocalDate datePrix) { this.datePrix = datePrix; }
    
    public Article getArticle() { return article; }
    public void setArticle(Article article) { this.article = article; }
    
    public Fournisseur getFournisseur() { return fournisseur; }
    public void setFournisseur(Fournisseur fournisseur) { this.fournisseur = fournisseur; }
}
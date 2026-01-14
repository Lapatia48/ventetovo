package entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "bon_reception")
public class BonReception {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_bon_reception")
    private Integer idBonReception;
    
    @Column(name = "id_bon_livraison", nullable = false)
    private Integer idBonLivraison;
    
    @Column(name = "id_article", nullable = false)
    private Integer idArticle;
    
    @Column(name = "quantite_commandee", nullable = false)
    private Integer quantiteCommandee;
    
    @Column(name = "quantite_recue", nullable = false)
    private Integer quantiteRecue;
    
    @Column(name = "quantite_non_conforme")
    private Integer quantiteNonConforme = 0;
    
    @Column(name = "commentaire")
    private String commentaire;
    
    @Column(name = "date_reception")
    private LocalDateTime dateReception;
    
    @Column(name = "id_receptionnaire")
    private Integer idReceptionnaire;
    
    // Transient
    @Transient
    private BonLivraison bonLivraison;
    
    @Transient
    private Article article;
    
    // Constructeurs
    public BonReception() {
        this.dateReception = LocalDateTime.now();
    }
    
    public BonReception(Integer idBonLivraison, Integer idArticle, Integer quantiteCommandee, Integer quantiteRecue) {
        this.idBonLivraison = idBonLivraison;
        this.idArticle = idArticle;
        this.quantiteCommandee = quantiteCommandee;
        this.quantiteRecue = quantiteRecue;
        this.dateReception = LocalDateTime.now();
    }
    
    // Getters et Setters
    public Integer getIdBonReception() { return idBonReception; }
    public void setIdBonReception(Integer idBonReception) { this.idBonReception = idBonReception; }
    
    public Integer getIdBonLivraison() { return idBonLivraison; }
    public void setIdBonLivraison(Integer idBonLivraison) { this.idBonLivraison = idBonLivraison; }
    
    public Integer getIdArticle() { return idArticle; }
    public void setIdArticle(Integer idArticle) { this.idArticle = idArticle; }
    
    public Integer getQuantiteCommandee() { return quantiteCommandee; }
    public void setQuantiteCommandee(Integer quantiteCommandee) { this.quantiteCommandee = quantiteCommandee; }
    
    public Integer getQuantiteRecue() { return quantiteRecue; }
    public void setQuantiteRecue(Integer quantiteRecue) { this.quantiteRecue = quantiteRecue; }
    
    public Integer getQuantiteNonConforme() { return quantiteNonConforme; }
    public void setQuantiteNonConforme(Integer quantiteNonConforme) { this.quantiteNonConforme = quantiteNonConforme; }
    
    public String getCommentaire() { return commentaire; }
    public void setCommentaire(String commentaire) { this.commentaire = commentaire; }
    
    public LocalDateTime getDateReception() { return dateReception; }
    public void setDateReception(LocalDateTime dateReception) { this.dateReception = dateReception; }
    
    public Integer getIdReceptionnaire() { return idReceptionnaire; }
    public void setIdReceptionnaire(Integer idReceptionnaire) { this.idReceptionnaire = idReceptionnaire; }
    
    public BonLivraison getBonLivraison() { return bonLivraison; }
    public void setBonLivraison(BonLivraison bonLivraison) { this.bonLivraison = bonLivraison; }
    
    public Article getArticle() { return article; }
    public void setArticle(Article article) { this.article = article; }
    
    // Méthode utilitaire
    public Integer getQuantiteConforme() {
        return quantiteRecue - quantiteNonConforme;
    }
}
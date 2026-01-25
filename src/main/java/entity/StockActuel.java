package entity;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import javax.persistence.*;

@Entity
@Table(name = "vue_stock_actuel")
public class StockActuel {

    @Id
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "id_depot")
    private Depot depot;

    @ManyToOne
    @JoinColumn(name = "id_methode_article")
    private MethodeArticle methodeArticle;

    @ManyToOne
    @JoinColumn(name = "id_article")
    private Article article;

    @Column(name = "quantite_article")
    private BigDecimal quantiteArticle;

    @Column(name = "prix_total")
    private BigDecimal prixTotal;

    @Column(name = "prix_par_methode")
    private BigDecimal prixParMethode;

    @Column(name = "date_mouvement")
    private LocalDateTime dateMouvement;

    //Constructeurs
    public StockActuel() {
    }

    public StockActuel(Depot depot, MethodeArticle methodeArticle, Article article,
            BigDecimal quantiteArticle, BigDecimal prixTotal, BigDecimal prixParMethode,
            LocalDateTime dateMouvement) {
        this.depot = depot;
        this.methodeArticle = methodeArticle;
        this.article = article;
        this.quantiteArticle = quantiteArticle;
        this.prixTotal = prixTotal;
        this.prixParMethode = prixParMethode;
        this.dateMouvement = dateMouvement;
    }

    // Getters and Setters
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Depot getDepot() {
        return depot;
    }

    public void setDepot(Depot depot) {
        this.depot = depot;
    }

    public MethodeArticle getMethodeArticle() {
        return methodeArticle;
    }

    public void setMethodeArticle(MethodeArticle methodeArticle) {
        this.methodeArticle = methodeArticle;
    }

    public Article getArticle() {
        return article;
    }

    public void setArticle(Article article) {
        this.article = article;
    }

    public BigDecimal getQuantiteArticle() {
        return quantiteArticle;
    }

    public void setQuantiteArticle(BigDecimal quantiteArticle) {
        this.quantiteArticle = quantiteArticle;
    }

    public BigDecimal getPrixTotal() {
        return prixTotal;
    }

    public void setPrixTotal(BigDecimal prixTotal) {
        this.prixTotal = prixTotal;
    }

    public BigDecimal getPrixParMethode() {
        return prixParMethode;
    }

    public void setPrixParMethode(BigDecimal prixParMethode) {
        this.prixParMethode = prixParMethode;
    }

    public LocalDateTime getDateMouvement() {
        return dateMouvement;
    }

    public void setDateMouvement(LocalDateTime dateMouvement) {
        this.dateMouvement = dateMouvement;
    }

    // getters & setters
    
}

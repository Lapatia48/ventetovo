package entity;

import jakarta.persistence.*;
import java.sql.Timestamp;

@Entity
@Table(name = "stock")
public class Stock {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_stock")
    private Long idStock;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_article", nullable = false)
    private Article article;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_depot", nullable = false)
    private Depot depot;

    @Column(name = "quantite", nullable = false)
    private Integer quantite = 0;

    @Column(name = "date_maj")
    private Timestamp dateMaj;

    // Constructeurs
    public Stock() {}

    public Stock(Article article, Depot depot, Integer quantite) {
        this.article = article;
        this.depot = depot;
        this.quantite = quantite;
    }

    // Getters et Setters
    public Long getIdStock() {
        return idStock;
    }

    public void setIdStock(Long idStock) {
        this.idStock = idStock;
    }

    public Article getArticle() {
        return article;
    }

    public void setArticle(Article article) {
        this.article = article;
    }

    public Depot getDepot() {
        return depot;
    }

    public void setDepot(Depot depot) {
        this.depot = depot;
    }

    public Integer getQuantite() {
        return quantite;
    }

    public void setQuantite(Integer quantite) {
        this.quantite = quantite;
    }

    public Timestamp getDateMaj() {
        return dateMaj;
    }

    public void setDateMaj(Timestamp dateMaj) {
        this.dateMaj = dateMaj;
    }

    @Override
    public String toString() {
        return "Stock{" +
                "idStock=" + idStock +
                ", article=" + article.getCode() +
                ", depot=" + depot.getNom() +
                ", quantite=" + quantite +
                '}';
    }
}
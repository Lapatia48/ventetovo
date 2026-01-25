package entity;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import javax.persistence.*;

@Entity
@Table(name = "mouvement_stock")
public class MouvementStock {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "stock_id")
    private Integer stockId;

    @Column(name = "quantite_stock", nullable = false)
    private BigDecimal quantiteStock;

    @Column(name = "prix_article", nullable = false)
    private BigDecimal prixArticle;

    @Column(name = "mouvement_type", nullable = false)
    private String mouvementType = "ENTREE";

    @Column(name = "date_entree_stock")
    private LocalDateTime dateEntreeStock;

    // Foreign keys
    @Column(name = "id_article")
    private Integer idArticle;

    @Column(name = "id_depot")
    private Integer idDepot;

    @Column(name = "id_methode_article")
    private Integer idMethodeArticle;

    // Relations
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_article", insertable = false, updatable = false)
    private Article article;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_depot", insertable = false, updatable = false)
    private Depot depot;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_methode_article", insertable = false, updatable = false)
    private MethodeArticle methodeArticle;

    // Constructors
    public MouvementStock() {}

    public MouvementStock(Integer idArticle, Integer idDepot, Integer idMethodeArticle,
                          BigDecimal quantiteStock, BigDecimal prixArticle, String mouvementType,
                          LocalDateTime dateEntreeStock) {
        this.idArticle = idArticle;
        this.idDepot = idDepot;
        this.idMethodeArticle = idMethodeArticle;
        this.quantiteStock = quantiteStock;
        this.prixArticle = prixArticle;
        this.mouvementType = mouvementType;
        this.dateEntreeStock = dateEntreeStock;
    }

    // Getters and Setters
    public Integer getStockId() { return stockId; }
    public void setStockId(Integer stockId) { this.stockId = stockId; }

    public BigDecimal getQuantiteStock() { return quantiteStock; }
    public void setQuantiteStock(BigDecimal quantiteStock) { this.quantiteStock = quantiteStock; }

    public BigDecimal getPrixArticle() { return prixArticle; }
    public void setPrixArticle(BigDecimal prixArticle) { this.prixArticle = prixArticle; }

    public String getMouvementType() { return mouvementType; }
    public void setMouvementType(String mouvementType) { this.mouvementType = mouvementType; }

    public LocalDateTime getDateEntreeStock() { return dateEntreeStock; }
    public void setDateEntreeStock(LocalDateTime dateEntreeStock) { this.dateEntreeStock = dateEntreeStock; }

    public Integer getIdArticle() { return idArticle; }
    public void setIdArticle(Integer idArticle) { this.idArticle = idArticle; }

    public Integer getIdDepot() { return idDepot; }
    public void setIdDepot(Integer idDepot) { this.idDepot = idDepot; }

    public Integer getIdMethodeArticle() { return idMethodeArticle; }
    public void setIdMethodeArticle(Integer idMethodeArticle) { this.idMethodeArticle = idMethodeArticle; }

    public Article getArticle() { return article; }
    public void setArticle(Article article) { this.article = article; }

    public Depot getDepot() { return depot; }
    public void setDepot(Depot depot) { this.depot = depot; }

    public MethodeArticle getMethodeArticle() { return methodeArticle; }
    public void setMethodeArticle(MethodeArticle methodeArticle) { this.methodeArticle = methodeArticle; }

    @Transient
    public java.util.Date getDateEntreeStockAsDate() {
        if (dateEntreeStock == null) return null;
        return java.util.Date.from(
            dateEntreeStock.atZone(java.time.ZoneId.systemDefault()).toInstant()
        );
    }
}

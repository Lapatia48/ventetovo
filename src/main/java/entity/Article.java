package entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.util.List;

@Entity
@Table(name = "article")
public class Article {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_article")
    private Long idArticle;

    @Column(name = "code", unique = true, nullable = false, length = 50)
    private String code;

    @Column(name = "designation", nullable = false, length = 200)
    private String designation;

    @Column(name = "prix_achat", precision = 15, scale = 2)
    private BigDecimal prixAchat = BigDecimal.ZERO;

    @Column(name = "prix_vente", nullable = false, precision = 15, scale = 2)
    private BigDecimal prixVente;

    @Column(name = "seuil_alerte")
    private Integer seuilAlerte = 10;

    // Relations avec d'autres entités
    @OneToMany(mappedBy = "article", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Stock> stocks;

    @OneToMany(mappedBy = "article", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<LigneDemandeAchat> lignesDemandeAchat;

    // Constructeurs
    public Article() {}

    public Article(String code, String designation, BigDecimal prixVente) {
        this.code = code;
        this.designation = designation;
        this.prixVente = prixVente;
    }

    // Getters et Setters
    public Long getIdArticle() {
        return idArticle;
    }

    public void setIdArticle(Long idArticle) {
        this.idArticle = idArticle;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public BigDecimal getPrixAchat() {
        return prixAchat;
    }

    public void setPrixAchat(BigDecimal prixAchat) {
        this.prixAchat = prixAchat;
    }

    public BigDecimal getPrixVente() {
        return prixVente;
    }

    public void setPrixVente(BigDecimal prixVente) {
        this.prixVente = prixVente;
    }

    public Integer getSeuilAlerte() {
        return seuilAlerte;
    }

    public void setSeuilAlerte(Integer seuilAlerte) {
        this.seuilAlerte = seuilAlerte;
    }

    public List<LigneDemandeAchat> getLignesDemandeAchat() {
        return lignesDemandeAchat;
    }

    public void setLignesDemandeAchat(List<LigneDemandeAchat> lignesDemandeAchat) {
        this.lignesDemandeAchat = lignesDemandeAchat;
    }

    public List<Stock> getStocks() {
        return stocks;
    }

    public void setStocks(List<Stock> stocks) {
        this.stocks = stocks;
    }

    @Override
    public String toString() {
        return "Article{" +
                "idArticle=" + idArticle +
                ", code='" + code + '\'' +
                ", designation='" + designation + '\'' +
                ", prixVente=" + prixVente +
                '}';
    }
}
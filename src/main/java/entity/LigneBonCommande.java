package entity;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "ligne_bon_commande")
public class LigneBonCommande {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_ligne")
    private Long idLigne;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_commande", nullable = false)
    private BonCommande bonCommande;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_article", nullable = false)
    private Article article;

    @Column(name = "quantite", nullable = false)
    private Integer quantite;

    @Column(name = "prix_unitaire", nullable = false, precision = 15, scale = 2)
    private BigDecimal prixUnitaire;

    // Constructeurs
    public LigneBonCommande() {}

    public LigneBonCommande(BonCommande bonCommande, Article article, Integer quantite, BigDecimal prixUnitaire) {
        this.bonCommande = bonCommande;
        this.article = article;
        this.quantite = quantite;
        this.prixUnitaire = prixUnitaire;
    }

    // Getters et Setters
    public Long getIdLigne() {
        return idLigne;
    }

    public void setIdLigne(Long idLigne) {
        this.idLigne = idLigne;
    }

    public BonCommande getBonCommande() {
        return bonCommande;
    }

    public void setBonCommande(BonCommande bonCommande) {
        this.bonCommande = bonCommande;
    }

    public Article getArticle() {
        return article;
    }

    public void setArticle(Article article) {
        this.article = article;
    }

    public Integer getQuantite() {
        return quantite;
    }

    public void setQuantite(Integer quantite) {
        this.quantite = quantite;
    }

    public BigDecimal getPrixUnitaire() {
        return prixUnitaire;
    }

    public void setPrixUnitaire(BigDecimal prixUnitaire) {
        this.prixUnitaire = prixUnitaire;
    }

    // Méthode utilitaire pour calculer le montant total de la ligne
    public BigDecimal getMontantTotal() {
        if (quantite != null && prixUnitaire != null) {
            return prixUnitaire.multiply(BigDecimal.valueOf(quantite));
        }
        return BigDecimal.ZERO;
    }

    @Override
    public String toString() {
        return "LigneBonCommande{" +
                "idLigne=" + idLigne +
                ", quantite=" + quantite +
                ", prixUnitaire=" + prixUnitaire +
                ", article=" + (article != null ? article.getDesignation() : null) +
                '}';
    }
}
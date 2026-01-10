package entity;

import jakarta.persistence.*;

@Entity
@Table(name = "ligne_demande_achat")
public class LigneDemandeAchat {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_ligne")
    private Long idLigne;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_demande", nullable = false)
    private DemandeAchat demande;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_article", nullable = false)
    private Article article;

    @Column(name = "quantite", nullable = false)
    private Integer quantite;

    // Constructeurs
    public LigneDemandeAchat() {}

    public LigneDemandeAchat(DemandeAchat demande, Article article, Integer quantite) {
        this.demande = demande;
        this.article = article;
        this.quantite = quantite;
    }

    // Getters et Setters
    public Long getIdLigne() {
        return idLigne;
    }

    public void setIdLigne(Long idLigne) {
        this.idLigne = idLigne;
    }

    public DemandeAchat getDemande() {
        return demande;
    }

    public void setDemande(DemandeAchat demande) {
        this.demande = demande;
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

    @Override
    public String toString() {
        return "LigneDemandeAchat{" +
                "idLigne=" + idLigne +
                ", quantite=" + quantite +
                ", article=" + (article != null ? article.getDesignation() : null) +
                '}';
    }
}
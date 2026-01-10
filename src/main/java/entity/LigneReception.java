package entity;

import jakarta.persistence.*;

@Entity
@Table(name = "ligne_reception")
public class LigneReception {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_ligne")
    private Long idLigne;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_reception", nullable = false)
    private Reception reception;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_article", nullable = false)
    private Article article;

    @Column(name = "quantite_commandee", nullable = false)
    private Integer quantiteCommandee;

    @Column(name = "quantite_recue", nullable = false)
    private Integer quantiteRecue;

    // Constructeurs
    public LigneReception() {}

    public LigneReception(Reception reception, Article article, Integer quantiteCommandee, Integer quantiteRecue) {
        this.reception = reception;
        this.article = article;
        this.quantiteCommandee = quantiteCommandee;
        this.quantiteRecue = quantiteRecue;
    }

    // Getters et Setters
    public Long getIdLigne() {
        return idLigne;
    }

    public void setIdLigne(Long idLigne) {
        this.idLigne = idLigne;
    }

    public Reception getReception() {
        return reception;
    }

    public void setReception(Reception reception) {
        this.reception = reception;
    }

    public Article getArticle() {
        return article;
    }

    public void setArticle(Article article) {
        this.article = article;
    }

    public Integer getQuantiteCommandee() {
        return quantiteCommandee;
    }

    public void setQuantiteCommandee(Integer quantiteCommandee) {
        this.quantiteCommandee = quantiteCommandee;
    }

    public Integer getQuantiteRecue() {
        return quantiteRecue;
    }

    public void setQuantiteRecue(Integer quantiteRecue) {
        this.quantiteRecue = quantiteRecue;
    }

    // Méthode utilitaire pour calculer l'écart
    public Integer getEcart() {
        if (quantiteRecue != null && quantiteCommandee != null) {
            return quantiteRecue - quantiteCommandee;
        }
        return 0;
    }

    @Override
    public String toString() {
        return "LigneReception{" +
                "idLigne=" + idLigne +
                ", quantiteCommandee=" + quantiteCommandee +
                ", quantiteRecue=" + quantiteRecue +
                ", article=" + (article != null ? article.getDesignation() : null) +
                '}';
    }
}
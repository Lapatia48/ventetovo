package entity;

import javax.persistence.*;

@Entity
@Table(name = "methode_article")
public class MethodeArticle {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_methode_article")
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "id_article", nullable = false)
    private Article article;

    @ManyToOne
    @JoinColumn(name = "id_methode", nullable = false)
    private MethodeCalculStock methode;

    //Constructeurs
    public MethodeArticle() {}

    public MethodeArticle(Article article, MethodeCalculStock methode) {
        this.article = article;
        this.methode = methode;
    }

    // --- Getters & Setters ---
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Article getArticle() {
        return article;
    }

    public void setArticle(Article article) {
        this.article = article;
    }

    public MethodeCalculStock getMethode() {
        return methode;
    }

    public void setMethode(MethodeCalculStock methode) {
        this.methode = methode;
    }
}

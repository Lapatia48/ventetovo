package entity;

import jakarta.persistence.*;

@Entity
@Table(name = "article")
public class Article {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_article")
    private Integer idArticle;
    
    // DB init script uses column "code".
    @Column(name = "code", unique = true, nullable = false)
    private String code;
    
    @Column(name = "designation", nullable = false)
    private String designation;

    @Column(name = "categorie")
    private String categorie;
    
    // Constructeurs
    public Article() {}
    
    public Article(String code, String designation) {
        this.code = code;
        this.designation = designation;
    }
    
    // Getters et Setters
    public Integer getIdArticle() { return idArticle; }
    public void setIdArticle(Integer idArticle) { this.idArticle = idArticle; }
    
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    
    public String getDesignation() { return designation; }
    public void setDesignation(String designation) { this.designation = designation; }

    public String getCategorie() { return categorie; }
    public void setCategorie(String categorie) { this.categorie = categorie; }

    // Compat JSP: certains ecrans utilisent ${article.codeArticle}
    public String getCodeArticle() { return code; }
    public void setCodeArticle(String codeArticle) { this.code = codeArticle; }
}
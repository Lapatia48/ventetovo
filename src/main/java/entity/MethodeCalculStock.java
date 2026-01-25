package entity;

import javax.persistence.*;
import java.util.Set;

@Entity
@Table(name = "methode_calcul_stock")
public class MethodeCalculStock {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_methode")
    private Integer id;

    @Column(name = "nom_methode", nullable = false, unique = true)
    private String nomMethode;

    @OneToMany(mappedBy = "methode")
    private Set<MethodeArticle> methodesArticles;

    //Constructeurs
    public MethodeCalculStock() {}

    public MethodeCalculStock(String nomMethode) {
        this.nomMethode = nomMethode;
    }

    // --- Getters & Setters ---
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getNomMethode() {
        return nomMethode;
    }

    public void setNomMethode(String nomMethode) {
        this.nomMethode = nomMethode;
    }

    public Set<MethodeArticle> getMethodesArticles() {
        return methodesArticles;
    }

    public void setMethodesArticles(Set<MethodeArticle> methodesArticles) {
        this.methodesArticles = methodesArticles;
    }
}

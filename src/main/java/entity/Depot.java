package entity;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "depot")
public class Depot {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_depot")
    private Long idDepot;

    @Column(name = "nom", unique = true, nullable = false, length = 100)
    private String nom;

    // Relations
    @OneToMany(mappedBy = "depot", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Stock> stocks;

    // Constructeurs
    public Depot() {}

    public Depot(String nom) {
        this.nom = nom;
    }

    // Getters et Setters
    public Long getIdDepot() {
        return idDepot;
    }

    public void setIdDepot(Long idDepot) {
        this.idDepot = idDepot;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public List<Stock> getStocks() {
        return stocks;
    }

    public void setStocks(List<Stock> stocks) {
        this.stocks = stocks;
    }

    @Override
    public String toString() {
        return "Depot{" +
                "idDepot=" + idDepot +
                ", nom='" + nom + '\'' +
                '}';
    }
}
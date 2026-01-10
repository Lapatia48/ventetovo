package entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.sql.Timestamp;

@Entity
@Table(name = "caisse")
public class Caisse {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_caisse")
    private Long idCaisse;

    @Column(name = "solde", nullable = false, precision = 15, scale = 2)
    private BigDecimal solde = BigDecimal.ZERO;

    @Column(name = "date_maj")
    private Timestamp dateMaj;

    // Constructeurs
    public Caisse() {}

    public Caisse(BigDecimal solde) {
        this.solde = solde;
    }

    // Getters et Setters
    public Long getIdCaisse() {
        return idCaisse;
    }

    public void setIdCaisse(Long idCaisse) {
        this.idCaisse = idCaisse;
    }

    public BigDecimal getSolde() {
        return solde;
    }

    public void setSolde(BigDecimal solde) {
        this.solde = solde;
    }

    public Timestamp getDateMaj() {
        return dateMaj;
    }

    public void setDateMaj(Timestamp dateMaj) {
        this.dateMaj = dateMaj;
    }

    @Override
    public String toString() {
        return "Caisse{" +
                "idCaisse=" + idCaisse +
                ", solde=" + solde +
                '}';
    }
}
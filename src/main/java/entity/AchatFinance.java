package entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "achat_finance")
public class AchatFinance {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_achat_finance")
    private Integer idAchatFinance;
    
    @Column(name = "montant_seuil", nullable = false)
    private Double montantSeuil;
    
    @Column(name = "date_maj")
    private LocalDateTime dateMaj;
    
    @Column(name = "description")
    private String description;
    
    @Column(name = "actif")
    private Boolean actif = true;
    
    // Constructeurs
    public AchatFinance() {
        this.dateMaj = LocalDateTime.now();
    }
    
    public AchatFinance(Double montantSeuil, String description) {
        this.montantSeuil = montantSeuil;
        this.description = description;
        this.dateMaj = LocalDateTime.now();
        this.actif = true;
    }
    
    // Getters et Setters
    public Integer getIdAchatFinance() { return idAchatFinance; }
    public void setIdAchatFinance(Integer idAchatFinance) { this.idAchatFinance = idAchatFinance; }
    
    public Double getMontantSeuil() { return montantSeuil; }
    public void setMontantSeuil(Double montantSeuil) { 
        this.montantSeuil = montantSeuil;
        this.dateMaj = LocalDateTime.now();
    }
    
    public LocalDateTime getDateMaj() { return dateMaj; }
    public void setDateMaj(LocalDateTime dateMaj) { this.dateMaj = dateMaj; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public Boolean getActif() { return actif; }
    public void setActif(Boolean actif) { 
        this.actif = actif;
        this.dateMaj = LocalDateTime.now();
    }
}
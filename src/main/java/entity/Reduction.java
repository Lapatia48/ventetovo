package entity;

import java.time.LocalDate;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "reduction")
public class Reduction {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_reduction")
    private Integer idReduction;
    
    @Column(name = "code", unique = true, nullable = false, length = 50)
    private String codeReduction;
    
    @Column(name = "libelle", nullable = false, length = 200)
    private String description;
    
    @Column(name = "type_reduction", nullable = false, length = 20)
    private String typeReduction; // POURCENTAGE ou MONTANT
    
    @Column(name = "valeur", nullable = false)
    private Double valeur;
    
    @Column(name = "date_debut")
    private LocalDate dateDebut;
    
    @Column(name = "date_fin")
    private LocalDate dateFin;
    
    @Column(name = "actif")
    private Boolean actif;
    
    // Constructeurs
    public Reduction() {
        this.actif = true;
    }
    
    public Reduction(String codeReduction, String typeReduction, Double valeur, LocalDate dateDebut, LocalDate dateFin) {
        this();
        this.codeReduction = codeReduction;
        this.typeReduction = typeReduction;
        this.valeur = valeur;
        this.dateDebut = dateDebut;
        this.dateFin = dateFin;
    }
    
    // Getters et Setters
    public Integer getIdReduction() {
        return idReduction;
    }
    
    public void setIdReduction(Integer idReduction) {
        this.idReduction = idReduction;
    }
    
    public String getCodeReduction() {
        return codeReduction;
    }
    
    public void setCodeReduction(String codeReduction) {
        this.codeReduction = codeReduction;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getTypeReduction() {
        return typeReduction;
    }
    
    public void setTypeReduction(String typeReduction) {
        this.typeReduction = typeReduction;
    }
    
    public Double getValeur() {
        return valeur;
    }
    
    public void setValeur(Double valeur) {
        this.valeur = valeur;
    }
    
    public LocalDate getDateDebut() {
        return dateDebut;
    }
    
    public void setDateDebut(LocalDate dateDebut) {
        this.dateDebut = dateDebut;
    }
    
    public LocalDate getDateFin() {
        return dateFin;
    }
    
    public void setDateFin(LocalDate dateFin) {
        this.dateFin = dateFin;
    }
    
    public Boolean getActif() {
        return actif;
    }
    
    public void setActif(Boolean actif) {
        this.actif = actif;
    }
    
    // Méthodes utilitaires
    public boolean estValide() {
        LocalDate aujourd_hui = LocalDate.now();
        boolean debutOk = (dateDebut == null) || !aujourd_hui.isBefore(dateDebut);
        boolean finOk = (dateFin == null) || !aujourd_hui.isAfter(dateFin);
        return Boolean.TRUE.equals(actif) && debutOk && finOk;
    }
    
    public Double calculerReduction(Double montant) {
        if (!estValide()) {
            return 0.0;
        }
        
        if ("POURCENTAGE".equals(typeReduction)) {
            return montant * (valeur / 100.0);
        } else if ("MONTANT".equals(typeReduction) || "MONTANT_FIXE".equals(typeReduction)) {
            return Math.min(valeur, montant);
        }
        
        return 0.0;
    }
}

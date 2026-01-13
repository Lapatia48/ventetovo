package entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "role")
public class Role {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_role")
    private Integer idRole;
    
    @Column(name = "nom_role", unique = true, nullable = false)
    private String nomRole;
    
    @Column(name = "niveau_validation")
    private Integer niveauValidation;
    
    // Constructeurs
    public Role() {}
    
    public Role(String nomRole, Integer niveauValidation) {
        this.nomRole = nomRole;
        this.niveauValidation = niveauValidation;
    }
    
    // Getters et Setters
    public Integer getIdRole() { return idRole; }
    public void setIdRole(Integer idRole) { this.idRole = idRole; }
    
    public String getNomRole() { return nomRole; }
    public void setNomRole(String nomRole) { this.nomRole = nomRole; }
    
    public Integer getNiveauValidation() { return niveauValidation; }
    public void setNiveauValidation(Integer niveauValidation) { this.niveauValidation = niveauValidation; }
}
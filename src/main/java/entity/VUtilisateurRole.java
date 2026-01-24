package entity;

import org.hibernate.annotations.Immutable;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Immutable
@Table(name = "v_utilisateur_role")
public class VUtilisateurRole {

    @Id
    @Column(name = "id_utilisateur")
    private Integer idUtilisateur;

    @Column(name = "nom")
    private String nom;
    
    @Column(name = "prenom")
    private String prenom;
    
    @Column(name = "email")
    private String email;
    
    @Column(name = "mot_de_passe")
    private String motDePasse;
    
    @Column(name = "actif")
    private Boolean actif;

    @Column(name = "id_role")
    private Integer idRole;
    
    @Column(name = "nom_role")
    private String nomRole;
    
    @Column(name = "niveau_validation")
    private Integer niveauValidation;

    // Getters
    public Integer getIdUtilisateur() { return idUtilisateur; }
    public String getNom() { return nom; }
    public String getPrenom() { return prenom; }
    public String getEmail() { return email; }
    public String getMotDePasse() { return motDePasse; }
    public Boolean getActif() { return actif; }
    public Integer getIdRole() { return idRole; }
    public String getNomRole() { return nomRole; }
    public Integer getNiveauValidation() { return niveauValidation; }
}

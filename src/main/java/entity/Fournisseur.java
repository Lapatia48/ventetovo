package entity;

import jakarta.persistence.*;

@Entity
@Table(name = "fournisseur")
public class Fournisseur {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_fournisseur")
    private Integer idFournisseur;
    
    @Column(name = "nom", nullable = false)
    private String nom;
    
    @Column(name = "email")
    private String email;
    
    @Column(name = "telephone")
    private String telephone;
    
    // Constructeurs
    public Fournisseur() {}
    
    public Fournisseur(String nom, String email, String telephone) {
        this.nom = nom;
        this.email = email;
        this.telephone = telephone;
    }
    
    // Getters et Setters
    public Integer getIdFournisseur() { return idFournisseur; }
    public void setIdFournisseur(Integer idFournisseur) { this.idFournisseur = idFournisseur; }
    
    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getTelephone() { return telephone; }
    public void setTelephone(String telephone) { this.telephone = telephone; }
}
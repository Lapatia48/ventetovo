package entity;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "role")
public class Role {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_role")
    private Long idRole;

    @Column(name = "nom_role", unique = true, nullable = false, length = 50)
    private String nomRole;

    @Column(name = "niveau_validation")
    private Integer niveauValidation = 0;

    @OneToMany(mappedBy = "role", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Utilisateur> utilisateurs;

    // Constructeurs
    public Role() {}

    public Role(String nomRole, Integer niveauValidation) {
        this.nomRole = nomRole;
        this.niveauValidation = niveauValidation;
    }

    // Getters et Setters
    public Long getIdRole() {
        return idRole;
    }

    public void setIdRole(Long idRole) {
        this.idRole = idRole;
    }

    public String getNomRole() {
        return nomRole;
    }

    public void setNomRole(String nomRole) {
        this.nomRole = nomRole;
    }

    public Integer getNiveauValidation() {
        return niveauValidation;
    }

    public void setNiveauValidation(Integer niveauValidation) {
        this.niveauValidation = niveauValidation;
    }

    public List<Utilisateur> getUtilisateurs() {
        return utilisateurs;
    }

    public void setUtilisateurs(List<Utilisateur> utilisateurs) {
        this.utilisateurs = utilisateurs;
    }

    @Override
    public String toString() {
        return "Role{" +
                "idRole=" + idRole +
                ", nomRole='" + nomRole + '\'' +
                ", niveauValidation=" + niveauValidation +
                '}';
    }
}
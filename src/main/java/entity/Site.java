package entity;

import javax.persistence.*;
import java.util.Set;

@Entity
@Table(name = "site")
public class Site {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_site")
    private Integer id;

    @Column(name = "code_site", nullable = false, unique = true)
    private String codeSite;

    @Column(name = "nom_site", nullable = false)
    private String nomSite;

    @Column(name = "adresse")
    private String adresse;

    @Column(name = "entite_legale")
    private String entiteLegale;

    // Optional: relation with Depot
    @OneToMany(mappedBy = "site")
    private Set<Depot> depots;

    //Constructeurs
    public Site() {}

    public Site(String codeSite, String nomSite, String adresse, String entiteLegale) {
        this.codeSite = codeSite;
        this.nomSite = nomSite;
        this.adresse = adresse;
        this.entiteLegale = entiteLegale;
    }

    // --- Getters & Setters ---
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getCodeSite() {
        return codeSite;
    }

    public void setCodeSite(String codeSite) {
        this.codeSite = codeSite;
    }

    public String getNomSite() {
        return nomSite;
    }

    public void setNomSite(String nomSite) {
        this.nomSite = nomSite;
    }

    public String getAdresse() {
        return adresse;
    }

    public void setAdresse(String adresse) {
        this.adresse = adresse;
    }

    public String getEntiteLegale() {
        return entiteLegale;
    }

    public void setEntiteLegale(String entiteLegale) {
        this.entiteLegale = entiteLegale;
    }

    public Set<Depot> getDepots() {
        return depots;
    }

    public void setDepots(Set<Depot> depots) {
        this.depots = depots;
    }
}

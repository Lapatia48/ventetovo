package entity;

import javax.persistence.*;

@Entity
@Table(name = "depot")
public class Depot {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_depot")
    private Integer id;

    @Column(name = "code_depot", nullable = false, unique = true)
    private String codeDepot;

    @Column(name = "nom_depot", nullable = false)
    private String nomDepot;

    @ManyToOne
    @JoinColumn(name = "id_site")
    private Site site; 

    @Column(name = "adresse")
    private String adresse;

    @ManyToOne
    @JoinColumn(name = "responsable_id")
    private Utilisateur responsable;

    //Constructeurs
    public Depot() {}

    public Depot(String codeDepot, String nomDepot, Site site, String adresse, Utilisateur responsable) {
        this.codeDepot = codeDepot;
        this.nomDepot = nomDepot;
        this.site = site;
        this.adresse = adresse;
        this.responsable = responsable;
    }

    //Getters & Setters
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getCodeDepot() {
        return codeDepot;
    }

    public void setCodeDepot(String codeDepot) {
        this.codeDepot = codeDepot;
    }

    public String getNomDepot() {
        return nomDepot;
    }

    public void setNomDepot(String nomDepot) {
        this.nomDepot = nomDepot;
    }

    public Site getSite() {
        return site;
    }

    public void setSite(Site site) {
        this.site = site;
    }

    public String getAdresse() {
        return adresse;
    }

    public void setAdresse(String adresse) {
        this.adresse = adresse;
    }

    public Utilisateur getResponsable() {
        return responsable;
    }

    public void setResponsable(Utilisateur responsable) {
        this.responsable = responsable;
    }
}

package entity;

import jakarta.persistence.*;

@Entity
@Table(name = "config_valorisation_article")
public class ConfigValorisationArticle {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_config")
    private Integer idConfig;
    
    @Column(name = "id_article", nullable = false, unique = true)
    private Integer idArticle;
    
    @Column(name = "methode_valorisation", nullable = false, length = 10)
    private String methodeValorisation; // FIFO, CMUP
    
    @Column(name = "gestion_lot")
    private Boolean gestionLot;
    
    @Column(name = "type_peremption", length = 10)
    private String typePeremption; // NULL, DLUO, DLC
    
    @Column(name = "delai_alerte_peremption")
    private Integer delaiAlertePeremption;
    
    // Constructeurs
    public ConfigValorisationArticle() {
        this.methodeValorisation = "CMUP";
        this.gestionLot = false;
    }
    
    public ConfigValorisationArticle(Integer idArticle, String methodeValorisation) {
        this();
        this.idArticle = idArticle;
        this.methodeValorisation = methodeValorisation;
    }
    
    // Getters et Setters
    public Integer getIdConfig() {
        return idConfig;
    }
    
    public void setIdConfig(Integer idConfig) {
        this.idConfig = idConfig;
    }
    
    public Integer getIdArticle() {
        return idArticle;
    }
    
    public void setIdArticle(Integer idArticle) {
        this.idArticle = idArticle;
    }
    
    public String getMethodeValorisation() {
        return methodeValorisation;
    }
    
    public void setMethodeValorisation(String methodeValorisation) {
        this.methodeValorisation = methodeValorisation;
    }
    
    public Boolean getGestionLot() {
        return gestionLot;
    }
    
    public void setGestionLot(Boolean gestionLot) {
        this.gestionLot = gestionLot;
    }
    
    public String getTypePeremption() {
        return typePeremption;
    }
    
    public void setTypePeremption(String typePeremption) {
        this.typePeremption = typePeremption;
    }
    
    public Integer getDelaiAlertePeremption() {
        return delaiAlertePeremption;
    }
    
    public void setDelaiAlertePeremption(Integer delaiAlertePeremption) {
        this.delaiAlertePeremption = delaiAlertePeremption;
    }
}

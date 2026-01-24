package entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;
import jakarta.persistence.Transient;
import java.math.BigDecimal;

@Entity
@Table(name = "ligne_devis")
public class LigneDevis {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_ligne_devis")
    private Integer idLigneDevis;
    
    @Column(name = "id_devis", nullable = false)
    private Integer idDevis;
    
    @Column(name = "id_article", nullable = false)
    private Integer idArticle;
    
    @Column(name = "quantite", nullable = false)
    private Integer quantite;
    
    @Column(name = "prix_unitaire_ht", precision = 15, scale = 2, nullable = false)
    private BigDecimal prixUnitaireHt;
    
    @Column(name = "remise", precision = 5, scale = 2)
    private BigDecimal remise = BigDecimal.ZERO;
    
    @Column(name = "montant_ht", precision = 15, scale = 2, insertable = false, updatable = false)
    private BigDecimal montantHt;
    
    @Column(name = "tva_taux", precision = 5, scale = 2)
    private BigDecimal tvaTaux = new BigDecimal("20.0");
    
    @Column(name = "montant_ttc", precision = 15, scale = 2, insertable = false, updatable = false)
    private BigDecimal montantTtc;
    
    // Transient pour les jointures
    @Transient
    private Devis devis;
    
    @Transient
    private Article article;
    
    // Constructeurs
    public LigneDevis() {}
    
    public LigneDevis(Integer idDevis, Integer idArticle, Integer quantite, BigDecimal prixUnitaireHt) {
        this.idDevis = idDevis;
        this.idArticle = idArticle;
        this.quantite = quantite;
        this.prixUnitaireHt = prixUnitaireHt;
        this.remise = BigDecimal.ZERO;
        this.tvaTaux = new BigDecimal("20.0");
    }

    // Calcul automatique avant persist
    @PrePersist
    @PreUpdate
    private void calculerMontants() {
        BigDecimal prixApresRemise = prixUnitaireHt
            .multiply(BigDecimal.ONE.subtract(remise.divide(new BigDecimal(100))));
        
        this.montantHt = prixApresRemise.multiply(new BigDecimal(quantite));
        
        BigDecimal tvaMultiplicateur = BigDecimal.ONE.add(
            tvaTaux.divide(new BigDecimal(100)));
        this.montantTtc = montantHt.multiply(tvaMultiplicateur);
    }
    
    // Getters et Setters
    public Integer getIdLigneDevis() { return idLigneDevis; }
    public void setIdLigneDevis(Integer idLigneDevis) { this.idLigneDevis = idLigneDevis; }
    
    public Integer getIdDevis() { return idDevis; }
    public void setIdDevis(Integer idDevis) { this.idDevis = idDevis; }
    
    public Integer getIdArticle() { return idArticle; }
    public void setIdArticle(Integer idArticle) { this.idArticle = idArticle; }
    
    public Integer getQuantite() { return quantite; }
    public void setQuantite(Integer quantite) { this.quantite = quantite; }
    
    public BigDecimal getPrixUnitaireHt() { return prixUnitaireHt; }
    public void setPrixUnitaireHt(BigDecimal prixUnitaireHt) { this.prixUnitaireHt = prixUnitaireHt; }
    
    public BigDecimal getRemise() { return remise; }
    public void setRemise(BigDecimal remise) { this.remise = remise; }
    
    public BigDecimal getMontantHt() { return montantHt; }
    public void setMontantHt(BigDecimal montantHt) { this.montantHt = montantHt; }
    
    public BigDecimal getTvaTaux() { return tvaTaux; }
    public void setTvaTaux(BigDecimal tvaTaux) { this.tvaTaux = tvaTaux; }
    
    public BigDecimal getMontantTtc() { return montantTtc; }
    public void setMontantTtc(BigDecimal montantTtc) { this.montantTtc = montantTtc; }
    
    public BigDecimal getMontantTva() { 
        if (montantHt != null && tvaTaux != null) {
            return montantHt.multiply(tvaTaux.divide(new BigDecimal(100)));
        }
        return BigDecimal.ZERO;
    }
    
    public Devis getDevis() { return devis; }
    public void setDevis(Devis devis) { this.devis = devis; }
    
    public Article getArticle() { return article; }
    public void setArticle(Article article) { this.article = article; }
}
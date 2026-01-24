package entity;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "ligne_commande_client")
public class LigneCommandeClient {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_ligne_commande")
    private Integer idLigneCommande;

    @Column(name = "id_commande", nullable = false)
    private Integer idCommande;

    @Column(name = "id_article", nullable = false)
    private Integer idArticle;

    @Column(name = "quantite_commandee", nullable = false)
    private Integer quantiteCommandee;

    @Column(name = "quantite_livree")
    private Integer quantiteLivree = 0;

    @Column(name = "prix_unitaire_ht", nullable = false, precision = 15, scale = 2)
    private BigDecimal prixUnitaireHt;

    @Column(name = "remise", precision = 5, scale = 2)
    private BigDecimal remise = BigDecimal.ZERO;

    @Column(name = "montant_ht", precision = 15, scale = 2, insertable = false, updatable = false)
    private BigDecimal montantHt;


    //  Getters & Setters

    public Integer getIdLigneCommande() { return idLigneCommande; }
    public void setIdLigneCommande(Integer idLigneCommande) { this.idLigneCommande = idLigneCommande; }

    public Integer getIdCommande() { return idCommande; }
    public void setIdCommande(Integer idCommande) { this.idCommande = idCommande; }

    public Integer getIdArticle() { return idArticle; }
    public void setIdArticle(Integer idArticle) { this.idArticle = idArticle; }

    public Integer getQuantiteCommandee() { return quantiteCommandee; }
    public void setQuantiteCommandee(Integer quantiteCommandee) {
        this.quantiteCommandee = quantiteCommandee;
    }

    public Integer getQuantiteLivree() { 
        return quantiteLivree != null ? quantiteLivree : 0; 
    }
    public void setQuantiteLivree(Integer quantiteLivree) {
        this.quantiteLivree = quantiteLivree;
    }

    public BigDecimal getPrixUnitaireHt() { return prixUnitaireHt; }
    public void setPrixUnitaireHt(BigDecimal prixUnitaireHt) {
        this.prixUnitaireHt = prixUnitaireHt;
    }

    public BigDecimal getRemise() { return remise; }
    public void setRemise(BigDecimal remise) { this.remise = remise; }

    public BigDecimal getMontantHt() { return montantHt; }
    public void setMontantHt(BigDecimal montantHt) { this.montantHt = montantHt; }
}

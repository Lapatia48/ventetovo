package entity;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "ligne_facture_client")
public class LigneFactureClient {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_ligne_facture")
    private Integer idLigneFacture;

    @Column(name = "id_facture", nullable = false)
    private Integer idFacture;

    @Column(name = "id_ligne_livraison")
    private Integer idLigneLivraison;

    @Column(name = "id_article", nullable = false)
    private Integer idArticle;

    @Column(name = "description")
    private String description;

    @Column(name = "quantite")
    private Integer quantite;

    @Column(name = "prix_unitaire_ht")
    private BigDecimal prixUnitaireHt;

    @Column(name = "remise")
    private BigDecimal remise;

    @Column(name = "montant_ht")
    private BigDecimal montantHt;

    @Column(name = "tva_taux")
    private BigDecimal tvaTaux;

    @Column(name = "montant_tva")
    private BigDecimal montantTva;

    @Column(name = "montant_ttc")
    private BigDecimal montantTtc;

    /* ================= GETTERS / SETTERS ================= */

    public Integer getIdLigneFacture() { return idLigneFacture; }
    public void setIdLigneFacture(Integer idLigneFacture) { this.idLigneFacture = idLigneFacture; }

    public Integer getIdFacture() { return idFacture; }
    public void setIdFacture(Integer idFacture) { this.idFacture = idFacture; }

    public Integer getIdLigneLivraison() { return idLigneLivraison; }
    public void setIdLigneLivraison(Integer idLigneLivraison) { this.idLigneLivraison = idLigneLivraison; }

    public Integer getIdArticle() { return idArticle; }
    public void setIdArticle(Integer idArticle) { this.idArticle = idArticle; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

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

    public BigDecimal getMontantTva() { return montantTva; }
    public void setMontantTva(BigDecimal montantTva) { this.montantTva = montantTva; }

    public BigDecimal getMontantTtc() { return montantTtc; }
    public void setMontantTtc(BigDecimal montantTtc) { this.montantTtc = montantTtc; }
}

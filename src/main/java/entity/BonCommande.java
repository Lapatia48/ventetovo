package entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Entity
@Table(name = "bon_commande")
public class BonCommande {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_commande")
    private Long idCommande;

    @Column(name = "numero", unique = true, nullable = false, length = 50)
    private String numero;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_demande", nullable = false)
    private DemandeAchat demande;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_fournisseur", nullable = false)
    private Fournisseur fournisseur;

    @Column(name = "date_commande")
    private LocalDate dateCommande = LocalDate.now();

    @Column(name = "montant_total", nullable = false, precision = 15, scale = 2)
    private BigDecimal montantTotal;

    @Column(name = "statut", length = 20)
    private String statut = "EN_COURS";

    // Relations avec d'autres entités
    @OneToMany(mappedBy = "bonCommande", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<LigneBonCommande> lignesBonCommande;

    @OneToMany(mappedBy = "commande", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Reception> receptions;

    // Constructeurs
    public BonCommande() {}

    public BonCommande(String numero, DemandeAchat demande, Fournisseur fournisseur, BigDecimal montantTotal) {
        this.numero = numero;
        this.demande = demande;
        this.fournisseur = fournisseur;
        this.montantTotal = montantTotal;
    }

    // Getters et Setters
    public Long getIdCommande() {
        return idCommande;
    }

    public void setIdCommande(Long idCommande) {
        this.idCommande = idCommande;
    }

    public String getNumero() {
        return numero;
    }

    public void setNumero(String numero) {
        this.numero = numero;
    }

    public DemandeAchat getDemande() {
        return demande;
    }

    public void setDemande(DemandeAchat demande) {
        this.demande = demande;
    }

    public Fournisseur getFournisseur() {
        return fournisseur;
    }

    public void setFournisseur(Fournisseur fournisseur) {
        this.fournisseur = fournisseur;
    }

    public LocalDate getDateCommande() {
        return dateCommande;
    }

    public void setDateCommande(LocalDate dateCommande) {
        this.dateCommande = dateCommande;
    }

    public BigDecimal getMontantTotal() {
        return montantTotal;
    }

    public void setMontantTotal(BigDecimal montantTotal) {
        this.montantTotal = montantTotal;
    }

    public String getStatut() {
        return statut;
    }

    public void setStatut(String statut) {
        this.statut = statut;
    }

    public List<LigneBonCommande> getLignesBonCommande() {
        return lignesBonCommande;
    }

    public void setLignesBonCommande(List<LigneBonCommande> lignesBonCommande) {
        this.lignesBonCommande = lignesBonCommande;
    }

    public List<Reception> getReceptions() {
        return receptions;
    }

    public void setReceptions(List<Reception> receptions) {
        this.receptions = receptions;
    }

    @Override
    public String toString() {
        return "BonCommande{" +
                "idCommande=" + idCommande +
                ", numero='" + numero + '\'' +
                ", dateCommande=" + dateCommande +
                ", montantTotal=" + montantTotal +
                ", statut='" + statut + '\'' +
                ", fournisseur=" + (fournisseur != null ? fournisseur.getNom() : null) +
                '}';
    }
}
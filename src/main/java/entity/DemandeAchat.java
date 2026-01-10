package entity;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "demande_achat")
public class DemandeAchat {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_demande")
    private Long idDemande;

    @Column(name = "numero", unique = true, nullable = false, length = 50)
    private String numero;

    @Column(name = "date_demande")
    private LocalDate dateDemande = LocalDate.now();

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_demandeur", nullable = false)
    private Utilisateur demandeur;

    @Column(name = "statut", length = 20)
    private String statut = "EN_ATTENTE";

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_valideur")
    private Utilisateur valideur;

    @Column(name = "date_validation")
    private LocalDateTime dateValidation;

    @Column(name = "commentaire", columnDefinition = "TEXT")
    private String commentaire;

    // Relations avec d'autres entités
    @OneToMany(mappedBy = "demande", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<LigneDemandeAchat> lignesDemande;

    @OneToMany(mappedBy = "demande", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<BonCommande> bonsCommande;

    // Constructeurs
    public DemandeAchat() {}

    public DemandeAchat(String numero, Utilisateur demandeur) {
        this.numero = numero;
        this.demandeur = demandeur;
    }

    // Getters et Setters
    public Long getIdDemande() {
        return idDemande;
    }

    public void setIdDemande(Long idDemande) {
        this.idDemande = idDemande;
    }

    public String getNumero() {
        return numero;
    }

    public void setNumero(String numero) {
        this.numero = numero;
    }

    public LocalDate getDateDemande() {
        return dateDemande;
    }

    public void setDateDemande(LocalDate dateDemande) {
        this.dateDemande = dateDemande;
    }

    public Utilisateur getDemandeur() {
        return demandeur;
    }

    public void setDemandeur(Utilisateur demandeur) {
        this.demandeur = demandeur;
    }

    public String getStatut() {
        return statut;
    }

    public void setStatut(String statut) {
        this.statut = statut;
    }

    public Utilisateur getValideur() {
        return valideur;
    }

    public void setValideur(Utilisateur valideur) {
        this.valideur = valideur;
    }

    public LocalDateTime getDateValidation() {
        return dateValidation;
    }

    public void setDateValidation(LocalDateTime dateValidation) {
        this.dateValidation = dateValidation;
    }

    public String getCommentaire() {
        return commentaire;
    }

    public void setCommentaire(String commentaire) {
        this.commentaire = commentaire;
    }

    public List<LigneDemandeAchat> getLignesDemande() {
        return lignesDemande;
    }

    public void setLignesDemande(List<LigneDemandeAchat> lignesDemande) {
        this.lignesDemande = lignesDemande;
    }

    public List<BonCommande> getBonsCommande() {
        return bonsCommande;
    }

    public void setBonsCommande(List<BonCommande> bonsCommande) {
        this.bonsCommande = bonsCommande;
    }

    @Override
    public String toString() {
        return "DemandeAchat{" +
                "idDemande=" + idDemande +
                ", numero='" + numero + '\'' +
                ", dateDemande=" + dateDemande +
                ", statut='" + statut + '\'' +
                ", demandeur=" + (demandeur != null ? demandeur.getNom() + " " + demandeur.getPrenom() : null) +
                ", valideur=" + (valideur != null ? valideur.getNom() + " " + valideur.getPrenom() : null) +
                '}';
    }
}
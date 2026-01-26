package entity;

import java.time.LocalDate;
import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.Transient;

@Entity
@Table(name = "bon_livraison_client")
public class BonLivraisonClient {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_bon_livraison_client")
    private Integer idBonLivraisonClient;
    
    @Column(name = "numero_bl", unique = true, nullable = false, length = 50)
    private String numeroBlClient;
    
    @Column(name = "id_facture_client", nullable = false)
    private Integer idFactureClient;
    
    @Column(name = "id_client", nullable = false)
    private Integer idClient;
    
    @Transient
    private Integer idArticle;
    
    @Column(name = "quantite_livree", nullable = false)
    private Integer quantiteLivree;
    
    @Column(name = "date_livraison")
    private LocalDate dateLivraison;
    
    @Transient
    private LocalDate dateLivraisonPrevue;
    
    @Column(name = "statut", length = 20)
    private String statut; // EN_PREPARATION, EXPEDIE, LIVRE, ANNULE
    
    @Transient
    private Integer idLivreur;
    
    @Transient
    private String commentaire;

    @Column(name = "date_expedition")
    private LocalDateTime dateExpedition;
    
    // Constructeurs
    public BonLivraisonClient() {
        this.dateLivraison = null;
        this.statut = "EN_PREPARATION";
    }
    
    // Getters et Setters
    public Integer getIdBonLivraisonClient() {
        return idBonLivraisonClient;
    }
    
    public void setIdBonLivraisonClient(Integer idBonLivraisonClient) {
        this.idBonLivraisonClient = idBonLivraisonClient;
    }
    
    public String getNumeroBlClient() {
        return numeroBlClient;
    }
    
    public void setNumeroBlClient(String numeroBlClient) {
        this.numeroBlClient = numeroBlClient;
    }
    
    public Integer getIdFactureClient() {
        return idFactureClient;
    }
    
    public void setIdFactureClient(Integer idFactureClient) {
        this.idFactureClient = idFactureClient;
    }
    
    public Integer getIdClient() {
        return idClient;
    }
    
    public void setIdClient(Integer idClient) {
        this.idClient = idClient;
    }
    
    public Integer getIdArticle() {
        return idArticle;
    }
    
    public void setIdArticle(Integer idArticle) {
        this.idArticle = idArticle;
    }
    
    public Integer getQuantiteLivree() {
        return quantiteLivree;
    }
    
    public void setQuantiteLivree(Integer quantiteLivree) {
        this.quantiteLivree = quantiteLivree;
    }
    
    public LocalDate getDateLivraison() {
        return dateLivraison;
    }
    
    public void setDateLivraison(LocalDate dateLivraison) {
        this.dateLivraison = dateLivraison;
    }
    
    public LocalDate getDateLivraisonPrevue() {
        return dateLivraisonPrevue;
    }
    
    public void setDateLivraisonPrevue(LocalDate dateLivraisonPrevue) {
        this.dateLivraisonPrevue = dateLivraisonPrevue;
    }
    
    public String getStatut() {
        return statut;
    }
    
    public void setStatut(String statut) {
        this.statut = statut;
    }
    
    public Integer getIdLivreur() {
        return idLivreur;
    }
    
    public void setIdLivreur(Integer idLivreur) {
        this.idLivreur = idLivreur;
    }
    
    public String getCommentaire() {
        return commentaire;
    }
    
    public void setCommentaire(String commentaire) {
        this.commentaire = commentaire;
    }

    public LocalDateTime getDateExpedition() {
        return dateExpedition;
    }

    public void setDateExpedition(LocalDateTime dateExpedition) {
        this.dateExpedition = dateExpedition;
    }
}

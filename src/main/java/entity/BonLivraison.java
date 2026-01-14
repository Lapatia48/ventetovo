package entity;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "bon_livraison")
public class BonLivraison {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_bon_livraison")
    private Integer idBonLivraison;
    
    @Column(name = "numero_livraison", nullable = false, unique = true)
    private String numeroLivraison;
    
    @Column(name = "id_bon_commande", nullable = false)
    private Integer idBonCommande;
    
    @Column(name = "date_livraison", nullable = false)
    private LocalDate dateLivraison;
    
    @Column(name = "transporteur")
    private String transporteur;
    
    @Column(name = "numero_bon_transport")
    private String numeroBonTransport;
    
    @Column(name = "statut")
    private String statut = "EN_ATTENTE";
    
    // Transient
    @Transient
    private BonCommande bonCommande;
    
    // Constructeurs
    public BonLivraison() {
        this.dateLivraison = LocalDate.now();
    }
    
    public BonLivraison(String numeroLivraison, Integer idBonCommande) {
        this.numeroLivraison = numeroLivraison;
        this.idBonCommande = idBonCommande;
        this.dateLivraison = LocalDate.now();
        this.statut = "EN_ATTENTE";
    }
    
    // Getters et Setters
    public Integer getIdBonLivraison() { return idBonLivraison; }
    public void setIdBonLivraison(Integer idBonLivraison) { this.idBonLivraison = idBonLivraison; }
    
    public String getNumeroLivraison() { return numeroLivraison; }
    public void setNumeroLivraison(String numeroLivraison) { this.numeroLivraison = numeroLivraison; }
    
    public Integer getIdBonCommande() { return idBonCommande; }
    public void setIdBonCommande(Integer idBonCommande) { this.idBonCommande = idBonCommande; }
    
    public LocalDate getDateLivraison() { return dateLivraison; }
    public void setDateLivraison(LocalDate dateLivraison) { this.dateLivraison = dateLivraison; }
    
    public String getTransporteur() { return transporteur; }
    public void setTransporteur(String transporteur) { this.transporteur = transporteur; }
    
    public String getNumeroBonTransport() { return numeroBonTransport; }
    public void setNumeroBonTransport(String numeroBonTransport) { this.numeroBonTransport = numeroBonTransport; }
    
    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }
    
    public BonCommande getBonCommande() { return bonCommande; }
    public void setBonCommande(BonCommande bonCommande) { this.bonCommande = bonCommande; }
}
package entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "bon_commande")
public class BonCommande {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_bon_commande")
    private Integer idBonCommande;
    
    @Column(name = "id_proforma", nullable = false)
    private Integer idProforma;
    
    @Column(name = "date_commande")
    private LocalDateTime dateCommande;
    
    @Column(name = "statut")
    private String statut = "EN_COURS";
    
    // Transient pour la jointure
    @Transient
    private Proforma proforma;
    
    // Constructeurs
    public BonCommande() {
        this.dateCommande = LocalDateTime.now();
    }
    
    public BonCommande(Integer idProforma) {
        this.idProforma = idProforma;
        this.dateCommande = LocalDateTime.now();
        this.statut = "EN_COURS";
    }
    
    // Getters et Setters
    public Integer getIdBonCommande() { return idBonCommande; }
    public void setIdBonCommande(Integer idBonCommande) { this.idBonCommande = idBonCommande; }
    
    public Integer getIdProforma() { return idProforma; }
    public void setIdProforma(Integer idProforma) { this.idProforma = idProforma; }
    
    public LocalDateTime getDateCommande() { return dateCommande; }
    public void setDateCommande(LocalDateTime dateCommande) { this.dateCommande = dateCommande; }
    
    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }
    
    public Proforma getProforma() { return proforma; }
    public void setProforma(Proforma proforma) { this.proforma = proforma; }
}
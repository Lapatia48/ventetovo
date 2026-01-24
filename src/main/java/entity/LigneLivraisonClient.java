package entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "ligne_livraison_client")
public class LigneLivraisonClient {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_ligne_livraison")
    private Integer idLigneLivraison;

    @Column(name = "id_livraison", nullable = false)
    private Integer idLivraison;

    @Column(name = "id_ligne_commande", nullable = false)
    private Integer idLigneCommande;

    @Column(name = "quantite_livree", nullable = false)
    private Integer quantiteLivree;

    @Column(name = "numero_lot")
    private String numeroLot;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    // getters / setters

    public Integer getIdLigneLivraison() {
        return idLigneLivraison;
    }

    public void setIdLigneLivraison(Integer idLigneLivraison) {
        this.idLigneLivraison = idLigneLivraison;
    }

    public Integer getIdLivraison() {
        return idLivraison;
    }

    public void setIdLivraison(Integer idLivraison) {
        this.idLivraison = idLivraison;
    }

    public Integer getIdLigneCommande() {
        return idLigneCommande;
    }

    public void setIdLigneCommande(Integer idLigneCommande) {
        this.idLigneCommande = idLigneCommande;
    }

    public Integer getQuantiteLivree() {
        return quantiteLivree;
    }

    public void setQuantiteLivree(Integer quantiteLivree) {
        this.quantiteLivree = quantiteLivree;
    }

    public String getNumeroLot() {
        return numeroLot;
    }

    public void setNumeroLot(String numeroLot) {
        this.numeroLot = numeroLot;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}

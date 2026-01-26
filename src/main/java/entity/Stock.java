package entity;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "stock")
public class Stock {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_stock")
    private Integer idStock;
    
    @Column(name = "id_article", nullable = false)
    private Integer idArticle;
    
    @Column(name = "quantite_disponible", nullable = false)
    private Integer quantiteDisponible;
    
    @Column(name = "quantite_reservee", nullable = false)
    private Integer quantiteReservee;
    
    @Column(name = "stock_minimum")
    private Integer stockMinimum;
    
    @Column(name = "cout_moyen_unitaire")
    private Double coutMoyenUnitaire;
    
    @Column(name = "valeur_stock")
    private Double valeurStock;
    
    @Column(name = "date_derniere_maj")
    private LocalDateTime dateMiseAJour;
    
    // Constructeurs
    public Stock() {
        this.quantiteDisponible = 0;
        this.quantiteReservee = 0;
        this.dateMiseAJour = LocalDateTime.now();
    }
    
    public Stock(Integer idArticle, Integer quantiteDisponible) {
        this();
        this.idArticle = idArticle;
        this.quantiteDisponible = quantiteDisponible;
    }
    
    // Getters et Setters
    public Integer getIdStock() {
        return idStock;
    }
    
    public void setIdStock(Integer idStock) {
        this.idStock = idStock;
    }
    
    public Integer getIdArticle() {
        return idArticle;
    }
    
    public void setIdArticle(Integer idArticle) {
        this.idArticle = idArticle;
    }
    
    public Integer getQuantiteDisponible() {
        return quantiteDisponible;
    }
    
    public void setQuantiteDisponible(Integer quantiteDisponible) {
        this.quantiteDisponible = quantiteDisponible;
        this.dateMiseAJour = LocalDateTime.now();
    }
    
    public Integer getQuantiteReservee() {
        return quantiteReservee;
    }
    
    public void setQuantiteReservee(Integer quantiteReservee) {
        this.quantiteReservee = quantiteReservee;
        this.dateMiseAJour = LocalDateTime.now();
    }
    
    public LocalDateTime getDateMiseAJour() {
        return dateMiseAJour;
    }
    
    public void setDateMiseAJour(LocalDateTime dateMiseAJour) {
        this.dateMiseAJour = dateMiseAJour;
    }
    
    public Integer getStockMinimum() {
        return stockMinimum;
    }
    
    public void setStockMinimum(Integer stockMinimum) {
        this.stockMinimum = stockMinimum;
    }
    
    public Double getCoutMoyenUnitaire() {
        return coutMoyenUnitaire;
    }
    
    public void setCoutMoyenUnitaire(Double coutMoyenUnitaire) {
        this.coutMoyenUnitaire = coutMoyenUnitaire;
    }
    
    public Double getValeurStock() {
        return valeurStock;
    }
    
    public void setValeurStock(Double valeurStock) {
        this.valeurStock = valeurStock;
    }
    
    // Méthodes utilitaires
    public Integer getQuantiteReellementDisponible() {
        return quantiteDisponible - quantiteReservee;
    }
    
    public boolean estDisponible(Integer quantiteDemandee) {
        return getQuantiteReellementDisponible() >= quantiteDemandee;
    }
    
    public void reserver(Integer quantite) {
        if (estDisponible(quantite)) {
            this.quantiteReservee += quantite;
            this.dateMiseAJour = LocalDateTime.now();
        } else {
            throw new IllegalStateException("Stock insuffisant pour réserver " + quantite + " unités");
        }
    }
    
    public void libererReservation(Integer quantite) {
        this.quantiteReservee = Math.max(0, this.quantiteReservee - quantite);
        this.dateMiseAJour = LocalDateTime.now();
    }
    
    public void retirer(Integer quantite) {
        if (quantiteDisponible >= quantite) {
            this.quantiteDisponible -= quantite;
            this.dateMiseAJour = LocalDateTime.now();
        } else {
            throw new IllegalStateException("Stock insuffisant pour retirer " + quantite + " unités");
        }
    }
    
    public void ajouter(Integer quantite) {
        this.quantiteDisponible += quantite;
        this.dateMiseAJour = LocalDateTime.now();
    }
}

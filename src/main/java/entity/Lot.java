package entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

@Entity
@Table(name = "lot")
public class Lot {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_lot")
    private Integer idLot;
    
    @Column(name = "numero_lot", unique = true, nullable = false, length = 50)
    private String numeroLot;
    
    @Column(name = "id_article", nullable = false)
    private Integer idArticle;
    
    @Column(name = "date_fabrication")
    private LocalDate dateFabrication;
    
    @Column(name = "date_peremption")
    private LocalDate datePeremption;
    
    @Column(name = "dluo")
    private LocalDate dluo; // Date Limite d'Utilisation Optimale
    
    @Column(name = "dlc")
    private LocalDate dlc; // Date Limite de Consommation
    
    @Column(name = "quantite_initiale", nullable = false)
    private Integer quantiteInitiale;
    
    @Column(name = "quantite_restante", nullable = false)
    private Integer quantiteRestante;
    
    @Column(name = "statut", length = 20)
    private String statut; // ACTIF, EXPIRE, BLOQUE, NON_CONFORME
    
    @Column(name = "cout_unitaire", nullable = false, precision = 15, scale = 4)
    private BigDecimal coutUnitaire;
    
    @Column(name = "id_fournisseur")
    private Integer idFournisseur;
    
    @Column(name = "reference_document", length = 100)
    private String referenceDocument;
    
    @Column(name = "date_creation")
    private LocalDateTime dateCreation;
    
    // Constructeurs
    public Lot() {
        this.statut = "ACTIF";
        this.dateCreation = LocalDateTime.now();
    }
    
    public Lot(String numeroLot, Integer idArticle, Integer quantite, Double coutUnitaire) {
        this();
        this.numeroLot = numeroLot;
        this.idArticle = idArticle;
        this.quantiteInitiale = quantite;
        this.quantiteRestante = quantite;
        this.coutUnitaire = BigDecimal.valueOf(coutUnitaire);
    }
    
    // Getters et Setters
    public Integer getIdLot() {
        return idLot;
    }
    
    public void setIdLot(Integer idLot) {
        this.idLot = idLot;
    }
    
    public String getNumeroLot() {
        return numeroLot;
    }
    
    public void setNumeroLot(String numeroLot) {
        this.numeroLot = numeroLot;
    }
    
    public Integer getIdArticle() {
        return idArticle;
    }
    
    public void setIdArticle(Integer idArticle) {
        this.idArticle = idArticle;
    }
    
    public LocalDate getDateFabrication() {
        return dateFabrication;
    }
    
    public void setDateFabrication(LocalDate dateFabrication) {
        this.dateFabrication = dateFabrication;
    }
    
    public LocalDate getDatePeremption() {
        return datePeremption;
    }
    
    public void setDatePeremption(LocalDate datePeremption) {
        this.datePeremption = datePeremption;
    }
    
    public LocalDate getDluo() {
        return dluo;
    }
    
    public void setDluo(LocalDate dluo) {
        this.dluo = dluo;
    }
    
    public LocalDate getDlc() {
        return dlc;
    }
    
    public void setDlc(LocalDate dlc) {
        this.dlc = dlc;
    }

    @Transient
    public Date getDateFabricationAsDate() {
        return toDate(dateFabrication);
    }

    @Transient
    public Date getDlcAsDate() {
        return toDate(dlc);
    }

    @Transient
    public Date getDluoAsDate() {
        return toDate(dluo);
    }

    @Transient
    public Date getPeremptionAsDate() {
        return toDate(dlc != null ? dlc : dluo);
    }

    private static Date toDate(LocalDate localDate) {
        if (localDate == null) {
            return null;
        }
        return Date.from(localDate.atStartOfDay(ZoneId.systemDefault()).toInstant());
    }
    
    public Integer getQuantiteInitiale() {
        return quantiteInitiale;
    }
    
    public void setQuantiteInitiale(Integer quantiteInitiale) {
        this.quantiteInitiale = quantiteInitiale;
    }
    
    public Integer getQuantiteRestante() {
        return quantiteRestante;
    }
    
    public void setQuantiteRestante(Integer quantiteRestante) {
        this.quantiteRestante = quantiteRestante;
    }
    
    public String getStatut() {
        return statut;
    }
    
    public void setStatut(String statut) {
        this.statut = statut;
    }
    
    public BigDecimal getCoutUnitaire() {
        return coutUnitaire;
    }
    
    public void setCoutUnitaire(BigDecimal coutUnitaire) {
        this.coutUnitaire = coutUnitaire;
    }
    
    public Integer getIdFournisseur() {
        return idFournisseur;
    }
    
    public void setIdFournisseur(Integer idFournisseur) {
        this.idFournisseur = idFournisseur;
    }
    
    public String getReferenceDocument() {
        return referenceDocument;
    }
    
    public void setReferenceDocument(String referenceDocument) {
        this.referenceDocument = referenceDocument;
    }
    
    public LocalDateTime getDateCreation() {
        return dateCreation;
    }
    
    public void setDateCreation(LocalDateTime dateCreation) {
        this.dateCreation = dateCreation;
    }
    
    // Méthodes utilitaires
    public boolean estPerime() {
        LocalDate aujourd_hui = LocalDate.now();
        return (dlc != null && dlc.isBefore(aujourd_hui)) ||
               (dlc == null && dluo != null && dluo.isBefore(aujourd_hui.minusDays(30)));
    }
    
    public boolean estProchePeremption(int joursAvant) {
        if (dlc == null && dluo == null) return false;
        LocalDate dateReference = dlc != null ? dlc : dluo;
        LocalDate dateAlerte = LocalDate.now().plusDays(joursAvant);
        return dateReference.isBefore(dateAlerte) || dateReference.isEqual(dateAlerte);
    }
    
    public void consommer(Integer quantite) {
        if (quantite > quantiteRestante) {
            throw new IllegalArgumentException("Quantité insuffisante dans le lot");
        }
        this.quantiteRestante -= quantite;
    }
}

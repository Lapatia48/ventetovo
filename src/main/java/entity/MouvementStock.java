package entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

@Entity
@Table(name = "mouvement_stock")
public class MouvementStock {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_mouvement")
    private Integer idMouvement;
    
    @Column(name = "numero_mouvement", unique = true, nullable = false, length = 50)
    private String numeroMouvement;
    
    @Column(name = "id_type_mouvement", nullable = false)
    private Integer idTypeMouvement;
    
    @Column(name = "id_article", nullable = false)
    private Integer idArticle;
    
    @Column(name = "id_lot")
    private Integer idLot;
    
    @Column(name = "id_depot")
    private Integer idDepot;
    
    @Column(name = "id_emplacement")
    private Integer idEmplacement;
    
    @Column(name = "quantite", nullable = false)
    private Integer quantite;
    
    @Column(name = "cout_unitaire", nullable = false, precision = 15, scale = 4)
    private BigDecimal coutUnitaire;
    
    @Column(name = "cout_total", nullable = false, precision = 15, scale = 2)
    private BigDecimal coutTotal;
    
    @Column(name = "reference_document", length = 100)
    private String referenceDocument;
    
    @Column(name = "type_document", length = 50)
    private String typeDocument;
    
    @Column(name = "date_mouvement", nullable = false)
    private LocalDateTime dateMouvement;
    
    @Column(name = "id_utilisateur")
    private Integer idUtilisateur;
    
    @Column(name = "commentaire", columnDefinition = "TEXT")
    private String commentaire;
    
    @Column(name = "valide")
    private Boolean valide;
    
    @Column(name = "date_validation")
    private LocalDateTime dateValidation;
    
    @Column(name = "cloture")
    private Boolean cloture;
    
    // Constructeurs
    public MouvementStock() {
        this.dateMouvement = LocalDateTime.now();
        this.valide = true;
        this.cloture = false;
    }
    
    // Getters et Setters
    public Integer getIdMouvement() {
        return idMouvement;
    }
    
    public void setIdMouvement(Integer idMouvement) {
        this.idMouvement = idMouvement;
    }
    
    public String getNumeroMouvement() {
        return numeroMouvement;
    }
    
    public void setNumeroMouvement(String numeroMouvement) {
        this.numeroMouvement = numeroMouvement;
    }
    
    public Integer getIdTypeMouvement() {
        return idTypeMouvement;
    }
    
    public void setIdTypeMouvement(Integer idTypeMouvement) {
        this.idTypeMouvement = idTypeMouvement;
    }
    
    public Integer getIdArticle() {
        return idArticle;
    }
    
    public void setIdArticle(Integer idArticle) {
        this.idArticle = idArticle;
    }
    
    public Integer getIdLot() {
        return idLot;
    }
    
    public void setIdLot(Integer idLot) {
        this.idLot = idLot;
    }
    
    public Integer getIdDepot() {
        return idDepot;
    }
    
    public void setIdDepot(Integer idDepot) {
        this.idDepot = idDepot;
    }
    
    public Integer getIdEmplacement() {
        return idEmplacement;
    }
    
    public void setIdEmplacement(Integer idEmplacement) {
        this.idEmplacement = idEmplacement;
    }
    
    public Integer getQuantite() {
        return quantite;
    }
    
    public void setQuantite(Integer quantite) {
        this.quantite = quantite;
    }
    
    public BigDecimal getCoutUnitaire() {
        return coutUnitaire;
    }
    
    public void setCoutUnitaire(BigDecimal coutUnitaire) {
        this.coutUnitaire = coutUnitaire;
    }
    
    public BigDecimal getCoutTotal() {
        return coutTotal;
    }
    
    public void setCoutTotal(BigDecimal coutTotal) {
        this.coutTotal = coutTotal;
    }
    
    public String getReferenceDocument() {
        return referenceDocument;
    }
    
    public void setReferenceDocument(String referenceDocument) {
        this.referenceDocument = referenceDocument;
    }
    
    public String getTypeDocument() {
        return typeDocument;
    }
    
    public void setTypeDocument(String typeDocument) {
        this.typeDocument = typeDocument;
    }
    
    public LocalDateTime getDateMouvement() {
        return dateMouvement;
    }
    
    public void setDateMouvement(LocalDateTime dateMouvement) {
        this.dateMouvement = dateMouvement;
    }

    @Transient
    public Date getDateMouvementAsDate() {
        if (dateMouvement == null) {
            return null;
        }
        return Date.from(dateMouvement.atZone(ZoneId.systemDefault()).toInstant());
    }
    
    public Integer getIdUtilisateur() {
        return idUtilisateur;
    }
    
    public void setIdUtilisateur(Integer idUtilisateur) {
        this.idUtilisateur = idUtilisateur;
    }
    
    public String getCommentaire() {
        return commentaire;
    }
    
    public void setCommentaire(String commentaire) {
        this.commentaire = commentaire;
    }
    
    public Boolean getValide() {
        return valide;
    }
    
    public void setValide(Boolean valide) {
        this.valide = valide;
    }
    
    public LocalDateTime getDateValidation() {
        return dateValidation;
    }
    
    public void setDateValidation(LocalDateTime dateValidation) {
        this.dateValidation = dateValidation;
    }
    
    public Boolean getCloture() {
        return cloture;
    }
    
    public void setCloture(Boolean cloture) {
        this.cloture = cloture;
    }
}

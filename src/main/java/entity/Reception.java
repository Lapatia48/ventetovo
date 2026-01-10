package entity;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.util.List;

@Entity
@Table(name = "reception")
public class Reception {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_reception")
    private Long idReception;

    @Column(name = "numero", unique = true, nullable = false, length = 50)
    private String numero;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_commande", nullable = false)
    private BonCommande commande;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_receptionnaire", nullable = false)
    private Utilisateur receptionnaire;

    @Column(name = "date_reception")
    private LocalDate dateReception = LocalDate.now();

    @Column(name = "statut", length = 20)
    private String statut = "CONFORME";

    // Relations avec d'autres entités
    @OneToMany(mappedBy = "reception", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<LigneReception> lignesReception;

    // Constructeurs
    public Reception() {}

    public Reception(String numero, BonCommande commande, Utilisateur receptionnaire) {
        this.numero = numero;
        this.commande = commande;
        this.receptionnaire = receptionnaire;
    }

    // Getters et Setters
    public Long getIdReception() {
        return idReception;
    }

    public void setIdReception(Long idReception) {
        this.idReception = idReception;
    }

    public String getNumero() {
        return numero;
    }

    public void setNumero(String numero) {
        this.numero = numero;
    }

    public BonCommande getCommande() {
        return commande;
    }

    public void setCommande(BonCommande commande) {
        this.commande = commande;
    }

    public Utilisateur getReceptionnaire() {
        return receptionnaire;
    }

    public void setReceptionnaire(Utilisateur receptionnaire) {
        this.receptionnaire = receptionnaire;
    }

    public LocalDate getDateReception() {
        return dateReception;
    }

    public void setDateReception(LocalDate dateReception) {
        this.dateReception = dateReception;
    }

    public String getStatut() {
        return statut;
    }

    public void setStatut(String statut) {
        this.statut = statut;
    }

    public List<LigneReception> getLignesReception() {
        return lignesReception;
    }

    public void setLignesReception(List<LigneReception> lignesReception) {
        this.lignesReception = lignesReception;
    }

    @Override
    public String toString() {
        return "Reception{" +
                "idReception=" + idReception +
                ", numero='" + numero + '\'' +
                ", dateReception=" + dateReception +
                ", statut='" + statut + '\'' +
                ", receptionnaire=" + (receptionnaire != null ? receptionnaire.getNom() + " " + receptionnaire.getPrenom() : null) +
                '}';
    }
}
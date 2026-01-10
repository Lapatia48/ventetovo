package repository;

import entity.BonCommande;
import entity.DemandeAchat;
import entity.Fournisseur;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface BonCommandeRepository extends JpaRepository<BonCommande, Long> {

    Optional<BonCommande> findByNumero(String numero);

    boolean existsByNumero(String numero);

    List<BonCommande> findByDemande(DemandeAchat demande);

    List<BonCommande> findByFournisseur(Fournisseur fournisseur);

    List<BonCommande> findByStatut(String statut);

    List<BonCommande> findByDateCommandeBetween(LocalDate dateDebut, LocalDate dateFin);

    List<BonCommande> findByDemandeAndStatut(DemandeAchat demande, String statut);

    List<BonCommande> findByFournisseurAndStatut(Fournisseur fournisseur, String statut);

    @Query("SELECT SUM(bc.montantTotal) FROM BonCommande bc WHERE bc.statut = :statut")
    BigDecimal sumMontantTotalByStatut(@Param("statut") String statut);

    @Query("SELECT bc FROM BonCommande bc WHERE bc.fournisseur = :fournisseur AND bc.dateCommande >= :dateDebut ORDER BY bc.dateCommande DESC")
    List<BonCommande> findRecentByFournisseur(@Param("fournisseur") Fournisseur fournisseur, @Param("dateDebut") LocalDate dateDebut);

    @Query("SELECT COUNT(bc) FROM BonCommande bc WHERE bc.statut = :statut")
    long countByStatut(@Param("statut") String statut);
}
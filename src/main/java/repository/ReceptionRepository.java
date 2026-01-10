package repository;

import entity.BonCommande;
import entity.Reception;
import entity.Utilisateur;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface ReceptionRepository extends JpaRepository<Reception, Long> {

    Optional<Reception> findByNumero(String numero);

    boolean existsByNumero(String numero);

    List<Reception> findByCommande(BonCommande commande);

    List<Reception> findByReceptionnaire(Utilisateur receptionnaire);

    List<Reception> findByStatut(String statut);

    List<Reception> findByDateReceptionBetween(LocalDate dateDebut, LocalDate dateFin);

    List<Reception> findByCommandeAndStatut(BonCommande commande, String statut);

    List<Reception> findByReceptionnaireAndStatut(Utilisateur receptionnaire, String statut);

    @Query("SELECT r FROM Reception r WHERE r.commande.fournisseur.idFournisseur = :idFournisseur")
    List<Reception> findByFournisseurId(@Param("idFournisseur") Long idFournisseur);

    @Query("SELECT COUNT(r) FROM Reception r WHERE r.statut = :statut")
    long countByStatut(@Param("statut") String statut);

    @Query("SELECT r FROM Reception r WHERE r.commande = :commande ORDER BY r.dateReception DESC")
    List<Reception> findByCommandeOrderByDateReceptionDesc(@Param("commande") BonCommande commande);
}
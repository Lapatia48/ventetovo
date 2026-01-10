package repository;

import entity.DemandeAchat;
import entity.Utilisateur;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface DemandeAchatRepository extends JpaRepository<DemandeAchat, Long> {

    Optional<DemandeAchat> findByNumero(String numero);

    boolean existsByNumero(String numero);

    List<DemandeAchat> findByDemandeur(Utilisateur demandeur);

    List<DemandeAchat> findByValideur(Utilisateur valideur);

    List<DemandeAchat> findByStatut(String statut);

    List<DemandeAchat> findByDateDemandeBetween(LocalDate dateDebut, LocalDate dateFin);

    @Query("SELECT d FROM DemandeAchat d WHERE d.demandeur = :demandeur AND d.statut = :statut")
    List<DemandeAchat> findByDemandeurAndStatut(@Param("demandeur") Utilisateur demandeur, @Param("statut") String statut);

    @Query("SELECT d FROM DemandeAchat d WHERE d.valideur = :valideur AND d.statut = :statut")
    List<DemandeAchat> findByValideurAndStatut(@Param("valideur") Utilisateur valideur, @Param("statut") String statut);

    @Query("SELECT COUNT(d) FROM DemandeAchat d WHERE d.statut = :statut")
    long countByStatut(@Param("statut") String statut);
}
package service;

import entity.Caisse;
import repository.CaisseRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Optional;

@Service
@Transactional
public class CaisseService {

    @Autowired
    private CaisseRepository caisseRepository;

    public Optional<Caisse> findById(Long id) {
        return caisseRepository.findById(id);
    }

    public Caisse getCaissePrincipale() {
        return caisseRepository.findFirstByOrderByIdCaisseAsc();
    }

    public Caisse save(Caisse caisse) {
        return caisseRepository.save(caisse);
    }

    // Méthode pour ajouter au solde
    public void ajouterAuSolde(BigDecimal montant) {
        Caisse caisse = getCaissePrincipale();
        if (caisse != null) {
            caisse.setSolde(caisse.getSolde().add(montant));
            save(caisse);
        }
    }

    // Méthode pour soustraire du solde
    public void soustraireDuSolde(BigDecimal montant) {
        Caisse caisse = getCaissePrincipale();
        if (caisse != null) {
            caisse.setSolde(caisse.getSolde().subtract(montant));
            save(caisse);
        }
    }
}
package service;

import entity.Fournisseur;
import repository.FournisseurRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class FournisseurService {

    @Autowired
    private FournisseurRepository fournisseurRepository;

    public List<Fournisseur> findAll() {
        return fournisseurRepository.findAll();
    }

    public Optional<Fournisseur> findById(Long id) {
        return fournisseurRepository.findById(id);
    }

    public Optional<Fournisseur> findByNom(String nom) {
        return fournisseurRepository.findByNom(nom);
    }

    public Fournisseur save(Fournisseur fournisseur) {
        // Validation de base
        if (fournisseur.getNom() == null || fournisseur.getNom().trim().isEmpty()) {
            throw new IllegalArgumentException("Le nom du fournisseur est obligatoire");
        }

        // Vérifier l'unicité du nom
        if (fournisseur.getIdFournisseur() == null && existsByNom(fournisseur.getNom())) {
            throw new IllegalArgumentException("Un fournisseur avec ce nom existe déjà");
        }

        return fournisseurRepository.save(fournisseur);
    }

    public void deleteById(Long id) {
        fournisseurRepository.deleteById(id);
    }

    public boolean existsByNom(String nom) {
        return fournisseurRepository.existsByNom(nom);
    }

    // Méthodes métier spécifiques
    public List<Fournisseur> findByNomContainingIgnoreCase(String nom) {
        return fournisseurRepository.findByNomContainingIgnoreCase(nom);
    }

    public Optional<Fournisseur> findByEmail(String email) {
        return fournisseurRepository.findByEmail(email);
    }

    public List<Fournisseur> findByTelephone(String telephone) {
        return fournisseurRepository.findByTelephone(telephone);
    }
}
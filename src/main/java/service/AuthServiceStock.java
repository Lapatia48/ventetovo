package service;

import org.springframework.stereotype.Service;

import entity.Utilisateur;
import repository.UtilisateurRepo;

@Service
public class AuthServiceStock {
    
    private final UtilisateurRepo utilisateurRepository;

    public AuthServiceStock(UtilisateurRepo utilisateurRepository) {
        this.utilisateurRepository = utilisateurRepository;
    }

    public Utilisateur login(String username, String password) {

        // username = email
        return utilisateurRepository
                .findActiveUserWithRole(username, password)
                .orElse(null);
    }

}

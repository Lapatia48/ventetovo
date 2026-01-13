package service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import entity.Role;
import entity.Utilisateur;
import repository.RoleRepository;
import repository.UtilisateurRepository;

@Service
public class UtilisateurService {
    
    @Autowired
    private UtilisateurRepository utilisateurRepository;
    
    @Autowired
    private RoleRepository roleRepository;
    
    public List<Utilisateur> findAll() {
        List<Utilisateur> utilisateurs = utilisateurRepository.findAll();
        // Enrichir avec les informations du rôle
        for (Utilisateur utilisateur : utilisateurs) {
            enrichirAvecRole(utilisateur);
        }
        return utilisateurs;
    }
    
    public Optional<Utilisateur> findById(Integer id) {
        Optional<Utilisateur> utilisateurOpt = utilisateurRepository.findById(id);
        utilisateurOpt.ifPresent(this::enrichirAvecRole);
        return utilisateurOpt;
    }
    
    public Optional<Utilisateur> findByEmail(String email) {
        Optional<Utilisateur> utilisateurOpt = utilisateurRepository.findByEmail(email);
        utilisateurOpt.ifPresent(this::enrichirAvecRole);
        return utilisateurOpt;
    }
    
    public List<Utilisateur> findByActifTrue() {
        List<Utilisateur> utilisateurs = utilisateurRepository.findByActifTrue();
        for (Utilisateur utilisateur : utilisateurs) {
            enrichirAvecRole(utilisateur);
        }
        return utilisateurs;
    }
    
    public Utilisateur save(Utilisateur utilisateur) {
        return utilisateurRepository.save(utilisateur);
    }
    
    public void delete(Integer id) {
        utilisateurRepository.deleteById(id);
    }
    
    public boolean authenticate(String email, String motDePasse) {
        Optional<Utilisateur> userOpt = utilisateurRepository.findByEmailAndMotDePasse(email, motDePasse);
        return userOpt.isPresent();
    }
    
    private void enrichirAvecRole(Utilisateur utilisateur) {
        if (utilisateur != null && utilisateur.getIdRole() != null) {
            Optional<Role> roleOpt = roleRepository.findById(utilisateur.getIdRole());
            roleOpt.ifPresent(utilisateur::setRole);
        }
    }
}
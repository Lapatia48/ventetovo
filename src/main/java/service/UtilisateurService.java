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

    public Optional<Utilisateur> findById(Integer id) {
        Optional<Utilisateur> opt = utilisateurRepository.findById(id);
        opt.ifPresent(this::enrichirAvecRole);
        return opt;
    }

    public Optional<Utilisateur> findByEmail(String email) {
        Optional<Utilisateur> opt = utilisateurRepository.findByEmail(email);
        opt.ifPresent(this::enrichirAvecRole);
        return opt;
    }

    public List<Utilisateur> findByActifTrue() {
        List<Utilisateur> list = utilisateurRepository.findByActifTrue();
        list.forEach(this::enrichirAvecRole);
        return list;
    }

    public List<Utilisateur> findAll() {
        List<Utilisateur> list = utilisateurRepository.findAll();
        list.forEach(this::enrichirAvecRole);
        return list;
    }

    public Utilisateur save(Utilisateur utilisateur) {
        Utilisateur saved = utilisateurRepository.save(utilisateur);
        enrichirAvecRole(saved);
        return saved;
    }

    private void enrichirAvecRole(Utilisateur utilisateur) {
        if (utilisateur == null) return;

        Integer idRole = utilisateur.getIdRole();
        if (idRole == null) return;

        roleRepository.findById(idRole)
                .ifPresent(utilisateur::setRole);
    }
}

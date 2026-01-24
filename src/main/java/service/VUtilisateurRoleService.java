package service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import entity.VUtilisateurRole;
import repository.VUtilisateurRoleRepository;

@Service
public class VUtilisateurRoleService {
    
    @Autowired
    private VUtilisateurRoleRepository vUtilisateurRoleRepository;
    
    public List<VUtilisateurRole> findAll() {
        return vUtilisateurRoleRepository.findAll();
    }
    
    public Optional<VUtilisateurRole> findById(Integer id) {
        return vUtilisateurRoleRepository.findById(id);
    }
    
    public Optional<VUtilisateurRole> findByEmail(String email) {
        return vUtilisateurRoleRepository.findByEmail(email);
    }
    
    public List<VUtilisateurRole> findByActifTrue() {
        return vUtilisateurRoleRepository.findAll()
                .stream()
                .filter(u -> Boolean.TRUE.equals(u.getActif()))
                .filter(u -> u.getNomRole() != null)  // Filtrer les utilisateurs sans rôle
                .toList();
    }
}

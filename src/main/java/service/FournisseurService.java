package service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import entity.Fournisseur;
import repository.FournisseurRepository;

@Service
public class FournisseurService {
    
    @Autowired
    private FournisseurRepository fournisseurRepository;
    
    public List<Fournisseur> findAll() {
        return fournisseurRepository.findAll();
    }
}
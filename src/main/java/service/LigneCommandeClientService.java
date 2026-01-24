package service;

import entity.LigneCommandeClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import repository.LigneCommandeClientRepository;

import java.util.List;
import java.util.Optional;

@Service
public class LigneCommandeClientService {

    @Autowired
    private LigneCommandeClientRepository ligneCommandeClientRepository;

    public List<LigneCommandeClient> findAll() {
        return ligneCommandeClientRepository.findAll();
    }

    public Optional<LigneCommandeClient> findById(Integer id) {
        return ligneCommandeClientRepository.findById(id);
    }

    public List<LigneCommandeClient> findByIdCommande(Integer idCommande) {
        return ligneCommandeClientRepository.findByIdCommande(idCommande);
    }

    public LigneCommandeClient save(LigneCommandeClient ligneCommandeClient) {
        return ligneCommandeClientRepository.save(ligneCommandeClient);
    }

    public void deleteById(Integer id) {
        ligneCommandeClientRepository.deleteById(id);
    }
}

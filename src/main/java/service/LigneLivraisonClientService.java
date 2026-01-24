package service;

import entity.LigneLivraisonClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import repository.LigneLivraisonClientRepository;

import java.util.List;
import java.util.Optional;

@Service
public class LigneLivraisonClientService {

    @Autowired
    private LigneLivraisonClientRepository ligneLivraisonRepository;

    // 🔍 Toutes les lignes
    public List<LigneLivraisonClient> findAll() {
        return ligneLivraisonRepository.findAll();
    }

    // 🔍 Par ID
    public Optional<LigneLivraisonClient> findById(Integer id) {
        return ligneLivraisonRepository.findById(id);
    }

    // 🔍 Par livraison
    public List<LigneLivraisonClient> findByIdLivraison(Integer idLivraison) {
        return ligneLivraisonRepository.findByIdLivraison(idLivraison);
    }

    // 💾 Sauvegarde
    public LigneLivraisonClient save(LigneLivraisonClient ligne) {
        return ligneLivraisonRepository.save(ligne);
    }

    // ❌ Suppression
    public void deleteById(Integer id) {
        ligneLivraisonRepository.deleteById(id);
    }
}

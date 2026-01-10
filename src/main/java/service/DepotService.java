package service;

import entity.Depot;
import repository.DepotRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class DepotService {

    @Autowired
    private DepotRepository depotRepository;

    public List<Depot> findAll() {
        return depotRepository.findAll();
    }

    public Optional<Depot> findById(Long id) {
        return depotRepository.findById(id);
    }

    public Optional<Depot> findByNom(String nom) {
        return depotRepository.findByNom(nom);
    }

    public Depot save(Depot depot) {
        return depotRepository.save(depot);
    }
}
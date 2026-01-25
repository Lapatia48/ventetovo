package service;

import entity.FactureReglement;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import repository.FactureReglementRepository;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class FactureReglementService {

    @Autowired
    private FactureReglementRepository factureReglementRepository;

    public List<FactureReglement> findAll() {
        return factureReglementRepository.findAll();
    }

    public Optional<FactureReglement> findById(Integer id) {
        return factureReglementRepository.findById(id);
    }

    public List<FactureReglement> findByIdFacture(Integer idFacture) {
        return factureReglementRepository.findByIdFacture(idFacture);
    }

    public List<FactureReglement> findByIdReglement(Integer idReglement) {
        return factureReglementRepository.findByIdReglement(idReglement);
    }

    public FactureReglement save(FactureReglement factureReglement) {
        return factureReglementRepository.save(factureReglement);
    }

    public void deleteById(Integer id) {
        factureReglementRepository.deleteById(id);
    }
}
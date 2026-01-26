package service;

import entity.Reduction;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import repository.ReductionRepository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
public class ReductionService {
    
    @Autowired
    private ReductionRepository reductionRepository;
    
    public List<Reduction> findAll() {
        return reductionRepository.findAll();
    }
    
    public Optional<Reduction> findById(Integer id) {
        return reductionRepository.findById(id);
    }
    
    public Optional<Reduction> findByCode(String codeReduction) {
        return reductionRepository.findByCodeReduction(codeReduction);
    }
    
    public Reduction save(Reduction reduction) {
        return reductionRepository.save(reduction);
    }
    
    public List<Reduction> findReductionsValides() {
        return reductionRepository.findReductionsValides(LocalDate.now());
    }
    
    public Double calculerMontantReduction(String codeReduction, Double montantBrut) {
        Optional<Reduction> reductionOpt = findByCode(codeReduction);
        
        if (reductionOpt.isPresent()) {
            Reduction reduction = reductionOpt.get();
            if (reduction.estValide()) {
                return reduction.calculerReduction(montantBrut);
            }
        }
        
        return 0.0;
    }
}

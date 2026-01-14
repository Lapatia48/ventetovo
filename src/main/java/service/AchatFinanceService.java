package service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import entity.AchatFinance;
import repository.AchatFinanceRepository;
import java.util.Optional;

@Service
public class AchatFinanceService {
    
    @Autowired
    private AchatFinanceRepository achatFinanceRepository;
    
    // Récupérer la configuration active
    public Optional<AchatFinance> getActiveConfiguration() {
        return achatFinanceRepository.findActiveConfiguration();
    }
    
    // Récupérer le montant seuil actif
    public Double getMontantSeuilActif() {
        return achatFinanceRepository.findActiveConfiguration()
            .map(AchatFinance::getMontantSeuil)
            .orElse(1000000.0); // Valeur par défaut si pas de configuration
    }
    
    // Sauvegarder ou mettre à jour la configuration
    public AchatFinance saveConfiguration(AchatFinance configuration) {
        // Désactiver les anciennes configurations
        achatFinanceRepository.findActiveConfiguration().ifPresent(oldConfig -> {
            oldConfig.setActif(false);
            achatFinanceRepository.save(oldConfig);
        });
        
        // Activer la nouvelle configuration
        configuration.setActif(true);
        return achatFinanceRepository.save(configuration);
    }
    
    // Créer une configuration par défaut si aucune n'existe
    public void initializeDefaultConfiguration() {
        if (achatFinanceRepository.findActiveConfiguration().isEmpty()) {
            AchatFinance defaultConfig = new AchatFinance(1000000.0, "Configuration par défaut - Seuil d'approbation");
            achatFinanceRepository.save(defaultConfig);
        }
    }
}
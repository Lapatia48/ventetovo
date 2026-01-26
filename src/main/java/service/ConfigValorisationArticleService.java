package service;

import entity.ConfigValorisationArticle;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import repository.ConfigValorisationArticleRepository;

import java.util.List;
import java.util.Optional;

@Service
public class ConfigValorisationArticleService {
    
    @Autowired
    private ConfigValorisationArticleRepository configValorisationArticleRepository;
    
    public List<ConfigValorisationArticle> findAll() {
        return configValorisationArticleRepository.findAll();
    }
    
    public Optional<ConfigValorisationArticle> findById(Integer id) {
        return configValorisationArticleRepository.findById(id);
    }
    
    public Optional<ConfigValorisationArticle> findByIdArticle(Integer idArticle) {
        return configValorisationArticleRepository.findByIdArticle(idArticle);
    }
    
    public ConfigValorisationArticle save(ConfigValorisationArticle config) {
        return configValorisationArticleRepository.save(config);
    }
    
    public ConfigValorisationArticle creerOuMettreAJourConfig(Integer idArticle, 
                                                               String methodeValorisation,
                                                               Boolean gestionLot,
                                                               String typePeremption,
                                                               Integer delaiAlerte) {
        Optional<ConfigValorisationArticle> configOpt = findByIdArticle(idArticle);
        
        ConfigValorisationArticle config;
        if (configOpt.isPresent()) {
            config = configOpt.get();
        } else {
            config = new ConfigValorisationArticle();
            config.setIdArticle(idArticle);
        }
        
        config.setMethodeValorisation(methodeValorisation);
        config.setGestionLot(gestionLot);
        config.setTypePeremption(typePeremption);
        config.setDelaiAlertePeremption(delaiAlerte);
        
        return save(config);
    }
}

package service;

import entity.ProformaClient;
import entity.Article;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import repository.ProformaClientRepository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class ProformaClientService {
    
    @Autowired
    private ProformaClientRepository proformaClientRepository;
    
    @Autowired
    private ArticleService articleService;
    
    @Autowired
    private ReductionService reductionService;
    
    public List<ProformaClient> findAll() {
        return proformaClientRepository.findAll();
    }
    
    public Optional<ProformaClient> findById(Integer id) {
        return proformaClientRepository.findById(id);
    }
    
    public ProformaClient save(ProformaClient proformaClient) {
        return proformaClientRepository.save(proformaClient);
    }
    
    public List<ProformaClient> findByIdClient(Integer idClient) {
        return proformaClientRepository.findByIdClient(idClient);
    }
    
    public List<ProformaClient> findByStatut(String statut) {
        return proformaClientRepository.findByStatut(statut);
    }
    
    public ProformaClient creerProformaClient(Integer idClient, Integer idArticle, Integer quantite, 
                                              String codeReduction) {
        // Récupérer le prix de l'article
        Optional<Article> articleOpt = articleService.findById(idArticle);
        if (!articleOpt.isPresent()) {
            throw new RuntimeException("Article non trouvé");
        }
        
        Article article = articleOpt.get();
        // On utilise un prix de vente fixe ou calculé (ex: prix d'achat + marge)
        // Pour simplifier, on suppose que l'article a un prix unitaire
        Double prixUnitaire = 100.0; // À adapter selon votre logique métier
        
        // Créer la proforma
        ProformaClient proforma = new ProformaClient();
        proforma.setNumeroProforma(genererNumeroProforma());
        proforma.setIdClient(idClient);
        proforma.setIdArticle(idArticle);
        proforma.setQuantite(quantite);
        proforma.setPrixUnitaire(prixUnitaire);
        
        // Appliquer la réduction si fournie
        if (codeReduction != null && !codeReduction.isEmpty()) {
            Double montantBrut = prixUnitaire * quantite;
            Double montantReduction = reductionService.calculerMontantReduction(codeReduction, montantBrut);
            
            if (montantReduction > 0) {
                Optional<entity.Reduction> reductionOpt = reductionService.findByCode(codeReduction);
                reductionOpt.ifPresent(reduction -> proforma.setIdReduction(reduction.getIdReduction()));
                proforma.setMontantReduction(montantReduction);
            }
        }
        
        // Calculer le montant total
        proforma.calculerMontantTotal();
        
        // Date de validité: 30 jours à partir de maintenant
        proforma.setDateValidite(LocalDate.now().plusDays(30));
        
        return save(proforma);
    }
    
    public void accepterProforma(Integer idProformaClient) {
        ProformaClient proforma = findById(idProformaClient)
            .orElseThrow(() -> new RuntimeException("Proforma non trouvée"));
        
        if (proforma.estExpire()) {
            throw new RuntimeException("Proforma expirée");
        }
        
        proforma.setStatut("ACCEPTE");
        save(proforma);
    }
    
    public void refuserProforma(Integer idProformaClient) {
        ProformaClient proforma = findById(idProformaClient)
            .orElseThrow(() -> new RuntimeException("Proforma non trouvée"));
        
        proforma.setStatut("REFUSE");
        save(proforma);
    }
    
    private String genererNumeroProforma() {
        long count = proformaClientRepository.count() + 1;
        return "PFC-" + LocalDateTime.now().getYear() + "-" + String.format("%05d", count);
    }
}

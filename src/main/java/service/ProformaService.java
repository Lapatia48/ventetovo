package service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import entity.*;
import repository.*;
import java.time.LocalDate;
import java.util.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

@Service
public class ProformaService {
    
    @Autowired
    private ProformaRepository proformaRepository;
    
    @Autowired
    private ArticleRepository articleRepository;
    
    @Autowired
    private FournisseurRepository fournisseurRepository;
    
    @Autowired
    private PrixRepository prixRepository;
    
    // Générer un token unique pour une demande
    public String genererTokenDemande() {
        try {
            String timestamp = String.valueOf(System.currentTimeMillis());
            String random = UUID.randomUUID().toString();
            String input = timestamp + random;
            
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(input.getBytes());
            
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            // Fallback simple
            return "DEM-" + System.currentTimeMillis() + "-" + UUID.randomUUID().toString().substring(0, 8);
        }
    }
    
    // Générer un numéro de proforma unique
    public String genererNumeroProforma() {
        String datePart = LocalDate.now().toString().replace("-", "");
        String randomPart = String.valueOf((int)(Math.random() * 1000));
        return "PRO-" + datePart + "-" + randomPart;
    }
    
    // Créer des proformas pour une demande d'achat
    public List<Proforma> creerProformasPourDemande(Integer idArticle, Integer quantite) {
        List<Proforma> proformas = new ArrayList<>();
        
        // Récupérer l'article
        Optional<Article> articleOpt = articleRepository.findById(idArticle);
        if (articleOpt.isEmpty()) {
            return proformas;
        }
        
        // Récupérer tous les fournisseurs qui ont un prix d'achat pour cet article
        List<Prix> prixAchat = prixRepository.findByIdArticleAndType(idArticle, "ACHAT");
        if (prixAchat.isEmpty()) {
            return proformas;
        }
        
        // Générer un token unique pour cette demande
        String tokenDemande = genererTokenDemande();
        
        // Créer une proforma pour chaque fournisseur
        for (Prix prix : prixAchat) {
            // Générer un numéro unique pour chaque proforma
            String numeroProforma = genererNumeroProforma();
            
            // Créer la proforma
            Proforma proforma = new Proforma(
                numeroProforma,
                tokenDemande,
                idArticle,
                prix.getIdFournisseur(),
                quantite,
                prix.getMontant()
            );
            
            // Enrichir avec les informations de l'article et du fournisseur
            articleOpt.ifPresent(proforma::setArticle);
            fournisseurRepository.findById(prix.getIdFournisseur())
                .ifPresent(proforma::setFournisseur);
            
            proformas.add(proforma);
        }
        
        // Sauvegarder toutes les proformas
        return proformaRepository.saveAll(proformas);
    }
    
    // Récupérer toutes les proformas d'une demande
    public List<Proforma> getProformasByToken(String tokenDemande) {
        List<Proforma> proformas = proformaRepository.findByTokenDemande(tokenDemande);
        enrichirProformas(proformas);
        return proformas;
    }
    
    // Récupérer toutes les demandes (groupées par token)
    public Map<String, List<Proforma>> getAllDemandes() {
        List<Proforma> allProformas = proformaRepository.findAll();
        enrichirProformas(allProformas);
        
        // Grouper par token
        Map<String, List<Proforma>> demandes = new HashMap<>();
        for (Proforma proforma : allProformas) {
            demandes.computeIfAbsent(proforma.getTokenDemande(), k -> new ArrayList<>())
                   .add(proforma);
        }
        
        return demandes;
    }
    
    // Marquer une proforma comme sélectionnée
    public void selectionnerProforma(Integer idProforma) {
        Optional<Proforma> proformaOpt = proformaRepository.findById(idProforma);
        if (proformaOpt.isPresent()) {
            Proforma proforma = proformaOpt.get();
            
            // Mettre à jour toutes les proformas de la même demande
            List<Proforma> proformasDemande = proformaRepository.findByTokenDemande(proforma.getTokenDemande());
            for (Proforma p : proformasDemande) {
                if (p.getIdProforma().equals(idProforma)) {
                    p.setStatut("SELECTIONNE");
                } else {
                    p.setStatut("REJETE");
                }
            }
            
            proformaRepository.saveAll(proformasDemande);
        }
    }
    
    // Méthode utilitaire pour enrichir les proformas
    private void enrichirProformas(List<Proforma> proformas) {
        for (Proforma proforma : proformas) {
            if (proforma.getIdArticle() != null) {
                articleRepository.findById(proforma.getIdArticle())
                    .ifPresent(proforma::setArticle);
            }
            if (proforma.getIdFournisseur() != null) {
                fournisseurRepository.findById(proforma.getIdFournisseur())
                    .ifPresent(proforma::setFournisseur);
            }
        }
    }
}

-- =====================================================
-- VUES METIER (pour faciliter les requetes)
-- =====================================================

-- Vue stock avec alertes
CREATE VIEW v_stock_alerte AS
SELECT 
    a.code,
    a.designation,
    d.nom as depot,
    s.quantite,
    a.seuil_alerte,
    CASE 
        WHEN s.quantite <= a.seuil_alerte THEN 'ALERTE'
        ELSE 'OK'
    END as statut
FROM stock s
JOIN article a ON s.id_article = a.id_article
JOIN depot d ON s.id_depot = d.id_depot;

-- Vue valorisation stock
CREATE VIEW v_valorisation_stock AS
SELECT 
    a.code,
    a.designation,
    d.nom as depot,
    s.quantite,
    a.prix_achat,
    (s.quantite * a.prix_achat) as valeur_stock
FROM stock s
JOIN article a ON s.id_article = a.id_article
JOIN depot d ON s.id_depot = d.id_depot;

-- Vue commandes en attente de validation
CREATE VIEW v_demandes_a_valider AS
SELECT 
    da.numero,
    da.date_demande,
    u.nom || ' ' || u.prenom as demandeur,
    COUNT(l.id_ligne) as nb_lignes,
    da.statut
FROM demande_achat da
JOIN utilisateur u ON da.id_demandeur = u.id_utilisateur
LEFT JOIN ligne_demande_achat l ON da.id_demande = l.id_demande
WHERE da.statut = 'EN_ATTENTE'
GROUP BY da.id_demande, da.numero, da.date_demande, u.nom, u.prenom, da.statut;

-- =====================================================
-- INDEX ESSENTIELS
-- =====================================================

CREATE INDEX idx_stock_article ON stock(id_article);
CREATE INDEX idx_mouvement_date ON mouvement_stock(date_mouvement);
CREATE INDEX idx_demande_statut ON demande_achat(statut);
CREATE INDEX idx_commande_client_statut ON commande_client(statut);

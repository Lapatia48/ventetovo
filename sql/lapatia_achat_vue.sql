-- Création de la vue
CREATE VIEW vue_article AS
SELECT 
    a.id_article,
    a.code,
    a.designation,
    f.id_fournisseur,
    f.nom AS nom_fournisseur,
    p_dernier.montant AS prix_achat,
    p_dernier.date_prix AS date_prix
FROM article a
JOIN prix p_achat ON a.id_article = p_achat.id_article 
    AND p_achat.type = 'ACHAT'
JOIN fournisseur f ON p_achat.id_fournisseur = f.id_fournisseur
-- Sous-requête pour obtenir le dernier prix (date max) par article et fournisseur
JOIN (
    SELECT 
        id_article,
        id_fournisseur,
        MAX(date_prix) AS derniere_date
    FROM prix
    WHERE type = 'ACHAT'
    GROUP BY id_article, id_fournisseur
) p_max ON p_achat.id_article = p_max.id_article 
    AND p_achat.id_fournisseur = p_max.id_fournisseur 
    AND p_achat.date_prix = p_max.derniere_date
-- Sélectionner seulement les prix correspondant à la date max
JOIN prix p_dernier ON p_achat.id_article = p_dernier.id_article 
    AND p_achat.id_fournisseur = p_dernier.id_fournisseur 
    AND p_achat.date_prix = p_dernier.date_prix
    AND p_dernier.type = 'ACHAT';


CREATE VIEW v_bon_commande AS
SELECT 
    bc.id_bon_commande,
    bc.id_proforma,
    bc.date_commande,
    bc.statut,
    p.numero as numero_proforma,
    p.token_demande,
    p.quantite,
    p.prix_unitaire,
    p.montant_total,
    f.nom as nom_fournisseur,
    f.email as email_fournisseur,
    f.telephone as telephone_fournisseur,
    a.code as code_article,
    a.designation as designation_article
FROM bon_commande bc
JOIN proforma p ON bc.id_proforma = p.id_proforma
JOIN fournisseur f ON p.id_fournisseur = f.id_fournisseur
JOIN article a ON p.id_article = a.id_article;

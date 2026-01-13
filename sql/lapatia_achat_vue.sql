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
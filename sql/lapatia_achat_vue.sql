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


-- Vue pour les factures avec détails
CREATE VIEW v_facture_fournisseur AS
SELECT 
    ff.id_facture,
    ff.numero_facture,
    ff.id_bon_commande,
    ff.montant_total,
    ff.date_facture,
    ff.date_echeance,
    ff.statut as statut_facture,
    bc.date_commande,
    bc.statut as statut_bc,
    vbc.nom_fournisseur,
    vbc.designation_article,
    vbc.quantite
FROM facture_fournisseur ff
JOIN bon_commande bc ON ff.id_bon_commande = bc.id_bon_commande
JOIN v_bon_commande vbc ON bc.id_bon_commande = vbc.id_bon_commande;

-- Vue pour les bons de livraison avec détails
CREATE VIEW v_bon_livraison AS
SELECT 
    bl.id_bon_livraison,
    bl.numero_livraison,
    bl.id_bon_commande,
    bl.date_livraison,
    bl.transporteur,
    bl.numero_bon_transport,
    bl.statut as statut_livraison,
    bc.date_commande,
    vbc.nom_fournisseur,
    vbc.designation_article,
    vbc.quantite,
    vbc.montant_total
FROM bon_livraison bl
JOIN bon_commande bc ON bl.id_bon_commande = bc.id_bon_commande
JOIN v_bon_commande vbc ON bc.id_bon_commande = vbc.id_bon_commande;

-- Vue pour les bons de réception avec détails
CREATE VIEW v_bon_reception AS
SELECT 
    br.id_bon_reception,
    br.id_bon_livraison,
    br.id_article,
    br.quantite_commandee,
    br.quantite_recue,
    br.quantite_non_conforme,
    br.commentaire,
    br.date_reception,
    br.id_receptionnaire,
    a.code as code_article,
    a.designation as designation_article,
    bl.numero_livraison,
    bl.statut as statut_livraison,
    (br.quantite_recue - br.quantite_non_conforme) as quantite_conforme
FROM bon_reception br
JOIN article a ON br.id_article = a.id_article
JOIN bon_livraison bl ON br.id_bon_livraison = bl.id_bon_livraison;
TRUNCATE TABLE ligne_livraison_client RESTART IDENTITY CASCADE;
TRUNCATE TABLE livraison_client RESTART IDENTITY CASCADE;
TRUNCATE TABLE ligne_commande_client RESTART IDENTITY CASCADE;
TRUNCATE TABLE commande_client RESTART IDENTITY CASCADE;
TRUNCATE TABLE ligne_devis RESTART IDENTITY CASCADE;
TRUNCATE TABLE devis RESTART IDENTITY CASCADE;



--------------------------------------------------
-- 1. CLIENTS
--------------------------------------------------
INSERT INTO client (code_client, nom)
VALUES
('CLI-001', 'Client Test');


--------------------------------------------------
-- 2. DEVIS
--------------------------------------------------
INSERT INTO devis
(numero_devis, id_client, statut, montant_total_ht, montant_ttc, id_commercial)
VALUES
('DEV-001', 1, 'ACCEPTE', 1000, 1200, 5);


--------------------------------------------------
-- 3. LIGNES DEVIS
--------------------------------------------------
INSERT INTO ligne_devis (id_devis, id_article, quantite, prix_unitaire_ht)
VALUES
(1, 1, 50, 15),
(1, 2, 20, 20);


--------------------------------------------------
-- 4. COMMANDES CLIENT
--------------------------------------------------
INSERT INTO commande_client
(numero_commande, id_devis, id_client, statut, montant_total_ht, montant_total_ttc, id_commercial)
VALUES
('CMD-001', 1, 1, 'CONFIRMEE', 1000, 1200, 5);


--------------------------------------------------
-- 5. LIGNES COMMANDES
--------------------------------------------------
INSERT INTO ligne_commande_client
(id_commande, id_article, quantite_commandee, prix_unitaire_ht)
VALUES
(1, 1, 50, 15),
(1, 2, 20, 20);


--------------------------------------------------
-- 6. LIVRAISONS
--------------------------------------------------
INSERT INTO livraison_client
(numero_livraison, id_commande, date_livraison,
 transporteur, numero_suivi, statut,
 id_preparateur, id_livreur)
VALUES
(
 'LIV-001',
 (SELECT id_commande FROM commande_client WHERE numero_commande='CMD-001'),
 DATE '2024-01-20',
 'Madagascar Express',
 'MDX001',
 'LIVREE',
 3, 4
),
(
 'LIV-002',
 (SELECT id_commande FROM commande_client WHERE numero_commande='CMD-002'),
 DATE '2024-01-26',
 'Chronopost',
 'CHR002',
 'EXPEDIEE',
 2, 3
);

--------------------------------------------------
-- 7. LIGNES LIVRAISON
--------------------------------------------------
INSERT INTO ligne_livraison_client
(id_livraison, id_ligne_commande, quantite_livree, numero_lot)
VALUES
(
 (SELECT id_livraison FROM livraison_client WHERE numero_livraison='LIV-001'),
 (SELECT id_ligne_commande FROM ligne_commande_client lc
   JOIN commande_client c ON c.id_commande = lc.id_commande
   WHERE c.numero_commande='CMD-001' AND lc.id_article=1),
 50,
 'LOT-RIZ-001'
),
(
 (SELECT id_livraison FROM livraison_client WHERE numero_livraison='LIV-002'),
 (SELECT id_ligne_commande FROM ligne_commande_client lc
   JOIN commande_client c ON c.id_commande = lc.id_commande
   WHERE c.numero_commande='CMD-002' AND lc.id_article=1),
 30,
 'LOT-RIZ-002'
);

--------------------------------------------------
-- 8. FACTURES
--------------------------------------------------
INSERT INTO facture_client
(numero_facture, id_livraison, id_commande, id_client,
 date_facture, statut,
 montant_total_ht, montant_tva, montant_ttc, montant_paye,
 mode_paiement, created_by)
VALUES
(
 'FAC-001',
 (SELECT id_livraison FROM livraison_client WHERE numero_livraison='LIV-001'),
 (SELECT id_commande FROM commande_client WHERE numero_commande='CMD-001'),
 (SELECT id_client FROM client WHERE code_client='CLI-001'),
 DATE '2024-01-21',
 'PAYEE',
 1000, 200, 1200, 1200,
 'VIREMENT',
 1
),
(
 'FAC-002',
 (SELECT id_livraison FROM livraison_client WHERE numero_livraison='LIV-002'),
 (SELECT id_commande FROM commande_client WHERE numero_commande='CMD-002'),
 (SELECT id_client FROM client WHERE code_client='CLI-002'),
 DATE '2024-01-27',
 'ENVOYEE',
 750, 150, 900, 0,
 'CHEQUE',
 2
);

--------------------------------------------------
-- 9. LIGNES FACTURE
--------------------------------------------------
INSERT INTO ligne_facture_client
(id_facture, id_ligne_livraison, id_article, description,
 quantite, prix_unitaire_ht, remise,
 montant_ht, tva_taux, montant_tva, montant_ttc)
VALUES
(
 (SELECT id_facture FROM facture_client WHERE numero_facture='FAC-001'),
 (SELECT id_ligne_livraison FROM ligne_livraison_client LIMIT 1),
 1,
 'Riz blanc 1kg',
 50, 15.00, 0,
 750.00, 20, 150.00, 900.00
),
(
 (SELECT id_facture FROM facture_client WHERE numero_facture='FAC-002'),
 (SELECT id_ligne_livraison FROM ligne_livraison_client OFFSET 1 LIMIT 1),
 1,
 'Riz blanc 1kg',
 30, 15.00, 0,
 450.00, 20, 90.00, 540.00
);

--------------------------------------------------
-- 10. REGLEMENTS
--------------------------------------------------
INSERT INTO reglement_client
(numero_reglement, id_client, date_reglement,
 mode_reglement, montant, statut,
 reference_paiement, created_by)
VALUES
(
 'REG-001',
 (SELECT id_client FROM client WHERE code_client='CLI-001'),
 DATE '2024-01-22',
 'VIREMENT',
 1200,
 'ENCAISSE',
 'VIR001',
 1
),
(
 'REG-002',
 (SELECT id_client FROM client WHERE code_client='CLI-002'),
 DATE '2024-02-05',
 'CHEQUE',
 900,
 'EN_ATTENTE',
 'CHQ002',
 2
);

--------------------------------------------------
-- 11. LIAISON FACTURE / REGLEMENT
--------------------------------------------------
INSERT INTO facture_reglement
(id_facture, id_reglement, montant_affecte)
VALUES
(
 (SELECT id_facture FROM facture_client WHERE numero_facture='FAC-001'),
 (SELECT id_reglement FROM reglement_client WHERE numero_reglement='REG-001'),
 1200
);


INSERT INTO prix (id_article, id_fournisseur, type, montant, date_prix) VALUES
(1, 1, 'VENTE', 1500, '2026-01-12'),  -- Grossiste A
(1, 2, 'VENTE', 2700, '2026-01-12'),  -- Grossiste B
(1, 3, 'VENTE', 4400, '2026-01-12');  -- Grossiste C
-- =====================================================
-- DONNEES INITIALES POUR TESTER LES FONCTIONS ACHAT/VENTE
-- =====================================================

-- 1. Depot (si pas déjà créé)
INSERT INTO depot (nom) VALUES ('Depot Principal') ON CONFLICT (nom) DO NOTHING;

-- 2. Articles (si pas déjà créés)
INSERT INTO article (code, designation, prix_achat, prix_vente, seuil_alerte) VALUES
('ART001', 'Ordinateur Portable HP', 2500000.00, 3500000.00, 5),
('ART002', 'Souris sans fil', 25000.00, 35000.00, 20),
('ART003', 'Clavier mecanique', 150000.00, 200000.00, 10),
('ART004', 'Ecran 24 pouces', 800000.00, 1200000.00, 5),
('ART005', 'Cable HDMI', 15000.00, 25000.00, 30)
ON CONFLICT (code) DO NOTHING;

-- 3. Stock initial (quantités de départ)
-- Pour chaque article dans le dépôt principal, on met une quantité initiale
INSERT INTO stock (id_article, id_depot, quantite) VALUES
(1, 1, 10),  -- Ordinateur: 10 unités
(2, 1, 50),  -- Souris: 50 unités
(3, 1, 25),  -- Clavier: 25 unités
(4, 1, 8),   -- Ecran: 8 unités (en dessous du seuil 5, donc "stock faible")
(5, 1, 100)  -- Cable: 100 unités
ON CONFLICT (id_article, id_depot) DO UPDATE SET quantite = EXCLUDED.quantite;

-- 4. Caisse initiale (solde de départ)
INSERT INTO caisse (solde) VALUES (10000000.00)  -- 10 millions d'ariary
ON CONFLICT (id_caisse) DO NOTHING;

-- =====================================================
-- VERIFICATION DES DONNEES
-- =====================================================

-- Vérifier les articles
SELECT id_article, code, designation, prix_achat, prix_vente, seuil_alerte FROM article;

-- Vérifier le stock
SELECT s.id_stock, s.id_article, a.designation, s.id_depot, d.nom AS depot_nom, s.quantite, s.date_maj
FROM stock s
JOIN article a ON s.id_article = a.id_article
JOIN depot d ON s.id_depot = d.id_depot;

-- Vérifier la caisse
SELECT id_caisse, solde, date_maj FROM caisse;
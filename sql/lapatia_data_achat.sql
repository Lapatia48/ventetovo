-- 1. Insertion des rôles
INSERT INTO role (id_role, nom_role, niveau_validation) VALUES
(1, 'ADMIN', 0),
(2, 'MAGASINIER', 0),
(3, 'VALIDEUR_N1', 1),
(4, 'VALIDEUR_N2', 2);

-- 2. Insertion des utilisateurs
INSERT INTO utilisateur (nom, prenom, email, mot_de_passe, id_role, actif) VALUES
('Dupont', 'Jean', 'admin@vente.com', '1234', 1, true), 
('Martin', 'Marie', 'magasinier@vente.com', '1234', 2, true), 
('Durand', 'Pierre', 'valideur1@vente.com', '1234', 3, true), 
('Leroy', 'Sophie', 'valideur2@vente.com', '1234', 4, true); 

-- 3. Insertion des fournisseurs
INSERT INTO fournisseur (nom, email, telephone) VALUES
('Grossiste A', 'contact@grossiste-a.mg', '020 12 345 67'),
('Grossiste B', 'info@grossiste-b.mg', '020 23 456 78'),
('Grossiste C', 'vente@grossiste-c.mg', '020 34 567 89');

-- 4. Insertion des articles (chaque article lié à un fournisseur principal)
INSERT INTO article (code, designation) VALUES
('RIZ001', 'Riz blanc 1kg'),
('SUC001', 'Sucre cristal 1kg');

-- 5. Insertion des prix pour chaque article et chaque fournisseur (type ACHAT)
-- Pour l'article 1 (Riz) - Prix d'achat
INSERT INTO prix (id_article, id_fournisseur, type, montant, date_prix) VALUES
(1, 1, 'ACHAT', 500, '2026-01-12'),  -- Grossiste A
(1, 2, 'ACHAT', 700, '2026-01-12'),  -- Grossiste B
(1, 3, 'ACHAT', 400, '2026-01-12');  -- Grossiste C

-- Pour l'article 2 (Sucre) - Prix d'achat
INSERT INTO prix (id_article, id_fournisseur, type, montant, date_prix) VALUES
(2, 1, 'ACHAT', 800, '2026-01-12'),  -- Grossiste A
(2, 2, 'ACHAT', 750, '2026-01-12'),  -- Grossiste B
(2, 3, 'ACHAT', 780, '2026-01-12');  -- Grossiste C


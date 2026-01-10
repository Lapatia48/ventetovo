-- =====================================================
-- DONNEES DE DEMO
-- =====================================================

-- Roles
INSERT INTO role (nom_role, niveau_validation) VALUES
('Admin', 2),
('Responsable Achats', 2),
('Acheteur', 1),
('Magasinier', 0),
('Commercial', 1),
('Responsable Ventes', 2);

-- Utilisateurs
INSERT INTO utilisateur (nom, prenom, email, mot_de_passe, id_role) VALUES
('ADMIN', 'Admin', 'admin@vente-tovo.mg', 'admin123', 1),
('RAKOTO', 'Jean', 'jean@vente-tovo.mg', 'pass123', 2),
('RABE', 'Marie', 'marie@vente-tovo.mg', 'pass123', 3),
('RANDRIA', 'Paul', 'paul@vente-tovo.mg', 'pass123', 4),
('RASOA', 'Sophie', 'sophie@vente-tovo.mg', 'pass123', 5);

-- Depots
INSERT INTO depot (nom) VALUES
('Depot Principal'),
('Depot Secondaire');

-- Articles
INSERT INTO article (code, designation, prix_achat, prix_vente, seuil_alerte) VALUES
('ART001', 'Ordinateur Portable HP', 2500000, 3500000, 5),
('ART002', 'Souris sans fil', 25000, 35000, 20),
('ART003', 'Clavier mecanique', 150000, 200000, 10),
('ART004', 'Ecran 24 pouces', 800000, 1200000, 5),
('ART005', 'Cable HDMI', 15000, 25000, 30);

-- Stock initial
INSERT INTO stock (id_article, id_depot, quantite) VALUES
(1, 1, 10),
(2, 1, 50),
(3, 1, 25),
(4, 1, 8),
(5, 1, 100),
(1, 2, 5),
(2, 2, 30);

-- Fournisseurs
INSERT INTO fournisseur (nom, email, telephone) VALUES
('Tech Distribution MG', 'contact@techdist.mg', '034 00 111 22'),
('Import Pro', 'info@importpro.mg', '033 11 222 33');

-- Clients
INSERT INTO client (nom, email, telephone) VALUES
('Entreprise ALPHA', 'alpha@company.mg', '034 22 333 44'),
('Societe BETA', 'beta@company.mg', '033 33 444 55'),
('GAMMA SARL', 'gamma@company.mg', '032 44 555 66');

-- Caisse initiale
INSERT INTO caisse (solde) VALUES (10000000); -- 10 millions d'ariary

-- =====================================================
-- COMMENTAIRES
-- =====================================================

COMMENT ON DATABASE vente_tovo IS 'Systeme de gestion Achats/Ventes/Stock - Version Demo';
COMMENT ON TABLE demande_achat IS 'REGLE: Le valideur doit etre different du demandeur';
COMMENT ON TABLE commande_client IS 'REGLE: Remise > 10% necessite validation responsable';
COMMENT ON TABLE ligne_inventaire IS 'REGLE: Le compteur ne peut pas valider son inventaire';
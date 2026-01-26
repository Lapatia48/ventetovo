-- =====================================================
-- SCRIPT COMPLET INITIALISATION BASE DE DONNEES
-- Systeme de Gestion Achat-Vente-Stock
-- Date: 2026-01-25
-- Sans accents, cedilles ni apostrophes
-- =====================================================

-- Suppression des tables existantes (dans le bon ordre)

create database vente_tovo;
\c vente_tovo;

DROP TABLE IF EXISTS Inventaire_Detail CASCADE;
DROP TABLE IF EXISTS Inventaire CASCADE;
DROP TABLE IF EXISTS Cloture_Stock_Mensuelle CASCADE;
DROP TABLE IF EXISTS Reservation_Stock CASCADE;
DROP TABLE IF EXISTS Mouvement_Stock CASCADE;
DROP TABLE IF EXISTS Config_Valorisation_Article CASCADE;
DROP TABLE IF EXISTS Lot CASCADE;
DROP TABLE IF EXISTS Type_Mouvement_Stock CASCADE;

DROP TABLE IF EXISTS Bon_Livraison_Client CASCADE;
DROP TABLE IF EXISTS Facture_Client CASCADE;
DROP TABLE IF EXISTS Bon_Commande_Client CASCADE;
DROP TABLE IF EXISTS Proforma_Client CASCADE;
DROP TABLE IF EXISTS Reduction CASCADE;
DROP TABLE IF EXISTS Client CASCADE;

DROP TABLE IF EXISTS Achat_Finance CASCADE;
DROP TABLE IF EXISTS Bon_Reception CASCADE;
DROP TABLE IF EXISTS Bon_Livraison CASCADE;
DROP TABLE IF EXISTS Facture_Fournisseur CASCADE;
DROP TABLE IF EXISTS Bon_Commande CASCADE;
DROP TABLE IF EXISTS Proforma CASCADE;
DROP TABLE IF EXISTS Prix CASCADE;
DROP TABLE IF EXISTS Stock CASCADE;
DROP TABLE IF EXISTS Article CASCADE;
DROP TABLE IF EXISTS Fournisseur CASCADE;
DROP TABLE IF EXISTS Utilisateur CASCADE;
DROP TABLE IF EXISTS Role CASCADE;

-- =====================================================
-- REFERENTIELS
-- =====================================================

-- Table Role
CREATE TABLE Role (
    id_role SERIAL PRIMARY KEY,
    nom VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);

-- Table Utilisateur
CREATE TABLE Utilisateur (
    id_utilisateur SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    mot_de_passe VARCHAR(255) NOT NULL,
    id_role INTEGER REFERENCES Role(id_role),
    actif BOOLEAN DEFAULT TRUE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table Fournisseur
CREATE TABLE Fournisseur (
    id_fournisseur SERIAL PRIMARY KEY,
    nom VARCHAR(200) NOT NULL,
    adresse TEXT,
    telephone VARCHAR(20),
    email VARCHAR(100),
    contact VARCHAR(100),
    conditions_paiement TEXT,
    delai_livraison INTEGER,
    actif BOOLEAN DEFAULT TRUE
);

-- Table Article
CREATE TABLE Article (
    id_article SERIAL PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL,
    designation VARCHAR(200) NOT NULL,
    description TEXT,
    unite VARCHAR(20) DEFAULT 'unite',
    categorie VARCHAR(50),
    actif BOOLEAN DEFAULT TRUE
);

-- Table Stock
CREATE TABLE Stock (
    id_stock SERIAL PRIMARY KEY,
    id_article INTEGER REFERENCES Article(id_article) UNIQUE,
    quantite_disponible INTEGER DEFAULT 0,
    quantite_reservee INTEGER DEFAULT 0,
    stock_minimum INTEGER DEFAULT 0,
    cout_moyen_unitaire DECIMAL(15,2) DEFAULT 0,
    valeur_stock DECIMAL(15,2) DEFAULT 0,
    date_derniere_maj TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table Prix (historique prix fournisseur)
CREATE TABLE Prix (
    id_prix SERIAL PRIMARY KEY,
    id_article INTEGER REFERENCES Article(id_article),
    id_fournisseur INTEGER REFERENCES Fournisseur(id_fournisseur),
    type VARCHAR(10) NOT NULL,
    montant DECIMAL(15,2) NOT NULL,
    date_prix DATE NOT NULL
);

-- Table Client
CREATE TABLE Client (
    id_client SERIAL PRIMARY KEY,
    nom VARCHAR(200) NOT NULL,
    adresse TEXT,
    telephone VARCHAR(20),
    email VARCHAR(100),
    contact VARCHAR(100),
    conditions_paiement TEXT,
    actif BOOLEAN DEFAULT TRUE
);

-- Table Reduction
CREATE TABLE Reduction (
    id_reduction SERIAL PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL,
    libelle VARCHAR(200) NOT NULL,
    type_reduction VARCHAR(20) CHECK (type_reduction IN ('POURCENTAGE', 'MONTANT')),
    valeur DECIMAL(15,2) NOT NULL,
    date_debut DATE,
    date_fin DATE,
    actif BOOLEAN DEFAULT TRUE
);

-- =====================================================
-- MODULE ACHAT
-- =====================================================

-- Table Proforma Fournisseur
CREATE TABLE Proforma (
    id_proforma SERIAL PRIMARY KEY,
    numero VARCHAR(50) UNIQUE NOT NULL,
    token_demande VARCHAR(100) NOT NULL,
    id_article INTEGER REFERENCES Article(id_article),
    id_fournisseur INTEGER REFERENCES Fournisseur(id_fournisseur),
    quantite INTEGER NOT NULL,
    prix_unitaire DECIMAL(15,2) NOT NULL,
    montant_total DECIMAL(15,2) NOT NULL,
    date_proforma TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    statut VARCHAR(20) DEFAULT 'EN_ATTENTE'
);

-- Table Bon de Commande Fournisseur
CREATE TABLE Bon_Commande (
    id_bon_commande SERIAL PRIMARY KEY,
    id_proforma INTEGER REFERENCES Proforma(id_proforma),
    date_commande TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    statut VARCHAR(20) DEFAULT 'EN_COURS'
);

-- Table Facture Fournisseur
CREATE TABLE Facture_Fournisseur (
    id_facture SERIAL PRIMARY KEY,
    numero_facture VARCHAR(50) UNIQUE NOT NULL,
    id_bon_commande INTEGER REFERENCES Bon_Commande(id_bon_commande),
    montant_total DECIMAL(15,2) NOT NULL,
    date_facture DATE NOT NULL,
    date_echeance DATE,
    statut VARCHAR(20) DEFAULT 'EN_ATTENTE'
);

-- Table Bon de Livraison Fournisseur
CREATE TABLE Bon_Livraison (
    id_bon_livraison SERIAL PRIMARY KEY,
    numero_livraison VARCHAR(50) UNIQUE NOT NULL,
    id_bon_commande INTEGER REFERENCES Bon_Commande(id_bon_commande),
    date_livraison DATE NOT NULL,
    transporteur VARCHAR(100),
    numero_bon_transport VARCHAR(100),
    statut VARCHAR(20) DEFAULT 'EN_ATTENTE'
);

-- Table Bon de Reception
CREATE TABLE Bon_Reception (
    id_bon_reception SERIAL PRIMARY KEY,
    id_bon_livraison INTEGER REFERENCES Bon_Livraison(id_bon_livraison),
    id_article INTEGER REFERENCES Article(id_article),
    quantite_commandee INTEGER NOT NULL,
    quantite_recue INTEGER NOT NULL,
    quantite_non_conforme INTEGER DEFAULT 0,
    date_reception DATE NOT NULL,
    commentaire TEXT,
    id_receptionnaire INTEGER REFERENCES Utilisateur(id_utilisateur)
);

-- Table Achat Finance (configuration seuil)
CREATE TABLE Achat_Finance (
    id_achat_finance SERIAL PRIMARY KEY,
    montant_seuil DECIMAL(15,2) NOT NULL,
    date_maj TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description TEXT,
    actif BOOLEAN DEFAULT TRUE
);

-- =====================================================
-- MODULE VENTE
-- =====================================================

-- Table Proforma Client
CREATE TABLE Proforma_Client (
    id_proforma_client SERIAL PRIMARY KEY,
    numero_proforma VARCHAR(50) UNIQUE NOT NULL,
    id_client INTEGER REFERENCES Client(id_client),
    id_article INTEGER REFERENCES Article(id_article),
    quantite INTEGER NOT NULL,
    prix_unitaire DECIMAL(15,2) NOT NULL,
    id_reduction INTEGER REFERENCES Reduction(id_reduction),
    montant_reduction DECIMAL(15,2) DEFAULT 0,
    montant_total DECIMAL(15,2) NOT NULL,
    statut VARCHAR(20) DEFAULT 'EN_ATTENTE' CHECK (statut IN ('EN_ATTENTE', 'ACCEPTE', 'REJETE')),
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_validation TIMESTAMP,
    id_utilisateur INTEGER REFERENCES Utilisateur(id_utilisateur),
    observations TEXT
);

-- Table Bon de Commande Client
CREATE TABLE Bon_Commande_Client (
    id_bon_commande_client SERIAL PRIMARY KEY,
    numero_bc VARCHAR(50) UNIQUE NOT NULL,
    id_proforma_client INTEGER REFERENCES Proforma_Client(id_proforma_client),
    id_client INTEGER REFERENCES Client(id_client),
    id_article INTEGER REFERENCES Article(id_article),
    quantite INTEGER NOT NULL,
    prix_unitaire DECIMAL(15,2) NOT NULL,
    montant_total DECIMAL(15,2) NOT NULL,
    statut VARCHAR(20) DEFAULT 'EN_COURS' CHECK (statut IN ('EN_COURS', 'LIVRE_PARTIEL', 'LIVRE_TOTAL', 'ANNULE')),
    date_commande TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_livraison_prevue DATE,
    id_utilisateur INTEGER REFERENCES Utilisateur(id_utilisateur)
);

-- Table Facture Client
CREATE TABLE Facture_Client (
    id_facture_client SERIAL PRIMARY KEY,
    numero_facture VARCHAR(50) UNIQUE NOT NULL,
    id_bon_commande_client INTEGER REFERENCES Bon_Commande_Client(id_bon_commande_client),
    id_client INTEGER REFERENCES Client(id_client),
    montant_ht DECIMAL(15,2) NOT NULL,
    montant_tva DECIMAL(15,2) DEFAULT 0,
    montant_ttc DECIMAL(15,2) NOT NULL,
    montant_paye DECIMAL(15,2) DEFAULT 0,
    statut_paiement VARCHAR(20) DEFAULT 'NON_PAYE' CHECK (statut_paiement IN ('NON_PAYE', 'PAYE_PARTIEL', 'PAYE_TOTAL')),
    date_facture DATE NOT NULL,
    date_echeance DATE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table Bon de Livraison Client
CREATE TABLE Bon_Livraison_Client (
    id_bon_livraison_client SERIAL PRIMARY KEY,
    numero_bl VARCHAR(50) UNIQUE NOT NULL,
    id_facture_client INTEGER REFERENCES Facture_Client(id_facture_client),
    id_client INTEGER REFERENCES Client(id_client),
    quantite_livree INTEGER NOT NULL,
    date_livraison DATE,
    statut VARCHAR(20) DEFAULT 'EN_PREPARATION' CHECK (statut IN ('EN_PREPARATION', 'EXPEDIE', 'LIVRE', 'ANNULE')),
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_expedition TIMESTAMP
);

-- =====================================================
-- MODULE GESTION DE STOCK
-- =====================================================

-- Table Type de Mouvement Stock
CREATE TABLE Type_Mouvement_Stock (
    id_type_mouvement SERIAL PRIMARY KEY,
    code VARCHAR(20) UNIQUE NOT NULL,
    libelle VARCHAR(100) NOT NULL,
    sens VARCHAR(10) CHECK (sens IN ('ENTREE', 'SORTIE')),
    description TEXT
);

-- Table Configuration Valorisation Article
CREATE TABLE Config_Valorisation_Article (
    id_config SERIAL PRIMARY KEY,
    id_article INTEGER REFERENCES Article(id_article) UNIQUE,
    methode_valorisation VARCHAR(10) DEFAULT 'CMUP' CHECK (methode_valorisation IN ('FIFO', 'CMUP')),
    gestion_lot BOOLEAN DEFAULT FALSE,
    type_peremption VARCHAR(10) CHECK (type_peremption IN ('DLC', 'DLUO', NULL)),
    delai_alerte_peremption INTEGER DEFAULT 30,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table Lot
CREATE TABLE Lot (
    id_lot SERIAL PRIMARY KEY,
    numero_lot VARCHAR(50) UNIQUE NOT NULL,
    id_article INTEGER REFERENCES Article(id_article),
    id_fournisseur INTEGER REFERENCES Fournisseur(id_fournisseur),
    quantite_initiale INTEGER NOT NULL,
    quantite_restante INTEGER NOT NULL,
    cout_unitaire DECIMAL(15,2) NOT NULL,
    date_fabrication DATE,
    dlc DATE,
    dluo DATE,
    statut VARCHAR(20) DEFAULT 'ACTIF' CHECK (statut IN ('ACTIF', 'EPUISE', 'EXPIRE', 'BLOQUE')),
    reference_document VARCHAR(50),
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table Mouvement Stock
CREATE TABLE Mouvement_Stock (
    id_mouvement SERIAL PRIMARY KEY,
    numero_mouvement VARCHAR(50) UNIQUE NOT NULL,
    id_type_mouvement INTEGER REFERENCES Type_Mouvement_Stock(id_type_mouvement),
    id_article INTEGER REFERENCES Article(id_article),
    id_lot INTEGER REFERENCES Lot(id_lot),
    quantite INTEGER NOT NULL,
    cout_unitaire DECIMAL(15,2) NOT NULL,
    cout_total DECIMAL(15,2) NOT NULL,
    reference_document VARCHAR(50),
    type_document VARCHAR(50),
    id_utilisateur INTEGER REFERENCES Utilisateur(id_utilisateur),
    date_mouvement TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    cloture BOOLEAN DEFAULT FALSE,
    observations TEXT
);

-- Table Reservation Stock
CREATE TABLE Reservation_Stock (
    id_reservation SERIAL PRIMARY KEY,
    id_article INTEGER REFERENCES Article(id_article),
    id_lot INTEGER REFERENCES Lot(id_lot),
    quantite INTEGER NOT NULL,
    reference_commande VARCHAR(50),
    id_bon_commande_client INTEGER REFERENCES Bon_Commande_Client(id_bon_commande_client),
    statut VARCHAR(20) DEFAULT 'ACTIVE' CHECK (statut IN ('ACTIVE', 'ANNULEE', 'CONSOMMEE')),
    date_reservation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_expiration TIMESTAMP,
    date_annulation TIMESTAMP
);

-- Table Inventaire
CREATE TABLE Inventaire (
    id_inventaire SERIAL PRIMARY KEY,
    numero_inventaire VARCHAR(50) UNIQUE NOT NULL,
    type_inventaire VARCHAR(20) CHECK (type_inventaire IN ('TOURNANT', 'ANNUEL', 'EXCEPTIONNEL')),
    date_inventaire DATE NOT NULL,
    statut VARCHAR(20) DEFAULT 'EN_COURS' CHECK (statut IN ('EN_COURS', 'TERMINE', 'VALIDE')),
    id_utilisateur INTEGER REFERENCES Utilisateur(id_utilisateur),
    observations TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table Detail Inventaire
CREATE TABLE Inventaire_Detail (
    id_inventaire_detail SERIAL PRIMARY KEY,
    id_inventaire INTEGER REFERENCES Inventaire(id_inventaire),
    id_article INTEGER REFERENCES Article(id_article),
    id_lot INTEGER REFERENCES Lot(id_lot),
    quantite_theorique INTEGER NOT NULL,
    quantite_physique INTEGER NOT NULL,
    ecart INTEGER GENERATED ALWAYS AS (quantite_physique - quantite_theorique) STORED,
    valeur_ecart DECIMAL(15,2),
    cout_unitaire DECIMAL(15,2),
    observations TEXT
);

-- Table Cloture Mensuelle
CREATE TABLE Cloture_Stock_Mensuelle (
    id_cloture SERIAL PRIMARY KEY,
    mois INTEGER CHECK (mois BETWEEN 1 AND 12),
    annee INTEGER,
    valeur_stock_total DECIMAL(15,2),
    quantite_stock_total INTEGER,
    nombre_articles INTEGER,
    nombre_mouvements INTEGER,
    valeur_entrees DECIMAL(15,2),
    valeur_sorties DECIMAL(15,2),
    ecart_inventaire DECIMAL(15,2) DEFAULT 0,
    statut VARCHAR(20) DEFAULT 'EN_COURS' CHECK (statut IN ('EN_COURS', 'CLOTURE')),
    date_cloture TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_utilisateur INTEGER REFERENCES Utilisateur(id_utilisateur),
    UNIQUE(mois, annee)
);

-- =====================================================
-- VUES
-- =====================================================

-- Vue Articles (dernier prix achat par fournisseur)
CREATE OR REPLACE VIEW vue_article AS
SELECT 
    a.id_article,
    a.code,
    a.designation,
    f.id_fournisseur,
    f.nom AS nom_fournisseur,
    p_dernier.montant AS prix_achat,
    p_dernier.date_prix AS date_dernier_prix
FROM article a
JOIN prix p_achat ON a.id_article = p_achat.id_article
    AND p_achat.type = 'ACHAT'
JOIN fournisseur f ON p_achat.id_fournisseur = f.id_fournisseur
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
JOIN prix p_dernier ON p_achat.id_article = p_dernier.id_article
    AND p_achat.id_fournisseur = p_dernier.id_fournisseur
    AND p_achat.date_prix = p_dernier.date_prix
    AND p_dernier.type = 'ACHAT';

-- Vue Bon de Commande (forme attendue par l'ancien module Achat)
CREATE OR REPLACE VIEW v_bon_commande AS
SELECT 
    bc.id_bon_commande,
    bc.id_proforma,
    bc.date_commande,
    bc.statut,
    p.numero AS numero_proforma,
    p.token_demande,
    p.quantite,
    p.prix_unitaire,
    p.montant_total,
    f.nom AS nom_fournisseur,
    f.email AS email_fournisseur,
    f.telephone AS telephone_fournisseur,
    a.code AS code_article,
    a.designation AS designation_article
FROM bon_commande bc
JOIN proforma p ON bc.id_proforma = p.id_proforma
JOIN fournisseur f ON p.id_fournisseur = f.id_fournisseur
JOIN article a ON p.id_article = a.id_article;

-- Vue Facture Fournisseur
CREATE OR REPLACE VIEW v_facture_fournisseur AS
SELECT 
    ff.id_facture,
    ff.numero_facture,
    ff.id_bon_commande,
    ff.montant_total,
    ff.date_facture,
    ff.date_echeance,
    ff.statut AS statut_facture,
    bc.date_commande,
    bc.statut AS statut_bc,
    vbc.nom_fournisseur,
    vbc.designation_article,
    vbc.quantite
FROM facture_fournisseur ff
JOIN bon_commande bc ON ff.id_bon_commande = bc.id_bon_commande
JOIN v_bon_commande vbc ON bc.id_bon_commande = vbc.id_bon_commande;

-- Vue Bon Livraison
CREATE OR REPLACE VIEW v_bon_livraison AS
SELECT 
    bl.id_bon_livraison,
    bl.numero_livraison,
    bl.id_bon_commande,
    bl.date_livraison,
    bl.transporteur,
    bl.numero_bon_transport,
    bl.statut AS statut_livraison,
    bc.date_commande,
    vbc.nom_fournisseur,
    vbc.designation_article,
    vbc.quantite,
    vbc.montant_total
FROM bon_livraison bl
JOIN bon_commande bc ON bl.id_bon_commande = bc.id_bon_commande
JOIN v_bon_commande vbc ON bc.id_bon_commande = vbc.id_bon_commande;

-- Vue Bon Reception
CREATE OR REPLACE VIEW v_bon_reception AS
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
    a.code AS code_article,
    a.designation AS designation_article,
    bl.numero_livraison,
    bl.statut AS statut_livraison,
    (br.quantite_recue - br.quantite_non_conforme) AS quantite_conforme
FROM bon_reception br
JOIN article a ON br.id_article = a.id_article
JOIN bon_livraison bl ON br.id_bon_livraison = bl.id_bon_livraison;

-- Vue Etat Stock Temps Reel
CREATE OR REPLACE VIEW V_Etat_Stock_Temps_Reel AS
SELECT 
    a.id_article,
    a.code,
    a.designation,
    s.quantite_disponible,
    s.quantite_reservee,
    s.stock_minimum,
    s.cout_moyen_unitaire,
    s.valeur_stock,
    CASE 
        WHEN s.quantite_disponible = 0 THEN 'RUPTURE'
        WHEN s.quantite_disponible <= s.stock_minimum THEN 'ALERTE'
        ELSE 'OK'
    END as statut_stock
FROM Article a
LEFT JOIN Stock s ON a.id_article = s.id_article;

-- Vue Lots Actifs
CREATE OR REPLACE VIEW V_Lots_Actifs AS
SELECT 
    l.id_lot,
    l.numero_lot,
    a.code as code_article,
    a.designation as designation_article,
    l.quantite_initiale,
    l.quantite_restante,
    l.cout_unitaire,
    l.date_fabrication,
    l.dlc,
    l.dluo,
    l.statut,
    CASE 
        WHEN l.dlc IS NOT NULL THEN l.dlc - CURRENT_DATE
        WHEN l.dluo IS NOT NULL THEN l.dluo - CURRENT_DATE
        ELSE NULL
    END as jours_avant_peremption
FROM Lot l
JOIN Article a ON l.id_article = a.id_article
WHERE l.statut = 'ACTIF';

-- Vue Valorisation Stock
CREATE OR REPLACE VIEW V_Valorisation_Stock AS
SELECT 
    COALESCE(c.methode_valorisation, 'CMUP') as methode_valorisation,
    a.id_article,
    a.code,
    a.designation,
    s.quantite_disponible + s.quantite_reservee as quantite_totale,
    s.cout_moyen_unitaire,
    s.valeur_stock as valeur_totale
FROM Article a
LEFT JOIN Stock s ON a.id_article = s.id_article
LEFT JOIN Config_Valorisation_Article c ON a.id_article = c.id_article
WHERE s.quantite_disponible + s.quantite_reservee > 0;

-- Vue CA Par Article
CREATE OR REPLACE VIEW V_CA_Par_Article AS
SELECT 
    EXTRACT(MONTH FROM m.date_mouvement) as mois,
    EXTRACT(YEAR FROM m.date_mouvement) as annee,
    a.id_article,
    a.code,
    a.designation,
    SUM(m.quantite) as quantite_vendue,
    SUM(m.cout_total) as chiffre_affaires,
    SUM(m.quantite * s.cout_moyen_unitaire) as cout_total,
    SUM(m.cout_total) - SUM(m.quantite * s.cout_moyen_unitaire) as marge_brute
FROM Mouvement_Stock m
JOIN Type_Mouvement_Stock t ON m.id_type_mouvement = t.id_type_mouvement
JOIN Article a ON m.id_article = a.id_article
LEFT JOIN Stock s ON a.id_article = s.id_article
WHERE t.code = 'LIV_CLIENT'
GROUP BY EXTRACT(MONTH FROM m.date_mouvement), EXTRACT(YEAR FROM m.date_mouvement),
         a.id_article, a.code, a.designation;

-- =====================================================
-- DONNEES DE REFERENCE
-- =====================================================

-- Roles
INSERT INTO Role (nom, description) VALUES
('ADMIN', 'Administrateur systeme'),
('ACHETEUR', 'Responsable achats'),
('VENDEUR', 'Responsable ventes'),
('MAGASINIER', 'Gestionnaire stock'),
('FINANCE', 'Service financier');

-- Utilisateurs (mot de passe: password123)
INSERT INTO Utilisateur (nom, email, mot_de_passe, id_role) VALUES
('Admin Systeme', 'admin@lapatia.com', 'password123', 1),
('Jean Rakoto', 'jean.rakoto@lapatia.com', 'password123', 2),
('Marie Razaka', 'marie.razaka@lapatia.com', 'password123', 3),
('Paul Rabe', 'paul.rabe@lapatia.com', 'password123', 4),
('Sophie Randria', 'sophie.randria@lapatia.com', 'password123', 5);

-- Fournisseurs
INSERT INTO Fournisseur (nom, adresse, telephone, email, contact, conditions_paiement, delai_livraison) VALUES
('SODIFRAM', 'Ankorondrano Antananarivo', '0340101010', 'contact@sodifram.mg', 'M. Rakoto', '30 jours fin de mois', 7),
('DISTRIPRO', 'Behoririka Antananarivo', '0340202020', 'info@distripro.mg', 'Mme Rasoa', '45 jours', 10),
('MAGRO', 'Ankorondrano Antananarivo', '0340303030', 'commercial@magro.mg', 'M. Andry', '60 jours', 15),
('IMPORT DIRECT', 'Ambohimanarina Antananarivo', '0340404040', 'ventes@importdirect.mg', 'Mme Nirina', '30 jours', 5),
('FOURNITURE PRO', 'Analakely Antananarivo', '0340505050', 'contact@fourpro.mg', 'M. Hery', '15 jours', 3);

-- Articles
INSERT INTO Article (code, designation, description, unite, categorie) VALUES
('ART-001', 'Riz Makalioka 50kg', 'Riz blanc de qualite superieure', 'sac', 'Alimentaire'),
('ART-002', 'Huile Oleina 5L', 'Huile de cuisine raffinee', 'bidon', 'Alimentaire'),
('ART-003', 'Sucre Cristallise 1kg', 'Sucre blanc cristallise', 'kg', 'Alimentaire'),
('ART-004', 'Farine Fleur 1kg', 'Farine de ble type 55', 'kg', 'Alimentaire'),
('ART-005', 'Lait en Poudre 500g', 'Lait entier en poudre', 'boite', 'Alimentaire'),
('ART-006', 'Pates Alimentaires 500g', 'Pates spaghetti', 'paquet', 'Alimentaire'),
('ART-007', 'Savon Lessive 500g', 'Savon en poudre', 'paquet', 'Menage'),
('ART-008', 'Papier Toilette 4 rouleaux', 'Papier hygienique', 'pack', 'Menage'),
('ART-009', 'Eau Minerale 1.5L', 'Eau de source', 'bouteille', 'Boisson'),
('ART-010', 'Cahier 100 pages', 'Cahier grand format', 'unite', 'Fourniture');

-- Stock initial
INSERT INTO Stock (id_article, quantite_disponible, quantite_reservee, stock_minimum, cout_moyen_unitaire, valeur_stock) VALUES
(1, 100, 0, 20, 45000.00, 4500000.00),
(2, 80, 0, 15, 12500.00, 1000000.00),
(3, 150, 0, 30, 2500.00, 375000.00),
(4, 200, 0, 40, 3000.00, 600000.00),
(5, 120, 0, 25, 8500.00, 1020000.00),
(6, 180, 0, 35, 1800.00, 324000.00),
(7, 90, 0, 20, 4500.00, 405000.00),
(8, 110, 0, 25, 3200.00, 352000.00),
(9, 140, 0, 30, 1500.00, 210000.00),
(10, 250, 0, 50, 800.00, 200000.00);

-- Prix fournisseurs
INSERT INTO Prix (id_article, id_fournisseur, type, montant, date_prix) VALUES
(1, 1, 'ACHAT', 45000.00, '2026-01-01'),
(2, 1, 'ACHAT', 12500.00, '2026-01-01'),
(3, 2, 'ACHAT', 2500.00, '2026-01-01'),
(4, 2, 'ACHAT', 3000.00, '2026-01-01'),
(5, 3, 'ACHAT', 8500.00, '2026-01-01'),
(6, 3, 'ACHAT', 1800.00, '2026-01-01'),
(7, 4, 'ACHAT', 4500.00, '2026-01-01'),
(8, 4, 'ACHAT', 3200.00, '2026-01-01'),
(9, 5, 'ACHAT', 1500.00, '2026-01-01'),
(10, 5, 'ACHAT', 800.00, '2026-01-01');

-- Clients
INSERT INTO Client (nom, adresse, telephone, email, contact, conditions_paiement) VALUES
('EPICERIE RAVINALA', 'Isotry Antananarivo', '0330111111', 'ravinala@gmail.com', 'M. Rivo', '30 jours'),
('SUPERMARCHE TSENA', 'Analakely Antananarivo', '0330222222', 'tsena@yahoo.com', 'Mme Fara', '15 jours'),
('BOUTIQUE FIHAVANANA', 'Ambohijatovo Antananarivo', '0330333333', 'fihavanana@hotmail.com', 'M. Koto', '45 jours'),
('MAGASIN FAMILIALY', 'Behoririka Antananarivo', '0330444444', 'familialy@gmail.com', 'Mme Hanta', '30 jours'),
('COMMERCE MITIA', 'Andravoahangy Antananarivo', '0330555555', 'mitia@outlook.com', 'M. Lala', '60 jours');

-- Reductions
INSERT INTO Reduction (code, libelle, type_reduction, valeur, date_debut, actif) VALUES
('PROMO10', 'Reduction 10 pourcent', 'POURCENTAGE', 10.00, '2026-01-01', TRUE),
('PROMO15', 'Reduction 15 pourcent', 'POURCENTAGE', 15.00, '2026-01-01', TRUE),
('PROMO20', 'Reduction 20 pourcent', 'POURCENTAGE', 20.00, '2026-01-01', TRUE),
('FIXE5000', 'Remise 5000 Ar', 'MONTANT', 5000.00, '2026-01-01', TRUE),
('FIXE10000', 'Remise 10000 Ar', 'MONTANT', 10000.00, '2026-01-01', TRUE);

-- Types de mouvement stock
INSERT INTO Type_Mouvement_Stock (code, libelle, sens, description) VALUES
('RECEP_FOURN', 'Reception Fournisseur', 'ENTREE', 'Entree suite reception fournisseur'),
('RET_CLIENT', 'Retour Client', 'ENTREE', 'Entree suite retour client'),
('AJUST_PLUS', 'Ajustement Positif', 'ENTREE', 'Augmentation suite inventaire ou correction'),
('PRODUCTION', 'Production Interne', 'ENTREE', 'Entree suite production'),
('LIV_CLIENT', 'Livraison Client', 'SORTIE', 'Sortie suite livraison client'),
('RET_FOURN', 'Retour Fournisseur', 'SORTIE', 'Sortie suite retour fournisseur'),
('AJUST_MOINS', 'Ajustement Negatif', 'SORTIE', 'Diminution suite inventaire ou correction'),
('CASSE', 'Casse ou Perte', 'SORTIE', 'Sortie suite casse ou vol'),
('UTILISATION', 'Consommation Interne', 'SORTIE', 'Sortie pour usage interne');

-- Configuration valorisation pour quelques articles
INSERT INTO Config_Valorisation_Article (id_article, methode_valorisation, gestion_lot, type_peremption, delai_alerte_peremption) VALUES
(1, 'FIFO', TRUE, 'DLUO', 60),
(2, 'FIFO', TRUE, 'DLUO', 90),
(5, 'FIFO', TRUE, 'DLC', 30),
(9, 'FIFO', TRUE, 'DLC', 15),
(3, 'CMUP', FALSE, NULL, 30),
(4, 'CMUP', FALSE, NULL, 30),
(6, 'CMUP', FALSE, NULL, 30),
(7, 'CMUP', FALSE, NULL, 30),
(8, 'CMUP', FALSE, NULL, 30),
(10, 'CMUP', FALSE, NULL, 30);

-- =====================================================
-- DONNEES DE TEST - WORKFLOW ACHAT
-- =====================================================

-- Proforma Achat 1
INSERT INTO Proforma (numero, token_demande, id_fournisseur, id_article, quantite, prix_unitaire, montant_total, statut) VALUES
('PRO-ACH-2026-00001', 'DEM-ACH-00001', 1, 1, 50, 45000.00, 2250000.00, 'EN_ATTENTE');

-- Bon de Commande 1
INSERT INTO Bon_Commande (id_proforma, date_commande, statut) VALUES
(1, '2026-01-20 10:00:00', 'EN_COURS');

-- Facture Fournisseur 1
INSERT INTO Facture_Fournisseur (numero_facture, id_bon_commande, montant_total, date_facture, date_echeance, statut) VALUES
('FF-2026-00001', 1, 2250000.00, '2026-01-20', '2026-02-20', 'EN_ATTENTE');

-- Bon de Livraison 1
INSERT INTO Bon_Livraison (numero_livraison, id_bon_commande, date_livraison, transporteur, numero_bon_transport, statut) VALUES
('BL-FOURN-2026-00001', 1, '2026-01-22', 'SODIFRAM', 'BT-2026-00001', 'RECU');

-- Bon de Reception 1
INSERT INTO Bon_Reception (id_bon_livraison, id_article, quantite_commandee, quantite_recue, quantite_non_conforme, commentaire, date_reception, id_receptionnaire) VALUES
(1, 1, 50, 50, 0, 'Conforme', '2026-01-22', 4);

-- Lot cree a la reception
INSERT INTO Lot (numero_lot, id_article, id_fournisseur, quantite_initiale, quantite_restante, cout_unitaire, date_fabrication, dluo, statut, reference_document) VALUES
('LOT-2026-000001', 1, 1, 50, 50, 45000.00, '2026-01-15', '2027-01-15', 'ACTIF', 'BL-FOURN-2026-00001');

-- Mouvement stock entree
INSERT INTO Mouvement_Stock (numero_mouvement, id_type_mouvement, id_article, id_lot, quantite, cout_unitaire, cout_total, reference_document, type_document, id_utilisateur) VALUES
('MVT-2026-000001', 1, 1, 1, 50, 45000.00, 2250000.00, 'BL-FOURN-2026-00001', 'BON_LIVRAISON', 4);

-- Proforma Achat 2 (Huile)
INSERT INTO Proforma (numero, token_demande, id_fournisseur, id_article, quantite, prix_unitaire, montant_total, statut) VALUES
('PRO-ACH-2026-00002', 'DEM-ACH-00002', 1, 2, 30, 12500.00, 375000.00, 'EN_ATTENTE');

-- BC 2
INSERT INTO Bon_Commande (id_proforma, date_commande, statut) VALUES
(2, '2026-01-23 09:00:00', 'EN_COURS');

-- BL 2
INSERT INTO Bon_Livraison (numero_livraison, id_bon_commande, date_livraison, transporteur, numero_bon_transport, statut) VALUES
('BL-FOURN-2026-00002', 2, '2026-01-25', 'DISTRIPRO', 'BT-2026-00002', 'RECU');

-- Lot 2
INSERT INTO Lot (numero_lot, id_article, id_fournisseur, quantite_initiale, quantite_restante, cout_unitaire, date_fabrication, dluo, statut, reference_document) VALUES
('LOT-2026-000002', 2, 1, 30, 30, 12500.00, '2026-01-10', '2027-04-10', 'ACTIF', 'BL-FOURN-2026-00002');

-- Mouvement 2
INSERT INTO Mouvement_Stock (numero_mouvement, id_type_mouvement, id_article, id_lot, quantite, cout_unitaire, cout_total, reference_document, type_document, id_utilisateur) VALUES
('MVT-2026-000002', 1, 2, 2, 30, 12500.00, 375000.00, 'BL-FOURN-2026-00002', 'BON_LIVRAISON', 4);

-- =====================================================
-- DONNEES DE TEST - WORKFLOW VENTE
-- =====================================================

-- Proforma Client 1
INSERT INTO Proforma_Client (numero_proforma, id_client, id_article, quantite, prix_unitaire, id_reduction, montant_reduction, montant_total, statut, id_utilisateur) VALUES
('PRO-VTE-2026-00001', 1, 1, 10, 55000.00, 1, 55000.00, 495000.00, 'ACCEPTE', 3);

-- BC Client 1
INSERT INTO Bon_Commande_Client (numero_bc, id_proforma_client, id_client, id_article, quantite, prix_unitaire, montant_total, statut, date_livraison_prevue, id_utilisateur) VALUES
('BCC-2026-00001', 1, 1, 1, 10, 55000.00, 495000.00, 'LIVRE_TOTAL', '2026-01-27', 3);

-- Facture Client 1
INSERT INTO Facture_Client (numero_facture, id_bon_commande_client, id_client, montant_ht, montant_tva, montant_ttc, montant_paye, statut_paiement, date_facture, date_echeance) VALUES
('FC-2026-00001', 1, 1, 495000.00, 99000.00, 594000.00, 594000.00, 'PAYE_TOTAL', '2026-01-24', '2026-02-24');

-- BL Client 1
INSERT INTO Bon_Livraison_Client (numero_bl, id_facture_client, id_client, quantite_livree, date_livraison, statut, date_expedition) VALUES
('BL-CLI-2026-00001', 1, 1, 10, '2026-01-25', 'LIVRE', '2026-01-25 08:00:00');

-- Mouvement sortie (livraison client)
INSERT INTO Mouvement_Stock (numero_mouvement, id_type_mouvement, id_article, id_lot, quantite, cout_unitaire, cout_total, reference_document, type_document, id_utilisateur) VALUES
('MVT-2026-000003', 5, 1, 1, 10, 45000.00, 450000.00, 'BL-CLI-2026-00001', 'BON_LIVRAISON_CLIENT', 4);

-- Mise a jour lot apres consommation
UPDATE Lot SET quantite_restante = 40 WHERE id_lot = 1;

-- Mise a jour stock apres sortie
UPDATE Stock SET quantite_disponible = 90, valeur_stock = 4050000.00 WHERE id_article = 1;

-- Reservation pour une commande en cours
INSERT INTO Proforma_Client (numero_proforma, id_client, id_article, quantite, prix_unitaire, montant_total, statut, id_utilisateur) VALUES
('PRO-VTE-2026-00002', 2, 2, 15, 16000.00, 240000.00, 'ACCEPTE', 3);

INSERT INTO Bon_Commande_Client (numero_bc, id_proforma_client, id_client, id_article, quantite, prix_unitaire, montant_total, statut, date_livraison_prevue, id_utilisateur) VALUES
('BCC-2026-00002', 2, 2, 2, 15, 16000.00, 240000.00, 'EN_COURS', '2026-01-30', 3);

-- Reservation du stock pour cette commande
INSERT INTO Reservation_Stock (id_article, id_lot, quantite, reference_commande, id_bon_commande_client, statut, date_expiration) VALUES
(2, 2, 15, 'BCC-2026-00002', 2, 'ACTIVE', '2026-02-10 00:00:00');

-- Mise a jour stock avec reservation
UPDATE Stock SET quantite_disponible = 65, quantite_reservee = 15 WHERE id_article = 2;

-- =====================================================
-- INVENTAIRE EXEMPLE
-- =====================================================

INSERT INTO Inventaire (numero_inventaire, type_inventaire, date_inventaire, statut, id_utilisateur, observations) VALUES
('INV-2026-00001', 'TOURNANT', '2026-01-25', 'TERMINE', 4, 'Inventaire mensuel zone stockage alimentaire');

INSERT INTO Inventaire_Detail (id_inventaire, id_article, id_lot, quantite_theorique, quantite_physique, cout_unitaire, observations) VALUES
(1, 1, 1, 40, 40, 45000.00, 'Conforme'),
(1, 2, 2, 30, 29, 12500.00, 'Ecart 1 unite - bidon endommage'),
(1, 3, NULL, 150, 150, 2500.00, 'Conforme');

-- Ajustement suite inventaire (ecart sur article 2)
INSERT INTO Mouvement_Stock (numero_mouvement, id_type_mouvement, id_article, id_lot, quantite, cout_unitaire, cout_total, reference_document, type_document, id_utilisateur, observations) VALUES
('MVT-2026-000004', 7, 2, 2, 1, 12500.00, 12500.00, 'INV-2026-00001', 'INVENTAIRE', 4, 'Ajustement negatif suite inventaire - bidon endommage');

-- Mise a jour lot et stock
UPDATE Lot SET quantite_restante = 29 WHERE id_lot = 2;
UPDATE Stock SET quantite_disponible = 64 WHERE id_article = 2;

-- =====================================================
-- INDEX POUR PERFORMANCE
-- =====================================================

CREATE INDEX idx_mouvement_date ON Mouvement_Stock(date_mouvement);
CREATE INDEX idx_mouvement_article ON Mouvement_Stock(id_article);
CREATE INDEX idx_mouvement_type ON Mouvement_Stock(id_type_mouvement);
CREATE INDEX idx_lot_article ON Lot(id_article);
CREATE INDEX idx_lot_statut ON Lot(statut);
CREATE INDEX idx_stock_article ON Stock(id_article);
CREATE INDEX idx_reservation_article ON Reservation_Stock(id_article);
CREATE INDEX idx_bc_statut ON Bon_Commande(statut);
CREATE INDEX idx_bcc_statut ON Bon_Commande_Client(statut);

-- =====================================================
-- FIN DU SCRIPT
-- =====================================================

-- Verification du nombre de lignes inserees
SELECT 'Roles' as table_name, COUNT(*) as nb_lignes FROM Role
UNION ALL
SELECT 'Utilisateurs', COUNT(*) FROM Utilisateur
UNION ALL
SELECT 'Fournisseurs', COUNT(*) FROM Fournisseur
UNION ALL
SELECT 'Articles', COUNT(*) FROM Article
UNION ALL
SELECT 'Stock', COUNT(*) FROM Stock
UNION ALL
SELECT 'Clients', COUNT(*) FROM Client
UNION ALL
SELECT 'Reductions', COUNT(*) FROM Reduction
UNION ALL
SELECT 'Types Mouvement', COUNT(*) FROM Type_Mouvement_Stock
UNION ALL
SELECT 'Lots', COUNT(*) FROM Lot
UNION ALL
SELECT 'Mouvements Stock', COUNT(*) FROM Mouvement_Stock
UNION ALL
SELECT 'Proforma Achat', COUNT(*) FROM Proforma
UNION ALL
SELECT 'Bon Commande Achat', COUNT(*) FROM Bon_Commande
UNION ALL
SELECT 'Proforma Vente', COUNT(*) FROM Proforma_Client
UNION ALL
SELECT 'Bon Commande Vente', COUNT(*) FROM Bon_Commande_Client;

COMMIT;

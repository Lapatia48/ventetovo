-- Base de donnees systeme de gestion Achats/Ventes/Stock - VERSION DEMO
CREATE DATABASE vente_tovo;
\c vente_tovo;

-- =====================================================
-- REFERENTIELS (Base)
-- =====================================================

CREATE TABLE role (
    id_role SERIAL PRIMARY KEY,
    nom_role VARCHAR(50) UNIQUE NOT NULL,
    niveau_validation INT DEFAULT 0 -- 0=operateur, 1=valideur N1, 2=valideur N2
);

CREATE TABLE utilisateur (
    id_utilisateur SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    mot_de_passe VARCHAR(255) NOT NULL,
    id_role INT NOT NULL,
    actif BOOLEAN DEFAULT TRUE,
    
    CONSTRAINT fk_utilisateur_role FOREIGN KEY (id_role) REFERENCES role(id_role)
);

CREATE TABLE fournisseur (
    id_fournisseur SERIAL PRIMARY KEY,
    nom VARCHAR(150) NOT NULL,
    email VARCHAR(150),
    telephone VARCHAR(20)
);

CREATE TABLE client (
    id_client SERIAL PRIMARY KEY,
    nom VARCHAR(150) NOT NULL,
    email VARCHAR(150),
    telephone VARCHAR(20)
);

CREATE TABLE article (
    id_article SERIAL PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL,
    designation VARCHAR(200) NOT NULL,
    prix_achat NUMERIC(15,2) DEFAULT 0,
    prix_vente NUMERIC(15,2) NOT NULL,
    seuil_alerte INT DEFAULT 10
);

CREATE TABLE depot (
    id_depot SERIAL PRIMARY KEY,
    nom VARCHAR(100) UNIQUE NOT NULL
);

-- =====================================================
-- MODULE ACHATS (simplifie)
-- =====================================================

CREATE TABLE demande_achat (
    id_demande SERIAL PRIMARY KEY,
    numero VARCHAR(50) UNIQUE NOT NULL,
    date_demande DATE DEFAULT CURRENT_DATE,
    id_demandeur INT NOT NULL,
    statut VARCHAR(20) DEFAULT 'EN_ATTENTE' CHECK (statut IN ('EN_ATTENTE', 'VALIDE', 'REJETE')),
    id_valideur INT,
    date_validation TIMESTAMP,
    commentaire TEXT,
    
    CONSTRAINT fk_demande_demandeur FOREIGN KEY (id_demandeur) REFERENCES utilisateur(id_utilisateur),
    CONSTRAINT fk_demande_valideur FOREIGN KEY (id_valideur) REFERENCES utilisateur(id_utilisateur),
    -- REGLE METIER : Pas d auto-validation
    CONSTRAINT check_pas_auto_validation CHECK (id_valideur IS NULL OR id_valideur != id_demandeur)
);

CREATE TABLE ligne_demande_achat (
    id_ligne SERIAL PRIMARY KEY,
    id_demande INT NOT NULL,
    id_article INT NOT NULL,
    quantite INT NOT NULL,
    
    CONSTRAINT fk_ligne_demande FOREIGN KEY (id_demande) REFERENCES demande_achat(id_demande) ON DELETE CASCADE,
    CONSTRAINT fk_ligne_article FOREIGN KEY (id_article) REFERENCES article(id_article)
);

CREATE TABLE bon_commande (
    id_commande SERIAL PRIMARY KEY,
    numero VARCHAR(50) UNIQUE NOT NULL,
    id_demande INT NOT NULL,
    id_fournisseur INT NOT NULL,
    date_commande DATE DEFAULT CURRENT_DATE,
    montant_total NUMERIC(15,2) NOT NULL,
    statut VARCHAR(20) DEFAULT 'EN_COURS' CHECK (statut IN ('EN_COURS', 'RECEPTIONNE', 'ANNULE')),
    
    CONSTRAINT fk_bc_demande FOREIGN KEY (id_demande) REFERENCES demande_achat(id_demande),
    CONSTRAINT fk_bc_fournisseur FOREIGN KEY (id_fournisseur) REFERENCES fournisseur(id_fournisseur)
);

CREATE TABLE ligne_bon_commande (
    id_ligne SERIAL PRIMARY KEY,
    id_commande INT NOT NULL,
    id_article INT NOT NULL,
    quantite INT NOT NULL,
    prix_unitaire NUMERIC(15,2) NOT NULL,
    
    CONSTRAINT fk_ligne_bc FOREIGN KEY (id_commande) REFERENCES bon_commande(id_commande) ON DELETE CASCADE,
    CONSTRAINT fk_ligne_bc_article FOREIGN KEY (id_article) REFERENCES article(id_article)
);

CREATE TABLE reception (
    id_reception SERIAL PRIMARY KEY,
    numero VARCHAR(50) UNIQUE NOT NULL,
    id_commande INT NOT NULL,
    id_receptionnaire INT NOT NULL,
    date_reception DATE DEFAULT CURRENT_DATE,
    statut VARCHAR(20) DEFAULT 'CONFORME' CHECK (statut IN ('CONFORME', 'NON_CONFORME')),
    
    CONSTRAINT fk_reception_bc FOREIGN KEY (id_commande) REFERENCES bon_commande(id_commande),
    CONSTRAINT fk_reception_user FOREIGN KEY (id_receptionnaire) REFERENCES utilisateur(id_utilisateur)
);

CREATE TABLE ligne_reception (
    id_ligne SERIAL PRIMARY KEY,
    id_reception INT NOT NULL,
    id_article INT NOT NULL,
    quantite_commandee INT NOT NULL,
    quantite_recue INT NOT NULL,
    
    CONSTRAINT fk_ligne_reception FOREIGN KEY (id_reception) REFERENCES reception(id_reception) ON DELETE CASCADE,
    CONSTRAINT fk_ligne_reception_article FOREIGN KEY (id_article) REFERENCES article(id_article)
);

-- =====================================================
-- MODULE VENTES (simplifie)
-- =====================================================

CREATE TABLE commande_client (
    id_commande SERIAL PRIMARY KEY,
    numero VARCHAR(50) UNIQUE NOT NULL,
    id_client INT NOT NULL,
    id_commercial INT NOT NULL,
    date_commande DATE DEFAULT CURRENT_DATE,
    remise_pct NUMERIC(5,2) DEFAULT 0,
    statut VARCHAR(20) DEFAULT 'EN_COURS' CHECK (statut IN ('EN_COURS', 'LIVRE', 'ANNULE')),
    -- REGLE METIER : Remise > 10% necessite validation
    validation_remise BOOLEAN DEFAULT FALSE,
    id_valideur_remise INT,
    
    CONSTRAINT fk_cc_client FOREIGN KEY (id_client) REFERENCES client(id_client),
    CONSTRAINT fk_cc_commercial FOREIGN KEY (id_commercial) REFERENCES utilisateur(id_utilisateur),
    CONSTRAINT fk_cc_valideur FOREIGN KEY (id_valideur_remise) REFERENCES utilisateur(id_utilisateur),
    CONSTRAINT check_remise CHECK (remise_pct <= 10 OR validation_remise = TRUE)
);

CREATE TABLE ligne_commande_client (
    id_ligne SERIAL PRIMARY KEY,
    id_commande INT NOT NULL,
    id_article INT NOT NULL,
    quantite INT NOT NULL,
    prix_unitaire NUMERIC(15,2) NOT NULL,
    
    CONSTRAINT fk_ligne_cc FOREIGN KEY (id_commande) REFERENCES commande_client(id_commande) ON DELETE CASCADE,
    CONSTRAINT fk_ligne_cc_article FOREIGN KEY (id_article) REFERENCES article(id_article)
);

CREATE TABLE livraison (
    id_livraison SERIAL PRIMARY KEY,
    numero VARCHAR(50) UNIQUE NOT NULL,
    id_commande INT NOT NULL,
    id_preparateur INT NOT NULL,
    date_livraison DATE DEFAULT CURRENT_DATE,
    
    CONSTRAINT fk_livraison_cc FOREIGN KEY (id_commande) REFERENCES commande_client(id_commande),
    CONSTRAINT fk_livraison_prep FOREIGN KEY (id_preparateur) REFERENCES utilisateur(id_utilisateur)
);

CREATE TABLE ligne_livraison (
    id_ligne SERIAL PRIMARY KEY,
    id_livraison INT NOT NULL,
    id_article INT NOT NULL,
    quantite INT NOT NULL,
    
    CONSTRAINT fk_ligne_livraison FOREIGN KEY (id_livraison) REFERENCES livraison(id_livraison) ON DELETE CASCADE,
    CONSTRAINT fk_ligne_livraison_article FOREIGN KEY (id_article) REFERENCES article(id_article)
);

-- =====================================================
-- MODULE STOCK (simplifie)
-- =====================================================

CREATE TABLE stock (
    id_stock SERIAL PRIMARY KEY,
    id_article INT NOT NULL,
    id_depot INT NOT NULL,
    quantite INT DEFAULT 0,
    date_maj TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_stock_article FOREIGN KEY (id_article) REFERENCES article(id_article),
    CONSTRAINT fk_stock_depot FOREIGN KEY (id_depot) REFERENCES depot(id_depot),
    CONSTRAINT unique_article_depot UNIQUE (id_article, id_depot)
);

CREATE TABLE mouvement_stock (
    id_mouvement SERIAL PRIMARY KEY,
    id_article INT NOT NULL,
    id_depot INT NOT NULL,
    type_mouvement VARCHAR(20) NOT NULL CHECK (type_mouvement IN ('ENTREE', 'SORTIE', 'AJUSTEMENT')),
    quantite INT NOT NULL,
    date_mouvement TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_utilisateur INT NOT NULL,
    reference VARCHAR(100), -- Numero du document source (BC, BL, etc.)
    commentaire TEXT,
    
    CONSTRAINT fk_mvt_article FOREIGN KEY (id_article) REFERENCES article(id_article),
    CONSTRAINT fk_mvt_depot FOREIGN KEY (id_depot) REFERENCES depot(id_depot),
    CONSTRAINT fk_mvt_user FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id_utilisateur)
);

-- =====================================================
-- MODULE INVENTAIRE (simplifie)
-- =====================================================

CREATE TABLE inventaire (
    id_inventaire SERIAL PRIMARY KEY,
    numero VARCHAR(50) UNIQUE NOT NULL,
    date_inventaire DATE DEFAULT CURRENT_DATE,
    id_depot INT NOT NULL,
    statut VARCHAR(20) DEFAULT 'EN_COURS' CHECK (statut IN ('EN_COURS', 'VALIDE')),
    id_valideur INT,
    
    CONSTRAINT fk_inv_depot FOREIGN KEY (id_depot) REFERENCES depot(id_depot),
    CONSTRAINT fk_inv_valideur FOREIGN KEY (id_valideur) REFERENCES utilisateur(id_utilisateur)
);

CREATE TABLE ligne_inventaire (
    id_ligne SERIAL PRIMARY KEY,
    id_inventaire INT NOT NULL,
    id_article INT NOT NULL,
    quantite_theorique INT NOT NULL,
    quantite_physique INT NOT NULL,
    ecart INT GENERATED ALWAYS AS (quantite_physique - quantite_theorique) STORED,
    id_compteur INT NOT NULL,
    
    CONSTRAINT fk_ligne_inv FOREIGN KEY (id_inventaire) REFERENCES inventaire(id_inventaire) ON DELETE CASCADE,
    CONSTRAINT fk_ligne_inv_article FOREIGN KEY (id_article) REFERENCES article(id_article),
    CONSTRAINT fk_ligne_inv_compteur FOREIGN KEY (id_compteur) REFERENCES utilisateur(id_utilisateur),
    -- REGLE METIER : Le compteur ne peut pas valider son propre inventaire
    CONSTRAINT check_compteur_valideur CHECK (
        id_compteur != (SELECT id_valideur FROM inventaire WHERE id_inventaire = ligne_inventaire.id_inventaire)
    )
);

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

-- =====================================================
-- COMMENTAIRES
-- =====================================================

COMMENT ON DATABASE vente_tovo IS 'Systeme de gestion Achats/Ventes/Stock - Version Demo';
COMMENT ON TABLE demande_achat IS 'REGLE: Le valideur doit etre different du demandeur';
COMMENT ON TABLE commande_client IS 'REGLE: Remise > 10% necessite validation responsable';
COMMENT ON TABLE ligne_inventaire IS 'REGLE: Le compteur ne peut pas valider son inventaire';
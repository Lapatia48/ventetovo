-- Module VENTE: Tables pour la gestion des ventes

-- Table Client
CREATE TABLE Client (
    id_client SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    telephone VARCHAR(20),
    adresse TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actif BOOLEAN DEFAULT TRUE
);

-- Table Stock
CREATE TABLE Stock (
    id_stock SERIAL PRIMARY KEY,
    id_article INTEGER NOT NULL REFERENCES Article(id_article),
    quantite_disponible INTEGER NOT NULL DEFAULT 0,
    quantite_reservee INTEGER NOT NULL DEFAULT 0,
    date_mise_a_jour TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT check_stock_positive CHECK (quantite_disponible >= 0),
    CONSTRAINT check_reserve_positive CHECK (quantite_reservee >= 0)
);

-- Table Reduction
CREATE TABLE Reduction (
    id_reduction SERIAL PRIMARY KEY,
    code_reduction VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    type_reduction VARCHAR(20) NOT NULL, -- 'POURCENTAGE' ou 'MONTANT_FIXE'
    valeur DECIMAL(10,2) NOT NULL,
    date_debut DATE NOT NULL,
    date_fin DATE NOT NULL,
    actif BOOLEAN DEFAULT TRUE,
    CONSTRAINT check_type_reduction CHECK (type_reduction IN ('POURCENTAGE', 'MONTANT_FIXE'))
);

-- Table Proforma Client (Devis)
CREATE TABLE Proforma_Client (
    id_proforma_client SERIAL PRIMARY KEY,
    numero_proforma VARCHAR(50) UNIQUE NOT NULL,
    id_client INTEGER NOT NULL REFERENCES Client(id_client),
    id_article INTEGER NOT NULL REFERENCES Article(id_article),
    quantite INTEGER NOT NULL,
    prix_unitaire DECIMAL(10,2) NOT NULL,
    id_reduction INTEGER REFERENCES Reduction(id_reduction),
    montant_reduction DECIMAL(10,2) DEFAULT 0,
    montant_total DECIMAL(10,2) NOT NULL,
    date_proforma TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_validite DATE NOT NULL,
    statut VARCHAR(20) DEFAULT 'EN_ATTENTE', -- 'EN_ATTENTE', 'ACCEPTE', 'REFUSE', 'EXPIRE'
    CONSTRAINT check_quantite_positive CHECK (quantite > 0),
    CONSTRAINT check_statut_proforma CHECK (statut IN ('EN_ATTENTE', 'ACCEPTE', 'REFUSE', 'EXPIRE'))
);

-- Table Bon de Commande Client
CREATE TABLE Bon_Commande_Client (
    id_bon_commande_client SERIAL PRIMARY KEY,
    numero_bc_client VARCHAR(50) UNIQUE NOT NULL,
    id_proforma_client INTEGER NOT NULL REFERENCES Proforma_Client(id_proforma_client),
    id_client INTEGER NOT NULL REFERENCES Client(id_client),
    id_article INTEGER NOT NULL REFERENCES Article(id_article),
    quantite INTEGER NOT NULL,
    montant_total DECIMAL(10,2) NOT NULL,
    date_commande TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    statut VARCHAR(20) DEFAULT 'EN_COURS', -- 'EN_COURS', 'CONFIRME', 'ANNULE'
    stock_verifie BOOLEAN DEFAULT FALSE,
    stock_suffisant BOOLEAN DEFAULT FALSE,
    CONSTRAINT check_statut_bc CHECK (statut IN ('EN_COURS', 'CONFIRME', 'ANNULE'))
);

-- Table Facture Client
CREATE TABLE Facture_Client (
    id_facture_client SERIAL PRIMARY KEY,
    numero_facture_client VARCHAR(50) UNIQUE NOT NULL,
    id_bon_commande_client INTEGER NOT NULL REFERENCES Bon_Commande_Client(id_bon_commande_client),
    id_client INTEGER NOT NULL REFERENCES Client(id_client),
    montant_total DECIMAL(10,2) NOT NULL,
    date_facture TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_echeance DATE NOT NULL,
    statut_paiement VARCHAR(20) DEFAULT 'NON_PAYE', -- 'NON_PAYE', 'PAYE', 'PARTIEL'
    montant_paye DECIMAL(10,2) DEFAULT 0,
    CONSTRAINT check_statut_paiement CHECK (statut_paiement IN ('NON_PAYE', 'PAYE', 'PARTIEL'))
);

-- Table Bon de Livraison Client
CREATE TABLE Bon_Livraison_Client (
    id_bon_livraison_client SERIAL PRIMARY KEY,
    numero_bl_client VARCHAR(50) UNIQUE NOT NULL,
    id_facture_client INTEGER NOT NULL REFERENCES Facture_Client(id_facture_client),
    id_client INTEGER NOT NULL REFERENCES Client(id_client),
    id_article INTEGER NOT NULL REFERENCES Article(id_article),
    quantite_livree INTEGER NOT NULL,
    date_livraison TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_livraison_prevue DATE,
    statut VARCHAR(20) DEFAULT 'EN_PREPARATION', -- 'EN_PREPARATION', 'EXPEDIE', 'LIVRE', 'RETOUR'
    id_livreur INTEGER REFERENCES Utilisateur(id_utilisateur),
    commentaire TEXT,
    CONSTRAINT check_statut_bl CHECK (statut IN ('EN_PREPARATION', 'EXPEDIE', 'LIVRE', 'RETOUR'))
);

CREATE OR REPLACE VIEW V_Proforma_Client AS
SELECT 
    pc.id_proforma_client,
    pc.numero_proforma,
    c.id_client,
    c.nom || ' ' || COALESCE(c.prenom, '') AS nom_client,
    c.email AS email_client,
    a.id_article,
    a.designation AS designation_article,
    pc.quantite,
    pc.prix_unitaire,
    r.code_reduction,
    r.type_reduction,
    r.valeur AS valeur_reduction,
    pc.montant_reduction,
    pc.montant_total,
    pc.date_proforma,
    pc.date_validite,
    pc.statut,
    CASE 
        WHEN pc.date_validite < CURRENT_DATE THEN TRUE
        ELSE FALSE
    END AS est_expire
FROM Proforma_Client pc
JOIN Client c ON pc.id_client = c.id_client
JOIN Article a ON pc.id_article = a.id_article
LEFT JOIN Reduction r ON pc.id_reduction = r.id_reduction;

-- Vue pour afficher les bons de commande clients avec 
CREATE OR REPLACE VIEW V_Bon_Commande_Client AS
SELECT 
    bcc.id_bon_commande_client,
    bcc.numero_bc_client,
    c.id_client,
    c.nom || ' ' || COALESCE(c.prenom, '') AS nom_client,
    c.email AS email_client,
    c.telephone AS telephone_client,
    a.id_article,
    a.designation AS designation_article,
    bcc.quantite,
    bcc.montant_total,
    bcc.date_commande,
    bcc.statut,
    bcc.stock_verifie,
    bcc.stock_suffisant,
    s.quantite_disponible AS stock_disponible,
    s.quantite_reservee AS stock_reserve,
    pc.numero_proforma
FROM Bon_Commande_Client bcc
JOIN Client c ON bcc.id_client = c.id_client
JOIN Article a ON bcc.id_article = a.id_article
JOIN Proforma_Client pc ON bcc.id_proforma_client = pc.id_proforma_client
LEFT JOIN Stock s ON a.id_article = s.id_article;

-- Vue pour afficher les factures clients avec 
CREATE OR REPLACE VIEW V_Facture_Client AS
SELECT 
    fc.id_facture_client,
    fc.numero_facture_client,
    c.id_client,
    c.nom || ' ' || COALESCE(c.prenom, '') AS nom_client,
    c.email AS email_client,
    bcc.numero_bc_client,
    a.designation AS designation_article,
    bcc.quantite,
    fc.montant_total,
    fc.date_facture,
    fc.date_echeance,
    fc.statut_paiement,
    fc.montant_paye,
    (fc.montant_total - fc.montant_paye) AS montant_restant,
    CASE 
        WHEN fc.date_echeance < CURRENT_DATE AND fc.statut_paiement != 'PAYE' THEN TRUE
        ELSE FALSE
    END AS est_en_retard
FROM Facture_Client fc
JOIN Bon_Commande_Client bcc ON fc.id_bon_commande_client = bcc.id_bon_commande_client
JOIN Client c ON fc.id_client = c.id_client
JOIN Article a ON bcc.id_article = a.id_article;

-- Vue pour afficher les bons de livraison clients avec détails
CREATE OR REPLACE VIEW V_Bon_Livraison_Client AS
SELECT 
    blc.id_bon_livraison_client,
    blc.numero_bl_client,
    c.id_client,
    c.nom || ' ' || COALESCE(c.prenom, '') AS nom_client,
    c.adresse AS adresse_client,
    c.telephone AS telephone_client,
    a.id_article,
    a.designation AS designation_article,
    blc.quantite_livree,
    blc.date_livraison,
    blc.date_livraison_prevue,
    blc.statut,
    u.nom || ' ' || COALESCE(u.prenom, '') AS nom_livreur,
    fc.numero_facture_client,
    fc.montant_total,
    blc.commentaire
FROM Bon_Livraison_Client blc
JOIN Facture_Client fc ON blc.id_facture_client = fc.id_facture_client
JOIN Client c ON blc.id_client = c.id_client
JOIN Article a ON blc.id_article = a.id_article
LEFT JOIN Utilisateur u ON blc.id_livreur = u.id_utilisateur;

-- Index pour  les performances
CREATE INDEX idx_stock_article ON Stock(id_article);
CREATE INDEX idx_proforma_client_client ON Proforma_Client(id_client);
CREATE INDEX idx_proforma_client_statut ON Proforma_Client(statut);
CREATE INDEX idx_bc_client_client ON Bon_Commande_Client(id_client);
CREATE INDEX idx_facture_client_statut ON Facture_Client(statut_paiement);
CREATE INDEX idx_bl_client_statut ON Bon_Livraison_Client(statut);

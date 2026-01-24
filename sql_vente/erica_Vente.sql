-- CLIENT
CREATE TABLE client (
    id_client SERIAL PRIMARY KEY,
    code_client VARCHAR(20) UNIQUE NOT NULL,  -- Important pour référence
    nom VARCHAR(150) NOT NULL,
    email VARCHAR(150),
    telephone VARCHAR(20),
    adresse TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- DEVIS (UN devis = PLUSIEURS articles)
CREATE TABLE devis (
    id_devis SERIAL PRIMARY KEY,
    numero_devis VARCHAR(50) UNIQUE NOT NULL,
    id_client INT NOT NULL REFERENCES client(id_client),

    id_validateur INT REFERENCES utilisateur(id_utilisateur),
    date_validation TIMESTAMP,

    date_devis TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_validite DATE,

    statut VARCHAR(20) DEFAULT 'A_VALIDER'
        CHECK (statut IN ('A_VALIDER', 'ACCEPTE', 'REFUSE', 'ENVOYE', 'EXPIRE')),

    montant_total_ht NUMERIC(15,2) DEFAULT 0,
    montant_tva NUMERIC(15,2) DEFAULT 0,
    montant_ttc NUMERIC(15,2) DEFAULT 0,

    id_commercial INT NOT NULL REFERENCES utilisateur(id_utilisateur),
    notes TEXT
);


-- Ligne devis (PLUSIEURS lignes par devis)
CREATE TABLE ligne_devis (
    id_ligne_devis SERIAL PRIMARY KEY,
    id_devis INT NOT NULL REFERENCES devis(id_devis) ON DELETE CASCADE,
    id_article INT NOT NULL REFERENCES article(id_article),
    quantite INT NOT NULL CHECK (quantite > 0),
    prix_unitaire_ht NUMERIC(15,2) NOT NULL,
    remise DECIMAL(5,2) DEFAULT 0,
    montant_ht NUMERIC(15,2) GENERATED ALWAYS AS 
        (quantite * prix_unitaire_ht * (1 - remise/100)) STORED,
    tva_taux DECIMAL(5,2) DEFAULT 20.0,
    montant_ttc NUMERIC(15,2) GENERATED ALWAYS AS 
        (quantite * prix_unitaire_ht * (1 - remise/100) * (1 + tva_taux/100)) STORED
);

-- COMMANDE CLIENT
CREATE TABLE commande_client (
    id_commande SERIAL PRIMARY KEY,
    numero_commande VARCHAR(50) UNIQUE NOT NULL,

    id_devis INT REFERENCES devis(id_devis),
    id_client INT NOT NULL REFERENCES client(id_client),

    date_commande TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_livraison_souhaitee DATE,

    statut VARCHAR(20) DEFAULT 'A_VALIDER'
        CHECK (statut IN (
            'A_VALIDER',
            'VALIDEE',
            'EN_PREPARATION',
            'PARTIELLEMENT_LIVREE',
            'LIVREE',
            'ANNULEE'
        )),

    montant_total_ht NUMERIC(15,2) DEFAULT 0,
    montant_total_ttc NUMERIC(15,2) DEFAULT 0,

    id_commercial INT REFERENCES utilisateur(id_utilisateur),

    id_validateur INT REFERENCES utilisateur(id_utilisateur),
    date_validation TIMESTAMP
);


-- Ligne commande client
CREATE TABLE ligne_commande_client (
    id_ligne_commande SERIAL PRIMARY KEY,
    id_commande INT NOT NULL REFERENCES commande_client(id_commande) ON DELETE CASCADE,
    id_article INT NOT NULL REFERENCES article(id_article),
    quantite_commandee INT NOT NULL CHECK (quantite_commandee > 0),
    quantite_livree INT DEFAULT 0,
    prix_unitaire_ht NUMERIC(15,2) NOT NULL,
    remise DECIMAL(5,2) DEFAULT 0,
    montant_ht NUMERIC(15,2) GENERATED ALWAYS AS 
        (quantite_commandee * prix_unitaire_ht * (1 - remise/100)) STORED
);

-- BON DE LIVRAISON CLIENT (Renommé pour éviter conflit)
CREATE TABLE livraison_client (
    id_livraison SERIAL PRIMARY KEY,
    numero_livraison VARCHAR(50) UNIQUE NOT NULL,
    id_commande INT NOT NULL REFERENCES commande_client(id_commande),
    date_livraison DATE NOT NULL,
    transporteur VARCHAR(100),
    numero_suivi VARCHAR(100),
    statut VARCHAR(20) DEFAULT 'EN_PREPARATION' 
        CHECK (statut IN ('EN_PREPARATION', 'EXPEDIEE', 'LIVREE', 'PARTIELLE', 'ANNULEE')),
    id_preparateur INT REFERENCES utilisateur(id_utilisateur),
    id_livreur INT REFERENCES utilisateur(id_utilisateur),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Ligne livraison
CREATE TABLE ligne_livraison_client (
    id_ligne_livraison SERIAL PRIMARY KEY,
    id_livraison INT NOT NULL REFERENCES livraison_client(id_livraison) ON DELETE CASCADE,
    id_ligne_commande INT NOT NULL REFERENCES ligne_commande_client(id_ligne_commande),
    quantite_livree INT NOT NULL CHECK (quantite_livree > 0),
    numero_lot VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- FACTURE CLIENT
CREATE TABLE facture_client (
    id_facture SERIAL PRIMARY KEY,
    numero_facture VARCHAR(50) UNIQUE NOT NULL,
    id_livraison INT REFERENCES livraison_client(id_livraison),
    id_commande INT REFERENCES commande_client(id_commande),
    id_client INT NOT NULL REFERENCES client(id_client),
    date_facture DATE NOT NULL DEFAULT CURRENT_DATE,
    date_echeance DATE GENERATED ALWAYS AS (date_facture + INTERVAL '30 days') STORED,
    statut VARCHAR(20) DEFAULT 'BROUILLON' 
        CHECK (statut IN ('BROUILLON', 'VALIDEE', 'ENVOYEE', 'PARTIELLEMENT_PAYEE', 
                         'PAYEE', 'IMPAYEE', 'ANNULEE')),
    montant_total_ht NUMERIC(15,2) NOT NULL DEFAULT 0,
    montant_tva NUMERIC(15,2) NOT NULL DEFAULT 0,
    montant_ttc NUMERIC(15,2) NOT NULL DEFAULT 0,
    montant_paye NUMERIC(15,2) DEFAULT 0,
    solde_restant NUMERIC(15,2) GENERATED ALWAYS AS (montant_ttc - montant_paye) STORED,
    mode_paiement VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT REFERENCES utilisateur(id_utilisateur)
);

-- Ligne facture (CRITIQUE - manquante dans votre modèle)
CREATE TABLE ligne_facture_client (
    id_ligne_facture SERIAL PRIMARY KEY,
    id_facture INT NOT NULL REFERENCES facture_client(id_facture) ON DELETE CASCADE,
    id_ligne_livraison INT REFERENCES ligne_livraison_client(id_ligne_livraison),
    id_article INT NOT NULL REFERENCES article(id_article),
    description TEXT,
    quantite INT NOT NULL,
    prix_unitaire_ht NUMERIC(15,2) NOT NULL,
    remise DECIMAL(5,2) DEFAULT 0,
    montant_ht NUMERIC(15,2) NOT NULL,
    tva_taux DECIMAL(5,2) NOT NULL DEFAULT 20.0,
    montant_tva NUMERIC(15,2) NOT NULL,
    montant_ttc NUMERIC(15,2) NOT NULL
);

-- RÈGLEMENT CLIENT
CREATE TABLE reglement_client (
    id_reglement SERIAL PRIMARY KEY,
    numero_reglement VARCHAR(50) UNIQUE NOT NULL,
    id_client INT NOT NULL REFERENCES client(id_client),
    date_reglement DATE NOT NULL DEFAULT CURRENT_DATE,
    mode_reglement VARCHAR(20) 
        CHECK (mode_reglement IN ('VIREMENT', 'CHEQUE', 'CARTE', 'ESPECES', 'PRELEVEMENT')),
    montant NUMERIC(15,2) NOT NULL,
    statut VARCHAR(20) DEFAULT 'EN_ATTENTE' 
        CHECK (statut IN ('EN_ATTENTE', 'VALIDE', 'ENCAISSE', 'REJETE', 'ANNULE')),
    reference_paiement VARCHAR(100),  -- N° de chèque, référence virement
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT REFERENCES utilisateur(id_utilisateur)
);

-- Table de LIAISON facture <-> règlement (CRITIQUE - manquante)
CREATE TABLE facture_reglement (
    id_facture_reglement SERIAL PRIMARY KEY,
    id_facture INT NOT NULL REFERENCES facture_client(id_facture),
    id_reglement INT NOT NULL REFERENCES reglement_client(id_reglement),
    montant_affecte NUMERIC(15,2) NOT NULL,
    date_affectation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(id_facture, id_reglement)
);

UPDATE utilisateur
SET id_role = (SELECT id_role FROM role WHERE nom_role = 'ADMIN')
WHERE id_role IS NULL;

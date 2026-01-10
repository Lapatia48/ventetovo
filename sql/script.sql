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
-- MODULE INVENTAIRE (simplifié)
-- =====================================================

CREATE TABLE inventaire (
    id_inventaire SERIAL PRIMARY KEY,
    numero VARCHAR(50) UNIQUE NOT NULL,
    date_inventaire DATE DEFAULT CURRENT_DATE,
    id_depot INT NOT NULL,
    statut VARCHAR(20) DEFAULT 'EN_COURS' CHECK (statut IN ('EN_COURS', 'VALIDE')),
    id_valideur INT,
    
    CONSTRAINT fk_inv_depot FOREIGN KEY (id_depot) REFERENCES depot(id_depot),
    CONSTRAINT fk_inv_valideur FOREIGN KEY (id_valideur) REFERENCES utilisateur(id_utilisateur),
    -- Règle: On ne peut pas valider un inventaire qui n'est pas terminé
    CONSTRAINT check_validation_coherence CHECK (
        (statut = 'VALIDE' AND id_valideur IS NOT NULL) OR 
        (statut = 'EN_COURS' AND id_valideur IS NULL)
    )
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
    CONSTRAINT fk_ligne_inv_compteur FOREIGN KEY (id_compteur) REFERENCES utilisateur(id_utilisateur)
);

-- =====================================================
-- CAISSE
-- =====================================================

CREATE TABLE caisse (
    id_caisse SERIAL PRIMARY KEY,
    solde NUMERIC(15,2) DEFAULT 0,
    date_maj TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE DATABASE vente_tovo;
\c vente_tovo;

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

CREATE TABLE article (
    id_article SERIAL PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL,
    designation VARCHAR(200) NOT NULL
);

CREATE TABLE prix (
    id_prix SERIAL PRIMARY KEY,
    id_article INT NOT NULL,
    id_fournisseur INT NOT NULL,
    type VARCHAR(10) NOT NULL,
    montant NUMERIC(15,2) NOT NULL,
    date_prix DATE NOT NULL,
    
    FOREIGN KEY (id_article) REFERENCES article(id_article),
    FOREIGN KEY (id_fournisseur) REFERENCES fournisseur(id_fournisseur)
);


-- Table pour les proformas
CREATE TABLE proforma (
    id_proforma SERIAL PRIMARY KEY,
    numero VARCHAR(50) UNIQUE NOT NULL,
    token_demande VARCHAR(64) NOT NULL, -- Token unique pour regrouper les proformas d'une même demande
    id_article INT NOT NULL,
    id_fournisseur INT NOT NULL,
    quantite INT NOT NULL,
    prix_unitaire NUMERIC(15,2) NOT NULL,
    montant_total NUMERIC(15,2) NOT NULL,
    date_proforma TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    statut VARCHAR(20) DEFAULT 'EN_ATTENTE' CHECK (statut IN ('EN_ATTENTE', 'SELECTIONNE', 'REJETE')),
    
    FOREIGN KEY (id_article) REFERENCES article(id_article),
    FOREIGN KEY (id_fournisseur) REFERENCES fournisseur(id_fournisseur)
);

-- Index pour optimiser les requêtes
CREATE INDEX idx_proforma_token ON proforma(token_demande);
CREATE INDEX idx_proforma_article ON proforma(id_article);
CREATE INDEX idx_proforma_fournisseur ON proforma(id_fournisseur);


-- table bon de commande
CREATE TABLE bon_commande (
    id_bon_commande SERIAL PRIMARY KEY,
    id_proforma INT NOT NULL,
    date_commande TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    statut VARCHAR(20) DEFAULT 'EN_COURS' CHECK (statut IN ('EN_COURS', 'LIVRE', 'ANNULE')),
    
    FOREIGN KEY (id_proforma) REFERENCES proforma(id_proforma)
);


-- Table Facture Fournisseur
CREATE TABLE facture_fournisseur (
    id_facture SERIAL PRIMARY KEY,
    numero_facture VARCHAR(50) UNIQUE NOT NULL,
    id_bon_commande INT NOT NULL,
    montant_total NUMERIC(15,2) NOT NULL,
    date_facture DATE NOT NULL,
    date_echeance DATE,
    statut VARCHAR(20) DEFAULT 'EN_ATTENTE' CHECK (statut IN ('EN_ATTENTE', 'REGLEE', 'EN_RETARD', 'ANNULEE')),
    
    FOREIGN KEY (id_bon_commande) REFERENCES bon_commande(id_bon_commande)
);

-- Table Bon de Livraison
CREATE TABLE bon_livraison (
    id_bon_livraison SERIAL PRIMARY KEY,
    numero_livraison VARCHAR(50) UNIQUE NOT NULL,
    id_bon_commande INT NOT NULL,
    date_livraison DATE NOT NULL,
    transporteur VARCHAR(100),
    numero_bon_transport VARCHAR(50),
    statut VARCHAR(20) DEFAULT 'EN_ATTENTE' CHECK (statut IN ('EN_ATTENTE', 'RECU', 'PARTIEL', 'ANNULE')),
    
    FOREIGN KEY (id_bon_commande) REFERENCES bon_commande(id_bon_commande)
);

-- Table Bon de Réception (lignes de livraison)
CREATE TABLE bon_reception (
    id_bon_reception SERIAL PRIMARY KEY,
    id_bon_livraison INT NOT NULL,
    id_article INT NOT NULL,
    quantite_commandee INT NOT NULL,
    quantite_recue INT NOT NULL,
    quantite_non_conforme INT DEFAULT 0,
    commentaire TEXT,
    date_reception TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_receptionnaire INT,
    
    FOREIGN KEY (id_bon_livraison) REFERENCES bon_livraison(id_bon_livraison) ON DELETE CASCADE,
    FOREIGN KEY (id_article) REFERENCES article(id_article),
    FOREIGN KEY (id_receptionnaire) REFERENCES utilisateur(id_utilisateur)
);
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
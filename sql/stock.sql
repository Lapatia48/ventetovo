-- insert lapatia_Achat.sql dans ta base sauf le bon_reception qui sera dessous

INSERT INTO role (nom_role, niveau_validation)
VALUES
('OPERATEUR', 0),
('SUPERVISEUR', 1);

INSERT INTO utilisateur (nom, prenom, email, mot_de_passe, id_role)
SELECT 'Rakoto', 'Jean', 'jean.rakoto@company.mg', 'jean', r.id_role
FROM role r WHERE r.nom_role = 'OPERATEUR';

INSERT INTO utilisateur (nom, prenom, email, mot_de_passe, id_role)
SELECT 'Rasoa', 'Marie', 'marie.rasoa@company.mg', 'marie', r.id_role
FROM role r WHERE r.nom_role = 'SUPERVISEUR';

INSERT INTO fournisseur (nom, email, telephone)
VALUES ('Tech Supplies Ltd', 'contact@techsupplies.com', '+261341234567');

INSERT INTO article (code, designation)
VALUES
('ART-001', 'Ordinateur Portable Dell Latitude'),
('ART-002', 'Souris Optique USB Logitech');

INSERT INTO prix (
    id_article,
    id_fournisseur,
    type,
    montant,
    date_prix
)
VALUES (
    1,
    1,
    'ACHAT',
    2500.00,
    CURRENT_DATE
);


INSERT INTO proforma (
    numero,
    token_demande,
    id_article,
    id_fournisseur,
    quantite,
    prix_unitaire,
    montant_total
)
SELECT
    'PROF-2025-001',
    'TOKEN-REQ-001',
    a.id_article,
    f.id_fournisseur,
    10,
    2500.00,
    25000.00
FROM article a
JOIN fournisseur f ON f.nom = 'Tech Supplies Ltd'
WHERE a.code = 'ART-001';

INSERT INTO bon_commande (id_proforma)
SELECT id_proforma
FROM proforma
WHERE numero = 'PROF-2025-001';

INSERT INTO facture_fournisseur (
    numero_facture,
    id_bon_commande,
    montant_total,
    date_facture,
    date_echeance,
    statut
)
SELECT
    'FAC-2025-001',
    bc.id_bon_commande,
    25000.00,
    CURRENT_DATE,
    CURRENT_DATE + INTERVAL '30 days',
    'EN_ATTENTE'
FROM bon_commande bc
JOIN proforma p ON p.id_proforma = bc.id_proforma
WHERE p.numero = 'PROF-2025-001';

INSERT INTO bon_livraison (
    numero_livraison,
    id_bon_commande,
    date_livraison,
    transporteur,
    numero_bon_transport,
    statut
)
SELECT
    'BL-2025-001',
    bc.id_bon_commande,
    CURRENT_DATE,
    'TRANS-MG',
    'BT-778899',
    'RECU'
FROM bon_commande bc
JOIN proforma p ON p.id_proforma = bc.id_proforma
WHERE p.numero = 'PROF-2025-001';




CREATE TABLE site (
    id_site SERIAL PRIMARY KEY,
    code_site VARCHAR(20) UNIQUE NOT NULL,
    nom_site VARCHAR(100) NOT NULL,
    adresse TEXT,
    entite_legale VARCHAR(150)
);

INSERT INTO site (code_site, nom_site, adresse, entite_legale)
VALUES ('SITE-ANT-001', 'Site Antananarivo Central', 'Antananarivo', 'ABC Madagascar');




CREATE TABLE depot (
    id_depot SERIAL PRIMARY KEY,
    code_depot VARCHAR(20) UNIQUE NOT NULL,
    nom_depot VARCHAR(100) NOT NULL,
    id_site INT REFERENCES site(id_site),
    adresse TEXT,
    responsable_id INT REFERENCES utilisateur(id_utilisateur)
);

INSERT INTO depot (code_depot, nom_depot, id_site, adresse, responsable_id)
SELECT
    'DEP-ANT-01',
    'Dépôt Central Antananarivo',
    s.id_site,
    'Zone industrielle Antananarivo',
    u.id_utilisateur
FROM site s
JOIN utilisateur u ON u.email = 'marie.rasoa@company.mg'
WHERE s.code_site = 'SITE-ANT-001';






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
    id_depot INT NOT NULL,
    
    FOREIGN KEY (id_bon_livraison) REFERENCES bon_livraison(id_bon_livraison) ON DELETE CASCADE,
    FOREIGN KEY (id_article) REFERENCES article(id_article),
    FOREIGN KEY (id_receptionnaire) REFERENCES utilisateur(id_utilisateur),
    FOREIGN KEY(id_depot) REFERENCES depot(id_depot)
);




-- ========================================
-- Stock
-- ========================================

CREATE TABLE methode_calcul_stock (
    id_methode SERIAL PRIMARY KEY,
    nom_methode VARCHAR(50) UNIQUE NOT NULL -- e.g., FIFO, LIFO, CMUP
);

INSERT INTO methode_calcul_stock (nom_methode)
VALUES ('LIFO');

INSERT INTO methode_calcul_stock (nom_methode)
VALUES ('CMUP');




CREATE TABLE methode_article(
    id_methode_article SERIAL PRIMARY KEY,
    id_article INT NOT NULL,
    id_methode INT NOT NULL,

    FOREIGN KEY (id_article) REFERENCES article(id_article),
    FOREIGN KEY (id_methode) REFERENCES methode_calcul_stock(id_methode)
);

INSERT INTO methode_article (id_article, id_methode)
VALUES (1, 2);

INSERT INTO methode_article (id_article, id_methode)
VALUES (2, 2);






CREATE OR REPLACE FUNCTION trg_set_article_methode()
RETURNS TRIGGER AS $$
BEGIN
    SELECT ma.id_methode_article
    INTO NEW.id_methode_article
    FROM methode_article ma
    WHERE ma.id_article = NEW.id_article;

    IF NEW.id_methode_article IS NULL THEN
        RAISE EXCEPTION
            'No stock calculation method defined for article id %',
            NEW.id_article;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;



CREATE TABLE mouvement_stock(
    stock_id SERIAL PRIMARY KEY,
    id_article INT NOT NULL, 
    quantite_stock NUMERIC(15,3) NOT NULL,
    id_methode_article INT NOT NULL,
    prix_article NUMERIC(15,3) NOT NULL,
    id_depot INT NOT NULL,
    date_entree_stock TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    mouvement_type VARCHAR(20) NOT NULL DEFAULT 'ENTREE', -- e.g., ENTREE, SORTIE

    FOREIGN KEY (id_article) REFERENCES article(id_article),
    FOREIGN KEY (id_depot) REFERENCES depot(id_depot),
    FOREIGN KEY (id_methode_article) REFERENCES methode_article(id_methode_article)
);


CREATE TRIGGER before_insert_mouvement_stock
BEFORE INSERT ON mouvement_stock
FOR EACH ROW
EXECUTE FUNCTION trg_set_article_methode();









-- Trigger d'insertion dans le stock lors de la réception d'un bon de réception

CREATE OR REPLACE FUNCTION trg_insert_stock_after_reception()
RETURNS TRIGGER AS $$
DECLARE
    v_id_methode_article INT;
    v_prix_article NUMERIC(15,3);
BEGIN
    SELECT ma.id_methode_article
    INTO v_id_methode_article
    FROM methode_article ma
    WHERE ma.id_article = NEW.id_article;

    IF v_id_methode_article IS NULL THEN
        RAISE EXCEPTION
            'No stock calculation method defined for article id %',
            NEW.id_article;
    END IF;

    SELECT p.montant
    INTO v_prix_article
    FROM prix p
    WHERE p.id_article = NEW.id_article
      AND p.type = 'ACHAT'
    ORDER BY p.date_prix DESC
    LIMIT 1;

    IF v_prix_article IS NULL THEN
        RAISE EXCEPTION
            'No purchase price found for article id %',
            NEW.id_article;
    END IF;

    INSERT INTO mouvement_stock (
        id_article,
        quantite_stock,
        id_methode_article,
        prix_article,
        id_depot,
        date_entree_stock,
        mouvement_type
    )
    VALUES (
        NEW.id_article,
        NEW.quantite_recue,
        v_id_methode_article,
        v_prix_article,
        NEW.id_depot,
        CURRENT_TIMESTAMP,
        'ENTREE'
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;



CREATE TRIGGER after_insert_bon_reception
AFTER INSERT ON bon_reception
FOR EACH ROW
EXECUTE FUNCTION trg_insert_stock_after_reception();




INSERT INTO bon_reception (
    id_bon_livraison,
    id_article,
    quantite_commandee,
    quantite_recue,
    quantite_non_conforme,
    commentaire,
    id_receptionnaire,
    id_depot
)
SELECT
    bl.id_bon_livraison,
    a.id_article,
    10,
    9,
    1,
    '1 unité endommagée',
    u.id_utilisateur,
    d.id_depot
FROM bon_livraison bl
JOIN bon_commande bc ON bc.id_bon_commande = bl.id_bon_commande
JOIN proforma p ON p.id_proforma = bc.id_proforma
JOIN article a ON a.id_article = p.id_article
JOIN utilisateur u ON u.email = 'jean.rakoto@company.mg'
JOIN depot d ON d.code_depot = 'DEP-ANT-01'
WHERE bl.numero_livraison = 'BL-2025-001';



CREATE TABLE inventaire_stock (
    id_inventaire SERIAL PRIMARY KEY,
    token_inventaire VARCHAR(50) NOT NULL, -- pour regrouper les lignes d'un même inventaire
    id_depot INT NOT NULL,
    date_inventaire TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_article INT NOT NULL,
    quantite_sur_terrain NUMERIC(15,3) NOT NULL,
    id_responsable INT,

    FOREIGN KEY (id_depot) REFERENCES depot(id_depot),
    FOREIGN KEY (id_responsable) REFERENCES utilisateur(id_utilisateur),
    FOREIGN KEY (id_article) REFERENCES article(id_article)
);






CREATE TABLE validation_inventaire(
    id_validation SERIAL PRIMARY KEY,
    id_inventaire INT NOT NULL,
    id_validateur INT NOT NULL,
    date_validation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    statut_validation VARCHAR(20) NOT NULL, -- e.g., VALIDE, REJETE

    FOREIGN KEY (id_inventaire) REFERENCES inventaire_stock(id_inventaire),
    FOREIGN KEY (id_validateur) REFERENCES utilisateur(id_utilisateur)  
);














CREATE TABLE inventaire(
    id_inventaire SERIAL PRIMARY KEY,
    id_article INT NOT NULL, 
    quantite_stock NUMERIC(15,3) NOT NULL,
    id_methode_article INT NOT NULL,
    id_depot INT NOT NULL,
    date_entree_stock TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    mouvement_type VARCHAR(20) NOT NULL DEFAULT 'ENTREE', -- e.g., ENTREE, SORTIE

    FOREIGN KEY (id_article) REFERENCES article(id_article),
    FOREIGN KEY (id_depot) REFERENCES depot(id_depot),
    FOREIGN KEY (id_methode_article) REFERENCES methode_article(id_methode_article)
);
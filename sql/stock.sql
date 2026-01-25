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

INSERT INTO methode_calcul_stock (nom_methode)
VALUES ('FIFO');




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












CREATE TABLE lot_stock (
    id_lot SERIAL PRIMARY KEY,
    id_article INT NOT NULL,
    id_depot INT NOT NULL,
    quantite_restante NUMERIC(15,3) NOT NULL,
    prix_unitaire NUMERIC(15,3) NOT NULL,
    date_entree TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_article) REFERENCES article(id_article),
    FOREIGN KEY (id_depot) REFERENCES depot(id_depot)
);







CREATE TABLE mouvement_stock_calcul (
    id SERIAL PRIMARY KEY,
    id_depot INT NOT NULL,
    id_methode_article INT NOT NULL,
    id_article INT NOT NULL,
    quantite_article NUMERIC(15,3) NOT NULL,
    prix_total NUMERIC(15,3) NOT NULL,
    prix_par_methode NUMERIC(15,3) NOT NULL,
    date_mouvement TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (id_depot) REFERENCES depot(id_depot),
    FOREIGN KEY (id_methode_article) REFERENCES methode_article(id_methode_article),
    FOREIGN KEY (id_article) REFERENCES article(id_article)
);









CREATE OR REPLACE FUNCTION fn_mouvement_stock()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    last_qty NUMERIC(15,3) := 0;
    last_total NUMERIC(15,3) := 0;
    last_pu NUMERIC(15,3) := 0;

    new_qty NUMERIC(15,3);
    new_total NUMERIC(15,3);
    new_pu NUMERIC(15,3);

    methode_nom TEXT;
    remaining_qty NUMERIC(15,3);
    lot RECORD;
BEGIN
    -- Méthode
    SELECT mcs.nom_methode
    INTO methode_nom
    FROM methode_article ma
    JOIN methode_calcul_stock mcs ON mcs.id_methode = ma.id_methode
    WHERE ma.id_methode_article = NEW.id_methode_article;

    -- Dernier état du stock
    SELECT quantite_article, prix_total, prix_par_methode
    INTO last_qty, last_total, last_pu
    FROM mouvement_stock_calcul
    WHERE id_article = NEW.id_article
      AND id_depot = NEW.id_depot
    ORDER BY id DESC
    LIMIT 1;

    IF NOT FOUND THEN
        last_qty := 0;
        last_total := 0;
        last_pu := 0;
    END IF;

    ------------------------------------------------------------------
    -- ENTREE
    ------------------------------------------------------------------
    IF NEW.mouvement_type = 'ENTREE' THEN
        new_qty := last_qty + NEW.quantite_stock;

        IF methode_nom = 'CMUP' THEN
            new_total := last_total + (NEW.quantite_stock * NEW.prix_article);
            new_pu := new_total / new_qty;
        ELSE
            -- FIFO / LIFO
            new_total := last_total + (NEW.quantite_stock * NEW.prix_article);
            new_pu := new_total / new_qty; -- only for valuation display
            INSERT INTO lot_stock(id_article, id_depot, quantite_restante, prix_unitaire)
            VALUES (NEW.id_article, NEW.id_depot, NEW.quantite_stock, NEW.prix_article);
        END IF;

    ------------------------------------------------------------------
    -- SORTIE
    ------------------------------------------------------------------
    ELSE
        IF last_qty < NEW.quantite_stock THEN
            RAISE EXCEPTION 'Stock insuffisant';
        END IF;

        new_qty := last_qty - NEW.quantite_stock;

        IF methode_nom = 'CMUP' THEN
            new_total := last_total - (NEW.quantite_stock * last_pu);
            new_pu := CASE WHEN new_qty = 0 THEN 0 ELSE new_total / new_qty END;

        ELSE
            remaining_qty := NEW.quantite_stock;
            new_total := last_total;

            FOR lot IN
                SELECT * FROM lot_stock
                WHERE id_article = NEW.id_article AND id_depot = NEW.id_depot
                ORDER BY date_entree
            LOOP
                EXIT WHEN remaining_qty <= 0;

                IF lot.quantite_restante <= remaining_qty THEN
                    remaining_qty := remaining_qty - lot.quantite_restante;
                    new_total := new_total - (lot.quantite_restante * lot.prix_unitaire);
                    DELETE FROM lot_stock WHERE id_lot = lot.id_lot;
                ELSE
                    UPDATE lot_stock
                    SET quantite_restante = quantite_restante - remaining_qty
                    WHERE id_lot = lot.id_lot;

                    new_total := new_total - (remaining_qty * lot.prix_unitaire);
                    remaining_qty := 0;
                END IF;
            END LOOP;

            new_pu := CASE WHEN new_qty = 0 THEN 0 ELSE new_total / new_qty END;
        END IF;
    END IF;

    ------------------------------------------------------------------
    -- INSERT SNAPSHOT
    ------------------------------------------------------------------
    INSERT INTO mouvement_stock_calcul(
        id_depot,
        id_methode_article,
        id_article,
        quantite_article,
        prix_total,
        prix_par_methode
    ) VALUES (
        NEW.id_depot,
        NEW.id_methode_article,
        NEW.id_article,
        new_qty,
        new_total,
        new_pu
    );

    RETURN NEW;
END;
$$;






-- Trigger sur mouvement_stock
CREATE TRIGGER trg_mouvement_stock
AFTER INSERT ON mouvement_stock
FOR EACH ROW
EXECUTE FUNCTION fn_mouvement_stock();









CREATE OR REPLACE VIEW vue_stock_actuel AS

/* =========================================================
   CMUP ARTICLES → last snapshot from mouvement_stock_calcul
   ========================================================= */
SELECT
    msc.id,
    msc.id_depot,
    msc.id_methode_article,
    msc.id_article,
    msc.quantite_article,
    msc.prix_total,
    msc.prix_par_methode,
    msc.date_mouvement
FROM mouvement_stock_calcul msc
JOIN (
    SELECT
        id_article,
        id_depot,
        MAX(id) AS max_id
    FROM mouvement_stock_calcul
    GROUP BY id_article, id_depot
) last_msc
    ON msc.id = last_msc.max_id
JOIN methode_article ma
    ON ma.id_methode_article = msc.id_methode_article
JOIN methode_calcul_stock mcs
    ON mcs.id_methode = ma.id_methode
WHERE mcs.nom_methode = 'CMUP'

UNION ALL

/* =========================================================
   FIFO / LIFO ARTICLES → one row per lot (NO aggregation)
   ========================================================= */
SELECT
    ls.id_lot AS id,
    ls.id_depot,
    ma.id_methode_article,
    ls.id_article,
    ls.quantite_restante AS quantite_article,
    (ls.quantite_restante * ls.prix_unitaire)::NUMERIC(15,3) AS prix_total,
    ls.prix_unitaire AS prix_par_methode,
    ls.date_entree AS date_mouvement
FROM lot_stock ls
JOIN methode_article ma
    ON ma.id_article = ls.id_article
JOIN methode_calcul_stock mcs
    ON mcs.id_methode = ma.id_methode
WHERE mcs.nom_methode IN ('FIFO', 'LIFO');






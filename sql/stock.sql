-- insert lapatia_Achat.sql dans ta base sauf le bon_reception qui sera dessous

CREATE TABLE site (
    id_site SERIAL PRIMARY KEY,
    code_site VARCHAR(20) UNIQUE NOT NULL,
    nom_site VARCHAR(100) NOT NULL,
    adresse TEXT,
    entite_legale VARCHAR(150)
);

CREATE TABLE depot (
    id_depot SERIAL PRIMARY KEY,
    code_depot VARCHAR(20) UNIQUE NOT NULL,
    nom_depot VARCHAR(100) NOT NULL,
    id_site INT REFERENCES site(id_site),
    adresse TEXT,
    responsable_id INT REFERENCES utilisateur(id_utilisateur)
);

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

CREATE TABLE stocks(
    stock_id SERIAL PRIMARY KEY,
    id_article INT NOT NULL, 
    quantite_stock NUMERIC(15,3) NOT NULL,
    id_depot INT NOT NULL,
    date_entree_stock TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_article) REFERENCES article(id_article),
    FOREIGN KEY (id_depot) REFERENCES depot(id_depot)
);

-- Trigger d'insertion dans le stock lors de la réception d'un bon de réception

CREATE OR REPLACE FUNCTION trg_insert_stock_after_reception()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO stocks (
        id_article,
        quantite_stock,
        id_depot,
        date_entree_stock
    )
    VALUES (
        NEW.id_article,
        NEW.quantite_recue,
        NEW.id_depot,
        CURRENT_TIMESTAMP
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_insert_bon_reception
AFTER INSERT ON bon_reception
FOR EACH ROW
EXECUTE FUNCTION trg_insert_stock_after_reception();


CREATE TABLE inventaire_stock (
    id_inventaire SERIAL PRIMARY KEY,
    id_depot INT NOT NULL,
    id_article INT NOT NULL,
    nouvelle_quantite NUMERIC(15,3) NOT NULL,
    prix_total_inventaire NUMERIC(18,4) NOT NULL,
    date_inventaire TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_responsable INT,

    FOREIGN KEY (id_depot) REFERENCES depot(id_depot),
    FOREIGN KEY (id_responsable) REFERENCES utilisateur(id_utilisateur),
    FOREIGN KEY (id_article) REFERENCES article(id_article)
);
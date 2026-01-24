INSERT INTO fournisseur (id_fournisseur, nom, email, telephone)
VALUES (
    1,
    'TEXTILE SUPPLY LTD',
    'contact@textilesupply.com',
    '+261 34 00 000 00'
);






-- Article géré en FIFO / LIFO
INSERT INTO article (id_article, code, designation)
VALUES (
    1,
    'TSHIRT-FIFO',
    'T-Shirt coton standard (FIFO/LIFO)'
);

-- Article géré en CMUP
INSERT INTO article (id_article, code, designation)
VALUES (
    2,
    'TSHIRT-CMUP',
    'T-Shirt coton premium (CMUP)'
);






INSERT INTO prix (id_prix, id_article, id_fournisseur, type, montant, date_prix)
VALUES
(
    1,
    1,
    1,
    'ACHAT',
    10.00,
    '2025-01-10'
),
(
    2,
    1,
    1,
    'ACHAT',
    15.00,
    '2025-02-05'
);

INSERT INTO prix (id_prix, id_article, id_fournisseur, type, montant, date_prix)
VALUES
(
    3,
    2,
    1,
    'ACHAT',
    20.00,
    '2025-01-12'
),
(
    4,
    2,
    1,
    'ACHAT',
    30.00,
    '2025-02-10'
);







-- Article 1 : géré en FIFO (ou LIFO selon ton choix fonctionnel)
INSERT INTO methode_article (id_methode_article, id_article, id_methode)
VALUES (
    1,
    1,  -- TSHIRT-FIFO
    3   -- FIFO
);

-- Article 2 : géré en CMUP
INSERT INTO methode_article (id_methode_article, id_article, id_methode)
VALUES (
    2,
    2,  -- TSHIRT-CMUP
    2   -- CMUP
);









-- Entrée 1 : 15 T-shirts à 10$
INSERT INTO mouvement_stock (
    id_article,
    quantite_stock,
    id_methode_article,
    prix_article,
    id_depot,
    mouvement_type
) VALUES (
    1,
    15,
    1,
    10.000,
    1,
    'ENTREE'
);

-- Entrée 2 : 5 T-shirts à 15$
INSERT INTO mouvement_stock (
    id_article,
    quantite_stock,
    id_methode_article,
    prix_article,
    id_depot,
    mouvement_type
) VALUES (
    1,
    5,
    1,
    15.000,
    1,
    'ENTREE'
);

-- Sortie : 8 T-shirts
INSERT INTO mouvement_stock (
    id_article,
    quantite_stock,
    id_methode_article,
    prix_article,
    id_depot,
    mouvement_type
) VALUES (
    1,
    8,
    1,
    0.000,   -- prix ignoré en sortie, calculé par FIFO
    1,
    'SORTIE'
);








-- Entrée 1 : 10 T-shirts à 20$
INSERT INTO mouvement_stock (
    id_article,
    quantite_stock,
    id_methode_article,
    prix_article,
    id_depot,
    mouvement_type
) VALUES (
    2,
    10,
    2,
    20.000,
    1,
    'ENTREE'
);

-- Entrée 2 : 10 T-shirts à 30$
INSERT INTO mouvement_stock (
    id_article,
    quantite_stock,
    id_methode_article,
    prix_article,
    id_depot,
    mouvement_type
) VALUES (
    2,
    10,
    2,
    30.000,
    1,
    'ENTREE'
);

-- Sortie : 5 T-shirts
INSERT INTO mouvement_stock (
    id_article,
    quantite_stock,
    id_methode_article,
    prix_article,
    id_depot,
    mouvement_type
) VALUES (
    2,
    5,
    2,
    0.000,   -- prix recalculé via CMUP
    1,
    'SORTIE'
);

-- change the CMUP price via insert of new stock
INSERT INTO mouvement_stock(
    id_article,
    quantite_stock,
    id_methode_article, -- CMUP method
    prix_article,
    id_depot,
    mouvement_type
) VALUES (
    2,      -- article id
    5,      -- quantity
    2,      -- CMUP
    30,     -- unit price
    1,      -- depot
    'ENTREE' 
);








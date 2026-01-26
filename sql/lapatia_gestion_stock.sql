-- ========================================
-- SYSTÈME DE GESTION DE STOCK AVANCÉ
-- ========================================

-- Table des types de mouvement
CREATE TABLE Type_Mouvement_Stock (
    id_type_mouvement SERIAL PRIMARY KEY,
    code VARCHAR(20) UNIQUE NOT NULL,
    libelle VARCHAR(100) NOT NULL,
    sens VARCHAR(10) NOT NULL, -- 'ENTREE' ou 'SORTIE'
    CONSTRAINT check_sens CHECK (sens IN ('ENTREE', 'SORTIE'))
);

-- Insérer les types de mouvement standards
INSERT INTO Type_Mouvement_Stock (code, libelle, sens) VALUES
('RECEP_FOURN', 'Réception fournisseur', 'ENTREE'),
('RETOUR_CLIENT', 'Retour client', 'ENTREE'),
('AJUST_POS', 'Ajustement positif', 'ENTREE'),
('TRANSF_IN', 'Transfert entrant', 'ENTREE'),
('LIV_CLIENT', 'Livraison client', 'SORTIE'),
('CONSO_INTERNE', 'Consommation interne', 'SORTIE'),
('REBUT', 'Rebut', 'SORTIE'),
('AJUST_NEG', 'Ajustement négatif', 'SORTIE'),
('TRANSF_OUT', 'Transfert sortant', 'SORTIE');

-- Table des lots
CREATE TABLE Lot (
    id_lot SERIAL PRIMARY KEY,
    numero_lot VARCHAR(50) UNIQUE NOT NULL,
    id_article INTEGER NOT NULL REFERENCES Article(id_article),
    date_fabrication DATE,
    date_peremption DATE,
    dluo DATE, -- Date Limite d'Utilisation Optimale
    dlc DATE, -- Date Limite de Consommation
    quantite_initiale INTEGER NOT NULL,
    quantite_restante INTEGER NOT NULL,
    statut VARCHAR(20) DEFAULT 'ACTIF', -- ACTIF, EXPIRE, BLOQUE, NON_CONFORME
    cout_unitaire DECIMAL(15,4) NOT NULL,
    id_fournisseur INTEGER REFERENCES Fournisseur(id_fournisseur),
    reference_document VARCHAR(100),
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT check_statut_lot CHECK (statut IN ('ACTIF', 'EXPIRE', 'BLOQUE', 'NON_CONFORME')),
    CONSTRAINT check_quantites CHECK (quantite_restante >= 0 AND quantite_restante <= quantite_initiale)
);

-- Table des dépôts/entrepôts
CREATE TABLE Depot (
    id_depot SERIAL PRIMARY KEY,
    code_depot VARCHAR(20) UNIQUE NOT NULL,
    nom VARCHAR(100) NOT NULL,
    adresse TEXT,
    actif BOOLEAN DEFAULT TRUE
);

-- Insérer un dépôt par défaut
INSERT INTO Depot (code_depot, nom, adresse) VALUES
('DEP-001', 'Dépôt Principal', 'Zone Industrielle');

-- Table des emplacements dans les dépôts
CREATE TABLE Emplacement (
    id_emplacement SERIAL PRIMARY KEY,
    id_depot INTEGER NOT NULL REFERENCES Depot(id_depot),
    code_emplacement VARCHAR(20) NOT NULL,
    nom VARCHAR(100),
    capacite_max INTEGER,
    UNIQUE(id_depot, code_emplacement)
);

-- Table des mouvements de stock (traçabilité complète)
CREATE TABLE Mouvement_Stock (
    id_mouvement SERIAL PRIMARY KEY,
    numero_mouvement VARCHAR(50) UNIQUE NOT NULL,
    id_type_mouvement INTEGER NOT NULL REFERENCES Type_Mouvement_Stock(id_type_mouvement),
    id_article INTEGER NOT NULL REFERENCES Article(id_article),
    id_lot INTEGER REFERENCES Lot(id_lot),
    id_depot INTEGER REFERENCES Depot(id_depot),
    id_emplacement INTEGER REFERENCES Emplacement(id_emplacement),
    quantite INTEGER NOT NULL,
    cout_unitaire DECIMAL(15,4) NOT NULL,
    cout_total DECIMAL(15,2) NOT NULL,
    reference_document VARCHAR(100), -- Référence BL, BC, Facture, etc.
    type_document VARCHAR(50), -- BonReception, BonLivraison, etc.
    date_mouvement TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_utilisateur INTEGER REFERENCES Utilisateur(id_utilisateur),
    commentaire TEXT,
    valide BOOLEAN DEFAULT TRUE,
    date_validation TIMESTAMP,
    cloture BOOLEAN DEFAULT FALSE, -- Si le mouvement est dans une période clôturée
    CONSTRAINT check_quantite_positive CHECK (quantite > 0)
);

-- Table de gestion des réservations de stock
CREATE TABLE Reservation_Stock (
    id_reservation SERIAL PRIMARY KEY,
    id_article INTEGER NOT NULL REFERENCES Article(id_article),
    id_lot INTEGER REFERENCES Lot(id_lot),
    quantite_reservee INTEGER NOT NULL,
    reference_document VARCHAR(100) NOT NULL, -- BC Client par exemple
    type_reservation VARCHAR(50) NOT NULL, -- COMMANDE_CLIENT, PRODUCTION, etc.
    date_reservation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_expiration TIMESTAMP,
    statut VARCHAR(20) DEFAULT 'ACTIVE', -- ACTIVE, LIBEREE, CONSOMMEE, EXPIREE
    id_utilisateur INTEGER REFERENCES Utilisateur(id_utilisateur),
    CONSTRAINT check_statut_reservation CHECK (statut IN ('ACTIVE', 'LIBEREE', 'CONSOMMEE', 'EXPIREE')),
    CONSTRAINT check_quantite_reservee CHECK (quantite_reservee > 0)
);

-- Table de configuration de valorisation par article
CREATE TABLE Config_Valorisation_Article (
    id_config SERIAL PRIMARY KEY,
    id_article INTEGER NOT NULL REFERENCES Article(id_article) UNIQUE,
    methode_valorisation VARCHAR(10) NOT NULL, -- FIFO, CMUP
    gestion_lot BOOLEAN DEFAULT FALSE,
    type_peremption VARCHAR(10), -- NULL, DLUO, DLC
    delai_alerte_peremption INTEGER, -- Nombre de jours avant alerte
    CONSTRAINT check_methode CHECK (methode_valorisation IN ('FIFO', 'CMUP')),
    CONSTRAINT check_type_peremption CHECK (type_peremption IS NULL OR type_peremption IN ('DLUO', 'DLC'))
);

-- Table de valorisation CMUP (Coût Moyen Pondéré)
CREATE TABLE Valorisation_CMUP (
    id_valorisation SERIAL PRIMARY KEY,
    id_article INTEGER NOT NULL REFERENCES Article(id_article),
    periode_mois DATE NOT NULL, -- Premier jour du mois
    quantite_debut INTEGER NOT NULL DEFAULT 0,
    valeur_debut DECIMAL(15,2) NOT NULL DEFAULT 0,
    quantite_entrees INTEGER NOT NULL DEFAULT 0,
    valeur_entrees DECIMAL(15,2) NOT NULL DEFAULT 0,
    quantite_sorties INTEGER NOT NULL DEFAULT 0,
    valeur_sorties DECIMAL(15,2) NOT NULL DEFAULT 0,
    quantite_fin INTEGER NOT NULL DEFAULT 0,
    valeur_fin DECIMAL(15,2) NOT NULL DEFAULT 0,
    cmup DECIMAL(15,4) NOT NULL DEFAULT 0,
    date_calcul TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(id_article, periode_mois)
);

-- Table de clôture mensuelle
CREATE TABLE Cloture_Stock (
    id_cloture SERIAL PRIMARY KEY,
    periode_mois DATE NOT NULL UNIQUE, -- Premier jour du mois
    date_cloture TIMESTAMP NOT NULL,
    id_utilisateur INTEGER REFERENCES Utilisateur(id_utilisateur),
    statut VARCHAR(20) DEFAULT 'EN_COURS', -- EN_COURS, VALIDEE, VERROUILLEE
    commentaire TEXT,
    CONSTRAINT check_statut_cloture CHECK (statut IN ('EN_COURS', 'VALIDEE', 'VERROUILLEE'))
);

-- Table d'inventaire
CREATE TABLE Inventaire (
    id_inventaire SERIAL PRIMARY KEY,
    numero_inventaire VARCHAR(50) UNIQUE NOT NULL,
    date_inventaire DATE NOT NULL,
    id_depot INTEGER REFERENCES Depot(id_depot),
    statut VARCHAR(20) DEFAULT 'EN_COURS', -- EN_COURS, VALIDE, APPLIQUE
    id_utilisateur INTEGER REFERENCES Utilisateur(id_utilisateur),
    commentaire TEXT,
    CONSTRAINT check_statut_inventaire CHECK (statut IN ('EN_COURS', 'VALIDE', 'APPLIQUE'))
);

-- Table de détail d'inventaire
CREATE TABLE Detail_Inventaire (
    id_detail SERIAL PRIMARY KEY,
    id_inventaire INTEGER NOT NULL REFERENCES Inventaire(id_inventaire),
    id_article INTEGER NOT NULL REFERENCES Article(id_article),
    id_lot INTEGER REFERENCES Lot(id_lot),
    quantite_theorique INTEGER NOT NULL,
    quantite_physique INTEGER NOT NULL,
    ecart INTEGER NOT NULL,
    valeur_ecart DECIMAL(15,2),
    commentaire TEXT,
    UNIQUE(id_inventaire, id_article, id_lot)
);

-- Mise à jour de la table Stock existante pour ajouter la valorisation
ALTER TABLE Stock ADD COLUMN IF NOT EXISTS valeur_stock DECIMAL(15,2) DEFAULT 0;
ALTER TABLE Stock ADD COLUMN IF NOT EXISTS cout_moyen_unitaire DECIMAL(15,4) DEFAULT 0;

-- ========================================
-- VUES POUR REPORTING
-- ========================================

-- Vue état du stock avec valorisation
CREATE OR REPLACE VIEW V_Etat_Stock AS
SELECT 
    s.id_stock,
    a.id_article,
    a.code_article,
    a.designation,
    a.categorie,
    s.quantite_disponible,
    s.quantite_reservee,
    (s.quantite_disponible - s.quantite_reservee) AS quantite_reellement_disponible,
    s.cout_moyen_unitaire,
    s.valeur_stock,
    cva.methode_valorisation,
    cva.gestion_lot,
    cva.type_peremption,
    s.date_mise_a_jour
FROM Stock s
JOIN Article a ON s.id_article = a.id_article
LEFT JOIN Config_Valorisation_Article cva ON a.id_article = cva.id_article;

-- Vue des lots actifs avec dates de péremption
CREATE OR REPLACE VIEW V_Lots_Actifs AS
SELECT 
    l.id_lot,
    l.numero_lot,
    a.id_article,
    a.designation AS designation_article,
    l.quantite_initiale,
    l.quantite_restante,
    l.dluo,
    l.dlc,
    l.statut,
    l.cout_unitaire,
    f.nom AS nom_fournisseur,
    CASE 
        WHEN l.dlc IS NOT NULL AND l.dlc < CURRENT_DATE THEN 'PERIME'
        WHEN l.dlc IS NOT NULL AND l.dlc <= CURRENT_DATE + INTERVAL '7 days' THEN 'ALERTE_PROCHE'
        WHEN l.dluo IS NOT NULL AND l.dluo < CURRENT_DATE THEN 'DLUO_DEPASSEE'
        WHEN l.dluo IS NOT NULL AND l.dluo <= CURRENT_DATE + INTERVAL '15 days' THEN 'ALERTE_DLUO'
        ELSE 'OK'
    END AS statut_peremption,
    l.date_creation
FROM Lot l
JOIN Article a ON l.id_article = a.id_article
LEFT JOIN Fournisseur f ON l.id_fournisseur = f.id_fournisseur
WHERE l.quantite_restante > 0;

-- Vue des mouvements de stock avec détails
CREATE OR REPLACE VIEW V_Mouvements_Stock AS
SELECT 
    ms.id_mouvement,
    ms.numero_mouvement,
    tms.code AS code_type_mouvement,
    tms.libelle AS type_mouvement,
    tms.sens,
    a.code_article,
    a.designation AS designation_article,
    l.numero_lot,
    d.nom AS nom_depot,
    ms.quantite,
    ms.cout_unitaire,
    ms.cout_total,
    ms.reference_document,
    ms.type_document,
    ms.date_mouvement,
    u.nom || ' ' || COALESCE(u.prenom, '') AS utilisateur,
    ms.valide,
    ms.cloture
FROM Mouvement_Stock ms
JOIN Type_Mouvement_Stock tms ON ms.id_type_mouvement = tms.id_type_mouvement
JOIN Article a ON ms.id_article = a.id_article
LEFT JOIN Lot l ON ms.id_lot = l.id_lot
LEFT JOIN Depot d ON ms.id_depot = d.id_depot
LEFT JOIN Utilisateur u ON ms.id_utilisateur = u.id_utilisateur
ORDER BY ms.date_mouvement DESC;

-- Vue des réservations actives
CREATE OR REPLACE VIEW V_Reservations_Stock AS
SELECT 
    rs.id_reservation,
    a.code_article,
    a.designation AS designation_article,
    l.numero_lot,
    rs.quantite_reservee,
    rs.reference_document,
    rs.type_reservation,
    rs.date_reservation,
    rs.date_expiration,
    rs.statut,
    u.nom || ' ' || COALESCE(u.prenom, '') AS utilisateur
FROM Reservation_Stock rs
JOIN Article a ON rs.id_article = a.id_article
LEFT JOIN Lot l ON rs.id_lot = l.id_lot
LEFT JOIN Utilisateur u ON rs.id_utilisateur = u.id_utilisateur
WHERE rs.statut = 'ACTIVE'
ORDER BY rs.date_reservation DESC;

-- Vue analyse chiffre d'affaires par article
CREATE OR REPLACE VIEW V_CA_Par_Article AS
SELECT 
    a.id_article,
    a.code_article,
    a.designation,
    a.categorie,
    COUNT(DISTINCT fc.id_facture_client) AS nb_ventes,
    SUM(bcc.quantite) AS quantite_totale_vendue,
    SUM(fc.montant_total) AS ca_total,
    AVG(fc.montant_total / bcc.quantite) AS prix_moyen_vente,
    MIN(fc.date_facture) AS premiere_vente,
    MAX(fc.date_facture) AS derniere_vente
FROM Article a
LEFT JOIN Bon_Commande_Client bcc ON a.id_article = bcc.id_article
LEFT JOIN Facture_Client fc ON bcc.id_bon_commande_client = fc.id_bon_commande_client
WHERE fc.statut_paiement = 'PAYE'
GROUP BY a.id_article, a.code_article, a.designation, a.categorie;

-- ========================================
-- INDEX POUR PERFORMANCES
-- ========================================

CREATE INDEX idx_mouvement_article ON Mouvement_Stock(id_article);
CREATE INDEX idx_mouvement_date ON Mouvement_Stock(date_mouvement);
CREATE INDEX idx_mouvement_lot ON Mouvement_Stock(id_lot);
CREATE INDEX idx_mouvement_type ON Mouvement_Stock(id_type_mouvement);
CREATE INDEX idx_mouvement_cloture ON Mouvement_Stock(cloture);
CREATE INDEX idx_lot_article ON Lot(id_article);
CREATE INDEX idx_lot_statut ON Lot(statut);
CREATE INDEX idx_lot_dlc ON Lot(dlc);
CREATE INDEX idx_lot_dluo ON Lot(dluo);
CREATE INDEX idx_reservation_article ON Reservation_Stock(id_article);
CREATE INDEX idx_reservation_statut ON Reservation_Stock(statut);

-- ========================================
-- FONCTIONS UTILITAIRES
-- ========================================

-- Fonction pour générer un numéro de mouvement
CREATE OR REPLACE FUNCTION generer_numero_mouvement()
RETURNS VARCHAR AS $$
DECLARE
    nouveau_numero VARCHAR;
    compteur INTEGER;
BEGIN
    SELECT COUNT(*) + 1 INTO compteur FROM Mouvement_Stock;
    nouveau_numero := 'MVT-' || TO_CHAR(CURRENT_DATE, 'YYYY') || '-' || LPAD(compteur::TEXT, 6, '0');
    RETURN nouveau_numero;
END;
$$ LANGUAGE plpgsql;

-- Fonction pour bloquer automatiquement les lots expirés
CREATE OR REPLACE FUNCTION bloquer_lots_expires()
RETURNS void AS $$
BEGIN
    UPDATE Lot 
    SET statut = 'EXPIRE'
    WHERE (dlc IS NOT NULL AND dlc < CURRENT_DATE)
       OR (dlc IS NULL AND dluo IS NOT NULL AND dluo < CURRENT_DATE - INTERVAL '30 days')
    AND statut = 'ACTIF';
END;
$$ LANGUAGE plpgsql;

-- Trigger pour calculer le coût total d'un mouvement
CREATE OR REPLACE FUNCTION calculer_cout_total_mouvement()
RETURNS TRIGGER AS $$
BEGIN
    NEW.cout_total := NEW.quantite * NEW.cout_unitaire;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_cout_total_mouvement
BEFORE INSERT OR UPDATE ON Mouvement_Stock
FOR EACH ROW
EXECUTE FUNCTION calculer_cout_total_mouvement();

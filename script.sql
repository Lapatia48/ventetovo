-- Base de donnees systeme de gestion Achats/Ventes/Stock - VERSION COMPLETE
CREATE DATABASE vente_tovo;
\c vente_tovo;

-- =====================================================
-- 1. RÉFÉRENTIELS COMPLETS
-- =====================================================

-- Unités de mesure
CREATE TABLE unite_mesure (
    id_unite SERIAL PRIMARY KEY,
    code VARCHAR(10) UNIQUE NOT NULL,
    libelle VARCHAR(50) NOT NULL
);

-- Taxes
CREATE TABLE taxe (
    id_taxe SERIAL PRIMARY KEY,
    code VARCHAR(20) UNIQUE NOT NULL,
    taux NUMERIC(5,2) NOT NULL, -- Ex: 20.00 pour 20%
    libelle VARCHAR(100) NOT NULL
);

-- Familles d'articles
CREATE TABLE famille_article (
    id_famille SERIAL PRIMARY KEY,
    code VARCHAR(20) UNIQUE NOT NULL,
    libelle VARCHAR(100) NOT NULL,
    tracabilite_lot BOOLEAN DEFAULT FALSE,
    methode_valorisation VARCHAR(10) DEFAULT 'CUMP' CHECK (methode_valorisation IN ('FIFO', 'CUMP'))
);

-- Articles avec tous les attributs
CREATE TABLE article (
    id_article SERIAL PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL,
    designation VARCHAR(200) NOT NULL,
    id_famille INT REFERENCES famille_article(id_famille),
    id_unite INT REFERENCES unite_mesure(id_unite),
    prix_achat NUMERIC(15,2) DEFAULT 0,
    prix_vente NUMERIC(15,2) NOT NULL,
    seuil_alerte INT DEFAULT 10,
    poids NUMERIC(10,3),
    volume NUMERIC(10,3),
    actif BOOLEAN DEFAULT TRUE
);

-- Conditions de paiement
CREATE TABLE condition_paiement (
    id_condition SERIAL PRIMARY KEY,
    code VARCHAR(20) UNIQUE NOT NULL,
    libelle VARCHAR(100) NOT NULL,
    nombre_jours INT DEFAULT 30,
    escompte NUMERIC(5,2) DEFAULT 0
);

-- Tarifs (grilles tarifaires)
CREATE TABLE grille_tarifaire (
    id_grille SERIAL PRIMARY KEY,
    code VARCHAR(20) UNIQUE NOT NULL,
    libelle VARCHAR(100) NOT NULL,
    date_debut DATE NOT NULL,
    date_fin DATE
);

CREATE TABLE ligne_grille_tarifaire (
    id_ligne SERIAL PRIMARY KEY,
    id_grille INT NOT NULL REFERENCES grille_tarifaire(id_grille),
    id_article INT NOT NULL REFERENCES article(id_article),
    prix NUMERIC(15,2) NOT NULL,
    quantite_min INT DEFAULT 1
);

-- Clients avec conditions spécifiques
CREATE TABLE client (
    id_client SERIAL PRIMARY KEY,
    nom VARCHAR(150) NOT NULL,
    email VARCHAR(150),
    telephone VARCHAR(20),
    adresse TEXT,
    id_condition_paiement INT REFERENCES condition_paiement(id_condition),
    id_grille_tarifaire INT REFERENCES grille_tarifaire(id_grille),
    credit_max NUMERIC(15,2) DEFAULT 0,
    actif BOOLEAN DEFAULT TRUE
);

-- Fournisseurs
CREATE TABLE fournisseur (
    id_fournisseur SERIAL PRIMARY KEY,
    nom VARCHAR(150) NOT NULL,
    email VARCHAR(150),
    telephone VARCHAR(20),
    adresse TEXT,
    id_condition_paiement INT REFERENCES condition_paiement(id_condition),
    delai_livraison_moyen INT DEFAULT 7,
    actif BOOLEAN DEFAULT TRUE
);

-- =====================================================
-- 2. SÉCURITÉ & HABILITATIONS (RBAC + ABAC)
-- =====================================================

-- Rôles
CREATE TABLE role (
    id_role SERIAL PRIMARY KEY,
    code_role VARCHAR(50) UNIQUE NOT NULL,
    libelle_role VARCHAR(100) NOT NULL,
    niveau_hierarchie INT DEFAULT 0 -- 0=opérateur, 1=superviseur, 2=manager, 3=directeur
);

-- Permissions
CREATE TABLE permission (
    id_permission SERIAL PRIMARY KEY,
    code_permission VARCHAR(50) UNIQUE NOT NULL,
    libelle_permission VARCHAR(100) NOT NULL,
    module VARCHAR(50) -- 'ACHATS', 'VENTES', 'STOCK', 'FINANCE'
);

-- Rôle-Permissions
CREATE TABLE role_permission (
    id_role INT NOT NULL REFERENCES role(id_role),
    id_permission INT NOT NULL REFERENCES permission(id_permission),
    PRIMARY KEY (id_role, id_permission)
);

-- Utilisateurs
CREATE TABLE utilisateur (
    id_utilisateur SERIAL PRIMARY KEY,
    matricule VARCHAR(50) UNIQUE,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    mot_de_passe VARCHAR(255) NOT NULL,
    id_role INT NOT NULL REFERENCES role(id_role),
    date_embauche DATE,
    actif BOOLEAN DEFAULT TRUE
);

-- Sites/Entités légales
CREATE TABLE site (
    id_site SERIAL PRIMARY KEY,
    code_site VARCHAR(20) UNIQUE NOT NULL,
    nom_site VARCHAR(100) NOT NULL,
    adresse TEXT,
    entite_legale VARCHAR(150)
);

-- Dépôts avec lien aux sites
CREATE TABLE depot (
    id_depot SERIAL PRIMARY KEY,
    code_depot VARCHAR(20) UNIQUE NOT NULL,
    nom_depot VARCHAR(100) NOT NULL,
    id_site INT REFERENCES site(id_site),
    adresse TEXT,
    responsable_id INT REFERENCES utilisateur(id_utilisateur)
);

-- Emplacements dans les dépôts
CREATE TABLE emplacement (
    id_emplacement SERIAL PRIMARY KEY,
    code_emplacement VARCHAR(50) NOT NULL,
    id_depot INT NOT NULL REFERENCES depot(id_depot),
    zone VARCHAR(50),
    allee VARCHAR(20),
    etagere VARCHAR(20),
    position VARCHAR(20),
    capacite_max INT,
    UNIQUE (code_emplacement, id_depot)
);

-- Attributs utilisateur pour ABAC
CREATE TABLE attribut_utilisateur (
    id_attribut SERIAL PRIMARY KEY,
    id_utilisateur INT NOT NULL REFERENCES utilisateur(id_utilisateur),
    id_site INT REFERENCES site(id_site),
    id_depot INT REFERENCES depot(id_depot),
    departement VARCHAR(50),
    plafond_validation NUMERIC(15,2) DEFAULT 0,
    plafond_remise NUMERIC(5,2) DEFAULT 5,
    date_debut DATE DEFAULT CURRENT_DATE,
    date_fin DATE,
    CONSTRAINT unique_user_scope UNIQUE (id_utilisateur, id_site, id_depot, departement)
);

-- Délégations temporaires
CREATE TABLE delegation_acces (
    id_delegation SERIAL PRIMARY KEY,
    utilisateur_source INT NOT NULL REFERENCES utilisateur(id_utilisateur),
    utilisateur_cible INT NOT NULL REFERENCES utilisateur(id_utilisateur),
    date_debut TIMESTAMP NOT NULL,
    date_fin TIMESTAMP NOT NULL,
    justification TEXT,
    statut VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT check_not_self CHECK (utilisateur_source != utilisateur_cible),
    CONSTRAINT check_dates CHECK (date_fin > date_debut)
);

-- =====================================================
-- 3. MODULE ACHATS COMPLET
-- =====================================================

-- Demande d'achat avec workflow multi-niveaux
CREATE TABLE demande_achat (
    id_demande SERIAL PRIMARY KEY,
    numero_da VARCHAR(50) UNIQUE NOT NULL,
    date_demande DATE DEFAULT CURRENT_DATE,
    id_demandeur INT NOT NULL REFERENCES utilisateur(id_utilisateur),
    motif TEXT,
    urgence VARCHAR(20) DEFAULT 'NORMALE' CHECK (urgence IN ('NORMALE', 'URGENT', 'CRITIQUE')),
    statut VARCHAR(20) DEFAULT 'BROUILLON' CHECK (statut IN ('BROUILLON', 'EN_ATTENTE', 'VALIDE_N1', 'VALIDE_N2', 'VALIDE_N3', 'REJETE', 'TRANSFORMEE')),
    id_valideur_n1 INT REFERENCES utilisateur(id_utilisateur),
    date_validation_n1 TIMESTAMP,
    id_valideur_n2 INT REFERENCES utilisateur(id_utilisateur),
    date_validation_n2 TIMESTAMP,
    id_valideur_n3 INT REFERENCES utilisateur(id_utilisateur),
    date_validation_n3 TIMESTAMP,
    montant_total NUMERIC(15,2) DEFAULT 0,
    CONSTRAINT fk_demandeur FOREIGN KEY (id_demandeur) REFERENCES utilisateur(id_utilisateur)
);

CREATE TABLE ligne_demande_achat (
    id_ligne SERIAL PRIMARY KEY,
    id_demande INT NOT NULL REFERENCES demande_achat(id_demande),
    id_article INT NOT NULL REFERENCES article(id_article),
    quantite INT NOT NULL,
    quantite_restante INT NOT NULL, -- Pour suivi des quantités non encore commandées
    date_besoin DATE,
    commentaire TEXT,
    CONSTRAINT check_quantite_positive CHECK (quantite > 0)
);

-- Pro-forma/Devis fournisseur
CREATE TABLE devis_fournisseur (
    id_devis SERIAL PRIMARY KEY,
    numero_devis VARCHAR(100) UNIQUE NOT NULL,
    id_demande INT REFERENCES demande_achat(id_demande),
    id_fournisseur INT NOT NULL REFERENCES fournisseur(id_fournisseur),
    date_devis DATE DEFAULT CURRENT_DATE,
    validite_jours INT DEFAULT 30,
    montant_ht NUMERIC(15,2) NOT NULL,
    montant_ttc NUMERIC(15,2) NOT NULL,
    statut VARCHAR(20) DEFAULT 'EN_COURS' CHECK (statut IN ('EN_COURS', 'ACCEPTE', 'REJETE', 'EXPIRÉ')),
    conditions TEXT
);

CREATE TABLE ligne_devis_fournisseur (
    id_ligne SERIAL PRIMARY KEY,
    id_devis INT NOT NULL REFERENCES devis_fournisseur(id_devis),
    id_article INT NOT NULL REFERENCES article(id_article),
    quantite INT NOT NULL,
    prix_unitaire NUMERIC(15,2) NOT NULL,
    remise_pct NUMERIC(5,2) DEFAULT 0,
    delai_livraison INT
);

-- Bon de commande avec validation multi-niveaux
CREATE TABLE bon_commande (
    id_commande SERIAL PRIMARY KEY,
    numero_bc VARCHAR(50) UNIQUE NOT NULL,
    id_demande INT REFERENCES demande_achat(id_demande),
    id_devis INT REFERENCES devis_fournisseur(id_devis),
    id_fournisseur INT NOT NULL REFERENCES fournisseur(id_fournisseur),
    date_commande DATE DEFAULT CURRENT_DATE,
    montant_ht NUMERIC(15,2) NOT NULL,
    montant_tva NUMERIC(15,2) NOT NULL,
    montant_ttc NUMERIC(15,2) NOT NULL,
    statut VARCHAR(20) DEFAULT 'BROUILLON' CHECK (statut IN ('BROUILLON', 'EN_ATTENTE', 'VALIDE_FINANCE', 'VALIDE_RESPONSABLE', 'VALIDE_SIGNATAIRE', 'EN_COURS', 'RECEPTIONNE', 'ANNULE')),
    id_acheteur INT REFERENCES utilisateur(id_utilisateur),
    id_valideur_finance INT REFERENCES utilisateur(id_utilisateur),
    date_validation_finance TIMESTAMP,
    id_valideur_responsable INT REFERENCES utilisateur(id_utilisateur),
    date_validation_responsable TIMESTAMP,
    id_valideur_signataire INT REFERENCES utilisateur(id_utilisateur),
    date_validation_signataire TIMESTAMP,
    conditions_livraison TEXT,
    date_livraison_prevue DATE
);

CREATE TABLE ligne_bon_commande (
    id_ligne SERIAL PRIMARY KEY,
    id_commande INT NOT NULL REFERENCES bon_commande(id_commande),
    id_article INT NOT NULL REFERENCES article(id_article),
    quantite INT NOT NULL,
    prix_unitaire NUMERIC(15,2) NOT NULL,
    remise_pct NUMERIC(5,2) DEFAULT 0,
    id_taxe INT REFERENCES taxe(id_taxe),
    date_livraison_prevue DATE
);

-- Réception avec contrôle qualité
CREATE TABLE reception (
    id_reception SERIAL PRIMARY KEY,
    numero_reception VARCHAR(50) UNIQUE NOT NULL,
    id_commande INT NOT NULL REFERENCES bon_commande(id_commande),
    id_depot INT NOT NULL REFERENCES depot(id_depot),
    date_reception DATE DEFAULT CURRENT_DATE,
    id_receptionnaire INT NOT NULL REFERENCES utilisateur(id_utilisateur),
    statut_reception VARCHAR(20) DEFAULT 'EN_COURS' CHECK (statut_reception IN ('EN_COURS', 'PARTIEL', 'COMPLET', 'NON_CONFORME')),
    commentaire TEXT
);

CREATE TABLE ligne_reception (
    id_ligne SERIAL PRIMARY KEY,
    id_reception INT NOT NULL REFERENCES reception(id_reception),
    id_article INT NOT NULL REFERENCES article(id_article),
    quantite_commandee INT NOT NULL,
    quantite_recue INT NOT NULL,
    quantite_conforme INT NOT NULL,
    quantite_non_conforme INT DEFAULT 0,
    motif_non_conformite TEXT,
    CONSTRAINT check_quantites CHECK (quantite_recue = quantite_conforme + quantite_non_conforme)
);

-- Facture fournisseur pour 3-way match
CREATE TABLE facture_fournisseur (
    id_facture SERIAL PRIMARY KEY,
    numero_facture VARCHAR(100) NOT NULL,
    id_commande INT REFERENCES bon_commande(id_commande),
    id_reception INT REFERENCES reception(id_reception),
    id_fournisseur INT NOT NULL REFERENCES fournisseur(id_fournisseur),
    date_facture DATE NOT NULL,
    montant_ht NUMERIC(15,2) NOT NULL,
    montant_tva NUMERIC(15,2) NOT NULL,
    montant_ttc NUMERIC(15,2) NOT NULL,
    statut VARCHAR(20) DEFAULT 'A_PAYER' CHECK (statut IN ('A_PAYER', 'VERIFIEE', 'CONTESTEE', 'PAYEE', 'ANNULEE')),
    match_statut VARCHAR(20) DEFAULT 'EN_ATTENTE' CHECK (match_statut IN ('EN_ATTENTE', 'OK', 'ECART', 'BLOQUE')),
    id_verificateur INT REFERENCES utilisateur(id_utilisateur),
    date_verification TIMESTAMP,
    date_echeance DATE
);

-- Paiement fournisseur
CREATE TABLE paiement_fournisseur (
    id_paiement SERIAL PRIMARY KEY,
    id_facture INT NOT NULL REFERENCES facture_fournisseur(id_facture),
    montant NUMERIC(15,2) NOT NULL,
    mode_paiement VARCHAR(30) CHECK (mode_paiement IN ('VIREMENT', 'CHEQUE', 'CARTE', 'EFFET')),
    date_paiement DATE DEFAULT CURRENT_DATE,
    reference VARCHAR(100),
    id_comptable INT REFERENCES utilisateur(id_utilisateur),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 4. MODULE VENTES COMPLET
-- =====================================================

-- Devis client
CREATE TABLE devis_client (
    id_devis SERIAL PRIMARY KEY,
    numero_devis VARCHAR(50) UNIQUE NOT NULL,
    id_client INT NOT NULL REFERENCES client(id_client),
    id_commercial INT NOT NULL REFERENCES utilisateur(id_utilisateur),
    date_devis DATE DEFAULT CURRENT_DATE,
    validite_jours INT DEFAULT 30,
    montant_ht NUMERIC(15,2) DEFAULT 0,
    montant_tva NUMERIC(15,2) DEFAULT 0,
    montant_ttc NUMERIC(15,2) DEFAULT 0,
    statut VARCHAR(20) DEFAULT 'BROUILLON' CHECK (statut IN ('BROUILLON', 'ENVOYE', 'ACCEPTE', 'REJETE', 'TRANSFORME', 'EXPIRÉ')),
    conditions_commerciales TEXT
);

CREATE TABLE ligne_devis_client (
    id_ligne SERIAL PRIMARY KEY,
    id_devis INT NOT NULL REFERENCES devis_client(id_devis),
    id_article INT NOT NULL REFERENCES article(id_article),
    quantite INT NOT NULL,
    prix_unitaire NUMERIC(15,2) NOT NULL,
    remise_pct NUMERIC(5,2) DEFAULT 0,
    id_taxe INT REFERENCES taxe(id_taxe)
);

-- Commande client avec réservation stock
CREATE TABLE commande_client (
    id_commande SERIAL PRIMARY KEY,
    numero_commande VARCHAR(50) UNIQUE NOT NULL,
    id_devis INT REFERENCES devis_client(id_devis),
    id_client INT NOT NULL REFERENCES client(id_client),
    id_commercial INT NOT NULL REFERENCES utilisateur(id_utilisateur),
    date_commande DATE DEFAULT CURRENT_DATE,
    montant_ht NUMERIC(15,2) NOT NULL,
    montant_tva NUMERIC(15,2) NOT NULL,
    montant_ttc NUMERIC(15,2) NOT NULL,
    statut VARCHAR(20) DEFAULT 'BROUILLON' CHECK (statut IN ('BROUILLON', 'CONFIRMEE', 'EN_PREPARATION', 'PARTIELLEMENT_LIVREE', 'LIVREE', 'FACTUREE', 'ANNULEE')),
    statut_stock VARCHAR(20) DEFAULT 'NON_RESERVE' CHECK (statut_stock IN ('NON_RESERVE', 'PARTIEL', 'COMPLET', 'RUPTURE')),
    remise_pct NUMERIC(5,2) DEFAULT 0,
    validation_remise BOOLEAN DEFAULT FALSE,
    id_valideur_remise INT REFERENCES utilisateur(id_utilisateur),
    date_validation_remise TIMESTAMP,
    id_condition_paiement INT REFERENCES condition_paiement(id_condition),
    date_livraison_souhaitee DATE
);

CREATE TABLE ligne_commande_client (
    id_ligne SERIAL PRIMARY KEY,
    id_commande INT NOT NULL REFERENCES commande_client(id_commande),
    id_article INT NOT NULL REFERENCES article(id_article),
    quantite INT NOT NULL,
    quantite_livree INT DEFAULT 0,
    quantite_facturee INT DEFAULT 0,
    prix_unitaire NUMERIC(15,2) NOT NULL,
    remise_pct NUMERIC(5,2) DEFAULT 0,
    id_taxe INT REFERENCES taxe(id_taxe),
    CONSTRAINT check_quantites_vente CHECK (quantite_livree <= quantite AND quantite_facturee <= quantite_livree)
);

-- Livraison client
CREATE TABLE livraison (
    id_livraison SERIAL PRIMARY KEY,
    numero_bl VARCHAR(50) UNIQUE NOT NULL,
    id_commande INT NOT NULL REFERENCES commande_client(id_commande),
    date_livraison DATE DEFAULT CURRENT_DATE,
    id_preparateur INT REFERENCES utilisateur(id_utilisateur),
    id_livreur INT REFERENCES utilisateur(id_utilisateur),
    id_depot INT REFERENCES depot(id_depot),
    statut VARCHAR(20) DEFAULT 'EN_PREPARATION' CHECK (statut IN ('EN_PREPARATION', 'PRETE', 'EN_COURS', 'LIVREE', 'PARTIELLE', 'ANNULEE')),
    commentaire TEXT
);

CREATE TABLE ligne_livraison (
    id_ligne SERIAL PRIMARY KEY,
    id_livraison INT NOT NULL REFERENCES livraison(id_livraison),
    id_article INT NOT NULL REFERENCES article(id_article),
    quantite INT NOT NULL,
    id_lot INT, -- Référence à la table lot (voir section stock)
    id_emplacement INT REFERENCES emplacement(id_emplacement)
);

-- Facture client
CREATE TABLE facture_client (
    id_facture SERIAL PRIMARY KEY,
    numero_facture VARCHAR(50) UNIQUE NOT NULL,
    id_commande INT REFERENCES commande_client(id_commande),
    id_livraison INT REFERENCES livraison(id_livraison),
    id_client INT NOT NULL REFERENCES client(id_client),
    date_facture DATE DEFAULT CURRENT_DATE,
    montant_ht NUMERIC(15,2) NOT NULL,
    montant_tva NUMERIC(15,2) NOT NULL,
    montant_ttc NUMERIC(15,2) NOT NULL,
    statut VARCHAR(20) DEFAULT 'EMISE' CHECK (statut IN ('EMISE', 'ENCAISSEE', 'ENCAISSEE_PARTIEL', 'IMPAYEE', 'ANNULEE')),
    id_comptable INT REFERENCES utilisateur(id_utilisateur),
    date_echeance DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ligne_facture_client (
    id_ligne SERIAL PRIMARY KEY,
    id_facture INT NOT NULL REFERENCES facture_client(id_facture),
    id_article INT NOT NULL REFERENCES article(id_article),
    quantite INT NOT NULL,
    prix_unitaire NUMERIC(15,2) NOT NULL,
    remise_pct NUMERIC(5,2) DEFAULT 0,
    id_taxe INT REFERENCES taxe(id_taxe)
);

-- Encaissement client
CREATE TABLE encaissement_client (
    id_encaissement SERIAL PRIMARY KEY,
    id_facture INT NOT NULL REFERENCES facture_client(id_facture),
    montant NUMERIC(15,2) NOT NULL,
    mode_paiement VARCHAR(30) CHECK (mode_paiement IN ('VIREMENT', 'CHEQUE', 'CARTE', 'ESPECES')),
    date_encaissement DATE DEFAULT CURRENT_DATE,
    reference VARCHAR(100),
    id_caissier INT REFERENCES utilisateur(id_utilisateur),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Avoirs/Retours clients
CREATE TABLE retour_client (
    id_retour SERIAL PRIMARY KEY,
    numero_retour VARCHAR(50) UNIQUE NOT NULL,
    id_facture INT REFERENCES facture_client(id_facture),
    id_client INT NOT NULL REFERENCES client(id_client),
    date_retour DATE DEFAULT CURRENT_DATE,
    motif VARCHAR(100),
    statut VARCHAR(20) DEFAULT 'EN_COURS' CHECK (statut IN ('EN_COURS', 'VALIDE', 'REFUSE', 'REMBOURSE')),
    id_valideur INT REFERENCES utilisateur(id_utilisateur),
    date_validation TIMESTAMP
);

CREATE TABLE ligne_retour_client (
    id_ligne SERIAL PRIMARY KEY,
    id_retour INT NOT NULL REFERENCES retour_client(id_retour),
    id_article INT NOT NULL REFERENCES article(id_article),
    quantite INT NOT NULL,
    motif_detail TEXT,
    statut_article VARCHAR(20) DEFAULT 'RETOURNE' CHECK (statut_article IN ('RETOURNE', 'REPARABLE', 'INUTILISABLE'))
);

-- =====================================================
-- 5. MODULE STOCK AVANCÉ
-- =====================================================

-- Lots et séries
CREATE TABLE lot (
    id_lot SERIAL PRIMARY KEY,
    numero_lot VARCHAR(100) UNIQUE NOT NULL,
    id_article INT NOT NULL REFERENCES article(id_article),
    id_fournisseur INT REFERENCES fournisseur(id_fournisseur),
    id_reception INT REFERENCES reception(id_reception),
    date_fabrication DATE,
    date_peremption DATE,
    date_dluo DATE,
    statut VARCHAR(20) DEFAULT 'DISPONIBLE' CHECK (statut IN ('DISPONIBLE', 'RESERVE', 'BLOQUE', 'EXPIRÉ', 'CONSOMME', 'DETRUIT')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Stock par lot et emplacement
CREATE TABLE stock_lot (
    id_stock_lot SERIAL PRIMARY KEY,
    id_lot INT NOT NULL REFERENCES lot(id_lot),
    id_emplacement INT NOT NULL REFERENCES emplacement(id_emplacement),
    quantite INT DEFAULT 0,
    quantite_reservee INT DEFAULT 0,
    quantite_disponible INT GENERATED ALWAYS AS (quantite - quantite_reservee) STORED,
    date_entree TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_sortie TIMESTAMP,
    CONSTRAINT check_quantites_stock CHECK (quantite >= 0 AND quantite_reservee >= 0 AND quantite_reservee <= quantite)
);

-- Réservation de stock
CREATE TABLE reservation_stock (
    id_reservation SERIAL PRIMARY KEY,
    id_commande_client INT REFERENCES commande_client(id_commande),
    id_lot INT NOT NULL REFERENCES lot(id_lot),
    id_emplacement INT REFERENCES emplacement(id_emplacement),
    quantite INT NOT NULL,
    date_reservation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_expiration TIMESTAMP,
    statut VARCHAR(20) DEFAULT 'ACTIVE' CHECK (statut IN ('ACTIVE', 'CONSOMMEE', 'ANNULEE', 'EXPIREE')),
    CONSTRAINT fk_reservation_commande FOREIGN KEY (id_commande_client) REFERENCES commande_client(id_commande)
);

-- Transferts entre dépôts
CREATE TABLE transfert_stock (
    id_transfert SERIAL PRIMARY KEY,
    numero_transfert VARCHAR(50) UNIQUE NOT NULL,
    id_depot_source INT NOT NULL REFERENCES depot(id_depot),
    id_depot_destination INT NOT NULL REFERENCES depot(id_depot),
    date_demande DATE DEFAULT CURRENT_DATE,
    date_realisation DATE,
    statut VARCHAR(20) DEFAULT 'EN_ATTENTE' CHECK (statut IN ('EN_ATTENTE', 'EN_PREPARATION', 'EN_TRANSIT', 'RECU', 'ANNULE')),
    id_demandeur INT REFERENCES utilisateur(id_utilisateur),
    id_preparateur INT REFERENCES utilisateur(id_utilisateur),
    id_receptionnaire INT REFERENCES utilisateur(id_utilisateur)
);

CREATE TABLE ligne_transfert_stock (
    id_ligne SERIAL PRIMARY KEY,
    id_transfert INT NOT NULL REFERENCES transfert_stock(id_transfert),
    id_article INT NOT NULL REFERENCES article(id_article),
    id_lot INT REFERENCES lot(id_lot),
    quantite INT NOT NULL,
    id_emplacement_source INT REFERENCES emplacement(id_emplacement),
    id_emplacement_destination INT REFERENCES emplacement(id_emplacement)
);

-- Mouvements de stock complets
CREATE TABLE mouvement_stock (
    id_mouvement SERIAL PRIMARY KEY,
    id_article INT NOT NULL REFERENCES article(id_article),
    id_lot INT REFERENCES lot(id_lot),
    id_depot INT NOT NULL REFERENCES depot(id_depot),
    id_emplacement INT REFERENCES emplacement(id_emplacement),
    type_mouvement VARCHAR(30) NOT NULL CHECK (type_mouvement IN ('ENTREE', 'SORTIE', 'AJUSTEMENT', 'TRANSFERT_ENTREE', 'TRANSFERT_SORTIE', 'RESERVATION', 'DERESERVATION')),
    quantite INT NOT NULL,
    quantite_avant INT NOT NULL,
    quantite_apres INT NOT NULL,
    date_mouvement TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_utilisateur INT NOT NULL REFERENCES utilisateur(id_utilisateur),
    reference_document VARCHAR(100),
    id_document INT,
    commentaire TEXT
);

-- Historique des coûts pour FIFO/CUMP
CREATE TABLE cout_historique (
    id_cout SERIAL PRIMARY KEY,
    id_article INT NOT NULL REFERENCES article(id_article),
    id_lot INT REFERENCES lot(id_lot),
    cout_unitaire NUMERIC(15,2) NOT NULL,
    quantite_initiale INT NOT NULL,
    quantite_restante INT NOT NULL,
    date_entree DATE NOT NULL,
    source VARCHAR(50) NOT NULL, -- 'ACHAT', 'AJUSTEMENT', 'INVENTAIRE'
    id_document_source INT,
    CONSTRAINT check_quantites_cout CHECK (quantite_restante >= 0 AND quantite_restante <= quantite_initiale)
);

-- =====================================================
-- 6. MODULE INVENTAIRE COMPLET
-- =====================================================

-- Planification des inventaires
CREATE TABLE plan_inventaire (
    id_plan SERIAL PRIMARY KEY,
    type_inventaire VARCHAR(20) NOT NULL CHECK (type_inventaire IN ('TOURNANT', 'ANNUEL', 'CYCLIQUE', 'SURPRISE')),
    id_depot INT NOT NULL REFERENCES depot(id_depot),
    date_planifiee DATE NOT NULL,
    frequence_jours INT,
    statut VARCHAR(20) DEFAULT 'PLANIFIE' CHECK (statut IN ('PLANIFIE', 'EN_COURS', 'TERMINE', 'ANNULE')),
    id_planificateur INT REFERENCES utilisateur(id_utilisateur)
);

-- Inventaires
CREATE TABLE inventaire (
    id_inventaire SERIAL PRIMARY KEY,
    numero_inventaire VARCHAR(50) UNIQUE NOT NULL,
    type_inventaire VARCHAR(20) NOT NULL CHECK (type_inventaire IN ('TOURNANT', 'ANNUEL', 'CYCLIQUE', 'SURPRISE')),
    id_depot INT NOT NULL REFERENCES depot(id_depot),
    date_inventaire DATE DEFAULT CURRENT_DATE,
    methode VARCHAR(20) DEFAULT 'COMPTAGE' CHECK (methode IN ('COMPTAGE', 'ECHANTILLONNAGE', 'VALEUR')),
    statut VARCHAR(20) DEFAULT 'EN_COURS' CHECK (statut IN ('EN_COURS', 'COMPTAGE_TERMINE', 'VALIDATION_EN_COURS', 'VALIDE', 'ANNULE')),
    id_planificateur INT REFERENCES utilisateur(id_utilisateur),
    id_validateur INT REFERENCES utilisateur(id_utilisateur),
    date_validation TIMESTAMP
);

-- Lignes d'inventaire avec validation
CREATE TABLE ligne_inventaire (
    id_ligne SERIAL PRIMARY KEY,
    id_inventaire INT NOT NULL REFERENCES inventaire(id_inventaire),
    id_article INT NOT NULL REFERENCES article(id_article),
    id_lot INT REFERENCES lot(id_lot),
    id_emplacement INT REFERENCES emplacement(id_emplacement),
    quantite_theorique INT NOT NULL,
    quantite_physique INT NOT NULL,
    ecart_quantite INT GENERATED ALWAYS AS (quantite_physique - quantite_theorique) STORED,
    valeur_theorique NUMERIC(15,2),
    valeur_physique NUMERIC(15,2),
    ecart_valeur NUMERIC(15,2),
    id_compteur INT NOT NULL REFERENCES utilisateur(id_utilisateur),
    date_comptage TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    commentaire TEXT
);

-- Ajustements de stock post-inventaire
CREATE TABLE ajustement_stock (
    id_ajustement SERIAL PRIMARY KEY,
    numero_ajustement VARCHAR(50) UNIQUE NOT NULL,
    id_inventaire INT REFERENCES inventaire(id_inventaire),
    type_ajustement VARCHAR(20) NOT NULL CHECK (type_ajustement IN ('INVENTAIRE', 'CASSE', 'OBSOLESCENCE', 'DON', 'VOL')),
    date_ajustement DATE DEFAULT CURRENT_DATE,
    montant_total NUMERIC(15,2) NOT NULL,
    statut VARCHAR(20) DEFAULT 'EN_ATTENTE' CHECK (statut IN ('EN_ATTENTE', 'VALIDE_N1', 'VALIDE_N2', 'VALIDE', 'REJETE')),
    motif TEXT,
    id_demandeur INT REFERENCES utilisateur(id_utilisateur),
    id_valideur_n1 INT REFERENCES utilisateur(id_utilisateur),
    id_valideur_n2 INT REFERENCES utilisateur(id_utilisateur),
    id_valideur_final INT REFERENCES utilisateur(id_utilisateur)
);

CREATE TABLE ligne_ajustement_stock (
    id_ligne SERIAL PRIMARY KEY,
    id_ajustement INT NOT NULL REFERENCES ajustement_stock(id_ajustement),
    id_article INT NOT NULL REFERENCES article(id_article),
    id_lot INT REFERENCES lot(id_lot),
    id_depot INT NOT NULL REFERENCES depot(id_depot),
    quantite_avant INT NOT NULL,
    quantite_ajustement INT NOT NULL,
    quantite_apres INT GENERATED ALWAYS AS (quantite_avant + quantite_ajustement) STORED,
    valeur_ajustement NUMERIC(15,2),
    motif_detail TEXT
);

-- =====================================================
-- 7. KPI & REPORTING
-- =====================================================

-- Définition des KPI
CREATE TABLE kpi_definition (
    code_kpi VARCHAR(50) PRIMARY KEY,
    libelle_kpi VARCHAR(100) NOT NULL,
    description TEXT,
    formule_calcul TEXT,
    unite VARCHAR(20),
    categorie VARCHAR(50), -- 'STOCK', 'ACHATS', 'VENTES', 'FINANCE', 'QUALITE'
    cible NUMERIC(15,4),
    seuil_alerte NUMERIC(15,4),
    frequence_calcul VARCHAR(20) DEFAULT 'QUOTIDIEN'
);

-- Historique des KPI
CREATE TABLE kpi_historique (
    id_kpi_hist SERIAL PRIMARY KEY,
    code_kpi VARCHAR(50) NOT NULL REFERENCES kpi_definition(code_kpi),
    date_mesure DATE NOT NULL,
    periode VARCHAR(10) NOT NULL, -- 'JOUR', 'SEMAINE', 'MOIS', 'TRIMESTRE', 'ANNEE'
    id_site INT REFERENCES site(id_site),
    id_depot INT REFERENCES depot(id_depot),
    id_utilisateur INT REFERENCES utilisateur(id_utilisateur),
    valeur NUMERIC(15,4) NOT NULL,
    valeur_cible NUMERIC(15,4),
    ecart NUMERIC(15,4),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_kpi_jour UNIQUE (code_kpi, date_mesure, periode, id_site, id_depot)
);

-- Rapports pré-définis
CREATE TABLE modele_rapport (
    id_modele SERIAL PRIMARY KEY,
    code_rapport VARCHAR(50) UNIQUE NOT NULL,
    libelle_rapport VARCHAR(100) NOT NULL,
    description TEXT,
    requete_sql TEXT,
    parametres JSONB,
    frequence VARCHAR(20) DEFAULT 'MANUEL',
    public BOOLEAN DEFAULT FALSE
);

-- =====================================================
-- 8. AUDIT & JOURNALISATION
-- =====================================================

-- Journal d'audit complet
CREATE TABLE journal_audit (
    id_audit SERIAL PRIMARY KEY,
    id_utilisateur INT REFERENCES utilisateur(id_utilisateur),
    action_type VARCHAR(50) NOT NULL,
    table_name VARCHAR(50) NOT NULL,
    record_id INT,
    anciennes_valeurs JSONB,
    nouvelles_valeurs JSONB,
    timestamp_action TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ip_address INET,
    user_agent TEXT,
    id_session VARCHAR(100)
);

-- Sessions utilisateurs
CREATE TABLE session_utilisateur (
    id_session VARCHAR(100) PRIMARY KEY,
    id_utilisateur INT NOT NULL REFERENCES utilisateur(id_utilisateur),
    date_debut TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_fin TIMESTAMP,
    ip_address INET,
    user_agent TEXT,
    statut VARCHAR(20) DEFAULT 'ACTIVE'
);

-- =====================================================
-- 9. INTÉGRATION API
-- =====================================================

-- Clés API
CREATE TABLE api_cle (
    id_cle SERIAL PRIMARY KEY,
    cle_api VARCHAR(100) UNIQUE NOT NULL,
    libelle VARCHAR(100) NOT NULL,
    id_utilisateur INT REFERENCES utilisateur(id_utilisateur),
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_expiration TIMESTAMP,
    permissions JSONB,
    actif BOOLEAN DEFAULT TRUE
);

-- Logs d'appels API
CREATE TABLE api_log (
    id_log SERIAL PRIMARY KEY,
    id_cle INT REFERENCES api_cle(id_cle),
    endpoint VARCHAR(200) NOT NULL,
    methode VARCHAR(10) NOT NULL,
    parametres JSONB,
    reponse_code INT,
    duree_ms INT,
    timestamp_appel TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ip_address INET
);

-- Synchronisation RH
CREATE TABLE synchronisation_rh (
    id_sync SERIAL PRIMARY KEY,
    type_sync VARCHAR(50) NOT NULL,
    date_sync TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    nb_enregistrements INT,
    statut VARCHAR(20) DEFAULT 'SUCCES' CHECK (statut IN ('SUCCES', 'ERREUR', 'EN_COURS')),
    details TEXT
);

-- =====================================================
-- VUES MÉTIER COMPLÈTES
-- =====================================================

-- Vue stock détaillé avec alertes
CREATE VIEW v_stock_detaille AS
SELECT 
    a.code as code_article,
    a.designation,
    f.code as famille,
    d.nom_depot,
    e.code_emplacement,
    l.numero_lot,
    l.date_peremption,
    sl.quantite,
    sl.quantite_reservee,
    sl.quantite_disponible,
    a.prix_achat,
    (sl.quantite * a.prix_achat) as valeur_stock,
    CASE 
        WHEN sl.quantite_disponible <= a.seuil_alerte THEN 'ALERTE_RUPTURE'
        WHEN l.date_peremption IS NOT NULL AND l.date_peremption <= CURRENT_DATE + INTERVAL '30 days' THEN 'ALERTE_PEREMPTION'
        ELSE 'OK'
    END as statut_alerte
FROM stock_lot sl
JOIN lot l ON sl.id_lot = l.id_lot
JOIN article a ON l.id_article = a.id_article
JOIN famille_article f ON a.id_famille = f.id_famille
JOIN emplacement e ON sl.id_emplacement = e.id_emplacement
JOIN depot d ON e.id_depot = d.id_depot;

-- Vue KPI Achats
CREATE VIEW v_kpi_achats AS
SELECT 
    date_trunc('month', bc.date_commande) as mois,
    COUNT(DISTINCT bc.id_commande) as nb_commandes,
    SUM(bc.montant_ttc) as montant_total,
    AVG(EXTRACT(DAY FROM r.date_reception - bc.date_commande)) as delai_livraison_moyen,
    COUNT(DISTINCT CASE WHEN r.statut_reception = 'NON_CONFORME' THEN r.id_reception END) as nb_receptions_non_conformes
FROM bon_commande bc
LEFT JOIN reception r ON bc.id_commande = r.id_commande
WHERE bc.statut NOT IN ('BROUILLON', 'ANNULE')
GROUP BY date_trunc('month', bc.date_commande);

-- Vue KPI Ventes
CREATE VIEW v_kpi_ventes AS
SELECT 
    date_trunc('month', cc.date_commande) as mois,
    COUNT(DISTINCT cc.id_commande) as nb_commandes,
    SUM(cc.montant_ttc) as ca_total,
    AVG(cc.remise_pct) as remise_moyenne,
    COUNT(DISTINCT CASE WHEN cc.statut = 'ANNULEE' THEN cc.id_commande END) as nb_annulations,
    SUM(CASE WHEN fc.statut = 'IMPAYEE' THEN fc.montant_ttc ELSE 0 END) as montant_impaye
FROM commande_client cc
LEFT JOIN facture_client fc ON cc.id_commande = fc.id_commande
GROUP BY date_trunc('month', cc.date_commande);

-- Vue rotation stock
CREATE VIEW v_rotation_stock AS
SELECT 
    a.code,
    a.designation,
    d.nom_depot,
    COALESCE(SUM(sl.quantite), 0) as stock_actuel,
    COALESCE(SUM(sl.quantite * a.prix_achat), 0) as valeur_stock,
    COALESCE(SUM(CASE WHEN m.type_mouvement = 'SORTIE' THEN m.quantite ELSE 0 END), 0) as sorties_mois,
    CASE 
        WHEN COALESCE(SUM(sl.quantite), 0) > 0 
        THEN (COALESCE(SUM(CASE WHEN m.type_mouvement = 'SORTIE' THEN m.quantite ELSE 0 END), 0) * 30) / NULLIF(SUM(sl.quantite), 0)
        ELSE 0
    END as rotation_jours
FROM article a
LEFT JOIN stock_lot sl ON a.id_article = (SELECT id_article FROM lot WHERE id_lot = sl.id_lot)
LEFT JOIN depot d ON (SELECT id_depot FROM emplacement WHERE id_emplacement = sl.id_emplacement) = d.id_depot
LEFT JOIN mouvement_stock m ON a.id_article = m.id_article 
    AND m.date_mouvement >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY a.id_article, a.code, a.designation, d.id_depot, d.nom_depot;

-- =====================================================
-- INDEX AVANCÉS POUR PERFORMANCE
-- =====================================================

-- Index pour recherche rapide
CREATE INDEX idx_article_code ON article(code);
CREATE INDEX idx_client_nom ON client(nom);
CREATE INDEX idx_fournisseur_nom ON fournisseur(nom);

-- Index pour les workflows
CREATE INDEX idx_demande_achat_statut ON demande_achat(statut);
CREATE INDEX idx_bon_commande_statut ON bon_commande(statut);
CREATE INDEX idx_commande_client_statut ON commande_client(statut);
CREATE INDEX idx_facture_client_statut ON facture_client(statut);

-- Index pour les KPI et reporting
CREATE INDEX idx_mouvement_date ON mouvement_stock(date_mouvement);
CREATE INDEX idx_lot_date_peremption ON lot(date_peremption) WHERE statut = 'DISPONIBLE';
CREATE INDEX idx_kpi_date_mesure ON kpi_historique(date_mesure, code_kpi);

-- Index pour la gestion des lots
CREATE INDEX idx_stock_lot_disponible ON stock_lot(id_lot, quantite_disponible) WHERE quantite_disponible > 0;
CREATE INDEX idx_reservation_expiration ON reservation_stock(date_expiration) WHERE statut = 'ACTIVE';

-- =====================================================
-- FONCTIONS ET TRIGGERS
-- =====================================================

-- Fonction pour mettre à jour automatiquement le stock
CREATE OR REPLACE FUNCTION maj_stock_auto()
RETURNS TRIGGER AS $$
BEGIN
    -- Logique de mise à jour du stock lors des réceptions, livraisons, etc.
    -- Cette fonction serait implémentée selon les besoins spécifiques
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger pour journalisation automatique
CREATE OR REPLACE FUNCTION journaliser_modification()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO journal_audit (id_utilisateur, action_type, table_name, record_id, anciennes_valeurs, nouvelles_valeurs)
    VALUES (
        COALESCE(NEW.id_utilisateur_modif, OLD.id_utilisateur_modif, 1),
        TG_OP,
        TG_TABLE_NAME,
        COALESCE(NEW.id, OLD.id),
        CASE WHEN TG_OP IN ('UPDATE', 'DELETE') THEN row_to_json(OLD) ELSE NULL END,
        CASE WHEN TG_OP IN ('INSERT', 'UPDATE') THEN row_to_json(NEW) ELSE NULL END
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Appliquer le trigger aux tables principales
CREATE TRIGGER trig_audit_article AFTER INSERT OR UPDATE OR DELETE ON article
FOR EACH ROW EXECUTE FUNCTION journaliser_modification();

CREATE TRIGGER trig_audit_bon_commande AFTER INSERT OR UPDATE OR DELETE ON bon_commande
FOR EACH ROW EXECUTE FUNCTION journaliser_modification();

CREATE TRIGGER trig_audit_facture AFTER INSERT OR UPDATE OR DELETE ON facture_client
FOR EACH ROW EXECUTE FUNCTION journaliser_modification();

-- =====================================================
-- DONNÉES DE BASE
-- =====================================================

-- Insertions des données de référence
INSERT INTO unite_mesure (code, libelle) VALUES 
('UNITE', 'Unité'),
('KG', 'Kilogramme'),
('M', 'Mètre'),
('L', 'Litre'),
('M2', 'Mètre carré'),
('M3', 'Mètre cube');

INSERT INTO taxe (code, taux, libelle) VALUES
('TVA20', 20.00, 'TVA 20%'),
('TVA10', 10.00, 'TVA 10%'),
('TVA5', 5.00, 'TVA 5.5%'),
('EXPORT', 0.00, 'Export hors taxes');

INSERT INTO condition_paiement (code, libelle, nombre_jours, escompte) VALUES
('COMPTANT', 'Comptant', 0, 0),
('30J', '30 jours net', 30, 0),
('30J2', '30 jours net, 2% escompte 10 jours', 30, 2),
('60J', '60 jours net', 60, 0);

INSERT INTO famille_article (code, libelle, tracabilite_lot, methode_valorisation) VALUES
('INFORMATIQUE', 'Informatique', FALSE, 'CUMP'),
('BUREAU', 'Fournitures bureau', FALSE, 'CUMP'),
('ALIMENTAIRE', 'Produits alimentaires', TRUE, 'FIFO'),
('PHARMA', 'Produits pharmaceutiques', TRUE, 'FEFO');

-- Rôles et permissions de base
INSERT INTO role (code_role, libelle_role, niveau_hierarchie) VALUES
('ADMIN', 'Administrateur système', 3),
('DIRECTEUR', 'Directeur', 3),
('RESP_ACHATS', 'Responsable Achats', 2),
('RESP_VENTES', 'Responsable Ventes', 2),
('RESP_STOCK', 'Responsable Stock', 2),
('RESP_FINANCE', 'Responsable Finance', 2),
('ACHETEUR', 'Acheteur', 1),
('COMMERCIAL', 'Commercial', 1),
('MAGASINIER', 'Magasinier', 0),
('COMPTABLE', 'Comptable', 1),
('CONTROLEUR', 'Contrôleur de gestion', 1);

-- =====================================================
-- COMMENTAIRES
-- =====================================================

COMMENT ON DATABASE vente_tovo IS 'Système complet de gestion Achats/Ventes/Stock pour grande entreprise';
COMMENT ON TABLE demande_achat IS 'Workflow DA avec validation multi-niveaux (N1, N2, N3)';
COMMENT ON TABLE bon_commande IS 'BC avec 3 niveaux de validation: Finance, Responsable, Signataire';
COMMENT ON TABLE facture_fournisseur IS 'Facture fournisseur avec contrôle 3-way match (BC/Reception/Facture)';
COMMENT ON TABLE lot IS 'Gestion des lots/séries avec traçabilité et dates de péremption';
COMMENT ON TABLE reservation_stock IS 'Réservation de stock pour les commandes clients';
COMMENT ON TABLE kpi_definition IS 'Définition des indicateurs de performance par rôle/département';
COMMENT ON TABLE journal_audit IS 'Journal complet pour traçabilité et conformité RGPD';
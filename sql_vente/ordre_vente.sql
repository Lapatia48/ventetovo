-- 1. Tables indépendantes
CREATE TABLE client (...);
CREATE TABLE devis (...);
CREATE TABLE ligne_devis (...);

-- 2. Tables dépendantes de devis
CREATE TABLE commande_client (...);
CREATE TABLE ligne_commande_client (...);

-- 3. Tables dépendantes de commande
CREATE TABLE livraison_client (...);
CREATE TABLE ligne_livraison_client (...);

-- 4. Tables dépendantes de livraison
CREATE TABLE facture_client (...);
CREATE TABLE ligne_facture_client (...);

-- 5. Tables de paiement
CREATE TABLE reglement_client (...);
CREATE TABLE facture_reglement (...);
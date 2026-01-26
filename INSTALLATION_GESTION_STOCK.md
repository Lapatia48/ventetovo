# SQL d'Insertion - Gestion de Stock

## 🗄️ Ordre d'Exécution des Scripts SQL

### 1. Structure de Base (si pas déjà fait)
```bash
# Tables principales achat/vente existantes
psql -U postgres -d lapatia < sql/lapatia_Achat.sql
```

### 2. Module Gestion de Stock
```bash
# Nouveau module de gestion avancée du stock
psql -U postgres -d lapatia < sql/lapatia_gestion_stock.sql
```

## 📋 Tables Créées par lapatia_gestion_stock.sql

### Tables de Configuration et Référence

1. **Type_Mouvement_Stock** (9 types)
   - RECEP_FOURN, RET_CLIENT, AJUST_PLUS, PRODUCTION
   - LIV_CLIENT, RET_FOURN, AJUST_MOINS, CASSE, UTILISATION

### Tables Principales

2. **Lot**
   - Gestion par lots avec numéros uniques
   - DLC/DLUO et dates de fabrication
   - Suivi quantités et statuts

3. **Mouvement_Stock**
   - Traçabilité complète de tous les mouvements
   - Numérotation automatique
   - Liens vers documents sources

4. **Config_Valorisation_Article**
   - Configuration FIFO/CMUP par article
   - Gestion des lots et péremption

5. **Reservation_Stock**
   - Réservations pour commandes clients
   - Gestion statuts et expiration

6. **Inventaire** et **Inventaire_Detail**
   - Inventaires physiques périodiques
   - Écarts et ajustements

7. **Cloture_Stock_Mensuelle**
   - Clôture comptable mensuelle
   - Verrouillage des modifications

### Vues de Reporting

8. **V_Etat_Stock_Temps_Reel**
   - Stock disponible, réservé, valeur
   - Indicateurs CMUP et alertes

9. **V_Mouvements_Stock_Synthese**
   - Synthèse des mouvements
   - Types et valorisation

10. **V_Lots_Actifs**
    - Lots actifs avec alertes péremption
    - Jours avant expiration

11. **V_Valorisation_Stock**
    - Valorisation par méthode (FIFO/CMUP)
    - Valeurs et quantités

12. **V_CA_Par_Article**
    - Chiffre d'affaires par article
    - Quantités vendues et marges

## ✅ Vérification de l'Installation

```sql
-- Vérifier que toutes les tables sont créées
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_name LIKE '%stock%'
ORDER BY table_name;

-- Résultat attendu:
-- cloture_stock_mensuelle
-- config_valorisation_article
-- inventaire
-- inventaire_detail
-- lot
-- mouvement_stock
-- reservation_stock
-- type_mouvement_stock
-- v_ca_par_article
-- v_etat_stock_temps_reel
-- v_lots_actifs
-- v_mouvements_stock_synthese
-- v_valorisation_stock

-- Vérifier que les types de mouvement sont insérés
SELECT * FROM Type_Mouvement_Stock ORDER BY id_type_mouvement;

-- Résultat attendu: 9 lignes
```

## 🔧 Configuration Initiale Recommandée

### 1. Configurer les Articles pour FIFO ou CMUP

```sql
-- Exemple: Configurer un article en FIFO avec gestion de lot et DLC
INSERT INTO Config_Valorisation_Article (
    id_article, 
    methode_valorisation, 
    gestion_lot, 
    type_peremption, 
    delai_alerte_peremption
) VALUES (
    1,          -- ID de l'article (à adapter)
    'FIFO',     -- ou 'CMUP'
    true,       -- Gestion par lot
    'DLC',      -- ou 'DLUO' ou NULL
    30          -- Alerte 30 jours avant péremption
);

-- Pour les articles non périssables en CMUP
INSERT INTO Config_Valorisation_Article (
    id_article, 
    methode_valorisation, 
    gestion_lot
) VALUES (
    2,          -- ID de l'article
    'CMUP',     
    false       -- Pas de gestion par lot
);
```

### 2. Définir les Stocks Minimums

```sql
-- Mettre à jour les stocks minimums
UPDATE Stock 
SET stock_minimum = 10 
WHERE id_article = 1;

UPDATE Stock 
SET stock_minimum = 50 
WHERE id_article = 2;
```

## 📊 Exemples de Requêtes Utiles

### Stock Temps Réel avec Alertes

```sql
-- Voir l'état complet du stock avec alertes
SELECT 
    a.designation,
    v.quantite_disponible,
    v.quantite_reservee,
    v.stock_minimum,
    v.cout_moyen_unitaire,
    v.valeur_stock,
    CASE 
        WHEN v.quantite_disponible = 0 THEN 'RUPTURE'
        WHEN v.quantite_disponible <= v.stock_minimum THEN 'ALERTE'
        ELSE 'OK'
    END as statut_stock
FROM V_Etat_Stock_Temps_Reel v
JOIN Article a ON v.id_article = a.id_article
ORDER BY statut_stock DESC, a.designation;
```

### Lots Proches de la Péremption

```sql
-- Lots qui périment dans les 30 jours
SELECT 
    l.numero_lot,
    a.designation,
    l.quantite_restante,
    l.dlc,
    l.dluo,
    CASE 
        WHEN l.dlc IS NOT NULL THEN l.dlc - CURRENT_DATE
        WHEN l.dluo IS NOT NULL THEN l.dluo - CURRENT_DATE
    END as jours_avant_peremption
FROM Lot l
JOIN Article a ON l.id_article = a.id_article
WHERE l.statut = 'ACTIF'
  AND (
    l.dlc BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '30 days'
    OR l.dluo BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '30 days'
  )
ORDER BY jours_avant_peremption;
```

### Chiffre d'Affaires par Article

```sql
-- CA du mois en cours par article
SELECT 
    a.designation,
    v.quantite_vendue,
    v.chiffre_affaires,
    v.cout_total,
    v.marge_brute,
    ROUND((v.marge_brute / v.chiffre_affaires * 100)::numeric, 2) as taux_marge
FROM V_CA_Par_Article v
JOIN Article a ON v.id_article = a.id_article
WHERE v.mois = EXTRACT(MONTH FROM CURRENT_DATE)
  AND v.annee = EXTRACT(YEAR FROM CURRENT_DATE)
ORDER BY v.chiffre_affaires DESC;
```

### Mouvements du Jour

```sql
-- Tous les mouvements d'aujourd'hui
SELECT 
    m.numero_mouvement,
    tm.libelle as type_mouvement,
    tm.sens,
    a.designation,
    m.quantite,
    m.cout_unitaire,
    m.cout_total,
    m.reference_document,
    u.nom as utilisateur,
    m.date_mouvement
FROM Mouvement_Stock m
JOIN Type_Mouvement_Stock tm ON m.id_type_mouvement = tm.id_type_mouvement
JOIN Article a ON m.id_article = a.id_article
LEFT JOIN Utilisateur u ON m.id_utilisateur = u.id_utilisateur
WHERE DATE(m.date_mouvement) = CURRENT_DATE
ORDER BY m.date_mouvement DESC;
```

### Valorisation Globale du Stock

```sql
-- Valorisation totale par méthode
SELECT 
    methode_valorisation,
    COUNT(*) as nombre_articles,
    SUM(quantite_totale) as quantite_totale,
    SUM(valeur_totale) as valeur_totale
FROM V_Valorisation_Stock
GROUP BY methode_valorisation;
```

## 🔄 Procédures de Maintenance

### Bloquer les Lots Expirés

```sql
-- À exécuter quotidiennement
UPDATE Lot
SET statut = 'EXPIRE'
WHERE statut = 'ACTIF'
  AND (
    (dlc IS NOT NULL AND dlc < CURRENT_DATE)
    OR (dluo IS NOT NULL AND dluo < CURRENT_DATE)
  );
```

### Clôture Mensuelle

```sql
-- À exécuter en fin de mois après validation comptable
INSERT INTO Cloture_Stock_Mensuelle (
    mois,
    annee,
    valeur_stock_total,
    quantite_stock_total,
    nombre_articles,
    nombre_mouvements,
    valeur_entrees,
    valeur_sorties
)
SELECT 
    EXTRACT(MONTH FROM CURRENT_DATE),
    EXTRACT(YEAR FROM CURRENT_DATE),
    SUM(valeur_stock) as valeur_stock_total,
    SUM(quantite_disponible + quantite_reservee) as quantite_stock_total,
    COUNT(*) as nombre_articles,
    (SELECT COUNT(*) FROM Mouvement_Stock 
     WHERE EXTRACT(MONTH FROM date_mouvement) = EXTRACT(MONTH FROM CURRENT_DATE)
       AND EXTRACT(YEAR FROM date_mouvement) = EXTRACT(YEAR FROM CURRENT_DATE)
    ),
    (SELECT COALESCE(SUM(cout_total), 0) FROM Mouvement_Stock m
     JOIN Type_Mouvement_Stock t ON m.id_type_mouvement = t.id_type_mouvement
     WHERE t.sens = 'ENTREE'
       AND EXTRACT(MONTH FROM date_mouvement) = EXTRACT(MONTH FROM CURRENT_DATE)
       AND EXTRACT(YEAR FROM date_mouvement) = EXTRACT(YEAR FROM CURRENT_DATE)
    ),
    (SELECT COALESCE(SUM(cout_total), 0) FROM Mouvement_Stock m
     JOIN Type_Mouvement_Stock t ON m.id_type_mouvement = t.id_type_mouvement
     WHERE t.sens = 'SORTIE'
       AND EXTRACT(MONTH FROM date_mouvement) = EXTRACT(MONTH FROM CURRENT_DATE)
       AND EXTRACT(YEAR FROM date_mouvement) = EXTRACT(YEAR FROM CURRENT_DATE)
    )
FROM Stock;
```

### Nettoyage des Réservations Expirées

```sql
-- Annuler les réservations expirées (plus de 30 jours)
UPDATE Reservation_Stock
SET statut = 'ANNULEE',
    date_annulation = CURRENT_TIMESTAMP
WHERE statut = 'ACTIVE'
  AND date_reservation < CURRENT_DATE - INTERVAL '30 days';
```

## 🎯 Checklist Post-Installation

- [ ] Script SQL lapatia_gestion_stock.sql exécuté sans erreur
- [ ] 13 tables créées (8 tables + 5 vues)
- [ ] 9 types de mouvement insérés
- [ ] Configuration valorisation créée pour articles principaux
- [ ] Stocks minimums définis
- [ ] Vérification des vues fonctionnelles
- [ ] Test d'un mouvement manuel
- [ ] Vérification intégration AchatController
- [ ] Test du tableau de bord accessible

## 🚀 Prochaines Étapes

1. **Tester l'Application**
   ```bash
   mvn clean package
   # Déployer le WAR dans Tomcat
   # Accéder à http://localhost:8080/vente/
   ```

2. **Accéder au Module**
   - Page d'accueil → Clic sur "Gestion de Stock"
   - URL directe: http://localhost:8080/vente/gestionstock/dashboard

3. **Configurer les Articles**
   - Menu "Configuration"
   - Définir FIFO/CMUP pour chaque article
   - Activer gestion lot si nécessaire

4. **Tester le Workflow Complet**
   - Créer une réception (module achat)
   - Vérifier le mouvement créé
   - Vérifier la mise à jour du stock
   - Tester une sortie (module vente)

5. **Consulter les Rapports**
   - Tableau de bord pour vue d'ensemble
   - Rapport CA pour analyse ventes
   - Rapport valorisation pour comptabilité

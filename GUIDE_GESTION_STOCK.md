# Guide d'Utilisation - Gestion Avancée du Stock

## 📋 Vue d'Ensemble

Le système de gestion de stock implémente les spécifications du PDF pour gérer:
- **Mouvements de stock** avec traçabilité complète
- **Gestion par lots** avec numéros de lot et dates de péremption (DLC/DLUO)
- **Valorisation FIFO ou CMUP** configurable par article
- **Réservations de stock** pour les commandes clients
- **Rapports** de chiffre d'affaires et valorisation

## 🗄️ Structure de la Base de Données

### Tables Principales

1. **Type_Mouvement_Stock**
   - 9 types de mouvements (entrées et sorties)
   - RECEP_FOURN, RET_CLIENT, AJUST_PLUS, PRODUCTION (entrées)
   - LIV_CLIENT, RET_FOURN, AJUST_MOINS, CASSE, UTILISATION (sorties)

2. **Lot**
   - Gestion par lots avec numéros uniques (LOT-YYYY-NNNNNN)
   - Dates de fabrication et péremption (DLC/DLUO)
   - Suivi quantités initiale et restante
   - Statuts: ACTIF, EPUISE, EXPIRE, BLOQUE

3. **Mouvement_Stock**
   - Enregistrement de tous les mouvements avec numéros uniques (MVT-YYYY-NNNNNN)
   - Traçabilité: date, utilisateur, document source, type
   - Valorisation: coût unitaire et total
   - Respect de la clôture mensuelle

4. **Config_Valorisation_Article**
   - Configuration par article: FIFO ou CMUP
   - Activation gestion par lot
   - Type de péremption (DLC/DLUO) et délai d'alerte

5. **Reservation_Stock**
   - Réservations pour commandes clients
   - Statuts: ACTIVE, ANNULEE, CONSOMMEE

6. **Inventaire**
   - Inventaires physiques périodiques
   - Écarts et ajustements

7. **Cloture_Stock_Mensuelle**
   - Clôture comptable mensuelle
   - Blocage des modifications après clôture

## 🚀 Fonctionnalités

### 1. Tableau de Bord (`/gestionstock/dashboard`)

Affiche:
- Valeur totale du stock
- Nombre d'articles
- Alertes stock faible (quantité ≤ stock minimum)
- Alertes péremption (lots proches DLC/DLUO dans 30 jours)
- Mouvements du jour

**Actions automatiques:**
- Blocage automatique des lots expirés

### 2. Gestion des Stocks (`/gestionstock/stocks`)

**Filtres disponibles:**
- Tous les stocks
- Stock faible (quantité ≤ minimum)
- Stock critique (quantité = 0)

**Pour chaque article:**
- Quantités disponible et réservée
- Stock minimum
- Coût moyen pondéré (CMUP)
- Valeur du stock
- Statut visuel (OK, Faible, Rupture)

**Détail d'un stock** (`/gestionstock/stocks/{id}`):
- Indicateurs clés
- Configuration valorisation
- Lots actifs
- Historique des mouvements avec filtres de date

### 3. Historique des Mouvements (`/gestionstock/mouvements`)

**Filtres:**
- Par article
- Par période (date début - date fin)

**Informations affichées:**
- Numéro unique du mouvement
- Date et heure
- Type de mouvement (Entrée/Sortie)
- Quantité et coûts
- Référence document source

### 4. Gestion des Lots (`/gestionstock/lots`)

**Filtres:**
- Par article
- Par statut (ACTIF, EPUISE, EXPIRE, BLOQUE)

**Informations par lot:**
- Numéro de lot unique
- Quantités initiale et restante
- Coût unitaire
- Date de fabrication
- DLC ou DLUO
- Statut

**Actions:**
- Bloquer un lot (avec raison)
- Alertes péremption (30 jours)

### 5. Configuration Valorisation (`/gestionstock/configuration`)

**Configuration par article:**
- **Méthode de valorisation:**
  - FIFO (First In First Out): lots les plus anciens consommés en premier
  - CMUP (Coût Moyen Pondéré): coût moyenné sur tous les achats
  
- **Gestion par lot:** Activer/désactiver le suivi par lot
- **Type de péremption:**
  - DLC (Date Limite de Consommation): produits frais, médicaments
  - DLUO (Date Limite d'Utilisation Optimale): produits secs
- **Délai d'alerte:** Nombre de jours avant péremption pour alerte

### 6. Rapports

#### a) Rapport Chiffre d'Affaires (`/gestionstock/rapports/chiffre-affaires`)

**Filtres:** Date début - Date fin

**Affichage:**
- CA total sur la période
- CA par article avec quantité vendue
- Pourcentage du CA total par article

**Calcul:** Basé sur les mouvements de type LIV_CLIENT (livraisons clients)

#### b) Rapport Valorisation (`/gestionstock/rapports/valorisation`)

**Affichage:**
- Valeur totale du stock
- Répartition par méthode (FIFO/CMUP)
- Détail par article:
  - Quantité disponible
  - Coût moyen unitaire
  - Valeur du stock
  - % du total

## 🔄 Flux de Gestion

### Flux d'Achat (Entrée de Stock)

1. **Création Proforma Fournisseur**
   - Sélection articles et quantités
   - Négociation prix

2. **Validation Proforma → Bon de Commande**
   - Génération automatique du BC
   - Envoi au fournisseur

3. **Réception Marchandise → Bon de Livraison**
   - Enregistrement BL fournisseur
   - Création Bon de Réception

4. **Validation Réception**
   - **Création automatique du mouvement de stock (RECEP_FOURN)**
   - **Si gestion par lot activée:**
     - Création d'un nouveau lot avec numéro unique
     - Enregistrement DLC/DLUO si applicable
     - Association au mouvement
   - **Mise à jour du stock:**
     - Ajout de la quantité disponible
     - Recalcul du CMUP
     - Mise à jour de la valeur du stock

5. **Génération Facture**
   - Enregistrement de la facture fournisseur
   - Paiements fractionnés possibles

### Flux de Vente (Sortie de Stock)

1. **Création Proforma Client**
   - Vérification stock disponible
   - Application réductions

2. **Acceptation Proforma → Bon de Commande Client**
   - Génération automatique BC client
   - **Réservation du stock**

3. **Génération Facture Client**
   - Sur base du BC client
   - Paiements fractionnés

4. **Paiement Complet → Bon de Livraison**
   - Génération BL automatique quand facture payée

5. **Expédition Marchandise**
   - **Création automatique du mouvement de stock (LIV_CLIENT)**
   - **Si FIFO activé:**
     - Sélection du lot le plus ancien (FEFO si DLC/DLUO)
     - Consommation du lot
     - Valorisation au coût du lot
   - **Si CMUP activé:**
     - Valorisation au coût moyen pondéré
   - **Mise à jour du stock:**
     - Réduction de la quantité disponible
     - Libération de la réservation
     - Recalcul de la valeur du stock

## 📊 Règles de Valorisation

### FIFO (First In First Out)

**Principe:** Les lots entrés en premier sortent en premier

**Algorithme:**
1. Tri des lots actifs par:
   - DLC (si existe) croissante
   - DLUO (si existe) croissante
   - Date de fabrication croissante
2. Consommation du premier lot disponible
3. Si lot insuffisant, passage au suivant

**Avantages:**
- Évite la péremption
- Rotation optimale des produits frais
- Traçabilité précise

**Utilisation:** Produits périssables, médicaments, alimentaire

### CMUP (Coût Moyen Pondéré)

**Principe:** Le coût est moyenné sur tous les achats

**Calcul:**
```
Nouveau CMUP = (Valeur Stock Actuel + Valeur Nouvelle Entrée) / (Qté Actuelle + Qté Nouvelle)
```

**Mise à jour:**
- À chaque entrée (réception)
- Recalculé automatiquement

**Avantages:**
- Simple à gérer
- Lisse les variations de prix
- Pas besoin de gestion par lot

**Utilisation:** Produits non périssables, pièces industrielles

## 🔒 Clôture Mensuelle

**Objectifs:**
- Figer les mouvements du mois
- Empêcher modifications rétroactives
- Conformité comptable

**Processus:**
1. Calcul valorisation de fin de mois
2. Vérification cohérence (quantités, valeurs)
3. Création enregistrement clôture avec:
   - Valeur totale du stock
   - Quantité totale
   - Écarts inventaire
4. **Blocage:** Aucun mouvement ne peut être créé ou modifié sur période clôturée

## 🚨 Alertes et Sécurités

### Alertes Automatiques

1. **Stock Faible**
   - Déclenchement: Quantité ≤ Stock Minimum
   - Affichage: Tableau de bord, badge orange

2. **Stock Critique**
   - Déclenchement: Quantité = 0
   - Affichage: Badge rouge, blocage commandes

3. **Péremption Proche**
   - Déclenchement: DLC/DLUO dans X jours (configurable)
   - Affichage: Tableau de bord, page lots
   - Défaut: 30 jours

4. **Lot Expiré**
   - Déclenchement: DLC/DLUO dépassée
   - Action: Blocage automatique du lot
   - Le lot ne peut plus être utilisé

### Sécurités

1. **Vérification Stock Disponible**
   - Avant acceptation proforma client
   - Avant création BC client
   - Avant expédition

2. **Blocage Période Clôturée**
   - Impossible de créer/modifier mouvement
   - Message d'erreur explicite

3. **Validation Lot**
   - Vérification statut ACTIF
   - Vérification non périmé
   - Vérification quantité suffisante

4. **Traçabilité Complète**
   - Chaque mouvement enregistre:
     - Utilisateur
     - Date et heure précise
     - Document source
     - Coûts unitaire et total

## 🛠️ Points d'Intégration

### Dans AchatController (Validation Réception)

```java
// Après validation du bon de réception
mouvementStockService.enregistrerEntreeStock(
    article.getIdArticle(),
    quantite,
    coutUnitaire,
    utilisateur.getIdUtilisateur(),
    "BL-" + idBonLivraison,
    "BON_LIVRAISON",
    dluo,  // Date limite utilisation optimale
    dlc,   // Date limite consommation
    idFournisseur
);
```

**Effets:**
- Création mouvement RECEP_FOURN
- Création lot si gestion activée
- Mise à jour stock
- Recalcul CMUP

### Dans VenteController (Expédition)

```java
// Lors de l'expédition du bon de livraison
mouvementStockService.enregistrerSortieStock(
    article.getIdArticle(),
    quantite,
    utilisateur.getIdUtilisateur(),
    "BL-" + idBonLivraison,
    "BON_LIVRAISON_CLIENT"
);
```

**Effets:**
- Création mouvement LIV_CLIENT
- Consommation lot(s) selon FIFO si activé
- Valorisation FIFO ou CMUP
- Mise à jour stock
- Libération réservation

## 📝 Bonnes Pratiques

1. **Configuration Initiale**
   - Configurer méthode valorisation pour chaque article
   - Activer gestion lot pour produits périssables
   - Définir DLC/DLUO et délais d'alerte

2. **Gestion Quotidienne**
   - Consulter tableau de bord chaque matin
   - Traiter alertes stock faible
   - Vérifier alertes péremption
   - Bloquer lots expirés si nécessaire

3. **Réceptions**
   - Vérifier conformité quantités
   - Enregistrer DLC/DLUO immédiatement
   - Valider réception rapidement pour stock à jour

4. **Expéditions**
   - Vérifier stock disponible avant expédition
   - Respecter FIFO pour produits périssables
   - Confirmer expédition immédiatement

5. **Inventaires**
   - Réaliser inventaires périodiques (mensuel/trimestriel)
   - Enregistrer écarts
   - Créer ajustements si nécessaire

6. **Clôtures**
   - Clôturer chaque mois après validation comptable
   - Vérifier cohérence avant clôture
   - Ne jamais rouvrir une période clôturée

7. **Rapports**
   - Analyser CA régulièrement
   - Suivre évolution valorisation stock
   - Identifier articles à forte rotation

## 🔗 Navigation

- **Accueil** → `/` → Lien "Gestion de Stock"
- **Tableau de Bord** → `/gestionstock/dashboard`
- **Tous les menus** → Liens en haut de chaque page

## 📞 Support

Pour toute question ou problème:
1. Vérifier configuration article
2. Consulter historique mouvements
3. Vérifier alertes et statuts
4. Contacter administrateur système si nécessaire

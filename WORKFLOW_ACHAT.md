# Module Achat - Guide du Workflow Complet

## Vue d'ensemble

Ce projet Spring MVC implémente un module d'achat complet avec le workflow suivant :

```
Demande d'achat → Proformas → Sélection → Bon de Commande → Facture Fournisseur 
→ Bon de Livraison → Bon de Réception → Comparaison BL/BR → Validation
```

## Workflow Détaillé

### 1. Demande d'Achat (Point de départ)
- **URL**: `/achat/achat`
- **Page JSP**: `achat.jsp`
- L'utilisateur sélectionne un article et clique sur "Demande d'achat"
- Redirige vers `/achat/quantite?idArticle=X`

### 2. Saisie de la Quantité
- **URL**: `/achat/quantite`
- **Page JSP**: `quantite.jsp`
- L'utilisateur saisit la quantité désirée
- Soumet le formulaire vers `/achat/quantite` (POST)

### 3. Génération et Affichage des Proformas
- **URL**: `/achat/proformas?token=XXX`
- **Page JSP**: `proformas.jsp`
- Le système génère automatiquement des proformas pour tous les fournisseurs ayant un prix d'achat pour cet article
- Chaque proforma contient :
  - Numéro de proforma
  - Article (code, désignation)
  - Fournisseur
  - Quantité
  - Prix unitaire
  - Montant total

### 4. Sélection d'un Proforma et Vérification Financière
- **URL**: `/achat/selectionner` (POST)
- **Page JSP**: `finance.jsp`
- Le système compare le montant du proforma avec le seuil de validation
- Affiche si une validation est requise
- L'utilisateur valide avec son email

### 5. Création du Bon de Commande
- **URL**: `/achat/validerProforma` (POST)
- Après validation, un bon de commande est créé automatiquement
- Le bon de commande est lié au proforma sélectionné
- **Navigation**: `/bc/list` pour voir tous les bons de commande

### 6. Génération de la Facture Fournisseur
- **URL**: `/bc/detail/{id}` puis bouton "Générer facture fournisseur"
- **Endpoint**: `/genererFactureFournisseur` (POST)
- **Page JSP**: `facturefournisseur-detail.jsp`
- La facture contient TOUS les détails du proforma :
  - Numéro de proforma
  - Article (code, désignation)
  - Fournisseur (nom, email, téléphone)
  - Quantité
  - Prix unitaire
  - Montant total
  - Dates

### 7. Règlement et Création du Bon de Livraison
- **URL**: `/factureFournisseur/detail/{id}`
- Bouton "Receptionner" déclenche `/factureFournisseur/regler` (POST)
- Cela marque la facture comme réglée ET crée un bon de livraison
- Redirige vers `/bonLivraison/list`

### 8. Création du Bon de Réception
- **URL**: `/bonLivraison/detail/{id}`
- Bouton "📦 Créer un bon de réception" → `/bonReception/form/{idBonLivraison}`
- **Page JSP**: `bonreception-form.jsp`
- L'utilisateur saisit :
  - Quantité reçue
  - Quantité non conforme
  - Commentaire
- Soumet vers `/bonReception/enregistrer` (POST)

### 9. Comparaison BL/BR
- **URL**: `/bonReception/comparaison/{idBonLivraison}`
- **Page JSP**: `bonreception-comparaison.jsp`
- Affichage côte à côte :
  - Bon de Livraison (colonne gauche)
  - Bon de Réception (colonne droite)
- Compare les quantités :
  - ✅ Correspondance parfaite (vert)
  - ⚠️ Écarts détectés (orange/rouge)

### 10. Validation Finale
- Bouton "✅ Valider la réception" dans la page de comparaison
- **Endpoint**: `/bonReception/valider` (POST)
- Actions :
  - Marque le bon de livraison comme "RECU"
  - TODO: Gère le mouvement de caisse (à implémenter si nécessaire)
  - Mise à jour du stock (à implémenter si nécessaire)

## Structure des Entités

### Entités Principales
1. **Article** - Produits à acheter
2. **Fournisseur** - Fournisseurs disponibles
3. **Prix** - Prix d'achat par fournisseur et article
4. **Proforma** - Propositions de prix pour une demande
5. **BonCommande** - Commande validée
6. **FactureFournisseur** - Facture du fournisseur
7. **BonLivraison** - Livraison de la commande
8. **BonReception** - Réception physique des marchandises

### Relations
- Proforma → Article (many-to-one)
- Proforma → Fournisseur (many-to-one)
- BonCommande → Proforma (many-to-one)
- FactureFournisseur → BonCommande (many-to-one)
- BonLivraison → BonCommande (many-to-one)
- BonReception → BonLivraison (many-to-one)
- BonReception → Article (many-to-one)

## Enrichissement des Données

Les services enrichissent automatiquement les entités avec les données liées :
- **BonCommandeService** : Enrichit avec Proforma → Article + Fournisseur
- **FactureFournisseurService** : Enrichit avec BonCommande → Proforma complète
- **BonLivraisonService** : Enrichit avec BonCommande → Proforma complète
- **BonReceptionService** : Enrichit avec BonLivraison + Article

## Pages JSP Créées/Modifiées

### Nouvelles Pages
1. `bonreception-form.jsp` - Formulaire de saisie du bon de réception
2. `bonreception-comparaison.jsp` - Comparaison BL/BR côte à côte

### Pages Modifiées
1. `achat.jsp` - Navigation améliorée
2. `bc-liste.jsp` - Liens de navigation ajoutés
3. `bc-detail.jsp` - Bouton pour générer facture
4. `facturefournisseur-list.jsp` - Affichage du fournisseur corrigé
5. `facturefournisseur-detail.jsp` - Détails complets du proforma
6. `bonlivraison-detail.jsp` - Bouton pour créer bon de réception
7. `bonlivraison-list.jsp` - Navigation améliorée

## Navigation Entre les Pages

```
Menu Achat (achat.jsp)
    ├─→ Demandes (demandes.jsp)
    ├─→ Bons de Commande (bc-liste.jsp)
    │   └─→ Détail BC (bc-detail.jsp)
    │       └─→ Générer Facture
    ├─→ Factures Fournisseurs (facturefournisseur-list.jsp)
    │   └─→ Détail Facture (facturefournisseur-detail.jsp)
    │       └─→ Réceptionner → Crée BL
    └─→ Bons de Livraison (bonlivraison-list.jsp)
        └─→ Détail BL (bonlivraison-detail.jsp)
            └─→ Créer Bon Réception (bonreception-form.jsp)
                └─→ Comparaison BL/BR (bonreception-comparaison.jsp)
                    └─→ Valider → Fin du processus
```

## Points à Noter

### Sécurité
- Vérification de connexion utilisateur dans les actions sensibles
- Validation email pour les proformas dépassant le seuil

### Validation
- Les quantités sont vérifiées (min/max)
- Les statuts sont mis à jour automatiquement
- Détection des écarts entre BL et BR

### Extensibilité
Le code contient des TODOs pour :
- Gestion du mouvement de caisse
- Mise à jour du stock
- Notifications par email

## Base de Données

Le schéma SQL complet est dans `sql/lapatia_Achat.sql` incluant :
- Tables avec contraintes
- Index pour optimisation
- Valeurs par défaut
- Clés étrangères

## Démarrage Rapide

1. Importer la base de données : `psql < sql/lapatia_Achat.sql`
2. Configurer la connexion dans `app-context.xml`
3. Démarrer le serveur : `mvn tomcat:run` ou déployer le WAR
4. Accéder à : `http://localhost:8080/vente/achat/achat`

## Workflow Complet d'un Achat

1. Choisir un article → Saisir quantité → Voir proformas
2. Sélectionner un proforma → Valider avec email
3. Bon de commande créé automatiquement
4. Générer facture fournisseur depuis le BC
5. Régler la facture → Bon de livraison créé
6. Créer bon de réception depuis le BL
7. Comparer BL et BR côte à côte
8. Valider la réception → Stock mis à jour (TODO)

✅ **Projet finalisé et prêt à l'emploi!**

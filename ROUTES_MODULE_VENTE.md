# 🗺️ Routes du Module Vente - Guide Complet

## 📋 Vue d'ensemble des routes

### 🏠 Accueil
| Méthode | Route | Description | Vue JSP |
|---------|-------|-------------|---------|
| GET | `/vente/accueil` | Page d'accueil du module vente | `accueil.jsp` |

---

### 📦 Articles
| Méthode | Route | Description | Vue JSP |
|---------|-------|-------------|---------|
| GET | `/vente/articles` | Liste des articles disponibles | `liste_articles.jsp` |

---

### 📄 Gestion des Devis

#### Consultation
| Méthode | Route | Description | Vue JSP |
|---------|-------|-------------|---------|
| GET | `/vente/devis` | Liste de tous les devis | `liste_devis.jsp` |
| GET | `/vente/devis/nouveau` | Formulaire de création de devis | `nouveau_devis.jsp` |

#### Actions
| Méthode | Route | Paramètres | Description | Redirection |
|---------|-------|------------|-------------|-------------|
| POST | `/vente/devis/nouveau` | `selectedArticles` (JSON) | Sélectionne les articles pour le devis | → `/vente/devis/nouveau` (GET) |
| POST | `/vente/devis/creer` | `idClient`, `idCommercial`, `qty_*`, `prix_*`, `remise_*`, `tva_*`, `notes` | Crée un nouveau devis avec lignes | → `/vente/devis` |
| POST | `/vente/devis/valider` | `idDevis` | Valide un devis (nécessite rôle valideur) | → `/vente/devis` |
| POST | `/vente/devis/refuser` | `idDevis`, `motif` | Refuse un devis | → `/vente/devis` |

---

### 🛒 Gestion des Commandes

#### Consultation
| Méthode | Route | Description | Vue JSP |
|---------|-------|-------------|---------|
| GET | `/vente/commandes` | Liste des devis acceptés (transformables en commande) | `liste_devis_commande.jsp` |
| GET | `/vente/commandes/nouveau` | Formulaire de confirmation de commande | `commande_confirmation.jsp` |

#### Actions
| Méthode | Route | Paramètres | Description | Redirection |
|---------|-------|------------|-------------|-------------|
| POST | `/vente/commandes/creer` | `idDevis`, `dateLivraison` | Crée une commande depuis un devis accepté | → `/vente/livraisons` |

---

### 📦 Gestion des Livraisons

#### Consultation
| Méthode | Route | Description | Vue JSP | Accès |
|---------|-------|-------------|---------|-------|
| GET | `/vente/livraisons` | Liste des commandes à livrer | `liste_commandes_livraison.jsp` | MAGASINIER, ADMIN |
| GET | `/vente/livraisons/nouveau` | Formulaire de préparation de livraison | `livraison_form.jsp` | MAGASINIER, ADMIN |

#### Actions
| Méthode | Route | Paramètres | Description | Redirection |
|---------|-------|------------|-------------|-------------|
| POST | `/vente/livraisons/creer` | `idCommande`, `transporteur`, `numeroSuivi`, `qty_*` | Crée une livraison pour une commande | → `/vente/livraisons` |

---

## 🔄 Workflow Complet

### 1️⃣ Création d'un Devis
```
Articles → Sélection → Nouveau Devis → Création
↓
/vente/articles (GET)
    → Sélectionner articles
    → POST /vente/devis/nouveau (avec selectedArticles JSON)
        ↓
        → GET /vente/devis/nouveau (formulaire)
            → Remplir quantités, prix, remises
            → POST /vente/devis/creer
                ↓
                → Devis créé (statut: BROUILLON)
```

### 2️⃣ Validation du Devis
```
Liste Devis → Validation
↓
GET /vente/devis
    → Bouton "Valider" sur un devis
    → POST /vente/devis/valider?idDevis=X
        ↓
        → Devis validé (statut: ACCEPTE ou A_VALIDER_N2)
```

### 3️⃣ Création d'une Commande
```
Devis Accepté → Commande
↓
GET /vente/commandes (liste des devis acceptés)
    → Clic "Créer commande"
    → GET /vente/commandes/nouveau?idDevis=X
        → Confirmer date de livraison
        → POST /vente/commandes/creer
            ↓
            → Commande créée (statut: CONFIRMEE)
```

### 4️⃣ Préparation et Livraison
```
Commande Confirmée → Livraison
↓
GET /vente/livraisons (liste des commandes livrables)
    → Clic "Préparer livraison"
    → GET /vente/livraisons/nouveau?idCommande=X
        → Saisir quantités, transporteur
        → POST /vente/livraisons/creer
            ↓
            → Livraison créée (statut: EXPEDIEE)
```

---

## 🔐 Contrôles d'accès par rôle

### COMMERCIAL
✅ Créer des devis  
✅ Consulter les devis  
❌ Valider des devis  
❌ Gérer les livraisons

### VALIDEUR_N1
✅ Valider des devis < seuil N2  
✅ Consulter les devis  
❌ Créer des devis

### VALIDEUR_N2
✅ Valider tous les devis  
✅ Consulter les devis  
❌ Créer des devis

### MAGASINIER
✅ Gérer les livraisons  
✅ Préparer les commandes  
❌ Créer/Valider des devis

### ADMIN
✅ Accès complet à toutes les fonctionnalités

---

## 📝 Paramètres requis par route

### POST /vente/devis/nouveau
```
selectedArticles: "[1,2,3]" (JSON array des IDs d'articles)
```

### POST /vente/devis/creer
```
idClient: Integer (ID du client)
idCommercial: Integer (ID du commercial, optionnel si user = COMMERCIAL)
qty_[articleId]: Integer (quantité pour chaque article)
prix_[articleId]: Decimal (prix unitaire HT)
remise_[articleId]: Decimal (% de remise, 0-100)
tva_[articleId]: Decimal (taux TVA, défaut 20.0)
notes: String (notes optionnelles)
```

### POST /vente/commandes/creer
```
idDevis: Integer (ID du devis accepté)
dateLivraison: String (format: YYYY-MM-DD, optionnel)
```

### POST /vente/livraisons/creer
```
idCommande: Integer (ID de la commande)
transporteur: String (nom du transporteur, requis)
numeroSuivi: String (numéro de suivi, optionnel)
qty_[idLigneCommande]: Integer (quantité à livrer pour chaque ligne)
```

---

## 🎯 Points d'entrée principaux

1. **Page d'accueil** : `/vente/accueil`
2. **Créer un devis** : `/vente/articles`
3. **Gérer les devis** : `/vente/devis`
4. **Créer des commandes** : `/vente/commandes`
5. **Gérer les livraisons** : `/vente/livraisons`

---

## ⚠️ Redirections en cas d'erreur

Toutes les routes protégées redirigent vers `/user/login?id=1` si :
- L'utilisateur n'est pas connecté
- L'utilisateur n'a pas de rôle assigné
- La session est invalide

Les routes avec contrôle d'accès (livraisons) redirigent vers `/vente/accueil` avec un message d'erreur si le rôle ne correspond pas.

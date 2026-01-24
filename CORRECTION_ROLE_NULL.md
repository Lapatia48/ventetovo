# 🔧 Correction de l'erreur "Role.getNomRole() is null"

## 🔍 Diagnostic du problème

L'erreur `Cannot invoke "entity.Role.getNomRole()" because the return value of "entity.Utilisateur.getRole()" is null` se produit lorsqu'un utilisateur connecté n'a pas de rôle assigné dans la base de données.

### Causes possibles :
1. L'utilisateur n'a pas de `id_role` dans la table `utilisateur`
2. L'`id_role` pointe vers un rôle qui n'existe pas dans la table `role`
3. Les données de test n'ont pas été correctement chargées

## ✅ Solutions appliquées

### 1. Corrections dans le contrôleur
Le fichier [VentesController.java](src/main/java/controller/VentesController.java) a été modifié pour :
- Vérifier systématiquement si `user.getRole()` est `null` avant d'y accéder
- Rediriger vers la page de login avec un message d'erreur approprié
- Invalider la session pour forcer une nouvelle authentification

### 2. Scripts SQL fournis

#### a) **diagnostic_users_roles.sql** 🔍
Permet de diagnostiquer l'état actuel de votre base :
```bash
psql -U votre_user -d votre_db -f sql_vente/diagnostic_users_roles.sql
```

#### b) **fix_missing_roles.sql** 🔧
Corrige les problèmes de rôles manquants :
- Crée les rôles ADMIN, COMMERCIAL, MAGASINIER s'ils n'existent pas
- Assigne le rôle ADMIN aux utilisateurs sans rôle
- Corrige les références à des rôles invalides

```bash
psql -U votre_user -d votre_db -f sql_vente/fix_missing_roles.sql
```

#### c) **create_test_users.sql** 👥
Crée des utilisateurs de test avec les rôles appropriés :
- MAGASINIER : `magasinier@vente-tovo.mg` / `magasinier123`
- COMMERCIAL : `commercial@vente-tovo.mg` / `commercial123`
- ADMIN : `admin@vente-tovo.mg` / `admin123`

```bash
psql -U votre_user -d votre_db -f sql_vente/create_test_users.sql
```

## 📋 Marche à suivre

### Étape 1 : Diagnostic
```bash
psql -U votre_user -d votre_db -f sql_vente/diagnostic_users_roles.sql
```
Vérifiez si des utilisateurs ont le statut `⚠️ PAS DE ROLE` ou `❌ ROLE INVALIDE`

### Étape 2 : Correction
```bash
psql -U votre_user -d votre_db -f sql_vente/fix_missing_roles.sql
```

### Étape 3 : Création d'utilisateurs de test (optionnel)
```bash
psql -U votre_user -d votre_db -f sql_vente/create_test_users.sql
```

### Étape 4 : Test
1. Déconnectez-vous de l'application
2. Connectez-vous avec un des comptes suivants :
   - **Magasinier** (accès aux livraisons) : `magasinier@vente-tovo.mg` / `magasinier123`
   - **Commercial** : `commercial@vente-tovo.mg` / `commercial123`
   - **Admin** (accès complet) : `admin@vente-tovo.mg` / `admin123`
3. Accédez à **Gestion Livraisons**

## 🔐 Contrôles d'accès

Les pages de livraison sont maintenant protégées :
- ✅ Accessible aux rôles : `MAGASINIER`, `ADMIN`
- ❌ Refusé aux autres rôles (redirection avec message d'erreur)
- ❌ Impossible d'accéder sans rôle (redirection vers login)

## 🧪 Vérification manuelle dans la base

```sql
-- Vérifier votre utilisateur actuel
SELECT u.id_utilisateur, u.nom, u.prenom, u.email, u.id_role, r.nom_role, u.actif
FROM utilisateur u
LEFT JOIN role r ON u.id_role = r.id_role
WHERE u.email = 'votre_email@exemple.com';

-- Si le rôle est NULL ou invalide, le corriger
UPDATE utilisateur 
SET id_role = (SELECT id_role FROM role WHERE nom_role = 'MAGASINIER')
WHERE email = 'votre_email@exemple.com';
```

## 📝 Notes importantes

1. **Le champ `role` dans l'entité `Utilisateur` est `@Transient`** : il n'est pas persisté en base mais chargé à la demande par le service
2. **Le service `UtilisateurService` enrichit automatiquement** les utilisateurs avec leur rôle via la méthode `enrichirAvecRole()`
3. **Les contrôleurs rechargent toujours l'utilisateur depuis la base** pour avoir les données à jour

## 🚨 Si le problème persiste

1. Vérifiez que la table `role` contient bien des données :
   ```sql
   SELECT * FROM role;
   ```

2. Vérifiez que tous les utilisateurs ont un `id_role` valide :
   ```sql
   SELECT * FROM utilisateur WHERE id_role IS NULL;
   ```

3. Consultez les logs de l'application pour voir les erreurs détaillées

4. Videz le cache de votre navigateur et la session

## 📧 Contact

Si le problème persiste après avoir suivi ces étapes, contactez l'équipe de développement avec :
- Les résultats du script de diagnostic
- Les logs de l'application
- L'utilisateur avec lequel vous essayez de vous connecter

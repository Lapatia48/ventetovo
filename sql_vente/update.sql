UPDATE commande_client
SET id_validateur = 1,
    date_validation = NOW()
WHERE statut = 'VALIDEE'
  AND id_validateur IS NULL;

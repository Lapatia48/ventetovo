CREATE OR REPLACE VIEW v_utilisateur_role AS
SELECT 
    u.id_utilisateur,
    u.nom,
    u.prenom,
    u.email,
    u.mot_de_passe,
    u.actif,
    r.id_role,
    r.nom_role,
    r.niveau_validation
FROM utilisateur u
JOIN role r ON r.id_role = u.id_role;

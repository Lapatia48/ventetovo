CREATE OR REPLACE FUNCTION check_commercial_devis()
RETURNS TRIGGER AS $$
DECLARE
    role_name VARCHAR;
    actif_user BOOLEAN;
BEGIN
    SELECT r.nom_role, u.actif
    INTO role_name, actif_user
    FROM utilisateur u
    JOIN role r ON u.id_role = r.id_role
    WHERE u.id_utilisateur = NEW.id_commercial;

    -- Vérifier que l'utilisateur existe
    IF role_name IS NULL THEN
        RAISE EXCEPTION 'Utilisateur % introuvable pour id_commercial', NEW.id_commercial;
    END IF;

    -- Vérifier le rôle
    IF role_name <> 'COMMERCIAL' THEN
        RAISE EXCEPTION 'Utilisateur % n''est pas COMMERCIAL (role=%)', 
            NEW.id_commercial, role_name;
    END IF;

    -- Vérifier qu'il est actif
    IF actif_user IS FALSE THEN
        RAISE EXCEPTION 'Le commercial % est inactif', NEW.id_commercial;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_check_commercial_devis
BEFORE INSERT OR UPDATE OF id_commercial
ON devis
FOR EACH ROW
EXECUTE FUNCTION check_commercial_devis();

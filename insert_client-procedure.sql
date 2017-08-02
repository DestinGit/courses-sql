CREATE PROCEDURE `insertion_client` (
	param_nom varchar(50),
    param_prenom varchar(50),
    param_adresse varchar(100),
    param_date_naissance DATE,
    param_cp CHAR(5),
    param_ville VARCHAR(50),
    param_pays VARCHAR(50),
    OUT param_idClient INT
)
BEGIN
	DECLARE v_idClient INT;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SELECT false as success, @erreur as message;
		END;
    	
    -- Récupération de l'identifiant du client que je veux insérer
    SELECT id_client FROM clients WHERE nom = param_nom AND prenom = param_prenom
    INTO v_idClient;
    
    IF v_idClient IS NULL THEN
		
        CALL insert_ville(param_ville, param_cp, param_pays);
        
		INSERT INTO clients(nom, prenom,adresse, date_naissance, cp)
		VALUES (param_nom, param_prenom, param_adresse, param_date_naissance, param_cp);
		
		-- Récupération de la valeur du dernier id auto
		SET param_idClient := LAST_INSERT_ID();
	ELSE
        SET param_idClient := v_idClient;
	END IF;
END
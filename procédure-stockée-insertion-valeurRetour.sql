CREATE PROCEDURE `insertion_client` (
	param_nom varchar(50),
    param_prenom varchar(50),
    param_adresse varchar(100),
    param_date_naissance DATE,
    param_cp CHAR(5),
    OUT param_idClient INT
)
BEGIN
	INSERT INTO clients(nom, prenom,adresse, date_naissance, cp)
    VALUES (param_nom, param_prenom, param_adresse, param_date_naissance, param_cp);
    
    -- Récupération de la valeur du dernier id auto
    SET param_idClient := LAST_INSERT_ID();
END
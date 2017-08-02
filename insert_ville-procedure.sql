CREATE PROCEDURE `insert_ville` (
	p_ville VARCHAR(50),
	p_codePostal CHAR(50),
	p_pays VARCHAR(50)
)
BEGIN
	DECLARE v_villeExiste TINYINT UNSIGNED;
    DECLARE v_codePays CHAR(4);
    
    SET v_villeExiste := EXISTS(SELECT cp FROM villes WHERE cp = p_codePostal AND nom_ville = p_ville);
    
    IF NOT v_villeExiste THEN
		-- récupération du code pays
        SET v_codePays := (SELECT id_pays FROM pays WHERE nom_pays = p_pays);
        IF v_codePays IS NOT NULL THEN
			INSERT INTO villes (cp, nom_ville, id_pays)
            VALUES(p_codePostal, p_ville, v_codePays);
            -- TODO retourner une erreur
        END IF;
    END IF;
END
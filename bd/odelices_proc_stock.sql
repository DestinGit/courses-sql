USE odelice;

DELIMITER $$

DROP PROCEDURE IF EXISTS creation_recette $$

CREATE PROCEDURE creation_recette (
p_titre VARCHAR(50),
p_preparation TEXT,
p_difficulte VARCHAR(30),
p_auteur VARCHAR(30)
)

BEGIN

	DECLARE v_id_difficulte TINYINT;
    DECLARE v_id_auteur INT;
    
    /*
    SET v_id_difficulte := (SELECT id FROM difficultes WHERE 
    difficulte_texte=p_difficulte);
    */
    
    -- Récupération de la difficulté
    SELECT id FROM difficultes WHERE 
    difficulte_texte=p_difficulte INTO v_id_difficulte;
    
    -- Recherche de l'auteur
    SELECT id FROM auteurs WHERE nom = p_auteur INTO v_id_auteur;
    
    -- Création de l'auteur si inexistant
    IF v_id_auteur IS NULL THEN
		INSERT INTO auteurs (nom) VALUES (p_auteur);
        
        SET v_id_auteur := LAST_INSERT_ID();
    END IF;
    
    IF v_id_auteur IS NOT NULL AND v_id_difficulte IS NOT NULL THEN
		INSERT INTO recette (titre, preparation, id_difficulte, id_auteur)
        VALUES (p_titre, p_preparation, v_id_difficulte, v_id_auteur);
    END IF;
END $$

DELIMITER ;
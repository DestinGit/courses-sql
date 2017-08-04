USE `abonnements`;
DROP procedure IF EXISTS `abonnement_client`;

DELIMITER $$
USE `abonnements`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `abonnement_client`(
p_num_abonne INT,
p_offre_id SMALLINT
)
BEGIN

	DECLARE v_revue_id, v_nb_numeros, 
			v_prochain_numero, v_premier_numero, 
            v_dernier_numero SMALLINT;
	DECLARE v_tarif DECIMAL(5,2); 
      
	-- Informations sur l'offre
	SELECT revue_id, nb_numeros, tarif FROM offre_abonnement
    WHERE id= p_offre_id INTO v_revue_id, v_nb_numeros, v_tarif;
    
    -- abonnement en cours
    SELECT dernier_numero, prochain_numero FROM vue_abonnes_details WHERE
    num_abonne=p_num_abonne and revue_id = v_revue_id
    INTO v_premier_numero, v_prochain_numero;
    
    -- Définition du premier numéro
    IF v_premier_numero IS NULL THEN
		SET v_premier_numero := v_prochain_numero;
	ELSEIF v_premier_numero >= v_prochain_numero THEN
		SET v_premier_numero := v_premier_numero +1;
	ELSE 
		SET v_premier_numero := v_prochain_numero;
	END IF;
    
    -- Définition du dernier numéro
    SET v_dernier_numero := v_premier_numero + v_nb_numeros - 1;
    
    -- Insertion de l'abonnement
    INSERT INTO abonnement_client
    (date_abonnement, offre_id, num_abonne, 
    montant, premier_numero, dernier_numero)
    VALUES
    (
    CURDATE(), p_offre_id, p_num_abonne, v_tarif, 
    v_premier_numero, v_dernier_numero
    );
    
    
    


END$$

DELIMITER ;


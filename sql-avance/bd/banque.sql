SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

DROP DATABASE IF EXISTS banque;
CREATE DATABASE banque CHARACTER SET=utf8  COLLATE=utf8_unicode_ci;

USE banque;

-- ----------------------------
--  Table structure for compte
-- ----------------------------
DROP TABLE IF EXISTS compte;
CREATE TABLE compte (
  id int(11) unsigned NOT NULL AUTO_INCREMENT,
  iban varchar(34) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY iban (iban)
) ENGINE=InnoDB;

-- ----------------------------
--  Records of compte
-- ----------------------------
BEGIN;
INSERT INTO compte (iban) VALUES 
('DE06495352657836424132'), 
('DK6988299842527195'), 
('FR3007344050937354660134854'), 
('FR4197944644738285027717680'), 
('FR6888474339535547405026268'), 
('GB22KVUM18028477988401'), 
('GB26JAYK66540091518150'), 
('GB55ZAFY89851748597528'), 
('GR0708312360607104632724143'), 
('GR3019549951345337224826989');
COMMIT;

-- ----------------------------
--  Table structure for compte_mouvement
-- ----------------------------
DROP TABLE IF EXISTS compte_mouvement;
CREATE TABLE compte_mouvement (
  id int(10) unsigned NOT NULL AUTO_INCREMENT,
  date_operation date NOT NULL,
  compte_id int(10) unsigned NOT NULL,
  libelle varchar(100) NOT NULL,
  debit decimal(8,2) NOT NULL DEFAULT '0.00',
  credit decimal(8,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (id),
  KEY compte_id (compte_id),
  CONSTRAINT mouvement_to_compte FOREIGN KEY (compte_id) REFERENCES compte (id)
) ENGINE=InnoDB;

-- ----------------------------
--  Records of compte_mouvement
-- ----------------------------
SET @dateBase := '2013-01-01';

# Insertion des dépôts initiaux
INSERT INTO compte_mouvement (date_operation, compte_id, libelle, credit)
(
SELECT 
	DATE_ADD(@dateBase,INTERVAL (RAND()*365) DAY),
	compte.id, 
	'Dépôt initial', 
	ROUND( (RAND()*2000) + 500,2)
FROM compte
);

# Insertion des retraits
INSERT INTO compte_mouvement (date_operation, compte_id, libelle, debit)
(
SELECT 
	DATE_ADD((SELECT MIN(date_operation) FROM compte_mouvement as cm
				WHERE cm.compte_id = compte.id and cm.credit > 0)
		,INTERVAL (RAND()*365) DAY
	),
	compte.id, 
	'Retrait', 
	ROUND(RAND()*200,2)
FROM compte, compte as c1
);

# Insertion des dépôts successifs
INSERT INTO compte_mouvement (date_operation, compte_id, libelle, credit)
(
SELECT 
	DATE_ADD((SELECT MIN(date_operation) FROM compte_mouvement as cm
				WHERE cm.compte_id = compte.id and cm.credit > 0)
		,INTERVAL (RAND()*365) DAY
	),
	compte.id, 
	'dépôt', 
	ROUND(RAND()*1000,2)
FROM compte, compte as c1
LIMIT 30
);


-- ----------------------------
--  Procedure structure for virement_bancaire
-- ----------------------------
DROP PROCEDURE IF EXISTS virement_bancaire;
delimiter $$
CREATE DEFINER=root@localhost PROCEDURE virement_bancaire(p_iban_source VARCHAR(34), p_iban_cible VARCHAR(34), p_montant DECIMAL(8,2))
BEGIN

DECLARE v_id_compte_cible INT;
DECLARE v_id_compte_source INT;

DECLARE etape VARCHAR(50);
DECLARE EXIT HANDLER FOR SQLEXCEPTION 
	BEGIN
		ROLLBACK;
		GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, 
			@errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
		SET @full_error = CONCAT("ERROR ", @errno, " (", @sqlstate, "): ", @text);
		SELECT @full_error, etape;
	END;

SET etape = 'Début transaction';
#SET autocommit=0;
START TRANSACTION;

SET etape = 'Récupération des id comptes';
SELECT id FROM compte WHERE iban=p_iban_source INTO v_id_compte_cible;
SELECT id FROM compte WHERE iban=p_iban_cible INTO v_id_compte_source;


SET etape = CONCAT_WS(' ', 'Préparation de la requête','id cible=', v_id_compte_cible);
PREPARE stmVirementBancaire FROM 
'INSERT INTO compte_mouvement 
(compte_id, debit, credit, date_operation, libelle)
VALUES (?,?,?,CURDATE(),?)';


SET @debit := p_montant;
SET	@credit := 0;
SET	@libelle := CONCAT('Virement vers ', p_iban_cible);
SET @id_compte := v_id_compte_source;
EXECUTE stmVirementBancaire USING 
@id_compte, @debit, @credit, @libelle;

SET @debit := 0;
SET	@credit := p_montant;
SET	@libelle := CONCAT('Virement depuis ', p_iban_source);
SET @id_compte := v_id_compte_cible;
EXECUTE stmVirementBancaire USING 
@id_compte, @debit, @credit, @libelle;

DEALLOCATE PREPARE stmVirementBancaire;

COMMIT;

END $$

delimiter ;

SET FOREIGN_KEY_CHECKS = 1;

CREATE DEFINER = CURRENT_USER TRIGGER `cours`.`clients_BEFORE_UPDATE` BEFORE UPDATE ON `clients` FOR EACH ROW
BEGIN
	INSERT INTO historique(nom_table, nom_colonne, operation, nouvelle_valeur, ancienne_valeur)
    VALUES
    ('clients', 'nom', 'insert', NEW.nom, OLD.nom),
    ('clients', 'prenom', 'insert', NEW.prenom, OLD.prenom),
    ('clients', 'cp', 'insert', NEW.cp, OLD.cp);
END

CREATE DEFINER = CURRENT_USER TRIGGER `cours`.`clients_BEFORE_INSERT` BEFORE INSERT ON `clients` FOR EACH ROW
BEGIN
	INSERT INTO historique(nom_table, nom_colonne, operation, nouvelle_valeur)
    VALUES
    ('clients', 'nom', 'insert', NEW.nom),
    ('clients', 'prenom', 'insert', NEW.prenom),
    ('clients', 'cp', 'insert', NEW.cp);
END
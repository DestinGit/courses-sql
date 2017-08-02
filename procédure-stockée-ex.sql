CREATE DEFINER=`root`@`localhost` PROCEDURE `clients_vendeurs`(
	param_cp CHAR(5)
)
BEGIN
	SELECT t.*, villes.nom_ville FROM
	(
		SELECT id_client as id, nom, cp, 'client' as categorie FROM clients
		UNION
		SELECT id_vendeur, nom, cp, 'vendeur' FROM vendeurs
	) as t
	INNER JOIN villes ON t.cp = villes.cp
    WHERE t.cp = param_cp
	ORDER BY cp;
END
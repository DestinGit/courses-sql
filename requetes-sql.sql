# cumul des ventes par années
SET @cumul := 0, @rang := 0;

SELECT
@rang := @rang + 1 as rang,
t.total,
(@cumul := @cumul + t.total) AS cumul

FROM (
		SELECT
		YEAR(date_vente) as annee,
		SUM(montant) AS total,
		
		COUNT(*) AS nb_ventes
		FROM ventes
		GROUP BY annee
		ORDER BY annee DESC
) AS t 
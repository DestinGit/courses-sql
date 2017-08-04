SELECT 
vad.titre_revue,
vad.num_abonne,
vad.nom,
vad.prenom,
vad.nb_numeros_a_servir,
CASE
	WHEN vad.nb_numeros_a_servir = 0 AND vad.nb_numeros_par_an NOT IN (1,2)
		THEN 'Relance 2'
    WHEN vad.nb_numeros_a_servir = 2 
    OR (vad.nb_numeros_par_an IN (1,2) AND  vad.nb_numeros_a_servir = 0)
		THEN 'Relance 1'
    ELSE 'pas de relance'

END as relance

FROM vue_abonnes_details as vad

WHERE vad.prochain_numero BETWEEN vad.premier_numero and vad.dernier_numero 
and vad.revue_id = 1
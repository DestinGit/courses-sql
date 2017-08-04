SELECT 
vad.titre_revue,
vad.num_abonne,
vad.nom,
vad.prenom,
vad.nb_numeros_a_servir,
CASE
	WHEN vad.nb_numeros_a_servir = -1
		THEN 'Relance 3'
    WHEN vad.nb_numeros_a_servir = -3 
		THEN 'Relance 4'
END as relance

FROM vue_abonnes_details as vad

WHERE vad.nb_numeros_a_servir IN (-1,-3)
and vad.revue_id = 1
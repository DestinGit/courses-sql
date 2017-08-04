SELECT 
vad.titre_revue,
count(distinct num_abonne) as nb_abonnes,
dernier_numero
prochain_numero,
SUM(
	prix_unitaire * nb_numeros_a_servir
) as dette_abonne


FROM vue_abonnement_details as vad

WHERE nb_numeros_a_servir >0

GROUP BY revue_id;
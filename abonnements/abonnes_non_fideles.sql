SELECT num_abonne, titre_revue, nb_numeros, 
ROUND(nb_numeros / nb_numero_par_an, 2) as duree_abonnement
FROM vue_abonnes_details as vad
WHERE nb_numeros != nb_numeros_intervalle;
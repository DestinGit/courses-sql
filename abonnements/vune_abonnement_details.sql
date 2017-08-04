CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vue_abonnement_details` AS
    SELECT 
        `abonnement_client`.`id` AS `abonnement_id`,
        `abonnement_client`.`date_abonnement` AS `date_abonnement`,
        `abonnement_client`.`offre_id` AS `offre_id`,
        `abonnement_client`.`num_abonne` AS `num_abonne`,
        `client`.`nom` AS `nom`,
        `client`.`prenom` AS `prenom`,
        `abonnement_client`.`montant` AS `montant`,
        `abonnement_client`.`premier_numero` AS `premier_numero`,
        `abonnement_client`.`dernier_numero` AS `dernier_numero`,
        `echeance_debut`.`date_parution` AS `date_debut_abon`,
        `echeance_fin`.`date_parution` AS `date_fin_abon`,
        ROUND(((((`abonnement_client`.`dernier_numero` - `abonnement_client`.`premier_numero`) + 1) / `periodicite`.`nb_numero_par_an`) * 12),
                0) AS `duree_abon`,
        ((`abonnement_client`.`dernier_numero` - `abonnement_client`.`premier_numero`) + 1) AS `nb_numeros`,
        CAST((`abonnement_client`.`montant` / ((`abonnement_client`.`dernier_numero` - `abonnement_client`.`premier_numero`) + 1))
            AS DECIMAL (5 , 2 )) AS `prix_unitaire`,
        `offre_abonnement`.`libelle` AS `libelle_offre`,
        `offre_abonnement`.`tarif` AS `tarif`,
        `offre_abonnement`.`revue_id` AS `revue_id`,
        `revue`.`titre` AS `titre_revue`,
        `periodicite`.`libelle` AS `periodicite`,
        `periodicite`.`intervalle` AS `intervalle`,
        `periodicite`.`nb_numero_par_an` AS `nb_numero_par_an`,
        (SELECT 
                MIN(`echeance_revue`.`numero`)
            FROM
                `echeance_revue`
            WHERE
                ((`echeance_revue`.`revue_id` = `offre_abonnement`.`revue_id`)
                    AND (`echeance_revue`.`date_parution` > CURDATE()))) AS `prochain_numero`,
        CAST(((`abonnement_client`.`dernier_numero` / 1) - (SELECT 
                    MIN(`echeance_revue`.`numero`)
                FROM
                    `echeance_revue`
                WHERE
                    ((`echeance_revue`.`revue_id` = `offre_abonnement`.`revue_id`)
                        AND (`echeance_revue`.`date_parution` > CURDATE()))))
            AS UNSIGNED) AS `nb_numeros_a_servir`
    FROM
        ((((((`abonnement_client`
        JOIN `client` ON ((`abonnement_client`.`num_abonne` = `client`.`num_abonne`)))
        JOIN `offre_abonnement` ON ((`abonnement_client`.`offre_id` = `offre_abonnement`.`id`)))
        JOIN `revue` ON ((`offre_abonnement`.`revue_id` = `revue`.`id`)))
        JOIN `periodicite` ON ((`revue`.`periodicite_id` = `periodicite`.`id`)))
        LEFT JOIN `echeance_revue` `echeance_debut` ON (((`echeance_debut`.`revue_id` = `offre_abonnement`.`revue_id`)
            AND (`echeance_debut`.`numero` = `abonnement_client`.`premier_numero`))))
        LEFT JOIN `echeance_revue` `echeance_fin` ON (((`echeance_fin`.`revue_id` = `offre_abonnement`.`revue_id`)
            AND (`echeance_fin`.`numero` = `abonnement_client`.`dernier_numero`))))
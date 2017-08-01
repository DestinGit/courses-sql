# importation des données du fichier dans une table temporaire
LOAD DATA INFILE 'c:/Destin/ventes.csv'
INTO TABLE import_vente
FIELDS
	TERMINATED BY ';'
LINES
	TERMINATED BY '\r\n'
IGNORE
	1 LINES
    
(vendeur, @dateVente, montant, departement)

SET date_vente = str_to_date(@dateVente, '%d/%m/%Y')
;

# Mise à jour l'id des vendeurs
UPDATE import_vente as iv INNER JOIN personnes as p ON p.nom = iv.vendeur
SET iv.vendeur_id = p.personne_id;

# Mise à jour des départements
UPDATE import_vente as iv INNER JOIN departements as d ON d.nom_departement = iv.departement
SET iv.id_departement = d.departement_id;

# Insertion des donnees
INSERT INTO ventes (date_vente, montant, departement_id, vendeur_id)
(
	SELECT date_vente, montant, id_departement, id_vendeur FROM import_vente
    WHERE id_departement is not null and id_vendeur is not null
)

# RAZ de la table import
# DROP TABLE IF EXISTS import_vente;
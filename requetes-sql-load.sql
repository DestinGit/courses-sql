LOAD DATA INFILE 'c:/Destin/personne.csv'
INTO TABLE personnes
FIELDS
	TERMINATED BY ';'
LINES
	TERMINATED BY '\n'
(nom, date_naissance)
;
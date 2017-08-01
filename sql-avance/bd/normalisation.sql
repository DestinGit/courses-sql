DROP DATABASE IF EXISTS normalisation_bd;
CREATE DATABASE normalisation_bd CHARACTER SET=utf8  COLLATE=utf8_unicode_ci;

USE normalisation_bd;

DROP TABLE IF EXISTS clients;

CREATE TABLE personnes (
	nom VARCHAR(30),
	prenom VARCHAR(30),
	age INT,
	tel1 VARCHAR(10),
	tel2 VARCHAR(10),
	tel3 VARCHAR(10),
	email1 VARCHAR(30),
	email2 VARCHAR(30),
	amis TEXT,
	adresse VARCHAR(80),
	code_postal VARCHAR(5),
	ville VARCHAR(30),
	region VARCHAR(30),
	animal_nom VARCHAR(30),
	animal_type VARCHAR(30),
	PRIMARY KEY(nom, prenom)
)ENGINE=InnoDB;

INSERT INTO personnes VALUES
(	'MARTIN', 'Paul', 43, '0978563489', NULL, NULL, 
	'pmartin@yahoo.com', NULL, 'Jean Hebert, Pauline HUR', 
	'12 rue de Passy','75116', 'Paris','Ile de France', 
	'velour', 'chat'
),
(	'HEBERT', 'Jean', 37, '0645873951', '0476024532', NULL, 
	'jhebert@live.com', NULL, 'Pauline HUR', 
	'4 grande rue','25440', 'Abbans dessus','Franche Comté', 
	'Pilou', 'chien'
),
(	'HUR', 'Pauline', 34, '0634094512', NULL, '038956430945', 
	'phur66@hotmail.com', NULL, 'Paul Martin', 
	'67 rue de la République','69001', 'Lyon','Rhône Alpe', 
	NULL, NULL
);

CREATE TABLE activites (
	nom VARCHAR(30),
	prenom VARCHAR(30),
	activite VARCHAR(30),
	type_activite VARCHAR(30),
	lieu_activite VARCHAR(30),
	professeur VARCHAR(50),
    qualification_prof VARCHAR(50),
	jour VARCHAR(20),
	heure VARCHAR(10),
    cotisation_2013 INT,
    cotisation_2014 INT,
    cotisation_2015 INT,
    cotisation_2016 INT,
	PRIMARY KEY(nom, prenom, activite)
)ENGINE=InnoDB;

INSERT INTO activites VALUES
(	'MARTIN', 'Paul', 'dessin', 'art plastique', 
	'cours Koronin 5 rue des blancs manteaux 75004 Paris',
	'Jacques Koronin', 'DNAP', 'mardi et jeudi', '19H, 20H30',
    200, 200, 215, 225
),

(	'MARTIN', 'Paul', 'natation', 'sport', 
	'Piscine d\'Auteuil 1 route des lacs Passy',
	'Daniel Hydrophile','BNSSA', 'lundi','19H',
    NULL, NULL, 80, 80
);
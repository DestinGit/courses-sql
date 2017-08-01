DROP DATABASE IF EXISTS odelice;
CREATE DATABASE odelice;

USE odelice;

SET FOREIGN_KEY_CHECKS = 0;


CREATE TABLE recette (
    id INT UNSIGNED AUTO_INCREMENT,
    titre VARCHAR(50) NOT NULL,
    image VARCHAR(30),
    preparation TEXT NOT NULL,
    id_difficulte TINYINT UNSIGNED NOT NULL,
    id_auteur INT UNSIGNED NOT NULL,
    PRIMARY KEY (id)
)ENGINE=innodb CHARSET=utf8 COLLATE = utf8_general_ci;

CREATE TABLE auteurs (
    id INT UNSIGNED AUTO_INCREMENT,
    nom VARCHAR(30) NOT NULL,
    PRIMARY KEY (id)
)ENGINE=innodb CHARSET=utf8 COLLATE = utf8_general_ci;

CREATE TABLE difficultes (
    id TINYINT UNSIGNED AUTO_INCREMENT,
    difficulte_numerique TINYINT UNSIGNED NOT NULL UNIQUE,
    difficulte_texte VARCHAR(30) NOT NULL UNIQUE,
    PRIMARY KEY (id)
)ENGINE=innodb CHARSET=utf8 COLLATE = utf8_general_ci;

CREATE TABLE categorie_temps (
    id TINYINT UNSIGNED AUTO_INCREMENT,
    libelle VARCHAR(30) NOT NULL UNIQUE,
    PRIMARY KEY (id)
)ENGINE=innodb CHARSET=utf8 COLLATE = utf8_general_ci;

CREATE TABLE temps_recettes (
    id_categorie TINYINT UNSIGNED,
    id_recette INT UNSIGNED,
    PRIMARY KEY (id_categorie, id_recette)
)ENGINE=innodb CHARSET=utf8 COLLATE = utf8_general_ci;

CREATE TABLE unites (
    id TINYINT UNSIGNED AUTO_INCREMENT,
    libelle VARCHAR(30) NOT NULL UNIQUE,
    abbreviation VARCHAR(5) NOT NULL,
    PRIMARY KEY (id)
)ENGINE=innodb CHARSET=utf8 COLLATE = utf8_general_ci;

CREATE TABLE categorie_ingredients (
    id TINYINT UNSIGNED AUTO_INCREMENT,
    libelle VARCHAR(30) NOT NULL UNIQUE,
    PRIMARY KEY (id)
)ENGINE=innodb CHARSET=utf8 COLLATE = utf8_general_ci;

CREATE TABLE ingredients (
    id SMALLINT UNSIGNED AUTO_INCREMENT,
    ingredient VARCHAR(30) NOT NULL UNIQUE,
    id_categorie TINYINT UNSIGNED NOT NULL,
    PRIMARY KEY (id)
)ENGINE=innodb CHARSET=utf8 COLLATE = utf8_general_ci;

CREATE TABLE recettes_ingredients (
    id_ingredient SMALLINT UNSIGNED,
    id_recette INT UNSIGNED,
    qt SMALLINT UNSIGNED,
    id_unite TINYINT UNSIGNED,
    PRIMARY KEY (id_ingredient, id_recette)
)ENGINE=innodb CHARSET=utf8 COLLATE = utf8_general_ci;

ALTER TABLE recette ADD CONSTRAINT recette_to_difficulte
FOREIGN KEY(id_difficulte)
REFERENCES difficultes(id);

ALTER TABLE recette ADD CONSTRAINT recette_to_auteur
FOREIGN KEY(id_auteur)
REFERENCES auteurs(id);

ALTER TABLE temps_recettes ADD CONSTRAINT temps_to_recettes
FOREIGN KEY (id_recette)
REFERENCES recettes(id);

ALTER TABLE temps_recettes ADD CONSTRAINT temps_to_categorie
FOREIGN KEY (id_categorie)
REFERENCES categorie_temps(id);

ALTER TABLE ingredients ADD CONSTRAINT ingredients_to_categorie
FOREIGN KEY (id_categorie)
REFERENCES categorie_ingredients(id);

ALTER TABLE recettes_ingredients ADD CONSTRAINT recettes_ingredients_to_recette
FOREIGN KEY (id_recette)
REFERENCES recettes(id);


ALTER TABLE recettes_ingredients ADD CONSTRAINT recettes_ingredients_to_ingredients
FOREIGN KEY (id_ingredient)
REFERENCES ingredients(id);


ALTER TABLE recettes_ingredients ADD CONSTRAINT recettes_ingredients_to_unite
FOREIGN KEY (id_unite)
REFERENCES unites(id);

SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO categorie_temps (libelle)
VALUES 
('temps de préparation'), 
('temps de cuisson'), 
('temps de repos');

INSERT INTO difficultes (difficulte_numerique, difficulte_texte)
VALUES
(1, 'très facile'),
(2, 'facile'),
(3, 'moyen'),
(4, 'difficile'),
(5, 'très difficile')

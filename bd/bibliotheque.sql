DROP DATABASE IF EXISTS bibliotheque;

CREATE DATABASE bibliotheque DEFAULT CHARACTER SET=utf8  COLLATE=utf8_general_ci;

USE bibliotheque;

SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `auteurs`
-- ----------------------------
DROP TABLE IF EXISTS `auteurs`;
CREATE TABLE `auteurs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nom` varchar(50) DEFAULT NULL,
  `prenom` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `auteurs`
-- ----------------------------
BEGIN;
INSERT INTO `auteurs` VALUES ('1', 'Adams', 'Douglas'), ('2', 'Herbert', 'Frank'), ('3', 'Sartre', 'J.P.'), ('4', 'Lordon', 'F.'), ('5', 'Brin', 'David'), ('6', 'Kant', 'Emmanuel'), ('7', 'Alain', ''), ('8', 'Asimov', 'Isaac'), ('9', 'Heinlein', 'Robert'), ('10', 'Platon', ''), ('11', 'Pascal', 'Blaise'), ('12', 'Martin', 'Robert'), ('13', 'Celko', 'Joe'), ('14', 'Soutou', 'Christian'), ('15', 'Highsmith', 'Patricia'), ('16', 'Karwin', 'Bill'), ('17', 'Hunt', 'Andrew'), ('18', 'Hugo', 'Victor'), ('19', 'Herbert', 'Frank');
COMMIT;

-- ----------------------------
--  Table structure for `editeurs`
-- ----------------------------
DROP TABLE IF EXISTS `editeurs`;
CREATE TABLE `editeurs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nom` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `editeurs`
-- ----------------------------
BEGIN;
INSERT INTO `editeurs` VALUES ('1', 'Grasset'), ('2', 'Hachette'), ('3', 'PUF'), ('4', 'Robert Laffont'), ('5', 'Dunod'), ('6', 'Eyrolles'), ('7', 'La Fabrique'), ('8', 'Morgan Kauffmann'), ('9', 'O\'Reilly'), ('10', 'Addison Wesley');
COMMIT;

-- ----------------------------
--  Table structure for `genres`
-- ----------------------------
DROP TABLE IF EXISTS `genres`;
CREATE TABLE `genres` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `genre` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `genres`
-- ----------------------------
BEGIN;
INSERT INTO `genres` VALUES ('1', 'Science fiction'), ('2', 'Essai'), ('3', 'Philosophie'), ('4', 'Informatique'), ('5', 'Roman policier'), ('6', 'Théâtre');
COMMIT;

-- ----------------------------
--  Table structure for `livres`
-- ----------------------------
DROP TABLE IF EXISTS `livres`;
CREATE TABLE `livres` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `titre` varchar(100) NOT NULL,
  `prix` float(5,2) NOT NULL,
  `editeur_id` int(10) unsigned NOT NULL,
  `auteur_id` int(10) unsigned NOT NULL,
  `genre_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `livres_to_editeur` (`editeur_id`),
  KEY `livres_to_auteur` (`auteur_id`),
  KEY `livres_to_genre` (`genre_id`),
  CONSTRAINT `livres_to_auteur` FOREIGN KEY (`auteur_id`) REFERENCES `auteurs` (`id`),
  CONSTRAINT `livres_to_editeur` FOREIGN KEY (`editeur_id`) REFERENCES `editeurs` (`id`),
  CONSTRAINT `livres_to_genre` FOREIGN KEY (`genre_id`) REFERENCES `genres` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `livres`
-- ----------------------------
BEGIN;
INSERT INTO `livres` VALUES ('1', 'Le guide du routard intergallactique', '13.00', '1', '1', '1'), ('2', 'Dune', '18.00', '2', '2', '1'), ('3', 'La nausée', '12.50', '3', '3', '2'), ('4', 'Désir et servitude', '9.00', '3', '4', '2'), ('5', 'Elévation', '11.00', '1', '5', '1'), ('6', 'Critique de la raison pure', '12.00', '3', '6', '3'), ('7', 'Propos sur le bonheur', '9.00', '3', '7', '3'), ('8', 'Fondation', '14.00', '4', '8', '1'), ('9', 'En terre étrangère', '10.00', '4', '9', '1'), ('10', 'La République', '8.00', '3', '10', '3'), ('11', 'Pensées', '11.00', '2', '11', '3'), ('12', 'Discours de la méthode', '9.00', '2', '11', '3'), ('13', 'Coder proprement', '18.00', '5', '12', '4'), ('14', 'SQL Avancé', '45.00', '5', '13', '4'), ('15', 'Programmer avec MySQL', '35.00', '6', '14', '4'), ('16', 'Crimes presque parfaits', '28.00', '2', '15', '5'), ('17', 'Carol', '22.00', '2', '15', '5'), ('18', 'Des chats et des hommes', '22.00', '2', '15', '5'), ('19', 'Sur les pas de Ripley', '22.00', '2', '15', '5'), ('20', 'L\'inconnu du Nord Express', '22.00', '2', '15', '5'), ('21', 'Ripley et les ombres', '22.00', '2', '15', '5'), ('26', 'D\'un retournement l\'autre', '9.00', '7', '4', '6'), ('27', 'Imperium', '15.00', '7', '4', '2'), ('28', 'Et la vertu sauvera le monde', '6.00', '7', '4', '2'), ('29', 'Economistes à gages', '7.50', '7', '4', '2'), ('30', 'SQL for smarties', '55.86', '8', '13', '4'), ('31', 'Data and Databases : Concepts in Practice', '67.47', '8', '13', '4'), ('32', 'Thinking in Sets : Auxiliary, Temporal, and Virtual Tables in SQL', '28.43', '8', '13', '4'), ('33', 'SQL Antipatterns', '33.44', '9', '16', '4'), ('34', 'The pragmatic programmer : Form journeyman to master', '33.85', '10', '17', '4');
COMMIT;

-- ----------------------------
--  Procedure structure for `cumul`
-- ----------------------------
DROP PROCEDURE IF EXISTS `cumul`;
delimiter ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cumul`(IN montant INT, INOUT total INT)
SET total := total + montant
 ;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;

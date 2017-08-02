-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Client :  127.0.0.1
-- Généré le :  Mer 02 Août 2017 à 16:48
-- Version du serveur :  10.1.10-MariaDB
-- Version de PHP :  7.0.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données :  `cours`
--

DELIMITER $$
--
-- Procédures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `clients_vendeurs` (`param_cp` CHAR(5))  BEGIN
	SELECT t.*, villes.nom_ville FROM
	(
		SELECT id_client as id, nom, cp, 'client' as categorie FROM clients
		UNION
		SELECT id_vendeur, nom, cp, 'vendeur' FROM vendeurs
	) as t
	INNER JOIN villes ON t.cp = villes.cp
    WHERE t.cp = param_cp
	ORDER BY cp;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertion_client` (`param_nom` VARCHAR(50), `param_prenom` VARCHAR(50), `param_adresse` VARCHAR(100), `param_date_naissance` DATE, `param_cp` CHAR(5), `param_ville` VARCHAR(50), `param_pays` VARCHAR(50), OUT `param_idClient` INT)  BEGIN
	DECLARE v_idClient INT;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SELECT false as success, @erreur as message;
		END;
    	
    -- Récupération de l'identifiant du client que je veux insérer
    SELECT id_client FROM clients WHERE nom = param_nom AND prenom = param_prenom
    INTO v_idClient;
    
    IF v_idClient IS NULL THEN
		
        CALL insert_ville(param_ville, param_cp, param_pays);
        
		INSERT INTO clients(nom, prenom,adresse, date_naissance, cp)
		VALUES (param_nom, param_prenom, param_adresse, param_date_naissance, param_cp);
		
		-- Récupération de la valeur du dernier id auto
		SET param_idClient := LAST_INSERT_ID();
	ELSE
        SET param_idClient := v_idClient;
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_ville` (`p_ville` VARCHAR(50), `p_codePostal` CHAR(50), `p_pays` VARCHAR(50))  BEGIN
	DECLARE v_villeExiste TINYINT UNSIGNED;
    DECLARE v_codePays CHAR(4);
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SELECT false as success, @erreur as message;
        END;
    
    SET v_villeExiste := EXISTS(SELECT cp FROM villes WHERE cp = p_codePostal AND nom_ville = p_ville);
    
    IF NOT v_villeExiste THEN
		-- récupération du code pays
        SET v_codePays := (SELECT id_pays FROM pays WHERE nom_pays = p_pays);
        
        IF v_codePays IS NOT NULL THEN
			INSERT INTO villes (cp, nom_ville, id_pays)
            VALUES(p_codePostal, p_ville, v_codePays);
		ELSE
            -- TODO retourner une erreur
            SET @erreur = 'Le pays n\'existe pas';
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Le pays n\'existe pas';
        END IF;
    END IF;
END$$

--
-- Fonctions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `alea` (`p_min` INT, `p_max` INT) RETURNS INT(11) BEGIN
	DECLARE tmp INT;
	IF p_min > p_max THEN
		SET tmp := p_min;
		SET p_min := p_max;
		SET p_max := p_min;
	END IF;
	RETURN p_min + FLOOR(RAND() * (p_max - p_min));
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `cdes`
--

CREATE TABLE `cdes` (
  `id_cde` int(5) NOT NULL,
  `date_cde` date NOT NULL,
  `id_client` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Contenu de la table `cdes`
--

INSERT INTO `cdes` (`id_cde`, `date_cde`, `id_client`) VALUES
(1, '2005-10-03', 1),
(2, '2005-10-10', 2),
(3, '2005-11-01', 1),
(4, '2000-11-01', 1),
(5, '2000-12-10', 2),
(6, '2017-08-02', 1),
(7, '2017-08-02', 2),
(8, '2017-08-02', 5),
(9, '2017-08-02', 4);

-- --------------------------------------------------------

--
-- Structure de la table `clients`
--

CREATE TABLE `clients` (
  `id_client` int(5) NOT NULL,
  `nom` varchar(50) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `prenom` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `adresse` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_naissance` date DEFAULT NULL,
  `cp` char(5) COLLATE utf8_unicode_ci NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Contenu de la table `clients`
--

INSERT INTO `clients` (`id_client`, `nom`, `prenom`, `adresse`, `date_naissance`, `cp`) VALUES
(1, 'Buguet', 'Pascal', NULL, '1955-10-03', '75011'),
(2, 'Buguet', 'MJ', NULL, '1948-08-22', '75011'),
(3, 'Fassiola', 'Annabelle', NULL, '1985-05-10', '75011'),
(4, 'Roux', 'Fran├ºoise', NULL, '1950-10-10', '59000'),
(5, 'Tintin', 'Albert', NULL, NULL, '75011'),
(6, 'Sordi', 'Alberto', NULL, NULL, '99391'),
(7, 'Muti', 'Ornella', NULL, NULL, '99392'),
(8, 'Milou', 'Le chien', NULL, NULL, '75019'),
(9, 'Tournesol', 'Bruno', NULL, NULL, '94100'),
(10, 'Roberts', 'Julia', NULL, '1965-10-03', '75011'),
(12, 'Mopao', 'Quadra', '148 rue picpus', '1979-01-31', '75012'),
(13, 'Yemei', 'Mokonzi', '148 rue picpus', '1979-01-31', '75012'),
(14, 'Mopao', 'Mokonzi', '148 rue picpus', '1979-01-31', '75012'),
(15, 'Jean', 'Bernard', '146 rue picpus', '1970-01-12', '94000'),
(16, 'Jean', 'Bernard', '146 rue picpus', '1970-01-12', '94000');

--
-- Déclencheurs `clients`
--
DELIMITER $$
CREATE TRIGGER `clients_BEFORE_INSERT` BEFORE INSERT ON `clients` FOR EACH ROW BEGIN
	INSERT INTO historique(nom_table, nom_colonne, operation, nouvelle_valeur)
    VALUES
    ('clients', 'nom', 'insert', NEW.nom),
    ('clients', 'prenom', 'insert', NEW.prenom),
    ('clients', 'cp', 'insert', NEW.cp);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `clients_BEFORE_UPDATE` BEFORE UPDATE ON `clients` FOR EACH ROW BEGIN
	INSERT INTO historique(nom_table, nom_colonne, operation, nouvelle_valeur, ancienne_valeur)
    VALUES
    ('clients', 'nom', 'insert', NEW.nom, OLD.nom),
    ('clients', 'prenom', 'insert', NEW.prenom, OLD.prenom),
    ('clients', 'cp', 'insert', NEW.cp, OLD.cp);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `historique`
--

CREATE TABLE `historique` (
  `id` int(10) UNSIGNED NOT NULL,
  `nom_table` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `nom_colonne` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `operation` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `ancienne_valeur` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `nouvelle_valeur` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `horodatage` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Contenu de la table `historique`
--

INSERT INTO `historique` (`id`, `nom_table`, `nom_colonne`, `operation`, `ancienne_valeur`, `nouvelle_valeur`, `horodatage`) VALUES
(1, 'clients', 'nom', 'insert', 'JeanA', 'Jean', '2017-08-02 14:42:51'),
(2, 'clients', 'prenom', 'insert', 'BernardA', 'Bernard', '2017-08-02 14:42:51'),
(3, 'clients', 'cp', 'insert', '94000', '94000', '2017-08-02 14:42:51');

-- --------------------------------------------------------

--
-- Structure de la table `ligcdes`
--

CREATE TABLE `ligcdes` (
  `id_cde` int(5) NOT NULL,
  `id_produit` int(5) NOT NULL,
  `qte` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Contenu de la table `ligcdes`
--

INSERT INTO `ligcdes` (`id_cde`, `id_produit`, `qte`) VALUES
(1, 1, 2),
(1, 2, 3),
(2, 1, 2),
(3, 1, 6),
(3, 2, 2),
(3, 3, 1),
(4, 1, 5),
(5, 4, 10),
(6, 1, 1),
(6, 2, 1),
(6, 3, 1),
(6, 4, 1),
(7, 4, 100),
(8, 1, 10),
(9, 1, 10);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `new_view`
--
CREATE TABLE `new_view` (
`id` int(5)
,`nom` varchar(50)
,`cp` char(5)
,`categorie` varchar(6)
);

-- --------------------------------------------------------

--
-- Structure de la table `pays`
--

CREATE TABLE `pays` (
  `id_pays` char(4) COLLATE utf8_unicode_ci NOT NULL,
  `nom_pays` varchar(50) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Contenu de la table `pays`
--

INSERT INTO `pays` (`id_pays`, `nom_pays`) VALUES
('033', 'France'),
('034', 'Espagne'),
('035', 'Angleterre'),
('039', 'Italie');

-- --------------------------------------------------------

--
-- Structure de la table `produits`
--

CREATE TABLE `produits` (
  `id_produit` int(5) NOT NULL,
  `designation` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `prix` double(7,2) NOT NULL,
  `qte_stockee` int(5) DEFAULT '0',
  `photo` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Contenu de la table `produits`
--

INSERT INTO `produits` (`id_produit`, `designation`, `prix`, `qte_stockee`, `photo`) VALUES
(1, 'Evian', 1.81, 10, 'evian.jpg'),
(2, 'Badoit', 1.93, 10, 'badoit.jpg'),
(3, 'Graves', 13.20, 10, 'graves.jpg'),
(4, 'Ruinard', 110.00, 10, 'ruinard.jpg'),
(5, 'Dom P├®rignon', 165.00, 10, 'dom.jpg'),
(7, 'Picpoul', 5.00, 500, NULL),
(8, 'Picmal', 5.00, 10, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `utilisateurs`
--

CREATE TABLE `utilisateurs` (
  `pseudo` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `mdp` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `e_mail` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `qualite` varchar(50) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Contenu de la table `utilisateurs`
--

INSERT INTO `utilisateurs` (`pseudo`, `mdp`, `e_mail`, `qualite`) VALUES
('a', 'f', 'af@free.fr', 'FO'),
('p', 'b', 'pb@free.fr', 'BO');

-- --------------------------------------------------------

--
-- Structure de la table `vendeurs`
--

CREATE TABLE `vendeurs` (
  `id_vendeur` int(10) UNSIGNED NOT NULL,
  `nom` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `chef` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `cp` char(5) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Contenu de la table `vendeurs`
--

INSERT INTO `vendeurs` (`id_vendeur`, `nom`, `chef`, `cp`) VALUES
(1, 'Lucky', 1, '75011'),
(2, 'Dalton', 1, '75012'),
(3, 'Mickey', 1, '75012'),
(4, 'Donald', 2, '75011');

-- --------------------------------------------------------

--
-- Structure de la table `vendeurs_villes`
--

CREATE TABLE `vendeurs_villes` (
  `id_vendeur` int(10) UNSIGNED NOT NULL,
  `cp` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  `Date_debut` date NOT NULL DEFAULT '0000-00-00',
  `date_fin` date NOT NULL DEFAULT '0000-00-00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Contenu de la table `vendeurs_villes`
--

INSERT INTO `vendeurs_villes` (`id_vendeur`, `cp`, `Date_debut`, `date_fin`) VALUES
(1, '75011', '2006-01-01', '2006-12-31'),
(1, '75011', '2007-01-01', '2007-12-31'),
(2, '75011', '2006-01-01', '2006-12-31'),
(2, '75012', '2007-01-01', '2007-12-31'),
(3, '75011', '2007-01-01', '2007-12-31'),
(3, '75012', '2006-01-01', '2006-12-31');

-- --------------------------------------------------------

--
-- Structure de la table `ventes`
--

CREATE TABLE `ventes` (
  `id_vendeur` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `id_produit` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `vente` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `date_vente` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Contenu de la table `ventes`
--

INSERT INTO `ventes` (`id_vendeur`, `id_produit`, `vente`, `date_vente`) VALUES
(1, 1, 20, '2007-04-16'),
(1, 2, 100, '2007-04-16'),
(2, 1, 1, '2007-04-16'),
(2, 2, 10, '2008-04-16'),
(2, 3, 5, '2008-04-16');

-- --------------------------------------------------------

--
-- Structure de la table `ventes_croisees`
--

CREATE TABLE `ventes_croisees` (
  `nom_vendeur` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `designation` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `vente` int(10) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Contenu de la table `ventes_croisees`
--

INSERT INTO `ventes_croisees` (`nom_vendeur`, `designation`, `vente`) VALUES
('Casta', 'Evian', 20),
('Casta', 'Graves', 5),
('Haddock', 'Badoit', 1),
('Haddock', 'Evian', 1),
('Haddock', 'Graves', 10),
('Tintin', 'Badoit', 5),
('Tintin', 'Evian', 10),
('Tintin', 'Graves', 10);

-- --------------------------------------------------------

--
-- Structure de la table `villes`
--

CREATE TABLE `villes` (
  `cp` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  `nom_ville` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `site` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `photo` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `id_pays` char(4) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Contenu de la table `villes`
--

INSERT INTO `villes` (`cp`, `nom_ville`, `site`, `photo`, `id_pays`) VALUES
('13000', 'Marseille', 'www.ma.net', NULL, '033'),
('24200', 'Sarlat', NULL, NULL, '033'),
('24300', 'Carsac', NULL, NULL, '033'),
('24400', 'Aillac', NULL, NULL, '033'),
('59000', 'Lille', 'www.lille.fr', 'lille.jpg', '033'),
('69000', 'Lyon', 'www.lyon.fr', 'lyon.jpg', '033'),
('75011', 'Paris 11', 'www.paris.fr', 'paris.jpg', '033'),
('75012', 'Paris 12', 'www.paris.fr', 'paris.jpg', '033'),
('75019', 'Paris XIX', 'www.paris.fr', 'paris.jpg', '033'),
('78000', 'Versailles', NULL, NULL, '033'),
('94000', 'Créteil', NULL, NULL, '033'),
('94100', 'Vincennes', NULL, NULL, '033'),
('94200', 'St Mand├®', NULL, NULL, '033'),
('94400', 'vitry sur seine', NULL, NULL, '033'),
('99391', 'ROME', NULL, NULL, '039'),
('99392', 'MILAN', NULL, NULL, '039');

-- --------------------------------------------------------

--
-- Structure de la vue `new_view`
--
DROP TABLE IF EXISTS `new_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `new_view`  AS  select `clients`.`id_client` AS `id`,`clients`.`nom` AS `nom`,`clients`.`cp` AS `cp`,'client' AS `categorie` from `clients` ;

--
-- Index pour les tables exportées
--

--
-- Index pour la table `cdes`
--
ALTER TABLE `cdes`
  ADD PRIMARY KEY (`id_cde`),
  ADD KEY `FK_cdes_client` (`id_client`);

--
-- Index pour la table `clients`
--
ALTER TABLE `clients`
  ADD PRIMARY KEY (`id_client`),
  ADD KEY `Index_cp` (`cp`);

--
-- Index pour la table `historique`
--
ALTER TABLE `historique`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `ligcdes`
--
ALTER TABLE `ligcdes`
  ADD PRIMARY KEY (`id_cde`,`id_produit`),
  ADD KEY `FK_ligcdes_id_produit` (`id_produit`);

--
-- Index pour la table `pays`
--
ALTER TABLE `pays`
  ADD PRIMARY KEY (`id_pays`);

--
-- Index pour la table `produits`
--
ALTER TABLE `produits`
  ADD PRIMARY KEY (`id_produit`);

--
-- Index pour la table `utilisateurs`
--
ALTER TABLE `utilisateurs`
  ADD PRIMARY KEY (`pseudo`),
  ADD UNIQUE KEY `e_mail` (`e_mail`);

--
-- Index pour la table `vendeurs`
--
ALTER TABLE `vendeurs`
  ADD PRIMARY KEY (`id_vendeur`),
  ADD KEY `FK_vendeurs_cp` (`cp`),
  ADD KEY `FK_vendeurs_id_vendeur` (`chef`);

--
-- Index pour la table `vendeurs_villes`
--
ALTER TABLE `vendeurs_villes`
  ADD PRIMARY KEY (`id_vendeur`,`cp`,`Date_debut`),
  ADD KEY `cp` (`cp`);

--
-- Index pour la table `ventes`
--
ALTER TABLE `ventes`
  ADD PRIMARY KEY (`id_vendeur`,`id_produit`,`vente`);

--
-- Index pour la table `ventes_croisees`
--
ALTER TABLE `ventes_croisees`
  ADD PRIMARY KEY (`nom_vendeur`,`designation`);

--
-- Index pour la table `villes`
--
ALTER TABLE `villes`
  ADD PRIMARY KEY (`cp`),
  ADD KEY `Index_id_pays` (`id_pays`);

--
-- AUTO_INCREMENT pour les tables exportées
--

--
-- AUTO_INCREMENT pour la table `cdes`
--
ALTER TABLE `cdes`
  MODIFY `id_cde` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
--
-- AUTO_INCREMENT pour la table `clients`
--
ALTER TABLE `clients`
  MODIFY `id_client` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;
--
-- AUTO_INCREMENT pour la table `historique`
--
ALTER TABLE `historique`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT pour la table `produits`
--
ALTER TABLE `produits`
  MODIFY `id_produit` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT pour la table `vendeurs`
--
ALTER TABLE `vendeurs`
  MODIFY `id_vendeur` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT pour la table `vendeurs_villes`
--
ALTER TABLE `vendeurs_villes`
  MODIFY `id_vendeur` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- Contraintes pour les tables exportées
--

--
-- Contraintes pour la table `cdes`
--
ALTER TABLE `cdes`
  ADD CONSTRAINT `FK_cdes_client` FOREIGN KEY (`id_client`) REFERENCES `clients` (`id_client`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `clients`
--
ALTER TABLE `clients`
  ADD CONSTRAINT `FK_clients_cp` FOREIGN KEY (`cp`) REFERENCES `villes` (`cp`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `ligcdes`
--
ALTER TABLE `ligcdes`
  ADD CONSTRAINT `FK_ligcdes_cde` FOREIGN KEY (`id_cde`) REFERENCES `cdes` (`id_cde`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_ligcdes_produit` FOREIGN KEY (`id_produit`) REFERENCES `produits` (`id_produit`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `vendeurs`
--
ALTER TABLE `vendeurs`
  ADD CONSTRAINT `FK_vendeurs_cp` FOREIGN KEY (`cp`) REFERENCES `villes` (`cp`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_vendeurs_id_vendeur` FOREIGN KEY (`chef`) REFERENCES `vendeurs` (`id_vendeur`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `vendeurs_villes`
--
ALTER TABLE `vendeurs_villes`
  ADD CONSTRAINT `FK_vv_cp` FOREIGN KEY (`cp`) REFERENCES `villes` (`cp`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_vv_vendeur` FOREIGN KEY (`id_vendeur`) REFERENCES `vendeurs` (`id_vendeur`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `ventes`
--
ALTER TABLE `ventes`
  ADD CONSTRAINT `FK_ventes_vendeur` FOREIGN KEY (`id_vendeur`) REFERENCES `vendeurs` (`id_vendeur`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `villes`
--
ALTER TABLE `villes`
  ADD CONSTRAINT `FK_villes_pays` FOREIGN KEY (`id_pays`) REFERENCES `pays` (`id_pays`) ON DELETE CASCADE ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

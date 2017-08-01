-- BD cours
USE cours;

SET FOREIGN_KEY_CHECKS = 0;

-- Contenu de la table pays

INSERT INTO pays (id_pays, nom_pays) VALUES
('033', 'France'),
('034', 'Espagne'),
('035', 'Angleterre'),
('039', 'Italie');

-- Contenu de la table villes

INSERT INTO villes (cp, nom_ville, site, photo, id_pays) VALUES
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
('94100', 'Vincennes', NULL, NULL, '033'),
('94200', 'St Mandé', NULL, NULL, '033'),
('99391', 'ROME', NULL, NULL, '039'),
('99392', 'MILAN', NULL, NULL, '039');

-- Contenu de la table clients

INSERT INTO clients (id_client, nom, prenom, adresse, date_naissance, cp) VALUES
(1, 'Buguet', 'Pascal', NULL, '1955-10-03', '75011'),
(2, 'Buguet', 'MJ', NULL, '1948-08-22', '75011'),
(3, 'Fassiola', 'Annabelle', NULL, '1985-05-10', '75011'),
(4, 'Roux', 'Françoise', NULL, '1950-10-10', '59000'),
(5, 'Tintin', 'Albert', NULL, NULL, '75011'),
(6, 'Sordi', 'Alberto', NULL, NULL, '99391'),
(7, 'Muti', 'Ornella', NULL, NULL, '99392'),
(8, 'Milou', 'Le chien', NULL, NULL, '75019'),
(9, 'Tournesol', 'Bruno', NULL, NULL, '94100'),
(10, 'Roberts', 'Julia', NULL, '1965-10-03', '75011');

-- Contenu de la table cdes

INSERT INTO cdes (id_cde, date_cde, id_client) VALUES
(1, '2005-10-03', 1),
(2, '2005-10-10', 2),
(3, '2005-11-01', 1),
(4, '2000-11-01', 1),
(5, '2000-12-10', 2),
(6, CURDATE(), 1),
(7, CURDATE(), 2),
(8, CURDATE(), 5),
(9, CURDATE(), 4);


-- Contenu de la table produits

INSERT INTO produits (id_produit, designation, prix, qte_stockee, photo) VALUES
(1, 'Evian', 1.81, 10, 'evian.jpg'),
(2, 'Badoit', 1.93, 10, 'badoit.jpg'),
(3, 'Graves', 13.20, 10, 'graves.jpg'),
(4, 'Ruinard', 110.00, 10, 'ruinard.jpg'),
(5, 'Dom Pérignon', 165.00, 10, 'dom.jpg'),
(7, 'Picpoul', 5.00, 500, NULL),
(8, 'Picmal', 5.00, 10, NULL);

-- Contenu de la table ligcdes

INSERT INTO ligcdes (id_cde, id_produit, qte) VALUES
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

-- Contenu de la table vendeurs

INSERT INTO vendeurs (id_vendeur, nom, chef, cp) VALUES
(1, 'Lucky', 1, '75011'),
(2, 'Dalton', 1, '75012'),
(3, 'Mickey', 1, '75012'),
(4, 'Donald', 2, '75011');

-- Contenu de la table vendeurs_villes

INSERT INTO vendeurs_villes (id_vendeur, cp, Date_debut, date_fin) VALUES
(1, '75011', '2006-01-01', '2006-12-31'),
(1, '75011', '2007-01-01', '2007-12-31'),
(2, '75011', '2006-01-01', '2006-12-31'),
(2, '75012', '2007-01-01', '2007-12-31'),
(3, '75011', '2007-01-01', '2007-12-31'),
(3, '75012', '2006-01-01', '2006-12-31');

-- Contenu de la table ventes

INSERT INTO ventes (id_vendeur, id_produit, vente, date_vente) VALUES
(1, 1, 20, '2007-04-16'),
(1, 2, 100, '2007-04-16'),
(2, 1, 1, '2007-04-16'),
(2, 2, 10, '2008-04-16'),
(2, 3, 5, '2008-04-16');

-- Contenu de la table ventes_croisees

INSERT INTO ventes_croisees (nom_vendeur, designation, vente) VALUES
('Casta', 'Evian', 20),
('Casta', 'Graves', 5),
('Haddock', 'Badoit', 1),
('Haddock', 'Evian', 1),
('Haddock', 'Graves', 10),
('Tintin', 'Badoit', 5),
('Tintin', 'Evian', 10),
('Tintin', 'Graves', 10);

-- Contenu de la table utilisateurs

INSERT INTO utilisateurs (pseudo, mdp, e_mail, qualite) VALUES
('a', 'f', 'af@free.fr', 'FO'),
('p', 'b', 'pb@free.fr', 'BO');

SET FOREIGN_KEY_CHECKS = 1;
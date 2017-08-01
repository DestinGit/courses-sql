

DROP table if exists genres;
CREATE TABLE genres(
id smallint auto_increment,
genre varchar(30) not null,
primary key(id)
)engine=innodb 
default charset=utf8 collate=utf8_unicode_ci;

DROP table if exists auteurs;
CREATE TABLE auteurs(
id smallint auto_increment,
auteur varchar(30) not null,
primary key(id)
)engine=innodb 
default charset=utf8 collate=utf8_unicode_ci;

DROP table if exists editeurs;
CREATE TABLE editeurs(
id smallint auto_increment,
editeur varchar(30) not null,
primary key(id)
)engine=innodb 
default charset=utf8 collate=utf8_unicode_ci;

DROP table if exists livres;
CREATE TABLE livres(
id int auto_increment,
titre varchar(50) not null,
id_genre smallint not null,
id_editeur smallint not null,
prix decimal(5,2) not null,
primary key(id),
constraint livres_to_genre 
	foreign key(id_genre) 
    references genres(id),
constraint livres_to_editeurs
	foreign key (id_editeur)
    references editeurs(id)
)engine=innodb 
default charset=utf8 collate=utf8_unicode_ci;

DROP table if exists livres_auteurs;
CREATE TABLE livres_auteurs(
id_livre int not null,
id_auteur smallint not null,
primary key(id_livre, id_auteur),
constraint livres_auteurs_to_auteur
	foreign key (id_auteur)
    references auteurs(id),
constraint livres_auteurs_to_livre
	foreign key (id_livre)
    references livres(id)
)engine=innodb 
default charset=utf8 collate=utf8_unicode_ci;

INSERT INTO auteurs
(auteur)
VALUES
('Hugo'),('Dumas'),('Platon'),('Camus'),('Molière');

INSERT INTO genres
(genre)
VALUES
('Roman'), ('Philo'), ('Essai'), ('Théâtre');

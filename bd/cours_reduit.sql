SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

CREATE SCHEMA IF NOT EXISTS `cours` DEFAULT CHARACTER SET utf8 ;
USE `cours` ;

-- -----------------------------------------------------
-- Table `cours`.`pays`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `cours`.`pays` (
  `id_pays` CHAR(4) NOT NULL COMMENT 'Code pays' ,
  `nom_pays` VARCHAR(50) NOT NULL COMMENT 'Nom du pays' ,
  PRIMARY KEY (`id_pays`) ,
  UNIQUE INDEX `index_unique` (`nom_pays` ASC) ,
  INDEX `index_nom` (`nom_pays` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
ROW_FORMAT = DYNAMIC;


-- -----------------------------------------------------
-- Table `cours`.`villes`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `cours`.`villes` (
  `cp` VARCHAR(5) NOT NULL ,
  `nom_ville` VARCHAR(50) NOT NULL ,
  `site` VARCHAR(50) NULL DEFAULT NULL ,
  `photo` VARCHAR(50) NULL DEFAULT NULL ,
  `id_pays` CHAR(4) NOT NULL ,
  `dep` VARCHAR(2) NULL DEFAULT NULL ,
  PRIMARY KEY (`cp`) ,
  INDEX `i_villes_nom_ville` (`nom_ville` ASC) ,
  INDEX `i_villes_id_pays` (`id_pays` ASC) ,
  CONSTRAINT `FK_villes_id_pays`
    FOREIGN KEY (`id_pays` )
    REFERENCES `cours`.`pays` (`id_pays` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
ROW_FORMAT = DYNAMIC;


-- -----------------------------------------------------
-- Table `cours`.`clients`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `cours`.`clients` (
  `id_client` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `nom` VARCHAR(50) NOT NULL ,
  `prenom` VARCHAR(50) NOT NULL ,
  `adresse` VARCHAR(100) NULL DEFAULT NULL ,
  `date_naissance` DATE NULL DEFAULT NULL ,
  `cp` CHAR(5) NOT NULL DEFAULT '' ,
  PRIMARY KEY (`id_client`) ,
  INDEX `Index_cp` (`cp` ASC) ,
  INDEX `i_clients_nom_prenom` (`nom` ASC, `prenom` ASC) ,
  CONSTRAINT `FK_clients_1`
    FOREIGN KEY (`cp` )
    REFERENCES `cours`.`villes` (`cp` ))
ENGINE = InnoDB
AUTO_INCREMENT = 11
DEFAULT CHARACTER SET = utf8
ROW_FORMAT = DYNAMIC;


-- -----------------------------------------------------
-- Table `cours`.`cdes`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `cours`.`cdes` (
  `id_cde` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `date_cde` DATETIME NOT NULL ,
  `id_client` INT(10) UNSIGNED NOT NULL ,
  PRIMARY KEY (`id_cde`) ,
  INDEX `FK_cdes_client` (`id_client` ASC) ,
  CONSTRAINT `FK_cdes_1`
    FOREIGN KEY (`id_client` )
    REFERENCES `cours`.`clients` (`id_client` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 76
DEFAULT CHARACTER SET = utf8
ROW_FORMAT = DYNAMIC;


-- -----------------------------------------------------
-- Table `cours`.`produits`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `cours`.`produits` (
  `id_produit` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `designation` VARCHAR(50) CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NOT NULL ,
  `prix` FLOAT(7,2) NOT NULL ,
  `qte_stockee` INT(5) NULL DEFAULT NULL ,
  `photo` VARCHAR(50) NULL DEFAULT NULL ,
  `prix_promo` FLOAT(7,2) NULL DEFAULT NULL ,
  `id_categorie` INT(10) UNSIGNED NULL DEFAULT NULL ,
  PRIMARY KEY (`id_produit`) ,
  UNIQUE INDEX `index_designation` (`designation` ASC) )
ENGINE = InnoDB
AUTO_INCREMENT = 75
DEFAULT CHARACTER SET = utf8
ROW_FORMAT = DYNAMIC;


-- -----------------------------------------------------
-- Table `cours`.`ligcdes`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `cours`.`ligcdes` (
  `id_cde` INT(10) UNSIGNED NOT NULL ,
  `id_produit` INT(10) UNSIGNED NOT NULL ,
  `qte` INT(5) NOT NULL ,
  PRIMARY KEY (`id_cde`, `id_produit`) ,
  INDEX `FK_ligcdes_id_produit` (`id_produit` ASC) ,
  CONSTRAINT `FK_ligcdes_2`
    FOREIGN KEY (`id_produit` )
    REFERENCES `cours`.`produits` (`id_produit` ),
  CONSTRAINT `FK_ligcdes_1`
    FOREIGN KEY (`id_cde` )
    REFERENCES `cours`.`cdes` (`id_cde` ))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
ROW_FORMAT = DYNAMIC;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

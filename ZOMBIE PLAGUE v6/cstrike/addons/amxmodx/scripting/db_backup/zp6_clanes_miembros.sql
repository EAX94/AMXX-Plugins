-- phpMyAdmin SQL Dump
-- version 3.4.10.1deb1
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 05-06-2015 a las 07:45:31
-- Versión del servidor: 5.5.43
-- Versión de PHP: 5.3.10-1ubuntu3.18

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de datos: `cimsp`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `zp6_clanes_miembros`
--

CREATE TABLE IF NOT EXISTS `zp6_clanes_miembros` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `clan_id` mediumint(8) unsigned NOT NULL,
  `acc_id` mediumint(8) unsigned NOT NULL,
  `pj_id` tinyint(1) unsigned NOT NULL,
  `name` varchar(32) NOT NULL,
  `range` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `tulio` int(11) unsigned NOT NULL DEFAULT '0',
  `since` int(11) unsigned NOT NULL,
  `time_p` int(11) unsigned NOT NULL DEFAULT '0',
  `last_time` int(11) unsigned NOT NULL DEFAULT '0',
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `clan_id` (`clan_id`),
  KEY `acc_id` (`acc_id`),
  KEY `pj_id` (`pj_id`),
  KEY `activo` (`activo`)
) ENGINE=MyISAM  DEFAULT CHARSET=ascii AUTO_INCREMENT=22 ;

--
-- Volcado de datos para la tabla `zp6_clanes_miembros`
--

INSERT INTO `zp6_clanes_miembros` (`id`, `clan_id`, `acc_id`, `pj_id`, `name`, `range`, `tulio`, `since`, `time_p`, `last_time`, `activo`) VALUES(1, 1, 3, 1, 'Leannn.-', 3, 0, 1431139533, 4113, 1431482582, 1);
INSERT INTO `zp6_clanes_miembros` (`id`, `clan_id`, `acc_id`, `pj_id`, `name`, `range`, `tulio`, `since`, `time_p`, `last_time`, `activo`) VALUES(2, 1, 72, 1, 'Axel', 1, 0, 1431139547, 4530, 1431237349, 1);
INSERT INTO `zp6_clanes_miembros` (`id`, `clan_id`, `acc_id`, `pj_id`, `name`, `range`, `tulio`, `since`, `time_p`, `last_time`, `activo`) VALUES(3, 1, 17, 1, 'Juan!', 1, 0, 1431139555, 6588, 1431471787, 1);
INSERT INTO `zp6_clanes_miembros` (`id`, `clan_id`, `acc_id`, `pj_id`, `name`, `range`, `tulio`, `since`, `time_p`, `last_time`, `activo`) VALUES(4, 1, 2, 1, 'El Masiee!', 2, 0, 1431139661, 3712, 1431299661, 0);
INSERT INTO `zp6_clanes_miembros` (`id`, `clan_id`, `acc_id`, `pj_id`, `name`, `range`, `tulio`, `since`, `time_p`, `last_time`, `activo`) VALUES(5, 1, 34, 1, 'Maxteel', 1, 0, 1431139693, 645, 1431145124, 0);
INSERT INTO `zp6_clanes_miembros` (`id`, `clan_id`, `acc_id`, `pj_id`, `name`, `range`, `tulio`, `since`, `time_p`, `last_time`, `activo`) VALUES(6, 1, 51, 1, 'Alumina', 1, 0, 1431139756, 1006, 1431144778, 0);
INSERT INTO `zp6_clanes_miembros` (`id`, `clan_id`, `acc_id`, `pj_id`, `name`, `range`, `tulio`, `since`, `time_p`, `last_time`, `activo`) VALUES(7, 1, 35, 1, 'xxxbonoxxx', 1, 0, 1431139782, 1287, 1431194966, 0);
INSERT INTO `zp6_clanes_miembros` (`id`, `clan_id`, `acc_id`, `pj_id`, `name`, `range`, `tulio`, `since`, `time_p`, `last_time`, `activo`) VALUES(8, 1, 4, 4, 'Pikachu^^', 1, 0, 1431140790, 11603, 1431642863, 1);
INSERT INTO `zp6_clanes_miembros` (`id`, `clan_id`, `acc_id`, `pj_id`, `name`, `range`, `tulio`, `since`, `time_p`, `last_time`, `activo`) VALUES(9, 1, 62, 1, 'koko.', 1, 0, 1431141572, 170, 1431142979, 0);
INSERT INTO `zp6_clanes_miembros` (`id`, `clan_id`, `acc_id`, `pj_id`, `name`, `range`, `tulio`, `since`, `time_p`, `last_time`, `activo`) VALUES(10, 1, 62, 2, 'kokoxxj', 1, 0, 1431143079, 1347, 1431238454, 1);
INSERT INTO `zp6_clanes_miembros` (`id`, `clan_id`, `acc_id`, `pj_id`, `name`, `range`, `tulio`, `since`, `time_p`, `last_time`, `activo`) VALUES(11, 1, 196, 1, 'HOMERO.', 1, 0, 1431208523, 9028, 1431317032, 1);
INSERT INTO `zp6_clanes_miembros` (`id`, `clan_id`, `acc_id`, `pj_id`, `name`, `range`, `tulio`, `since`, `time_p`, `last_time`, `activo`) VALUES(12, 1, 226, 1, 'VI', 1, 0, 1431208525, 1815, 1431292767, 0);
INSERT INTO `zp6_clanes_miembros` (`id`, `clan_id`, `acc_id`, `pj_id`, `name`, `range`, `tulio`, `since`, `time_p`, `last_time`, `activo`) VALUES(13, 1, 73, 1, 'joak1toh lamela', 1, 0, 1431215487, 1270, 1431293147, 0);
INSERT INTO `zp6_clanes_miembros` (`id`, `clan_id`, `acc_id`, `pj_id`, `name`, `range`, `tulio`, `since`, `time_p`, `last_time`, `activo`) VALUES(14, 2, 231, 2, '(A)lan sanchezxD<3', 3, 0, 1431218755, 698, 1431220517, 1);
INSERT INTO `zp6_clanes_miembros` (`id`, `clan_id`, `acc_id`, `pj_id`, `name`, `range`, `tulio`, `since`, `time_p`, `last_time`, `activo`) VALUES(15, 2, 86, 1, 'sub scorpion', 1, 0, 1431218801, 5855, 1431732345, 1);
INSERT INTO `zp6_clanes_miembros` (`id`, `clan_id`, `acc_id`, `pj_id`, `name`, `range`, `tulio`, `since`, `time_p`, `last_time`, `activo`) VALUES(16, 2, 220, 1, 'ElYaguarete.-', 1, 0, 1431218804, 3512, 1431302769, 1);
INSERT INTO `zp6_clanes_miembros` (`id`, `clan_id`, `acc_id`, `pj_id`, `name`, `range`, `tulio`, `since`, `time_p`, `last_time`, `activo`) VALUES(17, 2, 190, 1, 'TOMYY', 1, 0, 1431218806, 1055, 1431226822, 1);
INSERT INTO `zp6_clanes_miembros` (`id`, `clan_id`, `acc_id`, `pj_id`, `name`, `range`, `tulio`, `since`, `time_p`, `last_time`, `activo`) VALUES(18, 2, 132, 2, 'el bananero', 1, 0, 1431218807, 462, 1431299661, 1);
INSERT INTO `zp6_clanes_miembros` (`id`, `clan_id`, `acc_id`, `pj_id`, `name`, `range`, `tulio`, `since`, `time_p`, `last_time`, `activo`) VALUES(19, 2, 235, 4, 'SilverJ1', 1, 0, 1431218878, 981, 1431313374, 1);
INSERT INTO `zp6_clanes_miembros` (`id`, `clan_id`, `acc_id`, `pj_id`, `name`, `range`, `tulio`, `since`, `time_p`, `last_time`, `activo`) VALUES(20, 1, 2, 1, 'El Masiee!', 1, 0, 1431314549, 0, 0, 0);
INSERT INTO `zp6_clanes_miembros` (`id`, `clan_id`, `acc_id`, `pj_id`, `name`, `range`, `tulio`, `since`, `time_p`, `last_time`, `activo`) VALUES(21, 1, 2, 1, 'El Masiee!', 2, 0, 1431314670, 131, 1431315518, 1);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

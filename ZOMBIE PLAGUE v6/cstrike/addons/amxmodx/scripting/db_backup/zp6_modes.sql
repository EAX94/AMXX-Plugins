-- phpMyAdmin SQL Dump
-- version 3.4.10.1deb1
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 05-06-2015 a las 07:45:50
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
-- Estructura de tabla para la tabla `zp6_modes`
--

CREATE TABLE IF NOT EXISTS `zp6_modes` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `primer_zombie` int(11) unsigned NOT NULL,
  `swarm` int(11) unsigned NOT NULL,
  `infeccion_multiple` int(11) unsigned NOT NULL,
  `plague` int(11) unsigned NOT NULL,
  `survivor` int(11) unsigned NOT NULL,
  `nemesis` int(11) unsigned NOT NULL,
  `wesker` int(11) unsigned NOT NULL,
  `jason` int(11) unsigned NOT NULL,
  `armageddon` int(11) unsigned NOT NULL,
  `mega_nemesis` int(11) unsigned NOT NULL,
  `troll` int(11) unsigned NOT NULL,
  `paranoia` int(11) unsigned NOT NULL,
  `coop` int(11) unsigned NOT NULL,
  `assassin` int(11) unsigned NOT NULL,
  `alien_vs_depredador` int(11) unsigned NOT NULL,
  `bomber` int(11) unsigned NOT NULL,
  `duelo_final` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=ascii AUTO_INCREMENT=2 ;

--
-- Volcado de datos para la tabla `zp6_modes`
--

INSERT INTO `zp6_modes` (`id`, `primer_zombie`, `swarm`, `infeccion_multiple`, `plague`, `survivor`, `nemesis`, `wesker`, `jason`, `armageddon`, `mega_nemesis`, `troll`, `paranoia`, `coop`, `assassin`, `alien_vs_depredador`, `bomber`, `duelo_final`) VALUES
(1, 757, 36, 25, 5, 8, 6, 9, 8, 2, 1, 3, 1, 1, 1, 3, 1, 1);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

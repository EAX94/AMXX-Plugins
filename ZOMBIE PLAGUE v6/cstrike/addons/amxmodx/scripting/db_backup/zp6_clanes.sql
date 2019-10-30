-- phpMyAdmin SQL Dump
-- version 3.4.10.1deb1
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 05-06-2015 a las 07:45:26
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
-- Estructura de tabla para la tabla `zp6_clanes`
--

CREATE TABLE IF NOT EXISTS `zp6_clanes` (
  `id` mediumint(8) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) COLLATE utf8_spanish_ci NOT NULL,
  `tulio` int(11) unsigned NOT NULL DEFAULT '0',
  `created_date` int(11) unsigned NOT NULL,
  `victorias` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `victorias_consec` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `victorias_consec_history` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `campeon_actual` mediumint(8) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci AUTO_INCREMENT=3 ;

--
-- Volcado de datos para la tabla `zp6_clanes`
--

INSERT INTO `zp6_clanes` (`id`, `name`, `tulio`, `created_date`, `victorias`, `victorias_consec`, `victorias_consec_history`, `campeon_actual`) VALUES(1, 'Prov3', 0, 1431139533, 0, 0, 0, 0);
INSERT INTO `zp6_clanes` (`id`, `name`, `tulio`, `created_date`, `victorias`, `victorias_consec`, `victorias_consec_history`, `campeon_actual`) VALUES(2, 'xd', 0, 1431218755, 0, 0, 0, 0);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

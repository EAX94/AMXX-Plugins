-- phpMyAdmin SQL Dump
-- version 3.4.10.1deb1
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 05-06-2015 a las 07:34:40
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
-- Estructura de tabla para la tabla `td_bans`
--

CREATE TABLE IF NOT EXISTS `td_bans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `td_id` int(11) NOT NULL,
  `hid` varchar(64) NOT NULL,
  `start` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `finish` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `name_admin` varchar(32) NOT NULL,
  `reason` varchar(256) NOT NULL,
  `activo` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=ascii AUTO_INCREMENT=4 ;

--
-- Volcado de datos para la tabla `td_bans`
--

INSERT INTO `td_bans` (`id`, `td_id`, `hid`, `start`, `finish`, `name_admin`, `reason`, `activo`) VALUES(1, 1744, '19472BE0-4E4B5E3C-A603354F-9', '2015-02-04 19:28:06', '2015-03-04 19:28:06', 'KISKE', 'Interrumpir en el progreso de otros jugadores', 0);
INSERT INTO `td_bans` (`id`, `td_id`, `hid`, `start`, `finish`, `name_admin`, `reason`, `activo`) VALUES(2, 538, '05DA4444-3922BAA9-543F5776-3', '2015-02-05 19:50:00', '2015-03-05 19:50:00', 'KISKE', 'Abusar del slot reservado para expulsar companeros', 1);
INSERT INTO `td_bans` (`id`, `td_id`, `hid`, `start`, `finish`, `name_admin`, `reason`, `activo`) VALUES(3, 4473, '2F7BE999-7E70824E-0F06DF15-4', '2015-02-06 19:51:00', '2015-03-06 19:51:00', 'KISKE', 'Interrumpir en el progreso de otros jugadores', 1);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

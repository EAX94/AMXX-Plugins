-- phpMyAdmin SQL Dump
-- version 3.4.10.1deb1
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 05-06-2015 a las 07:45:21
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
-- Estructura de tabla para la tabla `zp6_bans`
--

CREATE TABLE IF NOT EXISTS `zp6_bans` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `acc_id` mediumint(8) unsigned NOT NULL,
  `hid` varchar(30) NOT NULL,
  `start` int(11) unsigned NOT NULL,
  `finish` int(11) unsigned NOT NULL,
  `name_admin` varchar(32) NOT NULL,
  `reason` varchar(128) NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `pj_name` varchar(32) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `acc_id` (`acc_id`),
  KEY `hid` (`hid`)
) ENGINE=MyISAM DEFAULT CHARSET=ascii AUTO_INCREMENT=1 ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

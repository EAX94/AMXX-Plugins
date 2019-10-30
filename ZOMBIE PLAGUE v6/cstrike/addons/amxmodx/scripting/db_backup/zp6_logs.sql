-- phpMyAdmin SQL Dump
-- version 3.4.10.1deb1
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 05-06-2015 a las 07:45:45
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
-- Estructura de tabla para la tabla `zp6_logs`
--

CREATE TABLE IF NOT EXISTS `zp6_logs` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `acc_id` mediumint(8) unsigned NOT NULL,
  `pj_id` tinyint(1) unsigned NOT NULL,
  `pj_name` varchar(32) NOT NULL,
  `old_hid` varchar(30) NOT NULL,
  `new_hid` varchar(30) NOT NULL,
  `fecha` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=ascii AUTO_INCREMENT=30 ;

--
-- Volcado de datos para la tabla `zp6_logs`
--

INSERT INTO `zp6_logs` (`id`, `acc_id`, `pj_id`, `pj_name`, `old_hid`, `new_hid`, `fecha`) VALUES(1, 203, 1, 'Alexx.-', 'F1CE0ECF-4DECE270-95BF799D-4', '2BDCBEAD-138BECEA-4B728508-10', 1431138438);
INSERT INTO `zp6_logs` (`id`, `acc_id`, `pj_id`, `pj_name`, `old_hid`, `new_hid`, `fecha`) VALUES(2, 176, 1, 'JOkER', '2BDCBEAD-FAC96F62-FBF0925C-1', '2BDCBEAD-9E123232-7CDDA3A1-4', 1431141344);
INSERT INTO `zp6_logs` (`id`, `acc_id`, `pj_id`, `pj_name`, `old_hid`, `new_hid`, `fecha`) VALUES(3, 213, 1, 'JOkER~', '2BDCBEAD-9E123232-7CDDA3A1-4', '2BDCBEAD-FAC96F62-FBF0925C-1', 1431146635);
INSERT INTO `zp6_logs` (`id`, `acc_id`, `pj_id`, `pj_name`, `old_hid`, `new_hid`, `fecha`) VALUES(4, 86, 1, 'sub scorpion', '2F7BE999-6906B864-723BA1FF-3', '2F7BE999-F25716AB-66CA2D40-1', 1431200946);
INSERT INTO `zp6_logs` (`id`, `acc_id`, `pj_id`, `pj_name`, `old_hid`, `new_hid`, `fecha`) VALUES(5, 86, 1, 'SUB SCORPION', '2F7BE999-F25716AB-66CA2D40-1', '2F7BE999-6906B864-723BA1FF-3', 1431203399);
INSERT INTO `zp6_logs` (`id`, `acc_id`, `pj_id`, `pj_name`, `old_hid`, `new_hid`, `fecha`) VALUES(6, 157, 2, 'UH!', '00005C89-CD07EA0E-53DDC35B-3', '00005C89-85364064-FD3FD17C-9', 1431208383);
INSERT INTO `zp6_logs` (`id`, `acc_id`, `pj_id`, `pj_name`, `old_hid`, `new_hid`, `fecha`) VALUES(7, 157, 2, 'UH!', '00005C89-CD07EA0E-53DDC35B-3', '00005C89-85364064-FD3FD17C-9', 1431208801);
INSERT INTO `zp6_logs` (`id`, `acc_id`, `pj_id`, `pj_name`, `old_hid`, `new_hid`, `fecha`) VALUES(8, 203, 1, 'Alexx.-', '2BDCBEAD-138BECEA-4B728508-10', 'F1CE0ECF-4DECE270-95BF799D-4', 1431213547);
INSERT INTO `zp6_logs` (`id`, `acc_id`, `pj_id`, `pj_name`, `old_hid`, `new_hid`, `fecha`) VALUES(9, 86, 1, 'sub scorpion', '2F7BE999-6906B864-723BA1FF-3', '2F7BE999-F25716AB-66CA2D40-1', 1431213979);
INSERT INTO `zp6_logs` (`id`, `acc_id`, `pj_id`, `pj_name`, `old_hid`, `new_hid`, `fecha`) VALUES(10, 231, 1, '(R)ap<3', 'D8967DD5-31D614E5-C2DA078D-9', 'D8967DD5-EE6224BB-E9BF6BD0-1', 1431217412);
INSERT INTO `zp6_logs` (`id`, `acc_id`, `pj_id`, `pj_name`, `old_hid`, `new_hid`, `fecha`) VALUES(11, 2, 1, 'El Masiee!', '8742DE19-1D6FC0E9-7609FD30-3', '5AE9B691-4E4B5E3C-3317AA6B-3', 1431218703);
INSERT INTO `zp6_logs` (`id`, `acc_id`, `pj_id`, `pj_name`, `old_hid`, `new_hid`, `fecha`) VALUES(12, 203, 1, 'Alexx.-', 'F1CE0ECF-4DECE270-95BF799D-4', '2BDCBEAD-138BECEA-4B728508-10', 1431224079);
INSERT INTO `zp6_logs` (`id`, `acc_id`, `pj_id`, `pj_name`, `old_hid`, `new_hid`, `fecha`) VALUES(13, 2, 1, 'El Masiee!', '5AE9B691-4E4B5E3C-3317AA6B-3', '8742DE19-1D6FC0E9-7609FD30-3', 1431227396);
INSERT INTO `zp6_logs` (`id`, `acc_id`, `pj_id`, `pj_name`, `old_hid`, `new_hid`, `fecha`) VALUES(14, 2, 1, 'El Masiee!', '8742DE19-1D6FC0E9-7609FD30-3', '5AE9B691-4E4B5E3C-3317AA6B-3', 1431299661);
INSERT INTO `zp6_logs` (`id`, `acc_id`, `pj_id`, `pj_name`, `old_hid`, `new_hid`, `fecha`) VALUES(15, 157, 2, 'UH!', '00005C89-85364064-FD3FD17C-9', '00005C89-CD07EA0E-53DDC35B-3', 1431378711);
INSERT INTO `zp6_logs` (`id`, `acc_id`, `pj_id`, `pj_name`, `old_hid`, `new_hid`, `fecha`) VALUES(16, 157, 2, 'UH!', '00005C89-CD07EA0E-53DDC35B-3', '00005C89-85364064-FD3FD17C-9', 1431378816);
INSERT INTO `zp6_logs` (`id`, `acc_id`, `pj_id`, `pj_name`, `old_hid`, `new_hid`, `fecha`) VALUES(17, 268, 1, 'SAPITO', '00005C89-85364064-FD3FD17C-9', '00005C89-CD07EA0E-53DDC35B-3', 1431380109);
INSERT INTO `zp6_logs` (`id`, `acc_id`, `pj_id`, `pj_name`, `old_hid`, `new_hid`, `fecha`) VALUES(18, 15, 1, 'ViruS', '2BDCBEAD-138BECEA-4B728508-10', 'F1CE0ECF-4DECE270-95BF799D-4', 1431385272);
INSERT INTO `zp6_logs` (`id`, `acc_id`, `pj_id`, `pj_name`, `old_hid`, `new_hid`, `fecha`) VALUES(19, 50, 1, 'abZek', 'D8967DD5-5AEF38F3-7F54C917-8', 'D8967DD5-4E4B5E3C-B7CBFDBE-2', 1431391166);
INSERT INTO `zp6_logs` (`id`, `acc_id`, `pj_id`, `pj_name`, `old_hid`, `new_hid`, `fecha`) VALUES(20, 220, 1, 'ElYaguarete.-', '2F7BE999-64C8182C-D26BAF55-7', '2F7BE999-64C8182C-297C7474-7', 1431434096);
INSERT INTO `zp6_logs` (`id`, `acc_id`, `pj_id`, `pj_name`, `old_hid`, `new_hid`, `fecha`) VALUES(21, 220, 1, 'ElYaguarete.-', '2F7BE999-64C8182C-297C7474-7', '2F7BE999-64C8182C-D26BAF55-7', 1431442681);
INSERT INTO `zp6_logs` (`id`, `acc_id`, `pj_id`, `pj_name`, `old_hid`, `new_hid`, `fecha`) VALUES(22, 15, 1, 'ViruS', 'F1CE0ECF-4DECE270-95BF799D-4', '2BDCBEAD-138BECEA-4B728508-10', 1431458961);
INSERT INTO `zp6_logs` (`id`, `acc_id`, `pj_id`, `pj_name`, `old_hid`, `new_hid`, `fecha`) VALUES(23, 264, 1, 'Compumundo.-', 'CD2A547C-D80D3AE4-AABC82EF-6', 'D8967DD5-31D614E5-C2DA078D-9', 1431472804);
INSERT INTO `zp6_logs` (`id`, `acc_id`, `pj_id`, `pj_name`, `old_hid`, `new_hid`, `fecha`) VALUES(24, 55, 1, 'Cross', '4DAFF436-D6116A45-D68F7EEF-7', '573C484E-F25796A0-9367FF6E-1', 1431476387);
INSERT INTO `zp6_logs` (`id`, `acc_id`, `pj_id`, `pj_name`, `old_hid`, `new_hid`, `fecha`) VALUES(25, 276, 1, '|BOCA|D!5C0N3CT3D|_xXx_', '59C1DE55-737E72D4-7D483231-2', '59C1DE55-026F7650-7D483231-1', 1431642272);
INSERT INTO `zp6_logs` (`id`, `acc_id`, `pj_id`, `pj_name`, `old_hid`, `new_hid`, `fecha`) VALUES(26, 6, 1, '[ExTrEmE]-[PrO-MaTi]', '573C484E-E06F714C-2E0713EF-10', '573C484E-735CEECF-2E0713EF-1', 1431642341);
INSERT INTO `zp6_logs` (`id`, `acc_id`, `pj_id`, `pj_name`, `old_hid`, `new_hid`, `fecha`) VALUES(27, 88, 1, 'SlowMinD -G-', '158E082F-A04D5975-57156363-8', '59C1DE55-026F7650-C8469BAF-10', 1431642822);
INSERT INTO `zp6_logs` (`id`, `acc_id`, `pj_id`, `pj_name`, `old_hid`, `new_hid`, `fecha`) VALUES(28, 15, 1, 'ViruS', '2BDCBEAD-138BECEA-4B728508-10', 'F1CE0ECF-4DECE270-95BF799D-4', 1431816748);
INSERT INTO `zp6_logs` (`id`, `acc_id`, `pj_id`, `pj_name`, `old_hid`, `new_hid`, `fecha`) VALUES(29, 291, 1, 'capoan', '2F7BE999-F25716AB-66CA2D40-1', '2F7BE999-6906B864-723BA1FF-3', 1432393749);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

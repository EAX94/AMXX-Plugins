-- phpMyAdmin SQL Dump
-- version 3.4.10.1deb1
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 05-06-2015 a las 07:45:36
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
-- Estructura de tabla para la tabla `zp6_combos`
--

CREATE TABLE IF NOT EXISTS `zp6_combos` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `acc_id` mediumint(8) unsigned NOT NULL,
  `pj_id` tinyint(1) unsigned NOT NULL,
  `username` varchar(32) NOT NULL,
  `mapname` varchar(32) NOT NULL,
  `type` tinyint(1) NOT NULL DEFAULT '0',
  `combo` int(11) unsigned NOT NULL,
  `combo_date` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=ascii AUTO_INCREMENT=71 ;

--
-- Volcado de datos para la tabla `zp6_combos`
--

INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(1, 56, 1, 'Rus0''', 'zm_kfox_b3', 0, 2001, 1431137662);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(2, 16, 1, 'SeBaS_LePrOsO', 'zm_kfox_b3', 0, 2783, 1431137676);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(3, 16, 1, 'SeBaS_LePrOsO', 'zm_kfox_b3', 0, 3381, 1431137729);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(4, 19, 1, 'Musimundo.-', 'zm_kfox_b3', 0, 4441, 1431137732);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(5, 73, 1, 'joak1toh lamela', 'zm_kfox_b3', 0, 11751, 1431137933);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(6, 196, 1, 'HOMERO.', 'zm_kfox_b3', 0, 12701, 1431137951);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(7, 196, 1, 'HOMERO.', 'zm_kfox_b3', 0, 14845, 1431138357);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(8, 196, 1, 'HOMERO.', 'zm_kfox_b3', 0, 15068, 1431138459);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(9, 198, 1, 'Fefo', 'zm_kfox_b3', 0, 18544, 1431139128);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(10, 6, 1, '[ExTrEmE]-[PrO-MaTi]', 'zm_kfox_b3', 0, 25623, 1431139142);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(11, 41, 1, 'warp', 'zm_kfox_b3', 0, 27300, 1431139142);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(12, 96, 1, '.::!v@n::.', 'zm_kfox_b3', 0, 33713, 1431139144);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(13, 2, 1, 'El Masiee!', 'zm_kontrax_b5', 0, 1059, 1431140010);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(14, 51, 1, 'Alumina', 'zm_kontrax_b5', 0, 3848, 1431140030);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(15, 83, 1, 'manicomio', 'zm_kontrax_b5', 0, 17291, 1431140088);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(16, 190, 1, 'TOMYY', 'zm_kontrax_b5', 0, 22029, 1431140092);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(17, 4, 4, 'Pikachu^^', 'zm_kontrax_b5', 0, 61807, 1431140139);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(18, 62, 1, 'koko.', 'zm_kontrax_b5', 0, 72350, 1431141966);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(19, 2, 1, 'El Masiee!', 'zm_taringacs_rre_texas', 0, 1025, 1431149175);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(20, 220, 1, 'ElYaguarete.-', 'zm_taringacs_contrax', 0, 9259, 1431181176);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(21, 219, 2, 'Conejito.-', 'zm_taringacs_contrax', 0, 27150, 1431181459);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(22, 222, 1, 'Minato.', 'zm_taringacs_contrax', 0, 33902, 1431181560);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(23, 220, 1, 'ElYaguarete.-', 'zm_taringacs_contrax', 0, 58749, 1431181917);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(24, 219, 2, 'Conejito.-', 'zm_gaminga_roma2', 0, 4702, 1431182546);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(25, 9, 1, 'Armando Barreda', 'zm_gaminga_roma2', 0, 11266, 1431182637);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(26, 219, 2, 'Conejito.-', 'zm_gaminga_roma2', 0, 15021, 1431182708);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(27, 9, 1, 'Armando Barreda', 'zm_gaminga_roma2', 0, 17606, 1431183121);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(28, 157, 2, 'UH!', 'zm_gaminga_roma2', 0, 20148, 1431195680);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(29, 72, 1, 'Axel', 'zm_kontrax_b5', 1, 5, 1431201627);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(30, 6, 1, '[ExTrEmE]-[PrO-MaTi]', 'zm_gaminga_aroma_v3', 0, 1811, 1431204818);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(31, 226, 1, 'VI', 'zm_gaminga_aroma_v3', 0, 2925, 1431204876);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(32, 86, 1, 'SUB SCORPION', 'zm_gaminga_aroma_v3', 0, 4389, 1431204878);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(33, 6, 1, '[ExTrEmE]-[PrO-MaTi]', 'zm_gaminga_aroma_v3', 0, 12914, 1431204978);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(34, 41, 1, 'warp', 'zm_gaminga_aroma_v3', 0, 17465, 1431205127);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(35, 6, 1, '[ExTrEmE]-[PrO-MaTi]', 'zm_gaminga_aroma_v3', 0, 22795, 1431205127);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(36, 4, 4, 'Pikachu^^', 'zm_gaminga_aroma_v3', 0, 27712, 1431205787);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(37, 7, 1, 'iZZy', 'zm_gaminga_aroma_v3', 0, 37265, 1431206118);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(38, 112, 1, 'hitbooy', 'zm_gaminga_aroma_v3', 0, 56184, 1431206501);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(39, 196, 1, 'HOMERO.', 'zm_kontrax_b5', 1, 6, 1431207444);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(40, 196, 1, 'HOMERO.', 'zm_gaminga_aroma_v3', 1, 5, 1431210022);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(41, 7, 1, 'iZZy', 'zm_taringacs_contrax_v3', 0, 2547, 1431211568);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(42, 39, 1, 'Licenciado Lucas', 'zm_taringacs_contrax_v3', 0, 3200, 1431211593);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(43, 56, 1, 'Rus0''', 'zm_taringacs_contrax_v3', 0, 5053, 1431211649);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(44, 39, 1, 'Licenciado Lucas', 'zm_taringacs_contrax_v3', 0, 19972, 1431211709);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(45, 73, 1, 'joak1toh lamela', 'zm_gaminga_roma2', 0, 29162, 1431214392);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(46, 54, 1, 'Warface', 'zm_gaminga_roma2', 0, 41701, 1431215087);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(47, 72, 1, 'Axel', 'zm_gaminga_roma2', 1, 8, 1431215090);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(48, 190, 1, 'TOMYY', 'zm_taringacs_contrax_v4', 0, 1542, 1431219658);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(49, 220, 1, 'ElYaguarete.-', 'zm_taringacs_contrax_v4', 0, 1968, 1431219661);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(50, 220, 1, 'ElYaguarete.-', 'zm_taringacs_contrax_v4', 0, 4336, 1431219842);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(51, 226, 1, 'VI', 'zm_taringacs_contrax_v4', 0, 4853, 1431220147);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(52, 220, 1, 'ElYaguarete.-', 'zm_taringacs_contrax_v4', 0, 6943, 1431220147);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(53, 190, 1, 'TOMYY', 'zm_gaminga_roma2', 0, 48826, 1431222730);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(54, 235, 4, 'SilverJ1', 'zm_gaminga_aroma_v3', 0, 72495, 1431224103);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(55, 72, 1, 'Axel', 'zm_gaminga_aroma_v3', 1, 6, 1431288997);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(56, 196, 1, 'HOMERO.', 'zm_gaminga_aroma_v3', 1, 12, 1431291077);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(57, 35, 1, 'xxxbonoxxx', 'zm_five', 0, 1095, 1431310186);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(58, 5, 1, 'Blackouter', 'zm_five', 0, 2715, 1431310308);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(59, 259, 1, 'LeoneL_089', 'zm_taringacs_contrax_v4', 0, 13427, 1431355991);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(60, 262, 1, 'vasco0p', 'zm_gaminga_aroma_v3', 0, 121805, 1431362816);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(61, 66, 1, 'Kolve3', 'zm_taringacs_rre_texas', 0, 1688, 1431369307);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(62, 268, 1, 'SAPITO', 'zm_gaminga_roma2', 0, 106435, 1431379475);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(63, 16, 1, 'SeBaS_LePrOsO', 'zm_taringacs_rre-valle', 0, 3287, 1431380493);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(64, 268, 1, 'SAPITO', 'zm_taringacs_rre-valle', 0, 3796, 1431380590);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(65, 15, 1, 'ViruS', 'zm_kfox_b3', 0, 45370, 1431460001);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(66, 132, 2, 'el bananero', 'zm_kfox_b3', 0, 52826, 1431460366);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(67, 132, 2, 'el bananero', 'zm_taringacs_rre_texas', 0, 39440, 1431461139);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(68, 40, 1, 'Luch3.-', 'zm_gaminga_aroma_v3', 0, 184417, 1431472375);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(69, 280, 1, 'los borbotones', 'zm_gaminga_roma2', 0, 139916, 1431874173);
INSERT INTO `zp6_combos` (`id`, `acc_id`, `pj_id`, `username`, `mapname`, `type`, `combo`, `combo_date`) VALUES(70, 292, 1, '.     aMb', 'zm_gaminga_roma2', 0, 208635, 1432685161);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

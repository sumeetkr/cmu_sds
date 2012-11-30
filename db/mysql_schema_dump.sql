-- phpMyAdmin SQL Dump
-- version 3.4.10.1deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Nov 20, 2012 at 11:55 AM
-- Server version: 5.5.28
-- PHP Version: 5.3.10-1ubuntu3.4

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `AndrewSisters`
--

-- --------------------------------------------------------

--
-- Table structure for table `readings`
--

CREATE TABLE IF NOT EXISTS `readings` (
  `index` bigint(20) NOT NULL AUTO_INCREMENT,
  `id` int(11) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `bat` int(11) NOT NULL,
  `temp` int(11) NOT NULL,
  `digital_temp` int(11) NOT NULL,
  `light` int(11) NOT NULL,
  `humidity` int(11) NOT NULL,
  `pressure` int(11) NOT NULL,
  `acc_x` int(11) NOT NULL,
  `acc_y` int(11) NOT NULL,
  `acc_z` int(11) NOT NULL,
  `audio_p2p` int(11) NOT NULL,
  `motion` int(11) NOT NULL,
  `gpio_state` int(11) NOT NULL,
  PRIMARY KEY (`index`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
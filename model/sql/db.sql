# ************************************************************
# Sequel Pro SQL dump
# Version 4096
#
# http://www.sequelpro.com/
# http://code.google.com/p/sequel-pro/
#
# Host: 127.0.0.1 (MySQL 5.6.15)
# Database: wonder
# Generation Time: 2014-03-07 01:27:45 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table journey_times
# ------------------------------------------------------------

DROP TABLE IF EXISTS `journey_times`;

CREATE TABLE `journey_times` (
  `id` int(11) unsigned NOT NULL,
  `timestamp` datetime NOT NULL,
  `recorded_timestamp` datetime NOT NULL,
  `point` point NOT NULL,
  `from_point` point NOT NULL,
  `to_point` point NOT NULL,
  `ideal_time` int(11) DEFAULT NULL,
  `historic_time` int(11) DEFAULT NULL,
  `estimated_time` int(11) NOT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  `direction` varchar(20) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  SPATIAL KEY `point_index` (`point`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table roadworks
# ------------------------------------------------------------

DROP TABLE IF EXISTS `roadworks`;

CREATE TABLE `roadworks` (
  `id` int(11) unsigned NOT NULL,
  `timestamp` datetime DEFAULT NULL,
  `point` point DEFAULT NULL,
  `line` linestring DEFAULT NULL,
  `operational_lanes` int(11) DEFAULT NULL,
  `restricted_lanes` int(11) DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `comment` text,
  `impact` text,
  `delay_time` int(11) DEFAULT NULL,
  `occurence_probability` text,
  `road_maintenance_type` text,
  `subject_type_of_works` text,
  `recorded_time` datetime DEFAULT NULL,
  `direction` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

CREATE TABLE IF NOT EXISTS `houses` (
  `id` int(11) NOT NULL,
  `owner` int(11) NOT NULL DEFAULT '0',
  `for_sale` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `players` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `steam_id` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `role` enum('PLAYER','ADMIN') DEFAULT 'PLAYER',
  `cash` int(11) NOT NULL DEFAULT '500',
  `balance` int(11) NOT NULL DEFAULT '4500',
  `xp` int(11) NOT NULL DEFAULT '0',
  `payday` int(11) NOT NULL DEFAULT '0',
  `salary` int(11) NOT NULL DEFAULT '0',
  `phone_bill` int(11) NOT NULL DEFAULT '0',
  `inventory` text,
  `licenses` text,
  `prim_weapon` int(11) NOT NULL DEFAULT '1',
  `prim_ammo` int(11) NOT NULL DEFAULT '0',
  `sec_weapon` int(11) NOT NULL DEFAULT '1',
  `sec_ammo` int(11) NOT NULL DEFAULT '0',
  `spawn` int(11) DEFAULT '0',
  `job` enum('NONE','GARBAGE','DELIVERY') DEFAULT 'NONE',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `player_vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` int(11) DEFAULT NULL,
  `model` int(11) DEFAULT NULL,
  `color` int(11) DEFAULT '16777215',
  `license` varchar(16) DEFAULT '',
  `x` double DEFAULT '0',
  `y` double DEFAULT '0',
  `z` double DEFAULT '0',
  `heading` double DEFAULT '0',
  `fuel` double DEFAULT '100',
  `health` double DEFAULT '2000',
  `towed` tinyint(4) DEFAULT '0',
  `nitro` tinyint(4) DEFAULT '0',
  `radio` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;

CREATE TABLE IF NOT EXISTS `players` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `steam_id` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `player_vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` int(11) DEFAULT NULL,
  `model` int(11) DEFAULT NULL,
  `color` int(11) DEFAULT NULL,
  `license` varchar(16) DEFAULT '',
  `x` double DEFAULT NULL,
  `y` double DEFAULT NULL,
  `z` double DEFAULT NULL,
  `heading` double DEFAULT NULL,
  `fuel` double DEFAULT NULL,
  `health` double DEFAULT NULL,
  `towed` tinyint(4) DEFAULT '0',
  `nitro` tinyint(4) DEFAULT '0',
  `radio` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;
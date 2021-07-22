-- Создаём структуру бд vk
-- БД будет состоять из нескольких таблиц: media_types, users, communities, communities_users, friend_requests, media, messages, posts, posts_likes, profiles
DROP DATABASE IF EXISTS vk2;
CREATE DATABASE vk2;
USE vk2;
DROP TABLE IF EXISTS `communities`;
DROP TABLE IF EXISTS `media_types`;

CREATE TABLE `media_types` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `first_name` varchar(145) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(145) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(145) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` char(11) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` char(65) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_idx` (`email`),
  UNIQUE KEY `phone_idx` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE `communities` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(145) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(245) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `admin_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_communities_users_admin_idx` (`admin_id`),
  CONSTRAINT `fk_communities_users` FOREIGN KEY (`admin_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `communities_users`;

CREATE TABLE `communities_users` (
  `community_id` bigint(20) unsigned NOT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`community_id`,`user_id`),
  KEY `communities_users_comm_idx` (`community_id`),
  KEY `communities_users_users_idx` (`user_id`),
  CONSTRAINT `fk_communities_users_comm` FOREIGN KEY (`community_id`) REFERENCES `communities` (`id`),
  CONSTRAINT `fk_communities_users_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `friend_requests`;

CREATE TABLE `friend_requests` (
  `from_user_id` bigint(20) unsigned NOT NULL,
  `to_user_id` bigint(20) unsigned NOT NULL,
  `accepted` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`from_user_id`,`to_user_id`),
  KEY `fk_friend_requests_from_user_idx` (`from_user_id`),
  KEY `fk_friend_requests_to_user_idx` (`to_user_id`),
  CONSTRAINT `fk_friend_requests_users_1` FOREIGN KEY (`from_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_friend_requests_users_2` FOREIGN KEY (`to_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `media`;

CREATE TABLE `media` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `media_types_id` int(10) unsigned NOT NULL,
  `file_name` varchar(245) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '/files/folder/img.png',
  `file_size` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fk_media_users_idx` (`user_id`),
  KEY `fk_media_media_types` (`media_types_id`),
  CONSTRAINT `fk_media_media_types` FOREIGN KEY (`media_types_id`) REFERENCES `media_types` (`id`),
  CONSTRAINT `fk_media_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1301 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `messages`;

CREATE TABLE `messages` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `from_user_id` bigint(20) unsigned NOT NULL,
  `to_user_id` bigint(20) unsigned NOT NULL,
  `txt` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_delivered` tinyint(1) DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fk_messages_from_user_idx` (`from_user_id`),
  KEY `fk_messages_to_user_idx` (`to_user_id`),
  CONSTRAINT `fk_messages_users_1` FOREIGN KEY (`from_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_messages_users_2` FOREIGN KEY (`to_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `posts`;

CREATE TABLE `posts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `txt` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`),
  CONSTRAINT `user_posts_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `posts_likes`;

CREATE TABLE `posts_likes` (
  `post_id` bigint(20) unsigned NOT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  `like_type` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`post_id`,`user_id`),
  KEY `post_idx` (`post_id`),
  KEY `user_idx` (`user_id`),
  CONSTRAINT `posts_likes_fk` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`),
  CONSTRAINT `users_likes_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `profiles`;

CREATE TABLE `profiles` (
  `user_id` bigint(20) unsigned NOT NULL,
  `gender` enum('f','m','x') COLLATE utf8mb4_unicode_ci NOT NULL,
  `birthday` date NOT NULL,
  `photo_id` bigint(20) unsigned DEFAULT NULL,
  `user_status` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(130) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country` varchar(130) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `photo_id` (`photo_id`),
  CONSTRAINT `fk_profiles_media` FOREIGN KEY (`photo_id`) REFERENCES `media` (`id`),
  CONSTRAINT `fk_profiles_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- заполняем получившиеся таблицы данными 
INSERT INTO `media_types` (`id`, `name`) VALUES (1, 'aut');
INSERT INTO `media_types` (`id`, `name`) VALUES (4, 'nobis');
INSERT INTO `media_types` (`id`, `name`) VALUES (2, 'praesentium');
INSERT INTO `media_types` (`id`, `name`) VALUES (3, 'rerum');

INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('1', 'Cooper', 'Denesik', 'viola.effertz@example.net', '89907957506', 'd47a64be9aafcea194fa5e7937f3c371d9441bcf', '2007-01-12 16:24:01');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('2', 'Kieran', 'Jakubowski', 'cole.charlene@example.net', '89684121240', '9d7ca1c52b798340c183db28ec33159104dff3a1', '2019-11-28 18:41:21');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('3', 'Tyra', 'Boyer', 'lacey28@example.org', '89410848673', 'd7c34e92b1a15af9caefaa8e9a74bdc2cb28b7b3', '2016-02-10 03:29:19');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('4', 'Andre', 'Ernser', 'dkerluke@example.com', '89999228626', '78fdac636315d2de95a08ce5acc65c54306c45a1', '2021-07-06 17:19:19');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('5', 'Fredy', 'Kuhlman', 'yhermann@example.com', '89350187485', '659cb2f73bc25a43099261296a8b43bc77d6918a', '1992-11-07 17:31:07');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('6', 'Ted', 'Abbott', 'eladio65@example.com', '89572245089', 'e5ff80983ec9005d757ff2e2bd1454ba59d59ba2', '1996-12-26 08:20:43');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('7', 'Kylee', 'Weissnat', 'fadel.loy@example.org', '89514681519', 'ab98691010d355fd9bcc32ea9c4e360247bfccea', '2013-05-08 14:38:24');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('8', 'Karelle', 'McKenzie', 'tleannon@example.com', '89679127484', '3faf997d0a1584cdc151aa8019d97f840abba0a7', '2011-01-14 17:31:01');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('9', 'Clotilde', 'Crona', 'gledner@example.com', '89984846524', 'ce87ced64231b34264cc6e618e82b95b50041a4f', '2005-04-08 22:16:18');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('10', 'Eusebio', 'Blanda', 'tschimmel@example.org', '89026847929', 'ff9567cbe005713b6dc8dd1d282213c7157d7616', '2006-12-14 13:21:13');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('11', 'Harley', 'Huel', 'tyrel71@example.org', '89213131757', '01429f001996bf6d897f936f5c3103f5d5b70117', '1994-01-21 18:14:11');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('12', 'Amara', 'Prosacco', 'wklein@example.net', '89127837613', '886f2e887fdee882b58641158c7a849b61d4e5e2', '1991-08-08 14:52:51');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('13', 'Margarette', 'Rodriguez', 'beatty.clotilde@example.com', '89594151397', 'd2f0a9a8c724ccd4c5ec279f95044e7ed7c2527e', '1994-09-10 20:07:00');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('14', 'Bernard', 'Greenholt', 'joana.jacobi@example.net', '89868940196', '00caa44a37fc2d349b1cf6b1e817011fb02ecc38', '2003-02-01 09:24:32');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('15', 'Kamille', 'White', 'brendon.mcdermott@example.net', '89153611856', 'a794ae02673da7d7e5cc16deab054cefc7ba1b11', '2004-02-27 09:53:37');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('16', 'Alexzander', 'Beer', 'gleason.johanna@example.net', '89965677195', '478609d53cf0fe239e5a5042a4bb811f8e65d4e8', '2007-12-07 11:48:18');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('17', 'Maxine', 'Hegmann', 'quigley.lennie@example.com', '89440898429', '89da63671a31bdf0721dea45632cdb4eecc0c731', '2013-08-03 12:55:32');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('18', 'Jamir', 'Murazik', 'corwin.laila@example.net', '89009720238', 'e757775724045311f52f25b556543975653e8852', '2005-11-12 08:14:43');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('19', 'Carleton', 'Jacobi', 'gkoepp@example.net', '89228878820', '0e32ff1b55b3227121f318cadd2c3efd62f842b6', '2008-11-07 04:32:12');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('20', 'Rashawn', 'Labadie', 'ivory.strosin@example.com', '89173506733', '425a74a5e29391e0ece328c8fc99d6300e466d15', '1996-05-03 11:59:12');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('21', 'Nigel', 'White', 'jaida68@example.net', '89722045827', '4539dd8ac799ba3326354305696d6cf965e04d0c', '2000-05-18 05:11:46');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('22', 'Meda', 'Kling', 'smcglynn@example.net', '89251895977', 'b4c0f1815a6eff9339ce6b0de5132799ddb61bb3', '2011-02-02 07:21:11');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('23', 'Eladio', 'Leannon', 'jameson70@example.net', '89573905117', '5de3c887e2cbaa947dc0e06d7c279b32609121ca', '2007-06-02 19:48:56');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('24', 'Hester', 'Lebsack', 'froberts@example.com', '89729608652', 'c048d85b3d39d77cf952b39ddb0e77159a475b7d', '2003-05-12 10:09:44');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('25', 'Glenna', 'Frami', 'howell.kallie@example.net', '89133758693', '22429bdbeecfc6e7c9aaaefbb09d45bb9da162ef', '1997-11-01 10:11:27');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('26', 'Abner', 'Macejkovic', 'janae.zboncak@example.org', '89027978550', 'bb135b3ea98117b525efa70db6fa17e81483b124', '2016-05-31 18:40:49');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('27', 'Jed', 'West', 'dandre46@example.com', '89049217896', 'defcbc4dfde9d81de42426725707c28ba140fabf', '1995-07-15 23:06:43');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('28', 'Jayson', 'Lind', 'mbashirian@example.net', '89992203517', '29aafec8d58b936fbcc2b4afc0022eca832289bd', '2000-08-08 08:09:48');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('29', 'Ova', 'Kessler', 'shudson@example.com', '89072542661', '28f67dd03f9ddd2080b4ac2b6ce1897473ed8639', '2013-11-25 03:53:31');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('30', 'Cielo', 'Marks', 'zack11@example.org', '89486148792', 'd22bb093c29832ade67eb5a927561e1c10215195', '2003-02-02 11:30:05');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('31', 'Sylvan', 'Kassulke', 'emilie88@example.org', '89926310400', '64f47ddef1a0efa079931122dff64393d1802e30', '1996-11-21 13:45:22');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('32', 'Marion', 'Gerlach', 'schumm.keagan@example.org', '89706646698', '7a1d8daddebe2a871c3ee094515bb5248153f3f0', '2012-04-07 09:42:29');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('33', 'Eladio', 'Parisian', 'elias48@example.com', '89314378645', '10658f6b64015011c5955ee47a9568b65072aecc', '1993-12-04 15:50:29');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('34', 'Haylie', 'Harvey', 'william.medhurst@example.net', '89506453949', '8138b0ca2832ff5621982bd7296183f35c30f44a', '2019-04-03 22:03:11');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('35', 'Dana', 'Ward', 'eliza53@example.com', '89466454009', '0a0b36a555dcaf9d9e60228f6eeb057fd4541739', '2011-07-22 00:54:12');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('36', 'Lily', 'Lueilwitz', 'kasey.zulauf@example.net', '89172465058', 'ff269e2297fdaac8705da808734ba1eae71176b1', '1996-08-02 13:11:06');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('37', 'Whitney', 'Emard', 'zulauf.rod@example.org', '89183600436', 'bd0bc0d8702f11e156e07cbc5a96e1c1cbec7576', '1996-11-05 05:59:08');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('38', 'Tyson', 'Barrows', 'rosie42@example.net', '89124215337', '28e1610065981a53f23e5c278c1ceac9a2962832', '2005-03-01 22:29:16');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('39', 'Orlo', 'Friesen', 'dasia.fahey@example.net', '89628309613', '861afec2b2fe32796aea449760ce62831c76d545', '2016-07-09 11:19:26');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('40', 'Axel', 'Cormier', 'isabell23@example.net', '89554473567', '2ad10dd6c01edab94698f9eac7e8d2175c6d36dc', '1992-12-27 12:43:31');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('41', 'Fannie', 'Walter', 'meggie87@example.org', '89484863292', 'e7f2d41f854a92bbba9c3e92c6f00dfc4c44b1f9', '2008-01-24 18:48:46');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('42', 'Thora', 'Rempel', 'qerdman@example.org', '89422232315', '7d324119ea37fda014e214665801a05f56b68510', '2006-07-29 12:17:10');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('43', 'Tatyana', 'Prosacco', 'swift.gerald@example.com', '89761430487', 'e6194f8f7a9dc4ec42fb246b67bd255696d93870', '2001-07-27 12:17:11');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('44', 'Jazmin', 'Price', 'katheryn.kunde@example.org', '89314672872', 'dc62da3e4dd3f6bff6a09eabfd8dc7b6cff89edb', '2000-11-24 11:20:15');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('45', 'Milford', 'Wyman', 'charlene.ward@example.org', '89166862452', 'bf21b80f657f21d62ee0f989dcbac818614b1f20', '2008-02-10 02:16:26');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('46', 'Desiree', 'Jast', 'jensen00@example.org', '89729853977', '78590f0fd5ee7b16dd6d527fc627248090bcd278', '2016-10-29 13:17:36');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('47', 'Anne', 'Labadie', 'baumbach.jefferey@example.org', '89590978107', 'de542a693193dfeb910161d9eab7ef67682ecf13', '1995-10-05 21:57:11');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('48', 'Carmine', 'Lowe', 'gretchen.champlin@example.com', '89349884727', '3eb7bb3d869666519a4096c951474306463e9774', '1997-09-27 11:12:27');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('49', 'Junior', 'Hammes', 'hortense.wyman@example.net', '89558761705', '4197e2ebf0a0d1d07e0e0fcc5da59803e10217e8', '2020-08-03 11:16:33');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('50', 'Ofelia', 'Schmidt', 'kayden.barton@example.org', '89812321761', '567bc5ea07a735397b9050494550e9ec9c60cb79', '2018-04-19 18:26:59');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('51', 'Carrie', 'Schuppe', 'powlowski.stefanie@example.net', '89995424268', '418eb044e0f74874eb54ca6d6b281ecb63c37765', '2017-02-26 17:29:25');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('52', 'Lauryn', 'Daugherty', 'alek47@example.net', '89705624786', 'ccd049c23c138389623ecd3349ee975593e91981', '2018-05-22 21:53:56');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('53', 'Kaylie', 'Ryan', 'strosin.godfrey@example.com', '89315689828', '9151705b1a3ca6571de70cf7df88ed9175407f83', '2003-03-17 00:46:44');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('54', 'Idell', 'Dooley', 'nvolkman@example.org', '89684020509', 'fa34a8f98d79c3a0c24fd4180860e1ed20c71945', '2019-03-03 12:06:14');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('55', 'Shad', 'Kohler', 'tito50@example.com', '89849187603', '44afd7dcc30f468d73e66e78d205dfeaf43a1605', '2003-07-07 21:37:27');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('56', 'Werner', 'Stiedemann', 'gwen54@example.net', '89774149598', 'b20e1e10024106795eb3332d5fe12ccce4bf1130', '2015-03-06 23:37:37');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('57', 'Brandyn', 'Cummerata', 'alia30@example.net', '89592269406', '5b79e6f609260b2e4fb74074069f54e131bacebd', '2002-05-09 23:16:53');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('58', 'Lauren', 'Nader', 'mayert.genoveva@example.net', '89385603014', '96327f28bd515a299ed34a9a55213756e0fccc99', '2021-04-28 15:04:01');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('59', 'Leta', 'Simonis', 'langworth.waldo@example.net', '89587055010', 'edbada6bb7dffc67b6de480ea4569785a443453d', '2009-02-27 07:21:46');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('60', 'Chaya', 'Hessel', 'lbins@example.com', '89991889405', '8b01aeaa3579b0a741f6db7b3af3dfed354f05db', '2008-12-14 12:58:52');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('61', 'Loraine', 'West', 'ylindgren@example.org', '89856863995', '01cb4b214352662308a6f89314d640ad4ca836e5', '2019-08-26 19:59:57');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('62', 'Raheem', 'Yost', 'wolff.ivory@example.org', '89510810678', '3a7c5af263a8a3e7085c70ca589f931fa8cae198', '2020-07-26 16:11:59');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('63', 'Ayla', 'Mante', 'mante.teagan@example.net', '89031243327', 'eb767523aa48b4d86f220e3b0bdb52322262fea6', '2008-06-28 22:44:36');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('64', 'Anahi', 'Veum', 'qkozey@example.net', '89492713683', '29c19ba31feef4890352790cd0453233326c9c11', '1998-01-23 18:20:44');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('65', 'Laverna', 'Christiansen', 'rosalyn42@example.com', '89093430692', 'b5553a1c49ae5d6054d07b03f9ea5794b0642019', '2011-01-13 06:13:47');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('66', 'Lesley', 'Koelpin', 'blair02@example.com', '89697051716', 'e7c9f01e676c2bf81832c7c46495d97401b82486', '2006-03-06 15:21:58');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('67', 'Janick', 'Bartell', 'tmayer@example.net', '89985536884', '3bd73211301d5550044fa5b5d84443bd8202e7ca', '1999-07-26 06:14:27');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('68', 'Katlyn', 'Adams', 'audie03@example.com', '89627944874', '0c7d7ae9fca0307e623989c2b8f1b918c8b3f9b7', '2011-07-21 18:59:56');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('69', 'Katherine', 'Cronin', 'raheem66@example.com', '89991257663', 'bcb3da6c031c14f181cfdf36241a5a5fc336d0ed', '2012-08-25 14:59:16');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('70', 'Merle', 'Mohr', 'zjerde@example.net', '89830752208', 'ae134ce348d0eecdf4b878a2f4fa6875cd6b8b5d', '1999-07-17 18:13:32');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('71', 'Anabelle', 'Hagenes', 'fwindler@example.com', '89431155671', 'fe8b21ffc12c224e8ebf4d0d797f977737432339', '2019-12-11 16:32:38');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('72', 'Lee', 'Kihn', 'alexane.schaden@example.org', '89590726472', '2f90d2e6732e3dedac0f7e9dfca0a732b3286408', '1998-07-18 21:21:54');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('73', 'Ima', 'Dooley', 'jaren12@example.org', '89651239250', 'e364f6b9a857f2a2c1d94b1ba7cbbcc2888a5a5c', '2004-02-26 02:05:30');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('74', 'Aisha', 'Konopelski', 'ccremin@example.com', '89655993586', '93ea073ebb1779ccf1f1f14009791b642aa86529', '1999-05-03 11:51:21');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('75', 'Jameson', 'Mante', 'yrau@example.org', '89015284166', '4975428aab04c47c0db69fbd735b3a50c7e527c6', '2007-08-22 00:28:51');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('76', 'Vena', 'Larkin', 'margarette.lubowitz@example.com', '89428668699', 'a419d5bad76f76ac35b45242c88d84e42d7bb975', '2007-05-03 16:58:45');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('77', 'Jerel', 'Konopelski', 'd\'amore.laury@example.com', '89777758491', '3013971623a7393d4ece3ed3498fffe4181a6bf5', '2017-07-05 07:38:57');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('78', 'Trey', 'O\'Connell', 'queen03@example.net', '89131447542', 'f8b0e431245d73dcbad98d402669f27e37351207', '1995-08-01 06:25:42');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('79', 'Samanta', 'Moore', 'heller.jewel@example.org', '89105511182', 'c016c8fb1330e89edb7fc94a37136e3896209ed5', '2006-07-15 00:04:49');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('80', 'Darwin', 'Cummerata', 'doris73@example.net', '89285092667', '31d1f64c942cab57deac47132c35385fb6739b55', '2006-05-19 00:15:21');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('81', 'Gerald', 'Adams', 'hoppe.jaylen@example.com', '89989330033', '93e1bd27b9cc40db1797f544b5c95ac0308d4bd0', '2013-11-20 16:01:47');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('82', 'Kendrick', 'Paucek', 'genoveva92@example.com', '89786016031', '6a7e34a4d3dcc794ba7f25dcdb01540fb0d08dc1', '2017-11-26 18:59:52');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('83', 'Vito', 'Sawayn', 'kbeahan@example.org', '89647073104', '39e69c34a6859140e2ab4e308e7e72edfc7435d6', '2015-03-23 23:52:02');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('84', 'Matilda', 'Rath', 'stoltenberg.delaney@example.net', '89105057581', '407ea14e5bbf7a3f64bf5fe84e1a28c08f31ef60', '1998-03-20 17:10:31');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('85', 'Arvid', 'Volkman', 'sheldon71@example.net', '89640469228', 'b6be5940ccb7af7aefa6b1ad9d29138bb51b8bf6', '1998-04-30 21:55:21');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('86', 'Marilou', 'Schroeder', 'litzy58@example.org', '89679292595', 'd29e85c93ee85e970aeba33813273088b5aecc22', '2004-08-31 08:31:17');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('87', 'Kylie', 'Jones', 'kreichel@example.org', '89843175945', 'bb7f2af0bb7a30005a1deb536376ba6f38c59a1c', '2006-04-12 04:52:45');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('88', 'Nelda', 'Daugherty', 'veum.kendra@example.net', '89277631865', '2560a96bba297603a83b4627566ed6aba0be52a2', '1998-10-21 12:59:35');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('89', 'Zachery', 'Monahan', 'adele30@example.net', '89143497905', '9090b4cadfcb83a477241865085e1dc92f8df65a', '2013-03-28 07:08:30');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('90', 'Sandrine', 'McLaughlin', 'roxane.farrell@example.com', '89921532584', '29a5c79ceb64cb671b4c2c6958a4decedadbb788', '2014-12-20 11:32:38');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('91', 'Fabian', 'Christiansen', 'rippin.jailyn@example.org', '89080777810', '01d12853bd55ceba50374d74a360f62c37c40d73', '2000-05-26 15:48:13');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('92', 'Zane', 'Russel', 'tanner.walsh@example.com', '89642708802', 'df62e32d7b5765ef2588e2fb1f5fe7534d0f32af', '1998-08-02 22:05:05');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('93', 'Carol', 'Hilll', 'kendra51@example.com', '89139471091', 'db3827ea6cb8b80065080e6f54ffaf32e9efad3e', '2004-12-05 05:28:48');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('94', 'Kody', 'Becker', 'sydnie47@example.com', '89166674968', '338d3bfd7c632e76f23ddbd97686c084f72deddd', '2014-09-20 19:40:19');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('95', 'Mackenzie', 'Koch', 'regan.bergnaum@example.com', '89811040074', 'ffc19dcefce220bd25f5d02d90f45fb54c29e5c4', '1996-07-21 22:51:53');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('96', 'Abdiel', 'Kemmer', 'hoeger.josh@example.net', '89858366798', '94b4575e33eafd90c9b391e80edc75ec6d099581', '1998-07-01 17:00:59');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('97', 'Bryce', 'Moore', 'shammes@example.com', '89836437526', 'd21058eb25951af18373f894cb2f4fe2bbc2a9f6', '2002-03-17 08:17:13');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('98', 'Dillon', 'Thiel', 'gutmann.floy@example.net', '89834323938', '7434297c703e67ac67681952feefcd1a52d94f3d', '2004-06-01 06:32:15');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('99', 'Jaylen', 'Bauch', 'enrique.kling@example.com', '89866586136', '5bcfa31350abad1a4cbb4885842f1a99c86cc827', '2018-10-06 23:34:16');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `created_at`) VALUES ('100', 'Chadd', 'McKenzie', 'benjamin58@example.com', '89161695631', '21d8d09bd3c7c21c743dbae77f6bb801915039ba', '2014-01-07 01:47:59');

INSERT INTO `communities` (`id`, `name`, `description`, `admin_id`) VALUES ('1', 'aperiam', 'Dolorem est unde est. Sed tempore porro vitae voluptatem dicta unde est qui. Voluptatum quaerat assumenda culpa mollitia ut alias laudantium.', '92');
INSERT INTO `communities` (`id`, `name`, `description`, `admin_id`) VALUES ('2', 'perferendis', 'Sequi quis consequuntur cum et. Enim nihil amet doloremque tenetur soluta est. Quaerat exercitationem quia qui delectus. Temporibus nisi autem dolor itaque sed.', '80');
INSERT INTO `communities` (`id`, `name`, `description`, `admin_id`) VALUES ('3', 'quis', 'Et rerum similique est cumque. A placeat minima quaerat fugit non. Error quae voluptas natus. Iure iure consequatur tempore debitis voluptatum quae ipsum sapiente.', '73');
INSERT INTO `communities` (`id`, `name`, `description`, `admin_id`) VALUES ('4', 'et', 'Itaque pariatur velit sapiente mollitia voluptatibus sint. Voluptatum molestiae illo corporis esse omnis laborum ipsam quod. Nemo sit nisi ad odit aliquid. Cumque nobis iusto alias velit.', '84');
INSERT INTO `communities` (`id`, `name`, `description`, `admin_id`) VALUES ('5', 'voluptatem', 'Saepe voluptas accusamus et qui quia hic quaerat. Et pariatur quo neque possimus molestiae velit possimus et. Dolor magni qui dolorum consequatur nam illum iste. Illum magni eos molestiae fuga et adipisci. Quia rerum recusandae asperiores ad.', '32');
INSERT INTO `communities` (`id`, `name`, `description`, `admin_id`) VALUES ('6', 'sunt', 'Impedit earum voluptate officia debitis ipsum. Quasi qui sequi illo et debitis sunt ut. Quaerat sint qui repellat. Et excepturi est non dicta.', '92');
INSERT INTO `communities` (`id`, `name`, `description`, `admin_id`) VALUES ('7', 'eius', 'A fugit ex vel ut ut autem sed. Voluptatum ducimus praesentium dolor mollitia et consectetur officia ut. Et voluptatem et rem iure. Rerum itaque quidem repudiandae non et totam sint. Illum omnis aperiam esse aut facilis culpa voluptatem autem.', '91');
INSERT INTO `communities` (`id`, `name`, `description`, `admin_id`) VALUES ('8', 'cupiditate', 'Rem quo voluptatem dolorem iusto. Totam consectetur quasi sunt quidem. Cum rerum quas non iste et illo rerum.', '31');
INSERT INTO `communities` (`id`, `name`, `description`, `admin_id`) VALUES ('9', 'doloribus', 'Dicta corporis natus veritatis facilis aut consequuntur. Minus dolorum reprehenderit ut aut quaerat tenetur. Aliquam harum dolorem voluptatem enim. Et reprehenderit qui assumenda tempore.', '90');
INSERT INTO `communities` (`id`, `name`, `description`, `admin_id`) VALUES ('10', 'qui', 'Minus tenetur facere autem aut. Excepturi molestias ut accusantium quaerat.', '86');
INSERT INTO `communities` (`id`, `name`, `description`, `admin_id`) VALUES ('11', 'atque', 'Dolorem et sit animi voluptas commodi nam pariatur. Quaerat deleniti vel incidunt quae non doloremque. Aut unde sint omnis doloribus quia.', '71');
INSERT INTO `communities` (`id`, `name`, `description`, `admin_id`) VALUES ('12', 'commodi', 'Asperiores dolorem at maiores maxime rem blanditiis. Excepturi dolor omnis rerum nam ratione cupiditate.', '31');
INSERT INTO `communities` (`id`, `name`, `description`, `admin_id`) VALUES ('13', 'ullam', 'Nulla ut ipsa consequatur porro aut. Et vel aspernatur enim quos. Omnis repellat sed numquam qui ex. Eos sapiente sint nostrum enim sed qui.', '31');
INSERT INTO `communities` (`id`, `name`, `description`, `admin_id`) VALUES ('14', 'quos', 'Aspernatur sed nihil ea voluptatem. Itaque dolore autem accusamus consectetur quibusdam alias quis. Eligendi asperiores officiis cupiditate reiciendis vel atque qui.', '46');
INSERT INTO `communities` (`id`, `name`, `description`, `admin_id`) VALUES ('15', 'quis', 'Vero officiis quasi voluptatem necessitatibus voluptatibus. Omnis consectetur aliquid repudiandae rerum sunt dignissimos maxime et. Nostrum corporis sed ut id sunt cum.', '6');
INSERT INTO `communities` (`id`, `name`, `description`, `admin_id`) VALUES ('16', 'sint', 'Unde tempore et blanditiis aut ullam. Repellat molestiae voluptate aut. Sit sit consequatur et reiciendis quis. Doloremque nihil earum id aliquid fugiat aut ipsum repellendus. Velit cupiditate est vitae est.', '82');
INSERT INTO `communities` (`id`, `name`, `description`, `admin_id`) VALUES ('17', 'ab', 'Facilis dolorum quaerat quo incidunt modi. Maiores in alias dolorem tenetur. Nesciunt repudiandae officiis esse temporibus quae. In ratione rerum aperiam facilis dolores et.', '12');
INSERT INTO `communities` (`id`, `name`, `description`, `admin_id`) VALUES ('18', 'occaecati', 'Libero quisquam praesentium aliquid maiores. Maxime illum natus error quia explicabo. Qui eum nobis ut corporis reprehenderit voluptatem. Expedita iste vel quia consequuntur cupiditate.', '36');
INSERT INTO `communities` (`id`, `name`, `description`, `admin_id`) VALUES ('19', 'magnam', 'Vel omnis aut illo deleniti. Qui sint natus est consequuntur. Dolor voluptatem sint porro et quidem.', '16');
INSERT INTO `communities` (`id`, `name`, `description`, `admin_id`) VALUES ('20', 'provident', 'Voluptatem cumque nostrum dignissimos magni ratione est quos. Natus iusto beatae ducimus nemo harum distinctio itaque. Quia eum voluptates unde quam blanditiis. Tempora beatae at soluta ut. Sit ducimus sed nihil est quis ut perspiciatis.', '57');
INSERT INTO `communities` (`id`, `name`, `description`, `admin_id`) VALUES ('21', 'molestiae', 'Cupiditate porro ipsam rerum molestiae suscipit commodi iste. Qui totam totam voluptate aut. Mollitia ducimus necessitatibus totam et sint tempore. Ullam dignissimos omnis eius consequuntur est.', '13');
INSERT INTO `communities` (`id`, `name`, `description`, `admin_id`) VALUES ('22', 'officiis', 'Dolorem voluptatem harum laborum ad. Error totam est accusantium aliquid necessitatibus repellendus praesentium. Maiores ipsum nihil voluptatem sunt ut. Ad modi nam quaerat ea error.', '9');
INSERT INTO `communities` (`id`, `name`, `description`, `admin_id`) VALUES ('23', 'non', 'Exercitationem sint dolores nihil modi iste aliquam qui labore. Hic ea est modi. Totam blanditiis qui voluptatem aut voluptatibus consequatur. Labore dolore unde similique rerum. Vel dicta excepturi nemo eos quis laborum officiis.', '52');
INSERT INTO `communities` (`id`, `name`, `description`, `admin_id`) VALUES ('24', 'est', 'Iusto eaque tempora accusantium voluptatem aperiam veniam soluta. Ea ut dolores eum aut. Voluptas velit architecto blanditiis cum.', '23');
INSERT INTO `communities` (`id`, `name`, `description`, `admin_id`) VALUES ('25', 'aut', 'Voluptatem placeat aut modi. Enim ut suscipit unde.', '40');

INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('1', '27', '2021-07-13 10:28:42');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('1', '34', '2021-06-21 11:44:51');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('1', '46', '2021-07-09 22:42:21');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('1', '57', '2021-06-30 20:44:19');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('1', '82', '2021-06-23 15:27:19');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('1', '90', '2021-07-05 18:57:23');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('1', '98', '2021-06-30 14:07:19');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('2', '48', '2021-07-10 16:04:13');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('2', '53', '2021-07-13 13:57:15');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('2', '74', '2021-06-28 18:27:57');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('2', '83', '2021-06-27 11:37:02');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('2', '85', '2021-07-10 21:15:44');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('2', '91', '2021-07-06 22:43:59');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('3', '8', '2021-06-29 21:01:07');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('3', '29', '2021-07-06 04:20:58');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('4', '3', '2021-07-09 06:09:59');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('4', '18', '2021-06-18 09:16:05');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('4', '53', '2021-07-11 17:08:38');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('4', '57', '2021-07-04 13:45:27');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('4', '79', '2021-06-17 12:54:48');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('4', '96', '2021-06-24 14:33:49');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('4', '100', '2021-07-04 04:32:35');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('5', '9', '2021-06-15 01:52:12');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('5', '25', '2021-06-18 09:37:07');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('5', '45', '2021-06-17 04:28:06');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('5', '65', '2021-06-23 12:41:43');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('6', '4', '2021-06-20 05:04:15');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('6', '15', '2021-06-30 09:20:07');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('6', '73', '2021-06-21 13:21:58');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('6', '78', '2021-07-09 05:29:19');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('7', '26', '2021-06-19 21:13:16');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('7', '45', '2021-07-03 23:05:28');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('7', '54', '2021-07-02 09:42:02');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('7', '89', '2021-06-24 23:34:32');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('8', '9', '2021-06-28 03:37:01');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('8', '35', '2021-07-04 08:50:42');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('8', '48', '2021-06-21 12:38:50');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('8', '53', '2021-06-26 15:16:30');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('8', '61', '2021-07-06 15:24:08');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('9', '48', '2021-06-15 08:49:47');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('10', '36', '2021-06-14 15:10:51');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('10', '46', '2021-07-02 11:32:43');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('11', '2', '2021-07-13 12:36:37');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('11', '33', '2021-06-21 11:00:19');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('11', '55', '2021-06-26 00:19:01');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('11', '58', '2021-06-22 23:42:33');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('11', '59', '2021-06-19 18:36:31');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('11', '99', '2021-06-20 16:42:14');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('12', '33', '2021-07-05 07:19:04');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('12', '40', '2021-06-21 21:31:41');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('12', '75', '2021-06-15 03:46:36');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('12', '89', '2021-06-21 05:57:17');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('13', '14', '2021-07-14 09:42:00');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('13', '18', '2021-06-16 01:08:18');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('13', '21', '2021-06-26 17:47:32');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('13', '35', '2021-06-18 09:54:23');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('13', '37', '2021-07-09 13:01:51');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('14', '55', '2021-06-30 11:30:50');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('14', '73', '2021-07-04 07:59:30');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('14', '91', '2021-06-20 12:08:26');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('14', '96', '2021-07-11 05:08:33');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('15', '20', '2021-07-08 07:35:33');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('15', '58', '2021-07-02 16:41:42');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('15', '62', '2021-06-15 21:23:10');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('16', '35', '2021-06-20 17:56:31');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('16', '61', '2021-07-07 20:34:53');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('17', '4', '2021-06-23 13:40:01');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('17', '24', '2021-06-24 20:47:27');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('17', '35', '2021-06-17 12:32:48');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('18', '5', '2021-06-17 12:32:35');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('18', '35', '2021-06-27 01:22:17');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('18', '36', '2021-07-11 22:47:04');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('18', '47', '2021-06-25 03:35:07');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('18', '49', '2021-06-21 06:37:38');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('18', '50', '2021-06-21 12:37:49');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('18', '96', '2021-06-24 10:24:59');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('19', '22', '2021-07-02 01:45:29');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('19', '57', '2021-06-17 17:09:16');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('19', '91', '2021-06-16 01:08:55');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('20', '43', '2021-07-03 22:14:08');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('20', '83', '2021-06-15 03:52:59');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('21', '16', '2021-06-30 10:38:08');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('21', '53', '2021-06-25 22:48:15');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('21', '79', '2021-07-07 13:58:37');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('21', '80', '2021-07-09 10:36:09');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('21', '99', '2021-06-30 23:35:29');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('22', '42', '2021-07-04 13:49:18');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('23', '19', '2021-07-03 16:55:38');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('23', '38', '2021-06-24 18:49:40');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('23', '54', '2021-06-14 23:28:18');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('23', '62', '2021-06-17 21:16:28');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('23', '83', '2021-06-17 03:22:48');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('24', '28', '2021-06-29 07:25:45');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('24', '31', '2021-06-17 16:09:04');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('24', '34', '2021-07-04 07:19:08');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('24', '45', '2021-06-26 04:33:36');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('24', '87', '2021-07-06 22:29:57');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('25', '15', '2021-07-01 20:14:48');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('25', '44', '2021-07-04 22:52:45');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES ('25', '79', '2021-06-28 06:09:12');

INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('5', '96', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('5', '51', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('5', '30', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('5', '35', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('5', '11', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('5', '29', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('5', '20', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('5', '83', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('5', '16', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('5', '32', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('19', '49', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('22', '31', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('24', '76', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('25', '52', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('26', '21', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('27', '78', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('28', '97', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('34', '1', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('37', '98', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('38', '92', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('39', '65', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('40', '66', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('41', '73', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('42', '64', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('46', '61', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('47', '23', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('50', '82', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('53', '15', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('55', '43', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('57', '44', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('58', '70', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('59', '7', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('60', '68', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('63', '48', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('67', '56', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('71', '91', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('72', '5', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('77', '69', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('80', '88', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('84', '81', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('86', '45', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('87', '36', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('89', '33', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('90', '74', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('93', '8', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('94', '2', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('95', '62', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('96', '85', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('99', '75', 0);
INSERT INTO `friend_requests` (`from_user_id`, `to_user_id`, `accepted`) VALUES ('100', '79', 0);

INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('1', '1', 3, 'deleniti', '688', '2021-06-16 14:44:40');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('2', '2', 2, 'molestiae', '1941', '2021-06-22 08:48:46');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('3', '3', 4, 'mollitia', '205', '2021-06-28 06:49:01');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('4', '4', 4, 'esse', '2215', '2021-06-25 23:59:46');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('5', '5', 2, 'fugit', '1160', '2021-06-20 22:39:09');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('6', '6', 3, 'voluptatum', '999', '2021-06-16 12:52:47');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('7', '7', 4, 'inventore', '3794', '2021-07-08 11:28:50');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('8', '8', 1, 'unde', '2904', '2021-06-20 08:37:56');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('9', '9', 2, 'perferendis', '1009', '2021-07-07 03:20:05');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('10', '10', 2, 'similique', '3941', '2021-07-10 02:34:10');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('11', '11', 1, 'quia', '1794', '2021-07-05 18:12:31');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('12', '12', 2, 'neque', '1690', '2021-07-02 06:31:16');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('13', '13', 3, 'aliquid', '1134', '2021-07-11 08:43:47');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('14', '14', 1, 'porro', '1813', '2021-07-02 22:43:52');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('15', '15', 3, 'illo', '135', '2021-07-12 20:31:21');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('16', '16', 3, 'vel', '593', '2021-06-30 23:48:09');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('17', '17', 3, 'aut', '3634', '2021-06-18 06:00:35');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('18', '18', 2, 'eius', '2106', '2021-06-22 03:36:52');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('19', '19', 1, 'ut', '2566', '2021-07-06 17:43:58');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('20', '20', 2, 'dolores', '2686', '2021-06-20 23:18:57');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('21', '21', 3, 'rerum', '1606', '2021-07-03 19:27:52');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('22', '22', 4, 'dicta', '1282', '2021-07-14 12:24:02');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('23', '23', 4, 'illo', '3506', '2021-06-16 22:19:23');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('24', '24', 4, 'soluta', '1165', '2021-07-14 11:47:39');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('25', '25', 1, 'similique', '961', '2021-06-23 01:53:38');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('26', '26', 2, 'quod', '2870', '2021-07-01 23:34:30');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('27', '27', 2, 'quod', '1194', '2021-06-30 20:58:30');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('28', '28', 1, 'dignissimos', '2319', '2021-07-06 01:29:09');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('29', '29', 4, 'delectus', '1119', '2021-06-19 22:46:26');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('30', '30', 4, 'et', '3211', '2021-07-08 03:16:56');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('31', '31', 3, 'consequuntur', '973', '2021-06-29 16:22:26');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('32', '32', 3, 'impedit', '1138', '2021-06-16 17:19:28');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('33', '33', 1, 'aut', '473', '2021-06-23 23:37:31');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('34', '34', 2, 'libero', '2754', '2021-06-22 17:42:43');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('35', '35', 3, 'suscipit', '1422', '2021-06-20 17:00:10');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('36', '36', 2, 'et', '3605', '2021-06-22 00:19:30');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('37', '37', 2, 'quis', '1040', '2021-06-26 23:49:53');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('38', '38', 4, 'distinctio', '835', '2021-06-20 00:03:26');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('39', '39', 1, 'sint', '1398', '2021-06-22 16:53:35');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('40', '40', 2, 'non', '1392', '2021-06-23 06:32:29');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('41', '41', 4, 'numquam', '269', '2021-06-26 13:16:01');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('42', '42', 3, 'voluptatem', '596', '2021-07-01 04:01:56');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('43', '43', 4, 'harum', '589', '2021-06-20 13:26:37');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('44', '44', 1, 'iusto', '2286', '2021-07-04 17:28:31');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('45', '45', 4, 'consequatur', '2472', '2021-06-26 21:54:30');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('46', '46', 1, 'doloremque', '3835', '2021-07-14 12:39:22');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('47', '47', 2, 'necessitatibus', '1923', '2021-06-27 01:15:23');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('48', '48', 3, 'molestiae', '2383', '2021-06-16 13:21:40');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('49', '49', 2, 'dolor', '2225', '2021-06-15 06:55:08');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('50', '50', 3, 'ut', '2574', '2021-06-21 15:25:24');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('51', '51', 4, 'dolores', '2200', '2021-07-10 09:27:38');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('52', '52', 4, 'ut', '2279', '2021-06-15 06:59:36');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('53', '53', 4, 'at', '3407', '2021-06-24 19:37:53');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('54', '54', 1, 'rem', '3629', '2021-06-24 22:52:08');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('55', '55', 4, 'eaque', '1468', '2021-06-15 02:47:20');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('56', '56', 2, 'rerum', '3510', '2021-06-30 03:59:51');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('57', '57', 3, 'enim', '1282', '2021-07-11 06:22:45');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('58', '58', 1, 'ut', '3589', '2021-06-17 13:37:17');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('59', '59', 2, 'placeat', '3400', '2021-06-14 21:24:33');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('60', '60', 3, 'dolor', '1101', '2021-06-23 07:37:08');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('61', '61', 2, 'est', '3847', '2021-06-25 06:09:28');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('62', '62', 1, 'odio', '1656', '2021-06-14 22:49:13');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('63', '63', 2, 'sit', '3049', '2021-06-16 17:44:18');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('64', '64', 3, 'ut', '942', '2021-07-10 19:41:39');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('65', '65', 4, 'fugit', '515', '2021-06-20 20:10:37');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('66', '66', 1, 'placeat', '2539', '2021-07-03 07:01:03');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('67', '67', 4, 'qui', '1449', '2021-06-15 08:59:33');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('68', '68', 2, 'debitis', '2957', '2021-07-10 21:45:33');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('69', '69', 1, 'quia', '135', '2021-06-23 01:14:17');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('70', '70', 4, 'eveniet', '3187', '2021-07-09 09:46:32');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('71', '71', 2, 'sed', '2279', '2021-07-11 05:56:37');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('72', '72', 1, 'aut', '1799', '2021-07-01 09:23:24');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('73', '73', 4, 'quos', '1477', '2021-06-20 08:00:04');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('74', '74', 1, 'optio', '2245', '2021-06-20 19:33:30');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('75', '75', 4, 'blanditiis', '593', '2021-06-15 10:14:21');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('76', '76', 1, 'alias', '1883', '2021-06-27 00:54:15');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('77', '77', 2, 'repellendus', '310', '2021-06-20 08:40:10');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('78', '78', 3, 'est', '2794', '2021-07-10 01:03:55');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('79', '79', 4, 'assumenda', '1049', '2021-07-12 06:57:12');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('80', '80', 1, 'facilis', '2481', '2021-06-26 21:51:56');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('81', '81', 3, 'aspernatur', '2378', '2021-07-05 11:14:24');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('82', '82', 1, 'fugit', '2258', '2021-06-28 04:30:45');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('83', '83', 2, 'autem', '1791', '2021-06-29 06:01:42');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('84', '84', 4, 'doloribus', '2250', '2021-07-10 07:07:07');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('85', '85', 3, 'velit', '3553', '2021-06-30 14:58:32');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('86', '86', 4, 'eligendi', '936', '2021-06-15 20:41:33');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('87', '87', 3, 'iusto', '3804', '2021-07-03 05:40:29');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('88', '88', 3, 'architecto', '2441', '2021-06-18 23:15:56');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('89', '89', 1, 'eius', '244', '2021-06-25 00:58:06');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('90', '90', 3, 'eum', '2488', '2021-07-03 15:03:03');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('91', '91', 1, 'sequi', '191', '2021-06-26 02:19:07');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('92', '92', 4, 'optio', '1060', '2021-06-28 17:09:50');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('93', '93', 4, 'sit', '970', '2021-07-01 01:00:34');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('94', '94', 1, 'aliquid', '1798', '2021-06-26 08:58:55');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('95', '95', 3, 'ex', '323', '2021-06-18 19:36:37');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('96', '96', 2, 'aut', '3503', '2021-06-27 20:17:43');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('97', '97', 2, 'et', '2662', '2021-06-25 23:04:02');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('98', '98', 3, 'quo', '1481', '2021-07-05 04:50:26');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('99', '99', 1, 'alias', '1845', '2021-06-24 22:13:18');
INSERT INTO `media` (`id`, `user_id`, `media_types_id`, `file_name`, `file_size`, `created_at`) VALUES ('100', '100', 2, 'non', '1742', '2021-07-06 14:31:56');

INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('1', '5', '85', 'Id quia corrupti a sequi quisquam mollitia. Quod quo quia velit enim officiis ut. Suscipit ut id possimus quibusdam nihil doloremque porro dignissimos. Aspernatur assumenda porro aut placeat ab.', 0, '1992-06-24 09:16:34', '2021-04-17 11:47:14');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('2', '59', '27', 'Beatae eum deserunt illo ab velit itaque fugiat. Aut maxime voluptatem corporis est quam minus. Ipsam corporis fugit tenetur dicta.', 1, '1979-02-23 16:42:42', '2020-11-22 07:30:32');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('3', '5', '69', 'Recusandae quod molestias eum fugit. Temporibus voluptatem aut sit tempore saepe est iusto. Laudantium vero sunt est est.', 1, '1985-06-02 20:18:05', '2020-11-06 23:16:29');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('4', '5', '55', 'Sint placeat sit consequuntur ut porro. Qui ea enim quis libero minus dolor quo dolores. Distinctio enim unde quis minima ex facilis esse.', 1, '2000-01-15 22:52:24', '2021-03-15 21:48:38');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('5', '5', '96', 'Ea voluptas velit molestias consequuntur. Voluptatum sunt est officiis quia.', 1, '1982-06-30 23:13:25', '2021-04-24 05:36:07');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('6', '54', '8', 'Eos natus libero distinctio quia harum ipsa. Autem eos repellendus deleniti natus pariatur mollitia libero. Magni nihil qui iusto est eveniet dolorem labore.', 1, '2002-01-17 13:40:58', '2020-10-24 09:06:50');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('7', '5', '48', 'Dolorem eligendi minima ipsa aliquid. Architecto praesentium voluptatem asperiores velit. Id blanditiis sequi odio.', 1, '1976-05-01 08:16:54', '2020-10-02 04:54:39');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('8', '5', '33', 'Sunt facere ut culpa aperiam rerum sit voluptatem. Provident veritatis a hic molestiae dolorum. Error modi amet nostrum.', 1, '2002-12-28 07:30:39', '2021-03-22 05:46:51');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('9', '7', '35', 'Sed vero voluptates aut molestias. Sit accusantium adipisci aut eum fuga perspiciatis. Voluptatem hic impedit reiciendis et. Est nam dolores hic ut et sit.', 1, '1976-03-29 03:24:30', '2020-11-15 12:24:26');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('10', '3', '94', 'Ut tenetur repellendus iure molestiae temporibus consequatur. Sapiente laboriosam maiores nihil reiciendis. Aut modi totam quia consequuntur et omnis neque officia. Et aut aut qui voluptates.', 0, '1999-09-17 06:23:50', '2021-04-02 19:58:32');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('11', '5', '22', 'Vitae dolorum mollitia harum labore aut temporibus et sed. Eum ea aliquam ipsa ullam. Molestiae deleniti nostrum consectetur et ut. Dicta laboriosam deleniti quaerat nulla.', 0, '1990-09-28 12:27:07', '2020-08-27 20:42:28');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('12', '4', '10', 'Voluptas est nobis et. Et et sunt et repellendus eius velit. Ut eligendi quia nesciunt omnis.\nEarum quia dolores quas autem et quia sit. Numquam velit quia eveniet sint iusto dolorem quia.', 0, '1988-10-12 03:03:00', '2021-06-23 23:35:25');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('13', '5', '14', 'Deserunt eaque rerum debitis. Ut voluptatem asperiores maiores sunt.', 0, '2015-12-26 04:45:54', '2020-07-14 20:40:48');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('14', '100', '85', 'Doloremque quod iste fugit reiciendis beatae consequatur sunt. Sunt dolores veritatis quia aut.', 0, '1993-11-09 09:36:20', '2020-08-03 21:02:19');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('15', '23', '46', 'Doloremque a nihil commodi et. Quasi ex fugiat rem molestias. Culpa sed nihil magnam nam aut.', 0, '2007-08-21 01:15:28', '2020-12-08 20:29:12');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('16', '5', '100', 'Quas corporis neque sit voluptatum. Velit ut in soluta facere sed nihil. Possimus rerum hic similique sit corrupti.', 1, '2001-10-13 06:14:31', '2021-03-17 15:21:34');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('17', '5', '57', 'Non recusandae et occaecati fugiat. Et inventore aliquam sint beatae provident quis omnis. Rerum fugit dolorum sit aut voluptatem tempore ab.', 1, '1985-08-08 15:41:41', '2021-07-11 00:21:59');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('18', '5', '57', 'Eius sunt corrupti dolores cupiditate. Perspiciatis dolorem nobis eveniet libero. Et qui exercitationem ullam sed voluptates et nesciunt.', 0, '1973-05-15 08:29:49', '2021-06-03 15:50:26');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('19', '5', '57', 'Itaque voluptas veniam ut sint accusamus nam. Odit sit omnis a et vel nemo eligendi consectetur.', 1, '1998-02-10 21:58:57', '2021-04-01 19:34:40');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('20', '23', '39', 'Animi et aut dolor illum earum. Temporibus velit et omnis aut maiores illum ut. Rem atque eius numquam illo nulla. Et nesciunt ullam aut voluptate. Sit ullam illum qui qui et.', 1, '1996-01-30 13:02:45', '2020-12-14 18:50:57');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('21', '46', '42', 'Eos saepe et qui est ea quia a. Aut rerum enim asperiores corporis cum inventore. Rerum qui maiores numquam rem quae. Doloremque totam recusandae sed voluptas dolores ullam dolorem.', 1, '1980-05-01 00:23:12', '2020-09-22 07:17:52');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('22', '92', '89', 'Id aperiam nihil qui. Veritatis corrupti officiis maiores enim. Sapiente nesciunt iusto ullam nemo quis molestias est occaecati.', 0, '1981-08-24 15:50:25', '2021-01-07 05:49:10');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('23', '7', '53', 'Totam aperiam hic corporis minima. Non neque aut eum voluptas eum. Sed quae unde exercitationem.\nQuos dolor nemo eum vel. Aut voluptas eos modi quis.', 0, '2020-01-28 13:57:32', '2021-01-13 22:05:35');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('24', '48', '10', 'Eius soluta maiores nam saepe amet nulla adipisci. Minima non nihil voluptas velit ratione.', 0, '1971-04-08 08:27:36', '2021-07-09 17:02:09');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('25', '52', '3', 'Asperiores ad fugit consequuntur est quo. Et architecto sint ut vel. Quos aspernatur minima minus deserunt.', 0, '2005-06-10 10:03:00', '2021-01-10 14:07:36');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('26', '32', '12', 'Odio in incidunt assumenda ad. Perferendis porro sunt quia. Illo aut voluptatem ipsa et minus voluptatem dignissimos esse. Dicta assumenda porro nihil nam nemo ipsam.', 0, '1981-02-23 18:53:32', '2020-11-15 11:54:51');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('27', '19', '22', 'Vel cupiditate ad similique harum. Et nihil officiis in rerum eum cupiditate ut. Quia nesciunt est unde assumenda.', 1, '1997-03-17 09:02:33', '2020-12-25 09:18:36');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('28', '71', '62', 'Earum quidem quia quia sint non. Amet sed ducimus nisi a sapiente non. Sit non qui necessitatibus fugit soluta mollitia.', 0, '1990-11-13 19:12:30', '2020-10-27 00:48:57');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('29', '46', '14', 'Et quod velit libero quis voluptatum exercitationem dolores. Quam quas quaerat voluptas nulla. Hic repellat ut sed voluptatem.', 1, '1988-07-29 07:15:05', '2021-06-20 01:04:50');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('30', '33', '16', 'Laborum id consequatur vel consequuntur voluptatum velit quisquam et. Et facilis est autem est nemo. Ex repellat error quaerat porro consequatur libero in.', 1, '1984-03-30 08:55:04', '2021-07-03 18:29:02');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('31', '52', '48', 'Aut corrupti corrupti magni officia ut. Ex exercitationem explicabo cum aut. Quis sit voluptatibus est dignissimos cum. Voluptatum unde fugit quas natus.', 0, '1985-05-13 02:09:14', '2020-08-26 00:31:26');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('32', '50', '8', 'Tenetur est alias aut. Eum adipisci omnis corporis hic voluptas provident qui quas. Repellendus rerum error numquam dolores quidem. Deleniti placeat nobis deleniti laborum nemo.', 0, '2004-11-03 12:34:28', '2020-09-06 17:59:51');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('33', '21', '69', 'Assumenda ipsam quas mollitia est repellat illo est. Quisquam ipsum sit magni aut harum numquam. Aperiam minus impedit qui delectus.', 0, '2006-06-26 21:21:01', '2021-06-08 13:16:47');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('34', '100', '62', 'Quam nihil aut enim perferendis iste. Officiis doloremque asperiores corporis dolorum. Asperiores deleniti ipsa eum. Provident facilis voluptatem molestiae laborum consequuntur voluptas deleniti.', 0, '2017-11-28 03:19:07', '2020-07-17 19:09:49');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('35', '29', '3', 'Voluptatem nihil at sint et minima eum sit. Ut vel et facilis ut nobis. Et a iste ducimus quos asperiores numquam fugit corporis.', 1, '1976-08-02 12:51:33', '2021-04-25 04:55:33');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('36', '42', '16', 'Ea ab molestiae alias consectetur. Provident officia quisquam aut at odit quas. Qui quaerat dolore reiciendis sit consectetur facilis. Aspernatur aut maiores consequatur voluptate suscipit.', 1, '1998-09-23 21:21:32', '2020-12-06 23:06:25');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('37', '19', '24', 'Voluptate possimus possimus dolores et. Recusandae dolor error quam quaerat ab. Consequatur illum quasi nostrum atque. Animi quia neque repellendus unde unde eum. Numquam quos alias eum.', 1, '1985-11-10 20:19:35', '2021-04-14 11:48:10');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('38', '32', '93', 'Est nobis fugiat repellendus ut. Eum qui ullam iusto magni. Voluptatum maiores ut officiis qui aliquid. Et eos qui magni voluptas.', 0, '2017-04-15 06:14:07', '2021-02-15 06:02:50');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('39', '14', '86', 'Minima esse non voluptatem incidunt. Laudantium ut corporis consequuntur error maxime soluta. Ut culpa et et nobis. Aliquam quo quas sunt vitae repellat.', 1, '1976-03-28 11:27:49', '2020-10-28 16:34:06');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('40', '5', '96', 'Architecto porro ad est. Consequatur eum sint excepturi. Nostrum aliquid tempore est autem recusandae sit voluptatibus.', 1, '1989-04-26 12:13:01', '2021-05-15 11:04:53');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('41', '72', '74', 'Voluptatum consequatur qui amet. Qui nobis adipisci officia qui consequuntur dolores blanditiis.', 0, '1987-11-24 13:52:49', '2021-03-08 22:21:32');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('42', '5', '87', 'Sequi rerum occaecati ratione corporis. Magnam et fugit vitae assumenda aperiam quia. Inventore eveniet fugiat nostrum unde temporibus consequatur. Quibusdam minima vel aut dolorum.', 0, '1978-01-03 12:18:33', '2021-04-05 20:40:51');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('43', '79', '70', 'Laboriosam consequatur eligendi sit quod. Sed veritatis ipsam quaerat voluptatem ea. Quam totam minus iure et voluptatem. Laborum fugit exercitationem et et porro.', 1, '2017-10-17 01:17:39', '2020-11-21 11:55:02');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('44', '67', '36', 'Praesentium impedit eveniet natus aut. Dolor repellat quis dolor consequuntur a voluptas. Ut quisquam laudantium perferendis qui minus voluptatibus animi. Et ut at corrupti.', 1, '1985-04-30 10:18:43', '2020-08-19 22:44:20');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('45', '18', '87', 'Id voluptatem ea reiciendis tempore ab. Qui aut non assumenda ipsa. Dolorum explicabo qui ut atque enim.', 1, '2016-12-28 00:14:44', '2020-08-11 17:33:57');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('46', '34', '30', 'Maxime nesciunt dicta reiciendis perferendis. Non ex nulla rem aut minus. Optio nisi vitae dolorem quis nam ducimus. Autem voluptatum sequi illum consectetur consequuntur autem reprehenderit.', 1, '2004-05-03 03:58:53', '2020-07-16 16:05:11');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('47', '14', '83', 'Est aliquam est aut fugiat. Totam ratione et dolorem dicta odit praesentium. Et ut sit atque doloribus nam aspernatur quia.', 1, '1984-05-31 20:19:33', '2021-04-16 08:44:44');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('48', '44', '13', 'Vitae earum magni vero ipsum labore ab consequatur. Suscipit eaque atque est minus.', 1, '1985-01-12 10:41:26', '2020-08-19 17:52:56');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('49', '99', '23', 'Voluptas et dolor non quos. Cupiditate quia ab id. Animi nobis sint soluta optio soluta velit tempora. Maiores quibusdam est dignissimos possimus.', 1, '2014-02-12 20:46:35', '2021-02-09 16:30:18');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('50', '56', '20', 'Voluptate fugit ut id illo. Eveniet ex pariatur mollitia est assumenda. Placeat eaque in molestias amet laudantium non.', 0, '1981-03-02 06:47:44', '2021-04-21 16:28:16');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('51', '7', '47', 'Consequatur molestiae et nobis ipsa. Quas illo omnis quam aliquid voluptatem nostrum corrupti quia. Esse minus sit voluptate voluptates. Cupiditate veniam ducimus et facilis.', 1, '2018-08-06 14:48:59', '2021-04-05 18:55:43');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('52', '15', '63', 'Voluptatem odit dolores nihil ratione dolore sed. Minus pariatur amet harum repellendus provident. Ut corporis sint expedita fugit id sit.', 0, '1981-03-29 00:26:43', '2020-09-13 04:13:34');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('53', '64', '60', 'Nihil accusamus reiciendis ipsum nesciunt. Nam odio sapiente et vel. Voluptatibus explicabo consequuntur omnis explicabo. Autem id similique ut aperiam qui et est alias.', 1, '1985-03-03 17:27:34', '2021-02-17 12:26:07');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('54', '61', '55', 'Delectus quisquam quo asperiores ea cumque qui. Molestiae doloremque expedita ut eaque eos deleniti. Velit necessitatibus ad numquam officia enim omnis.', 0, '1972-01-25 11:35:20', '2021-03-22 02:27:41');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('55', '84', '94', 'Consequatur exercitationem vel atque et beatae non. Sed incidunt et sed praesentium ut. Eaque illo suscipit omnis tempora fugiat. Quis natus quo dicta quas cumque.', 0, '1984-03-26 00:19:47', '2021-03-10 01:59:53');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('56', '2', '83', 'Veritatis dolor laboriosam omnis et iure. Vel neque amet porro maxime. Aut commodi quia delectus. Modi fugit ipsam esse maiores.', 1, '1980-02-24 03:23:50', '2020-08-19 02:50:28');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('57', '54', '65', 'Eligendi dolorem incidunt autem labore qui. Voluptatem incidunt qui hic corrupti. Et alias facere qui magni molestias. Qui eos sed ab nobis consequuntur repudiandae deleniti qui.', 1, '1977-03-21 23:54:32', '2020-11-09 19:59:21');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('58', '96', '35', 'Qui eaque eum iure sunt quod ducimus. Dolorum temporibus ducimus et ut aspernatur dolor. Dolor eos nemo ut vel aperiam harum.', 1, '1978-12-21 12:08:33', '2021-06-19 18:49:41');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('59', '51', '45', 'Iure tenetur hic repellat. Architecto aut odio voluptatem facere aut modi et. Sed quisquam velit inventore quo.', 0, '2007-03-28 03:16:17', '2021-05-29 23:40:46');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('60', '29', '30', 'Minima est voluptatibus incidunt qui porro voluptatem. Non neque corrupti ex enim est deserunt.', 1, '2002-07-08 19:03:55', '2020-10-03 23:22:25');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('61', '52', '19', 'Ea nobis non deleniti et praesentium asperiores qui. Vel esse adipisci esse quod. Esse sunt voluptate optio molestiae quis aut.', 1, '1999-04-19 13:41:41', '2021-02-01 01:44:37');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('62', '56', '54', 'Aliquid molestias quidem dolor fugiat. Atque reprehenderit eos sunt minus quibusdam similique consequatur beatae. Maxime dolores nemo distinctio ex et magni nam.', 1, '1975-02-08 06:43:50', '2020-11-11 15:11:38');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('63', '50', '85', 'Doloribus aut quia quia velit. Necessitatibus earum natus et accusantium modi sunt dignissimos. Dolor necessitatibus quae consequuntur soluta odio sunt et. Fugiat sint beatae dolores omnis quia.', 1, '1983-10-30 16:40:16', '2020-10-02 23:52:39');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('64', '2', '59', 'Vero rerum vero pariatur doloribus enim accusamus perspiciatis. Doloribus sint praesentium dicta ab sapiente mollitia. Fugiat ipsum saepe repellendus non ut illo.', 1, '2011-07-19 13:32:38', '2020-11-04 09:17:50');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('65', '22', '57', 'Pariatur possimus quia non quia non voluptas odit voluptas. Est quia et incidunt iusto tempore. Aperiam quo delectus commodi sunt voluptatem ut minus reiciendis. Aut doloremque voluptas eos sint sed.', 0, '1975-03-01 21:11:46', '2021-04-01 20:01:01');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('66', '86', '93', 'Aut ullam repellat quod aspernatur assumenda quia exercitationem. Pariatur consequatur et mollitia explicabo. Ut id sit unde. Ducimus et sed temporibus consequatur quas.', 0, '1999-12-18 06:04:23', '2021-05-16 18:52:39');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('67', '100', '24', 'Sit assumenda officia iste placeat et provident non aut. Accusamus eaque perspiciatis id velit et. Voluptatibus nesciunt officia sed nobis quam placeat. Quo deserunt a quasi et omnis.', 0, '1975-11-11 20:23:46', '2020-11-08 07:27:32');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('68', '43', '100', 'Culpa voluptatibus odit voluptates facilis. Dolore repellat qui odit qui minus numquam. At sequi sunt non architecto. Consequuntur et aperiam et excepturi.', 1, '1975-12-09 18:07:51', '2020-09-05 15:07:30');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('69', '20', '100', 'Ut ducimus animi cum quae. Dolores consequatur consequatur eligendi. Eaque nihil suscipit nam nobis et. Quo rem commodi hic qui itaque.', 0, '2012-12-27 09:27:51', '2020-12-03 02:20:47');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('70', '34', '52', 'Aliquid vero accusantium et sunt. Nesciunt consectetur iusto et iste dolorem. Consequuntur officia expedita quod cupiditate deserunt.', 0, '1975-11-03 23:19:31', '2020-10-08 11:26:49');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('71', '9', '45', 'Itaque et culpa illum et fugiat. Molestiae quidem distinctio dolorum necessitatibus. Itaque officia dolorem expedita est. Tenetur enim pariatur rerum error voluptatum autem magnam.', 0, '2000-06-29 21:14:43', '2020-11-08 04:59:58');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('72', '54', '30', 'Sit dicta eius rem omnis dolor mollitia. Consequatur cumque ex dolorem aut eum voluptas ipsum. Quia quam ut culpa assumenda nam. Officiis temporibus facere omnis vitae nam autem eos.', 1, '2004-02-14 11:46:57', '2021-04-01 11:58:12');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('73', '82', '12', 'Illo odio possimus sequi dolor placeat eius. Voluptas et sunt molestiae et molestiae. Voluptas deserunt expedita laudantium dolorem voluptatem. Vel distinctio reiciendis est aut sint et expedita.', 1, '2014-09-30 08:21:08', '2021-02-05 16:41:23');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('74', '23', '79', 'Amet eius nihil sunt et hic sit molestiae harum. Exercitationem aut dolores cumque ab sequi earum.\nPraesentium ut est ipsa quos. Architecto nam ut enim quis voluptas. Fugit magni sunt non voluptatem.', 0, '1975-04-16 11:11:05', '2021-06-26 07:34:25');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('75', '18', '50', 'Ea vel in cupiditate harum voluptate hic iusto corporis. Ea maxime voluptate dolor molestias voluptatem et voluptatem.', 1, '1983-06-18 02:01:57', '2020-11-15 08:43:41');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('76', '86', '25', 'Deleniti quaerat et fugiat sed nemo non. Aut et libero qui sint est aut error. Quo beatae consequuntur unde excepturi iusto consequatur similique.', 1, '1996-06-18 13:25:45', '2020-10-31 02:05:23');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('77', '20', '18', 'Laboriosam delectus et est tenetur ad inventore modi ut. Aut quia aut libero facere vel blanditiis excepturi. Et soluta quo molestias vero voluptatem. Et consectetur quod quia consequuntur non.', 1, '1991-01-10 08:28:56', '2021-03-01 11:23:23');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('78', '26', '69', 'Ea ea alias dicta eaque. Voluptas nihil perferendis corporis laudantium sint voluptatibus. Et alias modi perferendis maxime cupiditate. Deserunt eligendi doloremque qui quo et amet.', 1, '2007-10-19 07:52:41', '2020-09-24 22:57:15');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('79', '65', '27', 'Consequuntur rem ut consectetur quo inventore. Earum repudiandae provident non molestiae. Reiciendis omnis asperiores est distinctio optio odit. Est reiciendis laboriosam velit soluta cumque.', 1, '2016-09-14 09:20:11', '2021-04-28 07:57:22');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('80', '44', '35', 'Voluptas alias est assumenda et at modi eveniet. Qui assumenda repellendus pariatur sed fuga hic quas.', 1, '1985-01-04 13:59:10', '2021-03-21 14:43:47');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('81', '36', '97', 'Ut nostrum quis aut iure. Aut aut tenetur pariatur ut tempore velit. At consequatur tempora occaecati sed earum est.', 0, '1987-01-23 11:44:13', '2021-06-12 20:41:26');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('82', '53', '4', 'Et occaecati suscipit ducimus quidem magnam soluta optio. Corrupti quod sequi aut quasi. Illo tempora non necessitatibus officia rerum sint distinctio. Nulla asperiores sunt a debitis officia.', 1, '1982-03-21 00:37:29', '2020-09-27 21:51:16');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('83', '29', '95', 'Ex ducimus necessitatibus sequi quibusdam deleniti placeat optio. Voluptatem delectus sunt sed ut iure officiis est. In quaerat ipsam et ut nihil delectus.', 1, '2013-01-24 16:09:35', '2020-07-17 04:25:08');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('84', '40', '10', 'Accusamus dolore sed iure. Recusandae provident vel quo vel commodi. Odio deserunt non ea qui molestiae. Ut id saepe dolore.', 1, '1987-11-13 05:02:16', '2020-10-01 19:47:00');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('85', '98', '96', 'Modi tempore laboriosam qui aut sint. Occaecati voluptatem et recusandae. Neque dolor assumenda adipisci sunt possimus nam. Dicta eligendi molestiae fugit accusantium corrupti est.', 0, '1995-08-27 05:49:08', '2020-07-19 05:16:20');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('86', '42', '13', 'Et ex autem ad voluptatum architecto ut quis. Et eveniet beatae id occaecati.\nInventore eos autem voluptas in. Maiores quibusdam voluptas rem. Et dicta ab sequi eaque.', 1, '1986-05-03 11:52:47', '2020-07-29 02:02:03');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('87', '89', '49', 'Et voluptatum et est incidunt aut dignissimos. Corporis nisi illum corrupti sit et consequatur. Quaerat quaerat quaerat modi unde illum sit.', 1, '2020-08-07 20:41:04', '2021-04-01 17:19:50');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('88', '68', '9', 'Delectus velit rem et veniam error quis a atque. Sed commodi aut placeat sit et. Modi eum repellendus incidunt nam architecto minus velit.', 0, '2014-12-29 21:10:03', '2021-07-02 16:29:02');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('89', '44', '32', 'Vel occaecati eveniet laudantium nisi magni optio. Soluta libero mollitia sint sint. Ipsum blanditiis non odio. Repellendus ipsum enim facere provident nisi est est.', 1, '2012-11-16 05:26:00', '2020-12-19 09:21:06');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('90', '43', '42', 'Corrupti est possimus tenetur nesciunt rerum consequuntur. Nobis earum vel officia accusamus facere error. Voluptas eius ipsam nobis porro est.', 0, '1996-05-01 01:02:55', '2021-06-10 13:32:15');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('91', '96', '8', 'Et magni qui animi quibusdam adipisci saepe ratione. Voluptate cumque itaque aut numquam. In nisi aut perferendis aut. Ab occaecati accusamus quisquam dolorem repellat nemo.', 1, '1976-09-05 06:10:58', '2021-05-16 04:40:22');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('92', '63', '62', 'Est cum id maxime. Non ratione quis qui et alias. Fugit dolores sapiente repellat voluptatem. Veritatis praesentium enim voluptate expedita omnis.', 1, '1975-08-10 23:44:08', '2020-10-08 00:07:20');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('93', '54', '100', 'Quaerat dolorem ducimus voluptatem voluptatum quisquam maxime deserunt. Debitis quas magni natus tempore dolorum.', 0, '2012-01-02 20:39:03', '2021-04-27 14:24:19');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('94', '79', '99', 'Itaque commodi non qui facilis sit et id in. Ut labore tempore adipisci exercitationem. Aut corrupti non cum nulla tempore voluptatibus.', 0, '1978-06-24 22:22:05', '2021-04-18 20:11:13');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('95', '72', '5', 'Rerum quasi temporibus quia impedit architecto inventore. Voluptatibus at est autem fugiat et dignissimos. Quis fugit excepturi voluptatibus voluptatum.', 1, '1995-01-09 22:59:24', '2020-11-03 04:56:59');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('96', '56', '30', 'Perspiciatis qui et facere est in facilis. Praesentium cum et natus ut quisquam earum cupiditate nostrum. Vel aut sunt in et nesciunt est. Consequatur tempora voluptatem molestiae eum error qui.', 1, '1980-12-30 02:58:23', '2021-06-23 22:52:15');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('97', '52', '89', 'Suscipit voluptatibus harum dolorum dolore non eveniet ut. Accusamus qui similique et. Libero voluptas iure corrupti quia. Labore eius odio cum et ut molestias odit.', 0, '1995-03-07 08:27:27', '2020-12-03 18:59:21');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('98', '88', '100', 'Dolor sit magnam cupiditate et cupiditate. Autem doloribus amet neque quas nobis qui. Iste laboriosam consequatur et corporis.', 1, '1993-11-24 09:19:50', '2021-02-19 06:55:51');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('99', '52', '48', 'Ipsam aliquid et id necessitatibus quam vel est. Id perferendis in non soluta excepturi consectetur nihil laborum.', 0, '2001-05-31 06:23:45', '2020-09-09 07:34:37');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `txt`, `is_delivered`, `created_at`, `update_at`) VALUES ('100', '89', '7', 'Iure autem beatae quos sed. Est dignissimos maiores ut exercitationem sunt aut consequatur.', 0, '1991-02-09 05:58:11', '2021-01-20 03:33:00');

INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('1', '30', 'Unde laudantium temporibus cum corporis eaque voluptates.', '2020-08-03 02:00:01', '2020-12-05 12:47:27');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('2', '34', 'At sit sunt recusandae voluptatem numquam aliquid sit ea.', '2021-01-29 21:10:27', '2020-10-14 08:40:37');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('3', '30', 'Adipisci illo qui eum quos voluptas ut.', '2020-10-14 04:27:05', '2020-09-05 21:08:42');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('4', '38', 'Porro et excepturi blanditiis eligendi aut libero.', '2020-11-22 03:12:18', '2021-01-26 02:37:09');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('5', '82', 'Eum soluta molestiae recusandae modi eaque sapiente voluptates beatae.', '2021-07-02 17:41:50', '2020-09-13 14:52:01');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('6', '35', 'Omnis vel tenetur nulla quo.', '2020-07-18 12:56:58', '2021-04-03 16:46:19');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('7', '91', 'Quis aliquid et rerum enim modi.', '2021-03-19 17:11:29', '2020-12-03 17:35:05');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('8', '97', 'Minus voluptatem ut cum amet.', '2021-01-08 16:46:10', '2020-07-30 18:25:35');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('9', '78', 'Cumque minima sequi qui cum fugit repellendus ea sit.', '2020-10-03 11:57:17', '2020-11-04 11:58:25');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('10', '18', 'Aut qui praesentium aut.', '2020-09-18 01:51:04', '2021-05-20 04:27:10');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('11', '34', 'Ut sed quia quod et odio.', '2021-05-27 02:19:55', '2021-04-08 07:13:00');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('12', '66', 'Alias omnis cumque veniam ea aut ea ipsam aut.', '2021-01-28 06:55:28', '2020-07-27 14:56:51');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('13', '93', 'Recusandae odio explicabo aliquam.', '2021-02-12 14:51:06', '2021-07-08 12:01:30');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('14', '25', 'Suscipit quis et recusandae excepturi mollitia ut id.', '2021-01-21 13:16:25', '2021-02-26 13:45:55');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('15', '67', 'Rerum voluptatibus est rerum libero ut quaerat.', '2021-02-14 10:39:45', '2021-01-09 12:41:12');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('16', '38', 'Quibusdam beatae qui aliquam consequatur quis sed.', '2021-06-27 21:41:56', '2020-12-23 16:57:00');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('17', '55', 'In rem provident adipisci eaque beatae facilis.', '2020-09-22 18:01:27', '2020-08-14 03:52:35');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('18', '94', 'Possimus architecto voluptas dolore corporis.', '2020-09-11 12:52:09', '2021-06-29 19:38:19');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('19', '14', 'Officia laudantium sapiente atque placeat unde quaerat impedit.', '2020-10-31 21:50:12', '2021-04-25 23:35:48');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('20', '96', 'Dolore impedit dicta blanditiis quo ut id minus.', '2021-06-12 08:57:09', '2020-07-27 17:26:15');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('21', '1', 'Non rerum atque tenetur voluptatem in voluptas magni.', '2021-03-15 17:31:48', '2020-08-05 14:15:59');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('22', '1', 'Natus aut labore libero et possimus.', '2021-06-21 10:26:46', '2021-04-15 20:40:18');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('23', '1', 'Eveniet qui nihil est natus sed id.', '2021-05-02 22:48:02', '2020-08-31 00:48:10');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('24', '90', 'Eum ipsum explicabo dolorum aut distinctio.', '2021-04-17 21:06:47', '2021-03-28 11:45:26');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('25', '70', 'Impedit sint et fugiat sint.', '2021-07-05 20:40:09', '2020-12-18 09:54:53');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('26', '41', 'Corporis rem voluptatibus similique cumque.', '2021-04-02 14:31:34', '2020-11-29 15:34:46');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('27', '37', 'Reiciendis tempore aut eveniet explicabo qui fuga et dignissimos.', '2021-02-25 16:11:11', '2020-10-26 00:32:28');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('28', '49', 'Accusamus qui amet sit commodi.', '2021-07-03 15:07:19', '2021-01-06 17:56:27');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('29', '93', 'Voluptas qui soluta quos expedita.', '2021-01-07 09:01:37', '2021-02-28 14:37:23');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('30', '35', 'Doloribus consequatur laboriosam rerum maxime vitae.', '2020-11-07 05:55:43', '2021-06-26 13:12:25');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('31', '70', 'Aut consequatur aspernatur eos quia a at voluptas.', '2021-01-06 16:51:46', '2020-10-22 05:44:31');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('32', '96', 'Voluptatum autem id sed.', '2021-05-03 04:03:03', '2021-03-02 16:54:57');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('33', '64', 'Voluptas sed voluptatem est quis et.', '2021-05-20 07:35:59', '2021-05-05 12:41:29');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('34', '14', 'Tempore eos culpa est nam accusantium aliquam.', '2021-02-23 17:24:05', '2020-09-12 11:41:09');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('35', '53', 'Quam est qui et et natus harum.', '2020-11-25 05:51:21', '2020-08-02 09:04:34');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('36', '81', 'Qui necessitatibus aut exercitationem.', '2021-03-20 03:11:40', '2021-05-26 15:39:54');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('37', '40', 'Placeat omnis eaque minima inventore quas voluptate.', '2021-05-28 06:05:53', '2021-03-31 12:11:30');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('38', '61', 'Non eius eius sint accusantium dolores.', '2021-01-22 16:22:02', '2021-01-04 16:40:33');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('39', '70', 'Neque accusamus optio enim iste aut atque ipsam.', '2021-06-27 10:23:00', '2020-07-21 03:40:15');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('40', '61', 'Rem exercitationem nihil dolore ut repudiandae quia sint.', '2020-08-03 12:31:41', '2020-09-25 12:18:57');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('41', '26', 'Dolorem ad blanditiis quae qui doloribus reiciendis.', '2021-02-12 15:25:41', '2021-01-13 15:41:35');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('42', '76', 'Aliquam sint non cumque ipsam quo eum expedita consequuntur.', '2021-01-04 11:30:04', '2021-04-28 18:36:03');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('43', '98', 'Tempora perferendis optio eius perferendis.', '2020-12-23 13:24:42', '2021-03-11 13:09:50');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('44', '22', 'Sequi aut sed quisquam temporibus pariatur voluptas.', '2020-12-16 09:00:44', '2021-04-14 04:15:01');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('45', '57', 'Culpa consequatur iure ipsa ducimus possimus rerum quis iusto.', '2021-01-11 17:05:52', '2021-04-29 08:22:22');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('46', '19', 'Dolores illum ad voluptates sequi aut.', '2020-12-04 06:22:46', '2021-03-27 09:26:21');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('47', '27', 'Magni eligendi minima aut vel iste.', '2020-10-17 09:26:10', '2020-10-28 23:54:55');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('48', '39', 'Dolore eius rem sint in.', '2020-11-14 02:21:15', '2020-10-04 07:45:36');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('49', '88', 'Ut consequatur et recusandae.', '2020-12-30 22:07:28', '2021-03-01 12:18:20');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('50', '53', 'Quia tenetur asperiores cumque.', '2020-11-05 14:32:29', '2020-08-11 19:15:25');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('51', '16', 'Neque praesentium ipsam et mollitia ad.', '2020-08-24 09:27:40', '2020-08-08 20:22:19');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('52', '82', 'Illo laboriosam accusantium dolore ad nobis ut.', '2021-02-22 12:47:57', '2021-05-13 22:26:21');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('53', '42', 'Qui et tempora tenetur odit officia corrupti nam.', '2020-11-23 07:14:09', '2021-03-07 22:58:24');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('54', '99', 'Voluptas dolor id magni.', '2020-09-13 15:04:37', '2021-01-26 19:31:04');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('55', '11', 'Aut quasi magni dolor repellendus voluptas occaecati dolores in.', '2020-10-23 16:46:55', '2021-06-23 09:31:06');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('56', '53', 'Numquam alias rerum in error.', '2020-09-15 10:54:00', '2021-06-21 12:53:45');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('57', '66', 'Enim voluptatem labore voluptatem eveniet velit aliquam commodi.', '2021-04-28 11:05:28', '2020-12-07 05:57:31');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('58', '29', 'Provident qui ut ducimus vel voluptas quod distinctio eveniet.', '2020-11-23 12:25:11', '2020-10-19 09:40:25');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('59', '82', 'Ipsam voluptates ullam minus ea.', '2020-08-31 23:42:22', '2020-08-15 14:19:01');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('60', '58', 'Consequatur nihil impedit consequatur blanditiis.', '2020-10-06 12:35:19', '2020-12-19 12:37:20');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('61', '40', 'Quo autem voluptas velit minima quis.', '2021-07-08 17:20:25', '2020-12-20 00:43:43');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('62', '50', 'Consectetur quia odio veritatis ex quidem.', '2021-04-14 03:56:09', '2021-05-10 08:28:09');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('63', '78', 'Laboriosam voluptas nam dolorem quia placeat velit.', '2021-04-24 21:18:27', '2021-07-07 07:31:51');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('64', '17', 'Quos excepturi quo molestiae ipsum est corrupti.', '2021-04-05 22:07:29', '2020-07-17 01:29:59');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('65', '40', 'Fuga asperiores quas assumenda non cumque sunt dolore.', '2021-06-08 00:03:42', '2020-12-06 14:20:36');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('66', '63', 'Et sapiente in natus reprehenderit omnis quia.', '2021-02-25 15:38:44', '2021-01-24 16:18:48');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('67', '15', 'Magnam sed facere quasi voluptatem sunt praesentium voluptatem numquam.', '2021-03-08 05:04:33', '2021-06-30 12:05:27');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('68', '66', 'Nemo tempora et consequuntur magnam quibusdam deserunt.', '2020-12-07 20:52:18', '2021-07-08 14:49:06');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('69', '70', 'Ad minima qui repudiandae modi.', '2021-05-31 23:17:30', '2020-09-06 03:10:22');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('70', '31', 'Eos quia ut quos est sequi animi.', '2021-02-03 18:41:00', '2021-02-22 15:26:12');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('71', '100', 'Distinctio sit voluptates illo.', '2020-11-29 14:52:58', '2020-08-19 09:57:24');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('72', '52', 'Quibusdam itaque necessitatibus ex molestias.', '2020-10-28 20:57:52', '2020-09-01 14:24:01');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('73', '51', 'Nulla omnis doloremque sit dolor.', '2020-11-22 07:14:31', '2021-05-30 14:40:25');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('74', '77', 'Temporibus aliquam quo sed occaecati et.', '2020-09-20 16:37:22', '2021-04-16 02:28:11');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('75', '57', 'Non beatae inventore incidunt nihil exercitationem animi facilis eius.', '2020-08-18 16:31:43', '2020-09-15 23:57:05');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('76', '89', 'Aut sit praesentium omnis temporibus.', '2020-09-28 12:18:43', '2020-08-13 11:19:40');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('77', '6', 'Ducimus rerum autem reprehenderit nobis ut quo eum.', '2021-04-17 18:33:37', '2020-11-23 10:11:24');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('78', '59', 'Modi ut illo dignissimos dolor provident voluptatibus unde officiis.', '2021-01-07 02:56:16', '2021-06-21 20:25:45');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('79', '77', 'Sapiente assumenda tempora sunt excepturi atque atque.', '2021-01-14 16:29:48', '2021-03-07 17:33:56');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('80', '18', 'Perferendis itaque sunt commodi sit aut ea est.', '2021-06-18 09:51:41', '2021-06-24 22:47:09');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('81', '20', 'Quidem aut quia doloribus ipsam alias vel ipsam nihil.', '2020-12-01 15:50:44', '2021-01-01 12:50:36');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('82', '43', 'Sunt voluptas architecto sint minima dolore amet molestiae et.', '2020-08-22 02:31:14', '2021-06-20 01:28:01');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('83', '37', 'Deserunt velit non aut voluptas quia voluptatem.', '2021-06-20 05:12:57', '2021-06-11 08:17:52');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('84', '96', 'Velit cum est voluptate maxime illum.', '2021-05-31 14:52:56', '2020-07-15 09:17:05');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('85', '4', 'Omnis deserunt ducimus inventore modi excepturi ut sint.', '2021-03-16 23:27:18', '2021-06-27 14:14:45');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('86', '35', 'Placeat suscipit placeat numquam sit possimus.', '2020-12-21 05:00:47', '2020-10-03 01:24:33');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('87', '89', 'Aut autem voluptatum dicta similique sit neque.', '2020-07-16 13:20:28', '2021-03-06 15:08:23');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('88', '44', 'Porro sapiente voluptas inventore est repellat repellendus.', '2020-12-31 13:01:32', '2021-04-07 01:53:56');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('89', '52', 'A est vel cum adipisci voluptatibus.', '2020-08-14 13:59:05', '2020-10-03 23:56:44');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('90', '86', 'Perferendis nihil ducimus aperiam debitis aut nihil.', '2021-03-05 16:55:25', '2021-02-04 07:15:05');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('91', '76', 'Blanditiis voluptas autem eos placeat.', '2021-02-15 22:08:44', '2021-02-12 08:25:51');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('92', '92', 'Fugiat sunt velit aut eos qui odio maiores.', '2020-12-17 14:49:00', '2020-10-06 12:17:11');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('93', '7', 'Non voluptates necessitatibus sint corporis eligendi quia.', '2021-01-23 06:49:30', '2021-01-29 14:24:18');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('94', '60', 'Laborum consectetur sunt debitis pariatur inventore.', '2021-01-16 03:07:57', '2020-12-08 14:53:18');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('95', '76', 'Similique ipsum eos a quasi voluptas.', '2020-08-02 09:39:13', '2020-10-24 05:21:36');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('96', '80', 'Odit eveniet velit assumenda.', '2020-10-01 10:13:34', '2021-03-17 09:46:01');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('97', '22', 'Et voluptatem quos qui reiciendis.', '2020-12-19 17:50:57', '2020-09-03 06:20:57');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('98', '25', 'Vel animi voluptas et nulla.', '2020-11-01 02:02:44', '2021-03-04 08:48:27');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('99', '2', 'Cum dignissimos blanditiis quo nulla tempore sapiente ut.', '2021-04-23 03:31:37', '2020-07-17 12:04:31');
INSERT INTO `posts` (`id`, `user_id`, `txt`, `created_at`, `updated_at`) VALUES ('100', '90', 'Natus consequatur quidem consequatur temporibus accusamus natus accusantium.', '2021-07-01 18:40:13', '2021-03-09 22:59:38');


INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('21', '16', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('21', '48', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('23', '51', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('22', '12', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('22', '79', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('21', '13', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('21', '39', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('15', '83', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('16', '40', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('16', '86', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('17', '48', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('17', '72', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('18', '55', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('19', '44', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('19', '57', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('20', '69', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('22', '80', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('25', '92', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('26', '28', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('27', '21', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('28', '92', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('29', '1', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('32', '71', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('32', '89', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('33', '36', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('34', '61', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('34', '93', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('35', '68', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('35', '88', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('38', '39', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('38', '82', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('42', '63', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('42', '71', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('44', '65', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('45', '34', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('45', '96', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('46', '30', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('46', '74', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('47', '9', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('47', '50', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('48', '99', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('53', '55', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('54', '71', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('55', '82', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('55', '99', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('57', '33', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('57', '46', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('58', '28', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('60', '14', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('60', '99', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('61', '89', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('61', '90', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('62', '14', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('63', '84', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('64', '40', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('64', '76', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('65', '37', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('66', '8', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('66', '59', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('67', '12', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('67', '60', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('68', '48', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('68', '63', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('69', '78', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('70', '64', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('73', '24', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('74', '88', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('75', '84', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('75', '95', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('76', '62', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('76', '78', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('79', '20', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('79', '53', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('80', '15', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('80', '77', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('81', '40', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('81', '72', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('82', '18', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('83', '21', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('83', '80', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('84', '63', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('84', '72', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('85', '52', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('85', '76', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('86', '75', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('87', '29', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('87', '62', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('88', '29', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('88', '95', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('89', '41', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('90', '36', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('90', '43', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('92', '21', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('94', '73', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('94', '84', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('95', '99', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('97', '23', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('97', '84', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('99', '31', 1);
INSERT INTO `posts_likes` (`post_id`, `user_id`, `like_type`) VALUES ('99', '41', 1);

INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('1', 'f', '2000-08-12', '1', 'Accusantium sed voluptas ut la', 'Willbury', 'Norfolk Island');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('2', 'x', '1984-04-25', '2', 'Ad magnam ipsum suscipit volup', 'South Yoshikohaven', 'Luxembourg');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('3', 'x', '2001-08-23', '3', 'Eum rerum officiis autem conse', 'New Monica', 'Swaziland');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('4', 'f', '1983-06-08', '4', 'Nihil iusto a exercitationem. ', 'Lake Josefinaview', 'Greenland');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('5', 'x', '2014-08-06', '5', 'Animi quis qui libero quia. Au', 'North Martaside', 'French Guiana');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('6', 'm', '1980-11-27', '6', 'Neque nam corrupti qui volupta', 'Lake Elvis', 'Dominica');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('7', 'x', '1978-07-28', '7', 'Ab tenetur aliquam quam natus ', 'Lake Ruthemouth', 'Christmas Island');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('8', 'm', '1973-10-09', '8', 'Animi in odit architecto id od', 'Leannonport', 'Sudan');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('9', 'm', '1990-02-20', '9', 'Autem ut est ut cum. Tempore d', 'South Roderick', 'Luxembourg');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('10', 'm', '1992-06-12', '10', 'Velit consequatur non aut pers', 'Port Dudleyfort', 'Ghana');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('11', 'm', '1977-05-04', '11', 'Et omnis eum voluptatem quasi ', 'Brownberg', 'Saint Martin');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('12', 'm', '1985-06-12', '12', 'Dolorum minus tenetur autem ne', 'Grantshire', 'Croatia');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('13', 'f', '1971-01-03', '13', 'Ut id ut expedita qui assumend', 'Predovicmouth', 'Grenada');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('14', 'x', '1994-10-14', '14', 'Hic eos quod consequatur adipi', 'East Marlee', 'Cape Verde');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('15', 'x', '1990-09-30', '15', 'Placeat et quos ut saepe beata', 'Colleenfort', 'Philippines');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('16', 'f', '1981-12-19', '16', 'Quam est et sapiente vel venia', 'Barrowshaven', 'Moldova');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('17', 'm', '1977-02-20', '17', 'Alias corrupti totam cupiditat', 'South Mattiemouth', 'Western Sahara');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('18', 'm', '1972-03-01', '18', 'Nulla illo vero rerum doloribu', 'Aufderharland', 'Senegal');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('19', 'x', '1986-03-30', '19', 'Perferendis at voluptatibus in', 'Valentinehaven', 'Ireland');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('20', 'm', '2014-12-06', '20', 'Nam nam numquam cum illo. Laud', 'Alexysview', 'Timor-Leste');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('21', 'f', '1975-08-25', '21', 'A quas cupiditate quaerat. Eve', 'New Mckennaport', 'Bhutan');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('22', 'f', '2010-01-11', '22', 'Architecto recusandae et nam e', 'Breanahaven', 'Bosnia and Herzegovina');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('23', 'f', '2020-12-24', '23', 'Id voluptas accusamus molestia', 'Lake Nathaniel', 'Mauritania');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('24', 'm', '1971-12-29', '24', 'Ex eum magnam quam culpa non. ', 'Port Joshuahberg', 'Belarus');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('25', 'm', '1981-03-12', '25', 'Quis natus aspernatur dolorum ', 'Torpland', 'Falkland Islands (Malvinas)');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('26', 'x', '1976-05-04', '26', 'Ratione est corporis aut et ma', 'Auermouth', 'Libyan Arab Jamahiriya');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('27', 'f', '1995-12-14', '27', 'Voluptatem et non deserunt in ', 'Lake Elyse', 'Guernsey');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('28', 'm', '1970-05-16', '28', 'Eos accusantium quo fugiat sed', 'Port Magnolialand', 'Jordan');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('29', 'x', '1972-01-03', '29', 'Nisi accusantium corrupti repr', 'Margiechester', 'Oman');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('30', 'f', '1998-07-12', '30', 'Soluta ea culpa quibusdam aut ', 'South Clint', 'French Guiana');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('31', 'm', '2014-07-26', '31', 'Quia possimus deserunt volupta', 'Colefurt', 'Cameroon');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('32', 'f', '2000-07-02', '32', 'Tenetur sed optio impedit dolo', 'South Corrine', 'Cook Islands');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('33', 'x', '1978-10-21', '33', 'Quo ad sit vel in. Minima iure', 'South Carleetown', 'New Zealand');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('34', 'x', '1996-04-07', '34', 'Aut ipsa fugit ea cupiditate s', 'West Nathenmouth', 'Martinique');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('35', 'x', '2009-03-01', '35', 'Minus et et voluptate vero. Pe', 'Mullerville', 'Cameroon');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('36', 'x', '2007-10-14', '36', 'Placeat maxime quidem quis est', 'Nolanshire', 'Christmas Island');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('37', 'f', '1996-05-21', '37', 'Hic voluptas harum non repella', 'Carterborough', 'Dominica');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('38', 'm', '1972-09-18', '38', 'Omnis corrupti harum similique', 'Giovannytown', 'Egypt');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('39', 'f', '1979-10-16', '39', 'Aut odio sunt at. Dolorem non ', 'Kundeberg', 'Burundi');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('40', 'x', '2013-11-03', '40', 'Nemo enim magnam voluptatem au', 'Friesenton', 'Sudan');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('41', 'f', '1986-07-25', '41', 'Occaecati perspiciatis beatae ', 'East Anastaciomouth', 'Nauru');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('42', 'm', '1973-01-11', '42', 'Sed voluptatem consequuntur si', 'West Kamrenton', 'Kazakhstan');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('43', 'm', '1971-07-17', '43', 'Qui et quis officia ipsum ex m', 'West Avaville', 'Mayotte');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('44', 'x', '2018-08-25', '44', 'Vero et omnis et tempora qui r', 'Schmelermouth', 'Andorra');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('45', 'f', '2014-06-26', '45', 'Quo ut optio esse consequatur ', 'Lake Ozellaside', 'Isle of Man');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('46', 'x', '2007-12-26', '46', 'Debitis nobis aut id vel quibu', 'McClureside', 'Argentina');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('47', 'f', '2015-07-21', '47', 'Labore et architecto dicta rep', 'Lake Amiya', 'Bahamas');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('48', 'f', '1970-02-02', '48', 'Est repellendus accusantium oc', 'North Rylan', 'Guyana');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('49', 'm', '1999-06-04', '49', 'Magnam expedita commodi minus ', 'Georgianafurt', 'Liberia');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('50', 'm', '1998-05-25', '50', 'Et similique sunt accusantium ', 'South Amparo', 'Cocos (Keeling) Islands');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('51', 'm', '2007-02-14', '51', 'Qui voluptatibus iure ad qui. ', 'Clareland', 'Jersey');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('52', 'x', '1983-06-27', '52', 'Voluptas et quidem cupiditate ', 'North Penelope', 'Tunisia');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('53', 'f', '1972-03-22', '53', 'Laboriosam optio tenetur et ex', 'South Keely', 'Christmas Island');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('54', 'm', '1997-11-16', '54', 'Rerum amet dolorum est nihil e', 'Cristburgh', 'Andorra');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('55', 'x', '2002-12-08', '55', 'Qui id libero veniam minima il', 'Lake Zettachester', 'Cape Verde');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('56', 'x', '2015-11-20', '56', 'Veritatis magnam rerum sequi q', 'North Reva', 'Mauritania');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('57', 'x', '1992-08-04', '57', 'Ipsum optio voluptas perspicia', 'New Denaside', 'Georgia');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('58', 'm', '1998-03-16', '58', 'Eligendi illum autem veritatis', 'Bergnaumport', 'Myanmar');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('59', 'f', '1999-04-07', '59', 'Eaque et optio maiores ratione', 'Port Annalise', 'Zimbabwe');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('60', 'f', '2000-05-18', '60', 'Quia nesciunt rerum excepturi ', 'West Catherine', 'Ukraine');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('61', 'm', '1994-07-02', '61', 'Aut provident molestiae laboru', 'Predovicmouth', 'Wallis and Futuna');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('62', 'x', '1995-08-03', '62', 'Ducimus a assumenda molestiae ', 'Feestville', 'Turkmenistan');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('63', 'm', '1971-10-02', '63', 'Nesciunt est vitae ea quia. Ma', 'Parkerstad', 'Egypt');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('64', 'x', '2014-04-10', '64', 'Quod quasi velit nemo non ad s', 'Otiliaville', 'Cambodia');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('65', 'f', '2017-09-25', '65', 'Aperiam unde eligendi hic sit ', 'Port Eduardo', 'Honduras');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('66', 'f', '1994-03-09', '66', 'Laboriosam nulla mollitia sunt', 'Rosendoland', 'Turkey');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('67', 'f', '1978-04-15', '67', 'Qui est qui maiores sapiente. ', 'Shanelville', 'British Virgin Islands');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('68', 'f', '2004-12-25', '68', 'Quis ut soluta libero. Aut fug', 'Grantmouth', 'Switzerland');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('69', 'm', '2012-11-29', '69', 'Ad voluptatem explicabo volupt', 'North Henderson', 'Slovakia (Slovak Republic)');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('70', 'x', '1971-08-12', '70', 'Et officia ut sed cupiditate s', 'South Vivienchester', 'Kyrgyz Republic');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('71', 'f', '2011-02-09', '71', 'Soluta ea fugiat inventore rep', 'Macifurt', 'Netherlands Antilles');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('72', 'f', '1985-09-24', '72', 'Tempore ut magnam eum nemo qui', 'New Dario', 'Paraguay');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('73', 'm', '1985-01-12', '73', 'Est amet tempore eveniet. Dolo', 'East Amari', 'Saint Martin');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('74', 'm', '1972-04-18', '74', 'Qui reprehenderit a numquam du', 'Wizaside', 'Saint Kitts and Nevis');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('75', 'm', '1973-10-16', '75', 'Porro commodi error dolore max', 'Jackchester', 'Mexico');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('76', 'x', '2008-11-14', '76', 'Aut quisquam optio a incidunt ', 'Billieburgh', 'Ghana');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('77', 'f', '1974-12-14', '77', 'Id iusto officia consequuntur ', 'West Aaliyah', 'Saint Lucia');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('78', 'f', '2020-09-19', '78', 'Adipisci consectetur voluptate', 'Port Donavonborough', 'Malawi');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('79', 'f', '2010-10-10', '79', 'Quia nulla quo qui rerum et do', 'Keeblerstad', 'Venezuela');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('80', 'f', '1983-08-14', '80', 'Aut et ipsa cupiditate. Animi ', 'West Neldaport', 'Falkland Islands (Malvinas)');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('81', 'f', '1976-04-01', '81', 'Saepe et pariatur veniam eaque', 'Wilbertbury', 'Vietnam');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('82', 'f', '1992-03-02', '82', 'Quam et dolor et aliquid. Laud', 'New Joshuahfort', 'Kuwait');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('83', 'm', '2001-06-01', '83', 'Maiores quae ut iure. Hic quia', 'Erickfort', 'Holy See (Vatican City State)');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('84', 'f', '2002-06-26', '84', 'Rerum quo suscipit quo. Nostru', 'Hillsmouth', 'Venezuela');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('85', 'm', '1984-05-12', '85', 'Error laborum impedit asperior', 'East Dock', 'Moldova');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('86', 'f', '1974-11-20', '86', 'Et autem quidem molestias moll', 'Schmelerhaven', 'Gambia');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('87', 'm', '2012-11-22', '87', 'Est hic ipsa architecto eaque ', 'New Daisy', 'Tajikistan');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('88', 'f', '2006-08-26', '88', 'Neque repudiandae nam repellen', 'North Dorishaven', 'Argentina');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('89', 'x', '1995-03-03', '89', 'Animi quas aspernatur aut est.', 'Mauriceview', 'Tunisia');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('90', 'f', '2010-02-20', '90', 'Rerum autem est neque sed et r', 'Port Jordynfort', 'Anguilla');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('91', 'f', '2009-04-05', '91', 'Voluptatem fugit adipisci volu', 'Kiehnfurt', 'Egypt');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('92', 'f', '1988-12-18', '92', 'Omnis rerum officiis fugiat mo', 'Welchmouth', 'Finland');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('93', 'f', '2002-04-22', '93', 'Est nam nisi quia aut repellat', 'Eileenton', 'Morocco');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('94', 'x', '1978-02-22', '94', 'Alias qui dolorum rem magni id', 'Braunton', 'Chile');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('95', 'f', '2010-04-24', '95', 'Aspernatur nulla saepe vel eni', 'Stiedemannborough', 'Macao');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('96', 'x', '1999-03-30', '96', 'Possimus a quibusdam rerum err', 'Port Evalynland', 'United States of America');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('97', 'm', '1988-07-03', '97', 'Enim sed qui ut pariatur quia ', 'Cormierton', 'Wallis and Futuna');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('98', 'm', '1979-04-15', '98', 'Saepe praesentium sapiente exp', 'New Thalia', 'Macedonia');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('99', 'x', '1974-03-14', '99', 'Laboriosam occaecati earum qui', 'Jordihaven', 'Tunisia');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `user_status`, `city`, `country`) VALUES ('100', 'f', '2018-12-18', '100', 'In alias aliquid et aut distin', 'Port Medatown', 'Tuvalu');

-- Вносим несколько изменений в таблицы
update media_types set name='image' where id=1;
update media_types set name='audio' where id=2;
update media_types set name='video' where id=3;
update media_types set name='document' where id=4;

delete from friend_requests where from_user_id = to_user_id;

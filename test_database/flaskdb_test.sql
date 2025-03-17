-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: flaskdb_test
-- ------------------------------------------------------
-- Server version	8.0.41

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `alembic_version`
--

DROP TABLE IF EXISTS `alembic_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alembic_version` (
  `version_num` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alembic_version`
--

LOCK TABLES `alembic_version` WRITE;
/*!40000 ALTER TABLE `alembic_version` DISABLE KEYS */;
INSERT INTO `alembic_version` VALUES ('179f8a81fb54'),('179f8a81fb54'),('179f8a81fb54'),('179f8a81fb54');
/*!40000 ALTER TABLE `alembic_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `belgium_registrations`
--

DROP TABLE IF EXISTS `belgium_registrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `belgium_registrations` (
  `exception_country` varchar(50) DEFAULT NULL,
  `id` int NOT NULL AUTO_INCREMENT,
  `country` varchar(50) DEFAULT NULL,
  `registration_type` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `minimum_diesel` varchar(50) DEFAULT NULL,
  `minimum_petrol` varchar(50) DEFAULT NULL,
  `result` text,
  `description` text,
  `image_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `belgium_registrations`
--

LOCK TABLES `belgium_registrations` WRITE;
/*!40000 ALTER TABLE `belgium_registrations` DISABLE KEYS */;
INSERT INTO `belgium_registrations` VALUES ('Belgium, Nertherlands',1,'Belgium','Digital','Antwerp/Ghent + Brussels','5','2','The chosen vehicle qualifies for both existing registration options available in Belgium.','&emsp;As of 2024, Belgium has three active Low Emission Zones: Antwerp, Ghent, and Brussels. Access to these zones is restricted for vehicles that do not meet the minimum standards of Diesel Euro 5 and Petrol Euro 2. <br>\r\n&emsp;Antwerp and Ghent require the same registration, while Brussels requires a different one. However, the minimum standards (Diesel Euro 5, Petrol Euro 2) are the same for all.The registrations are completely digital. <br>\r\n&emsp;Vehicles are registered in the national database, and the LEZ is enforced by smart cameras that detect license plates, so physical proof of registration is not required.','None'),('Belgium, Nertherlands',2,'Belgium','Digital','None','0','0','The selected vehicle does not qualify for any of the two registration options in Belgium.','&emsp;As of 2024, Belgium has three active Low Emission Zones: Antwerp, Ghent, and Brussels. Access to these zones is restricted for vehicles that do not meet the minimum standards of Diesel Euro 5 and Petrol Euro 2. <br>\r\n&emsp;Antwerp and Ghent require the same registration, while Brussels requires a different one. However, the minimum standards (Diesel Euro 5, Petrol Euro 2) are the same for all.The registrations are completely digital. <br>\r\n&emsp;Vehicles are registered in the national database, and the LEZ is enforced by smart cameras that detect license plates, so physical proof of registration is not required.','None');
/*!40000 ALTER TABLE `belgium_registrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Blocked_users`
--

DROP TABLE IF EXISTS `Blocked_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Blocked_users` (
  `ip_address` varchar(50) NOT NULL,
  `user_id` int DEFAULT NULL,
  `blocked_until` datetime NOT NULL,
  `total_bans` int DEFAULT NULL,
  PRIMARY KEY (`ip_address`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `Blocked_users_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Blocked_users`
--

LOCK TABLES `Blocked_users` WRITE;
/*!40000 ALTER TABLE `Blocked_users` DISABLE KEYS */;
INSERT INTO `Blocked_users` VALUES ('127.0.0.1',NULL,'2099-01-01 00:00:00',66);
/*!40000 ALTER TABLE `Blocked_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bulgaria_registrations`
--

DROP TABLE IF EXISTS `bulgaria_registrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bulgaria_registrations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `country` varchar(50) DEFAULT NULL,
  `registration_type` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `minimum_diesel` varchar(50) DEFAULT NULL,
  `minimum_petrol` varchar(50) DEFAULT NULL,
  `result` text,
  `description` text,
  `image_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bulgaria_registrations`
--

LOCK TABLES `bulgaria_registrations` WRITE;
/*!40000 ALTER TABLE `bulgaria_registrations` DISABLE KEYS */;
INSERT INTO `bulgaria_registrations` VALUES (1,'Bulgaria','Sticker/ ?  ','Eco-Stickers (I and II)','6','4','The selected vehicle is permitted to enter the Winter Low Emission Zone in Sofia, Bulgaria.\r\n','&emsp;As of 2024, Bulgaria has one active Low Emission Zone in Sofia, enforced during the winter period from 1st December to 28th February each year. <br>\r\n&emsp;Access to this zone is restricted for Bulgarian vehicles that do not meet the minimum standards for Eco sticker I and II Registration (Diesel Euro 6 and Petrol Euro 4). These stickers are issued by local authorities during the annual car inspection. Therefore, foreign vehicles are exempt from requiring a sticker or registration but must adhere to the same minimum standards. <br>\r\n&emsp;Since this regulation was only implemented in 2023, no penalties have been imposed to date.<br>','None'),(2,'Bulgaria','Sticker/ ?  ','None','0','0','The selected vehicle is NOT permitted to enter the Winter Low Emission Zone in Sofia, Bulgaria.\r\n\r\n\r\n\r\n\r\n\r\n\r\n','&emsp;As of 2024, Bulgaria has one active Low Emission Zone in Sofia, enforced during the winter period from 1st December to 28th February each year. <br>\r\n&emsp;Access to this zone is restricted for Bulgarian vehicles that do not meet the minimum standards for Eco sticker I and II Registration (Diesel Euro 6 and Petrol Euro 4). These stickers are issued by local authorities during the annual car inspection. Therefore, foreign vehicles are exempt from requiring a sticker or registration but must adhere to the same minimum standards. <br>\r\n&emsp;Since this regulation was only implemented in 2023, no penalties have been imposed to date.<br>','None');
/*!40000 ALTER TABLE `bulgaria_registrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `car`
--

DROP TABLE IF EXISTS `car`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `car` (
  `id` int NOT NULL AUTO_INCREMENT,
  `owner_id` int DEFAULT NULL,
  `brand` varchar(50) DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `year` int DEFAULT NULL,
  `fuel_type` varchar(50) DEFAULT NULL,
  `euro_standard` varchar(50) DEFAULT NULL,
  `dpf` tinyint(1) DEFAULT NULL,
  `registration_country` varchar(50) DEFAULT NULL,
  `belgium_registrations` varchar(50) DEFAULT NULL,
  `bulgaria_registrations` varchar(50) DEFAULT NULL,
  `denmark_registrations` varchar(50) DEFAULT NULL,
  `france_registrations` varchar(50) DEFAULT NULL,
  `germany_registrations` varchar(50) DEFAULT NULL,
  `greece_registrations` varchar(50) DEFAULT NULL,
  `netherlands_registrations` varchar(50) DEFAULT NULL,
  `norway_registrations` varchar(50) DEFAULT NULL,
  `poland_registrations` varchar(50) DEFAULT NULL,
  `spain_registrations` varchar(50) DEFAULT NULL,
  `united_kingdom_registrations` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `owner_id` (`owner_id`),
  CONSTRAINT `car_ibfk_1` FOREIGN KEY (`owner_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `car`
--



--
-- Table structure for table `denmark_registrations`
--

DROP TABLE IF EXISTS `denmark_registrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `denmark_registrations` (
  `exception_country` varchar(50) DEFAULT NULL,
  `id` int NOT NULL AUTO_INCREMENT,
  `country` varchar(50) DEFAULT NULL,
  `registration_type` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `minimum_diesel` varchar(50) DEFAULT NULL,
  `minimum_petrol` varchar(50) DEFAULT NULL,
  `result` text,
  `description` text,
  `image_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `denmark_registrations`
--

LOCK TABLES `denmark_registrations` WRITE;
/*!40000 ALTER TABLE `denmark_registrations` DISABLE KEYS */;
INSERT INTO `denmark_registrations` VALUES ('Denmark, Norway',1,'Denmark','Digital','Aalborg, Aarhurs, Copenhagen, Odense','5','5','The selected vehicle is eligible for digital registration in all of Denmark\'s Low Emission Zones.','&emsp;As of 2024, Denmark has four active Low Emission Zones: Aalborg, Aarhus, Copenhagen, and Odense. Access to these zones is restricted for vehicles that do not meet the minimum standard of Euro 5 for both diesel and petrol. <br>\r\n&emsp;Foreign vehicles must be registered in the Danish National database no later than the day of entry. Vehicles registered in Denmark and Norway are exempt from this requirement as they are already included in the database. <br>\r\n&emsp;The registration process is entirely digital. LEZ regulations are enforced by cameras placed throughout the cities. <br>','None'),('Denmark, Norway',2,'Denmark','Digital','None','0','0','The selected vehicle is NOT eligible for digital registration in Denmark\'s Low Emission Zones.','&emsp;As of 2024, Denmark has four active Low Emission Zones: Aalborg, Aarhus, Copenhagen, and Odense. Access to these zones is restricted for vehicles that do not meet the minimum standard of Euro 5 for both diesel and petrol. <br>\r\n&emsp;Foreign vehicles must be registered in the Danish National database no later than the day of entry. Vehicles registered in Denmark and Norway are exempt from this requirement as they are already included in the database. <br>\r\n&emsp;The registration process is entirely digital. LEZ regulations are enforced by cameras placed throughout the cities. <br>','None');
/*!40000 ALTER TABLE `denmark_registrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `france_registrations`
--

DROP TABLE IF EXISTS `france_registrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `france_registrations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `country` varchar(50) DEFAULT NULL,
  `registration_type` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `minimum_diesel` varchar(50) DEFAULT NULL,
  `minimum_petrol` varchar(50) DEFAULT NULL,
  `result` text,
  `description` text,
  `image_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `france_registrations`
--

LOCK TABLES `france_registrations` WRITE;
/*!40000 ALTER TABLE `france_registrations` DISABLE KEYS */;
INSERT INTO `france_registrations` VALUES (1,'France','Sticker','Crit Air 1','-','5','Selected vehicle is eligible for Crit’Air 1 (purple sticker). This sticker is assigned to plug-in hybrid vehicles, in addition to Euro 5 and 6 Petrol vehicles. Diesel vehicles are not eligible for Crit’Air 1.','&emsp;In France, there are 13 Low Emission Zones that affect passenger vehicles. Each of these zones requires a registration known as Crit\'Air (Critères de Circulation Air). They are represented by stickers and classify vehicles according to their Euro emission standard. These stickers are mandatory and must be permanently displayed on the windshield for easy identification.<br><br>\r\n\r\n    <ul>\r\n        <li><strong>Crit\'Air 0/E:</strong> Green sticker for zero emission electric and hydrogen vehicles.</li>\r\n        <li><strong>Crit\'Air 1:</strong> Purple sticker for plug-in hybrid vehicles and Euro 5, 6 petrol vehicles.</li>\r\n        <li><strong>Crit\'Air 2:</strong> Yellow sticker for Euro 4 petrol vehicles, and Euro 5, 6 diesel vehicles.</li>\r\n        <li><strong>Crit\'Air 3:</strong> Orange sticker for Euro 2, 3 petrol vehicles and Euro 4 diesel vehicles.</li>\r\n        <li><strong>Crit\'Air 4:</strong> Burgundy sticker for Euro 3 diesel vehicles.</li>\r\n        <li><strong>Crit\'Air 5:</strong> Dark grey sticker for Euro 2 diesel vehicles.</li>\r\n    </ul>\r\n<br>\r\n&emsp;Local authorities determine restrictions based on current air quality levels. For more information, please visit our website, specifically the France page or the Route Planner page. <br>','/static/france/critair1_rs.png'),(2,'France','Sticker','Crit Air 2','5','4','Selected vehicle is eligible for Crit’Air 2 (yellow sticker). This sticker is assigned to Euro 4 Petrol vehicles in addition to Euro 5 and 6 Diesel vehicles. \r\n','&emsp;In France, there are 13 Low Emission Zones that affect passenger vehicles. Each of these zones requires a registration known as Crit\'Air (Critères de Circulation Air). They are represented by stickers and classify vehicles according to their Euro emission standard. These stickers are mandatory and must be permanently displayed on the windshield for easy identification.<br><br>\r\n\r\n    <ul>\r\n        <li><strong>Crit\'Air 0/E:</strong> Green sticker for zero emission electric and hydrogen vehicles.</li>\r\n        <li><strong>Crit\'Air 1:</strong> Purple sticker for plug-in hybrid vehicles and Euro 5, 6 petrol vehicles.</li>\r\n        <li><strong>Crit\'Air 2:</strong> Yellow sticker for Euro 4 petrol vehicles, and Euro 5, 6 diesel vehicles.</li>\r\n        <li><strong>Crit\'Air 3:</strong> Orange sticker for Euro 2, 3 petrol vehicles and Euro 4 diesel vehicles.</li>\r\n        <li><strong>Crit\'Air 4:</strong> Burgundy sticker for Euro 3 diesel vehicles.</li>\r\n        <li><strong>Crit\'Air 5:</strong> Dark grey sticker for Euro 2 diesel vehicles.</li>\r\n    </ul>\r\n<br>\r\n&emsp;Local authorities determine restrictions based on current air quality levels. For more information, please visit our website, specifically the France page or the Route Planner page. <br>','/static/france/critair2.png'),(3,'France','Sticker','Crit Air 3','4 ','2','Selected vehicle is eligible for Crit’Air 3 (orange sticker). This sticker is assigned to Euro 4 Diesel vehicles in addition to Euro 2 and 3 Petrol vehicles. ','&emsp;In France, there are 13 Low Emission Zones that affect passenger vehicles. Each of these zones requires a registration known as Crit\'Air (Critères de Circulation Air). They are represented by stickers and classify vehicles according to their Euro emission standard. These stickers are mandatory and must be permanently displayed on the windshield for easy identification.<br><br>\r\n\r\n    <ul>\r\n        <li><strong>Crit\'Air 0/E:</strong> Green sticker for zero emission electric and hydrogen vehicles.</li>\r\n        <li><strong>Crit\'Air 1:</strong> Purple sticker for plug-in hybrid vehicles and Euro 5, 6 petrol vehicles.</li>\r\n        <li><strong>Crit\'Air 2:</strong> Yellow sticker for Euro 4 petrol vehicles, and Euro 5, 6 diesel vehicles.</li>\r\n        <li><strong>Crit\'Air 3:</strong> Orange sticker for Euro 2, 3 petrol vehicles and Euro 4 diesel vehicles.</li>\r\n        <li><strong>Crit\'Air 4:</strong> Burgundy sticker for Euro 3 diesel vehicles.</li>\r\n        <li><strong>Crit\'Air 5:</strong> Dark grey sticker for Euro 2 diesel vehicles.</li>\r\n    </ul>\r\n<br>\r\n&emsp;Local authorities determine restrictions based on current air quality levels. For more information, please visit our website, specifically the France page or the Route Planner page. <br>','/static/france/critair3.png'),(4,'France','Sticker','Crit Air 4','3','-','Selected vehicle is eligible for Crit’Air 4 (burgundy sticker). This sticker is assigned to Euro 3 Diesel vehicles. Petrol vehicles are not eligible for Crit’Air 4. ','&emsp;In France, there are 13 Low Emission Zones that affect passenger vehicles. Each of these zones requires a registration known as Crit\'Air (Critères de Circulation Air). They are represented by stickers and classify vehicles according to their Euro emission standard. These stickers are mandatory and must be permanently displayed on the windshield for easy identification.<br><br>\r\n\r\n    <ul>\r\n        <li><strong>Crit\'Air 0/E:</strong> Green sticker for zero emission electric and hydrogen vehicles.</li>\r\n        <li><strong>Crit\'Air 1:</strong> Purple sticker for plug-in hybrid vehicles and Euro 5, 6 petrol vehicles.</li>\r\n        <li><strong>Crit\'Air 2:</strong> Yellow sticker for Euro 4 petrol vehicles, and Euro 5, 6 diesel vehicles.</li>\r\n        <li><strong>Crit\'Air 3:</strong> Orange sticker for Euro 2, 3 petrol vehicles and Euro 4 diesel vehicles.</li>\r\n        <li><strong>Crit\'Air 4:</strong> Burgundy sticker for Euro 3 diesel vehicles.</li>\r\n        <li><strong>Crit\'Air 5:</strong> Dark grey sticker for Euro 2 diesel vehicles.</li>\r\n    </ul>\r\n<br>\r\n&emsp;Local authorities determine restrictions based on current air quality levels. For more information, please visit our website, specifically the France page or the Route Planner page. <br>','/static/france/critair4.png'),(5,'France','Sticker','Crit Air 5','2','-','Selected vehicle is eligible for Crit’Air 5 (dark grey sticker). This sticker is assigned to Euro 2 Diesel vehicles. Petrol vehicles are not eligible for Crit’Air 5. ','&emsp;In France, there are 13 Low Emission Zones that affect passenger vehicles. Each of these zones requires a registration known as Crit\'Air (Critères de Circulation Air). They are represented by stickers and classify vehicles according to their Euro emission standard. These stickers are mandatory and must be permanently displayed on the windshield for easy identification.<br><br>\r\n\r\n    <ul>\r\n        <li><strong>Crit\'Air 0/E:</strong> Green sticker for zero emission electric and hydrogen vehicles.</li>\r\n        <li><strong>Crit\'Air 1:</strong> Purple sticker for plug-in hybrid vehicles and Euro 5, 6 petrol vehicles.</li>\r\n        <li><strong>Crit\'Air 2:</strong> Yellow sticker for Euro 4 petrol vehicles, and Euro 5, 6 diesel vehicles.</li>\r\n        <li><strong>Crit\'Air 3:</strong> Orange sticker for Euro 2, 3 petrol vehicles and Euro 4 diesel vehicles.</li>\r\n        <li><strong>Crit\'Air 4:</strong> Burgundy sticker for Euro 3 diesel vehicles.</li>\r\n        <li><strong>Crit\'Air 5:</strong> Dark grey sticker for Euro 2 diesel vehicles.</li>\r\n    </ul>\r\n<br>\r\n&emsp;Local authorities determine restrictions based on current air quality levels. For more information, please visit our website, specifically the France page or the Route Planner page. <br>','/static/france/critair5.png'),(6,'France','Sticker','None','0','0','Selected vehicle is not eligible for any of the Crit\'Air registrations.','&emsp;In France, there are 13 Low Emission Zones that affect passenger vehicles. Each of these zones requires a registration known as Crit\'Air (Critères de Circulation Air). They are represented by stickers and classify vehicles according to their Euro emission standard. These stickers are mandatory and must be permanently displayed on the windshield for easy identification.<br><br>\r\n\r\n    <ul>\r\n        <li><strong>Crit\'Air 0/E:</strong> Green sticker for zero emission electric and hydrogen vehicles.</li>\r\n        <li><strong>Crit\'Air 1:</strong> Purple sticker for plug-in hybrid vehicles and Euro 5, 6 petrol vehicles.</li>\r\n        <li><strong>Crit\'Air 2:</strong> Yellow sticker for Euro 4 petrol vehicles, and Euro 5, 6 diesel vehicles.</li>\r\n        <li><strong>Crit\'Air 3:</strong> Orange sticker for Euro 2, 3 petrol vehicles and Euro 4 diesel vehicles.</li>\r\n        <li><strong>Crit\'Air 4:</strong> Burgundy sticker for Euro 3 diesel vehicles.</li>\r\n        <li><strong>Crit\'Air 5:</strong> Dark grey sticker for Euro 2 diesel vehicles.</li>\r\n    </ul>\r\n<br>\r\n&emsp;Local authorities determine restrictions based on current air quality levels. For more information, please visit our website, specifically the France page or the Route Planner page. <br>','None'),(7,'France','Sticker','Crit Air 0/E',NULL,NULL,'Selected vehicle is eligible for Crit’Air 0/E (green sticker). This sticker is assigned to zero emission electric and hydrogen vehicles.','&emsp;In France, there are 13 Low Emission Zones that affect passenger vehicles. Each of these zones requires a registration known as Crit\'Air (Critères de Circulation Air). They are represented by stickers and classify vehicles according to their Euro emission standard. These stickers are mandatory and must be permanently displayed on the windshield for easy identification.<br><br>\r\n\r\n    <ul>\r\n        <li><strong>Crit\'Air 0/E:</strong> Green sticker for zero emission electric and hydrogen vehicles.</li>\r\n        <li><strong>Crit\'Air 1:</strong> Purple sticker for plug-in hybrid vehicles and Euro 5, 6 petrol vehicles.</li>\r\n        <li><strong>Crit\'Air 2:</strong> Yellow sticker for Euro 4 petrol vehicles, and Euro 5, 6 diesel vehicles.</li>\r\n        <li><strong>Crit\'Air 3:</strong> Orange sticker for Euro 2, 3 petrol vehicles and Euro 4 diesel vehicles.</li>\r\n        <li><strong>Crit\'Air 4:</strong> Burgundy sticker for Euro 3 diesel vehicles.</li>\r\n        <li><strong>Crit\'Air 5:</strong> Dark grey sticker for Euro 2 diesel vehicles.</li>\r\n    </ul>\r\n<br>\r\n&emsp;Local authorities determine restrictions based on current air quality levels. For more information, please visit our website, specifically the France page or the Route Planner page. <br>','/static/france/critairE.png');
/*!40000 ALTER TABLE `france_registrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `germany_registrations`
--

DROP TABLE IF EXISTS `germany_registrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `germany_registrations` (
  `minimum_diesel_wdpf` varchar(50) DEFAULT NULL,
  `minimum_petrol_wdpf` varchar(50) DEFAULT NULL,
  `id` int NOT NULL AUTO_INCREMENT,
  `country` varchar(50) DEFAULT NULL,
  `registration_type` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `minimum_diesel` varchar(50) DEFAULT NULL,
  `minimum_petrol` varchar(50) DEFAULT NULL,
  `result` text,
  `description` text,
  `image_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `germany_registrations`
--

LOCK TABLES `germany_registrations` WRITE;
/*!40000 ALTER TABLE `germany_registrations` DISABLE KEYS */;
INSERT INTO `germany_registrations` VALUES ('3','0',1,'Germany','Sticker','Umweltplakette Green - 4','4','1','Selected vehicle is eligible for Green German Emission Sticker (Umweltplakette)','<p>&emsp;German cities can legally designate Low Emission Zones where only vehicles with an emissions sticker are allowed to enter. These stickers are called Umweltplakette in German and must be displayed on the windshield, clearly visible for authorities. Green represents the cleanest and most environmentally friendly sticker, followed by yellow and lastly, red for the highest polluting vehicle.</p>\r\n\r\n    <ul>\r\n        <li><strong>Green Sticker:</strong> Diesel: Euro 4, 5, 6, or Euro 3 with filter. Petrol: Euro 1 or better, pre-Euro 1 with converter.</li>\r\n        <li><strong>Yellow Sticker:</strong> Diesel: Euro 3, or Euro 2 with filter. Petrol: Euro 1 or better.</li>\r\n        <li><strong>Red Sticker:</strong> Diesel: Euro 2, or Euro 1 with filter. Petrol: Euro 1 or better.</li>\r\n        <li><strong>No Sticker:</strong> Diesel: Euro 1 or worse. Petrol: Without a catalytic converter.</li>\r\n    </ul>\r\n	<br>\r\n\r\n    <p>&emsp;Local authorities set restrictions based on air quality levels. You can verify the regulations on our website by visiting the Germany page or the Route Planner page.</p>','/static/images/germany_green.png'),('2','-',2,'Germany','Sticker','Umweltplakette Yellow - 3','3','-','Selected vehicle is eligible for Yellow German Emission Sticker (Umweltplakette)','<p>&emsp;German cities can legally designate Low Emission Zones where only vehicles with an emissions sticker are allowed to enter. These stickers are called Umweltplakette in German and must be displayed on the windshield, clearly visible for authorities. Green represents the cleanest and most environmentally friendly sticker, followed by yellow and lastly, red for the highest polluting vehicle.</p>\r\n\r\n    <ul>\r\n        <li><strong>Green Sticker:</strong> Diesel: Euro 4, 5, 6, or Euro 3 with filter. Petrol: Euro 1 or better, pre-Euro 1 with converter.</li>\r\n        <li><strong>Yellow Sticker:</strong> Diesel: Euro 3, or Euro 2 with filter. Petrol: Euro 1 or better.</li>\r\n        <li><strong>Red Sticker:</strong> Diesel: Euro 2, or Euro 1 with filter. Petrol: Euro 1 or better.</li>\r\n        <li><strong>No Sticker:</strong> Diesel: Euro 1 or worse. Petrol: Without a catalytic converter.</li>\r\n    </ul>\r\n	<br>\r\n\r\n    <p>&emsp;Local authorities set restrictions based on air quality levels. You can verify the regulations on our website by visiting the Germany page or the Route Planner page.</p>','/static/images/germany_yellow.png'),('1','-',3,'Germany','Sticker','Umweltplakette Red - 2','2','-','Selected vehicle is eligible for Red Emission Sticker (Umweltplakette)','<p>&emsp;German cities can legally designate Low Emission Zones where only vehicles with an emissions sticker are allowed to enter. These stickers are called Umweltplakette in German and must be displayed on the windshield, clearly visible for authorities. Green represents the cleanest and most environmentally friendly sticker, followed by yellow and lastly, red for the highest polluting vehicle.</p>\r\n\r\n    <ul>\r\n        <li><strong>Green Sticker:</strong> Diesel: Euro 4, 5, 6, or Euro 3 with filter. Petrol: Euro 1 or better, pre-Euro 1 with converter.</li>\r\n        <li><strong>Yellow Sticker:</strong> Diesel: Euro 3, or Euro 2 with filter. Petrol: Euro 1 or better.</li>\r\n        <li><strong>Red Sticker:</strong> Diesel: Euro 2, or Euro 1 with filter. Petrol: Euro 1 or better.</li>\r\n        <li><strong>No Sticker:</strong> Diesel: Euro 1 or worse. Petrol: Without a catalytic converter.</li>\r\n    </ul>\r\n	<br>\r\n\r\n    <p>&emsp;Local authorities set restrictions based on air quality levels. You can verify the regulations on our website by visiting the Germany page or the Route Planner page.</p>','/static/images/germany_red.png'),('0','-',4,'Germany','Sticker','None','0','0','Selected vehicle is not eligible for German Emission Stickers (Umweltplakette)','<p>&emsp;German cities can legally designate Low Emission Zones where only vehicles with an emissions sticker are allowed to enter. These stickers are called Umweltplakette in German and must be displayed on the windshield, clearly visible for authorities. Green represents the cleanest and most environmentally friendly sticker, followed by yellow and lastly, red for the highest polluting vehicle.</p>\r\n\r\n    <ul>\r\n        <li><strong>Green Sticker:</strong> Diesel: Euro 4, 5, 6, or Euro 3 with filter. Petrol: Euro 1 or better, pre-Euro 1 with converter.</li>\r\n        <li><strong>Yellow Sticker:</strong> Diesel: Euro 3, or Euro 2 with filter. Petrol: Euro 1 or better.</li>\r\n        <li><strong>Red Sticker:</strong> Diesel: Euro 2, or Euro 1 with filter. Petrol: Euro 1 or better.</li>\r\n        <li><strong>No Sticker:</strong> Diesel: Euro 1 or worse. Petrol: Without a catalytic converter.</li>\r\n    </ul>\r\n	<br>\r\n\r\n    <p>&emsp;Local authorities set restrictions based on air quality levels. You can verify the regulations on our website by visiting the Germany page or the Route Planner page.</p>','None');
/*!40000 ALTER TABLE `germany_registrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `greece_registrations`
--

DROP TABLE IF EXISTS `greece_registrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `greece_registrations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `country` varchar(50) DEFAULT NULL,
  `registration_type` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `minimum_diesel` varchar(50) DEFAULT NULL,
  `minimum_petrol` varchar(50) DEFAULT NULL,
  `result` text,
  `description` text,
  `image_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `greece_registrations`
--

LOCK TABLES `greece_registrations` WRITE;
/*!40000 ALTER TABLE `greece_registrations` DISABLE KEYS */;
/*!40000 ALTER TABLE `greece_registrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `italy_access`
--

DROP TABLE IF EXISTS `italy_access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `italy_access` (
  `id` int NOT NULL AUTO_INCREMENT,
  `country` varchar(50) DEFAULT NULL,
  `registration_type` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `minimum_diesel` varchar(50) DEFAULT NULL,
  `minimum_petrol` varchar(50) DEFAULT NULL,
  `result` text,
  `description` text,
  `image_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `italy_access`
--

LOCK TABLES `italy_access` WRITE;
/*!40000 ALTER TABLE `italy_access` DISABLE KEYS */;
INSERT INTO `italy_access` VALUES (4,'ITALY','None','Lombardia Region Winter ','6','3','The selected vehicle qualifies for access to the Lombardia Low Emission Zones (LEZs) throughout the entire year, including the Winter LEZ period.','&emsp;In Italy, the region of Lombardia has implemented Low Emission Zones (LEZs) to address air pollution. These zones are divided into two categories: the Winter LEZ, which is in effect from October 1st to March 31st, and the All Year LEZ. Notably, vehicle registration is not required to enter these zones. <br>\r\n&emsp;For additional details, please refer to the Route Planner or visit the Italy information page.<br>','None'),(5,'ITALY','None','Lombardia Region General','4','2','The selected vehicle is permitted access to the Lombardia Low Emission Zones (LEZs) only outside the Winter LEZ period.','&emsp;In Italy, the region of Lombardia has implemented Low Emission Zones (LEZs) to address air pollution. These zones are divided into two categories: the Winter LEZ, which is in effect from October 1st to March 31st, and the All Year LEZ. Notably, vehicle registration is not required to enter these zones. <br>\r\n&emsp;For additional details, please refer to the Route Planner or visit the Italy information page.<br>','None'),(6,'ITALY','None','None','0','0','The selected vehicle is not eligible for access to the Lombardia Low Emission Zones (LEZs).','&emsp;In Italy, the region of Lombardia has implemented Low Emission Zones (LEZs) to address air pollution. These zones are divided into two categories: the Winter LEZ, which is in effect from October 1st to March 31st, and the All Year LEZ. Notably, vehicle registration is not required to enter these zones. <br>\r\n&emsp;For additional details, please refer to the Route Planner or visit the Italy information page.<br>','None');
/*!40000 ALTER TABLE `italy_access` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `netherlands_registrations`
--

DROP TABLE IF EXISTS `netherlands_registrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `netherlands_registrations` (
  `exception_country` varchar(50) DEFAULT NULL,
  `id` int NOT NULL AUTO_INCREMENT,
  `country` varchar(50) DEFAULT NULL,
  `registration_type` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `minimum_diesel` varchar(50) DEFAULT NULL,
  `minimum_petrol` varchar(50) DEFAULT NULL,
  `result` text,
  `description` text,
  `image_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `netherlands_registrations`
--

LOCK TABLES `netherlands_registrations` WRITE;
/*!40000 ALTER TABLE `netherlands_registrations` DISABLE KEYS */;
INSERT INTO `netherlands_registrations` VALUES ('',1,'Netherlands','TEL/DIGITAL','Reg Class 4 or higher','4','0','The selected vehicle meets the Low Emission Zone (LEZ) standards and is authorized for entry.','&emsp;In the Netherlands, Low Emission Zones (LEZs) operate solely based on emission standards, without requiring stickers or physical registrations. <br>\r\n&emsp;Currently, the regulations apply exclusively to diesel vehicles that do not meet Euro 4 standards.','None'),('',2,'Netherlands','None','Reg Class 4 or higher','0','0','The selected vehicle does not comply with the Low Emission Zone (LEZ) standards and is therefore not authorized for entry.','&emsp;In the Netherlands, Low Emission Zones (LEZs) operate solely based on emission standards, without requiring stickers or physical registrations. <br>\r\n&emsp;Currently, the regulations apply exclusively to diesel vehicles that do not meet Euro 4 standards.','None');
/*!40000 ALTER TABLE `netherlands_registrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `poland_registrations`
--

DROP TABLE IF EXISTS `poland_registrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `poland_registrations` (
  `min_dis_bf_010323` varchar(50) DEFAULT NULL,
  `min_dis_af_010323` varchar(50) DEFAULT NULL,
  `min_pet_bf_010323` varchar(50) DEFAULT NULL,
  `min_pet_af_010323` varchar(50) DEFAULT NULL,
  `id` int NOT NULL AUTO_INCREMENT,
  `country` varchar(50) DEFAULT NULL,
  `registration_type` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `minimum_diesel` varchar(50) DEFAULT NULL,
  `minimum_petrol` varchar(50) DEFAULT NULL,
  `result` text,
  `description` text,
  `image_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `poland_registrations`
--

LOCK TABLES `poland_registrations` WRITE;
/*!40000 ALTER TABLE `poland_registrations` DISABLE KEYS */;
/*!40000 ALTER TABLE `poland_registrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `portugal_registrations`
--

DROP TABLE IF EXISTS `portugal_registrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `portugal_registrations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `country` varchar(50) DEFAULT NULL,
  `registration_type` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `minimum_diesel` varchar(50) DEFAULT NULL,
  `minimum_petrol` varchar(50) DEFAULT NULL,
  `result` text,
  `description` text,
  `image_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `portugal_registrations`
--

LOCK TABLES `portugal_registrations` WRITE;
/*!40000 ALTER TABLE `portugal_registrations` DISABLE KEYS */;
INSERT INTO `portugal_registrations` VALUES (1,'Portugal','None','None','3','3','The selected vehicle is permitted to enter the Lisbon Low Emission Zone (LEZ).','&emsp;Lisbon is the only city in Portugal with a Low Emission Zone (LEZ). No special registration is required within this zone, but it\'s important to adhere to the established limits to avoid any potential penalties.','None'),(2,'Portugal','None','None','0','0','The selected vehicle is prohibited from entering the Lisbon Low Emission Zone (LEZ).','&emsp;Lisbon is the only city in Portugal with a Low Emission Zone (LEZ). No special registration is required within this zone, but it\'s important to adhere to the established limits to avoid any potential penalties.','None');
/*!40000 ALTER TABLE `portugal_registrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `requests_log`
--

DROP TABLE IF EXISTS `requests_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `requests_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL,
  `endpoint` varchar(255) NOT NULL,
  `timestamp` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `requests_log_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2956 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requests_log`
--

LOCK TABLES `requests_log` WRITE;
/*!40000 ALTER TABLE `requests_log` DISABLE KEYS */;
INSERT INTO `requests_log` VALUES (2152,NULL,'127.0.0.1','/','2025-01-05 09:38:55'),(2153,NULL,'127.0.0.1','/','2025-01-05 09:38:56'),(2154,NULL,'127.0.0.1','/','2025-01-05 09:38:56'),(2155,NULL,'127.0.0.1','/','2025-01-05 09:38:56'),(2156,NULL,'127.0.0.1','/','2025-01-05 09:38:57'),(2157,NULL,'127.0.0.1','/','2025-01-05 09:38:57'),(2158,NULL,'127.0.0.1','/','2025-01-05 09:38:57'),(2159,NULL,'127.0.0.1','/','2025-01-05 09:38:58'),(2160,NULL,'127.0.0.1','/','2025-01-05 09:38:58'),(2161,NULL,'127.0.0.1','/','2025-01-05 09:38:58'),(2162,NULL,'127.0.0.1','/','2025-01-05 09:38:59'),(2163,NULL,'127.0.0.1','/','2025-01-05 09:38:59'),(2164,NULL,'127.0.0.1','/','2025-01-05 09:38:59'),(2165,NULL,'127.0.0.1','/','2025-01-05 09:39:00'),(2166,NULL,'127.0.0.1','/','2025-01-05 09:39:00'),(2167,NULL,'127.0.0.1','/','2025-01-05 09:39:00'),(2168,NULL,'127.0.0.1','/','2025-01-05 09:39:01'),(2169,NULL,'127.0.0.1','/','2025-01-05 09:39:01'),(2170,NULL,'127.0.0.1','/','2025-01-05 09:39:01'),(2171,NULL,'127.0.0.1','/','2025-01-05 09:39:02'),(2172,NULL,'127.0.0.1','/','2025-01-05 09:39:02'),(2173,NULL,'127.0.0.1','/','2025-01-05 09:39:02'),(2174,NULL,'127.0.0.1','/','2025-01-05 09:39:02'),(2175,NULL,'127.0.0.1','/','2025-01-05 09:39:03'),(2176,NULL,'127.0.0.1','/','2025-01-05 09:39:03'),(2177,NULL,'127.0.0.1','/','2025-01-05 09:39:03'),(2178,NULL,'127.0.0.1','/','2025-01-05 09:39:04'),(2179,NULL,'127.0.0.1','/','2025-01-05 09:39:04'),(2180,NULL,'127.0.0.1','/','2025-01-05 09:39:05'),(2181,NULL,'127.0.0.1','/','2025-01-05 09:39:05'),(2182,NULL,'127.0.0.1','/','2025-01-05 09:39:06'),(2183,NULL,'127.0.0.1','/','2025-01-05 09:39:06'),(2184,NULL,'127.0.0.1','/','2025-01-05 09:39:07'),(2185,NULL,'127.0.0.1','/','2025-01-05 09:39:07'),(2186,NULL,'127.0.0.1','/','2025-01-05 09:39:08'),(2187,NULL,'127.0.0.1','/','2025-01-05 09:39:08'),(2188,NULL,'127.0.0.1','/','2025-01-05 09:39:09'),(2189,NULL,'127.0.0.1','/','2025-01-05 09:39:09'),(2190,NULL,'127.0.0.1','/','2025-01-05 09:39:09'),(2191,NULL,'127.0.0.1','/','2025-01-05 09:39:10'),(2192,NULL,'127.0.0.1','/','2025-01-05 09:39:10'),(2193,NULL,'127.0.0.1','/','2025-01-05 09:39:11'),(2194,NULL,'127.0.0.1','/','2025-01-05 09:39:11'),(2195,NULL,'127.0.0.1','/','2025-01-05 09:39:12'),(2196,NULL,'127.0.0.1','/','2025-01-05 09:39:12'),(2197,NULL,'127.0.0.1','/','2025-01-05 09:39:13'),(2198,NULL,'127.0.0.1','/','2025-01-05 09:39:13'),(2199,NULL,'127.0.0.1','/','2025-01-05 09:39:14'),(2200,NULL,'127.0.0.1','/','2025-01-05 09:39:14'),(2201,NULL,'127.0.0.1','/','2025-01-05 09:39:15'),(2202,NULL,'127.0.0.1','/','2025-01-05 09:39:15'),(2203,NULL,'127.0.0.1','/','2025-01-05 09:39:16'),(2204,NULL,'127.0.0.1','/','2025-01-05 09:39:16'),(2205,NULL,'127.0.0.1','/','2025-01-05 09:39:17'),(2206,NULL,'127.0.0.1','/','2025-01-05 09:39:17'),(2207,NULL,'127.0.0.1','/','2025-01-05 09:39:17'),(2208,NULL,'127.0.0.1','/','2025-01-05 09:39:18'),(2209,NULL,'127.0.0.1','/','2025-01-05 09:39:18'),(2210,NULL,'127.0.0.1','/','2025-01-05 09:39:19'),(2211,NULL,'127.0.0.1','/','2025-01-05 09:39:19'),(2212,NULL,'127.0.0.1','/','2025-01-05 09:39:20'),(2213,NULL,'127.0.0.1','/','2025-01-05 09:39:20'),(2214,NULL,'127.0.0.1','/','2025-01-05 09:39:21'),(2215,NULL,'127.0.0.1','/','2025-01-05 09:39:21'),(2216,NULL,'127.0.0.1','/','2025-01-05 09:39:22'),(2217,NULL,'127.0.0.1','/','2025-01-05 09:39:22'),(2218,NULL,'127.0.0.1','/','2025-01-05 09:39:23'),(2219,NULL,'127.0.0.1','/','2025-01-05 09:39:23'),(2220,NULL,'127.0.0.1','/','2025-01-05 09:39:23'),(2221,NULL,'127.0.0.1','/','2025-01-05 09:39:24'),(2222,NULL,'127.0.0.1','/','2025-01-05 09:39:24'),(2223,NULL,'127.0.0.1','/','2025-01-05 09:39:25'),(2224,NULL,'127.0.0.1','/','2025-01-05 09:39:25'),(2225,NULL,'127.0.0.1','/','2025-01-05 09:39:26'),(2226,NULL,'127.0.0.1','/','2025-01-05 09:39:26'),(2227,NULL,'127.0.0.1','/','2025-01-05 09:39:27'),(2228,NULL,'127.0.0.1','/','2025-01-05 09:39:27'),(2229,NULL,'127.0.0.1','/','2025-01-05 09:39:28'),(2230,NULL,'127.0.0.1','/','2025-01-05 09:39:28'),(2231,NULL,'127.0.0.1','/','2025-01-05 09:39:29'),(2232,NULL,'127.0.0.1','/','2025-01-05 09:39:29'),(2233,NULL,'127.0.0.1','/','2025-01-05 09:39:30'),(2234,NULL,'127.0.0.1','/','2025-01-05 09:39:30'),(2235,NULL,'127.0.0.1','/','2025-01-05 09:39:31'),(2236,NULL,'127.0.0.1','/','2025-01-05 09:39:31'),(2237,NULL,'127.0.0.1','/','2025-01-05 09:39:31'),(2238,NULL,'127.0.0.1','/','2025-01-05 09:39:32'),(2239,NULL,'127.0.0.1','/','2025-01-05 09:39:32'),(2240,NULL,'127.0.0.1','/','2025-01-05 09:39:33'),(2241,NULL,'127.0.0.1','/','2025-01-05 09:39:33'),(2242,NULL,'127.0.0.1','/','2025-01-05 09:39:34'),(2243,NULL,'127.0.0.1','/','2025-01-05 09:39:34'),(2244,NULL,'127.0.0.1','/','2025-01-05 09:39:35'),(2245,NULL,'127.0.0.1','/','2025-01-05 09:39:35'),(2246,NULL,'127.0.0.1','/','2025-01-05 09:39:36'),(2247,NULL,'127.0.0.1','/','2025-01-05 09:39:36'),(2248,NULL,'127.0.0.1','/','2025-01-05 09:39:37'),(2249,NULL,'127.0.0.1','/','2025-01-05 09:39:37'),(2250,NULL,'127.0.0.1','/','2025-01-05 09:39:38'),(2251,NULL,'127.0.0.1','/','2025-01-05 09:39:38'),(2252,NULL,'127.0.0.1','/','2025-01-05 09:39:39'),(2253,2,'127.0.0.1','/','2025-01-05 09:40:28'),(2254,2,'127.0.0.1','/cities','2025-01-05 09:40:29'),(2255,2,'127.0.0.1','/maps','2025-01-05 09:40:48'),(2256,2,'127.0.0.1','/eligibility-check','2025-01-05 09:40:50'),(2257,2,'127.0.0.1','/','2025-01-05 09:41:14'),(2258,2,'127.0.0.1','/cities','2025-01-05 09:41:16'),(2259,NULL,'127.0.0.1','/','2025-01-05 09:46:40'),(2260,NULL,'127.0.0.1','/','2025-01-05 09:46:41'),(2261,NULL,'127.0.0.1','/','2025-01-05 09:46:41'),(2262,NULL,'127.0.0.1','/','2025-01-05 09:46:41'),(2263,NULL,'127.0.0.1','/','2025-01-05 09:46:41'),(2264,NULL,'127.0.0.1','/','2025-01-05 09:46:42'),(2265,NULL,'127.0.0.1','/','2025-01-05 09:46:42'),(2266,NULL,'127.0.0.1','/','2025-01-05 09:46:42'),(2267,NULL,'127.0.0.1','/','2025-01-05 09:46:42'),(2268,NULL,'127.0.0.1','/','2025-01-05 09:46:42'),(2269,NULL,'127.0.0.1','/','2025-01-05 09:46:43'),(2270,NULL,'127.0.0.1','/','2025-01-05 09:46:43'),(2271,NULL,'127.0.0.1','/','2025-01-05 09:46:43'),(2272,NULL,'127.0.0.1','/','2025-01-05 09:46:43'),(2273,NULL,'127.0.0.1','/','2025-01-05 09:46:44'),(2274,NULL,'127.0.0.1','/','2025-01-05 09:46:44'),(2275,NULL,'127.0.0.1','/','2025-01-05 09:46:44'),(2276,NULL,'127.0.0.1','/','2025-01-05 09:46:44'),(2277,NULL,'127.0.0.1','/','2025-01-05 09:46:45'),(2278,NULL,'127.0.0.1','/','2025-01-05 09:46:45'),(2279,NULL,'127.0.0.1','/','2025-01-05 09:46:45'),(2280,NULL,'127.0.0.1','/','2025-01-05 09:46:45'),(2281,NULL,'127.0.0.1','/','2025-01-05 09:46:46'),(2282,NULL,'127.0.0.1','/','2025-01-05 09:46:46'),(2283,NULL,'127.0.0.1','/','2025-01-05 09:46:46'),(2284,NULL,'127.0.0.1','/','2025-01-05 09:46:46'),(2285,NULL,'127.0.0.1','/','2025-01-05 09:46:47'),(2286,NULL,'127.0.0.1','/','2025-01-05 09:46:47'),(2287,NULL,'127.0.0.1','/','2025-01-05 09:46:47'),(2288,NULL,'127.0.0.1','/','2025-01-05 09:46:47'),(2289,NULL,'127.0.0.1','/','2025-01-05 09:46:47'),(2290,NULL,'127.0.0.1','/','2025-01-05 09:46:48'),(2291,NULL,'127.0.0.1','/','2025-01-05 09:46:48'),(2292,NULL,'127.0.0.1','/','2025-01-05 09:46:48'),(2293,NULL,'127.0.0.1','/','2025-01-05 09:46:48'),(2294,NULL,'127.0.0.1','/','2025-01-05 09:46:49'),(2295,NULL,'127.0.0.1','/','2025-01-05 09:46:49'),(2296,NULL,'127.0.0.1','/','2025-01-05 09:46:49'),(2297,NULL,'127.0.0.1','/','2025-01-05 09:46:49'),(2298,NULL,'127.0.0.1','/','2025-01-05 09:46:50'),(2299,NULL,'127.0.0.1','/','2025-01-05 09:46:50'),(2300,NULL,'127.0.0.1','/','2025-01-05 09:46:50'),(2301,NULL,'127.0.0.1','/','2025-01-05 09:46:50'),(2302,NULL,'127.0.0.1','/','2025-01-05 09:46:51'),(2303,NULL,'127.0.0.1','/','2025-01-05 09:46:51'),(2304,NULL,'127.0.0.1','/','2025-01-05 09:46:51'),(2305,NULL,'127.0.0.1','/','2025-01-05 09:46:51'),(2306,NULL,'127.0.0.1','/','2025-01-05 09:46:52'),(2307,NULL,'127.0.0.1','/','2025-01-05 09:46:52'),(2308,NULL,'127.0.0.1','/','2025-01-05 09:46:52'),(2309,NULL,'127.0.0.1','/','2025-01-05 09:46:52'),(2310,2,'127.0.0.1','/eligibility-check','2025-01-05 10:20:30'),(2311,NULL,'127.0.0.1','/','2025-01-05 10:22:35'),(2312,NULL,'127.0.0.1','/','2025-01-05 10:22:36'),(2313,NULL,'127.0.0.1','/','2025-01-05 10:22:36'),(2314,NULL,'127.0.0.1','/','2025-01-05 10:22:36'),(2315,NULL,'127.0.0.1','/','2025-01-05 10:22:36'),(2316,NULL,'127.0.0.1','/','2025-01-05 10:22:37'),(2317,NULL,'127.0.0.1','/','2025-01-05 10:22:37'),(2318,NULL,'127.0.0.1','/','2025-01-05 10:22:37'),(2319,NULL,'127.0.0.1','/','2025-01-05 10:22:37'),(2320,NULL,'127.0.0.1','/','2025-01-05 10:22:38'),(2321,NULL,'127.0.0.1','/','2025-01-05 10:22:38'),(2322,NULL,'127.0.0.1','/','2025-01-05 10:22:38'),(2323,NULL,'127.0.0.1','/','2025-01-05 10:22:38'),(2324,NULL,'127.0.0.1','/','2025-01-05 10:22:39'),(2325,NULL,'127.0.0.1','/','2025-01-05 10:22:39'),(2326,NULL,'127.0.0.1','/','2025-01-05 10:22:39'),(2327,NULL,'127.0.0.1','/','2025-01-05 10:22:39'),(2328,NULL,'127.0.0.1','/','2025-01-05 10:22:40'),(2329,NULL,'127.0.0.1','/','2025-01-05 10:22:40'),(2330,NULL,'127.0.0.1','/','2025-01-05 10:22:40'),(2331,NULL,'127.0.0.1','/','2025-01-05 10:22:40'),(2332,NULL,'127.0.0.1','/','2025-01-05 10:22:41'),(2333,NULL,'127.0.0.1','/','2025-01-05 10:22:41'),(2334,NULL,'127.0.0.1','/','2025-01-05 10:22:41'),(2335,NULL,'127.0.0.1','/','2025-01-05 10:22:41'),(2336,NULL,'127.0.0.1','/','2025-01-05 10:22:41'),(2337,NULL,'127.0.0.1','/','2025-01-05 10:22:42'),(2338,NULL,'127.0.0.1','/','2025-01-05 10:22:42'),(2339,NULL,'127.0.0.1','/','2025-01-05 10:22:42'),(2340,NULL,'127.0.0.1','/','2025-01-05 10:22:42'),(2341,NULL,'127.0.0.1','/','2025-01-05 10:22:43'),(2342,NULL,'127.0.0.1','/','2025-01-05 10:22:43'),(2343,NULL,'127.0.0.1','/','2025-01-05 10:22:43'),(2344,NULL,'127.0.0.1','/','2025-01-05 10:22:43'),(2345,NULL,'127.0.0.1','/','2025-01-05 10:22:44'),(2346,NULL,'127.0.0.1','/','2025-01-05 10:22:44'),(2347,NULL,'127.0.0.1','/','2025-01-05 10:22:44'),(2348,NULL,'127.0.0.1','/','2025-01-05 10:22:44'),(2349,NULL,'127.0.0.1','/','2025-01-05 10:22:45'),(2350,NULL,'127.0.0.1','/','2025-01-05 10:22:45'),(2351,NULL,'127.0.0.1','/','2025-01-05 10:22:45'),(2352,NULL,'127.0.0.1','/','2025-01-05 10:22:45'),(2353,NULL,'127.0.0.1','/','2025-01-05 10:22:46'),(2354,NULL,'127.0.0.1','/','2025-01-05 10:22:46'),(2355,NULL,'127.0.0.1','/','2025-01-05 10:22:46'),(2356,NULL,'127.0.0.1','/','2025-01-05 10:22:46'),(2357,NULL,'127.0.0.1','/','2025-01-05 10:22:46'),(2358,NULL,'127.0.0.1','/','2025-01-05 10:22:47'),(2359,NULL,'127.0.0.1','/','2025-01-05 10:22:47'),(2360,NULL,'127.0.0.1','/','2025-01-05 10:22:47'),(2361,NULL,'127.0.0.1','/','2025-01-05 10:22:47'),(2362,2,'127.0.0.1','/','2025-01-05 10:32:21'),(2363,2,'127.0.0.1','/cities','2025-01-05 10:32:22'),(2364,NULL,'127.0.0.1','/','2025-01-05 10:32:31'),(2365,NULL,'127.0.0.1','/','2025-01-05 10:32:31'),(2366,NULL,'127.0.0.1','/','2025-01-05 10:32:31'),(2367,NULL,'127.0.0.1','/','2025-01-05 10:32:32'),(2368,NULL,'127.0.0.1','/','2025-01-05 10:32:32'),(2369,NULL,'127.0.0.1','/','2025-01-05 10:32:32'),(2370,NULL,'127.0.0.1','/','2025-01-05 10:32:32'),(2371,NULL,'127.0.0.1','/','2025-01-05 10:32:33'),(2372,NULL,'127.0.0.1','/','2025-01-05 10:32:33'),(2373,NULL,'127.0.0.1','/','2025-01-05 10:32:33'),(2374,NULL,'127.0.0.1','/','2025-01-05 10:32:33'),(2375,NULL,'127.0.0.1','/','2025-01-05 10:32:33'),(2376,NULL,'127.0.0.1','/','2025-01-05 10:32:34'),(2377,NULL,'127.0.0.1','/','2025-01-05 10:32:34'),(2378,NULL,'127.0.0.1','/','2025-01-05 10:32:34'),(2379,NULL,'127.0.0.1','/','2025-01-05 10:32:34'),(2380,NULL,'127.0.0.1','/','2025-01-05 10:32:35'),(2381,NULL,'127.0.0.1','/','2025-01-05 10:32:35'),(2382,NULL,'127.0.0.1','/','2025-01-05 10:32:35'),(2383,NULL,'127.0.0.1','/','2025-01-05 10:32:35'),(2384,NULL,'127.0.0.1','/','2025-01-05 10:32:36'),(2385,NULL,'127.0.0.1','/','2025-01-05 10:32:36'),(2386,NULL,'127.0.0.1','/','2025-01-05 10:32:36'),(2387,NULL,'127.0.0.1','/','2025-01-05 10:32:36'),(2388,NULL,'127.0.0.1','/','2025-01-05 10:32:37'),(2389,NULL,'127.0.0.1','/','2025-01-05 10:32:37'),(2390,NULL,'127.0.0.1','/','2025-01-05 10:32:37'),(2391,NULL,'127.0.0.1','/','2025-01-05 10:32:37'),(2392,NULL,'127.0.0.1','/','2025-01-05 10:32:37'),(2393,NULL,'127.0.0.1','/','2025-01-05 10:32:38'),(2394,NULL,'127.0.0.1','/','2025-01-05 10:32:38'),(2395,NULL,'127.0.0.1','/','2025-01-05 10:32:38'),(2396,NULL,'127.0.0.1','/','2025-01-05 10:32:38'),(2397,NULL,'127.0.0.1','/','2025-01-05 10:32:39'),(2398,NULL,'127.0.0.1','/','2025-01-05 10:32:39'),(2399,NULL,'127.0.0.1','/','2025-01-05 10:32:39'),(2400,NULL,'127.0.0.1','/','2025-01-05 10:32:39'),(2401,NULL,'127.0.0.1','/','2025-01-05 10:32:40'),(2402,NULL,'127.0.0.1','/','2025-01-05 10:32:40'),(2403,NULL,'127.0.0.1','/','2025-01-05 10:32:40'),(2404,NULL,'127.0.0.1','/','2025-01-05 10:32:40'),(2405,NULL,'127.0.0.1','/','2025-01-05 10:32:41'),(2406,NULL,'127.0.0.1','/','2025-01-05 10:32:41'),(2407,NULL,'127.0.0.1','/','2025-01-05 10:32:41'),(2408,NULL,'127.0.0.1','/','2025-01-05 10:32:41'),(2409,NULL,'127.0.0.1','/','2025-01-05 10:32:42'),(2410,NULL,'127.0.0.1','/','2025-01-05 10:32:42'),(2411,NULL,'127.0.0.1','/','2025-01-05 10:32:42'),(2412,NULL,'127.0.0.1','/','2025-01-05 10:32:42'),(2413,2,'127.0.0.1','/eligibility-check','2025-01-05 10:37:04'),(2414,2,'127.0.0.1','/get-new-vehicle-info','2025-01-05 10:37:31'),(2415,2,'127.0.0.1','/get-new-vehicle-info','2025-01-05 10:38:20'),(2416,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:40:29'),(2417,NULL,'127.0.0.1','/login','2025-01-05 10:40:29'),(2418,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:40:29'),(2419,NULL,'127.0.0.1','/login','2025-01-05 10:40:29'),(2420,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:40:29'),(2421,NULL,'127.0.0.1','/login','2025-01-05 10:40:29'),(2422,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:40:30'),(2423,NULL,'127.0.0.1','/login','2025-01-05 10:40:30'),(2424,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:40:30'),(2425,NULL,'127.0.0.1','/login','2025-01-05 10:40:30'),(2426,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:40:30'),(2427,NULL,'127.0.0.1','/login','2025-01-05 10:40:30'),(2428,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:40:30'),(2429,NULL,'127.0.0.1','/login','2025-01-05 10:40:30'),(2430,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:40:30'),(2431,NULL,'127.0.0.1','/login','2025-01-05 10:40:31'),(2432,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:40:31'),(2433,NULL,'127.0.0.1','/login','2025-01-05 10:40:31'),(2434,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:40:31'),(2435,NULL,'127.0.0.1','/login','2025-01-05 10:40:31'),(2436,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:40:31'),(2437,NULL,'127.0.0.1','/login','2025-01-05 10:40:31'),(2438,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:40:31'),(2439,NULL,'127.0.0.1','/login','2025-01-05 10:40:31'),(2440,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:40:32'),(2441,NULL,'127.0.0.1','/login','2025-01-05 10:40:32'),(2442,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:40:32'),(2443,NULL,'127.0.0.1','/login','2025-01-05 10:40:32'),(2444,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:40:32'),(2445,NULL,'127.0.0.1','/login','2025-01-05 10:40:32'),(2446,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:40:32'),(2447,NULL,'127.0.0.1','/login','2025-01-05 10:40:32'),(2448,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:40:33'),(2449,NULL,'127.0.0.1','/login','2025-01-05 10:40:33'),(2450,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:40:33'),(2451,NULL,'127.0.0.1','/login','2025-01-05 10:40:33'),(2452,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:40:33'),(2453,NULL,'127.0.0.1','/login','2025-01-05 10:40:33'),(2454,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:40:33'),(2455,NULL,'127.0.0.1','/login','2025-01-05 10:40:33'),(2456,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:40:34'),(2457,NULL,'127.0.0.1','/login','2025-01-05 10:40:34'),(2458,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:40:34'),(2459,NULL,'127.0.0.1','/login','2025-01-05 10:40:34'),(2460,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:40:34'),(2461,NULL,'127.0.0.1','/login','2025-01-05 10:40:34'),(2462,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:40:34'),(2463,NULL,'127.0.0.1','/login','2025-01-05 10:40:34'),(2464,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:40:35'),(2465,NULL,'127.0.0.1','/login','2025-01-05 10:40:35'),(2466,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:40:35'),(2467,2,'127.0.0.1','/','2025-01-05 10:43:28'),(2468,2,'127.0.0.1','/cities','2025-01-05 10:43:30'),(2469,2,'127.0.0.1','/eligibility-check','2025-01-05 10:43:31'),(2470,2,'127.0.0.1','/get-new-vehicle-info','2025-01-05 10:43:53'),(2471,2,'127.0.0.1','/get-new-vehicle-info','2025-01-05 10:47:12'),(2472,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:32'),(2473,NULL,'127.0.0.1','/login','2025-01-05 10:47:32'),(2474,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:32'),(2475,NULL,'127.0.0.1','/login','2025-01-05 10:47:32'),(2476,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:32'),(2477,NULL,'127.0.0.1','/login','2025-01-05 10:47:32'),(2478,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:32'),(2479,NULL,'127.0.0.1','/login','2025-01-05 10:47:32'),(2480,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:33'),(2481,NULL,'127.0.0.1','/login','2025-01-05 10:47:33'),(2482,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:33'),(2483,NULL,'127.0.0.1','/login','2025-01-05 10:47:33'),(2484,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:33'),(2485,NULL,'127.0.0.1','/login','2025-01-05 10:47:33'),(2486,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:33'),(2487,NULL,'127.0.0.1','/login','2025-01-05 10:47:33'),(2488,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:33'),(2489,NULL,'127.0.0.1','/login','2025-01-05 10:47:33'),(2490,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:34'),(2491,NULL,'127.0.0.1','/login','2025-01-05 10:47:34'),(2492,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:34'),(2493,NULL,'127.0.0.1','/login','2025-01-05 10:47:34'),(2494,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:34'),(2495,NULL,'127.0.0.1','/login','2025-01-05 10:47:34'),(2496,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:34'),(2497,NULL,'127.0.0.1','/login','2025-01-05 10:47:34'),(2498,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:34'),(2499,NULL,'127.0.0.1','/login','2025-01-05 10:47:35'),(2500,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:35'),(2501,NULL,'127.0.0.1','/login','2025-01-05 10:47:35'),(2502,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:35'),(2503,NULL,'127.0.0.1','/login','2025-01-05 10:47:35'),(2504,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:35'),(2505,NULL,'127.0.0.1','/login','2025-01-05 10:47:35'),(2506,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:35'),(2507,NULL,'127.0.0.1','/login','2025-01-05 10:47:35'),(2508,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:36'),(2509,NULL,'127.0.0.1','/login','2025-01-05 10:47:36'),(2510,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:36'),(2511,NULL,'127.0.0.1','/login','2025-01-05 10:47:36'),(2512,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:36'),(2513,NULL,'127.0.0.1','/login','2025-01-05 10:47:36'),(2514,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:36'),(2515,NULL,'127.0.0.1','/login','2025-01-05 10:47:36'),(2516,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:36'),(2517,NULL,'127.0.0.1','/login','2025-01-05 10:47:36'),(2518,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:37'),(2519,NULL,'127.0.0.1','/login','2025-01-05 10:47:37'),(2520,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:37'),(2521,NULL,'127.0.0.1','/login','2025-01-05 10:47:37'),(2522,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:37'),(2523,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:37'),(2524,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:38'),(2525,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:38'),(2526,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:38'),(2527,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:38'),(2528,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:38'),(2529,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:39'),(2530,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:39'),(2531,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:39'),(2532,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:39'),(2533,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:40'),(2534,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:40'),(2535,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:40'),(2536,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:40'),(2537,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:40'),(2538,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:41'),(2539,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:41'),(2540,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:41'),(2541,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:41'),(2542,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:42'),(2543,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:42'),(2544,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:42'),(2545,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:42'),(2546,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:42'),(2547,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:43'),(2548,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:43'),(2549,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:43'),(2550,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:43'),(2551,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:44'),(2552,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:44'),(2553,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:44'),(2554,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:44'),(2555,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:44'),(2556,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:47:45'),(2557,2,'127.0.0.1','/get-new-vehicle-info','2025-01-05 10:48:04'),(2558,2,'127.0.0.1','/get-new-vehicle-info','2025-01-05 10:48:05'),(2559,2,'127.0.0.1','/eligibility-check','2025-01-05 10:48:07'),(2560,2,'127.0.0.1','/eligibility-check','2025-01-05 10:52:59'),(2561,2,'127.0.0.1','/eligibility-check','2025-01-05 10:53:09'),(2562,2,'127.0.0.1','/get-new-vehicle-info','2025-01-05 10:53:14'),(2563,2,'127.0.0.1','/eligibility-check','2025-01-05 10:54:19'),(2564,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:54:43'),(2565,NULL,'127.0.0.1','/login','2025-01-05 10:54:43'),(2566,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:54:43'),(2567,NULL,'127.0.0.1','/login','2025-01-05 10:54:43'),(2568,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:54:44'),(2569,NULL,'127.0.0.1','/login','2025-01-05 10:54:44'),(2570,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:54:44'),(2571,NULL,'127.0.0.1','/login','2025-01-05 10:54:44'),(2572,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:54:44'),(2573,NULL,'127.0.0.1','/login','2025-01-05 10:54:44'),(2574,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:54:44'),(2575,NULL,'127.0.0.1','/login','2025-01-05 10:54:44'),(2576,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:54:45'),(2577,NULL,'127.0.0.1','/login','2025-01-05 10:54:45'),(2578,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:54:45'),(2579,NULL,'127.0.0.1','/login','2025-01-05 10:54:45'),(2580,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:54:45'),(2581,NULL,'127.0.0.1','/login','2025-01-05 10:54:45'),(2582,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:54:45'),(2583,NULL,'127.0.0.1','/login','2025-01-05 10:54:45'),(2584,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:54:45'),(2585,NULL,'127.0.0.1','/login','2025-01-05 10:54:45'),(2586,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:54:46'),(2587,NULL,'127.0.0.1','/login','2025-01-05 10:54:46'),(2588,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:54:46'),(2589,NULL,'127.0.0.1','/login','2025-01-05 10:54:46'),(2590,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:54:46'),(2591,NULL,'127.0.0.1','/login','2025-01-05 10:54:46'),(2592,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:54:46'),(2593,NULL,'127.0.0.1','/login','2025-01-05 10:54:46'),(2594,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:54:47'),(2595,NULL,'127.0.0.1','/login','2025-01-05 10:54:47'),(2596,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:54:47'),(2597,NULL,'127.0.0.1','/login','2025-01-05 10:54:47'),(2598,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:54:47'),(2599,NULL,'127.0.0.1','/login','2025-01-05 10:54:47'),(2600,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:54:47'),(2601,NULL,'127.0.0.1','/login','2025-01-05 10:54:47'),(2602,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:54:47'),(2603,NULL,'127.0.0.1','/login','2025-01-05 10:54:47'),(2604,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:54:48'),(2605,NULL,'127.0.0.1','/login','2025-01-05 10:54:48'),(2606,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:54:48'),(2607,NULL,'127.0.0.1','/login','2025-01-05 10:54:48'),(2608,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:54:48'),(2609,NULL,'127.0.0.1','/login','2025-01-05 10:54:48'),(2610,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:54:48'),(2611,NULL,'127.0.0.1','/login','2025-01-05 10:54:48'),(2612,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:54:49'),(2613,NULL,'127.0.0.1','/login','2025-01-05 10:54:49'),(2614,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:55:31'),(2615,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:55:31'),(2616,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:55:31'),(2617,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:55:31'),(2618,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:55:32'),(2619,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:55:32'),(2620,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:55:32'),(2621,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:55:32'),(2622,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:55:32'),(2623,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:55:33'),(2624,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:55:33'),(2625,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:55:33'),(2626,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:55:33'),(2627,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:55:33'),(2628,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:55:34'),(2629,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:55:34'),(2630,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:55:34'),(2631,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:55:34'),(2632,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:55:35'),(2633,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:55:35'),(2634,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:55:35'),(2635,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:55:35'),(2636,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:55:35'),(2637,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:55:36'),(2638,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:55:36'),(2639,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:55:36'),(2640,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:55:36'),(2641,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:55:36'),(2642,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:55:37'),(2643,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:55:37'),(2644,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:55:37'),(2645,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:55:37'),(2646,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:55:38'),(2647,2,'127.0.0.1','/get-new-vehicle-info','2025-01-05 10:57:18'),(2648,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:57:23'),(2649,NULL,'127.0.0.1','/login','2025-01-05 10:57:23'),(2650,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:57:23'),(2651,NULL,'127.0.0.1','/login','2025-01-05 10:57:23'),(2652,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:57:24'),(2653,NULL,'127.0.0.1','/login','2025-01-05 10:57:24'),(2654,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:57:24'),(2655,NULL,'127.0.0.1','/login','2025-01-05 10:57:24'),(2656,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:57:24'),(2657,NULL,'127.0.0.1','/login','2025-01-05 10:57:24'),(2658,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:57:24'),(2659,NULL,'127.0.0.1','/login','2025-01-05 10:57:24'),(2660,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:57:24'),(2661,NULL,'127.0.0.1','/login','2025-01-05 10:57:24'),(2662,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:57:25'),(2663,NULL,'127.0.0.1','/login','2025-01-05 10:57:25'),(2664,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:57:25'),(2665,NULL,'127.0.0.1','/login','2025-01-05 10:57:25'),(2666,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:57:25'),(2667,NULL,'127.0.0.1','/login','2025-01-05 10:57:25'),(2668,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:57:25'),(2669,NULL,'127.0.0.1','/login','2025-01-05 10:57:25'),(2670,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:57:26'),(2671,NULL,'127.0.0.1','/login','2025-01-05 10:57:26'),(2672,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:57:26'),(2673,NULL,'127.0.0.1','/login','2025-01-05 10:57:26'),(2674,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:57:26'),(2675,NULL,'127.0.0.1','/login','2025-01-05 10:57:26'),(2676,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:57:26'),(2677,NULL,'127.0.0.1','/login','2025-01-05 10:57:26'),(2678,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:57:26'),(2679,NULL,'127.0.0.1','/login','2025-01-05 10:57:26'),(2680,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:57:27'),(2681,NULL,'127.0.0.1','/login','2025-01-05 10:57:27'),(2682,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:57:27'),(2683,NULL,'127.0.0.1','/login','2025-01-05 10:57:27'),(2684,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:57:27'),(2685,NULL,'127.0.0.1','/login','2025-01-05 10:57:27'),(2686,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:57:27'),(2687,NULL,'127.0.0.1','/login','2025-01-05 10:57:27'),(2688,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:57:28'),(2689,NULL,'127.0.0.1','/login','2025-01-05 10:57:28'),(2690,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:57:28'),(2691,NULL,'127.0.0.1','/login','2025-01-05 10:57:28'),(2692,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:57:28'),(2693,NULL,'127.0.0.1','/login','2025-01-05 10:57:28'),(2694,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:57:28'),(2695,NULL,'127.0.0.1','/login','2025-01-05 10:57:28'),(2696,NULL,'127.0.0.1','/eligibility-check','2025-01-05 10:57:28'),(2697,NULL,'127.0.0.1','/login','2025-01-05 10:57:28'),(2698,2,'127.0.0.1','/eligibility-check','2025-01-05 11:00:03'),(2699,2,'127.0.0.1','/eligibility-check','2025-01-05 11:00:05'),(2700,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:00:25'),(2701,NULL,'127.0.0.1','/login','2025-01-05 11:00:25'),(2702,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:00:26'),(2703,NULL,'127.0.0.1','/login','2025-01-05 11:00:26'),(2704,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:00:26'),(2705,NULL,'127.0.0.1','/login','2025-01-05 11:00:26'),(2706,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:00:26'),(2707,NULL,'127.0.0.1','/login','2025-01-05 11:00:26'),(2708,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:00:26'),(2709,NULL,'127.0.0.1','/login','2025-01-05 11:00:26'),(2710,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:00:27'),(2711,NULL,'127.0.0.1','/login','2025-01-05 11:00:27'),(2712,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:00:27'),(2713,NULL,'127.0.0.1','/login','2025-01-05 11:00:27'),(2714,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:00:27'),(2715,NULL,'127.0.0.1','/login','2025-01-05 11:00:27'),(2716,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:00:27'),(2717,NULL,'127.0.0.1','/login','2025-01-05 11:00:27'),(2718,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:00:27'),(2719,NULL,'127.0.0.1','/login','2025-01-05 11:00:27'),(2720,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:00:28'),(2721,NULL,'127.0.0.1','/login','2025-01-05 11:00:28'),(2722,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:00:28'),(2723,NULL,'127.0.0.1','/login','2025-01-05 11:00:28'),(2724,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:00:28'),(2725,NULL,'127.0.0.1','/login','2025-01-05 11:00:28'),(2726,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:00:28'),(2727,NULL,'127.0.0.1','/login','2025-01-05 11:00:28'),(2728,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:00:29'),(2729,NULL,'127.0.0.1','/login','2025-01-05 11:00:29'),(2730,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:00:29'),(2731,NULL,'127.0.0.1','/login','2025-01-05 11:00:29'),(2732,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:00:29'),(2733,NULL,'127.0.0.1','/login','2025-01-05 11:00:29'),(2734,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:00:29'),(2735,NULL,'127.0.0.1','/login','2025-01-05 11:00:29'),(2736,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:00:29'),(2737,NULL,'127.0.0.1','/login','2025-01-05 11:00:29'),(2738,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:00:30'),(2739,NULL,'127.0.0.1','/login','2025-01-05 11:00:30'),(2740,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:00:30'),(2741,NULL,'127.0.0.1','/login','2025-01-05 11:00:30'),(2742,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:00:30'),(2743,NULL,'127.0.0.1','/login','2025-01-05 11:00:30'),(2744,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:00:30'),(2745,NULL,'127.0.0.1','/login','2025-01-05 11:00:30'),(2746,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:00:31'),(2747,NULL,'127.0.0.1','/login','2025-01-05 11:00:31'),(2748,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:00:31'),(2749,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:00:31'),(2750,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:00:31'),(2751,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:00:31'),(2752,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:00:32'),(2753,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:00:32'),(2754,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:00:32'),(2755,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:00:32'),(2756,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:00:32'),(2757,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:00:33'),(2758,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:00:33'),(2759,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:00:33'),(2760,2,'127.0.0.1','/eligibility-check','2025-01-05 11:00:36'),(2761,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:02'),(2762,NULL,'127.0.0.1','/login','2025-01-05 11:02:02'),(2763,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:02'),(2764,NULL,'127.0.0.1','/login','2025-01-05 11:02:02'),(2765,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:02'),(2766,NULL,'127.0.0.1','/login','2025-01-05 11:02:02'),(2767,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:03'),(2768,NULL,'127.0.0.1','/login','2025-01-05 11:02:03'),(2769,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:03'),(2770,NULL,'127.0.0.1','/login','2025-01-05 11:02:03'),(2771,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:03'),(2772,NULL,'127.0.0.1','/login','2025-01-05 11:02:03'),(2773,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:03'),(2774,NULL,'127.0.0.1','/login','2025-01-05 11:02:03'),(2775,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:04'),(2776,NULL,'127.0.0.1','/login','2025-01-05 11:02:04'),(2777,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:04'),(2778,NULL,'127.0.0.1','/login','2025-01-05 11:02:04'),(2779,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:04'),(2780,NULL,'127.0.0.1','/login','2025-01-05 11:02:04'),(2781,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:04'),(2782,NULL,'127.0.0.1','/login','2025-01-05 11:02:04'),(2783,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:04'),(2784,NULL,'127.0.0.1','/login','2025-01-05 11:02:04'),(2785,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:05'),(2786,NULL,'127.0.0.1','/login','2025-01-05 11:02:05'),(2787,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:05'),(2788,NULL,'127.0.0.1','/login','2025-01-05 11:02:05'),(2789,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:05'),(2790,NULL,'127.0.0.1','/login','2025-01-05 11:02:05'),(2791,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:05'),(2792,NULL,'127.0.0.1','/login','2025-01-05 11:02:05'),(2793,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:05'),(2794,NULL,'127.0.0.1','/login','2025-01-05 11:02:06'),(2795,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:06'),(2796,NULL,'127.0.0.1','/login','2025-01-05 11:02:06'),(2797,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:06'),(2798,NULL,'127.0.0.1','/login','2025-01-05 11:02:06'),(2799,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:06'),(2800,NULL,'127.0.0.1','/login','2025-01-05 11:02:06'),(2801,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:06'),(2802,NULL,'127.0.0.1','/login','2025-01-05 11:02:06'),(2803,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:07'),(2804,NULL,'127.0.0.1','/login','2025-01-05 11:02:07'),(2805,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:07'),(2806,NULL,'127.0.0.1','/login','2025-01-05 11:02:07'),(2807,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:07'),(2808,NULL,'127.0.0.1','/login','2025-01-05 11:02:07'),(2809,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:07'),(2810,NULL,'127.0.0.1','/login','2025-01-05 11:02:07'),(2811,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:07'),(2812,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:08'),(2813,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:08'),(2814,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:08'),(2815,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:08'),(2816,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:09'),(2817,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:20'),(2818,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:20'),(2819,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:20'),(2820,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:20'),(2821,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:20'),(2822,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:21'),(2823,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:21'),(2824,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:21'),(2825,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:21'),(2826,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:22'),(2827,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:22'),(2828,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:22'),(2829,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:22'),(2830,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:22'),(2831,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:23'),(2832,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:23'),(2833,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:23'),(2834,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:23'),(2835,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:24'),(2836,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:24'),(2837,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:24'),(2838,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:24'),(2839,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:24'),(2840,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:25'),(2841,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:25'),(2842,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:25'),(2843,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:26'),(2844,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:26'),(2845,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:27'),(2846,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:27'),(2847,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:27'),(2848,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:27'),(2849,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:28'),(2850,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:28'),(2851,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:29'),(2852,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:29'),(2853,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:29'),(2854,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:30'),(2855,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:30'),(2856,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:31'),(2857,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:31'),(2858,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:31'),(2859,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:31'),(2860,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:32'),(2861,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:32'),(2862,NULL,'127.0.0.1','/eligibility-check','2025-01-05 11:02:32'),(2863,2,'127.0.0.1','/','2025-03-03 14:45:01'),(2864,2,'127.0.0.1','/cities','2025-03-03 14:45:03'),(2865,2,'127.0.0.1','/maps','2025-03-03 14:45:05'),(2866,2,'127.0.0.1','/maps','2025-03-03 14:45:22'),(2867,2,'127.0.0.1','/','2025-03-03 14:45:27'),(2868,2,'127.0.0.1','/cities','2025-03-03 14:45:28'),(2869,NULL,'127.0.0.1','/','2025-03-06 16:12:14'),(2870,NULL,'127.0.0.1','/cities','2025-03-06 16:12:14'),(2871,NULL,'127.0.0.1','/login','2025-03-06 16:12:23'),(2872,NULL,'127.0.0.1','/login','2025-03-06 16:12:24'),(2873,2,'127.0.0.1','/my-profile','2025-03-06 16:12:24'),(2874,2,'127.0.0.1','/new-car','2025-03-06 16:12:50'),(2875,2,'127.0.0.1','/new-car','2025-03-06 16:13:04'),(2876,2,'127.0.0.1','/delete/26','2025-03-06 16:13:44'),(2877,2,'127.0.0.1','/my-profile','2025-03-06 16:13:44'),(2878,2,'127.0.0.1','/delete/24','2025-03-06 16:14:04'),(2879,2,'127.0.0.1','/my-profile','2025-03-06 16:14:04'),(2880,2,'127.0.0.1','/delete/25','2025-03-06 16:14:06'),(2881,2,'127.0.0.1','/my-profile','2025-03-06 16:14:06'),(2882,2,'127.0.0.1','/delete/20','2025-03-06 16:14:09'),(2883,2,'127.0.0.1','/my-profile','2025-03-06 16:14:09'),(2884,2,'127.0.0.1','/maps','2025-03-06 16:14:31'),(2885,2,'127.0.0.1','/maps','2025-03-06 16:14:37'),(2886,2,'127.0.0.1','/maps','2025-03-06 16:14:41'),(2887,2,'127.0.0.1','/maps','2025-03-06 16:14:44'),(2888,2,'127.0.0.1','/maps','2025-03-06 16:14:44'),(2889,2,'127.0.0.1','/eligibility-check','2025-03-06 16:15:05'),(2890,2,'127.0.0.1','/get-vehicle-info/19','2025-03-06 16:15:10'),(2891,2,'127.0.0.1','/get-vehicle-info/19','2025-03-06 16:15:16'),(2892,2,'127.0.0.1','/maps','2025-03-06 16:15:32'),(2893,2,'127.0.0.1','/maps','2025-03-06 16:15:37'),(2894,NULL,'127.0.0.1','/maps','2025-03-06 16:22:31'),(2895,NULL,'127.0.0.1','/login','2025-03-06 16:22:31'),(2896,NULL,'127.0.0.1','/login','2025-03-06 16:22:36'),(2897,2,'127.0.0.1','/my-profile','2025-03-06 16:22:36'),(2898,2,'127.0.0.1','/maps','2025-03-06 16:22:39'),(2899,2,'127.0.0.1','/my-profile','2025-03-06 16:22:42'),(2900,2,'127.0.0.1','/maps','2025-03-06 16:22:43'),(2901,2,'127.0.0.1','/maps','2025-03-06 16:22:53'),(2902,NULL,'127.0.0.1','/','2025-03-07 16:33:31'),(2903,NULL,'127.0.0.1','/cities','2025-03-07 16:33:33'),(2904,NULL,'127.0.0.1','/','2025-03-07 18:40:59'),(2905,NULL,'127.0.0.1','/cities','2025-03-07 18:41:00'),(2906,NULL,'172.17.0.1','/','2025-03-11 08:17:16'),(2907,NULL,'172.17.0.1','/cities','2025-03-11 08:17:17'),(2908,NULL,'172.17.0.1','/info/spain','2025-03-11 08:17:28'),(2909,NULL,'172.17.0.1','/','2025-03-11 08:17:33'),(2910,NULL,'172.17.0.1','/cities','2025-03-11 08:17:34'),(2911,NULL,'172.17.0.1','/login','2025-03-11 08:17:34'),(2912,NULL,'172.17.0.1','/login','2025-03-11 08:17:35'),(2913,2,'172.17.0.1','/my-profile','2025-03-11 08:17:35'),(2914,2,'172.17.0.1','/delete_route/9','2025-03-11 08:17:42'),(2915,2,'172.17.0.1','/delete_route/18','2025-03-11 08:17:43'),(2916,2,'172.17.0.1','/delete_route/27','2025-03-11 08:17:45'),(2917,2,'172.17.0.1','/delete_route/36','2025-03-11 08:17:47'),(2918,2,'172.17.0.1','/delete_route/45','2025-03-11 08:17:49'),(2919,2,'172.17.0.1','/delete_route/54','2025-03-11 08:17:50'),(2920,2,'172.17.0.1','/delete_route/63','2025-03-11 08:17:51'),(2921,2,'172.17.0.1','/delete_route/72','2025-03-11 08:17:52'),(2922,2,'172.17.0.1','/edit/19','2025-03-11 08:17:54'),(2923,2,'172.17.0.1','/new-car','2025-03-11 08:18:16'),(2924,2,'172.17.0.1','/new-car','2025-03-11 08:18:34'),(2925,2,'172.17.0.1','/','2025-03-11 08:19:26'),(2926,2,'172.17.0.1','/cities','2025-03-11 08:19:27'),(2927,2,'172.17.0.1','/maps','2025-03-11 08:19:40'),(2928,2,'172.17.0.1','/maps','2025-03-11 08:19:49'),(2929,2,'172.17.0.1','/','2025-03-11 08:21:47'),(2930,2,'172.17.0.1','/cities','2025-03-11 08:21:48'),(2931,NULL,'172.17.0.1','/maps','2025-03-11 08:52:06'),(2932,NULL,'172.17.0.1','/login','2025-03-11 08:52:06'),(2933,NULL,'172.17.0.1','/login','2025-03-11 08:52:08'),(2934,2,'172.17.0.1','/my-profile','2025-03-11 08:52:08'),(2935,2,'172.17.0.1','/maps','2025-03-11 08:52:10'),(2936,2,'172.17.0.1','/maps','2025-03-11 08:52:15'),(2937,NULL,'172.17.0.1','/','2025-03-12 09:34:59'),(2938,NULL,'172.17.0.1','/cities','2025-03-12 09:35:01'),(2939,NULL,'172.17.0.1','/','2025-03-12 09:52:31'),(2940,NULL,'172.17.0.1','/cities','2025-03-12 09:52:32'),(2941,NULL,'172.17.0.1','/','2025-03-12 09:52:32'),(2942,NULL,'172.17.0.1','/cities','2025-03-12 09:52:33'),(2943,NULL,'172.17.0.1','/','2025-03-12 12:07:06'),(2944,NULL,'172.17.0.1','/cities','2025-03-12 12:07:07'),(2945,NULL,'172.17.0.1','/sign-up','2025-03-12 12:07:13'),(2946,NULL,'172.17.0.1','/sign-up','2025-03-12 12:07:33'),(2947,10,'172.17.0.1','/my-profile','2025-03-12 12:07:33'),(2948,NULL,'127.0.0.1','/login','2025-03-12 16:30:29'),(2949,10,'127.0.0.1','/my-profile','2025-03-12 16:30:29'),(2950,NULL,'127.0.0.1','/login','2025-03-12 16:30:33'),(2951,10,'127.0.0.1','/my-profile','2025-03-12 16:30:33'),(2952,NULL,'127.0.0.1','/login','2025-03-17 08:30:43'),(2953,10,'127.0.0.1','/my-profile','2025-03-17 08:30:44'),(2954,NULL,'127.0.0.1','/login','2025-03-17 08:33:30'),(2955,10,'127.0.0.1','/my-profile','2025-03-17 08:33:30');
/*!40000 ALTER TABLE `requests_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `saved_routes`
--

DROP TABLE IF EXISTS `saved_routes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `saved_routes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `owner_id` int DEFAULT NULL,
  `destinations_json` text,
  `destinations_text` text,
  PRIMARY KEY (`id`),
  KEY `owner_id` (`owner_id`),
  CONSTRAINT `saved_routes_ibfk_1` FOREIGN KEY (`owner_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `saved_routes`
--

LOCK TABLES `saved_routes` WRITE;
/*!40000 ALTER TABLE `saved_routes` DISABLE KEYS */;
INSERT INTO `saved_routes` VALUES (1,4,'[\"Paris, France\",\"Berlin, Germany\",\"Facultatea de Automatică și Calculatoare din Iași, Bulevardul Profesor Dr. doc. Dimitrie Mangeron, Iași, Romania\"]',NULL),(2,4,'[]',NULL),(3,6,'[\"Paris, France\",\"Berlin, Germany\",\"Bucharest, Romania\"]',NULL),(4,6,'[\"Paris, France\",\"Berlin, Germany\",\"London, UK\",\"București, Romania\"]',NULL),(5,4,'[\"Paris, France\",\"Sofia, Bulgaria\",\"Rome, Metropolitan City of Rome Capital, Italy\",\"Sofia, Bulgaria\"]',NULL),(6,6,'[\"Paris, France\",\"Berlin, Germany\",\"London, UK\",\"București, Romania\",\"Budapest, Hungary\"]',NULL),(7,6,'[\"Paris, France\",\"Berlin, Germany\",\"London, UK\",\"București, Romania\",\"Budapest, Hungary\",\"Sofia, Bulgaria\"]',NULL),(8,9,'[\"Milan, Italy\",\"Marseille, France\",\"Vienna, Austria\"]','Milan, Italy -> Marseille, France -> Vienna, Austria'),(10,4,'[\"Paris, France\",\"Berlin, Germany\",\"Facultatea de Automatică și Calculatoare din Iași, Bulevardul Profesor Dr. doc. Dimitrie Mangeron, Iași, Romania\"]',NULL),(11,4,'[]',NULL),(12,6,'[\"Paris, France\",\"Berlin, Germany\",\"Bucharest, Romania\"]',NULL),(13,6,'[\"Paris, France\",\"Berlin, Germany\",\"London, UK\",\"București, Romania\"]',NULL),(14,4,'[\"Paris, France\",\"Sofia, Bulgaria\",\"Rome, Metropolitan City of Rome Capital, Italy\",\"Sofia, Bulgaria\"]',NULL),(15,6,'[\"Paris, France\",\"Berlin, Germany\",\"London, UK\",\"București, Romania\",\"Budapest, Hungary\"]',NULL),(16,6,'[\"Paris, France\",\"Berlin, Germany\",\"London, UK\",\"București, Romania\",\"Budapest, Hungary\",\"Sofia, Bulgaria\"]',NULL),(17,9,'[\"Milan, Italy\",\"Marseille, France\",\"Vienna, Austria\"]','Milan, Italy -> Marseille, France -> Vienna, Austria'),(19,4,'[\"Paris, France\",\"Berlin, Germany\",\"Facultatea de Automatică și Calculatoare din Iași, Bulevardul Profesor Dr. doc. Dimitrie Mangeron, Iași, Romania\"]',NULL),(20,4,'[]',NULL),(21,6,'[\"Paris, France\",\"Berlin, Germany\",\"Bucharest, Romania\"]',NULL),(22,6,'[\"Paris, France\",\"Berlin, Germany\",\"London, UK\",\"București, Romania\"]',NULL),(23,4,'[\"Paris, France\",\"Sofia, Bulgaria\",\"Rome, Metropolitan City of Rome Capital, Italy\",\"Sofia, Bulgaria\"]',NULL),(24,6,'[\"Paris, France\",\"Berlin, Germany\",\"London, UK\",\"București, Romania\",\"Budapest, Hungary\"]',NULL),(25,6,'[\"Paris, France\",\"Berlin, Germany\",\"London, UK\",\"București, Romania\",\"Budapest, Hungary\",\"Sofia, Bulgaria\"]',NULL),(26,9,'[\"Milan, Italy\",\"Marseille, France\",\"Vienna, Austria\"]','Milan, Italy -> Marseille, France -> Vienna, Austria'),(28,4,'[\"Paris, France\",\"Berlin, Germany\",\"Facultatea de Automatică și Calculatoare din Iași, Bulevardul Profesor Dr. doc. Dimitrie Mangeron, Iași, Romania\"]',NULL),(29,4,'[]',NULL),(30,6,'[\"Paris, France\",\"Berlin, Germany\",\"Bucharest, Romania\"]',NULL),(31,6,'[\"Paris, France\",\"Berlin, Germany\",\"London, UK\",\"București, Romania\"]',NULL),(32,4,'[\"Paris, France\",\"Sofia, Bulgaria\",\"Rome, Metropolitan City of Rome Capital, Italy\",\"Sofia, Bulgaria\"]',NULL),(33,6,'[\"Paris, France\",\"Berlin, Germany\",\"London, UK\",\"București, Romania\",\"Budapest, Hungary\"]',NULL),(34,6,'[\"Paris, France\",\"Berlin, Germany\",\"London, UK\",\"București, Romania\",\"Budapest, Hungary\",\"Sofia, Bulgaria\"]',NULL),(35,9,'[\"Milan, Italy\",\"Marseille, France\",\"Vienna, Austria\"]','Milan, Italy -> Marseille, France -> Vienna, Austria'),(37,4,'[\"Paris, France\",\"Berlin, Germany\",\"Facultatea de Automatică și Calculatoare din Iași, Bulevardul Profesor Dr. doc. Dimitrie Mangeron, Iași, Romania\"]',NULL),(38,4,'[]',NULL),(39,6,'[\"Paris, France\",\"Berlin, Germany\",\"Bucharest, Romania\"]',NULL),(40,6,'[\"Paris, France\",\"Berlin, Germany\",\"London, UK\",\"București, Romania\"]',NULL),(41,4,'[\"Paris, France\",\"Sofia, Bulgaria\",\"Rome, Metropolitan City of Rome Capital, Italy\",\"Sofia, Bulgaria\"]',NULL),(42,6,'[\"Paris, France\",\"Berlin, Germany\",\"London, UK\",\"București, Romania\",\"Budapest, Hungary\"]',NULL),(43,6,'[\"Paris, France\",\"Berlin, Germany\",\"London, UK\",\"București, Romania\",\"Budapest, Hungary\",\"Sofia, Bulgaria\"]',NULL),(44,9,'[\"Milan, Italy\",\"Marseille, France\",\"Vienna, Austria\"]','Milan, Italy -> Marseille, France -> Vienna, Austria'),(46,4,'[\"Paris, France\",\"Berlin, Germany\",\"Facultatea de Automatică și Calculatoare din Iași, Bulevardul Profesor Dr. doc. Dimitrie Mangeron, Iași, Romania\"]',NULL),(47,4,'[]',NULL),(48,6,'[\"Paris, France\",\"Berlin, Germany\",\"Bucharest, Romania\"]',NULL),(49,6,'[\"Paris, France\",\"Berlin, Germany\",\"London, UK\",\"București, Romania\"]',NULL),(50,4,'[\"Paris, France\",\"Sofia, Bulgaria\",\"Rome, Metropolitan City of Rome Capital, Italy\",\"Sofia, Bulgaria\"]',NULL),(51,6,'[\"Paris, France\",\"Berlin, Germany\",\"London, UK\",\"București, Romania\",\"Budapest, Hungary\"]',NULL),(52,6,'[\"Paris, France\",\"Berlin, Germany\",\"London, UK\",\"București, Romania\",\"Budapest, Hungary\",\"Sofia, Bulgaria\"]',NULL),(53,9,'[\"Milan, Italy\",\"Marseille, France\",\"Vienna, Austria\"]','Milan, Italy -> Marseille, France -> Vienna, Austria'),(55,4,'[\"Paris, France\",\"Berlin, Germany\",\"Facultatea de Automatică și Calculatoare din Iași, Bulevardul Profesor Dr. doc. Dimitrie Mangeron, Iași, Romania\"]',NULL),(56,4,'[]',NULL),(57,6,'[\"Paris, France\",\"Berlin, Germany\",\"Bucharest, Romania\"]',NULL),(58,6,'[\"Paris, France\",\"Berlin, Germany\",\"London, UK\",\"București, Romania\"]',NULL),(59,4,'[\"Paris, France\",\"Sofia, Bulgaria\",\"Rome, Metropolitan City of Rome Capital, Italy\",\"Sofia, Bulgaria\"]',NULL),(60,6,'[\"Paris, France\",\"Berlin, Germany\",\"London, UK\",\"București, Romania\",\"Budapest, Hungary\"]',NULL),(61,6,'[\"Paris, France\",\"Berlin, Germany\",\"London, UK\",\"București, Romania\",\"Budapest, Hungary\",\"Sofia, Bulgaria\"]',NULL),(62,9,'[\"Milan, Italy\",\"Marseille, France\",\"Vienna, Austria\"]','Milan, Italy -> Marseille, France -> Vienna, Austria'),(64,4,'[\"Paris, France\",\"Berlin, Germany\",\"Facultatea de Automatică și Calculatoare din Iași, Bulevardul Profesor Dr. doc. Dimitrie Mangeron, Iași, Romania\"]',NULL),(65,4,'[]',NULL),(66,6,'[\"Paris, France\",\"Berlin, Germany\",\"Bucharest, Romania\"]',NULL),(67,6,'[\"Paris, France\",\"Berlin, Germany\",\"London, UK\",\"București, Romania\"]',NULL),(68,4,'[\"Paris, France\",\"Sofia, Bulgaria\",\"Rome, Metropolitan City of Rome Capital, Italy\",\"Sofia, Bulgaria\"]',NULL),(69,6,'[\"Paris, France\",\"Berlin, Germany\",\"London, UK\",\"București, Romania\",\"Budapest, Hungary\"]',NULL),(70,6,'[\"Paris, France\",\"Berlin, Germany\",\"London, UK\",\"București, Romania\",\"Budapest, Hungary\",\"Sofia, Bulgaria\"]',NULL),(71,9,'[\"Milan, Italy\",\"Marseille, France\",\"Vienna, Austria\"]','Milan, Italy -> Marseille, France -> Vienna, Austria'),(73,4,'[\"Paris, France\",\"Berlin, Germany\",\"Facultatea de Automatică și Calculatoare din Iași, Bulevardul Profesor Dr. doc. Dimitrie Mangeron, Iași, Romania\"]',NULL),(74,4,'[]',NULL),(75,6,'[\"Paris, France\",\"Berlin, Germany\",\"Bucharest, Romania\"]',NULL),(76,6,'[\"Paris, France\",\"Berlin, Germany\",\"London, UK\",\"București, Romania\"]',NULL),(77,4,'[\"Paris, France\",\"Sofia, Bulgaria\",\"Rome, Metropolitan City of Rome Capital, Italy\",\"Sofia, Bulgaria\"]',NULL),(78,6,'[\"Paris, France\",\"Berlin, Germany\",\"London, UK\",\"București, Romania\",\"Budapest, Hungary\"]',NULL),(79,6,'[\"Paris, France\",\"Berlin, Germany\",\"London, UK\",\"București, Romania\",\"Budapest, Hungary\",\"Sofia, Bulgaria\"]',NULL),(80,9,'[\"Milan, Italy\",\"Marseille, France\",\"Vienna, Austria\"]','Milan, Italy -> Marseille, France -> Vienna, Austria'),(81,2,'[\"Facultatea de Automatică și Calculatoare, Splaiul Independenței, Bucharest, Romania\",\"Berlin, Germany\",\"Tour Eiffel, Avenue Gustave Eiffel, Paris, France\"]','Facultatea de Automatică și Calculatoare, Splaiul Independenței, Bucharest, Romania -> Berlin, Germany -> Tour Eiffel, Avenue Gustave Eiffel, Paris, France');
/*!40000 ALTER TABLE `saved_routes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `spain_registrations`
--

DROP TABLE IF EXISTS `spain_registrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `spain_registrations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `country` varchar(50) DEFAULT NULL,
  `registration_type` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `minimum_diesel` varchar(50) DEFAULT NULL,
  `minimum_petrol` varchar(50) DEFAULT NULL,
  `result` text,
  `description` text,
  `image_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `spain_registrations`
--

LOCK TABLES `spain_registrations` WRITE;
/*!40000 ALTER TABLE `spain_registrations` DISABLE KEYS */;
INSERT INTO `spain_registrations` VALUES (1,'Spain','Sticker','Distintivo Ambiental Cero','-','-','The selected  vehicle is eligible for Distintivo Ambiental Cero.','&emsp;Since January 1, 2023, Spain has implemented new environmental regulations, mandating low-emission zones across several cities. These zones require emissions stickers for all vehicles. The Spanish emissions sticker is exclusively available for vehicles registered in Spain. However, Spanish authorities officially recognize emission stickers issued by other European countries, requiring foreign vehicles to also comply with the LEZ restrictions.\r\n<br>\r\n\r\n    <ul>\r\n        <li><strong>Distintivo Ambiental B:</strong> Petrol: Euro 3. Diesel: Euro 4 and 5.</li>\r\n        <li><strong>Distintivo Ambiental C:</strong> Petrol: Euro 4, 5, and 6. Diesel: Euro 6.</li>\r\n        <li><strong>Distintivo Ambiental ECO:</strong> Hybrid and/or gas vehicles that also meet: Petrol: Euro 4, 5, and 6. Diesel: Euro 6.</li>\r\n        <li><strong>Distintivo Ambiental Cero:</strong> 100% electric, fuel cell, plug-in-hybrid (minimum range 40 km) vehicles.</li>\r\n    </ul>','/static/spain/CERO.png'),(2,'Spain','Sticker','Distintivo Ambiental ECO','6','4','The selected  vehicle is eligible for Distintivo Ambiental ECO','&emsp;Since January 1, 2023, Spain has implemented new environmental regulations, mandating low-emission zones across several cities. These zones require emissions stickers for all vehicles. The Spanish emissions sticker is exclusively available for vehicles registered in Spain. However, Spanish authorities officially recognize emission stickers issued by other European countries, requiring foreign vehicles to also comply with the LEZ restrictions.\r\n<br>\r\n\r\n    <ul>\r\n        <li><strong>Distintivo Ambiental B:</strong> Petrol: Euro 3. Diesel: Euro 4 and 5.</li>\r\n        <li><strong>Distintivo Ambiental C:</strong> Petrol: Euro 4, 5, and 6. Diesel: Euro 6.</li>\r\n        <li><strong>Distintivo Ambiental ECO:</strong> Hybrid and/or gas vehicles that also meet: Petrol: Euro 4, 5, and 6. Diesel: Euro 6.</li>\r\n        <li><strong>Distintivo Ambiental Cero:</strong> 100% electric, fuel cell, plug-in-hybrid (minimum range 40 km) vehicles.</li>\r\n    </ul>','/static/spain/ECO.png'),(3,'Spain','Sticker','Distintivo Ambiental C','6','4','The selected  vehicle is eligible for Distintivo Ambiental C','&emsp;Since January 1, 2023, Spain has implemented new environmental regulations, mandating low-emission zones across several cities. These zones require emissions stickers for all vehicles. The Spanish emissions sticker is exclusively available for vehicles registered in Spain. However, Spanish authorities officially recognize emission stickers issued by other European countries, requiring foreign vehicles to also comply with the LEZ restrictions.\r\n<br>\r\n\r\n    <ul>\r\n        <li><strong>Distintivo Ambiental B:</strong> Petrol: Euro 3. Diesel: Euro 4 and 5.</li>\r\n        <li><strong>Distintivo Ambiental C:</strong> Petrol: Euro 4, 5, and 6. Diesel: Euro 6.</li>\r\n        <li><strong>Distintivo Ambiental ECO:</strong> Hybrid and/or gas vehicles that also meet: Petrol: Euro 4, 5, and 6. Diesel: Euro 6.</li>\r\n        <li><strong>Distintivo Ambiental Cero:</strong> 100% electric, fuel cell, plug-in-hybrid (minimum range 40 km) vehicles.</li>\r\n    </ul>','/static/spain/C.png'),(4,'Spain','Sticker','Distintivo Ambiental B','4','3','The selected  vehicle is eligible for Distintivo Ambiental B.','&emsp;Since January 1, 2023, Spain has implemented new environmental regulations, mandating low-emission zones across several cities. These zones require emissions stickers for all vehicles. The Spanish emissions sticker is exclusively available for vehicles registered in Spain. However, Spanish authorities officially recognize emission stickers issued by other European countries, requiring foreign vehicles to also comply with the LEZ restrictions.\r\n<br>\r\n\r\n    <ul>\r\n        <li><strong>Distintivo Ambiental B:</strong> Petrol: Euro 3. Diesel: Euro 4 and 5.</li>\r\n        <li><strong>Distintivo Ambiental C:</strong> Petrol: Euro 4, 5, and 6. Diesel: Euro 6.</li>\r\n        <li><strong>Distintivo Ambiental ECO:</strong> Hybrid and/or gas vehicles that also meet: Petrol: Euro 4, 5, and 6. Diesel: Euro 6.</li>\r\n        <li><strong>Distintivo Ambiental Cero:</strong> 100% electric, fuel cell, plug-in-hybrid (minimum range 40 km) vehicles.</li>\r\n    </ul>','/static/spain/B.png'),(5,'Spain','Sticker','None','0','0','The selected  vehicle is not eligible for any Distintivo Ambiental sticker.','&emsp;Since January 1, 2023, Spain has implemented new environmental regulations, mandating low-emission zones across several cities. These zones require emissions stickers for all vehicles. The Spanish emissions sticker is exclusively available for vehicles registered in Spain. However, Spanish authorities officially recognize emission stickers issued by other European countries, requiring foreign vehicles to also comply with the LEZ restrictions.\r\n<br>\r\n\r\n    <ul>\r\n        <li><strong>Distintivo Ambiental B:</strong> Petrol: Euro 3. Diesel: Euro 4 and 5.</li>\r\n        <li><strong>Distintivo Ambiental C:</strong> Petrol: Euro 4, 5, and 6. Diesel: Euro 6.</li>\r\n        <li><strong>Distintivo Ambiental ECO:</strong> Hybrid and/or gas vehicles that also meet: Petrol: Euro 4, 5, and 6. Diesel: Euro 6.</li>\r\n        <li><strong>Distintivo Ambiental Cero:</strong> 100% electric, fuel cell, plug-in-hybrid (minimum range 40 km) vehicles.</li>\r\n    </ul>','None');
/*!40000 ALTER TABLE `spain_registrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `unitedkingdom_registrations`
--

DROP TABLE IF EXISTS `unitedkingdom_registrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `unitedkingdom_registrations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `country` varchar(50) DEFAULT NULL,
  `registration_type` varchar(255) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `minimum_diesel` varchar(50) DEFAULT NULL,
  `minimum_petrol` varchar(50) DEFAULT NULL,
  `result` text,
  `description` text,
  `image_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `unitedkingdom_registrations`
--

LOCK TABLES `unitedkingdom_registrations` WRITE;
/*!40000 ALTER TABLE `unitedkingdom_registrations` DISABLE KEYS */;
INSERT INTO `unitedkingdom_registrations` VALUES (7,'United Kingdom','Aberdeen, Birmingham, Bristol, Dundee, Edinburgh, Glasgow, London, Portsmouth, Sheffield, New Castle, Manchester','None','6','4','The selected vehicle is permitted to drive in the UK Low Emission Zones.','&emsp;The United Kingdom features several permanent Low Emission Zones (LEZ) that operate year-round. These zones are established in the following cities: Aberdeen, Birmingham, Bristol, Dundee, Edinburgh, Glasgow, London, Portsmouth, Sheffield, Newcastle, and Manchester. For passenger cars, no formal registration is required, but it is strongly recommended to adhere to the minimum requirements. Failure to meet these requirements may result in a daily fee for LEZ access.','None'),(8,'United Kingdom','','None','0','0','The selected vehicle is not permitted to drive in the UK Low Emission Zones.','&emsp;The United Kingdom features several permanent Low Emission Zones (LEZ) that operate year-round. These zones are established in the following cities: Aberdeen, Birmingham, Bristol, Dundee, Edinburgh, Glasgow, London, Portsmouth, Sheffield, Newcastle, and Manchester. For passenger cars, no formal registration is required, but it is strongly recommended to adhere to the minimum requirements. Failure to meet these requirements may result in a daily fee for LEZ access.','None');
/*!40000 ALTER TABLE `unitedkingdom_registrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(150) DEFAULT NULL,
  `password` varchar(150) DEFAULT NULL,
  `first_name` varchar(150) DEFAULT NULL,
  `is_admin` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (10,'testuser@example.com','sha256$diD5H3x43u8onXEp$6fe5dc6f29ddb302b7963b9fad3e8d13aa093cf55db6d63efef66091b76324c6','test',0);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `zone`
--

DROP TABLE IF EXISTS `zone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `zone` (
  `id` int NOT NULL AUTO_INCREMENT,
  `country` varchar(100) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `registration_class` varchar(50) DEFAULT NULL,
  `minimum_diesel` varchar(15) DEFAULT NULL,
  `minimum_petrol` varchar(15) DEFAULT NULL,
  `fines` varchar(15) DEFAULT NULL,
  `registration_type` text,
  `registration_validity` text,
  `required_registration` text,
  `exception_country` varchar(50) DEFAULT NULL,
  `official_page` longtext,
  `description` longtext,
  `city_alias` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=174 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zone`
--

LOCK TABLES `zone` WRITE;
/*!40000 ALTER TABLE `zone` DISABLE KEYS */;
INSERT INTO `zone` VALUES (1,'BELGIUM','Antwerp/Antwerpen','Registration Antwerp + Ghent','5','2','150-350 €','DIGITAL','UNLIMITED','Antwerp + Ghent','Belgium and Netherlands','https://lez.antwerpen.be/?taal=EN','Antwerp: A vibrant city in Belgium known for its fashion, diamonds, and culture.','None'),(2,'BELGIUM','Brussels','Registration Brussels','5','2','150-350 €','DIGITAL','5 YEARS','Brussels','Belgium and Netherlands','https://www.lez.brussels/mytax/','Brussels: The capital city of Belgium and the de facto capital of the European Union, known for its historic landmarks and international institutions.','Bruxelles'),(3,'BELGIUM','Ghent','Registration Antwerp + Ghent','5','2','150-350 €','DIGITAL','UNLIMITED','Antwerp + Ghent','Belgium and Netherlands','https://lez.antwerpen.be/?taal=EN','Ghent: A historic city in Belgium with a rich medieval past and stunning architecture.','None'),(4,'BULGARIA','Sofia','N/A','6','4','N/A','Eco-Stickers (I and II)','1 YEAR','Eco-Stickers (I and II)','Bulgaria','https://www.bta.bg/en/news/bulgaria/579282-sofia-introduces-low-emission-zone','From 1 December until 28(29) February of each year','None'),(5,'DENMARK','Aalborg','None','5','5','200 €','Random sample control','5 YEARS','Aalborg','Denmark and Norway','https://miljoezoner.dk/en/about-the-low-emission-zones/where-are-the-zones/','Particulate filter required; cars must be registered no later than the day of entering the city.','None'),(6,'DENMARK','Aarhus','None','5','5','200 €','Random sample control','5 YEARS','Aarhus','Denmark and Norway','https://miljoezoner.dk/en/about-the-low-emission-zones/where-are-the-zones/','Particulate filter required; cars must be registered no later than the day of entering the city.','None'),(7,'DENMARK','Copenhagen','None','5','5','200 €','Random sample control','5 YEARS','Copenhagen','Denmark and Norway','https://miljoezoner.dk/en/about-the-low-emission-zones/where-are-the-zones/','Particulate filter required; cars must be registered no later than the day of entering the city.','None'),(8,'DENMARK','Odense','None','5','5','200 €','Random sample control','5 YEARS','Odense','Denmark and Norway','https://miljoezoner.dk/en/about-the-low-emission-zones/where-are-the-zones/','Particulate filter required; cars must be registered no later than the day of entering the city.','None'),(9,'FRANCE','Aix-Marseille-Provence','Crit\'Air','5','4','68 - 180 €','Sticker','UNLIMITED','Crit\'Air 2','N/A','https://www.certificat-air.gouv.fr/','Applies to Aix-Marseille-Provence metropolitan area; vehicles must display Crit\'Air stickers.','None'),(10,'FRANCE','Bordeaux','Crit\'Air','5','4','68 - 180 €','Sticker','UNLIMITED','Crit\'Air 2','N/A','https://www.certificat-air.gouv.fr/','Applies to Bordeaux and its metropolitan area; vehicles must display Crit\'Air stickers.','None'),(11,'FRANCE','Greater Grenoble','Crit\'Air','4','2','68 - 180 €','Sticker','UNLIMITED','Crit\'Air 3','N/A','https://www.certificat-air.gouv.fr/','Applies to Greater Grenoble and its metropolitan area; vehicles must display Crit\'Air stickers.','None'),(12,'FRANCE','Greater Saint-Etienne','Crit\'Air','2','0','68 - 180 €','Sticker','UNLIMITED','Crit\'Air 5','N/A','https://www.certificat-air.gouv.fr/','Applies to Greater Saint-Etienne and its metropolitan area; vehicles must display Crit\'Air stickers.','None'),(13,'FRANCE','Lille','Crit\'Air','4','2','68 - 180 €','Sticker','UNLIMITED','Crit\'Air 3','N/A','https://www.certificat-air.gouv.fr/','Applies to Lille and its metropolitan area; vehicles must display Crit\'Air stickers.','None'),(14,'FRANCE','Lyon','Crit\'Air','4','2','68 - 180 €','Sticker','UNLIMITED','Crit\'Air 3','N/A','https://www.certificat-air.gouv.fr/','Applies to Lyon and its metropolitan area; vehicles must display Crit\'Air stickers.','None'),(15,'FRANCE','Montpellier Mediterranee','Crit\'Air','4','2','68 - 180 €','Sticker','UNLIMITED','Crit\'Air 3','N/A','https://www.certificat-air.gouv.fr/','Applies to Montpellier Mediterranee and its metropolitan area; vehicles must display Crit\'Air stickers.','None'),(16,'FRANCE','Nice','Crit\'Air','4','2','68 - 180 €','Sticker','UNLIMITED','Crit\'Air 3','N/A','https://www.certificat-air.gouv.fr/','Applies to Nice and its metropolitan area; vehicles must display Crit-Air stickers.','None'),(17,'FRANCE','Paris','Crit\'Air','4','2','68 - 180 €','Sticker','UNLIMITED','Crit\'Air 3','N/A','https://www.certificat-air.gouv.fr/','Applies to the entire city of Paris; vehicles are categorized based on emissions and must display corresponding Crit-Air stickers.','None'),(18,'FRANCE','Reims','Crit\'Air','5','4','68 - 180 €','Sticker','UNLIMITED','Crit\'Air 2','N/A','https://www.certificat-air.gouv.fr/','Applies to Reims and its metropolitan area; vehicles must display Crit-Air stickers.','None'),(19,'FRANCE','Rouen','Crit\'Air','4','2','68 - 180 €','Sticker','UNLIMITED','Crit\'Air 3','N/A','https://www.certificat-air.gouv.fr/','Applies to Rouen and its metropolitan area; vehicles must display Crit-Air stickers.','None'),(20,'FRANCE','Strasbourg','Crit\'Air','4','2','68 - 180 €','Sticker','UNLIMITED','Crit\'Air 3','N/A','https://www.certificat-air.gouv.fr/','Description for Strasbourg','None'),(21,'FRANCE','Toulouse','Crit\'Air','4','2','68 - 180 €','Sticker','UNLIMITED','Crit\'Air 3','N/A','https://www.certificat-air.gouv.fr/','Description for Toulouse','None'),(22,'GERMANY','Aachen','Umweltplakette','4','1','50 - 200 €','Sticker','UNLIMITED','Umweltplakette Green - 4','N/A','https://www.germanemissionssticker.com/order/','Aachen is a charming town in southern Germany, famous for its picturesque vineyards and medieval castle ruins.','None'),(23,'GERMANY','Asperg','Umweltplakette','4','1','50 - 200 €','Sticker','UNLIMITED','Umweltplakette Green - 4','N/A','https://www.germanemissionssticker.com/order/','Asperg is a charming town in southern Germany, famous for its picturesque vineyards and medieval castle ruins.','None'),(24,'GERMANY','Augsburg','Umweltplakette','4','1','50 - 200 €','Sticker','UNLIMITED','Umweltplakette Green - 4','N/A','https://www.germanemissionssticker.com/order/','Augsburg is one of Germany\'s oldest cities, boasting a rich history, impressive Renaissance architecture, and lively cultural scene.','None'),(25,'GERMANY','Berlin','Umweltplakette','4','1','50 - 200 €','Sticker','UNLIMITED','Umweltplakette Green - 4','N/A','https://www.germanemissionssticker.com/order/','Berlin is the capital and largest city of Germany, renowned for its diverse art scene, historic landmarks, and vibrant nightlife.','None'),(26,'GERMANY','Bietigheim-Bissingen','Umweltplakette','4','1','50 - 200 €','Sticker','UNLIMITED','Umweltplakette Green - 4','N/A','https://www.germanemissionssticker.com/order/','Bietigheim-Bissingen is a picturesque town in southwestern Germany, characterized by its well-preserved medieval old town and scenic riverside views.','None'),(27,'GERMANY','Bochum','Umweltplakette','4','1','50 - 200 €','Sticker','UNLIMITED','Umweltplakette Green - 4','N/A','https://www.germanemissionssticker.com/order/','Germany - description','None'),(28,'GERMANY','Bonn','Umweltplakette','4','1','50 - 200 €','Sticker','UNLIMITED','Umweltplakette Green - 4','N/A','https://www.germanemissionssticker.com/order/','Germany - description','None'),(29,'GERMANY','Bottrop','Umweltplakette','4','1','50 - 200 €','Sticker','UNLIMITED','Umweltplakette Green - 4','N/A','https://www.germanemissionssticker.com/order/','Germany - description','None'),(30,'GERMANY','Bremen','Umweltplakette','4','1','50 - 200 €','Sticker','UNLIMITED','Umweltplakette Green - 4','N/A','https://www.germanemissionssticker.com/order/','Germany - description','None'),(31,'GERMANY','Castrop-Rauxel','Umweltplakette','4','1','50 - 200 €','Sticker','UNLIMITED','Umweltplakette Green - 4','N/A','https://www.germanemissionssticker.com/order/','Germany - description','None'),(88,'HUNGARY','Budapest','N/A','5','5','470 €','N/A','N/A','None','N/A','https://www.right-to-clean-air.eu/en/lawsuits-and-decisions/hungary/','Anti smog, from 6am to 10pm','None'),(89,'ITALY','Abbiategrasso','N/A','4','2','75 - 450 €','N/A','N/A','None','N/A','None','Part of Lombardia Region','None'),(90,'ITALY','Bergamo','N/A','4','2','75 - 450 €','N/A','N/A','None','N/A','None','Part of Lombardia Region','None'),(91,'ITALY','Bollate','N/A','4','2','75 - 450 €','N/A','N/A','None','N/A','None','Part of Lombardia Region','None'),(92,'ITALY','Bologna','N/A','4','3','75 - 450 €','N/A','N/A','None','N/A','https://www.comune.napoli.it/flex/cm/pages/ServeBLOB.php/L/IT/IDPagina/33761','Affects the city center; exceptions for residents, public transport, and certain vehicles','None'),(109,'ITALY','Florence','N/A','5','2','75 - 450 €','N/A','N/A','None','N/A','https://www.comune.napoli.it/flex/cm/pages/ServeBLOB.php/L/IT/IDPagina/33761','Affects the historic center; exceptions for residents and authorized vehicles','None'),(110,'ITALY','Gallarate','N/A','4','2','75 - 450 €','N/A','N/A','None','N/A','None','Part of Lombardia Region','None'),(111,'ITALY','Genoa','N/A','4','2','75 - 450 €','N/A','N/A','None','N/A','https://www.comune.napoli.it/flex/cm/pages/ServeBLOB.php/L/IT/IDPagina/33761','Affects the city center; exceptions for residents, public transport, and certain vehicles','None'),(112,'ITALY','Lecco','N/A','4','2','75 - 450 €','N/A','N/A','None','N/A','None','Part of Lombardia Region','None'),(126,'ITALY','Rome','N/A','4','3','75 - 450 €','N/A','N/A','None','N/A','https://www.comune.napoli.it/flex/cm/pages/ServeBLOB.php/L/IT/IDPagina/33761','Affects the entire municipality; exceptions for specific vehicles','Roma'),(127,'ITALY','Rozzano','N/A','4','2','75 - 450 €','N/A','N/A','None','N/A','None','Part of Lombardia Region','None'),(128,'ITALY','San Donato Milanese','N/A','4','2','75 - 450 €','N/A','N/A','None','N/A','None','Part of Lombardia Region','None'),(129,'ITALY','Saronno','N/A','4','2','75 - 450 €','N/A','N/A','None','N/A','None','Part of Lombardia Region','None'),(130,'ITALY','Segrate','N/A','4','2','75 - 450 €','N/A','N/A','None','N/A','None','Part of Lombardia Region','None'),(131,'ITALY','Seregno','N/A','4','2','75 - 450 €','N/A','N/A','None','N/A','None','Part of Lombardia Region','None'),(132,'ITALY','Sesto S. Giovanni','N/A','4','2','75 - 450 €','N/A','N/A','None','N/A','None','Part of Lombardia Region','None'),(133,'ITALY','Treviglio','N/A','4','2','75 - 450 €','N/A','N/A','None','N/A','None','Part of Lombardia Region','None'),(134,'ITALY','Turin','N/A','4','1','75 - 450 €','N/A','N/A','None','N/A','https://www.comune.napoli.it/flex/cm/pages/ServeBLOB.php/L/IT/IDPagina/33761','Affects the city center; exceptions for residents, public transport, and certain vehicles','None'),(135,'ITALY','Varese','N/A','4','2','75 - 450 €','N/A','N/A','None','N/A','None','Part of Lombardia Region','None'),(139,'NETHERLANDS','Arnhem','N/A','4','0','95 €','N/A','N/A','None','Netherlands','https://www.milieuzones.nl/english','Tel.: xxxxx , Arnhem city website','None'),(140,'NETHERLANDS','The Hague','N/A','4','0','95 €','N/A','N/A','None','Netherlands','https://www.milieuzones.nl/english','Tel.: xxxxx , The Haguecity website','None'),(141,'NETHERLANDS','Utrecht','N/A','4','0','95 €','N/A','N/A','None','Netherlands','https://www.milieuzones.nl/english','Utrecht: Utrecht is a city in the Netherlands, known for its historic city center, canals, and vibrant cultural scene.','None'),(142,'POLAND','Kraków','Poland Sticker','2 or 5','1 or 3','100-125 €','N/A','N/A','Registration sticker not avilable yet.','Poland','https://historiapojazdu.gov.pl/','From 1 July 2024, car registered before/after 1 March 2023','None'),(143,'POLAND','Warsaw','Poland Sticker','4 or 4','2 or 2','100-125 €','N/A','N/A','Registration sticker not avilable yet.','Poland','https://historiapojazdu.gov.pl/','From 1 July 2024','None'),(144,'PORTUGAL','Lisbon','None','3','3','120 €','None','N/A','None','N/A','https://eportugal.gov.pt/en/cidadaos-europeus-viajar-viver-e-fazer-negocios-em-portugal/veiculos-e-conduzir-em-portugal/regras-de-transito-e-mobilidade-em-portugal','Working days, from 7am to 9pm','None'),(145,'ROMANIA',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(146,'SPAIN','Alcobendas','Spain Sticker/Digital(Foreigners)','4','3','200 €','Sticker DGT','N/A','Distintivo Ambiental B','N/A','https://zberegistre.ambmobilitat.cat/en/VehiclesEstrangers','Working days from 7 am to 8pm','None'),(147,'SPAIN','Alicante','Spain Sticker/Digital(Foreigners)','4','4','200 €','Sticker','N/A','Distintivo Ambiental B','N/A','https://zberegistre.ambmobilitat.cat/en/VehiclesEstrangers','None','None'),(148,'SPAIN','Badalona','Spain Sticker/Digital(Foreigners)','4','3','200-1800 €','Sticker DGT','N/A','Distintivo Ambiental B','N/A','https://zberegistre.ambmobilitat.cat/en/VehiclesEstrangers','Working days from 7am to 8pm','None'),(149,'SPAIN','Barcelona','Spain Sticker/Digital(Foreigners)','4','3','200-1800 €','Sticker DGT','N/A','Distintivo Ambiental B','N/A','https://zberegistre.ambmobilitat.cat/en/VehiclesEstrangers','Working days from 7am to 8pm','None'),(160,'SPAIN','Sevilla','Spain Sticker/Digital(Foreigners)','4','3','200 €','Sticker','N/A','Distintivo Ambiental B','N/A','https://zberegistre.ambmobilitat.cat/en/VehiclesEstrangers','Working days from 7am to 7pm, public holidays excluded','None'),(169,'UNITED KINGDOM','London','DIGITAL','6','4','60 - 480£','Digital- TFL (Traffic for London)','N/A','London Registration Tax','United Kingdom','https://tfl.gov.uk/modes/driving/low-emission-zone#:~:text=The%20Low%20Emission%20Zone%20(LEZ,every%20day%20of%20the%20year.','£12.50/day if standard is not met, every day of the year except Christmas Day (25 December)','None'),(170,'UNITED KINGDOM','Manchester','DIGITAL','6','4','60 - 120 £','DIGITAL','N/A','Manchester Registration Tax','United Kingdom','https://tfl.gov.uk/modes/driving/low-emission-zone#:~:text=The%20Low%20Emission%20Zone%20(LEZ,every%20day%20of%20the%20year.','Date of entry into effect of the zone: 01-01-2026','None');
/*!40000 ALTER TABLE `zone` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `zone_temporary_data`
--

DROP TABLE IF EXISTS `zone_temporary_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `zone_temporary_data` (
  `id` int NOT NULL,
  `zone_id` int DEFAULT NULL,
  `country` text,
  `city` text,
  `temporary_data` text,
  `tp_lez_start` text,
  `tp_lez_end` text,
  `tp_minimum_diesel` text,
  `tp_minimum_petrol` text,
  PRIMARY KEY (`id`),
  KEY `fk_zone_temp_zone` (`zone_id`),
  CONSTRAINT `fk_zone_temp_zone` FOREIGN KEY (`zone_id`) REFERENCES `zone` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zone_temporary_data`
--

LOCK TABLES `zone_temporary_data` WRITE;
/*!40000 ALTER TABLE `zone_temporary_data` DISABLE KEYS */;
INSERT INTO `zone_temporary_data` VALUES (1,1,'Belgium','Antwerp/Antwerpen','None','None','None','None','None'),(2,2,'BELGIUM','Brussels','None','None','None','None','None'),(3,3,'BELGIUM','Ghent','None','None','None','None','None'),(4,4,'BULGARIA','Sofia','Winter LEZ applies from 01.12 to 01.03 every year.','12-01','03-01','None','None'),(5,5,'DENMARK','Aalborg','None','None','None','None','None'),(6,6,'DENMARK','Aarhus','None','None','None','None','None'),(7,7,'DENMARK','Copenhagen','None','None','None','None','None'),(8,8,'DENMARK','Odense','None','None','None','None','None'),(9,9,'FRANCE','Aix-Marseille-Provence','The driving restriction applies Monday to Friday, from 8 AM to 8 PM.','None','None','None','None'),(10,10,'FRANCE','Bordeaux','The driving restriction applies Monday to Friday, from 8 AM to 8 PM.','None','None','None','None'),(11,11,'FRANCE','Greater Grenoble','The driving restriction applies Monday to Friday, from 8 AM to 8 PM.','None','None','None','None'),(12,12,'FRANCE','Greater Saint-Etienne','The driving restriction applies Monday to Friday, from 8 AM to 8 PM.','None','None','None','None'),(13,13,'FRANCE','Lille','The driving restriction applies Monday to Friday, from 8 AM to 8 PM.','None','None','None','None'),(14,14,'FRANCE','Lyon','The driving restriction applies Monday to Friday, from 8 AM to 8 PM.','None','None','None','None'),(15,15,'FRANCE','Montpellier Mediterranee','The driving restriction applies Monday to Friday, from 8 AM to 8 PM.','None','None','None','None'),(16,16,'FRANCE','Nice','The driving restriction applies Monday to Friday, from 8 AM to 8 PM.','None','None','None','None'),(17,17,'FRANCE','Paris','The driving restriction applies Monday to Friday, from 8 AM to 8 PM.','None','None','None','None'),(18,18,'FRANCE','Reims','The driving restriction applies Monday to Friday, from 8 AM to 8 PM.','None','None','None','None'),(19,19,'FRANCE','Rouen','The driving restriction applies Monday to Friday, from 8 AM to 8 PM.','None','None','None','None'),(126,126,'ITALY','Rome','Winter LEZ for Rome is available from 1 October -> 31 March. Restrictions are applied Mon-Fri 07:30-19:30h but public holidays are excluded.','10-01','03-31','6','3'),(127,127,'ITALY','Rozzano','Winter LEZ for Rozzano is available from 1 October -> 31 March. Restrictions are applied Mon-Fri 07:30-19:30h but public holidays are excluded.','10-01','03-31','6','3'),(128,128,'ITALY','San Donato Milanese','Winter LEZ for San Donato Milanese is available from 1 October -> 31 March. Restrictions are applied Mon-Fri 07:30-19:30h but public holidays are excluded.','10-01','03-31','6','3'),(138,138,'NETHERLANDS','Amsterdam','None','None','None','None','None'),(139,139,'NETHERLANDS','Arnhem','None','None','None','None','None'),(140,140,'NETHERLANDS','The Hague','None','None','None','None','None'),(141,141,'NETHERLANDS','Utrecht','None','None','None','None','None'),(142,142,'POLAND','Krakow','None','None','None','None','None'),(143,143,'POLAND','Warsaw','None','None','None','None','None'),(144,144,'PORTUGAL','Lisbon','The driving restriction applies Monday to Friday, from 7am to 9 pm.','None','None','None','None'),(149,149,'SPAIN','Barcelona','Working days from 7 am to 8pm','None','None','None','None'),(169,169,'United Kingdom','London','None','None','None','None','None'),(170,170,'United Kingdom','Manchester','None','None','None','None','None'),(171,171,'United Kingdom','New Castle','None','None','None','None','None'),(172,172,'United Kingdom','Portsmouth','None','None','None','None','None'),(173,173,'United Kingdom','Sheffield','None','None','None','None','None');
/*!40000 ALTER TABLE `zone_temporary_data` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-03-17 11:07:05

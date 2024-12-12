CREATE DATABASE  IF NOT EXISTS `cs336project` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `cs336project`;
-- MySQL dump 10.13  Distrib 8.0.40, for macos14 (x86_64)
--
-- Host: 127.0.0.1    Database: cs336project
-- ------------------------------------------------------
-- Server version	9.1.0

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
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `username` varchar(20) NOT NULL,
  `password` varchar(20) DEFAULT NULL,
  `email` varchar(20) DEFAULT NULL,
  `first_name` varchar(20) DEFAULT NULL,
  `last_name` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES ('demo-customer','demopassword','demo@gmail.com','Demo','Customer'),('jdoe','password123','jdoe@gmail.com','john','doe'),('jvan','jonathan123','jvan@gmail.com','jonathan','van'),('lbj','goat','lbj@gmail.com','lebron','james');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee` (
  `ssn` char(11) NOT NULL,
  `first_name` varchar(20) DEFAULT NULL,
  `last_name` varchar(20) DEFAULT NULL,
  `username` varchar(20) DEFAULT NULL,
  `password` varchar(20) DEFAULT NULL,
  `role` enum('admin','rep') NOT NULL DEFAULT 'rep',
  PRIMARY KEY (`ssn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee`
--

LOCK TABLES `employee` WRITE;
/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
INSERT INTO `employee` VALUES ('123-45-6789','Adam','Silver','test_admin','admin00','admin'),('124-49-2394','Demo','Rep','demo-rep','demopassword','rep'),('143-25-3857','Demo','Person','demo-adm','demopassword','admin'),('454-52-6752','Jon','Jones','rep01','test','rep');
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `messages` (
  `message_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `summary` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `answer` text,
  `status` enum('unanswered','answered') DEFAULT 'unanswered',
  `answered_by` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`message_id`),
  KEY `fk_customer_username` (`username`),
  CONSTRAINT `fk_customer_username` FOREIGN KEY (`username`) REFERENCES `customer` (`username`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` VALUES (1,'lbj','Reset Password','I need help resetting my account password.','Please check your email for the reset link!','answered','rep01','2024-12-11 19:49:46','2024-12-11 20:36:26'),(2,'jdoe','Refund Policy','Can you explain the refund policy for canceled tickets?','You have up to 30 days from the date of purchase to request a refund!','answered','rep01','2024-12-11 19:49:46','2024-12-11 20:37:27'),(3,'lbj','Food','Hello, are we allowed food and drinks on the train?','Hello, yes. Additional food and drinks are sold in dining cars as well!','answered','rep01','2024-12-11 20:15:12','2024-12-11 20:41:03'),(4,'lbj','test','hello?',NULL,'unanswered',NULL,'2024-12-11 20:16:40','2024-12-11 20:16:40'),(5,'lbj','test','hello?',NULL,'unanswered',NULL,'2024-12-11 20:17:04','2024-12-11 20:17:04');
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reservation`
--

DROP TABLE IF EXISTS `reservation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservation` (
  `res_num` int NOT NULL,
  `res_date` datetime DEFAULT NULL,
  `passenger` varchar(20) DEFAULT NULL,
  `fare` float DEFAULT NULL,
  `origin` varchar(20) DEFAULT NULL,
  `destination` varchar(20) DEFAULT NULL,
  `train_id` char(4) DEFAULT NULL,
  `line_name` varchar(50) DEFAULT NULL,
  `class` enum('Business','First','Economy') NOT NULL,
  `discount` enum('Disabled','Senior/Child','Normal') NOT NULL,
  `trip` enum('Round','One','Monthly','Weekly') NOT NULL,
  PRIMARY KEY (`res_num`),
  KEY `passenger` (`passenger`),
  KEY `train_id` (`train_id`),
  CONSTRAINT `reservation_ibfk_1` FOREIGN KEY (`passenger`) REFERENCES `customer` (`username`),
  CONSTRAINT `reservation_ibfk_2` FOREIGN KEY (`train_id`) REFERENCES `train` (`train_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservation`
--

LOCK TABLES `reservation` WRITE;
/*!40000 ALTER TABLE `reservation` DISABLE KEYS */;
INSERT INTO `reservation` VALUES (1,'2024-12-01 08:00:00','jdoe',100.5,'Trenton','Secaucus Junction','2','NE Corridor Line','Economy','Normal','One'),(2,'2024-12-01 09:00:00','jvan',120.75,'Secaucus Junction','Trenton','1','NE Corridor Line','First','Senior/Child','Round'),(3,'2024-12-02 07:30:00','lbj',150.25,'Philadelphia 30th St','Pittsburgh Union Sta','3','Amtrak Pennsylvanian','Business','Normal','Weekly'),(4,'2024-12-02 10:15:00','jdoe',130,'Philadelphia 30th St','Pittsburgh Union Sta','3','Amtrak Pennsylvanian','Economy','Normal','One'),(5,'2024-12-03 14:00:00','jvan',110,'Trenton','Secaucus Junction','2','NE Corridor Line','First','Disabled','Round'),(6,'2024-12-03 16:45:00','lbj',140.25,'Secaucus Junction','Trenton','1','NE Corridor Line','Business','Senior/Child','Monthly'),(7,'2024-12-04 11:00:00','jdoe',125.75,'Philadelphia 30th St','Pittsburgh Union Sta','3','Amtrak Pennsylvanian','Economy','Normal','One'),(8,'2024-12-04 13:30:00','jvan',135,'Philadelphia 30th St','Pittsburgh Union Sta','3','Amtrak Pennsylvanian','First','Normal','Weekly'),(9,'2024-12-05 09:45:00','lbj',115.5,'Trenton','Secaucus Junction','2','NE Corridor Line','Business','Disabled','Round'),(10,'2024-12-05 15:00:00','jdoe',110,'Secaucus Junction','Trenton','1','NE Corridor Line','Economy','Senior/Child','One'),(11,'2024-12-06 07:00:00','jvan',140.25,'Philadelphia 30th St','Pittsburgh Union Sta','3','Amtrak Pennsylvanian','Business','Normal','Weekly'),(12,'2024-12-06 14:30:00','lbj',100,'Trenton','Secaucus Junction','2','NE Corridor Line','Economy','Normal','One'),(13,'2024-12-07 08:00:00','jdoe',105,'Pittsburgh Union Sta','Philadelphia 30th St','4','Amtrak Pennsylvanian','Economy','Normal','One'),(14,'2024-12-07 09:30:00','jvan',125.75,'Pittsburgh Union Sta','Philadelphia 30th St','4','Amtrak Pennsylvanian','First','Senior/Child','Round'),(15,'2024-12-08 07:15:00','lbj',135.5,'Pittsburgh Union Sta','Philadelphia 30th St','4','Amtrak Pennsylvanian','Business','Disabled','Weekly'),(16,'2024-12-11 14:34:25','lbj',88,'Secaucus Junction','Trenton','1','Train Line Name','First','Senior/Child','One');
/*!40000 ALTER TABLE `reservation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedule`
--

DROP TABLE IF EXISTS `schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schedule` (
  `transit_line` varchar(20) NOT NULL,
  `train_id` char(4) NOT NULL,
  `origin` varchar(20) NOT NULL,
  `destination` varchar(20) NOT NULL,
  `depart_time` datetime NOT NULL,
  `arrival_time` datetime DEFAULT NULL,
  `travel_time` int DEFAULT NULL,
  `num_stops` int DEFAULT NULL,
  PRIMARY KEY (`transit_line`,`train_id`,`depart_time`),
  KEY `train_id` (`train_id`),
  CONSTRAINT `schedule_ibfk_1` FOREIGN KEY (`train_id`) REFERENCES `train` (`train_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedule`
--

LOCK TABLES `schedule` WRITE;
/*!40000 ALTER TABLE `schedule` DISABLE KEYS */;
INSERT INTO `schedule` VALUES ('Amtrak Pennsylvanian','3','Philadelphia 30th St','Pittsburgh Union Sta','2024-12-09 00:00:00','2024-12-09 01:44:00',60,NULL),('Amtrak Pennsylvanian','4','Pittsburgh Union Sta','Philadelphia 30th St','2024-12-10 00:00:00','2024-12-10 01:44:00',60,NULL),('NE Corridor Line','1','Secaucus Junction','Trenton','2024-12-07 00:00:00','2024-12-07 01:44:00',60,NULL),('NE Corridor Line','2','Trenton','Secaucus Junction','2024-12-08 00:00:00','2024-12-08 01:44:00',60,NULL);
/*!40000 ALTER TABLE `schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `station`
--

DROP TABLE IF EXISTS `station`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `station` (
  `station_id` int NOT NULL,
  `station_name` varchar(20) DEFAULT NULL,
  `city` varchar(20) DEFAULT NULL,
  `state` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`station_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `station`
--

LOCK TABLES `station` WRITE;
/*!40000 ALTER TABLE `station` DISABLE KEYS */;
INSERT INTO `station` VALUES (1,'Secaucus Junction','Secaucus','NJ'),(2,'Newark Penn Station','Newark','NJ'),(3,'Newark Liberty Inter','Newark','NJ'),(4,'Elizabeth','Elizabeth','NJ'),(5,'Linden','Linden','NJ'),(6,'Rahway','Rahway','NJ'),(7,'Metropark','Iselin','NJ'),(8,'Metuchen','Metuchen','NJ'),(9,'Edison','Edison','NJ'),(10,'New Brunswick','New Brunswick','NJ'),(11,'West Windsor','Princeton Junction','NJ'),(12,'Hamilton','Hamilton','NJ'),(13,'Trenton','Trenton Transit Cent','NJ'),(14,'Philadelphia 30th St','Philadelphia','PA'),(15,'Paoli','Paoli','PA'),(16,'Exton','Exton','PA'),(17,'Lancaster','Lancaster','PA'),(18,'Elizabethtown','Elizabethtown','PA'),(19,'Harrisburg Transport','Harrisburg','PA'),(20,'Lewistown','Lewistown','PA'),(21,'Huntingdon','Huntingdon','PA'),(22,'Tyrone','Tyrone','PA'),(23,'Altoona Transportati','Altoona','PA'),(24,'Johnstown','Johnstown','PA'),(25,'Latrobe','Latrobe','PA'),(26,'Greensburg','Greensburg','PA'),(27,'Pittsburgh Union Sta','Pittsburgh','PA');
/*!40000 ALTER TABLE `station` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stop`
--

DROP TABLE IF EXISTS `stop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stop` (
  `station_id` int NOT NULL,
  `depart_time` datetime NOT NULL,
  `arrive_time` datetime DEFAULT NULL,
  `fare` float NOT NULL,
  PRIMARY KEY (`station_id`,`depart_time`),
  CONSTRAINT `stop_ibfk_1` FOREIGN KEY (`station_id`) REFERENCES `station` (`station_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stop`
--

LOCK TABLES `stop` WRITE;
/*!40000 ALTER TABLE `stop` DISABLE KEYS */;
INSERT INTO `stop` VALUES (1,'2024-12-07 00:08:00','2024-12-07 00:00:00',3),(1,'2024-12-08 00:08:00','2024-12-08 00:00:00',3),(2,'2024-12-07 00:16:00','2024-12-07 00:08:00',2.5),(2,'2024-12-08 00:16:00','2024-12-08 00:08:00',2.5),(3,'2024-12-07 00:24:00','2024-12-07 00:16:00',4),(3,'2024-12-08 00:24:00','2024-12-08 00:16:00',4),(4,'2024-12-07 00:32:00','2024-12-07 00:24:00',3.5),(4,'2024-12-08 00:32:00','2024-12-08 00:24:00',3.5),(5,'2024-12-07 00:40:00','2024-12-07 00:32:00',2),(5,'2024-12-08 00:40:00','2024-12-08 00:32:00',2),(6,'2024-12-07 00:48:00','2024-12-07 00:40:00',4.5),(6,'2024-12-08 00:48:00','2024-12-08 00:40:00',4.5),(7,'2024-12-07 00:56:00','2024-12-07 00:48:00',3),(7,'2024-12-08 00:56:00','2024-12-08 00:48:00',3),(8,'2024-12-07 01:04:00','2024-12-07 00:56:00',4),(8,'2024-12-08 01:04:00','2024-12-08 00:56:00',4),(9,'2024-12-07 01:12:00','2024-12-07 01:04:00',5),(9,'2024-12-08 01:12:00','2024-12-08 01:04:00',5),(10,'2024-12-07 01:20:00','2024-12-07 01:12:00',3.5),(10,'2024-12-08 01:20:00','2024-12-08 01:12:00',3.5),(11,'2024-12-07 01:28:00','2024-12-07 01:20:00',2.5),(11,'2024-12-08 01:28:00','2024-12-08 01:20:00',2.5),(12,'2024-12-07 01:36:00','2024-12-07 01:28:00',2),(12,'2024-12-08 01:36:00','2024-12-08 01:28:00',2),(13,'2024-12-07 01:44:00','2024-12-07 01:36:00',4.5),(13,'2024-12-08 01:44:00','2024-12-08 01:36:00',4.5),(14,'2024-12-09 00:08:00','2024-12-09 00:00:00',3),(14,'2024-12-10 00:08:00','2024-12-10 00:00:00',3),(15,'2024-12-09 00:16:00','2024-12-09 00:08:00',2.5),(15,'2024-12-10 00:16:00','2024-12-10 00:08:00',2.5),(16,'2024-12-09 00:24:00','2024-12-09 00:16:00',4),(16,'2024-12-10 00:24:00','2024-12-10 00:16:00',4),(17,'2024-12-09 00:32:00','2024-12-09 00:24:00',3.5),(17,'2024-12-10 00:32:00','2024-12-10 00:24:00',3.5),(18,'2024-12-09 00:40:00','2024-12-09 00:32:00',2),(18,'2024-12-10 00:40:00','2024-12-10 00:32:00',2),(19,'2024-12-09 00:48:00','2024-12-09 00:40:00',4.5),(19,'2024-12-10 00:48:00','2024-12-10 00:40:00',4.5),(20,'2024-12-09 00:56:00','2024-12-09 00:48:00',3),(20,'2024-12-10 00:56:00','2024-12-10 00:48:00',3),(21,'2024-12-09 01:04:00','2024-12-09 00:56:00',4),(21,'2024-12-10 01:04:00','2024-12-10 00:56:00',4),(22,'2024-12-09 01:12:00','2024-12-09 01:04:00',5),(22,'2024-12-10 01:12:00','2024-12-10 01:04:00',5),(23,'2024-12-09 01:20:00','2024-12-09 01:12:00',3.5),(23,'2024-12-10 01:20:00','2024-12-10 01:12:00',3.5),(24,'2024-12-09 01:28:00','2024-12-09 01:20:00',2.5),(24,'2024-12-10 01:28:00','2024-12-10 01:20:00',2.5),(25,'2024-12-09 01:36:00','2024-12-09 01:28:00',2),(25,'2024-12-10 01:36:00','2024-12-10 01:28:00',2),(26,'2024-12-09 01:44:00','2024-12-09 01:36:00',4.5),(26,'2024-12-10 01:44:00','2024-12-10 01:36:00',4.5),(27,'2024-12-09 01:52:00','2024-12-09 01:44:00',3),(27,'2024-12-10 01:52:00','2024-12-10 01:44:00',3);
/*!40000 ALTER TABLE `stop` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `train`
--

DROP TABLE IF EXISTS `train`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `train` (
  `train_id` char(4) NOT NULL,
  PRIMARY KEY (`train_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `train`
--

LOCK TABLES `train` WRITE;
/*!40000 ALTER TABLE `train` DISABLE KEYS */;
INSERT INTO `train` VALUES ('1'),('10'),('11'),('12'),('2'),('3'),('4'),('5'),('6'),('7'),('8'),('9');
/*!40000 ALTER TABLE `train` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-12-11 16:01:46
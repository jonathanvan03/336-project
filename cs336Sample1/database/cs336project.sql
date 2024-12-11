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
INSERT INTO `customer` VALUES ('jdoe','password123','jdoe@gmail.com','john','doe'),('jvan','jonathan123','jvan@gmail.com','jonathan','van'),('lbj','goat','lbj@gmail.com','lebron','james');
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
INSERT INTO `employee` VALUES ('123-45-6789','test','person','test_admin','admin00','admin');
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;
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
  `origin` int DEFAULT NULL,
  `destination` int DEFAULT NULL,
  `train_id` char(4) DEFAULT NULL,
  `line_name` varchar(50) DEFAULT NULL,
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
INSERT INTO `schedule` VALUES ('NE Corridor Line','1','Secaucus Junction','Trenton','2024-12-07 00:00:00','2024-12-07 01:44:00',60,NULL),('NE Corridor Line 2','3','Trenton','Secaucus Junction','2024-12-09 00:00:00','2024-12-09 01:44:00',60,NULL),('NE Corridor Line Re','2','Trenton','Secaucus Junction','2024-12-08 00:00:00','2024-12-08 01:44:00',60,NULL);
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
INSERT INTO `station` VALUES (1,'Secaucus Junction','Secaucus','NJ'),(2,'Newark Penn Station','Newark','NJ'),(3,'Newark Liberty Inter','Newark','NJ'),(4,'Elizabeth','Elizabeth','NJ'),(5,'Linden','Linden','NJ'),(6,'Rahway','Rahway','NJ'),(7,'Metropark','Iselin','NJ'),(8,'Metuchen','Metuchen','NJ'),(9,'Edison','Edison','NJ'),(10,'New Brunswick','New Brunswick','NJ'),(11,'West Windsor','Princeton Junction','NJ'),(12,'Hamilton','Hamilton','NJ'),(13,'Trenton','Trenton Transit Cent','NJ');
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
INSERT INTO `stop` VALUES (1,'2024-12-08 00:08:00','2024-12-08 00:00:00',3),(2,'2024-12-08 00:16:00','2024-12-08 00:08:00',2.5),(3,'2024-12-08 00:24:00','2024-12-08 00:16:00',4),(4,'2024-12-08 00:32:00','2024-12-08 00:24:00',3.5),(5,'2024-12-08 00:40:00','2024-12-08 00:32:00',2),(6,'2024-12-08 00:48:00','2024-12-08 00:40:00',4.5),(7,'2024-12-08 00:56:00','2024-12-08 00:48:00',3),(8,'2024-12-08 01:04:00','2024-12-08 00:56:00',4),(9,'2024-12-08 01:12:00','2024-12-08 01:04:00',5),(10,'2024-12-08 01:20:00','2024-12-08 01:12:00',3.5),(11,'2024-12-08 01:28:00','2024-12-08 01:20:00',2.5),(12,'2024-12-08 01:36:00','2024-12-08 01:28:00',2),(13,'2024-12-08 01:44:00','2024-12-08 01:36:00',4.5);
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
INSERT INTO `train` VALUES ('1'),('2'),('3');
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

-- Dump completed on 2024-12-10 22:35:52

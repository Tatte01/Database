CREATE DATABASE  IF NOT EXISTS `eshop` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci */;
USE `eshop`;
-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: eshop
-- ------------------------------------------------------
-- Server version	11.6.2-MariaDB

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
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `namn` char(50) NOT NULL,
  PRIMARY KEY (`namn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES ('Beverages'),('Caffeinated'),('Cold'),('Hot'),('Non-Caffeinated');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `address` varchar(100) NOT NULL,
  `phone` varchar(100) NOT NULL,
  `number_of_orders` int(11) DEFAULT NULL,
  `total_Spent` decimal(10,2) DEFAULT 0.00,
  PRIMARY KEY (`id`),
  KEY `idx_name` (`name`),
  KEY `idx_adress` (`address`),
  KEY `idx_phone` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (1,'Chloe','Los Angeles','555-1234',NULL,0.00),(2,'Bob','New York','555-5678',NULL,0.00),(3,'Charlie','Chicago','555-9101',NULL,0.00),(4,'David','Houston','555-1122',NULL,0.00),(5,'Malte','Miami','555-3344',NULL,0.00);
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faktura`
--

DROP TABLE IF EXISTS `faktura`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `faktura` (
  `invoice_id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL,
  `invoice_date` datetime NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'Not Paid',
  `payment_date` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`invoice_id`),
  KEY `order_id` (`order_id`),
  CONSTRAINT `faktura_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faktura`
--

LOCK TABLES `faktura` WRITE;
/*!40000 ALTER TABLE `faktura` DISABLE KEYS */;
INSERT INTO `faktura` VALUES (1,93,'2025-04-04 15:51:42',265.00,'Paid','2025-04-04 17:20:14'),(2,94,'2025-04-04 15:53:30',531.00,'Paid','2025-04-04 17:19:33'),(3,95,'2025-04-04 18:32:43',511.00,'Paid','2025'),(4,96,'2025-04-04 19:48:41',5280.00,'Betald','2025'),(5,97,'2025-04-04 19:59:00',4092.00,'Betald','2025-04-04');
/*!40000 ALTER TABLE `faktura` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`dbadm`@`%`*/ /*!50003 TRIGGER paidfaktura
BEFORE UPDATE ON faktura
FOR EACH ROW 
BEGIN 
    IF NEW.status = 'Paid' AND OLD.status != 'Paid' THEN
        
        
        
        INSERT INTO logs (event_type, description)
        VALUES('faktura betald',
        CONCAT('Faktura: ', NEW.invoice_id, ' was paid on ', DATE_FORMAT(NOW(), '%Y-%m-%d')));
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `faktura_lines`
--

DROP TABLE IF EXISTS `faktura_lines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `faktura_lines` (
  `invoice_id` int(11) DEFAULT NULL,
  `line_number` int(11) DEFAULT NULL,
  `product_id` int(11) NOT NULL,
  `product_name` varchar(100) NOT NULL,
  `quantity` int(11) NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `line_total` decimal(10,2) NOT NULL,
  KEY `invoice_id` (`invoice_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `faktura_lines_ibfk_1` FOREIGN KEY (`invoice_id`) REFERENCES `faktura` (`invoice_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faktura_lines`
--

LOCK TABLES `faktura_lines` WRITE;
/*!40000 ALTER TABLE `faktura_lines` DISABLE KEYS */;
INSERT INTO `faktura_lines` VALUES (1,1,41295,'Tea',3,49.00,147.00),(1,2,45425,'Espresso',2,59.00,118.00),(2,1,45425,'Espresso',2,59.00,118.00),(2,2,89340,'Refresher',5,59.00,295.00),(2,3,90720,'Lemonade',2,59.00,118.00),(3,1,41295,'Tea',4,49.00,196.00),(3,2,45425,'Espresso',3,59.00,177.00),(3,3,69585,'Americanos',2,69.00,138.00),(4,1,1337,'Test',5,999.00,4995.00),(4,2,13135,'Coffee',2,69.00,138.00),(4,3,41295,'Tea',3,49.00,147.00),(5,1,1337,'Test',5,777.00,3885.00),(5,2,13135,'Coffee',3,69.00,207.00);
/*!40000 ALTER TABLE `faktura_lines` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logs`
--

DROP TABLE IF EXISTS `logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` timestamp NULL DEFAULT current_timestamp(),
  `event_type` varchar(255) NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=135 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logs`
--

LOCK TABLES `logs` WRITE;
/*!40000 ALTER TABLE `logs` DISABLE KEYS */;
INSERT INTO `logs` VALUES (48,'2025-03-12 15:23:25','UPDATE','Product with ID: 90720 was updated. Old Name: Lemonade New Name: Lemonade, Old Price: 66.00 New Price: 555.00'),(49,'2025-03-12 15:23:39','UPDATE','Product with ID: 90720 was updated. Old Name: Lemonade New Name: Lemonade, Old Price: 555.00 New Price: 93.00'),(50,'2025-03-12 15:42:04','UPDATE','Product with ID: 41295 was updated. Old Name: Tea New Name: Tea, Old Price: 34.00 New Price: 55.00'),(51,'2025-03-12 21:05:19','DELETE','Product with ID: 444 Name: Chloe And Price: 44.00'),(52,'2025-03-13 15:12:15','INSERT','A new product was added with ID: 222, Name: Malte, Price: 66.00'),(53,'2025-03-13 15:14:48','DELETE','Product with ID: 222 Name: Malte And Price: 66.00'),(54,'2025-03-13 15:15:53','UPDATE','Product with ID: 90720 was updated. Old Name: Lemonade New Name: Lemonade, Old Price: 93.00 New Price: 50.00'),(55,'2025-03-13 15:16:07','UPDATE','Product with ID: 27515 was updated. Old Name: Chocolate New Name: Chocolate, Old Price: 58.00 New Price: 59.00'),(56,'2025-03-13 15:16:13','UPDATE','Product with ID: 41295 was updated. Old Name: Tea New Name: Tea, Old Price: 55.00 New Price: 39.00'),(57,'2025-03-13 15:16:20','UPDATE','Product with ID: 45425 was updated. Old Name: Espresso New Name: Espresso, Old Price: 54.00 New Price: 59.00'),(58,'2025-03-13 15:16:28','UPDATE','Product with ID: 90720 was updated. Old Name: Lemonade New Name: Lemonade, Old Price: 50.00 New Price: 59.00'),(59,'2025-03-13 21:05:16','INSERT','A new product was added with ID: 6969, Name: Chloe, Price: 66.00'),(60,'2025-03-13 21:05:23','DELETE','Product with ID: 6969 Name: Chloe And Price: 66.00'),(61,'2025-03-13 21:08:40','UPDATE','Product with ID: 13135 was updated. Old Name: Coffee New Name: Coffee, Old Price: 49.00 New Price: 59.00'),(62,'2025-03-15 09:55:52','INSERT','A new product was added with ID: 222, Name: Malte, Price: 22.00'),(63,'2025-03-15 10:05:02','DELETE','Product with ID: 222 Name: Malte And Price: 22.00'),(64,'2025-03-15 17:36:51','INSERT','A new product was added with ID: 222, Name: new product, Price: 50.00'),(65,'2025-03-20 16:14:25','INSERT','A new product was added with ID: 223, Name: new product, Price: 50.00'),(66,'2025-03-20 16:16:06','INSERT','A new product was added with ID: 345, Name: Malte, Price: 55.00'),(67,'2025-03-20 16:16:17','UPDATE','Product with ID: 345 was updated. Old Name: Malte New Name: Malte, Old Price: 55.00 New Price: 44.00'),(68,'2025-03-25 17:41:17','DELETE','Product with ID: 222 Name: new product And Price: 50.00'),(69,'2025-03-25 17:41:20','DELETE','Product with ID: 223 Name: new product And Price: 50.00'),(70,'2025-03-25 17:41:23','DELETE','Product with ID: 345 Name: Malte And Price: 44.00'),(71,'2025-03-25 17:43:31','INSERT','A new product was added with ID: 6969, Name: Malte, Price: 66.00'),(72,'2025-03-25 17:50:26','INSERT','A new product was added with ID: 222, Name: Chloe, Price: 99.00'),(73,'2025-03-25 17:50:31','UPDATE','Product with ID: 6969 was updated. Old Name: Malte New Name: Malte, Old Price: 66.00 New Price: 77.00'),(74,'2025-03-25 18:11:31','DELETE','Product with ID: 222 Name: Chloe And Price: 99.00'),(75,'2025-03-25 18:11:34','DELETE','Product with ID: 6969 Name: Malte And Price: 77.00'),(76,'2025-03-25 18:18:03','INSERT','A new product was added with ID: 6969, Name: Chloe, Price: 55.00'),(77,'2025-03-25 19:03:40','DELETE','Product with ID: 6969 Name: Chloe And Price: 55.00'),(78,'2025-03-25 19:08:26','UPDATE','Product with ID: 13135 was updated. Old Name: Coffee New Name: Coffee, Old Price: 59.00 New Price: 60.00'),(79,'2025-03-25 19:08:33','UPDATE','Product with ID: 13135 was updated. Old Name: Coffee New Name: Coffee, Old Price: 60.00 New Price: 59.00'),(80,'2025-03-25 19:14:31','INSERT','A new product was added with ID: 3333, Name: Chloe, Price: 44.00'),(81,'2025-03-25 19:14:41','DELETE','Product with ID: 3333 Name: Chloe And Price: 44.00'),(82,'2025-03-25 20:09:39','UPDATE','Product with ID: 13135 was updated. Old Name: Coffee New Name: Coffee, Old Price: 59.00 New Price: 69.00'),(83,'2025-03-25 20:11:40','INSERT','A new product was added with ID: 1111, Name: malte, Price: 44.00'),(84,'2025-03-25 20:14:14','INSERT','A new product was added with ID: 3333, Name: malte, Price: 44.00'),(85,'2025-03-25 20:20:53','DELETE','Product with ID: 3333 Name: malte And Price: 44.00'),(86,'2025-03-25 20:20:56','DELETE','Product with ID: 1111 Name: malte And Price: 44.00'),(87,'2025-03-25 20:21:37','INSERT','A new product was added with ID: 3333, Name: Malte, Price: 555.00'),(88,'2025-03-25 20:21:41','DELETE','Product with ID: 3333 Name: Malte And Price: 555.00'),(89,'2025-03-25 20:23:12','UPDATE','Product with ID: 41295 was updated. Old Name: Tea New Name: Tea, Old Price: 39.00 New Price: 49.00'),(90,'2025-03-26 12:10:35','INSERT','A new product was added with ID: 222, Name: Malte, Price: 45.00'),(91,'2025-03-26 12:10:49','UPDATE','Product with ID: 222 was updated. Old Name: Malte New Name: Malte, Old Price: 45.00 New Price: 55.00'),(92,'2025-03-27 12:52:39','INSERT','A new product was added with ID: 1111, Name: Malte, Price: 66.00'),(93,'2025-03-27 12:53:00','DELETE','Product with ID: 222 Name: Malte And Price: 55.00'),(94,'2025-03-27 12:53:19','INSERT','A new product was added with ID: 1234, Name: test, Price: 55.00'),(95,'2025-03-27 12:53:37','UPDATE','Product with ID: 1234 was updated. Old Name: test New Name: test, Old Price: 55.00 New Price: 44.00'),(96,'2025-03-27 13:02:03','DELETE','Product with ID: 1234 Name: test And Price: 44.00'),(97,'2025-03-30 15:54:19','UPDATE','Product with ID: 1111 was updated. Old Name: Malte New Name: Malte, Old Price: 66.00 New Price: 59.00'),(98,'2025-03-30 15:55:56','DELETE','Product with ID: 1111 Name: Malte And Price: 59.00'),(99,'2025-03-30 16:42:16','INSERT','A new product was added with ID: 549325, Name: TEST, Price: 66.00'),(100,'2025-03-30 16:43:29','DELETE','Product with ID: 549325 Name: TEST And Price: 66.00'),(101,'2025-03-30 16:43:39','INSERT','A new product was added with ID: 54932, Name: Test, Price: 44.00'),(102,'2025-03-30 16:51:11','DELETE','Product with ID: 54932 Name: Test And Price: 44.00'),(103,'2025-03-30 16:51:47','INSERT','A new product was added with ID: 3477, Name: test, Price: 56.00'),(104,'2025-03-30 16:52:32','DELETE','Product with ID: 3477 Name: test And Price: 56.00'),(105,'2025-03-30 16:52:47','INSERT','A new product was added with ID: 4567, Name: test, Price: 56.00'),(106,'2025-03-30 16:53:54','INSERT','A new product was added with ID: 8655, Name: test, Price: 34.00'),(107,'2025-03-30 16:54:00','DELETE','Product with ID: 8655 Name: test And Price: 34.00'),(108,'2025-03-30 16:54:03','DELETE','Product with ID: 4567 Name: test And Price: 56.00'),(109,'2025-03-30 16:56:49','INSERT','A new product was added with ID: 6969, Name: test, Price: 44.00'),(110,'2025-03-30 16:57:26','DELETE','Product with ID: 6969 Name: test And Price: 44.00'),(111,'2025-03-30 16:57:36','INSERT','A new product was added with ID: 1111, Name: test, Price: 54.00'),(112,'2025-03-30 16:57:58','DELETE','Product with ID: 1111 Name: test And Price: 54.00'),(113,'2025-03-30 16:58:21','INSERT','A new product was added with ID: 1111, Name: test, Price: 65.00'),(114,'2025-03-30 16:59:14','DELETE','Product with ID: 1111 Name: test And Price: 65.00'),(115,'2025-03-30 21:05:28','INSERT','A new product was added with ID: 77, Name: new product, Price: 50.00'),(116,'2025-03-31 15:30:35','UPDATE','Product with ID: 77 was updated. Old Name: new product New Name: new product, Old Price: 50.00 New Price: 40.00'),(117,'2025-03-31 15:30:42','UPDATE','Product with ID: 77 was updated. Old Name: new product New Name: Hello, Old Price: 40.00 New Price: 40.00'),(118,'2025-03-31 15:31:04','DELETE','Product with ID: 77 Name: Hello And Price: 40.00'),(119,'2025-03-31 16:18:13','INSERT','A new product was added with ID: 6969, Name: test, Price: 44.00'),(120,'2025-03-31 16:23:22','DELETE','Product with ID: 6969 Name: test And Price: 44.00'),(121,'2025-04-04 13:51:42','invoice_created','Generated invoice 1 for order 93'),(122,'2025-04-04 13:53:30','invoice_created','Generated invoice 2 for order 94'),(123,'2025-04-04 15:05:59','faktura betald','Faktura: 1 was paid'),(124,'2025-04-04 15:19:33','faktura betald','Faktura: 2 was paid on 2025-04-04'),(125,'2025-04-04 15:20:14','faktura betald','Faktura: 1 was paid on 2025-04-04'),(126,'2025-04-04 16:32:43','invoice_created','Generated invoice 3 for order 95'),(127,'2025-04-04 17:36:26','faktura betald','Faktura: 3 was paid on 2025-04-04'),(128,'2025-04-04 17:41:42','INSERT','A new product was added with ID: 1337, Name: Test, Price: 420.00'),(129,'2025-04-04 17:42:07','UPDATE','Product with ID: 1337 was updated. Old Name: Test New Name: Test, Old Price: 420.00 New Price: 999.00'),(130,'2025-04-04 17:48:41','invoice_created','Generated invoice 4 for order 96'),(131,'2025-04-04 17:51:20','faktura betald','Faktura: 4 was paid on 2025-04-04'),(132,'2025-04-04 17:56:34','UPDATE','Product with ID: 1337 was updated. Old Name: Test New Name: Test, Old Price: 999.00 New Price: 777.00'),(133,'2025-04-04 17:59:00','invoice_created','Generated invoice 5 for order 97'),(134,'2025-04-04 18:06:46','DELETE','Product with ID: 1337 Name: Test And Price: 777.00');
/*!40000 ALTER TABLE `logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=115 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (7,2,13135,2),(8,2,41295,1),(9,2,90720,3),(10,19,90720,1),(11,20,90720,2),(12,21,13135,1),(13,21,27515,1),(14,21,41295,5),(15,22,13135,2),(16,22,27515,3),(17,23,27515,5),(18,24,90720,2),(19,25,90720,3),(20,26,90720,2),(21,27,90720,2),(22,28,90720,2),(23,29,13135,2),(24,29,27515,2),(25,29,69585,3),(26,29,89340,2),(27,30,41295,2),(28,30,69585,4),(29,30,90720,3),(30,31,41295,2),(31,31,69585,4),(32,31,90720,3),(33,32,41295,1),(34,32,89340,2),(35,32,90720,1),(36,33,27515,10),(37,34,13135,48),(38,35,27515,51),(39,36,27515,4),(40,37,27515,3),(41,38,41295,3),(42,39,27515,2),(43,40,13135,2),(44,41,27515,3),(45,42,27515,4),(46,42,69585,3),(47,43,27515,2),(48,44,13135,5),(49,44,41295,5),(51,46,41295,5),(52,47,13135,313),(53,48,13135,194),(54,49,13135,50),(55,50,13135,5),(56,51,13135,5),(57,52,13135,5),(58,53,13135,5),(59,54,13135,5),(60,55,13135,5),(61,56,13135,5),(62,57,13135,6),(63,58,13135,800),(64,59,13135,5),(65,60,13135,5),(66,61,13135,5),(67,62,13135,100),(68,63,13135,5),(69,64,13135,5),(70,65,13135,5),(71,66,13135,5),(72,67,13135,5),(73,68,13135,5),(74,69,13135,5),(75,70,13135,5),(76,71,13135,5),(77,72,13135,5),(78,73,13135,5),(79,74,13135,5),(80,75,13135,5),(81,76,13135,5),(82,77,13135,5),(83,78,13135,5),(84,85,13135,5),(85,86,13135,5),(86,86,27515,4),(87,86,41295,4),(88,86,45425,3),(89,86,69585,4),(90,87,41295,3),(91,88,13135,400),(92,89,13135,300),(93,89,27515,6),(94,89,41295,2),(95,89,45425,2),(96,90,27515,3),(97,90,41295,2),(98,91,13135,3),(99,91,27515,2),(100,92,13135,4),(101,92,27515,3),(102,93,41295,3),(103,93,45425,2),(104,94,45425,2),(105,94,89340,5),(106,94,90720,2),(107,95,41295,4),(108,95,45425,3),(109,95,69585,2),(111,96,13135,2),(112,96,41295,3),(114,97,13135,3);
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `customer_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `ordered_at` datetime DEFAULT NULL,
  `shipped_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=98 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,5,'2025-03-12 19:05:53',NULL,NULL,'2025-03-12 19:05:53',NULL),(2,5,'2025-03-13 14:57:00',NULL,NULL,NULL,NULL),(3,5,'2025-03-13 20:08:55',NULL,NULL,'2025-03-13 20:08:55',NULL),(4,5,'2025-03-13 20:09:26',NULL,NULL,'2025-03-13 20:09:26',NULL),(5,5,'2025-03-13 20:10:08',NULL,NULL,'2025-03-13 20:10:08',NULL),(6,5,'2025-03-13 20:10:55',NULL,NULL,'2025-03-13 20:10:55',NULL),(7,5,'2025-03-13 20:12:01',NULL,NULL,'2025-03-13 20:12:01',NULL),(8,5,'2025-03-13 20:15:14',NULL,NULL,'2025-03-13 20:15:14',NULL),(9,5,'2025-03-13 20:18:04',NULL,NULL,'2025-03-13 20:18:04',NULL),(10,5,'2025-03-13 20:18:19',NULL,NULL,'2025-03-13 20:18:19',NULL),(11,5,'2025-03-13 20:18:19',NULL,NULL,'2025-03-13 20:18:19',NULL),(12,5,'2025-03-13 20:18:19',NULL,NULL,'2025-03-13 20:18:19',NULL),(13,5,'2025-03-13 20:18:31',NULL,NULL,'2025-03-13 20:18:31',NULL),(14,5,'2025-03-13 20:20:46',NULL,NULL,'2025-03-13 20:20:46',NULL),(15,5,'2025-03-13 20:21:44',NULL,NULL,'2025-03-13 20:21:44',NULL),(16,5,'2025-03-13 20:23:15',NULL,NULL,'2025-03-13 20:23:15',NULL),(17,5,'2025-03-13 20:25:06',NULL,NULL,'2025-03-13 20:25:06',NULL),(18,5,'2025-03-13 20:27:06',NULL,NULL,'2025-03-13 20:27:06',NULL),(19,5,'2025-03-13 20:27:39',NULL,NULL,'2025-03-13 20:27:39',NULL),(20,1,'2025-03-13 20:30:49',NULL,NULL,'2025-03-13 20:30:49',NULL),(21,3,'2025-03-13 20:31:36',NULL,NULL,'2025-03-13 20:31:36',NULL),(22,4,'2025-03-13 20:33:46',NULL,NULL,'2025-03-13 20:33:46','2025-03-15 11:33:11'),(23,2,'2025-03-13 20:35:24',NULL,NULL,'2025-03-13 20:35:24',NULL),(24,2,'2025-03-13 20:37:23',NULL,NULL,'2025-03-13 20:37:23',NULL),(25,5,'2025-03-13 20:43:50',NULL,NULL,'2025-03-13 20:43:50',NULL),(26,5,'2025-03-13 20:44:24',NULL,NULL,'2025-03-13 20:44:24',NULL),(27,2,'2025-03-13 20:45:12',NULL,NULL,'2025-03-13 20:45:12',NULL),(28,1,'2025-03-13 20:46:17',NULL,NULL,'2025-03-13 20:46:17',NULL),(29,5,'2025-03-13 20:47:06',NULL,NULL,'2025-03-13 20:47:06',NULL),(30,5,'2025-03-13 20:57:37',NULL,NULL,'2025-03-13 20:57:37',NULL),(31,5,'2025-03-13 21:05:43',NULL,NULL,'2025-03-13 21:05:43','2025-04-01 22:13:38'),(32,1,'2025-03-13 22:05:58',NULL,NULL,'2025-03-13 22:05:58','2025-04-01 22:14:44'),(33,1,'2025-03-13 22:08:17',NULL,NULL,'2025-03-13 22:08:17','2025-03-15 11:39:10'),(34,1,'2025-03-15 10:38:35',NULL,NULL,'2025-03-15 10:38:35','2025-04-01 22:15:17'),(35,1,'2025-03-15 11:16:29',NULL,NULL,'2025-03-15 11:16:29','2025-04-01 22:15:33'),(36,1,'2025-03-25 20:33:58',NULL,NULL,'2025-03-25 20:33:58',NULL),(37,1,'2025-03-25 20:37:12',NULL,NULL,'2025-03-25 20:37:12','2025-04-01 22:48:54'),(38,1,'2025-03-25 20:37:32',NULL,NULL,'2025-03-25 20:37:32',NULL),(39,1,'2025-03-25 20:40:49',NULL,NULL,'2025-03-25 20:40:49',NULL),(40,1,'2025-03-25 20:48:22',NULL,NULL,'2025-03-25 20:48:22',NULL),(41,1,'2025-03-25 20:49:00',NULL,NULL,'2025-03-25 20:49:00','2025-04-01 22:50:42'),(42,2,'2025-03-25 20:49:34',NULL,NULL,'2025-03-25 20:49:34',NULL),(43,2,'2025-03-25 20:50:03',NULL,NULL,'2025-03-25 20:50:03','2025-04-01 22:40:34'),(44,5,'2025-03-26 20:49:45',NULL,NULL,'2025-03-26 20:49:45','2025-03-31 20:33:37'),(45,5,'2025-03-26 21:01:13',NULL,NULL,'2025-03-26 21:01:13',NULL),(46,2,'2025-03-27 14:03:30',NULL,NULL,'2025-03-27 14:03:30','2025-03-27 14:06:21'),(47,1,'2025-03-31 21:02:04',NULL,NULL,'2025-03-31 21:02:04','2025-04-01 22:30:33'),(48,4,'2025-03-31 21:02:33',NULL,NULL,'2025-03-31 21:02:33','2025-04-01 22:21:48'),(49,2,'2025-04-01 21:49:32',NULL,NULL,'2025-04-01 21:49:32','2025-04-01 22:25:37'),(50,1,'2025-04-01 22:18:54',NULL,NULL,'2025-04-01 22:18:54','2025-04-01 22:21:24'),(51,2,'2025-04-01 22:23:37',NULL,NULL,'2025-04-01 22:23:37','2025-04-01 22:25:14'),(52,1,'2025-04-01 22:33:01',NULL,NULL,'2025-04-01 22:33:01','2025-04-01 22:38:28'),(53,1,'2025-04-01 22:52:16',NULL,NULL,'2025-04-01 22:52:16','2025-04-01 22:57:49'),(54,1,'2025-04-01 22:58:14',NULL,NULL,'2025-04-01 22:58:14','2025-04-01 22:58:18'),(55,1,'2025-04-01 23:02:06',NULL,NULL,'2025-04-01 23:02:06','2025-04-01 23:02:10'),(56,1,'2025-04-01 23:02:47',NULL,NULL,'2025-04-01 23:02:47','2025-04-01 23:09:59'),(57,1,'2025-04-01 23:10:28',NULL,NULL,'2025-04-01 23:10:28','2025-04-01 23:10:42'),(58,1,'2025-04-01 23:17:58',NULL,NULL,'2025-04-01 23:17:58',NULL),(59,1,'2025-04-01 23:20:30',NULL,NULL,'2025-04-01 23:20:30',NULL),(60,1,'2025-04-01 23:22:51',NULL,NULL,'2025-04-01 23:22:51',NULL),(61,1,'2025-04-01 23:24:00',NULL,NULL,'2025-04-01 23:24:00',NULL),(62,1,'2025-04-01 23:24:19',NULL,NULL,'2025-04-01 23:24:19',NULL),(63,1,'2025-04-01 23:25:26',NULL,NULL,'2025-04-01 23:25:26',NULL),(64,1,'2025-04-01 23:29:33',NULL,NULL,'2025-04-01 23:29:33',NULL),(65,1,'2025-04-01 23:29:55',NULL,NULL,'2025-04-01 23:29:55',NULL),(66,1,'2025-04-01 23:31:30',NULL,NULL,'2025-04-01 23:31:30',NULL),(67,1,'2025-04-01 23:33:11',NULL,NULL,'2025-04-01 23:33:11',NULL),(68,1,'2025-04-01 23:33:56',NULL,NULL,'2025-04-01 23:33:56',NULL),(69,1,'2025-04-01 23:34:23',NULL,NULL,'2025-04-01 23:34:23',NULL),(70,1,'2025-04-01 23:36:03',NULL,NULL,'2025-04-01 23:36:03',NULL),(71,1,'2025-04-01 23:36:42',NULL,NULL,'2025-04-01 23:36:42',NULL),(72,1,'2025-04-01 23:36:50',NULL,NULL,'2025-04-01 23:36:50',NULL),(73,1,'2025-04-01 23:41:14',NULL,NULL,'2025-04-01 23:41:14',NULL),(74,1,'2025-04-01 23:41:40',NULL,NULL,'2025-04-01 23:41:40',NULL),(75,1,'2025-04-01 23:47:18',NULL,NULL,'2025-04-01 23:47:18',NULL),(76,1,'2025-04-01 23:48:02',NULL,NULL,'2025-04-01 23:48:02',NULL),(77,1,'2025-04-01 23:49:38',NULL,NULL,'2025-04-01 23:49:38',NULL),(78,1,'2025-04-01 23:50:33',NULL,NULL,'2025-04-01 23:50:33',NULL),(79,1,'2025-04-01 23:52:37',NULL,NULL,'2025-04-01 23:52:37',NULL),(80,1,'2025-04-01 23:54:50',NULL,NULL,'2025-04-01 23:54:50',NULL),(81,1,'2025-04-01 23:55:44',NULL,NULL,'2025-04-01 23:55:44',NULL),(82,1,'2025-04-01 23:57:44',NULL,NULL,'2025-04-01 23:57:44',NULL),(83,1,'2025-04-01 23:58:04',NULL,NULL,'2025-04-01 23:58:04',NULL),(84,1,'2025-04-02 00:00:51',NULL,NULL,'2025-04-02 00:00:51',NULL),(85,1,'2025-04-02 00:05:32',NULL,NULL,'2025-04-02 00:05:32','2025-04-02 00:55:50'),(86,3,'2025-04-02 00:29:27',NULL,NULL,'2025-04-02 00:29:27','2025-04-02 00:46:04'),(87,1,'2025-04-02 00:50:30',NULL,NULL,'2025-04-02 00:50:30','2025-04-02 00:50:36'),(88,1,'2025-04-02 00:53:39',NULL,NULL,'2025-04-02 00:53:39','2025-04-02 00:53:44'),(89,1,'2025-04-02 00:54:44',NULL,NULL,'2025-04-02 00:54:44','2025-04-02 00:55:20'),(90,1,'2025-04-02 00:56:11',NULL,NULL,'2025-04-02 00:56:11','2025-04-02 00:56:15'),(91,1,'2025-04-02 00:56:44',NULL,NULL,'2025-04-02 00:56:44','2025-04-02 00:56:50'),(92,1,'2025-04-04 15:30:09',NULL,NULL,'2025-04-04 15:30:09','2025-04-04 15:30:51'),(93,2,'2025-04-04 15:42:26',NULL,NULL,'2025-04-04 15:42:26','2025-04-04 15:51:42'),(94,4,'2025-04-04 15:53:26',NULL,NULL,'2025-04-04 15:53:26','2025-04-04 15:53:30'),(95,5,'2025-04-04 18:32:37',NULL,NULL,'2025-04-04 18:32:37','2025-04-04 18:32:43'),(96,1,'2025-04-04 19:44:36',NULL,NULL,'2025-04-04 19:44:36','2025-04-04 19:48:41'),(97,5,'2025-04-04 19:58:20',NULL,NULL,'2025-04-04 19:58:20','2025-04-04 19:59:00');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`dbadm`@`%`*/ /*!50003 TRIGGER generate_invoice_after_shipment
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
    IF NEW.shipped_at IS NOT NULL AND (OLD.shipped_at IS NULL OR OLD.shipped_at != NEW.shipped_at) THEN
        
        INSERT INTO faktura (order_id, invoice_date, total_amount)
        VALUES (
            NEW.id,
            NOW(),
            (SELECT COALESCE(SUM(oi.quantity * p.price), 0)  
            FROM order_items oi
            JOIN product p ON oi.product_id = p.id
            WHERE order_id = NEW.id)
        );

        SET @invoice_id = LAST_INSERT_ID();

        
        INSERT INTO faktura_lines(
            invoice_id,
            line_number,
            product_id,
            product_name,
            quantity,
            unit_price,
            line_total
        )
        SELECT
            @invoice_id,
            ROW_NUMBER() OVER (),
            oi.product_id,
            p.name,
            oi.quantity,
            p.price,
            (oi.quantity * p.price)
        FROM
            order_items oi
        JOIN 
            product p ON oi.product_id = p.id
        WHERE
            oi.order_id = NEW.id;

        
        INSERT INTO logs (event_type, description)
        VALUES (
            'invoice_created',
            CONCAT('Generated invoice ', @invoice_id, ' for order ', NEW.id)  
        );
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (13135,'Coffee',69.00),(27515,'Chocolate',59.00),(41295,'Tea',49.00),(45425,'Espresso',59.00),(69585,'Americanos',69.00),(89340,'Refresher',59.00),(90720,'Lemonade',59.00);
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`dbadm`@`%`*/ /*!50003 TRIGGER log_product_insert
AFTER INSERT ON product
FOR EACH ROW
BEGIN
    INSERT INTO logs (event_type, description)
    VALUES ('INSERT', CONCAT('A new product was added with ID: ', new.id, ', Name: ', new.name, ', Price: ', new.price));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`dbadm`@`%`*/ /*!50003 TRIGGER log_product_update
AFTER UPDATE ON product
FOR EACH ROW
BEGIN
    INSERT INTO logs (event_type, description)
    VALUES ('UPDATE', CONCAT('Product with ID: ', old.id, ' was updated. Old Name: ', old.name, ' New Name: '
    , new.name, ', Old Price: ', old.price, ' New Price: ', new.price));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`dbadm`@`%`*/ /*!50003 TRIGGER log_product_delete
AFTER DELETE ON product
FOR EACH ROW
BEGIN
    INSERT INTO logs (event_type, description)
    VALUES ('DELETE', CONCAT('Product with ID: ', old.id, ' Name: ', old.name, ' And Price: ', old.price));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `productcategory`
--

DROP TABLE IF EXISTS `productcategory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `productcategory` (
  `product_id` int(11) NOT NULL,
  `category_type` char(50) NOT NULL,
  PRIMARY KEY (`product_id`,`category_type`),
  KEY `category_type` (`category_type`),
  CONSTRAINT `productcategory_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE,
  CONSTRAINT `productcategory_ibfk_2` FOREIGN KEY (`category_type`) REFERENCES `category` (`namn`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productcategory`
--

LOCK TABLES `productcategory` WRITE;
/*!40000 ALTER TABLE `productcategory` DISABLE KEYS */;
INSERT INTO `productcategory` VALUES (89340,'Beverages'),(90720,'Beverages'),(13135,'Caffeinated'),(45425,'Caffeinated'),(69585,'Caffeinated'),(13135,'Cold'),(41295,'Cold'),(45425,'Cold'),(89340,'Cold'),(90720,'Cold'),(13135,'Hot'),(27515,'Hot'),(41295,'Hot'),(45425,'Hot'),(69585,'Hot'),(27515,'Non-Caffeinated'),(41295,'Non-Caffeinated'),(45425,'Non-Caffeinated'),(89340,'Non-Caffeinated'),(90720,'Non-Caffeinated');
/*!40000 ALTER TABLE `productcategory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `storage`
--

DROP TABLE IF EXISTS `storage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `storage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 0,
  `shelf_location` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `storage_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `storage`
--

LOCK TABLES `storage` WRITE;
/*!40000 ALTER TABLE `storage` DISABLE KEYS */;
INSERT INTO `storage` VALUES (8,27515,5,'ShelfA1'),(9,13135,108,'ShelfA1'),(10,45425,34,'ShelfB2'),(11,69585,8,'ShelfB2'),(12,41295,4,'ShelfC1'),(13,89340,111,'ShelfD2'),(14,90720,79,'ShelfD2'),(56,13135,294,'ShelfC2'),(61,13135,276,'ShelfC3');
/*!40000 ALTER TABLE `storage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'eshop'
--

--
-- Dumping routines for database 'eshop'
--
/*!50003 DROP FUNCTION IF EXISTS `get_timestamp` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dbadm`@`%` FUNCTION `get_timestamp`(status VARCHAR(50),
    created_at DATETIME,
    updated_at DATETIME,
    deleted_at DATETIME,
    ordered_at DATETIME,
    shipped_at DATETIME
) RETURNS datetime
    DETERMINISTIC
BEGIN
    IF status = 'Skickad' THEN
        RETURN shipped_at;
    ELSEIF status = 'Beställd' THEN
        RETURN ordered_at;
    ELSEIF status = 'Raderad' THEN
        RETURN deleted_at;
    ELSEIF status = 'Uppdaterad' THEN
        RETURN updated_at;
    ELSE
        RETURN created_at;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `order_status` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dbadm`@`%` FUNCTION `order_status`(created_at DATETIME,
    updated_at DATETIME,
    deleted_at DATETIME,
    ordered_at DATETIME,
    shipped_at DATETIME
) RETURNS varchar(20) CHARSET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci
    DETERMINISTIC
BEGIN
    IF shipped_at IS NOT NULL THEN
        RETURN 'Skickad';
    ELSEIF ordered_at IS NOT NULL THEN
        RETURN 'Beställd';
    ELSEIF deleted_at IS NOT NULL THEN
        RETURN 'Raderad';
    ELSEIF updated_at IS NOT NULL THEN
        RETURN 'Uppdaterad';
    ELSE
        RETURN 'Skapad';
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `storage_availability` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dbadm`@`%` FUNCTION `storage_availability`(quantity INT, orderd INT) RETURNS varchar(20) CHARSET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci
    DETERMINISTIC
BEGIN
    DECLARE enough INT;
    SET enough = quantity - orderd;

    IF enough < 0 THEN 
        RETURN 'NOT-ENOUGH-ITEMS';
    ELSEIF quantity >= 1 THEN 
        RETURN 'IN-STOCK';
    ELSE 
        RETURN 'OUT-OF-STOCK';
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `allafakturor` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dbadm`@`%` PROCEDURE `allafakturor`()
BEGIN
    SELECT
    invoice_id,
    order_id,
    DATE_FORMAT(invoice_date, '%Y-%m-%d %H:%i') AS invoice_date,
    total_amount,
    status,
    payment_date AS payment_date
    FROM faktura;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `all_order_details` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dbadm`@`%` PROCEDURE `all_order_details`(in input_id INT)
BEGIN
    SELECT
        oi.order_id ,
        p.name,
        oi.product_id,
        oi.quantity
    FROM order_items oi
    JOIN product p ON oi.product_id = p.id
    WHERE oi.order_id = input_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_product` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dbadm`@`%` PROCEDURE `delete_product`(IN product_id INT)
BEGIN
    DELETE FROM product WHERE id = product_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `fakturalines` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dbadm`@`%` PROCEDURE `fakturalines`(IN id INT)
BEGIN
    SELECT
    invoice_id,
    line_number,
    product_id,
    product_name,
    quantity,
    unit_price,
    line_total 
    FROM faktura_lines
    WHERE invoice_id = id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_all_products` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dbadm`@`%` PROCEDURE `get_all_products`()
BEGIN
    SELECT
    p.id,
    p.name,
    p.price,
    COALESCE(s.total_quantity, 0) AS quantity, 
    COALESCE(GROUP_CONCAT(DISTINCT pc.category_type ORDER BY pc.category_type ASC), 'None') AS category 
    FROM product p
    LEFT JOIN (
        SELECT product_id, SUM(quantity) AS total_quantity 
        FROM storage
        GROUP BY product_id
    ) s ON p.id = s.product_id
    LEFT JOIN productcategory pc ON p.id = pc.product_id 
    GROUP BY p.id, p.name, p.price;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_product` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dbadm`@`%` PROCEDURE `insert_product`(
    IN p_id INT, 
    IN p_name VARCHAR(255), 
    IN p_price DECIMAL(10,2)
)
BEGIN
    INSERT INTO product (id, name, price)
    VALUES (p_id, p_name, p_price);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_product_category` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dbadm`@`%` PROCEDURE `insert_product_category`(
    IN p_product_id INT, 
    IN p_category_type VARCHAR(255)
)
BEGIN
    INSERT INTO productcategory (product_id, category_type)
    VALUES (p_product_id, p_category_type);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_storage` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dbadm`@`%` PROCEDURE `insert_storage`(
    IN p_product_id INT, 
    IN p_quantity INT, 
    IN p_shelf_location VARCHAR(255)
)
BEGIN
    INSERT INTO storage (product_id, quantity, shelf_location)
    VALUES (p_product_id, p_quantity, p_shelf_location);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `inv_name_search` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dbadm`@`%` PROCEDURE `inv_name_search`(IN product_name VARCHAR(255))
BEGIN
    SELECT
        p.id,
        p.name,
        s.shelf_location
    FROM product p
    JOIN storage s ON p.id = s.product_id
    WHERE p.name = product_name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `inv_opsion` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dbadm`@`%` PROCEDURE `inv_opsion`()
BEGIN 
    SELECT
        p.id,
        p.name,
        COALESCE(s.shelf_location, 'Not Assigned') AS shelf_location,
        COALESCE(s.quantity, 0) AS quantity
    FROM product p 
    LEFT JOIN storage s ON p.id = s.product_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `linkcategory` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dbadm`@`%` PROCEDURE `linkcategory`(
    IN p_id INT,
    IN c_category VARCHAR(255)
)
BEGIN
    INSERT INTO productcategory (product_id,category_type)
    VALUES (p_id, c_category);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `logs_show_limit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dbadm`@`%` PROCEDURE `logs_show_limit`(IN numder INT)
BEGIN
    SELECT 
        id,
        DATE_FORMAT(timestamp, '%Y-%m-%d %H:%i:%s') AS formatted_timestamp,
        event_type,
        description
    FROM logs
    ORDER BY id DESC
    LIMIT numder;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `one_product` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dbadm`@`%` PROCEDURE `one_product`(IN product_id INT)
BEGIN 
    SELECT 
        * 
    FROM product
    WHERE id = product_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `orders` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dbadm`@`%` PROCEDURE `orders`()
BEGIN
    SELECT 
        o.id AS order_id,
        c.id AS customer_id,
        c.name AS customer_name,
        DATE_FORMAT(
            get_timestamp(
                order_status(o.created_at, o.updated_at, o.deleted_at, o.ordered_at, o.shipped_at),
                o.created_at, o.updated_at, o.deleted_at, o.ordered_at, o.shipped_at
            ), 
            '%Y-%m-%d %H:%i:%s'
        ) AS status_time,
        order_status(o.created_at, o.updated_at, o.deleted_at, o.ordered_at, o.shipped_at) AS status,
        COUNT(oi.id) AS order_items_count  
    FROM orders o
    JOIN customer c ON o.customer_id = c.id
    LEFT JOIN order_items oi ON o.id = oi.order_id  
    GROUP BY o.id, c.id  
    ORDER BY status_time DESC   
    LIMIT 20;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `orders_search` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dbadm`@`%` PROCEDURE `orders_search`(IN search INT)
BEGIN
    SELECT 
        o.id AS order_id,
        c.id AS customer_id,
        c.name AS customer_name,
        DATE_FORMAT(
            get_timestamp(
                order_status(o.created_at, o.updated_at, o.deleted_at, o.ordered_at, o.shipped_at),
                o.created_at, o.updated_at, o.deleted_at, o.ordered_at, o.shipped_at
            ), 
            '%Y-%m-%d %H:%i:%s' 
        ) AS status_time,
        order_status(o.created_at, o.updated_at, o.deleted_at, o.ordered_at, o.shipped_at) AS status,
        COUNT(oi.id) AS order_items_count 
    FROM orders o
    JOIN customer c ON o.customer_id = c.id
    LEFT JOIN order_items oi ON o.id = oi.order_id 
    WHERE o.id = search OR c.id = search  
    GROUP BY o.id, c.id, c.name, status_time, status 
    ORDER BY status_time DESC 
    LIMIT 20;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `paymentcli` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dbadm`@`%` PROCEDURE `paymentcli`(
    IN p_invoice_id INT,
    IN p_payment_date VARCHAR(255)
)
BEGIN
    UPDATE faktura
    SET 
        payment_date = p_payment_date,
        status = 'Betald'
    WHERE invoice_id = p_invoice_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `picklist` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dbadm`@`%` PROCEDURE `picklist`(IN orderid INT)
BEGIN
    SELECT
        oi.order_id,
        p.id,
        p.name,
        oi.quantity AS 'amount ordered',
        COALESCE(s.quantity, 0) AS inventory,
        s.shelf_location AS shelf,
        storage_availability(s.quantity, oi.quantity) as storage
    FROM order_items oi
    JOIN product p ON oi.product_id = p.id
    LEFT JOIN storage s ON oi.product_id = s.product_id
    WHERE oi.order_id = orderid;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `picklist1st` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dbadm`@`%` PROCEDURE `picklist1st`(IN orderid INT)
BEGIN
    SELECT
        oi.order_id,
        p.id,
        p.name,
        oi.quantity AS 'amount ordered',
        COALESCE(s.quantity, 0) AS inventory,
        s.shelf_location AS shelf,
        storage_availability(s.quantity, oi.quantity) as storage
    FROM order_items oi
    JOIN product p ON oi.product_id = p.id
    LEFT JOIN storage s ON oi.product_id = s.product_id
    WHERE oi.order_id = orderid
    AND s.quantity = (
        SELECT MAX(s2.quantity)  
        FROM storage s2
        WHERE s2.product_id = s.product_id
    )
    GROUP BY p.id, oi.order_id, oi.quantity, p.name, s.shelf_location, s.quantity, storage_availability(s.quantity, oi.quantity);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `show_categorys` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dbadm`@`%` PROCEDURE `show_categorys`()
BEGIN 
    SELECT
        *
    FROM category;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `show_customers` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dbadm`@`%` PROCEDURE `show_customers`()
BEGIN
    SELECT
        *
    FROM customer;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `show_customers_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dbadm`@`%` PROCEDURE `show_customers_id`(
    in customer_id INT
)
BEGIN
SELECT
    id,
    name
FROM customer
WHERE id = customer_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `show_one_product` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dbadm`@`%` PROCEDURE `show_one_product`(IN product_id INT)
BEGIN 
    SELECT 
        p.*, pc.category_type
    FROM product p
    JOIN productcategory pc ON p.id = pc.product_id
    WHERE p.id = product_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `show_storage` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dbadm`@`%` PROCEDURE `show_storage`()
BEGIN
    SELECT
        DISTINCT shelf_location
    FROM storage;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_product` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dbadm`@`%` PROCEDURE `update_product`(IN p_id INT, IN p_name VARCHAR(255), IN p_price DECIMAL(10,2))
BEGIN 
    UPDATE product
    SET name = p_name, price = p_price
    WHERE id = p_id;
    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_storage_quantity` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dbadm`@`%` PROCEDURE `update_storage_quantity`(
    IN p_product_id INT,
    IN p_quantity INT,
    IN p_shelf_loc TEXT 
)
BEGIN
    
    IF EXISTS (SELECT 1 FROM product WHERE id = p_product_id) THEN
        
        
        IF EXISTS (
            SELECT 1 FROM storage 
            WHERE product_id = p_product_id 
            AND shelf_location = p_shelf_loc
        ) THEN
            
            UPDATE storage
            SET quantity = GREATEST(quantity + p_quantity, 0) 
            WHERE product_id = p_product_id 
            AND shelf_location = p_shelf_loc;
        ELSE
            
            INSERT INTO storage (product_id, quantity, shelf_location)
            VALUES (p_product_id, GREATEST(p_quantity, 0), p_shelf_loc);
        END IF;
        
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Product does not exist, cannot update storage.';
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_to_shipped` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dbadm`@`%` PROCEDURE `update_to_shipped`(IN orderid INT)
BEGIN
    UPDATE orders
    SET shipped_at = NOW()
    WHERE id = orderid;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-05 19:07:02

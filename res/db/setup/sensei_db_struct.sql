-- MySQL dump 10.13  Distrib 5.5.43, for debian-linux-gnu (armv7l)
--
-- Host: localhost    Database: sensei
-- ------------------------------------------------------
-- Server version	5.5.43-0+deb7u1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `_history_sensors_log`
--

DROP TABLE IF EXISTS `_history_sensors_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `_history_sensors_log` (
  `EventTime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `SensorName` varchar(40) NOT NULL DEFAULT '',
  `SensorValue` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `_history_sensors_values`
--

DROP TABLE IF EXISTS `_history_sensors_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `_history_sensors_values` (
  `DateField` bigint(20) NOT NULL,
  `SensorName` varchar(16) NOT NULL DEFAULT '',
  `Measure` varchar(20) NOT NULL DEFAULT '',
  `Unit` varchar(4) DEFAULT NULL,
  `Value` decimal(6,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `app_log`
--

DROP TABLE IF EXISTS `app_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `app_log` (
  `Row` varchar(250) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `calendar_d`
--

DROP TABLE IF EXISTS `calendar_d`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `calendar_d` (
  `datefield` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`datefield`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `calendar_h`
--

DROP TABLE IF EXISTS `calendar_h`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `calendar_h` (
  `datefield` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`datefield`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `calendar_m`
--

DROP TABLE IF EXISTS `calendar_m`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `calendar_m` (
  `datefield` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`datefield`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `calendar_s`
--

DROP TABLE IF EXISTS `calendar_s`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `calendar_s` (
  `datefield` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`datefield`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `commands_log`
--

DROP TABLE IF EXISTS `commands_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `commands_log` (
  `EventTime` datetime DEFAULT NULL,
  `CommandName` varchar(20) DEFAULT NULL,
  `ReturnText` varchar(40) DEFAULT NULL,
  `ReturnValue` decimal(10,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sensors_log`
--

DROP TABLE IF EXISTS `sensors_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sensors_log` (
  `EventTime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `SensorName` varchar(40) NOT NULL DEFAULT '',
  `SensorValue` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`EventTime`,`SensorName`),
  KEY `EventTime` (`EventTime`),
  KEY `SensorName` (`SensorName`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `Parse` AFTER INSERT ON `sensors_log`
 FOR EACH ROW BEGIN
      INSERT IGNORE INTO sensors_values (DateField,SensorName,Measure,Unit,Value)
      VALUES (
        (NEW.EventTime + 0), 
         CONCAT(
                      TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(NEW.SensorName,'<',-1),'>',1)),
                       '>',
                       TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(NEW.SensorName,'(',-1),')',1))
         ),         
         TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(NEW.SensorName,'>',-1),'(',1)),
         TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(NEW.SensorName,'{',-1),'}',1)),
         TRIM(NEW.SensorValue)
     ); 
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `sensors_values`
--

DROP TABLE IF EXISTS `sensors_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sensors_values` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `DateField` bigint(20) NOT NULL,
  `SensorName` varchar(16) NOT NULL DEFAULT '',
  `Measure` varchar(20) NOT NULL DEFAULT '',
  `Unit` varchar(4) DEFAULT NULL,
  `Value` decimal(6,2) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UniqueValuePerSensorPerSecond` (`DateField`,`SensorName`,`Measure`),
  KEY `SensorName` (`SensorName`,`Measure`),
  KEY `DateField` (`DateField`),
  KEY `SensorName_Measure_DF` (`SensorName`,`Measure`,`DateField`)
) ENGINE=InnoDB AUTO_INCREMENT=11070408 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sensors_values_h`
--

DROP TABLE IF EXISTS `sensors_values_h`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sensors_values_h` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `DateField` bigint(20) NOT NULL,
  `SensorName` varchar(16) NOT NULL DEFAULT '',
  `Measure` varchar(20) NOT NULL DEFAULT '',
  `Unit` varchar(4) DEFAULT NULL,
  `Value` decimal(6,2) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UniqueValuePerSensorPerSecond` (`DateField`,`SensorName`,`Measure`),
  KEY `SensorName` (`SensorName`,`Measure`),
  KEY `DateField` (`DateField`),
  KEY `SensorName_Measure_DF` (`SensorName`,`Measure`,`DateField`)
) ENGINE=InnoDB AUTO_INCREMENT=1570716 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sensors_values_m`
--

DROP TABLE IF EXISTS `sensors_values_m`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sensors_values_m` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `DateField` bigint(20) NOT NULL,
  `SensorName` varchar(16) NOT NULL DEFAULT '',
  `Measure` varchar(20) NOT NULL DEFAULT '',
  `Unit` varchar(4) DEFAULT NULL,
  `Value` decimal(6,2) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UniqueValuePerSensorPerSecond` (`DateField`,`SensorName`,`Measure`),
  KEY `SensorName` (`SensorName`,`Measure`),
  KEY `DateField` (`DateField`),
  KEY `SensorName_Measure_DF` (`SensorName`,`Measure`,`DateField`)
) ENGINE=InnoDB AUTO_INCREMENT=3451176 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'sensei'
--
/*!50003 DROP PROCEDURE IF EXISTS `fill_calendar_d` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `fill_calendar_d`(start_date DATETIME, end_date DATETIME)
BEGIN
  DECLARE crt_date DATETIME;
  SET crt_date = start_date;
  WHILE crt_date < end_date DO
    INSERT IGNORE INTO calendar_d VALUES(DATE_FORMAT(crt_date,'%Y%m%d000000')+0);
    SET crt_date = ADDDATE(crt_date, INTERVAL 1 DAY);
  END WHILE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `fill_calendar_h` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `fill_calendar_h`(start_date DATETIME, end_date DATETIME)
BEGIN
  DECLARE crt_date DATETIME;
  SET crt_date =  start_date;
  WHILE crt_date < end_date DO  
    INSERT IGNORE INTO calendar_h VALUES(DATE_FORMAT(crt_date,'%Y%m%d%H0000')+0);
    SET crt_date = ADDDATE(crt_date, INTERVAL 1 HOUR);
  END WHILE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `fill_calendar_m` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `fill_calendar_m`(start_date DATETIME, end_date DATETIME)
BEGIN
  DECLARE crt_date DATETIME;
  SET crt_date =  start_date;
  WHILE crt_date < end_date DO
    INSERT IGNORE INTO calendar_m VALUES(DATE_FORMAT(crt_date,'%Y%m%d%H%i00')+0);
    SET crt_date = ADDDATE(crt_date, INTERVAL 1 MINUTE);
  END WHILE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `fill_calendar_s` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `fill_calendar_s`(start_date DATETIME, end_date DATETIME)
BEGIN
  DECLARE crt_date DATETIME;
  SET crt_date =  start_date;
  WHILE crt_date < end_date DO
    INSERT IGNORE INTO calendar_s VALUES(DATE_FORMAT(crt_date,'%Y%m%d%H%i%s')+0);
    SET crt_date = ADDDATE(crt_date, INTERVAL 1 SECOND);
  END WHILE;
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

-- Dump completed on 2015-06-10 16:08:54

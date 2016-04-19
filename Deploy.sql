-- MySQL dump 10.13  Distrib 5.7.9, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: PicsRating
-- ------------------------------------------------------
-- Server version	5.5.46-log

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
-- Table structure for table `Galleries`
--

DROP TABLE IF EXISTS `Galleries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Galleries` (
  `GalleryID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(45) DEFAULT NULL,
  `Description` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`GalleryID`),
  UNIQUE KEY `Name_UNIQUE` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `GalleryPics`
--

DROP TABLE IF EXISTS `GalleryPics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `GalleryPics` (
  `GallID` int(11) NOT NULL,
  `PicID` int(11) NOT NULL,
  PRIMARY KEY (`GallID`,`PicID`),
  KEY `galpics_picid_idx` (`PicID`),
  CONSTRAINT `galpics_galid` FOREIGN KEY (`GallID`) REFERENCES `Galleries` (`GalleryID`) ON UPDATE CASCADE,
  CONSTRAINT `galpics_picid` FOREIGN KEY (`PicID`) REFERENCES `Pics` (`PicID`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Pics`
--

DROP TABLE IF EXISTS `Pics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Pics` (
  `PicID` int(11) NOT NULL AUTO_INCREMENT,
  `URL` varchar(300) NOT NULL,
  `Caption` varchar(300) DEFAULT NULL,
  `Name` varchar(45) NOT NULL,
  PRIMARY KEY (`PicID`),
  UNIQUE KEY `Name_UNIQUE` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Voter`
--

DROP TABLE IF EXISTS `Voter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Voter` (
  `VoterID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` char(45) NOT NULL,
  `VoterSignature` char(30) DEFAULT NULL,
  PRIMARY KEY (`VoterID`),
  UNIQUE KEY `name_sig_unique` (`Name`,`VoterSignature`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Votes`
--

DROP TABLE IF EXISTS `Votes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Votes` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `GalleryID` int(11) NOT NULL,
  `VoterID` int(11) NOT NULL,
  `winPicID` int(11) NOT NULL,
  `losePicID` int(11) NOT NULL,
  `Signature` char(30) NOT NULL,
  `time` datetime NOT NULL,
  `quality` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `Vots_galID_idx` (`GalleryID`),
  KEY `Votes_winPicID_idx` (`winPicID`),
  KEY `Votes_losePicID_idx` (`losePicID`),
  KEY `Votes_voterID_idx` (`VoterID`),
  CONSTRAINT `Votes_galID` FOREIGN KEY (`GalleryID`) REFERENCES `Galleries` (`GalleryID`) ON UPDATE CASCADE,
  CONSTRAINT `Votes_losePicID` FOREIGN KEY (`losePicID`) REFERENCES `Pics` (`PicID`) ON UPDATE CASCADE,
  CONSTRAINT `Votes_voterID` FOREIGN KEY (`VoterID`) REFERENCES `Voter` (`VoterID`) ON UPDATE CASCADE,
  CONSTRAINT `Votes_winPicID` FOREIGN KEY (`winPicID`) REFERENCES `Pics` (`PicID`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'PicsRating'
--
/*!50003 DROP PROCEDURE IF EXISTS `AddPicToGallery` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`netrex`@`localhost` PROCEDURE `AddPicToGallery`(gal_name varchar(45), pic_name varchar(45))
BEGIN
	DECLARE unexistent CONDITION FOR SQLSTATE '45000';
    DECLARE gal_id INT(11);
    DECLARE pic_id INT(11);
	
    START TRANSACTION;
		#Checking Gallery existance, fetching its ID
		SELECT GalleryID INTO gal_id FROM Galleries WHERE Name=gal_name;
		IF gal_id IS NULL THEN
			SIGNAL unexistent
			SET MESSAGE_TEXT = 'The gallery specified does not exist';
		END IF;
		
		#Checking Gallery existance, fetching its ID
		SELECT PicID INTO pic_id FROM Pics WHERE Name=pic_name;
		IF pic_id IS NULL THEN
			SIGNAL unexistent
			SET MESSAGE_TEXT = 'The picture specified does not exist';
		END IF;
		
		INSERT IGNORE INTO GalleryPics (GallID,PicID) VALUES (gal_id,pic_id);
    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GalleryRating` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`netrex`@`localhost` PROCEDURE `GalleryRating`(gal_name varchar(45))
BEGIN
	DECLARE unknown_gal CONDITION FOR SQLSTATE '45000';
	DECLARE gal_id INT(11);
    
    #Checking Gallery existance, fetching its ID
	SELECT GalleryID INTO gal_id FROM Galleries WHERE Name=gal_name;
	IF gal_id IS NULL THEN
		SIGNAL unknown_gal
	SET MESSAGE_TEXT = 'The gallery specified does not exist';
	END IF;
    
    DROP TEMPORARY TABLE IF EXISTS ids_table;
    
    CREATE TEMPORARY TABLE IF NOT EXISTS ids_table (
    `Id` INT NOT NULL, PRIMARY KEY (`Id`)) ENGINE=MEMORY; 

	INSERT INTO ids_table (`Id`)
		SELECT DISTINCT winPicID
			FROM Votes WHERE GalleryID=gal_id AND quality=0
		UNION SELECT DISTINCT losePicID
			FROM Votes WHERE GalleryID=gal_id AND quality=0;	
    
    SELECT
		p.Name,
		p.Caption,
        (SELECT COUNT(*) FROM Votes WHERE quality=0 AND GalleryID=gal_id AND winPicID=p.PicID) wins,
        (SELECT COUNT(*) FROM Votes WHERE quality=0 AND GalleryID=gal_id AND losePicID=p.PicID) loses,
        (SELECT COUNT(*) FROM Votes WHERE quality=0 AND GalleryID=gal_id AND winPicID=p.PicID)
			/(SELECT COUNT(*) FROM Votes WHERE quality=0 AND GalleryID=gal_id AND (losePicID=p.PicID OR winPicID=p.PicID)) win_rate,
		(SELECT COUNT(*) FROM Votes WHERE quality=0 AND GalleryID=gal_id AND winPicID=p.PicID)/
			(SELECT COUNT(*) FROM Votes WHERE quality=0 AND GalleryID=gal_id) gal_win_rate,
		(SELECT COUNT(*) FROM Votes WHERE quality=0 AND GalleryID=gal_id AND losePicID=p.PicID)/
			(SELECT COUNT(*) FROM Votes WHERE quality=0 AND GalleryID=gal_id) gal_lose_rate
    FROM Pics p
		INNER JOIN ids_table ids ON ids.`Id`=p.PicID
	ORDER BY gal_win_rate DESC, gal_lose_rate ASC;
        
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetGalPictures` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`netrex`@`localhost` PROCEDURE `GetGalPictures`(gal_name varchar(45))
BEGIN
	DECLARE unknown_gal CONDITION FOR SQLSTATE '45000';
	DECLARE gal_id INT(11);
    
    START TRANSACTION;
		#Checking Gallery existance, fetching its ID
		SELECT GalleryID INTO gal_id FROM Galleries WHERE Name=gal_name;
		IF gal_id IS NULL THEN
			SIGNAL unknown_gal
		SET MESSAGE_TEXT = 'The gallery specified does not exist';
		END IF;
        
        SELECT p.Name Name,p.Caption Caption, p.URL URL FROM GalleryPics gp INNER JOIN Pics p ON gp.PicID=p.PicID;
    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Vote` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`netrex`@`localhost` PROCEDURE `Vote`(
	voter_name varchar(45),
    voter_sig char(30),
    gal_name varchar(45),
    winPicture varchar(45),
    losePicture varchar(45),
    vote_sig char(30)
    )
    MODIFIES SQL DATA
BEGIN
	DECLARE unexistent CONDITION FOR SQLSTATE '45000';
	DECLARE voter_id INT(11);
    DECLARE gal_id INT(11);
    DECLARE winpic_id INT(11);
    DECLARE losepic_id INT(11);
    DECLARE matched_pics INT(11);
    
    START TRANSACTION;
		#Checking Gallery existance, fetching its ID
		SELECT GalleryID INTO gal_id FROM Galleries WHERE Name=gal_name;
		IF gal_id IS NULL THEN
			SIGNAL unexistent
			SET MESSAGE_TEXT = 'The gallery specified does not exist';
		END IF;
        
        SELECT PicID INTO winpic_id FROM Pics WHERE Name=winPicture;
		IF winpic_id IS NULL THEN
			SIGNAL unexistent
			SET MESSAGE_TEXT = 'The win picture specified does not exist';
		END IF;
        
        SELECT PicID INTO losepic_id FROM Pics WHERE Name=losePicture;
		IF losepic_id IS NULL THEN
			SIGNAL unexistent
			SET MESSAGE_TEXT = 'The lose picture specified does not exist';
		END IF;
        
        SELECT count(*) INTO matched_pics FROM GalleryPics WHERE GallID=gal_id AND (PicID=winpic_id OR PicID=losepic_id);
        IF matched_pics <2 THEN
			SIGNAL unexistent
			SET MESSAGE_TEXT = 'The pictures specified are not in the gallery you specified';
		END IF;
        
		#Fetching Voter id, regestering if needed
		SELECT VoterID INTO voter_id FROM Voter WHERE Name=voter_name AND VoterSignature=voter_sig;
		IF voter_id IS NULL THEN		
			INSERT INTO Voter (Name,VoterSignature) values (voter_name,voter_sig);
			SELECT VoterID INTO voter_id FROM Voter WHERE Name=voter_name AND VoterSignature=voter_sig;	        
		END IF;	
		DELETE FROM Votes WHERE
			VoterID=voter_id AND GalleryID=gal_id AND
			#removing any vote containig both pics from this voter and this gallery
			((winPicID=winpic_id AND losePicID=losepic_id) OR (winPicID=losepic_id AND losePicID=winpic_id));
		INSERT INTO Votes (GalleryID,VoterID,winPicID,losePicID,Signature,time) values
			(gal_id,voter_id,winpic_id,losepic_id,vote_sig, UTC_TIMESTAMP());
    COMMIT;
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

-- Dump completed on 2016-04-19 20:21:37

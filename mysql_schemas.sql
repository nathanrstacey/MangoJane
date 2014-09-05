-- MySQL dump 10.13  Distrib 5.1.66, for debian-linux-gnu (i686)
--
-- Host: localhost    Database: txtCLI
-- ------------------------------------------------------
-- Server version	5.1.66-0ubuntu0.11.10.3

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
-- Table structure for table `appSubscriptions`
--

DROP TABLE IF EXISTS `appSubscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `appSubscriptions` (
  `app` varchar(24) NOT NULL,
  `userName` varchar(24) NOT NULL,
  `whenDone` int(11) NOT NULL,
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `userApproved` tinyint(1) NOT NULL DEFAULT '0',
  `adminApproved` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=18 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `apps`
--

DROP TABLE IF EXISTS `apps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `apps` (
  `appName` varchar(24) NOT NULL,
  `pwd` varchar(100) DEFAULT NULL,
  `pwd_rights` tinytext,
  `admin1` varchar(100) NOT NULL,
  `admin2` varchar(100) DEFAULT NULL,
  `admin3` varchar(100) DEFAULT NULL,
  `security` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`appName`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `attachments`
--

DROP TABLE IF EXISTS `attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attachments` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `attachment` mediumblob NOT NULL,
  `timeCreated` int(11) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `blogList`
--

DROP TABLE IF EXISTS `blogList`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `blogList` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `appName` varchar(24) NOT NULL,
  `subAppName` varchar(24) NOT NULL,
  `security` varchar(10) NOT NULL,
  `poster1` varchar(100) DEFAULT NULL,
  `poster2` varchar(100) DEFAULT NULL,
  `poster3` varchar(100) DEFAULT NULL,
  `creator` varchar(100) DEFAULT NULL,
  `open` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=413 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `blogPosts`
--

DROP TABLE IF EXISTS `blogPosts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `blogPosts` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `appName` varchar(24) NOT NULL,
  `subAppName` varchar(24) NOT NULL,
  `post` text NOT NULL,
  `public` tinytext NOT NULL,
  `pointsMade` int(11) DEFAULT NULL,
  `pointsPossible` int(11) DEFAULT NULL,
  `cur_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `userName` varchar(100) NOT NULL,
  PRIMARY KEY (`ID`),
  FULLTEXT KEY `appName` (`appName`),
  FULLTEXT KEY `subAppName` (`subAppName`),
  FULLTEXT KEY `post` (`post`),
  FULLTEXT KEY `post_2` (`post`)
) ENGINE=MyISAM AUTO_INCREMENT=1212 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `blogSubscriptions`
--

DROP TABLE IF EXISTS `blogSubscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `blogSubscriptions` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `appName` varchar(24) NOT NULL,
  `subAppName` varchar(24) NOT NULL,
  `userName` varchar(100) NOT NULL,
  `subscribe_or_read` varchar(10) NOT NULL,
  `adminApproved` tinyint(1) DEFAULT '0',
  `userApproved` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=97 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `codeWord`
--

DROP TABLE IF EXISTS `codeWord`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `codeWord` (
  `word` varchar(100) NOT NULL,
  `cli` text,
  `userName` varchar(100) NOT NULL,
  PRIMARY KEY (`word`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lastEmailSent`
--

DROP TABLE IF EXISTS `lastEmailSent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lastEmailSent` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `theTo` varchar(100) NOT NULL,
  `theFrom` varchar(100) NOT NULL,
  `post` varchar(400) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=307 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sms2mmsEmails`
--

DROP TABLE IF EXISTS `sms2mmsEmails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sms2mmsEmails` (
  `smsDomain` varchar(100) NOT NULL,
  `mmsDomain` varchar(100) NOT NULL,
  PRIMARY KEY (`smsDomain`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tempCode`
--

DROP TABLE IF EXISTS `tempCode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tempCode` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `codeNumber` int(11) NOT NULL,
  `userName` varchar(100) NOT NULL,
  `code` text NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `userUsage`
--

DROP TABLE IF EXISTS `userUsage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `userUsage` (
  `userName` varchar(100) NOT NULL,
  `cur_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `currentString` text,
  `currentMoney` decimal(10,0) NOT NULL,
  `nickname` varchar(100) NOT NULL,
  PRIMARY KEY (`userName`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-01-21 18:42:08

CREATE DATABASE  IF NOT EXISTS `youtubedb` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `youtubedb`;
-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: youtubedb
-- ------------------------------------------------------
-- Server version	8.0.35

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
-- Table structure for table `channel_subscriptions`
--

DROP TABLE IF EXISTS `channel_subscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `channel_subscriptions` (
  `user_id` int NOT NULL,
  `channel_id` int NOT NULL,
  `subscribed_at` datetime NOT NULL,
  PRIMARY KEY (`user_id`,`channel_id`),
  KEY `channel_id` (`channel_id`),
  CONSTRAINT `channel_subscriptions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `channel_subscriptions_ibfk_2` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`channel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `channel_subscriptions`
--

LOCK TABLES `channel_subscriptions` WRITE;
/*!40000 ALTER TABLE `channel_subscriptions` DISABLE KEYS */;
INSERT INTO `channel_subscriptions` VALUES (1,1,'2024-01-11 15:23:04');
/*!40000 ALTER TABLE `channel_subscriptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `channels`
--

DROP TABLE IF EXISTS `channels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `channels` (
  `channel_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  `profile_picture_url` varchar(255) DEFAULT NULL,
  `banner_url` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`channel_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `channels`
--

LOCK TABLES `channels` WRITE;
/*!40000 ALTER TABLE `channels` DISABLE KEYS */;
INSERT INTO `channels` VALUES (1,'Borntodev','สร้างการเรียนรู้ที่ดีสำหรับสายไอที','https://yt3.googleusercontent.com/ytc/AIf8zZTx9WjLP2eL2nMMS_CUSSXxHn2vSav7eggLkZ3JMA=s176-c-k-c0x00ffffff-no-rj','https://yt3.googleusercontent.com/ytc/AIf8zZTx9WjLP2eL2nMMS_CUSSXxHn2vSav7eggLkZ3JMA=s176-c-k-c0x00ffffff-no-rj','2024-01-09 15:34:59','2024-01-09 15:34:59');
/*!40000 ALTER TABLE `channels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comments` (
  `comment_id` int NOT NULL AUTO_INCREMENT,
  `video_id` int NOT NULL,
  `user_id` int NOT NULL,
  `content` text,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`comment_id`),
  KEY `video_id` (`video_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`video_id`) REFERENCES `videos` (`video_id`),
  CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
INSERT INTO `comments` VALUES (1,1,1,'This is a comment by Aef.','2024-01-11 15:27:30','2024-01-11 15:27:30'),(2,1,2,'Comment from user 2','2024-01-11 16:10:00','2024-01-11 16:10:00'),(3,1,3,'Comment from user 3','2024-01-11 16:10:00','2024-01-11 16:10:00');
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `history`
--

DROP TABLE IF EXISTS `history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `history` (
  `user_id` int NOT NULL,
  `video_id` int NOT NULL,
  `watched_at` datetime NOT NULL,
  PRIMARY KEY (`user_id`,`video_id`),
  KEY `video_id` (`video_id`),
  CONSTRAINT `history_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `history_ibfk_2` FOREIGN KEY (`video_id`) REFERENCES `videos` (`video_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `history`
--

LOCK TABLES `history` WRITE;
/*!40000 ALTER TABLE `history` DISABLE KEYS */;
/*!40000 ALTER TABLE `history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `notification_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `content` text,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`notification_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `playlists`
--

DROP TABLE IF EXISTS `playlists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `playlists` (
  `playlist_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  `thumbnail_url` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`playlist_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `playlists`
--

LOCK TABLES `playlists` WRITE;
/*!40000 ALTER TABLE `playlists` DISABLE KEYS */;
/*!40000 ALTER TABLE `playlists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `popular`
--

DROP TABLE IF EXISTS `popular`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `popular` (
  `video_id` int NOT NULL,
  `view_count` int NOT NULL,
  `like_count` int NOT NULL,
  `dislike_count` int NOT NULL,
  `comment_count` int NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`video_id`),
  CONSTRAINT `popular_ibfk_1` FOREIGN KEY (`video_id`) REFERENCES `videos` (`video_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `popular`
--

LOCK TABLES `popular` WRITE;
/*!40000 ALTER TABLE `popular` DISABLE KEYS */;
INSERT INTO `popular` VALUES (1,1,500,50,200,'2024-01-09 15:59:24','2024-01-09 15:59:24'),(2,15,800,75,300,'2024-01-09 15:59:24','2024-01-09 15:59:24'),(3,200,1200,100,400,'2024-01-09 15:59:24','2024-01-09 15:59:24'),(4,8000,400,40,150,'2024-01-09 15:59:24','2024-01-09 15:59:24'),(5,25000,1500,125,500,'2024-01-09 15:59:24','2024-01-09 15:59:24'),(6,30000000,150,15,50,'2024-01-09 15:59:24','2024-01-09 15:59:24');
/*!40000 ALTER TABLE `popular` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recommendations`
--

DROP TABLE IF EXISTS `recommendations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recommendations` (
  `user_id` int NOT NULL,
  `video_id` int NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`user_id`,`video_id`),
  KEY `video_id` (`video_id`),
  CONSTRAINT `recommendations_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `recommendations_ibfk_2` FOREIGN KEY (`video_id`) REFERENCES `videos` (`video_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recommendations`
--

LOCK TABLES `recommendations` WRITE;
/*!40000 ALTER TABLE `recommendations` DISABLE KEYS */;
/*!40000 ALTER TABLE `recommendations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `settings` (
  `user_id` int NOT NULL,
  `notification_setting` varchar(255) NOT NULL,
  `dark_mode` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `settings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings`
--

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `profile_picture_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'aeff60','password123','user@example.com','aef','dev','2024-01-11 15:22:46','2024-01-11 15:22:46','https://b2dmain-ruk.cdn.jelastic.net/wp-content/uploads/2022/11/293716698_354038076879969_3950254371876821857_n-300x300.jpg'),(2,'user1','password1','user1@example.com','John','Doe','2024-01-11 16:06:24','2024-01-11 16:06:24',NULL),(3,'user2','password2','user2@example.com','Jane','Smith','2024-01-11 16:06:24','2024-01-11 16:06:24',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `videos`
--

DROP TABLE IF EXISTS `videos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `videos` (
  `video_id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text,
  `duration` int DEFAULT NULL,
  `video_type` varchar(255) DEFAULT NULL,
  `resolution` varchar(255) DEFAULT NULL,
  `thumbnail_url` varchar(255) DEFAULT NULL,
  `video_url` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `channel_id` int DEFAULT NULL,
  PRIMARY KEY (`video_id`),
  KEY `fk_channel` (`channel_id`),
  CONSTRAINT `fk_channel` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`channel_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `videos`
--

LOCK TABLES `videos` WRITE;
/*!40000 ALTER TABLE `videos` DISABLE KEYS */;
INSERT INTO `videos` VALUES (1,'Learn Python Basics','A beginner-friendly tutorial covering Python fundamentals.',300,'Programming Tutorial','1080p','https://i.ytimg.com/vi/3OIxNbaQgXM/hqdefault.jpg?sqp=-oaymwEcCNACELwBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLD0ia3HrI1RNjk3tT9gy87J6QGLrg','https://player.vimeo.com/video/901040301?h=ea47f38990','2024-01-09 13:29:09','2024-01-09 13:29:09',1),(2,'JavaScript Crash Course','An intensive crash course on JavaScript for web development.',240,'Programming Tutorial','720p','https://i.ytimg.com/vi/3OIxNbaQgXM/hqdefault.jpg?sqp=-oaymwEcCNACELwBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLD0ia3HrI1RNjk3tT9gy87J6QGLrg','https://player.vimeo.com/video/901040301?h=ea47f38990','2024-01-09 13:29:09','2024-01-09 13:29:09',1),(3,'Java Programming for Beginners','Introduction to Java programming for absolute beginners.',360,'Programming Tutorial','1080p','https://i.ytimg.com/vi/3OIxNbaQgXM/hqdefault.jpg?sqp=-oaymwEcCNACELwBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLD0ia3HrI1RNjk3tT9gy87J6QGLrg','https://player.vimeo.com/video/901040301?h=ea47f38990','2024-01-09 13:29:09','2024-01-09 13:29:09',1),(4,'Web Development with HTML & CSS','Building a simple website using HTML and CSS.',180,'Web Development Tutorial','720p','https://i.ytimg.com/vi/3OIxNbaQgXM/hqdefault.jpg?sqp=-oaymwEcCNACELwBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLD0ia3HrI1RNjk3tT9gy87J6QGLrg','https://player.vimeo.com/video/901040301?h=ea47f38990','2024-01-09 13:29:09','2024-01-09 13:29:09',1),(5,'Python Flask Web App Tutorial','Creating a web application using Python and Flask framework.',420,'Web Development Tutorial','1080p','https://i.ytimg.com/vi/3OIxNbaQgXM/hqdefault.jpg?sqp=-oaymwEcCNACELwBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLD0ia3HrI1RNjk3tT9gy87J6QGLrg','https://player.vimeo.com/video/901040301?h=ea47f38990','2024-01-09 13:29:09','2024-01-09 13:29:09',1),(6,'Introduction to Git and GitHub','Understanding the basics of version control with Git and GitHub.',150,'Programming Tutorial','720p','https://i.ytimg.com/vi/3OIxNbaQgXM/hqdefault.jpg?sqp=-oaymwEcCNACELwBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLD0ia3HrI1RNjk3tT9gy87J6QGLrg','https://player.vimeo.com/video/901040301?h=ea47f38990','2024-01-09 13:29:09','2024-01-09 13:29:09',1);
/*!40000 ALTER TABLE `videos` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-01-16 14:31:47

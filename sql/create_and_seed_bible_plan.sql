drop table if exists bible_plan_stg;

create table bible_plan_stg (
 day_id integer
,book_name varchar(100)
,start_chapter integer
,start_verse integer
,end_chapter integer
,end_verse integer
);

-- START OF BIBLE PLAN STAGE DATA
insert into bible_plan_stg values(1,'Amos',1,0,3,0);
insert into bible_plan_stg values(2,'Amos',4,0,6,0);
insert into bible_plan_stg values(3,'Amos',7,0,9,0);
insert into bible_plan_stg values(4,'Hosea',1,0,3,0);
insert into bible_plan_stg values(5,'Hosea',4,0,6,0);
insert into bible_plan_stg values(6,'Hosea',7,0,14,0);
insert into bible_plan_stg values(6,'',-1,0,-1,0);
insert into bible_plan_stg values(7,'Genesis',1,0,6,0);
insert into bible_plan_stg values(8,'Genesis',7,0,12,0);
insert into bible_plan_stg values(9,'Genesis',13,0,18,0);
insert into bible_plan_stg values(10,'Genesis',19,0,24,0);
insert into bible_plan_stg values(11,'Genesis',25,0,30,0);
insert into bible_plan_stg values(12,'Genesis',31,0,36,0);
insert into bible_plan_stg values(13,'Genesis',37,0,42,0);
insert into bible_plan_stg values(14,'Genesis',43,0,50,0);
insert into bible_plan_stg values(15,'Exodus',1,0,3,0);
insert into bible_plan_stg values(16,'Exodus',4,0,6,0);
insert into bible_plan_stg values(17,'Exodus',7,0,9,0);
insert into bible_plan_stg values(18,'Exodus',10,0,12,0);
insert into bible_plan_stg values(19,'Exodus',13,0,15,0);
insert into bible_plan_stg values(20,'Exodus',16,0,18,0);
insert into bible_plan_stg values(21,'Exodus',19,0,21,0);
insert into bible_plan_stg values(22,'Exodus',22,0,24,0);
insert into bible_plan_stg values(23,'Exodus',25,0,27,0);
insert into bible_plan_stg values(24,'Exodus',28,0,30,0);
insert into bible_plan_stg values(25,'Exodus',31,0,33,0);
insert into bible_plan_stg values(26,'Exodus',34,0,36,0);
insert into bible_plan_stg values(27,'Exodus',37,0,40,0);
insert into bible_plan_stg values(28,'',-1,0,-1,0);
insert into bible_plan_stg values(29,'',-1,0,-1,0);
insert into bible_plan_stg values(30,'Micah',1,0,4,0);
insert into bible_plan_stg values(31,'Micah',5,0,7,0);
insert into bible_plan_stg values(32,'Isaiah',1,0,4,0);
insert into bible_plan_stg values(33,'Isaiah',5,0,8,0);
insert into bible_plan_stg values(34,'Isaiah',9,0,12,0);
insert into bible_plan_stg values(35,'Isaiah',13,0,16,0);
insert into bible_plan_stg values(36,'Isaiah',17,0,20,0);
insert into bible_plan_stg values(37,'Isaiah',21,0,24,0);
insert into bible_plan_stg values(38,'Isaiah',25,0,28,0);
insert into bible_plan_stg values(39,'Isaiah',29,0,32,0);
insert into bible_plan_stg values(40,'Isaiah',33,0,35,0);
insert into bible_plan_stg values(41,'Isaiah',36,0,39,0);
insert into bible_plan_stg values(42,'Nahum',1,0,3,0);
insert into bible_plan_stg values(43,'Leviticus',1,0,7,0);
insert into bible_plan_stg values(44,'Leviticus',8,0,12,0);
insert into bible_plan_stg values(45,'Leviticus',13,0,15,0);
insert into bible_plan_stg values(46,'Leviticus',16,0,18,0);
insert into bible_plan_stg values(47,'Leviticus',19,0,22,0);
insert into bible_plan_stg values(48,'Leviticus',23,0,25,0);
insert into bible_plan_stg values(49,'Leviticus',26,0,27,0);
insert into bible_plan_stg values(50,'',-1,0,-1,0);
insert into bible_plan_stg values(51,'',-1,0,-1,0);
insert into bible_plan_stg values(52,'',-1,0,-1,0);
insert into bible_plan_stg values(53,'Habakkuk',1,0,3,0);
insert into bible_plan_stg values(54,'',-1,0,-1,0);
insert into bible_plan_stg values(55,'',-1,0,-1,0);
insert into bible_plan_stg values(56,'Numbers',1,0,4,0);
insert into bible_plan_stg values(57,'Numbers',5,0,8,0);
insert into bible_plan_stg values(58,'Numbers',9,0,13,0);
insert into bible_plan_stg values(59,'Numbers',14,0,16,0);
insert into bible_plan_stg values(59,'Isaiah',40,0,42,0);
insert into bible_plan_stg values(60,'Numbers',17,0,20,0);
insert into bible_plan_stg values(60,'Isaiah',43,0,45,0);
insert into bible_plan_stg values(61,'Numbers',21,0,23,0);
insert into bible_plan_stg values(61,'Isaiah',46,0,49,0);
insert into bible_plan_stg values(62,'Numbers',24,0,27,0);
insert into bible_plan_stg values(62,'Isaiah',50,0,52,0);
insert into bible_plan_stg values(63,'Numbers',28,0,30,0);
insert into bible_plan_stg values(63,'Isaiah',53,0,56,0);
insert into bible_plan_stg values(64,'Numbers',31,0,34,0);
insert into bible_plan_stg values(64,'Isaiah',57,0,60,0);
insert into bible_plan_stg values(65,'Numbers',35,0,36,0);
insert into bible_plan_stg values(65,'Isaiah',61,0,66,0);
insert into bible_plan_stg values(66,'Jeremiah',1,0,4,0);
insert into bible_plan_stg values(67,'Jeremiah',5,0,7,0);
insert into bible_plan_stg values(68,'Jeremiah',8,0,10,0);
insert into bible_plan_stg values(69,'Jeremiah',11,0,13,0);
insert into bible_plan_stg values(70,'Jeremiah',14,0,16,0);
insert into bible_plan_stg values(71,'Jeremiah',17,0,19,0);
insert into bible_plan_stg values(72,'Jeremiah',20,0,22,0);
insert into bible_plan_stg values(73,'Jeremiah',23,0,25,0);
insert into bible_plan_stg values(74,'Jeremiah',26,0,28,0);
insert into bible_plan_stg values(75,'Jeremiah',29,0,32,0);
insert into bible_plan_stg values(76,'Jeremiah',33,0,38,0);
insert into bible_plan_stg values(77,'Jeremiah',39,0,44,0);
insert into bible_plan_stg values(78,'Jeremiah',45,0,50,0);
insert into bible_plan_stg values(79,'Jeremiah',51,0,52,0);
insert into bible_plan_stg values(80,'Deuteronomy',1,0,6,0);
insert into bible_plan_stg values(81,'Deuteronomy',7,0,12,0);
insert into bible_plan_stg values(82,'Deuteronomy',13,0,18,0);
insert into bible_plan_stg values(83,'Deuteronomy',19,0,21,0);
insert into bible_plan_stg values(84,'Deuteronomy',22,0,24,0);
insert into bible_plan_stg values(85,'Deuteronomy',25,0,27,0);
insert into bible_plan_stg values(86,'Deuteronomy',28,0,30,0);
insert into bible_plan_stg values(87,'Deuteronomy',31,0,34,0);
insert into bible_plan_stg values(88,'',-1,0,-1,0);
insert into bible_plan_stg values(89,'Zephaniah',1,0,3,0);
insert into bible_plan_stg values(90,'Joel',1,0,3,0);
insert into bible_plan_stg values(91,'Joshua',1,0,3,0);
insert into bible_plan_stg values(92,'Joshua',4,0,9,0);
insert into bible_plan_stg values(93,'Joshua',10,0,12,0);
insert into bible_plan_stg values(94,'Joshua',13,0,15,0);
insert into bible_plan_stg values(95,'Joshua',16,0,18,0);
insert into bible_plan_stg values(96,'Joshua',19,0,21,0);
insert into bible_plan_stg values(97,'Joshua',22,0,24,0);
insert into bible_plan_stg values(98,'Judges',1,0,5,0);
insert into bible_plan_stg values(99,'Judges',6,0,10,0);
insert into bible_plan_stg values(100,'Judges',11,0,16,0);
insert into bible_plan_stg values(101,'Judges',17,0,21,0);
insert into bible_plan_stg values(102,'Ruth',1,0,4,0);
insert into bible_plan_stg values(103,'1 Samuel',1,0,3,0);
insert into bible_plan_stg values(104,'1 Samuel',4,0,6,0);
insert into bible_plan_stg values(105,'1 Samuel',7,0,9,0);
insert into bible_plan_stg values(106,'1 Samuel',10,0,12,0);
insert into bible_plan_stg values(107,'1 Samuel',13,0,15,0);
insert into bible_plan_stg values(108,'1 Samuel',16,0,18,0);
insert into bible_plan_stg values(109,'1 Samuel',19,0,21,0);
insert into bible_plan_stg values(110,'1 Samuel',22,0,26,0);
insert into bible_plan_stg values(111,'1 Samuel',27,0,31,0);
insert into bible_plan_stg values(112,'2 Samuel',1,0,4,0);
insert into bible_plan_stg values(113,'2 Samuel',5,0,8,0);
insert into bible_plan_stg values(114,'2 Samuel',9,0,12,0);
insert into bible_plan_stg values(115,'2 Samuel',13,0,15,0);
insert into bible_plan_stg values(116,'2 Samuel',16,0,21,0);
insert into bible_plan_stg values(117,'2 Samuel',22,0,24,0);
insert into bible_plan_stg values(118,'1 Kings',1,0,4,0);
insert into bible_plan_stg values(119,'1 Kings',5,0,8,0);
insert into bible_plan_stg values(120,'1 Kings',9,0,14,0);
insert into bible_plan_stg values(121,'1 Kings',15,0,19,0);
insert into bible_plan_stg values(122,'1 Kings',20,0,22,0);
insert into bible_plan_stg values(123,'2 Kings',1,0,4,0);
insert into bible_plan_stg values(124,'2 Kings',5,0,8,0);
insert into bible_plan_stg values(125,'2 Kings',9,0,11,0);
insert into bible_plan_stg values(126,'2 Kings',12,0,14,0);
insert into bible_plan_stg values(127,'2 Kings',15,0,17,0);
insert into bible_plan_stg values(128,'2 Kings',18,0,20,0);
insert into bible_plan_stg values(129,'2 Kings',21,0,25,0);
insert into bible_plan_stg values(130,'Obadiah',1,0,1,0);
insert into bible_plan_stg values(131,'Lamentations',1,0,5,0);
insert into bible_plan_stg values(132,'Ezekiel',1,0,5,0);
insert into bible_plan_stg values(133,'Ezekiel',6,0,10,0);
insert into bible_plan_stg values(134,'Ezekiel',11,0,15,0);
insert into bible_plan_stg values(135,'Ezekiel',16,0,20,0);
insert into bible_plan_stg values(136,'Ezekiel',21,0,25,0);
insert into bible_plan_stg values(137,'Ezekiel',26,0,30,0);
insert into bible_plan_stg values(138,'Ezekiel',31,0,35,0);
insert into bible_plan_stg values(139,'Ezekiel',36,0,39,0);
insert into bible_plan_stg values(140,'Ezekiel',40,0,43,0);
insert into bible_plan_stg values(141,'Ezekiel',44,0,48,0);
insert into bible_plan_stg values(142,'Daniel',1,0,3,0);
insert into bible_plan_stg values(143,'Daniel',4,0,6,0);
insert into bible_plan_stg values(144,'Daniel',7,0,9,0);
insert into bible_plan_stg values(145,'Daniel',10,0,12,0);
insert into bible_plan_stg values(146,'1 Chronicles',1,0,3,0);
insert into bible_plan_stg values(147,'1 Chronicles',4,0,7,0);
insert into bible_plan_stg values(148,'1 Chronicles',8,0,11,0);
insert into bible_plan_stg values(149,'1 Chronicles',12,0,15,0);
insert into bible_plan_stg values(150,'1 Chronicles',16,0,19,0);
insert into bible_plan_stg values(151,'1 Chronicles',20,0,23,0);
insert into bible_plan_stg values(152,'1 Chronicles',24,0,26,0);
insert into bible_plan_stg values(153,'1 Chronicles',27,0,29,0);
insert into bible_plan_stg values(154,'2 Chronicles',1,0,6,0);
insert into bible_plan_stg values(155,'2 Chronicles',7,0,12,0);
insert into bible_plan_stg values(156,'2 Chronicles',13,0,18,0);
insert into bible_plan_stg values(157,'2 Chronicles',19,0,24,0);
insert into bible_plan_stg values(158,'2 Chronicles',25,0,30,0);
insert into bible_plan_stg values(159,'2 Chronicles',31,0,36,0);
insert into bible_plan_stg values(160,'',-1,0,-1,0);
insert into bible_plan_stg values(161,'Ezra',1,0,6,0);
insert into bible_plan_stg values(161,'',-1,0,-1,0);
insert into bible_plan_stg values(161,'',-1,0,-1,0);
insert into bible_plan_stg values(162,'Ezra',7,0,10,0);
insert into bible_plan_stg values(163,'Nehemiah',1,0,3,0);
insert into bible_plan_stg values(164,'Nehemiah',4,0,6,0);
insert into bible_plan_stg values(165,'Nehemiah',7,0,9,0);
insert into bible_plan_stg values(166,'Nehemiah',10,0,13,0);
insert into bible_plan_stg values(167,'Esther',1,0,3,0);
insert into bible_plan_stg values(168,'Esther',4,0,6,0);
insert into bible_plan_stg values(169,'Esther',7,0,10,0);
insert into bible_plan_stg values(170,'Haggai',1,0,2,0);
insert into bible_plan_stg values(171,'Zechariah',1,0,6,0);
insert into bible_plan_stg values(172,'',-1,0,-1,0);
insert into bible_plan_stg values(173,'Zechariah',7,0,9,0);
insert into bible_plan_stg values(174,'Zechariah',10,0,14,0);
insert into bible_plan_stg values(175,'Malachi',1,0,4,0);
insert into bible_plan_stg values(1,'Psalms',1,0,1,0);
insert into bible_plan_stg values(2,'Psalms',2,0,2,0);
insert into bible_plan_stg values(3,'Psalms',3,0,3,0);
insert into bible_plan_stg values(4,'Psalms',4,0,4,0);
insert into bible_plan_stg values(5,'Psalms',5,0,5,0);
insert into bible_plan_stg values(6,'Psalms',6,0,7,0);
insert into bible_plan_stg values(6,'',-1,0,-1,0);
insert into bible_plan_stg values(7,'Psalms',8,0,8,0);
insert into bible_plan_stg values(8,'Psalms',9,0,9,0);
insert into bible_plan_stg values(9,'Psalms',10,0,10,0);
insert into bible_plan_stg values(10,'Psalms',11,0,11,0);
insert into bible_plan_stg values(11,'Psalms',12,0,12,0);
insert into bible_plan_stg values(12,'Psalms',13,0,13,0);
insert into bible_plan_stg values(13,'Psalms',14,0,14,0);
insert into bible_plan_stg values(14,'',-1,0,-1,0);
insert into bible_plan_stg values(15,'',-1,0,-1,0);
insert into bible_plan_stg values(16,'Psalms',15,0,15,0);
insert into bible_plan_stg values(17,'Psalms',16,0,16,0);
insert into bible_plan_stg values(18,'Psalms',17,0,17,0);
insert into bible_plan_stg values(19,'Psalms',18,0,18,0);
insert into bible_plan_stg values(20,'Psalms',19,0,19,0);
insert into bible_plan_stg values(21,'Psalms',20,0,20,0);
insert into bible_plan_stg values(22,'Psalms',21,0,21,0);
insert into bible_plan_stg values(23,'Psalms',22,0,22,0);
insert into bible_plan_stg values(24,'Psalms',23,0,26,0);
insert into bible_plan_stg values(25,'Psalms',27,0,30,0);
insert into bible_plan_stg values(26,'Psalms',31,0,34,0);
insert into bible_plan_stg values(27,'Psalms',35,0,37,0);
insert into bible_plan_stg values(28,'Psalms',38,0,41,0);
insert into bible_plan_stg values(29,'Jonah',1,0,4,0);
insert into bible_plan_stg values(30,'',-1,0,-1,0);
insert into bible_plan_stg values(31,'Proverbs',1,0,1,0);
insert into bible_plan_stg values(32,'Proverbs',2,0,2,0);
insert into bible_plan_stg values(33,'Proverbs',3,0,3,0);
insert into bible_plan_stg values(34,'Proverbs',4,0,4,0);
insert into bible_plan_stg values(35,'Proverbs',5,0,5,0);
insert into bible_plan_stg values(36,'Proverbs',6,0,6,0);
insert into bible_plan_stg values(37,'Proverbs',7,0,7,0);
insert into bible_plan_stg values(38,'Proverbs',8,0,9,0);
insert into bible_plan_stg values(39,'Job',1,0,3,0);
insert into bible_plan_stg values(40,'Job',4,0,7,0);
insert into bible_plan_stg values(41,'Job',8,0,10,0);
insert into bible_plan_stg values(42,'Job',11,0,14,0);
insert into bible_plan_stg values(43,'',-1,0,-1,0);
insert into bible_plan_stg values(44,'Job',15,0,17,0);
insert into bible_plan_stg values(45,'',-1,0,-1,0);
insert into bible_plan_stg values(46,'Job',18,0,20,0);
insert into bible_plan_stg values(47,'Job',21,0,22,0);
insert into bible_plan_stg values(48,'Job',23,0,24,0);
insert into bible_plan_stg values(49,'Job',25,0,28,0);
insert into bible_plan_stg values(50,'Job',29,0,31,0);
insert into bible_plan_stg values(51,'Job',32,0,37,0);
insert into bible_plan_stg values(52,'',-1,0,-1,0);
insert into bible_plan_stg values(53,'Job',38,0,42,0);
insert into bible_plan_stg values(54,'',-1,0,-1,0);
insert into bible_plan_stg values(55,'',-1,0,-1,0);
insert into bible_plan_stg values(56,'',-1,0,-1,0);
insert into bible_plan_stg values(57,'',-1,0,-1,0);
insert into bible_plan_stg values(58,'',-1,0,-1,0);
insert into bible_plan_stg values(59,'',-1,0,-1,0);
insert into bible_plan_stg values(59,'',-1,0,-1,0);
insert into bible_plan_stg values(60,'',-1,0,-1,0);
insert into bible_plan_stg values(60,'',-1,0,-1,0);
insert into bible_plan_stg values(61,'',-1,0,-1,0);
insert into bible_plan_stg values(61,'',-1,0,-1,0);
insert into bible_plan_stg values(62,'',-1,0,-1,0);
insert into bible_plan_stg values(62,'',-1,0,-1,0);
insert into bible_plan_stg values(63,'',-1,0,-1,0);
insert into bible_plan_stg values(63,'',-1,0,-1,0);
insert into bible_plan_stg values(64,'',-1,0,-1,0);
insert into bible_plan_stg values(64,'',-1,0,-1,0);
insert into bible_plan_stg values(65,'',-1,0,-1,0);
insert into bible_plan_stg values(65,'',-1,0,-1,0);
insert into bible_plan_stg values(66,'Psalms',42,0,42,0);
insert into bible_plan_stg values(67,'Psalms',43,0,43,0);
insert into bible_plan_stg values(68,'Psalms',44,0,44,0);
insert into bible_plan_stg values(69,'Psalms',45,0,45,0);
insert into bible_plan_stg values(70,'Psalms',46,0,46,0);
insert into bible_plan_stg values(71,'Psalms',47,0,47,0);
insert into bible_plan_stg values(72,'Psalms',48,0,48,0);
insert into bible_plan_stg values(73,'Psalms',49,0,49,0);
insert into bible_plan_stg values(74,'Psalms',50,0,50,0);
insert into bible_plan_stg values(75,'Psalms',51,0,51,0);
insert into bible_plan_stg values(76,'Psalms',52,0,52,0);
insert into bible_plan_stg values(77,'Psalms',53,0,53,0);
insert into bible_plan_stg values(78,'Psalms',54,0,54,0);
insert into bible_plan_stg values(79,'Psalms',55,0,56,0);
insert into bible_plan_stg values(80,'Psalms',57,0,57,0);
insert into bible_plan_stg values(81,'Psalms',58,0,58,0);
insert into bible_plan_stg values(82,'Psalms',59,0,59,0);
insert into bible_plan_stg values(83,'Psalms',60,0,60,0);
insert into bible_plan_stg values(84,'Psalms',61,0,62,0);
insert into bible_plan_stg values(85,'Psalms',63,0,63,0);
insert into bible_plan_stg values(86,'Psalms',64,0,64,0);
insert into bible_plan_stg values(87,'Psalms',65,0,67,0);
insert into bible_plan_stg values(88,'Psalms',68,0,72,0);
insert into bible_plan_stg values(89,'Proverbs',10,0,11,0);
insert into bible_plan_stg values(90,'Proverbs',12,0,13,0);
insert into bible_plan_stg values(91,'Proverbs',14,0,14,0);
insert into bible_plan_stg values(92,'Proverbs',15,0,15,0);
insert into bible_plan_stg values(93,'Proverbs',16,0,16,0);
insert into bible_plan_stg values(94,'Proverbs',17,0,17,0);
insert into bible_plan_stg values(95,'Proverbs',18,0,18,0);
insert into bible_plan_stg values(96,'Proverbs',19,0,19,0);
insert into bible_plan_stg values(97,'Proverbs',20,0,20,0);
insert into bible_plan_stg values(98,'',-1,0,-1,0);
insert into bible_plan_stg values(99,'',-1,0,-1,0);
insert into bible_plan_stg values(100,'',-1,0,-1,0);
insert into bible_plan_stg values(101,'',-1,0,-1,0);
insert into bible_plan_stg values(102,'Psalms',73,0,75,0);
insert into bible_plan_stg values(103,'Psalms',76,0,76,0);
insert into bible_plan_stg values(104,'Psalms',77,0,77,0);
insert into bible_plan_stg values(105,'Psalms',78,0,78,0);
insert into bible_plan_stg values(106,'Psalms',79,0,79,0);
insert into bible_plan_stg values(107,'Psalms',80,0,83,0);
insert into bible_plan_stg values(108,'Psalms',84,0,87,0);
insert into bible_plan_stg values(109,'Psalms',88,0,89,0);
insert into bible_plan_stg values(110,'',-1,0,-1,0);
insert into bible_plan_stg values(111,'',-1,0,-1,0);
insert into bible_plan_stg values(112,'',-1,0,-1,0);
insert into bible_plan_stg values(113,'',-1,0,-1,0);
insert into bible_plan_stg values(114,'',-1,0,-1,0);
insert into bible_plan_stg values(115,'Proverbs',21,0,21,0);
insert into bible_plan_stg values(116,'Proverbs',22,0,22,0);
insert into bible_plan_stg values(117,'Proverbs',23,0,25,0);
insert into bible_plan_stg values(118,'Proverbs',26,0,27,0);
insert into bible_plan_stg values(119,'Proverbs',28,0,28,0);
insert into bible_plan_stg values(120,'Proverbs',29,0,29,0);
insert into bible_plan_stg values(121,'Proverbs',30,0,31,0);
insert into bible_plan_stg values(122,'',-1,0,-1,0);
insert into bible_plan_stg values(123,'',-1,0,-1,0);
insert into bible_plan_stg values(124,'Song of Solomon',1,0,5,0);
insert into bible_plan_stg values(125,'Song of Solomon',6,0,8,0);
insert into bible_plan_stg values(126,'Ecclesiastes',1,0,1,0);
insert into bible_plan_stg values(127,'Ecclesiastes',2,0,5,0);
insert into bible_plan_stg values(128,'Ecclesiastes',6,0,9,0);
insert into bible_plan_stg values(129,'Ecclesiastes',10,0,12,0);
insert into bible_plan_stg values(130,'Psalms',90,0,91,0);
insert into bible_plan_stg values(131,'Psalms',92,0,93,0);
insert into bible_plan_stg values(132,'Psalms',94,0,95,0);
insert into bible_plan_stg values(133,'Psalms',96,0,97,0);
insert into bible_plan_stg values(134,'Psalms',98,0,99,0);
insert into bible_plan_stg values(135,'Psalms',100,0,101,0);
insert into bible_plan_stg values(136,'Psalms',102,0,103,0);
insert into bible_plan_stg values(137,'Psalms',104,0,105,0);
insert into bible_plan_stg values(138,'Psalms',106,0,106,0);
insert into bible_plan_stg values(139,'',-1,0,-1,0);
insert into bible_plan_stg values(140,'',-1,0,-1,0);
insert into bible_plan_stg values(141,'Psalms',107,0,109,0);
insert into bible_plan_stg values(142,'Psalms',110,0,110,0);
insert into bible_plan_stg values(143,'Psalms',111,0,111,0);
insert into bible_plan_stg values(144,'Psalms',112,0,113,0);
insert into bible_plan_stg values(145,'Psalms',114,0,114,0);
insert into bible_plan_stg values(146,'Psalms',115,0,115,0);
insert into bible_plan_stg values(147,'Psalms',116,0,116,0);
insert into bible_plan_stg values(148,'Psalms',117,0,117,0);
insert into bible_plan_stg values(149,'Psalms',118,0,118,0);
insert into bible_plan_stg values(146,'Psalms',119,1,119,24);
insert into bible_plan_stg values(147,'Psalms',119,25,119,48);
insert into bible_plan_stg values(148,'Psalms',119,49,119,72);
insert into bible_plan_stg values(149,'Psalms',119,73,119,96);
insert into bible_plan_stg values(150,'Psalms',119,97,119,120);
insert into bible_plan_stg values(151,'Psalms',119,121,119,144);
insert into bible_plan_stg values(152,'Psalms',119,145,119,176);
insert into bible_plan_stg values(157,'Psalms',120,0,120,0);
insert into bible_plan_stg values(158,'Psalms',121,0,121,0);
insert into bible_plan_stg values(159,'Psalms',122,0,122,0);
insert into bible_plan_stg values(160,'Psalms',123,0,124,0);
insert into bible_plan_stg values(161,'Psalms',125,0,131,0);
insert into bible_plan_stg values(161,'',-1,0,-1,0);
insert into bible_plan_stg values(161,'',-1,0,-1,0);
insert into bible_plan_stg values(162,'Psalms',132,0,134,0);
insert into bible_plan_stg values(163,'Psalms',135,0,138,0);
insert into bible_plan_stg values(164,'Psalms',139,0,142,0);
insert into bible_plan_stg values(165,'Psalms',143,0,146,0);
insert into bible_plan_stg values(166,'Psalms',147,0,147,0);
insert into bible_plan_stg values(167,'Psalms',148,0,148,0);
insert into bible_plan_stg values(168,'Psalms',149,0,149,0);
insert into bible_plan_stg values(169,'',-1,0,-1,0);
insert into bible_plan_stg values(170,'',-1,0,-1,0);
insert into bible_plan_stg values(171,'',-1,0,-1,0);
insert into bible_plan_stg values(172,'',-1,0,-1,0);
insert into bible_plan_stg values(173,'',-1,0,-1,0);
insert into bible_plan_stg values(174,'',-1,0,-1,0);
insert into bible_plan_stg values(175,'Psalms',150,0,150,0);
insert into bible_plan_stg values(1,'Mark',1,0,3,0);
insert into bible_plan_stg values(2,'Mark',4,0,6,0);
insert into bible_plan_stg values(3,'Mark',7,0,9,0);
insert into bible_plan_stg values(4,'Mark',10,0,12,0);
insert into bible_plan_stg values(5,'Mark',13,0,16,0);
insert into bible_plan_stg values(6,'',-1,0,-1,0);
insert into bible_plan_stg values(6,'',-1,0,-1,0);
insert into bible_plan_stg values(7,'',-1,0,-1,0);
insert into bible_plan_stg values(8,'',-1,0,-1,0);
insert into bible_plan_stg values(9,'',-1,0,-1,0);
insert into bible_plan_stg values(10,'',-1,0,-1,0);
insert into bible_plan_stg values(11,'',-1,0,-1,0);
insert into bible_plan_stg values(12,'',-1,0,-1,0);
insert into bible_plan_stg values(13,'',-1,0,-1,0);
insert into bible_plan_stg values(14,'',-1,0,-1,0);
insert into bible_plan_stg values(15,'Matthew',1,0,4,0);
insert into bible_plan_stg values(16,'Matthew',5,0,7,0);
insert into bible_plan_stg values(17,'Matthew',8,0,10,0);
insert into bible_plan_stg values(18,'Matthew',11,0,13,0);
insert into bible_plan_stg values(19,'Matthew',14,0,16,0);
insert into bible_plan_stg values(20,'Matthew',17,0,19,0);
insert into bible_plan_stg values(21,'Matthew',20,0,22,0);
insert into bible_plan_stg values(22,'Matthew',23,0,25,0);
insert into bible_plan_stg values(23,'Matthew',26,0,28,0);
insert into bible_plan_stg values(24,'',-1,0,-1,0);
insert into bible_plan_stg values(25,'',-1,0,-1,0);
insert into bible_plan_stg values(26,'',-1,0,-1,0);
insert into bible_plan_stg values(27,'',-1,0,-1,0);
insert into bible_plan_stg values(28,'Luke',1,0,2,0);
insert into bible_plan_stg values(29,'Luke',3,0,5,0);
insert into bible_plan_stg values(30,'Luke',6,0,8,0);
insert into bible_plan_stg values(31,'Luke',9,0,11,0);
insert into bible_plan_stg values(32,'Luke',12,0,13,0);
insert into bible_plan_stg values(33,'Luke',14,0,15,0);
insert into bible_plan_stg values(34,'Luke',16,0,17,0);
insert into bible_plan_stg values(35,'Luke',18,0,19,0);
insert into bible_plan_stg values(36,'Luke',20,0,21,0);
insert into bible_plan_stg values(37,'Luke',22,0,24,0);
insert into bible_plan_stg values(38,'',-1,0,-1,0);
insert into bible_plan_stg values(39,'',-1,0,-1,0);
insert into bible_plan_stg values(40,'',-1,0,-1,0);
insert into bible_plan_stg values(41,'',-1,0,-1,0);
insert into bible_plan_stg values(42,'',-1,0,-1,0);
insert into bible_plan_stg values(43,'',-1,0,-1,0);
insert into bible_plan_stg values(44,'',-1,0,-1,0);
insert into bible_plan_stg values(45,'',-1,0,-1,0);
insert into bible_plan_stg values(46,'',-1,0,-1,0);
insert into bible_plan_stg values(47,'',-1,0,-1,0);
insert into bible_plan_stg values(48,'',-1,0,-1,0);
insert into bible_plan_stg values(49,'John',1,0,1,0);
insert into bible_plan_stg values(50,'John',2,0,5,0);
insert into bible_plan_stg values(51,'John',6,0,6,0);
insert into bible_plan_stg values(52,'John',7,0,12,0);
insert into bible_plan_stg values(53,'',-1,0,-1,0);
insert into bible_plan_stg values(54,'John',13,0,17,0);
insert into bible_plan_stg values(55,'John',18,0,21,0);
insert into bible_plan_stg values(56,'',-1,0,-1,0);
insert into bible_plan_stg values(57,'',-1,0,-1,0);
insert into bible_plan_stg values(58,'',-1,0,-1,0);
insert into bible_plan_stg values(59,'',-1,0,-1,0);
insert into bible_plan_stg values(59,'',-1,0,-1,0);
insert into bible_plan_stg values(60,'',-1,0,-1,0);
insert into bible_plan_stg values(60,'',-1,0,-1,0);
insert into bible_plan_stg values(61,'',-1,0,-1,0);
insert into bible_plan_stg values(61,'',-1,0,-1,0);
insert into bible_plan_stg values(62,'',-1,0,-1,0);
insert into bible_plan_stg values(62,'',-1,0,-1,0);
insert into bible_plan_stg values(63,'',-1,0,-1,0);
insert into bible_plan_stg values(63,'',-1,0,-1,0);
insert into bible_plan_stg values(64,'',-1,0,-1,0);
insert into bible_plan_stg values(64,'',-1,0,-1,0);
insert into bible_plan_stg values(65,'',-1,0,-1,0);
insert into bible_plan_stg values(65,'',-1,0,-1,0);
insert into bible_plan_stg values(66,'Acts',1,0,2,0);
insert into bible_plan_stg values(67,'Acts',3,0,5,0);
insert into bible_plan_stg values(68,'Acts',6,0,8,0);
insert into bible_plan_stg values(69,'Acts',9,0,11,0);
insert into bible_plan_stg values(70,'Acts',12,0,14,0);
insert into bible_plan_stg values(71,'Acts',15,0,17,0);
insert into bible_plan_stg values(72,'Acts',18,0,20,0);
insert into bible_plan_stg values(73,'Acts',21,0,23,0);
insert into bible_plan_stg values(74,'Acts',24,0,27,0);
insert into bible_plan_stg values(75,'Acts',28,0,28,0);
insert into bible_plan_stg values(76,'',-1,0,-1,0);
insert into bible_plan_stg values(77,'',-1,0,-1,0);
insert into bible_plan_stg values(78,'',-1,0,-1,0);
insert into bible_plan_stg values(79,'',-1,0,-1,0);
insert into bible_plan_stg values(80,'',-1,0,-1,0);
insert into bible_plan_stg values(81,'',-1,0,-1,0);
insert into bible_plan_stg values(82,'',-1,0,-1,0);
insert into bible_plan_stg values(83,'James',1,0,3,0);
insert into bible_plan_stg values(84,'James',4,0,5,0);
insert into bible_plan_stg values(85,'Galatians',1,0,3,0);
insert into bible_plan_stg values(86,'Galatians',4,0,6,0);
insert into bible_plan_stg values(87,'',-1,0,-1,0);
insert into bible_plan_stg values(88,'',-1,0,-1,0);
insert into bible_plan_stg values(89,'1 Thessalonians',1,0,3,0);
insert into bible_plan_stg values(90,'1 Thessalonians',4,0,5,0);
insert into bible_plan_stg values(91,'2 Thessalonians',1,0,3,0);
insert into bible_plan_stg values(92,'',-1,0,-1,0);
insert into bible_plan_stg values(93,'1 Corinthians',1,0,3,0);
insert into bible_plan_stg values(94,'1 Corinthians',4,0,6,0);
insert into bible_plan_stg values(95,'1 Corinthians',7,0,9,0);
insert into bible_plan_stg values(96,'1 Corinthians',10,0,12,0);
insert into bible_plan_stg values(97,'1 Corinthians',13,0,13,0);
insert into bible_plan_stg values(98,'1 Corinthians',14,0,14,0);
insert into bible_plan_stg values(99,'',-1,0,-1,0);
insert into bible_plan_stg values(100,'1 Corinthians',15,0,15,0);
insert into bible_plan_stg values(101,'1 Corinthians',16,0,16,0);
insert into bible_plan_stg values(102,'',-1,0,-1,0);
insert into bible_plan_stg values(103,'2 Corinthians',1,0,3,0);
insert into bible_plan_stg values(104,'2 Corinthians',4,0,6,0);
insert into bible_plan_stg values(105,'2 Corinthians',7,0,9,0);
insert into bible_plan_stg values(106,'2 Corinthians',10,0,13,0);
insert into bible_plan_stg values(107,'',-1,0,-1,0);
insert into bible_plan_stg values(108,'',-1,0,-1,0);
insert into bible_plan_stg values(109,'',-1,0,-1,0);
insert into bible_plan_stg values(110,'Romans',1,0,2,0);
insert into bible_plan_stg values(111,'Romans',3,0,6,0);
insert into bible_plan_stg values(112,'Romans',7,0,9,0);
insert into bible_plan_stg values(113,'Romans',10,0,12,0);
insert into bible_plan_stg values(114,'Romans',13,0,15,0);
insert into bible_plan_stg values(115,'Romans',16,0,16,0);
insert into bible_plan_stg values(116,'',-1,0,-1,0);
insert into bible_plan_stg values(117,'',-1,0,-1,0);
insert into bible_plan_stg values(118,'',-1,0,-1,0);
insert into bible_plan_stg values(119,'',-1,0,-1,0);
insert into bible_plan_stg values(120,'',-1,0,-1,0);
insert into bible_plan_stg values(121,'',-1,0,-1,0);
insert into bible_plan_stg values(122,'Ephesians',1,0,3,0);
insert into bible_plan_stg values(123,'Ephesians',4,0,6,0);
insert into bible_plan_stg values(124,'',-1,0,-1,0);
insert into bible_plan_stg values(125,'Philippians',1,0,1,0);
insert into bible_plan_stg values(126,'Philippians',2,0,4,0);
insert into bible_plan_stg values(127,'',-1,0,-1,0);
insert into bible_plan_stg values(128,'',-1,0,-1,0);
insert into bible_plan_stg values(129,'',-1,0,-1,0);
insert into bible_plan_stg values(130,'Colossians',1,0,4,0);
insert into bible_plan_stg values(131,'',-1,0,-1,0);
insert into bible_plan_stg values(132,'',-1,0,-1,0);
insert into bible_plan_stg values(133,'',-1,0,-1,0);
insert into bible_plan_stg values(134,'',-1,0,-1,0);
insert into bible_plan_stg values(135,'',-1,0,-1,0);
insert into bible_plan_stg values(136,'',-1,0,-1,0);
insert into bible_plan_stg values(137,'',-1,0,-1,0);
insert into bible_plan_stg values(138,'Philemon',1,0,1,0);
insert into bible_plan_stg values(139,'1 Timothy',1,0,3,0);
insert into bible_plan_stg values(140,'1 Timothy',4,0,6,0);
insert into bible_plan_stg values(141,'',-1,0,-1,0);
insert into bible_plan_stg values(142,'Titus',1,0,3,0);
insert into bible_plan_stg values(143,'1 Peter',1,0,3,0);
insert into bible_plan_stg values(144,'1 Peter',4,0,5,0);
insert into bible_plan_stg values(145,'2 Timothy',1,0,4,0);
insert into bible_plan_stg values(146,'2 Peter',1,0,3,0);
insert into bible_plan_stg values(147,'Hebrews',1,0,2,0);
insert into bible_plan_stg values(148,'Hebrews',3,0,4,0);
insert into bible_plan_stg values(149,'Hebrews',5,0,6,0);
insert into bible_plan_stg values(150,'Hebrews',7,0,8,0);
insert into bible_plan_stg values(151,'Hebrews',9,0,10,0);
insert into bible_plan_stg values(152,'Hebrews',11,0,13,0);
insert into bible_plan_stg values(153,'Jude',1,0,1,0);
insert into bible_plan_stg values(154,'',-1,0,-1,0);
insert into bible_plan_stg values(155,'',-1,0,-1,0);
insert into bible_plan_stg values(156,'',-1,0,-1,0);
insert into bible_plan_stg values(157,'',-1,0,-1,0);
insert into bible_plan_stg values(158,'',-1,0,-1,0);
insert into bible_plan_stg values(159,'',-1,0,-1,0);
insert into bible_plan_stg values(160,'1 John',1,0,5,0);
insert into bible_plan_stg values(161,'2 John',1,0,1,0);
insert into bible_plan_stg values(161,'3 John',1,0,1,0);
insert into bible_plan_stg values(161,'',-1,0,-1,0);
insert into bible_plan_stg values(162,'',-1,0,-1,0);
insert into bible_plan_stg values(163,'',-1,0,-1,0);
insert into bible_plan_stg values(164,'',-1,0,-1,0);
insert into bible_plan_stg values(165,'',-1,0,-1,0);
insert into bible_plan_stg values(166,'Revelation',1,0,2,0);
insert into bible_plan_stg values(167,'Revelation',3,0,4,0);
insert into bible_plan_stg values(168,'Revelation',5,0,6,0);
insert into bible_plan_stg values(169,'Revelation',7,0,8,0);
insert into bible_plan_stg values(170,'Revelation',9,0,12,0);
insert into bible_plan_stg values(171,'Revelation',13,0,16,0);
insert into bible_plan_stg values(172,'',-1,0,-1,0);
insert into bible_plan_stg values(173,'Revelation',17,0,18,0);
insert into bible_plan_stg values(174,'Revelation',19,0,20,0);
insert into bible_plan_stg values(175,'Revelation',21,0,22,0);
-- END OF BIBLE PLAN STAGE DATA

drop table if exists bible_plan;

create table bible_plan as
select bps.day_id
      ,bb.book_id
      ,bps.start_chapter
      ,bps.end_chapter
      ,bps.start_verse
      ,bps.end_verse
  from bible_plan_stg bps
  join bible_book bb on bb.book_name = bps.book_name
 where bps.book_name > ''
 order by day_id, book_id
;

-- phpMyAdmin SQL Dump
-- version 3.3.7
-- http://www.phpmyadmin.net
--
-- 主机: localhost
-- 生成日期: 2016 年 02 月 05 日 07:12
-- 服务器版本: 5.0.90
-- PHP 版本: 5.2.14

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- 数据库: `free`
--

-- --------------------------------------------------------

--
-- 表的结构 `account`
--

CREATE TABLE IF NOT EXISTS `account` (
  `ID` int(11) NOT NULL auto_increment,
  `NAME` varchar(80) NOT NULL,
  `PASS` varchar(128) NOT NULL,
  `MOTTO` varchar(256) NOT NULL,
  `MOTTOCOLOR` int(11) NOT NULL,
  `SKIN` int(11) NOT NULL,
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `A` float NOT NULL,
  `INTERIOR` int(11) NOT NULL,
  `WORLD` int(11) NOT NULL,
  `LOCATION` int(11) NOT NULL,
  `CASH` int(11) NOT NULL,
  `BANK` int(11) NOT NULL,
  `QB` int(11) NOT NULL,
  `MONEYBAG` int(11) NOT NULL,
  `GID` int(11) NOT NULL,
  `RANK` int(11) NOT NULL,
  `COLOR` int(11) NOT NULL,
  `SAYCOLOR` int(11) NOT NULL,
  `KILL` int(11) NOT NULL,
  `DEATH` int(11) NOT NULL,
  `ADMIN` int(11) NOT NULL,
  `LEVEL` int(11) NOT NULL,
  `EXP` int(11) NOT NULL,
  `CHOOSE` int(11) NOT NULL,
  PRIMARY KEY  (`ID`)
) ENGINE=MyISAM  DEFAULT CHARSET=gbk AUTO_INCREMENT=41 ;

--
-- 转存表中的数据 `account`
--

INSERT INTO `account` (`ID`, `NAME`, `PASS`, `MOTTO`, `MOTTOCOLOR`, `SKIN`, `X`, `Y`, `Z`, `A`, `INTERIOR`, `WORLD`, `LOCATION`, `CASH`, `BANK`, `QB`, `MONEYBAG`, `GID`, `RANK`, `COLOR`, `SAYCOLOR`, `KILL`, `DEATH`, `ADMIN`, `LEVEL`, `EXP`, `CHOOSE`) VALUES
(40, '对方e', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', ' ', 0, 4, 2306.83, -1675.43, 13.9221, 0, 0, 0, 1, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 5, 1);

-- --------------------------------------------------------

--
-- 表的结构 `ban`
--

CREATE TABLE IF NOT EXISTS `ban` (
  `ID` int(11) NOT NULL auto_increment,
  `PID` int(11) NOT NULL,
  `MAKEMAN` int(11) NOT NULL,
  `JOIN` int(11) NOT NULL,
  `LIMIT` int(11) NOT NULL,
  `CREATETIME` varchar(40) NOT NULL,
  `REASON` varchar(128) NOT NULL,
  PRIMARY KEY  (`ID`)
) ENGINE=MyISAM  DEFAULT CHARSET=gbk AUTO_INCREMENT=15 ;

--
-- 转存表中的数据 `ban`
--

INSERT INTO `ban` (`ID`, `PID`, `MAKEMAN`, `JOIN`, `LIMIT`, `CREATETIME`, `REASON`) VALUES
(14, 40, 0, -1, 0, '', '');

-- --------------------------------------------------------

--
-- 表的结构 `gang`
--

CREATE TABLE IF NOT EXISTS `gang` (
  `ID` int(11) NOT NULL,
  `NAME` varchar(80) NOT NULL,
  `CREATETIME` varchar(40) NOT NULL,
  `PID` int(11) NOT NULL,
  `COLOR` int(11) NOT NULL,
  `EXP` int(11) NOT NULL,
  `LEVEL` int(11) NOT NULL,
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `A` float NOT NULL,
  `RANK1` varchar(40) NOT NULL,
  `RANK2` varchar(40) NOT NULL,
  `RANK3` varchar(40) NOT NULL,
  `RANK4` varchar(40) NOT NULL,
  `MONEYBOX` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=gbk;

--
-- 转存表中的数据 `gang`
--


-- --------------------------------------------------------

--
-- 表的结构 `island`
--

CREATE TABLE IF NOT EXISTS `island` (
  `ID` int(11) NOT NULL auto_increment,
  `PID` int(11) NOT NULL,
  `NAME` varchar(80) NOT NULL,
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `MAPINDEX` int(11) NOT NULL,
  PRIMARY KEY  (`ID`)
) ENGINE=MyISAM  DEFAULT CHARSET=gbk AUTO_INCREMENT=47 ;

--
-- 转存表中的数据 `island`
--

INSERT INTO `island` (`ID`, `PID`, `NAME`, `X`, `Y`, `Z`, `MAPINDEX`) VALUES
(46, 25, 'd关闭g', 121.692, -77.35, 1.578, 0);

-- --------------------------------------------------------

--
-- 表的结构 `jiaju`
--

CREATE TABLE IF NOT EXISTS `jiaju` (
  `ID` int(11) NOT NULL auto_increment,
  `NAME` varchar(80) NOT NULL,
  `CREATETIME` varchar(40) NOT NULL,
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `RX` float NOT NULL,
  `RY` float NOT NULL,
  `RZ` float NOT NULL,
  `INTERIOR` int(11) NOT NULL,
  `WORLD` int(11) NOT NULL,
  `INDEX` int(11) NOT NULL,
  `MODELID` int(11) NOT NULL,
  `TXDID` int(11) NOT NULL,
  `COLORID` int(11) NOT NULL,
  `SIZEID` int(11) NOT NULL,
  `FONTID` int(11) NOT NULL,
  `FONTSIZE` int(11) NOT NULL,
  `BOLD` int(11) NOT NULL,
  `FONTCOLORID` int(11) NOT NULL,
  `BACKCOLORID` int(11) NOT NULL,
  `TEXTALIGNMENT` int(11) NOT NULL,
  `TEXT` varchar(2048) NOT NULL,
  `JOIN` int(11) NOT NULL,
  `LIMIT` int(11) NOT NULL,
  PRIMARY KEY  (`ID`)
) ENGINE=MyISAM  DEFAULT CHARSET=gbk AUTO_INCREMENT=7 ;

--
-- 转存表中的数据 `jiaju`
--

INSERT INTO `jiaju` (`ID`, `NAME`, `CREATETIME`, `X`, `Y`, `Z`, `RX`, `RY`, `RZ`, `INTERIOR`, `WORLD`, `INDEX`, `MODELID`, `TXDID`, `COLORID`, `SIZEID`, `FONTID`, `FONTSIZE`, `BOLD`, `FONTCOLORID`, `BACKCOLORID`, `TEXTALIGNMENT`, `TEXT`, `JOIN`, `LIMIT`) VALUES
(1, '系统家具', '2016/2/4 13:42:45', 2008.25, -1717.61, 13.547, 0, 0, 0, 0, 0, -1, 19128, 0, 0, -1, 0, 0, 0, 0, 0, 0, '', 390, 7352),
(2, '系统家具', '2016/2/4 13:56:40', 2003.89, -1709.66, 13.383, 0, 0, 0, 0, 0, -1, 19128, 0, 0, -1, 0, 0, 0, 0, 0, 0, '', 402, 7352),
(3, '系统家具', '2016/2/4 13:58:35', 2004.44, -1719.11, 13.383, 0, 0, 0, 0, 0, -1, 19128, 0, 0, -1, 0, 0, 0, 0, 0, 0, '', 403, 7352),
(4, '系统家具', '2016/2/4 14:03:57', 1998.83, -1715.68, 13.383, 0, 0, 0, 0, 0, -1, 19128, 0, 0, -1, 0, 0, 0, 0, 0, 0, '', 407, 7351),
(5, '系统家具', '2016/2/5 15:04:35', 489.275, -1723.58, 11.326, 0, 0, 0, 0, 0, -1, 19128, 0, 0, -1, 0, 0, 0, 0, 0, 0, '', 553, 7202),
(6, '系统家具', '2016/2/5 15:11:34', 2274.59, -1654.75, 15.176, 0, 0, 0, 0, 0, -1, 19128, 0, 0, -1, 0, 0, 0, 0, 0, 0, '', 558, 7200);

-- --------------------------------------------------------

--
-- 表的结构 `minigame`
--

CREATE TABLE IF NOT EXISTS `minigame` (
  `ID` float NOT NULL auto_increment,
  `NAME` varchar(80) NOT NULL,
  `RATE` int(11) NOT NULL,
  `X1` float NOT NULL,
  `Y1` float NOT NULL,
  `Z1` float NOT NULL,
  `X2` float NOT NULL,
  `Y2` float NOT NULL,
  `Z2` float NOT NULL,
  `INTREIOR` int(11) NOT NULL,
  `SKIN1` int(11) NOT NULL,
  `SKIN2` int(11) NOT NULL,
  `WEAPON1` int(11) NOT NULL default '0',
  `WEAPON2` int(11) NOT NULL default '0',
  `WEAPON3` int(11) NOT NULL default '0',
  `WEAPON4` int(11) NOT NULL default '0',
  `WEAPON5` int(11) NOT NULL default '0',
  `WEAPON6` int(11) NOT NULL default '0',
  `WEAPON7` int(11) NOT NULL default '0',
  `WEAPON8` int(11) NOT NULL default '0',
  `WEAPON9` int(11) NOT NULL default '0',
  `WEAPON10` int(11) NOT NULL default '0',
  `WEAPON11` int(11) NOT NULL default '0',
  `WEAPON12` int(11) NOT NULL default '0',
  PRIMARY KEY  (`ID`)
) ENGINE=MyISAM  DEFAULT CHARSET=gbk AUTO_INCREMENT=2 ;

--
-- 转存表中的数据 `minigame`
--

INSERT INTO `minigame` (`ID`, `NAME`, `RATE`, `X1`, `Y1`, `Z1`, `X2`, `Y2`, `Z2`, `INTREIOR`, `SKIN1`, `SKIN2`, `WEAPON1`, `WEAPON2`, `WEAPON3`, `WEAPON4`, `WEAPON5`, `WEAPON6`, `WEAPON7`, `WEAPON8`, `WEAPON9`, `WEAPON10`, `WEAPON11`, `WEAPON12`) VALUES
(1, '地图和投诉人的', 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- 表的结构 `msgbox`
--

CREATE TABLE IF NOT EXISTS `msgbox` (
  `ID` int(11) NOT NULL auto_increment,
  `PID` int(11) NOT NULL,
  `SENDER` varchar(80) NOT NULL,
  `MSG` varchar(256) NOT NULL,
  `CASH` int(11) NOT NULL,
  `QB` int(11) NOT NULL,
  `READ` int(11) NOT NULL,
  `SENDTIME` varchar(40) NOT NULL,
  PRIMARY KEY  (`ID`)
) ENGINE=MyISAM  DEFAULT CHARSET=gbk AUTO_INCREMENT=76 ;

--
-- 转存表中的数据 `msgbox`
--


-- --------------------------------------------------------

--
-- 表的结构 `server`
--

CREATE TABLE IF NOT EXISTS `server` (
  `ID` int(11) NOT NULL auto_increment,
  `RUNTIME` int(20) NOT NULL,
  `MODETEXT` varchar(80) NOT NULL,
  PRIMARY KEY  (`ID`)
) ENGINE=MyISAM  DEFAULT CHARSET=gbk AUTO_INCREMENT=2 ;

--
-- 转存表中的数据 `server`
--

INSERT INTO `server` (`ID`, `RUNTIME`, `MODETEXT`) VALUES
(1, 558, '0');

-- --------------------------------------------------------

--
-- 表的结构 `teleport`
--

CREATE TABLE IF NOT EXISTS `teleport` (
  `ID` int(11) NOT NULL auto_increment,
  `CMD` varchar(40) NOT NULL,
  `NAME` varchar(80) NOT NULL,
  `CREATETIME` varchar(40) NOT NULL,
  `PID` int(11) NOT NULL,
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `A` float NOT NULL,
  `INTERIOR` int(11) NOT NULL,
  `WORLD` int(11) NOT NULL,
  `COST` int(11) NOT NULL,
  `RATE` int(11) NOT NULL,
  `MONEYBOX` int(11) NOT NULL,
  `RANGE1` float NOT NULL,
  `RANGE2` float NOT NULL,
  PRIMARY KEY  (`ID`)
) ENGINE=MyISAM  DEFAULT CHARSET=gbk AUTO_INCREMENT=5 ;

--
-- 转存表中的数据 `teleport`
--

INSERT INTO `teleport` (`ID`, `CMD`, `NAME`, `CREATETIME`, `PID`, `X`, `Y`, `Z`, `A`, `INTERIOR`, `WORLD`, `COST`, `RATE`, `MONEYBOX`, `RANGE1`, `RANGE2`) VALUES
(1, '256', '试试', '2016/1/16 13:35:06', 4, 1284.14, -2047.47, 57.916, 0, 0, 0, 0, 6, 0, 0, 0),
(2, '256r', '试试', '2016/1/16 13:37:04', 4, 142.361, -74.943, 1.43, 0, 0, 0, 0, 3, 0, 0, 0),
(3, 'bb', '宝贝', '2016/1/18 11:28:08', 5, 151.61, -67.032, 1.43, 0, 0, 0, 0, 0, 0, 0, 0),
(4, '1234', '1234', '2016/1/19 12:56:20', 6, 123.641, -79.574, 1.578, 0, 0, 0, 0, 39, 0, 0, 0);

-- --------------------------------------------------------

--
-- 表的结构 `vip`
--

CREATE TABLE IF NOT EXISTS `vip` (
  `ID` int(11) NOT NULL auto_increment,
  `PID` int(11) NOT NULL,
  `LEVEL` int(11) NOT NULL,
  `JOIN` int(11) NOT NULL,
  `LIMIT` int(11) NOT NULL,
  PRIMARY KEY  (`ID`)
) ENGINE=MyISAM  DEFAULT CHARSET=gbk AUTO_INCREMENT=19 ;

--
-- 转存表中的数据 `vip`
--

INSERT INTO `vip` (`ID`, `PID`, `LEVEL`, `JOIN`, `LIMIT`) VALUES
(7, 21, 0, 0, 0),
(6, 20, 1, -1, 0),
(8, 22, 0, 0, 0),
(9, 23, 0, 0, 0),
(10, 24, 0, 0, 0),
(11, 25, 0, 0, 0),
(12, 26, 0, 0, 0),
(13, 27, 0, 0, 0),
(14, 35, 0, 0, 0),
(15, 36, 0, 0, 0),
(16, 38, 0, 0, 0),
(17, 39, 0, 0, 0),
(18, 40, 0, 0, 0);

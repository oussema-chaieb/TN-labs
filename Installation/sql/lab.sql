-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Erstellungszeit: 03. Mrz 2024 um 17:59
-- Server-Version: 10.4.32-MariaDB
-- PHP-Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `test`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `lab`
--

CREATE TABLE `lab` (
  `labname` varchar(50) NOT NULL,
  `code` varchar(50) NOT NULL,
  `quality` int(11) NOT NULL DEFAULT 0,
  `ingrediants` int(11) NOT NULL DEFAULT 0,
  `qualitytwo` int(11) NOT NULL DEFAULT 0,
  `rewardfirststage` int(11) NOT NULL DEFAULT 0,
  `rewardsecondstage` int(11) NOT NULL DEFAULT 0,
  `rewardthirdstage` int(11) NOT NULL DEFAULT 0,
  `time` int(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Daten für Tabelle `lab`
--

INSERT INTO `lab` (`labname`, `code`, `quality`, `ingrediants`, `qualitytwo`, `rewardfirststage`, `rewardsecondstage`, `rewardthirdstage`, `time`) VALUES
('cokelab', '1991', 0, 0, 0, 0, 0, 0, 0),
('methlab', '1234', 0, 0, 0, 10, 0, 0, 0);

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `lab`
--
ALTER TABLE `lab`
  ADD PRIMARY KEY (`labname`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

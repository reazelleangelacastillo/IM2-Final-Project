-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3307
-- Generation Time: May 21, 2026 at 09:13 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `queryshelf`
--

-- --------------------------------------------------------

--
-- Table structure for table `academic`
--

CREATE TABLE `academic` (
  `academic_id` varchar(20) NOT NULL,
  `accession_id` varchar(30) NOT NULL,
  `department` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `academic`
--

INSERT INTO `academic` (`academic_id`, `accession_id`, `department`) VALUES
('ACAD-001', 'ACC001', 'Mathematics'),
('ACAD-002', 'ACC002', 'Mathematics'),
('ACAD-003', 'ACC003', 'Mathematics'),
('ACAD-004', 'ACC004', 'Mathematics'),
('ACAD-005', 'ACC005', 'Mathematics'),
('ACAD-006', 'ACC006', 'Science'),
('ACAD-007', 'ACC007', 'Science'),
('ACAD-008', 'ACC008', 'Science'),
('ACAD-009', 'ACC009', 'Science'),
('ACAD-010', 'ACC010', 'Science'),
('ACAD-011', 'ACC011', 'History'),
('ACAD-012', 'ACC012', 'History'),
('ACAD-013', 'ACC013', 'History'),
('ACAD-014', 'ACC014', 'History'),
('ACAD-015', 'ACC015', 'History'),
('ACAD-016', 'ACC016', 'Research'),
('ACAD-017', 'ACC017', 'Research'),
('ACAD-018', 'ACC018', 'Research'),
('ACAD-019', 'ACC019', 'Research'),
('ACAD-020', 'ACC020', 'Research'),
('ACAD-021', 'ACC046', 'Mathematics'),
('ACAD-022', 'ACC047', 'Science'),
('ACAD-023', 'ACC048', 'History'),
('ACAD-024', 'ACC049', 'Research'),
('ACAD-025', 'ACC050', 'Mathematics'),
('ACAD-026', 'ACC051', 'Mathematics'),
('ACAD-027', 'ACC052', 'Mathematics'),
('ACAD-028', 'ACC053', 'Mathematics'),
('ACAD-029', 'ACC054', 'Mathematics'),
('ACAD-030', 'ACC055', 'Science'),
('ACAD-031', 'ACC056', 'Science'),
('ACAD-032', 'ACC057', 'Science'),
('ACAD-033', 'ACC058', 'Science'),
('ACAD-034', 'ACC059', 'Science'),
('ACAD-035', 'ACC060', 'History'),
('ACAD-036', 'ACC061', 'History'),
('ACAD-037', 'ACC062', 'History'),
('ACAD-038', 'ACC063', 'History'),
('ACAD-039', 'ACC064', 'History'),
('ACAD-040', 'ACC065', 'Research'),
('ACAD-041', 'ACC066', 'Research'),
('ACAD-042', 'ACC067', 'Research'),
('ACAD-043', 'ACC068', 'Research'),
('ACAD-044', 'ACC069', 'Research'),
('ACAD-045', 'ACC070', 'Reference'),
('ACAD-046', 'ACC071', 'Reference'),
('ACAD-047', 'ACC072', 'Reference'),
('ACAD-048', 'ACC073', 'Reference'),
('ACAD-049', 'ACC074', 'Reference'),
('ACAD-050', 'ACC075', 'Reference'),
('ACAD-051', 'ACC022', 'Reference'),
('ACAD-052', 'ACC023', 'Reference'),
('ACAD-053', 'ACC024', 'Reference'),
('ACAD-054', 'ACC025', 'Reference'),
('ACAD-055', 'ACC097', 'Science'),
('ACAD-056', 'ACC098', 'History'),
('ACAD-057', 'ACC099', 'Research');

-- --------------------------------------------------------

--
-- Table structure for table `author`
--

CREATE TABLE `author` (
  `author_id` varchar(20) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `middle_initial` char(1) DEFAULT NULL,
  `author_num` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `author`
--

INSERT INTO `author` (`author_id`, `first_name`, `last_name`, `middle_initial`, `author_num`) VALUES
('AUTH001', 'Maria', 'Santos', 'S', 1),
('AUTH002', 'John', 'Cruz', 'C', 2),
('AUTH003', 'Carla', 'Reyes', 'R', 3),
('AUTH004', 'Mark', 'Dela Cruz', 'D', 4),
('AUTH005', 'Angela', 'Lopez', 'L', 5),
('AUTH006', 'Kevin', 'Ramos', 'R', 6),
('AUTH007', 'Sophia', 'Garcia', 'G', 7),
('AUTH008', 'Daniel', 'Flores', 'F', 8),
('AUTH009', 'Nicole', 'Torres', 'T', 9),
('AUTH010', 'Ethan', 'Perez', 'P', 10),
('AUTH011', 'Joshua', 'Bautista', 'B', 11),
('AUTH012', 'Bea', 'Navarro', 'N', 12),
('AUTH013', 'Christian', 'Aquino', 'A', 13),
('AUTH014', 'Faith', 'Castillo', 'C', 14),
('AUTH015', 'Vincent', 'Rivera', 'R', 15),
('AUTH016', 'Chloe', 'Morales', 'M', 16),
('AUTH017', 'Ryan', 'Herrera', 'H', 17),
('AUTH018', 'Alyssa', 'Gomez', 'G', 18),
('AUTH019', 'Carl', 'Diaz', 'D', 19),
('AUTH020', 'Jasmine', 'Ramos', 'R', 20),
('AUTH021', 'Patrick', 'Mendoza', 'M', 21),
('AUTH022', 'Hannah', 'Reyes', 'R', 22),
('AUTH023', 'Sean', 'Santos', 'S', 23),
('AUTH024', 'Angel', 'Cruz', 'C', 24),
('AUTH025', 'Gabriel', 'Flores', 'F', 25),
('AUTH026', 'Kim', 'Torres', 'T', 26),
('AUTH027', 'Nathan', 'Garcia', 'G', 27),
('AUTH028', 'Ella', 'Lopez', 'L', 28),
('AUTH029', 'Adrian', 'Perez', 'P', 29),
('AUTH030', 'Trisha', 'Aquino', 'A', 30),
('AUTH031', 'Kyle', 'Bautista', 'B', 31),
('AUTH032', 'Denise', 'Rivera', 'R', 32),
('AUTH033', 'Matthew', 'Navarro', 'N', 33),
('AUTH034', 'Princess', 'Castillo', 'C', 34),
('AUTH035', 'Jacob', 'Diaz', 'D', 35),
('AUTH036', 'Rica', 'Morales', 'M', 36),
('AUTH037', 'Aaron', 'Herrera', 'H', 37),
('AUTH038', 'Bianca', 'Gomez', 'G', 38),
('AUTH039', 'Paul', 'Ramos', 'R', 39),
('AUTH040', 'Kate', 'Mendoza', 'M', 40),
('AUTH041', 'Jericho', 'Reyes', 'R', 41),
('AUTH042', 'Mae', 'Santos', 'S', 42),
('AUTH043', 'Joseph', 'Cruz', 'C', 43),
('AUTH044', 'Christine', 'Flores', 'F', 44),
('AUTH045', 'Leo', 'Torres', 'T', 45),
('AUTH046', 'Samantha', 'Garcia', 'G', 46),
('AUTH047', 'Marco', 'Lopez', 'L', 47),
('AUTH048', 'Camille', 'Perez', 'P', 48),
('AUTH049', 'Ivan', 'Aquino', 'A', 49),
('AUTH050', 'Lovely', 'Bautista', 'B', 50),
('AUTH051', 'Michael', 'Belmonte', 'B', 51),
('AUTH052', 'Hannah', 'Basco', 'B', 52),
('AUTH053', 'Rafael', 'Nery', 'N', 53),
('AUTH054', 'Daniel', 'Ang', 'A', 54),
('AUTH055', 'William', 'Fernandez', 'F', 55),
('AUTH056', 'Wesley', 'Reyes', 'R', 56),
('AUTH057', 'Robert', 'Lomsoc', 'L', 57),
('AUTH058', 'Andrew', 'Cabacungan', 'C', 58),
('AUTH059', 'Quentin', 'Enopia', 'E', 59),
('AUTH060', 'Joshua', 'Macasaet', 'M', 60),
('AUTH061', 'Kenneth', 'Tieng', 'T', 61),
('AUTH062', 'Liam', 'Miller', 'M', 62),
('AUTH063', 'Choi', 'Min', 'M', 63),
('AUTH064', 'Ian', 'Cruz', 'C', 64),
('AUTH065', 'Miguel', 'Lopa', 'L', 65),
('AUTH066', 'Francis', 'Co', 'C', 66),
('AUTH067', 'Jacob', 'Ng', 'N', 67),
('AUTH068', 'Lauren', 'Katigbak', 'K', 68),
('AUTH069', 'Tristan', 'Salterio', 'S', 69),
('AUTH070', 'Ethan', 'Paredes', 'P', 70),
('AUTH071', 'Rafael', 'Diego', 'D', 71),
('AUTH072', 'Dominic', 'Sison', 'S', 72),
('AUTH073', 'Julius', 'Quirino', 'Q', 73),
('AUTH074', 'Gabriel', 'Castillo', 'C', 74),
('AUTH075', 'Adrian', 'Dizon', 'D', 75),
('AUTH076', 'Vincent', 'Ramirez', 'R', 76),
('AUTH077', 'Sophia', 'Cruz', 'C', 77),
('AUTH078', 'Brian', 'Guzman', 'G', 78),
('AUTH079', 'Charles', 'Valderama', 'V', 79),
('AUTH080', 'James', 'Santos', 'S', 80),
('AUTH081', 'Alexander', 'Villanueva', 'M', 81),
('AUTH082', 'Patricia', 'Fernandez', 'L', 82),
('AUTH083', 'Dominic', 'Santiago', 'R', 83),
('AUTH084', 'Vanessa', 'Mendoza', 'C', 84),
('AUTH085', 'Elijah', 'Ramos', 'P', 85),
('AUTH086', 'Krystal', 'Bautista', 'A', 86),
('AUTH087', 'Nathaniel', 'Flores', 'G', 87),
('AUTH088', 'Andrea', 'Reyes', 'T', 88),
('AUTH089', 'Vincent', 'Navarro', 'D', 89),
('AUTH090', 'Kimberly', 'Garcia', 'S', 90),
('AUTH091', 'Joshua', 'Santos', 'M', 91),
('AUTH092', 'Pauline', 'Cruz', 'R', 92),
('AUTH093', 'Jerome', 'Castillo', 'B', 93),
('AUTH094', 'Charlene', 'Torres', 'F', 94),
('AUTH095', 'Matthew', 'Diaz', 'L', 95),
('AUTH096', 'Cassandra', 'Aquino', 'N', 96),
('AUTH097', 'Patrick', 'Lopez', 'C', 97),
('AUTH098', 'Denise', 'Morales', 'G', 98),
('AUTH099', 'Ethan', 'Rivera', 'V', 99),
('AUTH100', 'Angela', 'Herrera', 'P', 100),
('AUTH101', 'Christian', 'Gomez', 'A', 101),
('AUTH102', 'Trisha', 'Mendoza', 'D', 102),
('AUTH103', 'Kevin', 'Perez', 'S', 103),
('AUTH104', 'Nicole', 'Bautista', 'M', 104),
('AUTH105', 'Raphael', 'Reyes', 'T', 105),
('AUTH106', 'Bianca', 'Flores', 'C', 106),
('AUTH107', 'Joshua', 'Santos', 'R', 107),
('AUTH108', 'Samantha', 'Cruz', 'L', 108),
('AUTH109', 'Adrian', 'Navarro', 'B', 109),
('AUTH110', 'Faith', 'Garcia', 'G', 110),
('AUTH111', 'Daniel', 'Torres', 'P', 111),
('AUTH112', 'Princess', 'Aquino', 'A', 112),
('AUTH113', 'Sean', 'Diaz', 'D', 113),
('AUTH114', 'Camille', 'Lopez', 'F', 114),
('AUTH115', 'Marco', 'Rivera', 'N', 115),
('AUTH116', 'Alyssa', 'Morales', 'M', 116),
('AUTH117', 'Gabriel', 'Herrera', 'S', 117),
('AUTH118', 'Hannah', 'Gomez', 'T', 118),
('AUTH119', 'Jacob', 'Ramos', 'C', 119),
('AUTH120', 'Sophia', 'Mendoza', 'V', 120),
('AUTH121', 'Ivan', 'Perez', 'L', 121),
('AUTH122', 'Bea', 'Castillo', 'R', 122),
('AUTH123', 'Carl', 'Santos', 'P', 123),
('AUTH124', 'Rica', 'Reyes', 'A', 124),
('AUTH125', 'Aaron', 'Flores', 'G', 125),
('AUTH126', 'Lovely', 'Cruz', 'D', 126),
('AUTH127', 'Jericho', 'Bautista', 'N', 127),
('AUTH128', 'Chloe', 'Navarro', 'M', 128),
('AUTH129', 'Nathan', 'Garcia', 'S', 129),
('AUTH130', 'Ella', 'Torres', 'T', 130);

-- --------------------------------------------------------

--
-- Table structure for table `book format`
--

CREATE TABLE `book format` (
  `format_id` varchar(20) NOT NULL,
  `format_type` varchar(50) NOT NULL,
  `recommended_age` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `book format`
--

INSERT INTO `book format` (`format_id`, `format_type`, `recommended_age`) VALUES
('FI01', 'Picture Book', '4–7 years'),
('FI02', 'Activity Book', '4–7 years'),
('FI03', 'Story Book', '5–8 years'),
('FI04', 'Story Book', '5–8 years'),
('FI05', 'Illustrated Story', '6–10 years'),
('FI06', 'Educational Workbook', '4–7 years'),
('FI07', 'Educational Workbook', '4–7 years'),
('FI08', 'Science Reader', '6–9 years'),
('FI09', 'Mythology Reader', '6–10 years'),
('FI10', 'Nature Guide Book', '6–10 years');

-- --------------------------------------------------------

--
-- Table structure for table `books`
--

CREATE TABLE `books` (
  `accession_id` varchar(30) NOT NULL,
  `id_status` int(11) NOT NULL,
  `pub_id` varchar(30) NOT NULL,
  `class_no` varchar(50) NOT NULL,
  `call_no` varchar(50) NOT NULL,
  `ISBN` varchar(25) DEFAULT NULL,
  `category` varchar(50) NOT NULL CHECK (`category` in ('Academic','Non-Academic'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `books`
--

INSERT INTO `books` (`accession_id`, `id_status`, `pub_id`, `class_no`, `call_no`, `ISBN`, `category`) VALUES
('ACC001', 110001, 'PUB001', '512', '512.S23', '978-621-13-9357-5', 'Academic'),
('ACC002', 110002, 'PUB002', '515', '515.C78', '978-621-42-4926-8', 'Academic'),
('ACC003', 110003, 'PUB003', '516', '516.R49', '978-621-06-3560-7', 'Academic'),
('ACC004', 110004, 'PUB004', '519.5', '519.D45', '978-971-61-0332-8', 'Academic'),
('ACC005', 110005, 'PUB005', '516.245', '516.L86', '978-123-59-1678-6', 'Academic'),
('ACC006', 110006, 'PUB006', '570', '570.R18', '978-621-64-4509-5', 'Academic'),
('ACC007', 110007, 'PUB007', '540', '540.G34', '978-123-51-1550-9', 'Academic'),
('ACC008', 110008, 'PUB008', '530', '530.F56', '978-123-60-6533-9', 'Academic'),
('ACC009', 110009, 'PUB009', '550', '550.T89', '978-621-12-7217-7', 'Academic'),
('ACC010', 110010, 'PUB010', '363.7', '363.P45', '978-123-80-8526-7', 'Academic'),
('ACC011', 110011, 'PUB011', '959.9', '959.B22', '978-971-79-2932-3', 'Academic'),
('ACC012', 110012, 'PUB012', '909', '909.N14', '978-123-31-3494-6', 'Academic'),
('ACC013', 110013, 'PUB013', '950', '950.A45', '978-123-71-3963-3', 'Academic'),
('ACC014', 110014, 'PUB014', '920', '920.C38', '978-621-07-8135-9', 'Academic'),
('ACC015', 110015, 'PUB015', '930', '930.R57', '978-621-61-3389-3', 'Academic'),
('ACC016', 110016, 'PUB016', '1.4001', '1.M12', '978-971-20-8992-3', 'Academic'),
('ACC017', 110017, 'PUB017', '1.4001', '1.H34', '978-123-10-7220-2', 'Academic'),
('ACC018', 110018, 'PUB018', '1.4001', '1.G56', '978-621-71-6508-4', 'Academic'),
('ACC019', 110019, 'PUB019', '1.42001', '1.D78', '978-621-14-0620-6', 'Academic'),
('ACC020', 110020, 'PUB020', '1.43001', '1.R90', '978-123-26-8602-6', 'Academic'),
('ACC021', 110021, 'PUB021', '423', '423.M22', '978-621-14-9759-4', 'Academic'),
('ACC022', 110022, 'PUB022', '503', '503.R14', '978-971-58-0043-3', 'Academic'),
('ACC023', 110023, 'PUB023', '912', '912.S35', '978-123-58-1721-2', 'Academic'),
('ACC024', 110024, 'PUB024', '400', '4.C18', '978-971-45-4117-7', 'Academic'),
('ACC025', 110025, 'PUB025', '610', '610.F56', '978-971-00-5412-1', 'Academic'),
('ACC026', 110026, 'PUB026', '158.1', '158.T45', '978-123-90-4244-3', 'Non-Academic'),
('ACC027', 110027, 'PUB027', '158.1', '158.G12', '978-621-37-6931-6', 'Non-Academic'),
('ACC028', 110028, 'PUB028', '155.2', '155.L89', '978-971-90-5716-1', 'Non-Academic'),
('ACC029', 110029, 'PUB029', '158.1', '158.P34', '978-971-67-1886-7', 'Non-Academic'),
('ACC030', 110030, 'PUB030', '650.1', '650.A67', '978-621-56-1429-4', 'Non-Academic'),
('ACC031', 110031, 'PUB031', '641.59', '641.B31', '978-971-34-3190-5', 'Non-Academic'),
('ACC032', 110032, 'PUB032', '641.81', '641.R32', '978-123-90-5309-8', 'Non-Academic'),
('ACC033', 110033, 'PUB033', '641.56', '641.N33', '978-971-75-0699-9', 'Non-Academic'),
('ACC034', 110034, 'PUB034', '641.5956', '641.C34', '978-621-24-8785-3', 'Non-Academic'),
('ACC035', 110035, 'PUB035', '641.86', '641.D35', '978-971-00-7722-9', 'Non-Academic'),
('ACC036', 110036, 'PUB036', '741.5', '741.M12', '978-971-10-1017-1', 'Non-Academic'),
('ACC037', 110037, 'PUB037', '741.5', '741.H34', '978-123-80-8662-2', 'Non-Academic'),
('ACC038', 110038, 'PUB038', '741.5', '741.G56', '978-123-26-6278-5', 'Non-Academic'),
('ACC039', 110039, 'PUB039', '741.5', '741.R78', '978-123-91-3425-4', 'Non-Academic'),
('ACC040', 110040, 'PUB040', '741.5', '741.M90', '978-123-68-9576-9', 'Non-Academic'),
('ACC041', 110041, 'PUB041', '398.2', '398.R49', '978-123-51-1778-7', 'Non-Academic'),
('ACC042', 110042, 'PUB042', '372.4', '372.S23', '978-123-56-4844-1', 'Non-Academic'),
('ACC043', 110043, 'PUB043', '372.7', '372.C78', '978-971-96-5466-7', 'Non-Academic'),
('ACC044', 110044, 'PUB044', '808.8', '808.F56', '978-971-52-4435-0', 'Non-Academic'),
('ACC045', 110045, 'PUB045', '590', '590.T89', '978-971-70-0401-3', 'Non-Academic'),
('ACC046', 110046, 'PUB046', '512.5', '512.G12', '978-621-31-4964-4', 'Academic'),
('ACC047', 110047, 'PUB047', '547', '547.L67', '978-123-33-2739-3', 'Academic'),
('ACC048', 110048, 'PUB048', '950', '950.P34', '978-123-29-5572-6', 'Academic'),
('ACC049', 110049, 'PUB049', '1.4001', '1.A56', '978-123-56-3004-0', 'Academic'),
('ACC050', 110050, 'PUB050', '158.1', '158.B22', '978-971-06-2103-3', 'Non-Academic'),
('ACC051', 110051, 'PUB051', '512', '158.B23', '978-621-50-0397-5', 'Academic'),
('ACC052', 110052, 'PUB052', '519.5', '158.B24', '978-971-40-2045-0', 'Academic'),
('ACC053', 110053, 'PUB053', '519.2', '158.B25', '978-621-80-4760-0', 'Academic'),
('ACC054', 110054, 'PUB054', '515.35', '158.B26', '978-971-86-9322-3', 'Academic'),
('ACC055', 110055, 'PUB055', '511.3', '158.B27', '978-971-07-2170-2', 'Academic'),
('ACC056', 110056, 'PUB056', '611', '158.B28', '978-621-12-8081-3', 'Academic'),
('ACC057', 110057, 'PUB057', '576.5', '158.B29', '978-621-94-5376-9', 'Academic'),
('ACC058', 110058, 'PUB058', '520', '158.B30', '978-123-21-5171-5', 'Academic'),
('ACC059', 110059, 'PUB059', '578.77', '158.B31', '978-971-23-6423-5', 'Academic'),
('ACC060', 110060, 'PUB060', '577', '158.B32', '978-621-40-0505-5', 'Academic'),
('ACC061', 110061, 'PUB061', '959.9', '158.B33', '978-621-84-2637-5', 'Academic'),
('ACC062', 110062, 'PUB062', '950', '158.B34', '978-123-01-9708-1', 'Academic'),
('ACC063', 110063, 'PUB063', '940', '158.B35', '978-621-45-8578-6', 'Academic'),
('ACC064', 110064, 'PUB064', '909.82', '158.B36', '978-123-93-9627-0', 'Academic'),
('ACC065', 110065, 'PUB065', '306', '158.B37', '978-123-28-4008-4', 'Academic'),
('ACC066', 110066, 'PUB066', '1.42', '158.B38', '978-971-63-3824-9', 'Academic'),
('ACC067', 110067, 'PUB067', '1.43', '158.B39', '978-123-93-4820-0', 'Academic'),
('ACC068', 110068, 'PUB068', '519.5', '158.B40', '978-621-09-2760-3', 'Academic'),
('ACC069', 110069, 'PUB069', '808.06', '158.B41', '978-621-78-4471-2', 'Academic'),
('ACC070', 110070, 'PUB070', '808.02', '158.B42', '978-621-55-2985-7', 'Academic'),
('ACC071', 110071, 'PUB071', '500', 'REF-SCI-071', '978-123-10-6402-3', 'Academic'),
('ACC072', 110072, 'PUB072', '912', 'REF-ATL-072', '978-123-35-4668-8', 'Academic'),
('ACC073', 110073, 'PUB073', '423', 'REF-DIC-073', '978-621-41-2672-9', 'Academic'),
('ACC074', 110074, 'PUB074', '4', 'REF-ITR-074', '978-621-08-1054-7', 'Academic'),
('ACC075', 110075, 'PUB075', '158.1', 'SH-075', '978-621-78-4253-4', 'Non-Academic'),
('ACC076', 110076, 'PUB076', '332.024', 'SH-076', '978-971-87-7217-1', 'Non-Academic'),
('ACC077', 110077, 'PUB077', '155.2', 'SH-077', '978-621-45-3515-6', 'Non-Academic'),
('ACC078', 110078, 'PUB078', '158.1', 'SH-078', '978-123-18-9257-2', 'Non-Academic'),
('ACC079', 110079, 'PUB079', '658.4', 'SH-079', '978-971-13-1770-6', 'Non-Academic'),
('ACC080', 110080, 'PUB080', '641.86', 'CK-080', '978-621-82-3773-5', 'Non-Academic'),
('ACC081', 110081, 'PUB081', '641.56', '641.B81', '978-971-89-5375-4', 'Non-Academic'),
('ACC082', 110082, 'PUB082', '641.56', '641.R82', '978-621-55-2385-5', 'Non-Academic'),
('ACC083', 110083, 'PUB083', '641.86', '641.N83', '978-621-50-3314-9', 'Non-Academic'),
('ACC084', 110084, 'PUB084', '641.59', '641.C84', '978-971-46-3262-2', 'Non-Academic'),
('ACC085', 110085, 'PUB085', '641.56', '641.D85', '978-123-53-7301-5', 'Non-Academic'),
('ACC086', 110086, 'PUB086', '741.5', '741.M86', '978-971-04-7277-2', 'Non-Academic'),
('ACC087', 110087, 'PUB087', '741.5', '741.H87', '978-971-88-9424-8', 'Non-Academic'),
('ACC088', 110088, 'PUB088', '741.5', '741.G88', '978-971-81-3866-3', 'Non-Academic'),
('ACC089', 110089, 'PUB089', '741.5', '741.R89', '978-123-04-3071-3', 'Non-Academic'),
('ACC090', 110090, 'PUB090', '741.5', '741.M90', '978-971-75-4273-7', 'Non-Academic'),
('ACC091', 110091, 'PUB091', '372.1', '372.R91', '978-123-15-9877-1', 'Non-Academic'),
('ACC092', 110092, 'PUB092', '372.7', '372.S92', '978-123-33-1385-3', 'Non-Academic'),
('ACC093', 110093, 'PUB093', '507', '507.C93', '978-123-19-3666-5', 'Non-Academic'),
('ACC094', 110094, 'PUB094', '398.2', '398.F94', '978-123-60-6297-0', 'Non-Academic'),
('ACC095', 110095, 'PUB095', '590', '590.T95', '978-621-41-6638-1', 'Non-Academic'),
('ACC096', 110096, 'PUB096', '512', '512.G96', '978-971-24-9401-7', 'Academic'),
('ACC097', 110097, 'PUB097', '530', '530.L97', '978-123-59-0891-0', 'Academic'),
('ACC098', 110098, 'PUB098', '959.9', '959.P98', '978-971-99-0744-2', 'Academic'),
('ACC099', 110099, 'PUB099', '1.42001', '1.A99', '978-971-09-8509-8', 'Academic'),
('ACC100', 110100, 'PUB100', '158.1', '158.B10', '978-621-97-9974-4', 'Non-Academic');

-- --------------------------------------------------------

--
-- Table structure for table `borrower`
--

CREATE TABLE `borrower` (
  `borrower_id` varchar(10) NOT NULL,
  `user_id` int(11) NOT NULL,
  `borrower_type` varchar(30) NOT NULL CHECK (`borrower_type` in ('Internal','External'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `borrower`
--

INSERT INTO `borrower` (`borrower_id`, `user_id`, `borrower_type`) VALUES
('BOR001', 100005, 'Internal'),
('BOR002', 100006, 'Internal'),
('BOR003', 100007, 'Internal'),
('BOR004', 100008, 'Internal'),
('BOR005', 100009, 'External'),
('BOR006', 100010, 'External'),
('BOR007', 100011, 'External'),
('BOR008', 100012, 'External'),
('BOR009', 100013, 'External'),
('BOR010', 100014, 'External'),
('BOR011', 100015, 'External'),
('BOR012', 100016, 'External'),
('BOR013', 100017, 'External'),
('BOR014', 100018, 'External'),
('BOR015', 100019, 'External'),
('BOR016', 100020, 'External'),
('BOR017', 100021, 'External'),
('BOR018', 100022, 'External'),
('BOR019', 100023, 'External'),
('BOR020', 100024, 'External'),
('BOR021', 100025, 'External'),
('BOR022', 100026, 'External'),
('BOR023', 100027, 'External'),
('BOR024', 100028, 'External'),
('BOR025', 100029, 'External'),
('BOR026', 100030, 'External'),
('BOR027', 100031, 'External'),
('BOR028', 100032, 'External'),
('BOR029', 100033, 'External'),
('BOR030', 100034, 'External'),
('BOR031', 100035, 'External'),
('BOR032', 100036, 'External'),
('BOR033', 100037, 'External'),
('BOR034', 100038, 'External'),
('BOR035', 100039, 'External'),
('BOR036', 100040, 'External'),
('BOR037', 100041, 'External'),
('BOR038', 100042, 'External'),
('BOR039', 100043, 'External'),
('BOR040', 100044, 'External'),
('BOR041', 100045, 'External'),
('BOR042', 100046, 'External'),
('BOR043', 100047, 'External'),
('BOR044', 100048, 'External'),
('BOR045', 100049, 'External'),
('BOR046', 100050, 'External'),
('BOR047', 100051, 'External'),
('BOR048', 100052, 'External'),
('BOR049', 100053, 'External'),
('BOR050', 100054, 'External'),
('BOR051', 100055, 'External'),
('BOR052', 100056, 'External'),
('BOR053', 100057, 'External'),
('BOR054', 100058, 'External'),
('BOR055', 100059, 'External'),
('BOR056', 100060, 'External'),
('BOR057', 100061, 'External');

-- --------------------------------------------------------

--
-- Table structure for table `borrowing period`
--

CREATE TABLE `borrowing period` (
  `borrowingperiod_id` varchar(30) NOT NULL,
  `duration` int(11) NOT NULL CHECK (`duration` between 1 and 30)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `borrowing period`
--

INSERT INTO `borrowing period` (`borrowingperiod_id`, `duration`) VALUES
('BP001', 7),
('BP002', 7),
('BP003', 7),
('BP004', 7),
('BP005', 7),
('BP006', 7),
('BP007', 7),
('BP008', 7),
('BP009', 7),
('BP010', 7),
('BP011', 7),
('BP012', 7),
('BP013', 7),
('BP014', 7),
('BP015', 7),
('BP016', 7),
('BP017', 7),
('BP018', 7),
('BP019', 7),
('BP020', 7),
('BP021', 7),
('BP022', 7),
('BP023', 7),
('BP024', 7),
('BP025', 7),
('BP026', 7),
('BP027', 7),
('BP028', 7),
('BP029', 7),
('BP030', 7),
('BP031', 7),
('BP032', 7),
('BP033', 7),
('BP034', 7),
('BP035', 7),
('BP036', 7),
('BP037', 7),
('BP038', 7),
('BP039', 7),
('BP040', 7),
('BP041', 7),
('BP042', 7),
('BP043', 7),
('BP044', 7),
('BP045', 7),
('BP046', 7),
('BP047', 7),
('BP048', 7),
('BP049', 7),
('BP050', 7),
('BP051', 7),
('BP052', 7),
('BP053', 7),
('BP054', 7),
('BP055', 7),
('BP056', 7),
('BP057', 7);

-- --------------------------------------------------------

--
-- Table structure for table `borrow reference`
--

CREATE TABLE `borrow reference` (
  `borrow_id` varchar(30) NOT NULL,
  `user_id` int(11) NOT NULL,
  `pub_id` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `borrow reference`
--

INSERT INTO `borrow reference` (`borrow_id`, `user_id`, `pub_id`) VALUES
('BOR001', 100005, 'PUB038'),
('BOR002', 100006, 'PUB039'),
('BOR003', 100007, 'PUB040'),
('BOR004', 100008, 'PUB057'),
('BOR005', 100009, 'PUB058'),
('BOR006', 100010, 'PUB059'),
('BOR007', 100011, 'PUB060'),
('BOR008', 100012, 'PUB061'),
('BOR009', 100013, 'PUB035'),
('BOR010', 100014, 'PUB036'),
('BOR011', 100015, 'PUB037'),
('BOR012', 100016, 'PUB093'),
('BOR013', 100017, 'PUB094'),
('BOR014', 100018, 'PUB040'),
('BOR015', 100019, 'PUB075'),
('BOR016', 100020, 'PUB076'),
('BOR017', 100021, 'PUB001'),
('BOR018', 100022, 'PUB010'),
('BOR019', 100023, 'PUB016'),
('BOR020', 100024, 'PUB022'),
('BOR021', 100025, 'PUB029'),
('BOR022', 100026, 'PUB046'),
('BOR023', 100027, 'PUB060'),
('BOR024', 100028, 'PUB092'),
('BOR025', 100029, 'PUB053'),
('BOR026', 100030, 'PUB054'),
('BOR027', 100031, 'PUB055'),
('BOR028', 100032, 'PUB041'),
('BOR029', 100033, 'PUB042'),
('BOR030', 100034, 'PUB043'),
('BOR031', 100035, 'PUB044'),
('BOR032', 100036, 'PUB045'),
('BOR033', 100037, 'PUB003'),
('BOR034', 100038, 'PUB004'),
('BOR035', 100039, 'PUB005'),
('BOR036', 100040, 'PUB006'),
('BOR037', 100041, 'PUB078'),
('BOR038', 100042, 'PUB079'),
('BOR039', 100043, 'PUB067'),
('BOR040', 100044, 'PUB068'),
('BOR041', 100045, 'PUB069'),
('BOR042', 100046, 'PUB033'),
('BOR043', 100047, 'PUB034'),
('BOR044', 100048, 'PUB035'),
('BOR045', 100049, 'PUB036'),
('BOR046', 100050, 'PUB037'),
('BOR047', 100051, 'PUB075'),
('BOR048', 100052, 'PUB076'),
('BOR049', 100053, 'PUB077'),
('BOR050', 100054, 'PUB078'),
('BOR051', 100055, 'PUB072'),
('BOR052', 100056, 'PUB073'),
('BOR053', 100057, 'PUB074'),
('BOR054', 100058, 'PUB011'),
('BOR055', 100059, 'PUB100'),
('BOR056', 100060, 'PUB072'),
('BOR057', 100061, 'PUB053');

-- --------------------------------------------------------

--
-- Table structure for table `borrows`
--

CREATE TABLE `borrows` (
  `borrow_id` varchar(30) NOT NULL,
  `user_id` int(11) NOT NULL,
  `date_borrowed` date NOT NULL,
  `date_returned` date DEFAULT NULL,
  `borrowingperiod_id` varchar(30) NOT NULL,
  `accession_id` varchar(30) NOT NULL,
  `due_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `borrows`
--

INSERT INTO `borrows` (`borrow_id`, `user_id`, `date_borrowed`, `date_returned`, `borrowingperiod_id`, `accession_id`, `due_date`) VALUES
('BOR001', 100005, '2026-04-20', '2026-04-24', 'BP001', 'ACC038', '2026-04-27'),
('BOR002', 100006, '2026-04-20', '2026-04-24', 'BP002', 'ACC039', '2026-04-27'),
('BOR003', 100007, '2026-04-21', '2026-04-27', 'BP003', 'ACC040', '2026-04-28'),
('BOR004', 100008, '2026-04-21', '2026-04-27', 'BP004', 'ACC057', '2026-04-28'),
('BOR005', 100009, '2026-04-22', '2026-04-28', 'BP005', 'ACC058', '2026-04-29'),
('BOR006', 100010, '2026-04-22', '2026-04-28', 'BP006', 'ACC059', '2026-04-29'),
('BOR007', 100011, '2026-04-23', '2026-04-29', 'BP007', 'ACC060', '2026-04-30'),
('BOR008', 100012, '2026-04-23', '2026-04-29', 'BP008', 'ACC061', '2026-04-30'),
('BOR009', 100013, '2026-04-24', '2026-04-30', 'BP009', 'ACC035', '2026-05-01'),
('BOR010', 100014, '2026-04-24', '2026-05-01', 'BP010', 'ACC036', '2026-05-01'),
('BOR011', 100015, '2026-04-27', '2026-05-01', 'BP011', 'ACC037', '2026-05-04'),
('BOR012', 100016, '2026-04-27', '2026-05-01', 'BP012', 'ACC093', '2026-05-04'),
('BOR013', 100017, '2026-04-28', '2026-05-07', 'BP013', 'ACC094', '2026-05-05'),
('BOR014', 100018, '2026-04-28', '2026-05-04', 'BP014', 'ACC040', '2026-05-05'),
('BOR015', 100019, '2026-04-29', '2026-05-05', 'BP015', 'ACC075', '2026-05-06'),
('BOR016', 100020, '2026-04-29', '2026-05-05', 'BP016', 'ACC076', '2026-05-06'),
('BOR017', 100021, '2026-04-30', '2026-05-06', 'BP017', 'ACC001', '2026-05-07'),
('BOR018', 100022, '2026-04-30', '2026-05-07', 'BP018', 'ACC010', '2026-05-07'),
('BOR019', 100023, '2026-05-01', '2026-05-06', 'BP019', 'ACC016', '2026-05-08'),
('BOR020', 100024, '2026-05-01', '2026-05-09', 'BP020', 'ACC022', '2026-05-08'),
('BOR021', 100025, '2026-05-04', '2026-05-08', 'BP021', 'ACC029', '2026-05-11'),
('BOR022', 100026, '2026-05-04', '2026-05-08', 'BP022', 'ACC046', '2026-05-11'),
('BOR023', 100027, '2026-05-05', '2026-05-11', 'BP023', 'ACC060', '2026-05-12'),
('BOR024', 100028, '2026-05-05', '2026-05-11', 'BP024', 'ACC092', '2026-05-12'),
('BOR025', 100029, '2026-05-06', '2026-05-12', 'BP025', 'ACC053', '2026-05-13'),
('BOR026', 100030, '2026-05-06', '2026-05-12', 'BP026', 'ACC054', '2026-05-13'),
('BOR027', 100031, '2026-05-07', '2026-05-13', 'BP027', 'ACC055', '2026-05-14'),
('BOR028', 100032, '2026-05-07', '2026-05-13', 'BP028', 'ACC041', '2026-05-14'),
('BOR029', 100033, '2026-05-08', '2026-05-14', 'BP029', 'ACC042', '2026-05-15'),
('BOR030', 100034, '2026-05-08', '2026-05-14', 'BP030', 'ACC043', '2026-05-15'),
('BOR031', 100035, '2026-05-11', '2026-05-15', 'BP031', 'ACC044', '2026-05-18'),
('BOR032', 100036, '2026-05-11', '2026-05-15', 'BP032', 'ACC045', '2026-05-18'),
('BOR033', 100037, '2026-05-12', '2026-05-18', 'BP033', 'ACC003', '2026-05-19'),
('BOR034', 100038, '2026-05-12', '2026-05-18', 'BP034', 'ACC004', '2026-05-19'),
('BOR035', 100039, '2026-05-13', '2026-05-19', 'BP035', 'ACC005', '2026-05-20'),
('BOR036', 100040, '2026-05-13', '2026-05-20', 'BP036', 'ACC006', '2026-05-20'),
('BOR037', 100041, '2026-05-14', '2026-05-21', 'BP037', 'ACC078', '2026-05-21'),
('BOR038', 100042, '2026-05-14', '2026-05-21', 'BP038', 'ACC079', '2026-05-21'),
('BOR039', 100043, '2026-05-15', '2026-05-22', 'BP039', 'ACC067', '2026-05-22'),
('BOR040', 100044, '2026-05-15', '2026-05-22', 'BP040', 'ACC068', '2026-05-22'),
('BOR041', 100045, '2026-05-18', '2026-05-22', 'BP041', 'ACC069', '2026-05-25'),
('BOR042', 100046, '2026-05-18', '2026-05-22', 'BP042', 'ACC033', '2026-05-25'),
('BOR043', 100047, '2026-05-19', NULL, 'BP043', 'ACC034', '2026-05-26'),
('BOR044', 100048, '2026-05-19', NULL, 'BP044', 'ACC035', '2026-05-26'),
('BOR045', 100049, '2026-05-20', NULL, 'BP045', 'ACC036', '2026-05-27'),
('BOR046', 100050, '2026-05-20', NULL, 'BP046', 'ACC037', '2026-05-27'),
('BOR047', 100051, '2026-05-21', NULL, 'BP047', 'ACC075', '2026-05-28'),
('BOR048', 100052, '2026-05-21', NULL, 'BP048', 'ACC076', '2026-05-28'),
('BOR049', 100053, '2026-05-22', NULL, 'BP049', 'ACC077', '2026-05-29'),
('BOR050', 100054, '2026-05-22', NULL, 'BP050', 'ACC078', '2026-05-29'),
('BOR051', 100055, '2026-05-25', NULL, 'BP051', 'ACC072', '2026-06-01'),
('BOR052', 100056, '2026-05-25', NULL, 'BP052', 'ACC073', '2026-06-01'),
('BOR053', 100057, '2026-05-25', NULL, 'BP053', 'ACC074', '2026-06-01'),
('BOR054', 100058, '2026-05-25', NULL, 'BP054', 'ACC011', '2026-06-01'),
('BOR055', 100059, '2026-05-25', NULL, 'BP055', 'ACC100', '2026-06-01'),
('BOR056', 100060, '2026-05-25', NULL, 'BP056', 'ACC072', '2026-06-01'),
('BOR057', 100061, '2026-05-25', NULL, 'BP057', 'ACC053', '2026-06-01');

-- --------------------------------------------------------

--
-- Table structure for table `comic`
--

CREATE TABLE `comic` (
  `comic_id` varchar(20) NOT NULL,
  `fiction_id` varchar(20) NOT NULL,
  `volume_no` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `comic`
--

INSERT INTO `comic` (`comic_id`, `fiction_id`, `volume_no`) VALUES
('C001', 'FIC-001', 1),
('C002', 'FIC-002', 1),
('C003', 'FIC-003', 2),
('C004', 'FIC-004', 2),
('C005', 'FIC-005', 3),
('C006', 'FIC-011', 1),
('C007', 'FIC-012', 1),
('C008', 'FIC-013', 2),
('C009', 'FIC-014', 2),
('C010', 'FIC-015', 3);

-- --------------------------------------------------------

--
-- Table structure for table `fiction`
--

CREATE TABLE `fiction` (
  `fiction_id` varchar(20) NOT NULL,
  `nonacademic_id` varchar(20) NOT NULL,
  `fiction_genre` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `fiction`
--

INSERT INTO `fiction` (`fiction_id`, `nonacademic_id`, `fiction_genre`) VALUES
('FIC-001', 'NONACAD-006', 'Educational Comics'),
('FIC-002', 'NONACAD-007', 'Superhero Comics'),
('FIC-003', 'NONACAD-008', 'Adventure Comics'),
('FIC-004', 'NONACAD-009', 'Fantasy Comics'),
('FIC-005', 'NONACAD-010', 'Humor Comics'),
('FIC-006', 'NONACAD-011', 'Picture Story Books'),
('FIC-007', 'NONACAD-012', 'Moral Lesson Books'),
('FIC-008', 'NONACAD-013', 'Bedtime Stories'),
('FIC-010', 'NONACAD-015', 'Fairy Tale Books'),
('FIC-011', 'NONACAD-027', 'Teen Adventure Comics'),
('FIC-012', 'NONACAD-028', 'Action Comics'),
('FIC-013', 'NONACAD-029', 'Sci-Fi Comics'),
('FIC-014', 'NONACAD-030', 'Fantasy Comics (Teens)'),
('FIC-015', 'NONACAD-031', 'Slice-of-Life Comics'),
('FIC-016', 'NONACAD-037', 'Children Story Books'),
('FIC-017', 'NONACAD-038', 'Illustrated Children Books'),
('FIC-018', 'NONACAD-039', 'Learning Story Books'),
('FIC-019', 'NONACAD-040', 'Bedtime Children Books'),
('FIC-020', 'NONACAD-041', 'Adventure Children Books');

-- --------------------------------------------------------

--
-- Table structure for table `fines`
--

CREATE TABLE `fines` (
  `fine_id` varchar(30) NOT NULL,
  `libclerk_id` varchar(30) NOT NULL,
  `borrow_id` varchar(30) NOT NULL,
  `amount` decimal(10,2) NOT NULL CHECK (`amount` >= 0.00),
  `pub_id` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `fines`
--

INSERT INTO `fines` (`fine_id`, `libclerk_id`, `borrow_id`, `amount`, `pub_id`) VALUES
('FN001', 'LC001', 'BOR020', 5.00, 'PUB022'),
('FN002', 'LC002', 'BOR013', 10.00, 'PUB094');

-- --------------------------------------------------------

--
-- Table structure for table `genre`
--

CREATE TABLE `genre` (
  `genre_id` varchar(30) NOT NULL,
  `genre` varchar(100) NOT NULL,
  `audience_type` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `genre`
--

INSERT INTO `genre` (`genre_id`, `genre`, `audience_type`) VALUES
('GR001', 'Recipe', 'General'),
('GR002', 'Recipe', 'General'),
('GR003', 'Recipe', 'General'),
('GR004', 'Recipe', 'General'),
('GR005', 'Recipe', 'General'),
('GR006', 'Comics', 'Kids'),
('GR007', 'Comics', 'Kids'),
('GR008', 'Comics', 'Kids'),
('GR009', 'Comics', 'Kids'),
('GR010', 'Comics', 'Kids'),
('GR011', 'Kids Book', 'Kids'),
('GR012', 'Kids Book', 'Kids'),
('GR013', 'Kids Book', 'Kids'),
('GR014', 'Kids Book', 'Kids'),
('GR015', 'Self Help', 'Young Adults and Adults'),
('GR016', 'Self-Help', 'General'),
('GR017', 'Self-Help', 'General'),
('GR018', 'Self-Help', 'General'),
('GR019', 'Self-Help', 'General'),
('GR020', 'Self-Help', 'General'),
('GR021', 'Recipe', 'General'),
('GR022', 'Recipe', 'General'),
('GR023', 'Recipe', 'General'),
('GR024', 'Recipe', 'General'),
('GR025', 'Recipe', 'General'),
('GR026', 'Comics', 'Kids/Teens'),
('GR027', 'Comics', 'Kids/Teens'),
('GR028', 'Comics', 'Kids/Teens'),
('GR029', 'Comics', 'Kids/Teens'),
('GR030', 'Comics', 'Kids/Teens'),
('GR031', 'Self Help', 'General'),
('GR032', 'Self Help', 'General'),
('GR033', 'Self Help', 'General'),
('GR034', 'Self Help', 'General'),
('GR035', 'Self Help', 'General'),
('GR036', 'Kids Book', 'Children'),
('GR037', 'Kids Book', 'Children'),
('GR038', 'Kids Book', 'Children'),
('GR039', 'Kids Book', 'Children'),
('GR040', 'Kids Book', 'Children'),
('GR041', 'Self help', 'General');

-- --------------------------------------------------------

--
-- Table structure for table `history`
--

CREATE TABLE `history` (
  `history_id` varchar(20) NOT NULL,
  `academic_id` varchar(20) NOT NULL,
  `historical_period` varchar(100) NOT NULL,
  `country_focus` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `history`
--

INSERT INTO `history` (`history_id`, `academic_id`, `historical_period`, `country_focus`) VALUES
('HIST-001', 'ACAD-011', 'Pre-Colonial to Modern', 'Philippines'),
('HIST-002', 'ACAD-012', 'Ancient to Modern', 'Asia'),
('HIST-003', 'ACAD-013', 'Medieval to Modern', 'Europe'),
('HIST-004', 'ACAD-014', '20th Century', 'Global'),
('HIST-005', 'ACAD-015', 'Contemporary', 'Southeast Asia'),
('HIST-006', 'ACAD-023', 'Modern Era', 'Asia'),
('HIST-007', 'ACAD-035', 'Colonial to Post-Colonial', 'Philippines'),
('HIST-008', 'ACAD-036', 'Ancient to Contemporary', 'Asia'),
('HIST-009', 'ACAD-037', 'Renaissance to Modern', 'Europe'),
('HIST-010', 'ACAD-038', 'World War I & II', 'Global'),
('HIST-011', 'ACAD-039', 'Multi-period', 'Global');

-- --------------------------------------------------------

--
-- Table structure for table `it staff`
--

CREATE TABLE `it staff` (
  `itstaff_id` varchar(30) NOT NULL,
  `user_id` int(11) NOT NULL,
  `technical_role` varchar(50) NOT NULL,
  `system_permission` varchar(100) NOT NULL,
  `hire_date` date NOT NULL,
  `duty_schedule` varchar(20) NOT NULL,
  `itstaff_pass` varchar(20) NOT NULL,
  `itstaff_username` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `it staff`
--

INSERT INTO `it staff` (`itstaff_id`, `user_id`, `technical_role`, `system_permission`, `hire_date`, `duty_schedule`, `itstaff_pass`, `itstaff_username`) VALUES
('IT001', 100004, 'System Administrator', 'Full Access', '2019-08-20', 'Monday-Friday 8:00AM', 'pass1236', 'jhondelacruz');

-- --------------------------------------------------------

--
-- Table structure for table `kids books`
--

CREATE TABLE `kids books` (
  `kidsbook_id` varchar(20) NOT NULL,
  `fiction_id` varchar(20) NOT NULL,
  `format_id` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kids books`
--

INSERT INTO `kids books` (`kidsbook_id`, `fiction_id`, `format_id`) VALUES
('K001', 'FIC-006', 'FI01'),
('K002', 'FIC-007', 'FI02'),
('K003', 'FIC-008', 'FI03'),
('K005', 'FIC-010', 'FI05'),
('K006', 'FIC-016', 'FI06'),
('K007', 'FIC-017', 'FI07'),
('K008', 'FIC-018', 'FI08'),
('K009', 'FIC-019', 'FI09'),
('K010', 'FIC-020', 'FI10');

-- --------------------------------------------------------

--
-- Table structure for table `librarian`
--

CREATE TABLE `librarian` (
  `librarian_id` varchar(10) NOT NULL,
  `user_id` int(11) NOT NULL,
  `hire_date` date NOT NULL,
  `duty_schedule` varchar(20) NOT NULL,
  `librarian_pass` varchar(20) NOT NULL,
  `librarian_username` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `librarian`
--

INSERT INTO `librarian` (`librarian_id`, `user_id`, `hire_date`, `duty_schedule`, `librarian_pass`, `librarian_username`) VALUES
('LIB001', 100001, '2020-06-15', 'Monday-Friday 8:00am', 'pass1234', 'marksantos');

-- --------------------------------------------------------

--
-- Table structure for table `library clerk`
--

CREATE TABLE `library clerk` (
  `libclerk_id` varchar(30) NOT NULL,
  `user_id` int(11) NOT NULL,
  `duty_schedule` varchar(20) NOT NULL,
  `assigned_counter` varchar(20) NOT NULL,
  `hire_date` date NOT NULL,
  `libclerk_pass` varchar(20) NOT NULL,
  `libclerk_username` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `library clerk`
--

INSERT INTO `library clerk` (`libclerk_id`, `user_id`, `duty_schedule`, `assigned_counter`, `hire_date`, `libclerk_pass`, `libclerk_username`) VALUES
('LC001', 100002, 'Monday-Friday 8:00AM', 'Counter 1', '2021-03-10', 'pass1235', 'marksantos'),
('LC002', 100003, 'Monday-Friday 8:00AM', 'Counter 2', '2023-06-19', 'pass1236', 'joanacruz');

-- --------------------------------------------------------

--
-- Table structure for table `magazines`
--

CREATE TABLE `magazines` (
  `magazine_id` varchar(30) NOT NULL,
  `ISSN` varchar(20) NOT NULL,
  `magazine_type` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `magazines`
--

INSERT INTO `magazines` (`magazine_id`, `ISSN`, `magazine_type`) VALUES
('MAG-101', 'ISSN-1011-011', 'Fashion'),
('MAG-102', 'ISSN-1011-012', 'Travel'),
('MAG-103', 'ISSN-1011-013', 'Business & Finance'),
('MAG-104', 'ISSN-1011-014', 'Health & Wellness'),
('MAG-105', 'ISSN-1011-015', 'Technology'),
('MAG-106', 'ISSN-1011-016', 'Entertainment'),
('MAG-107', 'ISSN-1011-017', 'Sports'),
('MAG-108', 'ISSN-1011-018', 'Education'),
('MAG-109', 'ISSN-1011-019', 'Science & Research'),
('MAG-110', 'ISSN-1011-020', 'Lifestyle');

-- --------------------------------------------------------

--
-- Table structure for table `mathematics`
--

CREATE TABLE `mathematics` (
  `math_id` varchar(20) NOT NULL,
  `academic_id` varchar(20) NOT NULL,
  `math_field` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `mathematics`
--

INSERT INTO `mathematics` (`math_id`, `academic_id`, `math_field`) VALUES
('MATH-001', 'ACAD-001', 'Algebra'),
('MATH-002', 'ACAD-002', 'Calculus'),
('MATH-003', 'ACAD-003', 'Geometry'),
('MATH-004', 'ACAD-004', 'Statistics'),
('MATH-005', 'ACAD-005', 'Trigonometry'),
('MATH-006', 'ACAD-021', 'Linear Algebra'),
('MATH-007', 'ACAD-025', 'Advanced Algebra'),
('MATH-008', 'ACAD-026', 'Statistics'),
('MATH-009', 'ACAD-027', 'Probability'),
('MATH-010', 'ACAD-028', 'Differential Equations'),
('MATH-011', 'ACAD-029', 'Mathematical Logic');

-- --------------------------------------------------------

--
-- Table structure for table `newspapers`
--

CREATE TABLE `newspapers` (
  `newspaper_id` varchar(30) NOT NULL,
  `ISSN` varchar(20) NOT NULL,
  `frequency` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `newspapers`
--

INSERT INTO `newspapers` (`newspaper_id`, `ISSN`, `frequency`) VALUES
('NEWS-101', 'ISSN-1011-001', 'Daily'),
('NEWS-102', 'ISSN-1011-002', 'Daily'),
('NEWS-103', 'ISSN-1011-003', 'Daily'),
('NEWS-104', 'ISSN-1011-004', 'Daily'),
('NEWS-105', 'ISSN-1011-005', 'Daily'),
('NEWS-106', 'ISSN-1011-006', 'Daily'),
('NEWS-107', 'ISSN-1011-007', 'Daily'),
('NEWS-108', 'ISSN-1011-008', 'Daily'),
('NEWS-109', 'ISSN-1011-009', 'Daily'),
('NEWS-110', 'ISSN-1011-010', 'Daily');

-- --------------------------------------------------------

--
-- Table structure for table `non academic`
--

CREATE TABLE `non academic` (
  `nonacademic_id` varchar(20) NOT NULL,
  `accession_id` varchar(30) NOT NULL,
  `genre_id` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `non academic`
--

INSERT INTO `non academic` (`nonacademic_id`, `accession_id`, `genre_id`) VALUES
('NONACAD-001', 'ACC031', 'GR001'),
('NONACAD-002', 'ACC032', 'GR002'),
('NONACAD-003', 'ACC033', 'GR003'),
('NONACAD-004', 'ACC034', 'GR004'),
('NONACAD-005', 'ACC035', 'GR005'),
('NONACAD-006', 'ACC036', 'GR006'),
('NONACAD-007', 'ACC037', 'GR007'),
('NONACAD-008', 'ACC038', 'GR008'),
('NONACAD-009', 'ACC039', 'GR009'),
('NONACAD-010', 'ACC040', 'GR010'),
('NONACAD-011', 'ACC041', 'GR011'),
('NONACAD-012', 'ACC042', 'GR012'),
('NONACAD-013', 'ACC043', 'GR013'),
('NONACAD-015', 'ACC045', 'GR014'),
('NONACAD-016', 'ACC050', 'GR015'),
('NONACAD-017', 'ACC076', 'GR016'),
('NONACAD-018', 'ACC077', 'GR017'),
('NONACAD-019', 'ACC078', 'GR018'),
('NONACAD-020', 'ACC079', 'GR019'),
('NONACAD-021', 'ACC080', 'GR020'),
('NONACAD-022', 'ACC081', 'GR021'),
('NONACAD-023', 'ACC082', 'GR022'),
('NONACAD-024', 'ACC083', 'GR023'),
('NONACAD-025', 'ACC084', 'GR024'),
('NONACAD-026', 'ACC085', 'GR025'),
('NONACAD-027', 'ACC086', 'GR026'),
('NONACAD-028', 'ACC087', 'GR027'),
('NONACAD-029', 'ACC088', 'GR028'),
('NONACAD-030', 'ACC089', 'GR029'),
('NONACAD-031', 'ACC090', 'GR030'),
('NONACAD-032', 'ACC026', 'GR031'),
('NONACAD-033', 'ACC027', 'GR032'),
('NONACAD-034', 'ACC028', 'GR033'),
('NONACAD-035', 'ACC029', 'GR034'),
('NONACAD-036', 'ACC030', 'GR035'),
('NONACAD-037', 'ACC091', 'GR036'),
('NONACAD-038', 'ACC092', 'GR037'),
('NONACAD-039', 'ACC093', 'GR038'),
('NONACAD-040', 'ACC094', 'GR039'),
('NONACAD-041', 'ACC095', 'GR040'),
('NONACAD-042', 'ACC100', 'GR041');

-- --------------------------------------------------------

--
-- Table structure for table `non fiction`
--

CREATE TABLE `non fiction` (
  `nonfiction_id` varchar(20) NOT NULL,
  `nonacademic_id` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `non fiction`
--

INSERT INTO `non fiction` (`nonfiction_id`, `nonacademic_id`) VALUES
('NF-001', 'NONACAD-001'),
('NF-002', 'NONACAD-002'),
('NF-003', 'NONACAD-003'),
('NF-004', 'NONACAD-004'),
('NF-005', 'NONACAD-005'),
('NF-006', 'NONACAD-016'),
('NF-007', 'NONACAD-017'),
('NF-008', 'NONACAD-018'),
('NF-009', 'NONACAD-019'),
('NF-010', 'NONACAD-020'),
('NF-011', 'NONACAD-021'),
('NF-012', 'NONACAD-022'),
('NF-013', 'NONACAD-023'),
('NF-014', 'NONACAD-024'),
('NF-015', 'NONACAD-025'),
('NF-016', 'NONACAD-026'),
('NF-017', 'NONACAD-032'),
('NF-018', 'NONACAD-033'),
('NF-019', 'NONACAD-034'),
('NF-020', 'NONACAD-035'),
('NF-021', 'NONACAD-036'),
('NF-022', 'NONACAD-037'),
('NF-023', 'NONACAD-042');

-- --------------------------------------------------------

--
-- Table structure for table `periodicals`
--

CREATE TABLE `periodicals` (
  `ISSN` varchar(20) NOT NULL,
  `pub_id` varchar(30) NOT NULL,
  `periodic_type` varchar(50) NOT NULL
) ;

--
-- Dumping data for table `periodicals`
--

INSERT INTO `periodicals` (`ISSN`, `pub_id`, `periodic_type`) VALUES
('ISSN-1011-001', 'PUB101', 'Newspaper'),
('ISSN-1011-002', 'PUB102', 'Newspaper'),
('ISSN-1011-003', 'PUB103', 'Newspaper'),
('ISSN-1011-004', 'PUB104', 'Newspaper'),
('ISSN-1011-005', 'PUB105', 'Newspaper'),
('ISSN-1011-006', 'PUB106', 'Newspaper'),
('ISSN-1011-007', 'PUB107', 'Newspaper'),
('ISSN-1011-008', 'PUB108', 'Newspaper'),
('ISSN-1011-009', 'PUB109', 'Newspaper'),
('ISSN-1011-010', 'PUB110', 'Newspaper'),
('ISSN-1011-011', 'PUB111', 'Magazines'),
('ISSN-1011-012', 'PUB112', 'Magazines'),
('ISSN-1011-013', 'PUB113', 'Magazines'),
('ISSN-1011-014', 'PUB114', 'Magazines'),
('ISSN-1011-015', 'PUB115', 'Magazines'),
('ISSN-1011-016', 'PUB116', 'Magazines'),
('ISSN-1011-017', 'PUB117', 'Magazines'),
('ISSN-1011-018', 'PUB118', 'Magazines'),
('ISSN-1011-019', 'PUB119', 'Magazines'),
('ISSN-1011-020', 'PUB120', 'Magazines'),
('ISSN-1011-021', 'PUB121', 'Tabloids'),
('ISSN-1011-022', 'PUB122', 'Tabloids'),
('ISSN-1011-023', 'PUB123', 'Tabloids'),
('ISSN-1011-024', 'PUB124', 'Tabloids'),
('ISSN-1011-025', 'PUB125', 'Tabloids'),
('ISSN-1011-026', 'PUB126', 'Tabloids'),
('ISSN-1011-027', 'PUB127', 'Tabloids'),
('ISSN-1011-028', 'PUB128', 'Tabloids'),
('ISSN-1011-029', 'PUB129', 'Tabloids'),
('ISSN-1011-030', 'PUB130', 'Tabloids');

-- --------------------------------------------------------

--
-- Table structure for table `pub author`
--

CREATE TABLE `pub author` (
  `pub_id` varchar(20) NOT NULL,
  `author_id` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pub author`
--

INSERT INTO `pub author` (`pub_id`, `author_id`) VALUES
('PUB001', 'AUTH001'),
('PUB002', 'AUTH002'),
('PUB003', 'AUTH003'),
('PUB004', 'AUTH004'),
('PUB005', 'AUTH005'),
('PUB006', 'AUTH006'),
('PUB007', 'AUTH007'),
('PUB008', 'AUTH008'),
('PUB009', 'AUTH009'),
('PUB010', 'AUTH010'),
('PUB011', 'AUTH011'),
('PUB012', 'AUTH012'),
('PUB013', 'AUTH013'),
('PUB014', 'AUTH014'),
('PUB015', 'AUTH015'),
('PUB016', 'AUTH016'),
('PUB017', 'AUTH017'),
('PUB018', 'AUTH018'),
('PUB019', 'AUTH019'),
('PUB020', 'AUTH020'),
('PUB021', 'AUTH021'),
('PUB022', 'AUTH022'),
('PUB023', 'AUTH023'),
('PUB024', 'AUTH024'),
('PUB025', 'AUTH025'),
('PUB026', 'AUTH026'),
('PUB027', 'AUTH027'),
('PUB028', 'AUTH028'),
('PUB029', 'AUTH029'),
('PUB030', 'AUTH030'),
('PUB031', 'AUTH031'),
('PUB032', 'AUTH032'),
('PUB033', 'AUTH033'),
('PUB034', 'AUTH034'),
('PUB035', 'AUTH035'),
('PUB036', 'AUTH036'),
('PUB037', 'AUTH037'),
('PUB038', 'AUTH038'),
('PUB039', 'AUTH039'),
('PUB040', 'AUTH040'),
('PUB041', 'AUTH041'),
('PUB042', 'AUTH042'),
('PUB043', 'AUTH043'),
('PUB044', 'AUTH044'),
('PUB045', 'AUTH045'),
('PUB046', 'AUTH046'),
('PUB047', 'AUTH047'),
('PUB048', 'AUTH048'),
('PUB049', 'AUTH049'),
('PUB050', 'AUTH050'),
('PUB051', 'AUTH051'),
('PUB052', 'AUTH052'),
('PUB053', 'AUTH053'),
('PUB054', 'AUTH054'),
('PUB055', 'AUTH055'),
('PUB056', 'AUTH056'),
('PUB057', 'AUTH057'),
('PUB058', 'AUTH058'),
('PUB059', 'AUTH059'),
('PUB060', 'AUTH060'),
('PUB061', 'AUTH061'),
('PUB062', 'AUTH062'),
('PUB063', 'AUTH063'),
('PUB064', 'AUTH064'),
('PUB065', 'AUTH065'),
('PUB066', 'AUTH066'),
('PUB067', 'AUTH067'),
('PUB068', 'AUTH068'),
('PUB069', 'AUTH069'),
('PUB070', 'AUTH070'),
('PUB071', 'AUTH071'),
('PUB072', 'AUTH072'),
('PUB073', 'AUTH073'),
('PUB074', 'AUTH074'),
('PUB075', 'AUTH075'),
('PUB076', 'AUTH076'),
('PUB077', 'AUTH077'),
('PUB078', 'AUTH078'),
('PUB079', 'AUTH079'),
('PUB080', 'AUTH080'),
('PUB081', 'AUTH081'),
('PUB082', 'AUTH082'),
('PUB083', 'AUTH083'),
('PUB084', 'AUTH084'),
('PUB085', 'AUTH085'),
('PUB086', 'AUTH086'),
('PUB087', 'AUTH087'),
('PUB088', 'AUTH088'),
('PUB089', 'AUTH089'),
('PUB090', 'AUTH090'),
('PUB091', 'AUTH091'),
('PUB092', 'AUTH092'),
('PUB093', 'AUTH093'),
('PUB094', 'AUTH094'),
('PUB095', 'AUTH095'),
('PUB096', 'AUTH096'),
('PUB097', 'AUTH097'),
('PUB098', 'AUTH098'),
('PUB099', 'AUTH099'),
('PUB100', 'AUTH100'),
('PUB101', 'AUTH101'),
('PUB102', 'AUTH102'),
('PUB103', 'AUTH103'),
('PUB104', 'AUTH104'),
('PUB105', 'AUTH105'),
('PUB106', 'AUTH106'),
('PUB107', 'AUTH107'),
('PUB108', 'AUTH108'),
('PUB109', 'AUTH109'),
('PUB110', 'AUTH110'),
('PUB111', 'AUTH111'),
('PUB112', 'AUTH112'),
('PUB113', 'AUTH113'),
('PUB114', 'AUTH114'),
('PUB115', 'AUTH115'),
('PUB116', 'AUTH116'),
('PUB117', 'AUTH117'),
('PUB118', 'AUTH118'),
('PUB119', 'AUTH119'),
('PUB120', 'AUTH120'),
('PUB121', 'AUTH121'),
('PUB122', 'AUTH122'),
('PUB123', 'AUTH123'),
('PUB124', 'AUTH124'),
('PUB125', 'AUTH125'),
('PUB126', 'AUTH126'),
('PUB127', 'AUTH127'),
('PUB128', 'AUTH128'),
('PUB129', 'AUTH129'),
('PUB130', 'AUTH130');

-- --------------------------------------------------------

--
-- Table structure for table `pub copies`
--

CREATE TABLE `pub copies` (
  `copy_id` varchar(20) NOT NULL,
  `pub_id` varchar(20) NOT NULL,
  `copy_number` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pub copies`
--

INSERT INTO `pub copies` (`copy_id`, `pub_id`, `copy_number`) VALUES
('COPY001', 'PUB001', 6),
('COPY002', 'PUB002', 6),
('COPY003', 'PUB003', 5),
('COPY004', 'PUB004', 7),
('COPY005', 'PUB005', 5),
('COPY006', 'PUB006', 2),
('COPY007', 'PUB007', 4),
('COPY008', 'PUB008', 9),
('COPY009', 'PUB009', 11),
('COPY010', 'PUB010', 12),
('COPY011', 'PUB011', 3),
('COPY012', 'PUB012', 7),
('COPY013', 'PUB013', 5),
('COPY014', 'PUB014', 8),
('COPY015', 'PUB015', 6),
('COPY016', 'PUB016', 10),
('COPY017', 'PUB017', 4),
('COPY018', 'PUB018', 9),
('COPY019', 'PUB019', 7),
('COPY020', 'PUB020', 5),
('COPY021', 'PUB021', 3),
('COPY022', 'PUB022', 6),
('COPY023', 'PUB023', 8),
('COPY024', 'PUB024', 11),
('COPY025', 'PUB025', 2),
('COPY026', 'PUB026', 7),
('COPY027', 'PUB027', 5),
('COPY028', 'PUB028', 6),
('COPY029', 'PUB029', 10),
('COPY030', 'PUB030', 4),
('COPY031', 'PUB031', 8),
('COPY032', 'PUB032', 9),
('COPY033', 'PUB033', 3),
('COPY034', 'PUB034', 6),
('COPY035', 'PUB035', 12),
('COPY036', 'PUB036', 5),
('COPY037', 'PUB037', 7),
('COPY038', 'PUB038', 4),
('COPY039', 'PUB039', 9),
('COPY040', 'PUB040', 6),
('COPY041', 'PUB041', 5),
('COPY042', 'PUB042', 11),
('COPY043', 'PUB043', 8),
('COPY044', 'PUB044', 3),
('COPY045', 'PUB045', 7),
('COPY046', 'PUB046', 6),
('COPY047', 'PUB047', 10),
('COPY048', 'PUB048', 4),
('COPY049', 'PUB049', 5),
('COPY050', 'PUB050', 9),
('COPY051', 'PUB051', 6),
('COPY052', 'PUB052', 7),
('COPY053', 'PUB053', 3),
('COPY054', 'PUB054', 8),
('COPY055', 'PUB055', 12),
('COPY056', 'PUB056', 5),
('COPY057', 'PUB057', 4),
('COPY058', 'PUB058', 6),
('COPY059', 'PUB059', 9),
('COPY060', 'PUB060', 11),
('COPY061', 'PUB061', 2),
('COPY062', 'PUB062', 7),
('COPY063', 'PUB063', 5),
('COPY064', 'PUB064', 8),
('COPY065', 'PUB065', 6),
('COPY066', 'PUB066', 10),
('COPY067', 'PUB067', 4),
('COPY068', 'PUB068', 9),
('COPY069', 'PUB069', 3),
('COPY070', 'PUB070', 7),
('COPY071', 'PUB071', 5),
('COPY072', 'PUB072', 6),
('COPY073', 'PUB073', 8),
('COPY074', 'PUB074', 11),
('COPY075', 'PUB075', 2),
('COPY076', 'PUB076', 7),
('COPY077', 'PUB077', 5),
('COPY078', 'PUB078', 9),
('COPY079', 'PUB079', 6),
('COPY080', 'PUB080', 4),
('COPY081', 'PUB081', 10),
('COPY082', 'PUB082', 3),
('COPY083', 'PUB083', 8),
('COPY084', 'PUB084', 12),
('COPY085', 'PUB085', 5),
('COPY086', 'PUB086', 7),
('COPY087', 'PUB087', 4),
('COPY088', 'PUB088', 6),
('COPY089', 'PUB089', 9),
('COPY090', 'PUB090', 11),
('COPY091', 'PUB091', 2),
('COPY092', 'PUB092', 5),
('COPY093', 'PUB093', 8),
('COPY094', 'PUB094', 6),
('COPY095', 'PUB095', 10),
('COPY096', 'PUB096', 4),
('COPY097', 'PUB097', 7),
('COPY098', 'PUB098', 9),
('COPY099', 'PUB099', 3),
('COPY100', 'PUB100', 6),
('COPY101', 'PUB101', 5),
('COPY102', 'PUB102', 8),
('COPY103', 'PUB103', 11),
('COPY104', 'PUB104', 2),
('COPY105', 'PUB105', 7),
('COPY106', 'PUB106', 4),
('COPY107', 'PUB107', 9),
('COPY108', 'PUB108', 6),
('COPY109', 'PUB109', 10),
('COPY110', 'PUB110', 3),
('COPY111', 'PUB111', 5),
('COPY112', 'PUB112', 7),
('COPY113', 'PUB113', 8),
('COPY114', 'PUB114', 12),
('COPY115', 'PUB115', 4),
('COPY116', 'PUB116', 6),
('COPY117', 'PUB117', 9),
('COPY118', 'PUB118', 11),
('COPY119', 'PUB119', 2),
('COPY120', 'PUB120', 5),
('COPY121', 'PUB121', 7),
('COPY122', 'PUB122', 8),
('COPY123', 'PUB123', 6),
('COPY124', 'PUB124', 10),
('COPY125', 'PUB125', 4),
('COPY126', 'PUB126', 9),
('COPY127', 'PUB127', 3),
('COPY128', 'PUB128', 5),
('COPY129', 'PUB129', 7),
('COPY130', 'PUB130', 11);

-- --------------------------------------------------------

--
-- Table structure for table `publication`
--

CREATE TABLE `publication` (
  `pub_id` varchar(30) NOT NULL,
  `title` varchar(100) NOT NULL,
  `series` varchar(100) DEFAULT NULL,
  `edition` varchar(30) DEFAULT NULL,
  `date_published` date NOT NULL,
  `shelf_location` varchar(30) NOT NULL,
  `language_used` varchar(50) NOT NULL,
  `publisher_id` varchar(30) NOT NULL,
  `subtitle` varchar(255) DEFAULT NULL,
  `pages` int(11) NOT NULL,
  `copyright_date` int(11) NOT NULL,
  `book_status` varchar(20) NOT NULL DEFAULT 'Available' CHECK (`book_status` in ('Available','Borrowed'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `publication`
--

INSERT INTO `publication` (`pub_id`, `title`, `series`, `edition`, `date_published`, `shelf_location`, `language_used`, `publisher_id`, `subtitle`, `pages`, `copyright_date`) VALUES
('PUB001', 'Basic Algebra', 'Mathematics Series', '3rd Edition', '2019-06-15', 'Shelf A1', 'English', 'PBL-001', 'Principles & Practice', 250, 2019),
('PUB002', 'Advanced Calculus', 'Mathematics Series', '2nd Edition', '2020-03-10', 'Shelf A2', 'English', 'PBL-002', 'Concepts and Theory', 275, 2020),
('PUB003', 'Geometry Essentials', 'Mathematics Series', '1st Edition', '2018-08-21', 'Shelf A3', 'English', 'PBL-003', 'Mastering Shapes', 317, 2018),
('PUB004', 'Statistics for Beginners', 'Mathematics Series', '4th Edition', '2021-01-12', 'Shelf A4', 'English', 'PBL-004', 'A Modern Introduction', 290, 2021),
('PUB005', 'Trigonometry Simplified', 'Mathematics Series', '5th Edition', '2017-11-05', 'Shelf A5', 'English', 'PBL-005', 'Steps to Success', 350, 2017),
('PUB006', 'General Biology', 'Science Today', '2nd Edition', '2022-05-18', 'Shelf B1', 'English', 'PBL-006', 'Exploring Life Systems', 320, 2022),
('PUB007', 'Chemistry Fundamentals', 'Science Today', '3rd Edition', '2020-09-14', 'Shelf B2', 'English', 'PBL-007', 'Matter and Atomic Structure', 310, 2020),
('PUB008', 'Physics Principles', 'Science Today', '1st Edition', '2019-04-08', 'Shelf B3', 'English', 'PBL-008', 'Force, Motion, and Energy', 350, 2019),
('PUB009', 'Earth and Life Science', 'Science Today', '2nd Edition', '2021-07-30', 'Shelf B4', 'English', 'PBL-009', 'The Dynamic Planet', 280, 2021),
('PUB010', 'Environmental Science', 'Science Today', '4th Edition', '2018-02-27', 'Shelf B5', 'English', 'PBL-010', 'Ecology and Conservation', 295, 2018),
('PUB011', 'Philippine History', 'History Collection', '3rd Edition', '2022-01-19', 'Shelf C1', 'English', 'PBL-011', 'A Nation\'s Journey', 340, 2022),
('PUB012', 'World History Explained', 'History Collection', '1st Edition', '2016-12-01', 'Shelf C2', 'English', 'PBL-012', 'Global Perspectives', 275, 2016),
('PUB013', 'Asian Civilization', 'History Collection', '2nd Edition', '2020-10-10', 'Shelf C3', 'English', 'PBL-013', 'Cultural Heritage', 310, 2020),
('PUB014', 'Rizal’s Life and Works', 'History Collection', '1st Edition', '2021-06-06', 'Shelf C4', 'English', 'PBL-014', 'The National Hero', 290, 2021),
('PUB015', 'Ancient Civilizations', 'History Collection', '5th Edition', '2019-09-25', 'Shelf C5', 'English', 'PBL-015', 'Origins of Humanity', 325, 2019),
('PUB016', 'Practical Research 1', 'Research Series', '2nd Edition', '2022-03-11', 'Shelf D1', 'English', 'PBL-016', 'Foundations of Inquiry', 210, 2022),
('PUB017', 'Practical Research 2', 'Research Series', '3rd Edition', '2018-07-07', 'Shelf D2', 'English', 'PBL-017', 'Applied Methodologies', 245, 2018),
('PUB018', 'Introduction to Research', 'Research Series', '2nd Edition', '2021-02-14', 'Shelf D3', 'English', 'PBL-018', 'Scholarly Investigations', 190, 2021),
('PUB019', 'Quantitative Research', 'Research Series', '1st Edition', '2019-05-20', 'Shelf D4', 'English', 'PBL-019', 'Statistical Analysis', 315, 2019),
('PUB020', 'Qualitative Research Guide', 'Research Series', '3rd Edition', '2023-01-09', 'Shelf D5', 'English', 'PBL-020', 'Thematic Interpretations', 280, 2023),
('PUB021', 'English Dictionary', 'Reference Collection', '10th Edition', '2020-01-15', 'Shelf E1', 'English', 'PBL-021', 'The Definitive Lexicon', 850, 2020),
('PUB022', 'Encyclopedia of Science', 'Reference Collection', '8th Edition', '2019-08-20', 'Shelf E2', 'English', 'PBL-022', 'Foundations of Knowledge', 1200, 2019),
('PUB023', 'Atlas of the World', 'Reference Collection', '5th Edition', '2021-11-11', 'Shelf E3', 'English', 'PBL-023', 'Cartographic Perspectives', 400, 2021),
('PUB024', 'Computer Reference Guide', 'Reference Collection', '2nd Edition', '2018-06-01', 'Shelf E4', 'English', 'PBL-024', 'Technical Systems Overview', 350, 2018),
('PUB025', 'Medical Reference Handbook', 'Reference Collection', '4th Edition', '2022-04-18', 'Shelf E5', 'English', 'PBL-025', 'Essentials of Healthcare', 600, 2022),
('PUB026', 'Think Positive', 'Self Help Series', '1st Edition', '2020-03-10', 'Shelf F1', 'English', 'PBL-026', 'Mindset for Growth', 210, 2020),
('PUB027', 'The Power of Discipline', 'Self Help Series', '2nd Edition', '2019-07-07', 'Shelf F2', 'English', 'PBL-027', 'Mastery of Will', 195, 2019),
('PUB028', 'Improve Your Confidence', 'Self Help Series', '3rd Edition', '2021-01-01', 'Shelf F3', 'English', 'PBL-028', 'Overcoming Self-Doubt', 230, 2021),
('PUB029', 'Success Habits', 'Self Help Series', '2nd Edition', '2022-10-10', 'Shelf F4', 'English', 'PBL-029', 'Daily Routines for Excellence', 250, 2022),
('PUB030', 'Time Management Skills', 'Self Help Series', '1st Edition', '2018-12-12', 'Shelf F5', 'English', 'PBL-030', 'Efficiency and Focus', 180, 2018),
('PUB031', 'Easy Filipino Recipes', 'Recipe Collection', '1st Edition', '2020-09-09', 'Shelf G1', 'English', 'PBL-031', 'Home-Style Classics', 180, 2020),
('PUB032', 'Baking for Beginners', 'Recipe Collection', '2nd Edition', '2021-02-20', 'Shelf G2', 'English', 'PBL-032', 'Sweet and Savory Breads', 215, 2021),
('PUB033', 'Healthy Cooking Guide', 'Recipe Collection', '3rd Edition', '2019-11-11', 'Shelf G3', 'English', 'PBL-033', 'Nutritious Meal Planning', 200, 2019),
('PUB034', 'Asian Cuisine Recipes', 'Recipe Collection', '2nd Edition', '2022-07-14', 'Shelf G4', 'English', 'PBL-034', 'Flavors of the East', 250, 2022),
('PUB035', 'Desserts Made Easy', 'Recipe Collection', '1st Edition', '2018-05-05', 'Shelf G5', 'English', 'PBL-035', 'Quick Treats and Pastries', 165, 2018),
('PUB036', 'Super Kid Comics', 'Comic Series', '1st Edition', '2020-01-10', 'Shelf H1', 'English', 'PBL-036', 'Origins of Justice', 128, 2020),
('PUB037', 'Adventures of Max', 'Comic Series', '2nd Edition', '2021-03-14', 'Shelf H2', 'English', 'PBL-037', 'The Ultimate Quest', 144, 2021),
('PUB038', 'Funny Heroes', 'Comic Series', '3rd Edition', '2019-06-18', 'Shelf H3', 'English', 'PBL-038', 'Comedy Chronicles', 96, 2019),
('PUB039', 'Galaxy Warriors', 'Comic Series', '1st Edition', '2022-09-01', 'Shelf H4', 'English', 'PBL-039', 'Interstellar Battle', 160, 2022),
('PUB040', 'Mystery Detectives', 'Comic Series', '2nd Edition', '2018-10-30', 'Shelf H5', 'English', 'PBL-040', 'The Secret Casebook', 112, 2018),
('PUB041', 'Fairy Tales for Kids', 'Kids Corner', '1st Edition', '2020-02-14', 'Shelf I1', 'English', 'PBL-041', 'Ancient Stories for Youth', 120, 2020),
('PUB042', 'ABC Learning Book', 'Kids Corner', '2nd Edition', '2021-08-08', 'Shelf I2', 'English', 'PBL-042', 'First Steps in Literacy', 40, 2021),
('PUB043', 'Fun with Numbers', 'Kids Corner', '1st Edition', '2019-04-17', 'Shelf I3', 'English', 'PBL-043', 'Intro to Math for Kids', 48, 2019),
('PUB044', 'Bedtime Stories', 'Kids Corner', '3rd Edition', '2022-12-25', 'Shelf I4', 'English', 'PBL-044', 'Dreamy Evening Tales', 150, 2022),
('PUB045', 'Animal Adventures', 'Kids Corner', '2nd Edition', '2018-07-19', 'Shelf I5', 'English', 'PBL-045', 'Exploring the Wildlife', 85, 2018),
('PUB046', 'Linear Algebra', 'Mathematics Series', '2nd Edition', '2020-05-05', 'Shelf A6', 'English', 'PBL-046', 'Vector Spaces and Matrices', 310, 2020),
('PUB047', 'Organic Chemistry', 'Science Today', '1st Edition', '2021-01-15', 'Shelf B6', 'English', 'PBL-047', 'Structure and Reactivity', 420, 2021),
('PUB048', 'Modern Asian History', 'History Collection', '2nd Edition', '2019-09-09', 'Shelf C6', 'English', 'PBL-048', 'Regional Transformation', 360, 2019),
('PUB049', 'Research Writing Skills', 'Research Series', '3rd Edition', '2022-02-02', 'Shelf D6', 'English', 'PBL-049', 'Mastering Academic Prose', 225, 2022),
('PUB050', 'Motivational Thinking', 'Self Help Series', '1st Edition', '2020-10-10', 'Shelf F6', 'English', 'PBL-050', 'Empowering the Mind', 190, 2020),
('PUB051', 'Algebra Workbook Advanced', 'Mathematics Series', '2nd Edition', '2021-03-12', 'Shelf A7', 'English', 'PBL-051', 'Mastering Higher Algebra Skills', 280, 2021),
('PUB052', 'Statistics Applications', 'Mathematics Series', '3rd Edition', '2020-07-18', 'Shelf A8', 'English', 'PBL-052', 'Real-World Data Analysis', 310, 2020),
('PUB053', 'Probability Basics', 'Mathematics Series', '1st Edition', '2019-11-05', 'Shelf A9', 'English', 'PBL-053', 'Understanding Chance and Outcomes', 350, 2019),
('PUB054', 'Differential Equations Intro', 'Mathematics Series', '4th Edition', '2022-02-10', 'Shelf A10', 'English', 'PBL-054', 'Foundations of Mathematical Change', 400, 2022),
('PUB055', 'Mathematical Logic', 'Mathematics Series', '1st Edition', '2018-06-22', 'Shelf A11', 'English', 'PBL-055', 'Critical Thinking and Reasoning', 220, 2018),
('PUB056', 'Human Anatomy Basics', 'Science Today', '2nd Edition', '2021-09-14', 'Shelf B6', 'English', 'PBL-056', 'Exploring the Human Body', 190, 2021),
('PUB057', 'Genetics Fundamentals', 'Science Today', '3rd Edition', '2020-04-09', 'Shelf B7', 'English', 'PBL-057', 'The Science of Heredity', 215, 2020),
('PUB058', 'Astronomy Guide', 'Science Today', '1st Edition', '2019-08-16', 'Shelf B8', 'English', 'PBL-058', 'Discovering the Universe', 250, 2019),
('PUB059', 'Marine Biology', 'Science Today', '2nd Edition', '2022-05-11', 'Shelf B9', 'English', 'PBL-059', 'Life Beneath the Ocean', 180, 2022),
('PUB060', 'Ecology and Environment', 'Science Today', '3rd Edition', '2021-12-01', 'Shelf B10', 'English', 'PBL-060', 'Protecting Nature and Ecosystems', 165, 2021),
('PUB061', 'Philippine Government History', 'History Collection', '2nd Edition', '2020-02-20', 'Shelf C7', 'English', 'PBL-061', 'Ancient to Modern Era', 520, 2020),
('PUB062', 'Asian History Timeline', 'History Collection', '1st Edition', '2018-10-10', 'Shelf C8', 'English', 'PBL-062', 'Renaissance and Reform', 540, 2018),
('PUB063', 'European History', 'History Collection', '3rd Edition', '2021-06-14', 'Shelf C9', 'English', 'PBL-063', 'Global Conflicts', 350, 2021),
('PUB064', 'World Wars Overview', 'History Collection', '2nd Edition', '2019-03-03', 'Shelf C10', 'English', 'PBL-064', 'Evolution of Traditions', 980, 2019),
('PUB065', 'Cultural History Studies', 'History Collection', '1st Edition', '2022-08-08', 'Shelf C11', 'English', 'PBL-065', 'Fundamental Principles', 410, 2022),
('PUB066', 'Research Methodology Guide', 'Research Series', '2nd Edition', '2020-11-11', 'Shelf D7', 'English', 'PBL-066', 'Narrative and Ethnography', 210, 2020),
('PUB067', 'Advanced Qualitative Research', 'Research Series', '3rd Edition', '2021-04-04', 'Shelf D8', 'English', 'PBL-067', 'Statistical Interpretation', 195, 2021),
('PUB068', 'Quantitative Analysis', 'Research Series', '1st Edition', '2019-09-09', 'Shelf D9', 'English', 'PBL-068', 'Structural Documentation', 180, 2019),
('PUB069', 'Thesis Writing Guide', 'Research Series', '2nd Edition', '2022-01-01', 'Shelf D10', 'English', 'PBL-069', 'Critical Thinking and Style', 365, 2022),
('PUB070', 'Academic Writing Skills', 'Research Series', '3rd Edition', '2020-06-06', 'Shelf D11', 'English', 'PBL-070', 'Foundations of Natural World', 225, 2020),
('PUB071', 'Science Encyclopedia Volume 1', 'Reference Collection', '10th Edition', '2021-01-15', 'Shelf E6', 'English', 'PBL-071', 'Advanced Scientific Discovery', 120, 2021),
('PUB072', 'Science Encyclopedia Volume 2', 'Reference Collection', '10th Edition', '2021-01-15', 'Shelf E7', 'English', 'PBL-072', 'Cartographic Global Overview', 150, 2021),
('PUB073', 'World Atlas Updated', 'Reference Collection', '6th Edition', '2022-03-20', 'Shelf E8', 'English', 'PBL-073', 'Language and Etymology', 95, 2022),
('PUB074', 'Dictionary of Terms', 'Reference Collection', '11th Edition', '2019-05-05', 'Shelf E9', 'English', 'PBL-074', 'Computing and Digital Systems', 210, 2019),
('PUB075', 'IT Reference Handbook', 'Reference Collection', '3rd Edition', '2023-07-07', 'Shelf E10', 'English', 'PBL-075', 'Cultivating Optimism', 180, 2023),
('PUB076', 'Positive Mindset Guide', 'Self Help Series', '2nd Edition', '2020-10-10', 'Shelf F7', 'English', 'PBL-076', 'Personal Wealth Management', 32, 2020),
('PUB077', 'Financial Freedom Basics', 'Self Help Series', '1st Edition', '2021-02-14', 'Shelf F8', 'English', 'PBL-077', 'Building Inner Strength', 40, 2021),
('PUB078', 'Self Confidence Booster', 'Self Help Series', '3rd Edition', '2019-07-07', 'Shelf F9', 'English', 'PBL-078', 'Inspiration for Every Day', 24, 2019),
('PUB079', 'Daily Motivation Book', 'Self Help Series', '1st Edition', '2022-12-12', 'Shelf F10', 'English', 'PBL-079', 'Principles of Team Management', 36, 2022),
('PUB080', 'Leadership Skills Guide', 'Self Help Series', '2nd Edition', '2018-08-08', 'Shelf F11', 'English', 'PBL-080', 'Traditional Sweets', 48, 2018),
('PUB081', 'Filipino Dessert Recipes', 'Recipe Collection', '1st Edition', '2021-05-05', 'Shelf G6', 'English', 'PBL-081', '30-Minute Meals', 24, 2021),
('PUB082', 'Easy Home Cooking', 'Recipe Collection', '2nd Edition', '2020-09-09', 'Shelf G7', 'English', 'PBL-082', 'Finger Foods & Appetizers', 32, 2020),
('PUB083', 'Quick Snacks Recipes', 'Recipe Collection', '1st Edition', '2019-12-12', 'Shelf G8', 'English', 'PBL-083', 'Flavors of the World', 45, 2019),
('PUB084', 'International Cuisine', 'Recipe Collection', '3rd Edition', '2022-04-04', 'Shelf G9', 'English', 'PBL-084', 'Balanced Nutrition Guide', 130, 2022),
('PUB085', 'Healthy Diet Recipes', 'Recipe Collection', '2nd Edition', '2018-06-06', 'Shelf G10', 'English', 'PBL-085', 'The Next Generation', 50, 2018),
('PUB086', 'Superhero Adventures', 'Comic Series', '2nd Edition', '2021-03-03', 'Shelf H6', 'English', 'PBL-086', 'Beyond the Galaxy', 280, 2021),
('PUB087', 'Space Explorers Comic', 'Comic Series', '1st Edition', '2020-07-07', 'Shelf H7', 'English', 'PBL-087', 'Sunday Funnies', 450, 2020),
('PUB088', 'Funny Cartoon World', 'Comic Series', '3rd Edition', '2019-11-11', 'Shelf H8', 'English', 'PBL-088', 'The Crimson Mystery', 520, 2019),
('PUB089', 'Detective Stories Comic', 'Comic Series', '2nd Edition', '2022-02-02', 'Shelf H9', 'English', 'PBL-089', 'Origins of Power', 310, 2022),
('PUB090', 'Hero Legends', 'Comic Series', '1st Edition', '2018-09-09', 'Shelf H10', 'English', 'PBL-090', 'Visual Learning Guide', 215, 2018),
('PUB091', 'Learning Colors for Kids', 'Kids Corner', '1st Edition', '2020-01-01', 'Shelf I6', 'English', 'PBL-091', 'Counting for Beginners', 24, 2020),
('PUB092', 'Numbers for Kids', 'Kids Corner', '2nd Edition', '2021-06-06', 'Shelf I7', 'English', 'PBL-092', 'Easy Experiments', 30, 2021),
('PUB093', 'Kids Science Fun', 'Kids Corner', '1st Edition', '2019-03-03', 'Shelf I8', 'English', 'PBL-093', 'Magical Midnight Tales', 45, 2019),
('PUB094', 'Bedtime Fairy Stories', 'Kids Corner', '3rd Edition', '2022-10-10', 'Shelf I9', 'English', 'PBL-094', 'Habitat and Wildlife', 80, 2022),
('PUB095', 'Animal Learning Book', 'Kids Corner', '2nd Edition', '2018-05-05', 'Shelf I10', 'English', 'PBL-095', 'Equation Solving Techniques', 36, 2018),
('PUB096', 'Algebra Mastery', 'Mathematics Series', '2nd Edition', '2021-08-08', 'Shelf A12', 'English', 'PBL-096', 'Quantum and Mechanics', 320, 2021),
('PUB097', 'Physics Advanced', 'Science Today', '3rd Edition', '2020-02-02', 'Shelf B11', 'English', 'PBL-097', 'Pre-Colonial to Present', 410, 2020),
('PUB098', 'History of Philippines Expanded', 'History Collection', '2nd Edition', '2022-11-11', 'Shelf C12', 'English', 'PBL-098', 'Comprehensive Thesis Guide', 550, 2022),
('PUB099', 'Research Writing Mastery', 'Research Series', '1st Edition', '2019-04-04', 'Shelf D12', 'English', 'PBL-099', 'Achieving Your Goals', 275, 2019),
('PUB100', 'Motivation for Success', 'Self Help Series', '3rd Edition', '2021-12-12', 'Shelf F12', 'English', 'PBL-100', 'Personal Growth & Achievement Guide', 210, 2021),
('PUB101', 'Philippine Star', 'Newspaper', 'Daily', '2026-05-12', 'News-Rack 1', 'English', 'PBL-101', 'Truth Shall Prevail National News', 28, 2026),
('PUB102', 'Manila Bulletin', 'Newspaper', 'Daily', '2026-05-12', 'News-Rack 1', 'English', 'PBL-102', 'The Nation\'s Leading Newspaper', 32, 2026),
('PUB103', 'Phil. Daily Inquirer', 'Newspaper', 'Daily', '2026-05-12', 'News-Rack 1', 'English', 'PBL-103', 'Balanced News, Fearless Views', 30, 2026),
('PUB104', 'The Manila Times', 'Newspaper', 'Daily', '2026-05-12', 'News-Rack 2', 'English', 'PBL-104', 'Trusted Voice in Philippine Journalism', 26, 2026),
('PUB105', 'Daily Tribune', 'Newspaper', 'Daily', '2026-05-12', 'News-Rack 2', 'English', 'PBL-105', 'Without Fear or Favor Broadcaster', 24, 2026),
('PUB106', 'BusinessWorld', 'Newspaper', 'Financial/Daily', '2026-05-12', 'News-Rack 2', 'English', 'PBL-106', 'Southeast Asia\'s First Business Daily', 22, 2026),
('PUB107', 'Manila Standard', 'Newspaper', 'Daily', '2026-05-12', 'News-Rack 3', 'English', 'PBL-107', 'Defining the News for the Global Filipino', 25, 2026),
('PUB108', 'BusinessMirror', 'Newspaper', 'Daily', '2026-05-12', 'News-Rack 3', 'English', 'PBL-108', 'A Broader Look at Banking & Finance', 27, 2026),
('PUB109', 'The Freeman', 'Newspaper', 'Regional/Daily', '2026-05-12', 'News-Rack 3', 'English', 'PBL-109', 'Cebu\'s Oldest and Trusted Daily', 20, 2026),
('PUB110', 'Malaya Business', 'Newspaper', 'Financial/Daily', '2026-05-12', 'News-Rack 2', 'English', 'PBL-110', 'Insightful Corporate & Economic Reporting', 18, 2026),
('PUB111', 'Esquire Philippines', 'Magazine', 'Monthly', '2026-05-05', 'Mag-Shelf B', 'English', 'PBL-111', 'Modern Man\'s Guide to Style & Culture', 120, 2026),
('PUB112', 'Reader\'s Digest PH', 'Magazine', 'Asian Ed.', '2026-05-01', 'Mag-Shelf A', 'English', 'PBL-112', 'Inspiring Stories and Practical Advice', 140, 2026),
('PUB113', 'K-Mag', 'Magazine', 'Bi-Monthly', '2026-04-10', 'Mag-Shelf E', 'English', 'PBL-113', 'The Definitive K-Pop & Hallyu Resource', 95, 2026),
('PUB114', 'Preview Magazine', 'Magazine', 'Monthly', '2026-05-01', 'Mag-Shelf B', 'English', 'PBL-114', 'The Philippines\' Style Authority', 110, 2026),
('PUB115', 'Cosmopolitan PH', 'Magazine', 'Monthly', '2026-05-01', 'Mag-Shelf B', 'English', 'PBL-115', 'Fun, Fearless Female Lifestyle', 130, 2026),
('PUB116', 'Top Gear PH', 'Magazine', 'Monthly', '2026-05-01', 'Mag-Shelf C', 'English', 'PBL-116', 'Number One Automotive Authority', 125, 2026),
('PUB117', 'Forbes Philippines', 'Magazine', 'Monthly', '2026-05-01', 'Mag-Shelf D', 'English', 'PBL-117', 'Wealth, Innovation, and Leadership', 150, 2026),
('PUB118', 'Men\'s Health PH', 'Magazine', 'Monthly', '2026-04-01', 'Mag-Shelf E', 'English', 'PBL-118', 'Fitness and Wellness for the Modern Man', 118, 2026),
('PUB119', 'Spot.ph', 'Magazine', 'Quarterly', '2026-02-15', 'Mag-Shelf D', 'English', 'PBL-119', 'The Ultimate Guide to Manila Living', 90, 2026),
('PUB120', 'Home & Design', 'Magazine', 'Annual', '2026-01-10', 'Mag-Shelf F', 'English', 'PBL-120', 'Interior Inspiration and Architecture', 105, 2026),
('PUB121', 'Tempo', 'Tabloid', 'Daily', '2026-05-11', 'Tab-Section', 'English', 'PBL-121', 'News in a Flash Tabloid', 20, 2026),
('PUB122', 'Bulgar', 'Tabloid', 'Daily', '2026-05-12', 'Tab-Section', 'Tagalog', 'PBL-122', 'Boses ng Pinoy, Mata ng Bayan', 22, 2026),
('PUB123', 'Bandera', 'Tabloid', 'Daily', '2026-05-11', 'Tab-Section', 'Bisaya', 'PBL-123', 'Balita, Karera, at Panalo', 18, 2026),
('PUB124', 'People\'s Journal', 'Tabloid', 'Daily', '2026-05-12', 'Tab-Section', 'English', 'PBL-124', 'The Country\'s Best-Selling Tabloid', 20, 2026),
('PUB125', 'Abante', 'Tabloid', 'Daily', '2026-05-12', 'Tab-Section', 'Tagalog', 'PBL-125', 'Una sa Balita, Una sa Masa', 24, 2026),
('PUB126', 'Pilipino Star Ngayon', 'Tabloid', 'Daily', '2026-05-12', 'Tab-Section', 'Tagalog', 'PBL-126', 'Ang Dyaryo ng Masang Pilipino', 26, 2026),
('PUB127', 'Hataw!', 'Tabloid', 'Daily', '2026-05-12', 'Tab-Section', 'Tagalog', 'PBL-127', 'Diyaryo ng Bayan for General News', 18, 2026),
('PUB128', 'Remate', 'Tabloid', 'Daily', '2026-05-12', 'Tab-Section', 'Tagalog', 'PBL-128', 'Ang Diaryo ng Masa at Katotohanan', 22, 2026),
('PUB129', 'Balita', 'Tabloid', 'Daily', '2026-05-12', 'Tab-Section', 'Tagalog', 'PBL-129', 'Pangunahing Pahayagang Tagalog sa Bansa', 20, 2026),
('PUB130', 'Police Files', 'Tabloid', 'Daily', '2026-05-12', 'Tab-Section', 'Tagalog', 'PBL-130', 'Crime, Justice, and Community Watch', 16, 2026);

-- --------------------------------------------------------

--
-- Table structure for table `publisher`
--

CREATE TABLE `publisher` (
  `publisher_id` varchar(30) NOT NULL,
  `publisher` varchar(100) NOT NULL,
  `place_of_publication` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `publisher`
--

INSERT INTO `publisher` (`publisher_id`, `publisher`, `place_of_publication`) VALUES
('PBL-001', 'Rex Book Store', 'Manila'),
('PBL-002', 'Rex Book Store', 'Cebu City'),
('PBL-003', 'Phoenix Publishing', 'Quezon City'),
('PBL-004', 'C&E Publishing', 'Manila'),
('PBL-005', 'Vibal Group', 'Pasig City'),
('PBL-006', 'Phoenix Publishing', 'Manila'),
('PBL-007', 'Rex Book Store', 'Davao City'),
('PBL-008', 'Anvil Publishing', 'Quezon City'),
('PBL-009', 'C&E Publishing', 'Manila'),
('PBL-010', 'Vibal Group', 'Cebu City'),
('PBL-011', 'Rex Book Store', 'Manila'),
('PBL-012', 'Adarna House', 'Quezon City'),
('PBL-013', 'National Book Store', 'Naga City'),
('PBL-014', 'Summit Books', 'Manila'),
('PBL-015', 'Rex Book Store', 'Cebu City'),
('PBL-016', 'Phoenix Publishing', 'Davao City'),
('PBL-017', 'Anvil Publishing', 'Manila'),
('PBL-018', 'C&E Publishing', 'Quezon City'),
('PBL-019', 'Vibal Group', 'Pasig City'),
('PBL-020', 'Rex Book Store', 'Manila'),
('PBL-021', 'Merriam Publishing', 'New York'),
('PBL-022', 'Britannica', 'London'),
('PBL-023', 'National Geographic', 'Washington DC'),
('PBL-024', 'Rex Book Store', 'Manila'),
('PBL-025', 'Phoenix Publishing', 'Cebu City'),
('PBL-026', 'Summit Books', 'Manila'),
('PBL-027', 'Vibal Group', 'Davao City'),
('PBL-028', 'Rex Book Store', 'Quezon City'),
('PBL-029', 'National Book Store', 'Manila'),
('PBL-030', 'Summit Books', 'Cebu City'),
('PBL-031', 'National Book Store', 'Naga City'),
('PBL-032', 'Summit Books', 'Manila'),
('PBL-033', 'Rex Book Store', 'Cebu City'),
('PBL-034', 'Phoenix Publishing', 'Davao City'),
('PBL-035', 'National Book Store', 'Quezon City'),
('PBL-036', 'Marvel Press', 'New York'),
('PBL-037', 'DC Comics', 'California'),
('PBL-038', 'Marvel Press', 'New York'),
('PBL-039', 'DC Comics', 'California'),
('PBL-040', 'Marvel Press', 'New York'),
('PBL-041', 'Adarna House', 'Quezon City'),
('PBL-042', 'Rex Book Store', 'Manila'),
('PBL-043', 'Phoenix Publishing', 'Cebu City'),
('PBL-044', 'Adarna House', 'Quezon City'),
('PBL-045', 'National Book Store', 'Davao City'),
('PBL-046', 'Rex Book Store', 'Manila'),
('PBL-047', 'Phoenix Publishing', 'Cebu City'),
('PBL-048', 'Anvil Publishing', 'Manila'),
('PBL-049', 'C&E Publishing', 'Quezon City'),
('PBL-050', 'Summit Books', 'Manila'),
('PBL-051', 'Rex Book Store', 'Manila'),
('PBL-052', 'Phoenix Publishing', 'Cebu City'),
('PBL-053', 'C&E Publishing', 'Quezon City'),
('PBL-054', 'Vibal Group', 'Manila'),
('PBL-055', 'Rex Book Store', 'Cebu City'),
('PBL-056', 'Phoenix Publishing', 'Davao City'),
('PBL-057', 'C&E Publishing', 'Manila'),
('PBL-058', 'Vibal Group', 'Quezon City'),
('PBL-059', 'Rex Book Store', 'Cebu City'),
('PBL-060', 'Phoenix Publishing', 'Manila'),
('PBL-061', 'Anvil Publishing', 'Quezon City'),
('PBL-062', 'C&E Publishing', 'Manila'),
('PBL-063', 'Summit Books', 'Cebu City'),
('PBL-064', 'Rex Book Store', 'Davao City'),
('PBL-065', 'Phoenix Publishing', 'Manila'),
('PBL-066', 'C&E Publishing', 'Quezon City'),
('PBL-067', 'Vibal Group', 'Cebu City'),
('PBL-068', 'Rex Book Store', 'Manila'),
('PBL-069', 'Phoenix Publishing', 'Davao City'),
('PBL-070', 'C&E Publishing', 'Quezon City'),
('PBL-071', 'Britannica', 'London'),
('PBL-072', 'Britannica', 'London'),
('PBL-073', 'National Geographic', 'Washington DC'),
('PBL-074', 'Merriam Publishing', 'New York'),
('PBL-075', 'Rex Book Store', 'Manila'),
('PBL-076', 'Summit Books', 'Cebu City'),
('PBL-077', 'Vibal Group', 'Davao City'),
('PBL-078', 'Rex Book Store', 'Manila'),
('PBL-079', 'National Book Store', 'Quezon City'),
('PBL-080', 'Summit Books', 'Cebu City'),
('PBL-081', 'National Book Store', 'Naga City'),
('PBL-082', 'Summit Books', 'Manila'),
('PBL-083', 'Rex Book Store', 'Cebu City'),
('PBL-084', 'Phoenix Publishing', 'Davao City'),
('PBL-085', 'National Book Store', 'Quezon City'),
('PBL-086', 'Marvel Press', 'New York'),
('PBL-087', 'DC Comics', 'California'),
('PBL-088', 'Marvel Press', 'New York'),
('PBL-089', 'DC Comics', 'California'),
('PBL-090', 'Marvel Press', 'New York'),
('PBL-091', 'Adarna House', 'Quezon City'),
('PBL-092', 'Rex Book Store', 'Manila'),
('PBL-093', 'Phoenix Publishing', 'Cebu City'),
('PBL-094', 'Adarna House', 'Quezon City'),
('PBL-095', 'National Book Store', 'Davao City'),
('PBL-096', 'Rex Book Store', 'Manila'),
('PBL-097', 'Phoenix Publishing', 'Cebu City'),
('PBL-098', 'Anvil Publishing', 'Manila'),
('PBL-099', 'C&E Publishing', 'Quezon City'),
('PBL-100', 'Summit Books', 'Manila'),
('PBL-101', 'PhilStar Grp', 'Manila'),
('PBL-102', 'MB Publishing', 'Manila'),
('PBL-103', 'PDI Inc.', 'Makati'),
('PBL-104', 'TMT Pub.', 'Manila'),
('PBL-105', 'Concept Pub.', 'Manila'),
('PBL-106', 'PhilStar Grp', 'Quezon City'),
('PBL-107', 'MST Pub.', 'Manila'),
('PBL-108', 'Phil. Business', 'Makati'),
('PBL-109', 'PhilStar Grp', 'Cebu City'),
('PBL-110', 'Malaya Pub.', 'Manila'),
('PBL-111', 'Summit Media', 'Makati'),
('PBL-112', 'Direct Pub.', 'Manila'),
('PBL-113', 'K-Publishing', 'Pasig'),
('PBL-114', 'Summit Media', 'Makati'),
('PBL-115', 'Summit Media', 'Makati'),
('PBL-116', 'Summit Media', 'Mandaluyong'),
('PBL-117', 'PhilStar Grp', 'Manila'),
('PBL-118', 'Summit Media', 'Makati'),
('PBL-119', 'Summit Media', 'Mandaluyong'),
('PBL-120', 'Vibal Group', 'Quezon City'),
('PBL-121', 'Manila Bulletin', 'Manila'),
('PBL-122', 'Sison\'s Pub.', 'Quezon City'),
('PBL-123', 'PDI Inc.', 'Makati'),
('PBL-124', 'PJI Inc.', 'Manila'),
('PBL-125', 'Monica Pub.', 'Manila'),
('PBL-126', 'PhilStar Grp', 'Manila'),
('PBL-127', 'JSY Pub.', 'Manila'),
('PBL-128', 'Remate Pub.', 'Manila'),
('PBL-129', 'Manila Bulletin', 'Manila'),
('PBL-130', 'PFT Pub.', 'Manila');

-- --------------------------------------------------------

--
-- Table structure for table `recipe book`
--

CREATE TABLE `recipe book` (
  `recipebook_id` varchar(20) NOT NULL,
  `nonfiction_id` varchar(20) NOT NULL,
  `cuisine_type` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `recipe book`
--

INSERT INTO `recipe book` (`recipebook_id`, `nonfiction_id`, `cuisine_type`) VALUES
('R001', 'NF-001', 'American'),
('R002', 'NF-002', 'Chinese'),
('R003', 'NF-003', 'African'),
('R004', 'NF-004', 'Arab'),
('R005', 'NF-005', 'Italian'),
('R006', 'NF-012', 'Japanese'),
('R007', 'NF-013', 'Philippine'),
('R008', 'NF-014', 'Caribbean'),
('R009', 'NF-015', 'Latin'),
('R010', 'NF-016', 'Moroccan');

-- --------------------------------------------------------

--
-- Table structure for table `reference books`
--

CREATE TABLE `reference books` (
  `reference_id` varchar(20) NOT NULL,
  `academic_id` varchar(20) NOT NULL,
  `reference_type` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reference books`
--

INSERT INTO `reference books` (`reference_id`, `academic_id`, `reference_type`) VALUES
('REF-001', 'ACAD-045', 'Encyclopedia'),
('REF-002', 'ACAD-046', 'Encyclopedia'),
('REF-003', 'ACAD-047', 'Atlas'),
('REF-004', 'ACAD-048', 'Dictionary'),
('REF-005', 'ACAD-049', 'Handbook'),
('REF-006', 'ACAD-050', 'Dictionary'),
('REF-007', 'ACAD-051', 'Encyclopedia'),
('REF-008', 'ACAD-052', 'Atlas'),
('REF-009', 'ACAD-053', 'Guide'),
('REF-010', 'ACAD-054', 'Handbook');

-- --------------------------------------------------------

--
-- Table structure for table `reports`
--

CREATE TABLE `reports` (
  `report_id` varchar(30) NOT NULL,
  `libclerk_id` varchar(30) NOT NULL,
  `report_type` varchar(50) NOT NULL CHECK (`report_type` in ('Monthly','Annual')),
  `date_generated` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reports`
--

INSERT INTO `reports` (`report_id`, `libclerk_id`, `report_type`, `date_generated`) VALUES
('REP001', 'LC001', 'Monthly', '2026-04-30'),
('REP002', 'LC001', 'Annual', '2025-12-31'),
('REP003', 'LC002', 'Monthly', '2026-05-15');

-- --------------------------------------------------------

--
-- Table structure for table `research`
--

CREATE TABLE `research` (
  `research_id` varchar(20) NOT NULL,
  `academic_id` varchar(20) NOT NULL,
  `research_type` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `research`
--

INSERT INTO `research` (`research_id`, `academic_id`, `research_type`) VALUES
('R001', 'ACAD-016', 'Practical Research'),
('R002', 'ACAD-017', 'Practical Research'),
('R003', 'ACAD-018', 'Introduction to Research'),
('R004', 'ACAD-019', 'Quantitative Research'),
('R005', 'ACAD-020', 'Qualitative Research'),
('R006', 'ACAD-040', 'Research Methodology'),
('R007', 'ACAD-041', 'Advanced Qualitative Research'),
('R008', 'ACAD-042', 'Quantitative Analysis'),
('R009', 'ACAD-043', 'Thesis Writing'),
('R010', 'ACAD-044', 'Academic Writing Skills'),
('R011', 'ACAD-057', 'Research Writing Mastery');

-- --------------------------------------------------------

--
-- Table structure for table `science`
--

CREATE TABLE `science` (
  `science_id` varchar(20) NOT NULL,
  `academic_id` varchar(20) NOT NULL,
  `science_branch` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `science`
--

INSERT INTO `science` (`science_id`, `academic_id`, `science_branch`) VALUES
('SCI-001', 'ACAD-006', 'Biology'),
('SCI-002', 'ACAD-007', 'Chemistry'),
('SCI-003', 'ACAD-008', 'Physics'),
('SCI-004', 'ACAD-009', 'Earth Science'),
('SCI-005', 'ACAD-010', 'Environmental Science'),
('SCI-006', 'ACAD-022', 'Organic Chemistry'),
('SCI-007', 'ACAD-030', 'Human Anatomy'),
('SCI-008', 'ACAD-031', 'Genetics'),
('SCI-009', 'ACAD-032', 'Astronomy'),
('SCI-010', 'ACAD-033', 'Marine Biology'),
('SCI-011', 'ACAD-034', 'Ecology');

-- --------------------------------------------------------

--
-- Table structure for table `self help`
--

CREATE TABLE `self help` (
  `selfhelp_id` varchar(20) NOT NULL,
  `nonfiction_id` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `self help`
--

INSERT INTO `self help` (`selfhelp_id`, `nonfiction_id`) VALUES
('SHP001', 'NF-006'),
('SHP002', 'NF-007'),
('SHP003', 'NF-008'),
('SHP004', 'NF-009'),
('SHP005', 'NF-010'),
('SHP006', 'NF-011'),
('SHP007', 'NF-017'),
('SHP008', 'NF-018'),
('SHP009', 'NF-019'),
('SHP010', 'NF-020'),
('SHP011', 'NF-021'),
('SHP012', 'NF-022');

-- --------------------------------------------------------

--
-- Table structure for table `status`
--

CREATE TABLE `status` (
  `id_status` int(11) NOT NULL,
  `status_type` varchar(20) NOT NULL CHECK (`status_type` in ('Available','Borrowed','Overdue')),
  `libclerk_id` varchar(30) NOT NULL,
  `condition` varchar(50) NOT NULL CHECK (`condition` in ('Good','Damaged'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `status`
--

INSERT INTO `status` (`id_status`, `status_type`, `libclerk_id`, `condition`) VALUES
(110001, 'Available', 'LC001', 'Good'),
(110002, 'Available', 'LC002', 'Good'),
(110003, 'Available', 'LC001', 'Good'),
(110004, 'Available', 'LC002', 'Good'),
(110005, 'Available', 'LC001', 'Good'),
(110006, 'Available', 'LC002', 'Good'),
(110007, 'Available', 'LC001', 'Good'),
(110008, 'Available', 'LC002', 'Good'),
(110009, 'Available', 'LC001', 'Good'),
(110010, 'Available', 'LC002', 'Good'),
(110011, 'Borrowed', 'LC001', 'Good'),
(110012, 'Available', 'LC002', 'Good'),
(110013, 'Available', 'LC001', 'Good'),
(110014, 'Available', 'LC002', 'Good'),
(110015, 'Available', 'LC001', 'Good'),
(110016, 'Available', 'LC002', 'Good'),
(110017, 'Available', 'LC001', 'Good'),
(110018, 'Available', 'LC002', 'Good'),
(110019, 'Available', 'LC001', 'Good'),
(110020, 'Available', 'LC002', 'Good'),
(110021, 'Available', 'LC001', 'Damaged'),
(110022, 'Overdue', 'LC002', 'Good'),
(110023, 'Available', 'LC001', 'Good'),
(110024, 'Available', 'LC002', 'Good'),
(110025, 'Available', 'LC001', 'Good'),
(110026, 'Available', 'LC002', 'Good'),
(110027, 'Available', 'LC001', 'Good'),
(110028, 'Available', 'LC002', 'Good'),
(110029, 'Available', 'LC001', 'Good'),
(110030, 'Available', 'LC002', 'Good'),
(110031, 'Available', 'LC001', 'Good'),
(110032, 'Available', 'LC002', 'Good'),
(110033, 'Available', 'LC001', 'Good'),
(110034, 'Borrowed', 'LC002', 'Good'),
(110035, 'Borrowed', 'LC001', 'Good'),
(110036, 'Borrowed', 'LC002', 'Good'),
(110037, 'Borrowed', 'LC001', 'Good'),
(110038, 'Available', 'LC002', 'Good'),
(110039, 'Available', 'LC001', 'Good'),
(110040, 'Available', 'LC002', 'Good'),
(110041, 'Available', 'LC001', 'Good'),
(110042, 'Available', 'LC002', 'Good'),
(110043, 'Available', 'LC001', 'Good'),
(110044, 'Available', 'LC002', 'Good'),
(110045, 'Available', 'LC001', 'Good'),
(110046, 'Available', 'LC002', 'Good'),
(110047, 'Available', 'LC001', 'Damaged'),
(110048, 'Available', 'LC002', 'Good'),
(110049, 'Available', 'LC001', 'Good'),
(110050, 'Available', 'LC002', 'Good'),
(110051, 'Available', 'LC001', 'Good'),
(110052, 'Available', 'LC002', 'Good'),
(110053, 'Borrowed', 'LC001', 'Good'),
(110054, 'Available', 'LC002', 'Good'),
(110055, 'Available', 'LC001', 'Good'),
(110056, 'Available', 'LC002', 'Good'),
(110057, 'Available', 'LC001', 'Good'),
(110058, 'Available', 'LC002', 'Good'),
(110059, 'Available', 'LC001', 'Good'),
(110060, 'Available', 'LC002', 'Good'),
(110061, 'Available', 'LC001', 'Good'),
(110062, 'Available', 'LC002', 'Good'),
(110063, 'Available', 'LC001', 'Good'),
(110064, 'Available', 'LC002', 'Good'),
(110065, 'Available', 'LC001', 'Good'),
(110066, 'Available', 'LC002', 'Good'),
(110067, 'Available', 'LC001', 'Good'),
(110068, 'Available', 'LC002', 'Good'),
(110069, 'Available', 'LC001', 'Good'),
(110070, 'Available', 'LC002', 'Damaged'),
(110071, 'Available', 'LC001', 'Good'),
(110072, 'Borrowed', 'LC002', 'Good'),
(110073, 'Available', 'LC001', 'Good'),
(110074, 'Available', 'LC002', 'Good'),
(110075, 'Borrowed', 'LC001', 'Good'),
(110076, 'Borrowed', 'LC002', 'Good'),
(110077, 'Borrowed', 'LC001', 'Good'),
(110078, 'Borrowed', 'LC002', 'Good'),
(110079, 'Available', 'LC001', 'Good'),
(110080, 'Available', 'LC002', 'Good'),
(110081, 'Available', 'LC001', 'Good'),
(110082, 'Available', 'LC002', 'Good'),
(110083, 'Available', 'LC001', 'Good'),
(110084, 'Available', 'LC002', 'Good'),
(110085, 'Available', 'LC001', 'Good'),
(110086, 'Available', 'LC002', 'Good'),
(110087, 'Available', 'LC001', 'Good'),
(110088, 'Available', 'LC002', 'Good'),
(110089, 'Available', 'LC001', 'Good'),
(110090, 'Available', 'LC002', 'Good'),
(110091, 'Available', 'LC001', 'Good'),
(110092, 'Available', 'LC002', 'Good'),
(110093, 'Available', 'LC001', 'Good'),
(110094, 'Overdue', 'LC002', 'Good'),
(110095, 'Available', 'LC001', 'Damaged'),
(110096, 'Available', 'LC002', 'Good'),
(110097, 'Available', 'LC001', 'Good'),
(110098, 'Available', 'LC002', 'Good'),
(110099, 'Available', 'LC001', 'Good'),
(110100, 'Borrowed', 'LC002', 'Good');

-- --------------------------------------------------------

--
-- Table structure for table `tabloids`
--

CREATE TABLE `tabloids` (
  `tabloid_id` varchar(30) NOT NULL,
  `ISSN` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tabloids`
--

INSERT INTO `tabloids` (`tabloid_id`, `ISSN`) VALUES
('TAB-101', 'ISSN-1011-021'),
('TAB-102', 'ISSN-1011-022'),
('TAB-103', 'ISSN-1011-023'),
('TAB-104', 'ISSN-1011-024'),
('TAB-105', 'ISSN-1011-025'),
('TAB-106', 'ISSN-1011-026'),
('TAB-107', 'ISSN-1011-027'),
('TAB-108', 'ISSN-1011-028'),
('TAB-109', 'ISSN-1011-029'),
('TAB-110', 'ISSN-1011-030');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `user_id` int(11) NOT NULL,
  `user_fname` varchar(50) NOT NULL,
  `user_lname` varchar(50) NOT NULL,
  `user_midInit` char(1) DEFAULT NULL,
  `birth_date` date NOT NULL,
  `gender` varchar(10) NOT NULL CHECK (`gender` in ('male','female')),
  `email` varchar(50) NOT NULL,
  `user_type` varchar(30) NOT NULL CHECK (`user_type` in ('Librarian','Borrower','IT Staff','Library Clerk')),
  `add_id` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`user_id`, `user_fname`, `user_lname`, `user_midInit`, `birth_date`, `gender`, `email`, `user_type`, `add_id`) VALUES
(100001, 'Anna', 'Reyes', 'D', '1995-06-12', 'Female', 'anna.reyes@gmail.com', 'Librarian', 'ADD001'),
(100002, 'Mark', 'Santos', 'S', '1998-03-21', 'Male', 'mark.santos@gmail.com', 'Library Clerk', 'ADD002'),
(100003, 'Joana', 'Cruz', 'D', '1999-05-20', 'Female', 'joana.cruz@gmail.com', 'Library Clerk', 'ADD003'),
(100004, 'John', 'Dela Cruz', 'F', '1993-11-10', 'Male', 'john.delacruz@gmail.com', 'IT Staff', 'ADD004'),
(100005, 'Carla', 'Mendoza', 'C', '2002-01-15', 'Female', 'carla.mendoza@gmail.com', 'Borrower', 'ADD005'),
(100006, 'Kevin', 'Ramos', 'A', '2001-04-10', 'Male', 'kevin.ramos@gmail.com', 'Borrower', 'ADD006'),
(100007, 'Maria', 'Lopez', 'C', '2000-07-20', 'Female', 'maria.lopez@gmail.com', 'Borrower', 'ADD007'),
(100008, 'James', 'Garcia', 'B', '1999-09-05', 'Male', 'james.garcia@gmail.com', 'Borrower', 'ADD008'),
(100009, 'Sophia', 'Cruz', 'S', '2003-02-18', 'Female', 'sophia.cruz@gmail.com', 'Borrower', 'ADD009'),
(100010, 'Daniel', 'Flores', 'C', '2002-12-11', 'Male', 'daniel.flores@gmail.com', 'Borrower', 'ADD010'),
(100011, 'Nicole', 'Torres', 'E', '2001-06-25', 'Female', 'nicole.torres@gmail.com', 'Borrower', 'ADD011'),
(100012, 'Ethan', 'Villanueva', 'W', '2000-03-14', 'Male', 'ethan.villanueva@gmail.com', 'Borrower', 'ADD012'),
(100013, 'Angela', 'Perez', 'T', '1999-08-09', 'Female', 'angela.perez@gmail.com', 'Borrower', 'ADD013'),
(100014, 'Joshua', 'Bautista', 'S', '2001-05-01', 'Male', 'joshua.bautista@gmail.com', 'Borrower', 'ADD014'),
(100015, 'Bea', 'Navarro', 'G', '2002-11-23', 'Female', 'bea.navarro@gmail.com', 'Borrower', 'ADD015'),
(100016, 'Christian', 'Aquino', 'M', '2003-07-30', 'Male', 'christian.aquino@gmail.com', 'Borrower', 'ADD016'),
(100017, 'Faith', 'Castillo', 'J', '2001-01-08', 'Female', 'faith.castillo@gmail.com', 'Borrower', 'ADD017'),
(100018, 'Vincent', 'Rivera', 'K', '2000-10-12', 'Male', 'vincent.rivera@gmail.com', 'Borrower', 'ADD018'),
(100019, 'Chloe', 'Morales', 'G', '2002-09-19', 'Female', 'chloe.morales@gmail.com', 'Borrower', 'ADD019'),
(100020, 'Ryan', 'Herrera', 'R', '1999-04-28', 'Male', 'ryan.herrera@gmail.com', 'Borrower', 'ADD020'),
(100021, 'Alyssa', 'Gomez', 'A', '2001-12-02', 'Female', 'alyssa.gomez@gmail.com', 'Borrower', 'ADD021'),
(100022, 'Carl', 'Diaz', 'R', '2000-06-17', 'Male', 'carl.diaz@gmail.com', 'Borrower', 'ADD022'),
(100023, 'Jasmine', 'Ramos', 'C', '2003-03-09', 'Female', 'jasmine.ramos@gmail.com', 'Borrower', 'ADD023'),
(100024, 'Patrick', 'Mendoza', 'C', '2002-08-21', 'Male', 'patrick.mendoza@gmail.com', 'Borrower', 'ADD024'),
(100025, 'Hannah', 'Reyes', 'D', '1999-05-13', 'Female', 'hannah.reyes@gmail.com', 'Borrower', 'ADD025'),
(100026, 'Sean', 'Santos', 'W', '2001-11-27', 'Male', 'sean.santos@gmail.com', 'Borrower', 'ADD026'),
(100027, 'Angel', 'Cruz', 'S', '2000-02-06', 'Female', 'angel.cruz@gmail.com', 'Borrower', 'ADD027'),
(100028, 'Gabriel', 'Flores', 'A', '2003-01-16', 'Male', 'gabriel.flores@gmail.com', 'Borrower', 'ADD028'),
(100029, 'Kim', 'Torres', 'E', '2002-07-07', 'Female', 'kim.torres@gmail.com', 'Borrower', 'ADD029'),
(100030, 'Nathan', 'Garcia', 'W', '2001-09-22', 'Male', 'nathan.garcia@gmail.com', 'Borrower', 'ADD030'),
(100031, 'Ella', 'Lopez', 'W', '2000-12-15', 'Female', 'ella.lopez@gmail.com', 'Borrower', 'ADD031'),
(100032, 'Adrian', 'Perez', 'A', '1999-10-30', 'Male', 'adrian.perez@gmail.com', 'Borrower', 'ADD032'),
(100033, 'Trisha', 'Aquino', 'A', '2002-06-11', 'Female', 'trisha.aquino@gmail.com', 'Borrower', 'ADD033'),
(100034, 'Kyle', 'Bautista', 'Z', '2001-04-04', 'Male', 'kyle.bautista@gmail.com', 'Borrower', 'ADD034'),
(100035, 'Denise', 'Rivera', 'C', '2003-02-28', 'Female', 'denise.rivera@gmail.com', 'Borrower', 'ADD035'),
(100036, 'Matthew', 'Navarro', 'D', '2000-07-01', 'Male', 'matthew.navarro@gmail.com', 'Borrower', 'ADD036'),
(100037, 'Princess', 'Castillo', 'G', '2001-08-14', 'Female', 'princess.castillo@gmail.com', 'Borrower', 'ADD037'),
(100038, 'Jacob', 'Diaz', 'L', '2002-03-17', 'Male', 'jacob.diaz@gmail.com', 'Borrower', 'ADD038'),
(100039, 'Rica', 'Morales', 'L', '1999-09-09', 'Female', 'rica.morales@gmail.com', 'Borrower', 'ADD039'),
(100040, 'Aaron', 'Herrera', 'I', '2001-05-24', 'Male', 'aaron.herrera@gmail.com', 'Borrower', 'ADD040'),
(100041, 'Bianca', 'Gomez', 'O', '2000-01-20', 'Female', 'bianca.gomez@gmail.com', 'Borrower', 'ADD041'),
(100042, 'Paul', 'Ramos', 'P', '2002-10-08', 'Male', 'paul.ramos@gmail.com', 'Borrower', 'ADD042'),
(100043, 'Kate', 'Mendoza', 'H', '2003-06-26', 'Female', 'kate.mendoza@gmail.com', 'Borrower', 'ADD043'),
(100044, 'Jericho', 'Reyes', 'T', '2001-07-03', 'Male', 'jericho.reyes@gmail.com', 'Borrower', 'ADD044'),
(100045, 'Mae', 'Santos', 'R', '2000-11-18', 'Female', 'mae.santos@gmail.com', 'Borrower', 'ADD045'),
(100046, 'Joseph', 'Cruz', 'E', '1999-03-12', 'Male', 'joseph.cruz@gmail.com', 'Borrower', 'ADD046'),
(100047, 'Christine', 'Flores', 'E', '2002-05-29', 'Female', 'christine.flores@gmail.com', 'Borrower', 'ADD047'),
(100048, 'Leo', 'Torres', 'W', '2001-09-01', 'Male', 'leo.torres@gmail.com', 'Borrower', 'ADD048'),
(100049, 'Samantha', 'Garcia', 'A', '2003-04-22', 'Female', 'samantha.garcia@gmail.com', 'Borrower', 'ADD049'),
(100050, 'Marco', 'Lopez', 'B', '2000-08-16', 'Male', 'marco.lopez@gmail.com', 'Borrower', 'ADD050'),
(100051, 'Camille', 'Perez', 'N', '2001-02-05', 'Female', 'camille.perez@gmail.com', 'Borrower', 'ADD051'),
(100052, 'Ivan', 'Aquino', 'M', '2002-12-13', 'Male', 'ivan.aquino@gmail.com', 'Borrower', 'ADD052'),
(100053, 'Lovely', 'Bautista', 'M', '1999-06-27', 'Female', 'lovely.bautista@gmail.com', 'Borrower', 'ADD053'),
(100054, 'Renzo', 'Rivera', 'M', '2003-01-31', 'Male', 'renzo.rivera@gmail.com', 'Borrower', 'ADD054'),
(100055, 'Carl', 'Vargaz', 'B', '2004-02-21', 'Male', 'carl.vargaz@gmail.com', 'Borrower', 'ADD055'),
(100056, 'Mary', 'Rivero', 'B', '2005-03-23', 'Female', 'mary.rivero@gmail.com', 'Borrower', 'ADD056'),
(100057, 'Olivia', 'Orosco', 'A', '2000-01-31', 'Female', 'olivia.orosco@gmail.com', 'Borrower', 'ADD057'),
(100058, 'Linda', 'Gomez', 'A', '2003-12-30', 'Female', 'linda.gomez@gmail.com', 'Borrower', 'ADD058'),
(100059, 'Karen', 'Dayto', 'S', '2002-05-17', 'Female', 'karen.dayto@gmail.com', 'Borrower', 'ADD059'),
(100060, 'Isabella', 'Jacob', 'S', '2004-09-27', 'Female', 'isabella.jacob@gmail.com', 'Borrower', 'ADD060'),
(100061, 'Harper', 'Espatinez', 'O', '2008-04-12', 'Female', 'harper.espatinez@gmail.com', 'Borrower', 'ADD061');

-- --------------------------------------------------------

--
-- Table structure for table `user location`
--

CREATE TABLE `user location` (
  `add_id` varchar(10) NOT NULL,
  `user_brgy` varchar(100) NOT NULL,
  `user_municipality` varchar(100) NOT NULL,
  `user_province` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user location`
--

INSERT INTO `user location` (`add_id`, `user_brgy`, `user_municipality`, `user_province`) VALUES
('ADD001', 'Bagumbayan', 'Daraga', 'Albay'),
('ADD002', 'Gogon', 'Legazpi City', 'Albay'),
('ADD003', 'Bonot', 'Legazpi City', 'Albay'),
('ADD004', 'Bonga', 'Bacacay', 'Albay'),
('ADD005', 'Busay', 'Daraga', 'Albay'),
('ADD006', 'San Roque', 'Tabaco City', 'Albay'),
('ADD007', 'Rawis', 'Legazpi City', 'Albay'),
('ADD008', 'Sto. Domingo', 'Tiwi', 'Albay'),
('ADD009', 'Bariw', 'Legazpi City', 'Albay'),
('ADD010', 'Basud', 'Guinobatan', 'Albay'),
('ADD011', 'Maonon', 'Polangui', 'Albay'),
('ADD012', 'Balinad', 'Ligao City', 'Albay'),
('ADD013', 'Calzada', 'Oas', 'Albay'),
('ADD014', 'Salvacion', 'Libon', 'Albay'),
('ADD015', 'Pawa', 'Legazpi City', 'Albay'),
('ADD016', 'Cabangan', 'Camalig', 'Albay'),
('ADD017', 'Sua', 'Manito', 'Albay'),
('ADD018', 'San Ramon', 'Tabaco City', 'Albay'),
('ADD019', 'Taysan', 'Legazpi City', 'Albay'),
('ADD020', 'Tagas', 'Daraga', 'Albay'),
('ADD021', 'San Isidro', 'Sto. Domingo', 'Albay'),
('ADD022', 'Quitago', 'Guinobatan', 'Albay'),
('ADD023', 'Calbayog', 'Malilipot', 'Albay'),
('ADD024', 'Paulog', 'Ligao City', 'Albay'),
('ADD025', 'Cabid-an', 'Sorsogon City', 'Sorsogon'),
('ADD026', 'Bibincahan', 'Sorsogon City', 'Sorsogon'),
('ADD027', 'Burabod', 'Castilla', 'Sorsogon'),
('ADD028', 'Tugos', 'Pilar', 'Sorsogon'),
('ADD029', 'San Rafael', 'Bulan', 'Sorsogon'),
('ADD030', 'San Juan Daan', 'Matnog', 'Sorsogon'),
('ADD031', 'Gubat Heights', 'Gubat', 'Sorsogon'),
('ADD032', 'Dolos', 'Bulusan', 'Sorsogon'),
('ADD033', 'Patag', 'Irosin', 'Sorsogon'),
('ADD034', 'Talisay', 'Sta. Magdalena', 'Sorsogon'),
('ADD035', 'Macawayan', 'Prieto Diaz', 'Sorsogon'),
('ADD036', 'Salvacion', 'Bacon District', 'Sorsogon'),
('ADD037', 'Lapinig', 'Barcelona', 'Sorsogon'),
('ADD038', 'San Roque', 'Juban', 'Sorsogon'),
('ADD039', 'Calomagon', 'Bulan', 'Sorsogon'),
('ADD040', 'Carriedo', 'Irosin', 'Sorsogon'),
('ADD041', 'Inlagadian', 'Casiguran', 'Sorsogon'),
('ADD042', 'San Vicente', 'Castilla', 'Sorsogon'),
('ADD043', 'Rizal', 'Pilar', 'Sorsogon'),
('ADD044', 'Buraburan', 'Donsol', 'Sorsogon'),
('ADD045', 'Mabini', 'Gubat', 'Sorsogon'),
('ADD046', 'Cogon', 'Bulusan', 'Sorsogon'),
('ADD047', 'Bolos', 'Irosin', 'Sorsogon'),
('ADD048', 'Salvacion', 'Matnog', 'Sorsogon'),
('ADD049', 'San Ramon', 'Barcelona', 'Sorsogon'),
('ADD050', 'Bibincahan', 'Sorsogon City', 'Sorsogon'),
('ADD051', 'Buyo', 'Castilla', 'Sorsogon'),
('ADD052', 'Bantayan', 'Juban', 'Sorsogon'),
('ADD053', 'Buenavista', 'Pilar', 'Sorsogon'),
('ADD054', 'Zone 1', 'Bulan', 'Sorsogon'),
('ADD055', 'Oma-Oma', 'Donsol', 'Sorsogon'),
('ADD056', 'San Roque', 'Gubat', 'Sorsogon'),
('ADD057', 'Monbon', 'Irosin', 'Sorsogon'),
('ADD058', 'Lalud', 'Casiguran', 'Sorsogon'),
('ADD059', 'San Isidro', 'Sta. Magdalena', 'Sorsogon'),
('ADD060', 'Cabarbuhan', 'Bacon District', 'Sorsogon'),
('ADD061', 'Bagacay', 'Prieto Diaz', 'Sorsogon');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `academic`
--
ALTER TABLE `academic`
  ADD PRIMARY KEY (`academic_id`),
  ADD KEY `accession_id` (`accession_id`);

--
-- Indexes for table `author`
--
ALTER TABLE `author`
  ADD PRIMARY KEY (`author_id`),
  ADD UNIQUE KEY `author_num` (`author_num`);

--
-- Indexes for table `book format`
--
ALTER TABLE `book format`
  ADD PRIMARY KEY (`format_id`);

--
-- Indexes for table `books`
--
ALTER TABLE `books`
  ADD PRIMARY KEY (`accession_id`),
  ADD UNIQUE KEY `ISBN` (`ISBN`),
  ADD KEY `id_status` (`id_status`),
  ADD KEY `books_ibfk_2` (`pub_id`);

--
-- Indexes for table `borrower`
--
ALTER TABLE `borrower`
  ADD PRIMARY KEY (`borrower_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `borrowing period`
--
ALTER TABLE `borrowing period`
  ADD PRIMARY KEY (`borrowingperiod_id`);

--
-- Indexes for table `borrow reference`
--
ALTER TABLE `borrow reference`
  ADD KEY `borrow_id` (`borrow_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `fk_publication` (`pub_id`);

--
-- Indexes for table `borrows`
--
ALTER TABLE `borrows`
  ADD PRIMARY KEY (`borrow_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `fk_borrowing_period` (`borrowingperiod_id`),
  ADD KEY `fk_accession_id` (`accession_id`);

--
-- Indexes for table `comic`
--
ALTER TABLE `comic`
  ADD PRIMARY KEY (`comic_id`),
  ADD KEY `fiction_id` (`fiction_id`);

--
-- Indexes for table `fiction`
--
ALTER TABLE `fiction`
  ADD PRIMARY KEY (`fiction_id`),
  ADD KEY `nonacademic_id` (`nonacademic_id`);

--
-- Indexes for table `fines`
--
ALTER TABLE `fines`
  ADD PRIMARY KEY (`fine_id`),
  ADD KEY `libclerk_id` (`libclerk_id`),
  ADD KEY `borrow_id` (`borrow_id`),
  ADD KEY `pub_id` (`pub_id`);

--
-- Indexes for table `genre`
--
ALTER TABLE `genre`
  ADD PRIMARY KEY (`genre_id`);

--
-- Indexes for table `history`
--
ALTER TABLE `history`
  ADD PRIMARY KEY (`history_id`),
  ADD KEY `academic_id` (`academic_id`);

--
-- Indexes for table `it staff`
--
ALTER TABLE `it staff`
  ADD PRIMARY KEY (`itstaff_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `kids books`
--
ALTER TABLE `kids books`
  ADD PRIMARY KEY (`kidsbook_id`),
  ADD KEY `fiction_id` (`fiction_id`),
  ADD KEY `format_id` (`format_id`);

--
-- Indexes for table `librarian`
--
ALTER TABLE `librarian`
  ADD PRIMARY KEY (`librarian_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `library clerk`
--
ALTER TABLE `library clerk`
  ADD PRIMARY KEY (`libclerk_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `magazines`
--
ALTER TABLE `magazines`
  ADD PRIMARY KEY (`magazine_id`),
  ADD KEY `ISSN` (`ISSN`);

--
-- Indexes for table `mathematics`
--
ALTER TABLE `mathematics`
  ADD PRIMARY KEY (`math_id`),
  ADD KEY `academic_id` (`academic_id`);

--
-- Indexes for table `newspapers`
--
ALTER TABLE `newspapers`
  ADD PRIMARY KEY (`newspaper_id`),
  ADD KEY `ISSN` (`ISSN`);

--
-- Indexes for table `non academic`
--
ALTER TABLE `non academic`
  ADD PRIMARY KEY (`nonacademic_id`),
  ADD KEY `accession_id` (`accession_id`),
  ADD KEY `fk_genre_id` (`genre_id`);

--
-- Indexes for table `non fiction`
--
ALTER TABLE `non fiction`
  ADD PRIMARY KEY (`nonfiction_id`),
  ADD KEY `nonacademic_id` (`nonacademic_id`);

--
-- Indexes for table `periodicals`
--
ALTER TABLE `periodicals`
  ADD PRIMARY KEY (`ISSN`),
  ADD KEY `pub_id` (`pub_id`);

--
-- Indexes for table `pub author`
--
ALTER TABLE `pub author`
  ADD KEY `pub_id` (`pub_id`),
  ADD KEY `author_id` (`author_id`);

--
-- Indexes for table `pub copies`
--
ALTER TABLE `pub copies`
  ADD PRIMARY KEY (`copy_id`),
  ADD KEY `pub_id` (`pub_id`);

--
-- Indexes for table `publication`
--
ALTER TABLE `publication`
  ADD PRIMARY KEY (`pub_id`),
  ADD KEY `fk_publisher` (`publisher_id`);

--
-- Indexes for table `publisher`
--
ALTER TABLE `publisher`
  ADD PRIMARY KEY (`publisher_id`);

--
-- Indexes for table `recipe book`
--
ALTER TABLE `recipe book`
  ADD PRIMARY KEY (`recipebook_id`),
  ADD KEY `nonfiction_id` (`nonfiction_id`);

--
-- Indexes for table `reference books`
--
ALTER TABLE `reference books`
  ADD PRIMARY KEY (`reference_id`),
  ADD KEY `academic_id` (`academic_id`);

--
-- Indexes for table `reports`
--
ALTER TABLE `reports`
  ADD PRIMARY KEY (`report_id`),
  ADD KEY `libclerk_id` (`libclerk_id`);

--
-- Indexes for table `research`
--
ALTER TABLE `research`
  ADD PRIMARY KEY (`research_id`),
  ADD KEY `academic_id` (`academic_id`);

--
-- Indexes for table `science`
--
ALTER TABLE `science`
  ADD PRIMARY KEY (`science_id`),
  ADD KEY `academic_id` (`academic_id`);

--
-- Indexes for table `self help`
--
ALTER TABLE `self help`
  ADD PRIMARY KEY (`selfhelp_id`),
  ADD KEY `nonfiction_id` (`nonfiction_id`);

--
-- Indexes for table `status`
--
ALTER TABLE `status`
  ADD PRIMARY KEY (`id_status`),
  ADD KEY `libclerk_id` (`libclerk_id`);

--
-- Indexes for table `tabloids`
--
ALTER TABLE `tabloids`
  ADD PRIMARY KEY (`tabloid_id`),
  ADD KEY `ISSN` (`ISSN`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`user_id`),
  ADD KEY `fk_user_location` (`add_id`);

--
-- Indexes for table `user location`
--
ALTER TABLE `user location`
  ADD PRIMARY KEY (`add_id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `academic`
--
ALTER TABLE `academic`
  ADD CONSTRAINT `academic_ibfk_1` FOREIGN KEY (`accession_id`) REFERENCES `books` (`accession_id`);

--
-- Constraints for table `books`
--
ALTER TABLE `books`
  ADD CONSTRAINT `books_ibfk_1` FOREIGN KEY (`id_status`) REFERENCES `status` (`id_status`),
  ADD CONSTRAINT `books_ibfk_2` FOREIGN KEY (`pub_id`) REFERENCES `publication` (`pub_id`);

--
-- Constraints for table `borrower`
--
ALTER TABLE `borrower`
  ADD CONSTRAINT `borrower_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

--
-- Constraints for table `borrow reference`
--
ALTER TABLE `borrow reference`
  ADD CONSTRAINT `borrow reference_ibfk_1` FOREIGN KEY (`borrow_id`) REFERENCES `borrows` (`borrow_id`),
  ADD CONSTRAINT `borrow reference_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
  ADD CONSTRAINT `fk_publication` FOREIGN KEY (`pub_id`) REFERENCES `publication` (`pub_id`);

--
-- Constraints for table `borrows`
--
ALTER TABLE `borrows`
  ADD CONSTRAINT `borrows_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
  ADD CONSTRAINT `fk_accession_id` FOREIGN KEY (`accession_id`) REFERENCES `books` (`accession_id`),
  ADD CONSTRAINT `fk_borrowing_period` FOREIGN KEY (`borrowingperiod_id`) REFERENCES `borrowing period` (`borrowingperiod_id`);

--
-- Constraints for table `comic`
--
ALTER TABLE `comic`
  ADD CONSTRAINT `comic_ibfk_1` FOREIGN KEY (`fiction_id`) REFERENCES `fiction` (`fiction_id`);

--
-- Constraints for table `fiction`
--
ALTER TABLE `fiction`
  ADD CONSTRAINT `fiction_ibfk_1` FOREIGN KEY (`nonacademic_id`) REFERENCES `non academic` (`nonacademic_id`);

--
-- Constraints for table `fines`
--
ALTER TABLE `fines`
  ADD CONSTRAINT `fines_ibfk_1` FOREIGN KEY (`libclerk_id`) REFERENCES `library clerk` (`libclerk_id`),
  ADD CONSTRAINT `fines_ibfk_2` FOREIGN KEY (`borrow_id`) REFERENCES `borrows` (`borrow_id`),
  ADD CONSTRAINT `fines_ibfk_3` FOREIGN KEY (`pub_id`) REFERENCES `publication` (`pub_id`);

--
-- Constraints for table `history`
--
ALTER TABLE `history`
  ADD CONSTRAINT `history_ibfk_1` FOREIGN KEY (`academic_id`) REFERENCES `academic` (`academic_id`);

--
-- Constraints for table `it staff`
--
ALTER TABLE `it staff`
  ADD CONSTRAINT `it staff_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

--
-- Constraints for table `kids books`
--
ALTER TABLE `kids books`
  ADD CONSTRAINT `kids books_ibfk_1` FOREIGN KEY (`fiction_id`) REFERENCES `fiction` (`fiction_id`),
  ADD CONSTRAINT `kids books_ibfk_2` FOREIGN KEY (`format_id`) REFERENCES `book format` (`format_id`);

--
-- Constraints for table `librarian`
--
ALTER TABLE `librarian`
  ADD CONSTRAINT `librarian_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

--
-- Constraints for table `library clerk`
--
ALTER TABLE `library clerk`
  ADD CONSTRAINT `library clerk_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

--
-- Constraints for table `magazines`
--
ALTER TABLE `magazines`
  ADD CONSTRAINT `magazines_ibfk_1` FOREIGN KEY (`ISSN`) REFERENCES `periodicals` (`ISSN`);

--
-- Constraints for table `mathematics`
--
ALTER TABLE `mathematics`
  ADD CONSTRAINT `mathematics_ibfk_1` FOREIGN KEY (`academic_id`) REFERENCES `academic` (`academic_id`);

--
-- Constraints for table `newspapers`
--
ALTER TABLE `newspapers`
  ADD CONSTRAINT `newspapers_ibfk_1` FOREIGN KEY (`ISSN`) REFERENCES `periodicals` (`ISSN`);

--
-- Constraints for table `non academic`
--
ALTER TABLE `non academic`
  ADD CONSTRAINT `fk_genre_id` FOREIGN KEY (`genre_id`) REFERENCES `genre` (`genre_id`),
  ADD CONSTRAINT `non academic_ibfk_1` FOREIGN KEY (`accession_id`) REFERENCES `books` (`accession_id`);

--
-- Constraints for table `non fiction`
--
ALTER TABLE `non fiction`
  ADD CONSTRAINT `non fiction_ibfk_1` FOREIGN KEY (`nonacademic_id`) REFERENCES `non academic` (`nonacademic_id`);

--
-- Constraints for table `periodicals`
--
ALTER TABLE `periodicals`
  ADD CONSTRAINT `periodicals_ibfk_1` FOREIGN KEY (`pub_id`) REFERENCES `publication` (`pub_id`);

--
-- Constraints for table `pub author`
--
ALTER TABLE `pub author`
  ADD CONSTRAINT `pub author_ibfk_1` FOREIGN KEY (`pub_id`) REFERENCES `publication` (`pub_id`),
  ADD CONSTRAINT `pub author_ibfk_2` FOREIGN KEY (`author_id`) REFERENCES `author` (`author_id`);

--
-- Constraints for table `pub copies`
--
ALTER TABLE `pub copies`
  ADD CONSTRAINT `pub copies_ibfk_1` FOREIGN KEY (`pub_id`) REFERENCES `publication` (`pub_id`);

--
-- Constraints for table `publication`
--
ALTER TABLE `publication`
  ADD CONSTRAINT `fk_publisher` FOREIGN KEY (`publisher_id`) REFERENCES `publisher` (`publisher_id`);

--
-- Constraints for table `recipe book`
--
ALTER TABLE `recipe book`
  ADD CONSTRAINT `recipe book_ibfk_1` FOREIGN KEY (`nonfiction_id`) REFERENCES `non fiction` (`nonfiction_id`);

--
-- Constraints for table `reference books`
--
ALTER TABLE `reference books`
  ADD CONSTRAINT `reference books_ibfk_1` FOREIGN KEY (`academic_id`) REFERENCES `academic` (`academic_id`);

--
-- Constraints for table `reports`
--
ALTER TABLE `reports`
  ADD CONSTRAINT `reports_ibfk_1` FOREIGN KEY (`libclerk_id`) REFERENCES `library clerk` (`libclerk_id`);

--
-- Constraints for table `research`
--
ALTER TABLE `research`
  ADD CONSTRAINT `research_ibfk_1` FOREIGN KEY (`academic_id`) REFERENCES `academic` (`academic_id`);

--
-- Constraints for table `science`
--
ALTER TABLE `science`
  ADD CONSTRAINT `science_ibfk_1` FOREIGN KEY (`academic_id`) REFERENCES `academic` (`academic_id`);

--
-- Constraints for table `self help`
--
ALTER TABLE `self help`
  ADD CONSTRAINT `self help_ibfk_1` FOREIGN KEY (`nonfiction_id`) REFERENCES `non fiction` (`nonfiction_id`);

--
-- Constraints for table `status`
--
ALTER TABLE `status`
  ADD CONSTRAINT `status_ibfk_1` FOREIGN KEY (`libclerk_id`) REFERENCES `library clerk` (`libclerk_id`);

--
-- Constraints for table `tabloids`
--
ALTER TABLE `tabloids`
  ADD CONSTRAINT `tabloids_ibfk_1` FOREIGN KEY (`ISSN`) REFERENCES `periodicals` (`ISSN`);

--
-- Constraints for table `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `fk_user_location` FOREIGN KEY (`add_id`) REFERENCES `user location` (`add_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

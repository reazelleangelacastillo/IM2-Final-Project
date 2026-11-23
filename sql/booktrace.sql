-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 15, 2026 at 10:53 AM
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
-- Database: `booktrace`
--

-- --------------------------------------------------------

--
-- Table structure for table `author`
--

CREATE TABLE `author` (
  `author_id` varchar(20) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `middle_initial` char(1) DEFAULT NULL,
  `author_num` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `author`
--

INSERT INTO `author` (`author_id`, `first_name`, `last_name`, `middle_initial`, `author_num`) VALUES
('AUTH001', 'Maria', 'Santos', 'S', '1'),
('AUTH002', 'John', 'Cruz', 'C', '2'),
('AUTH003', 'Carla', 'Reyes', 'R', '3'),
('AUTH004', 'Mark', 'Dela Cruz', 'D', '4'),
('AUTH005', 'Angela', 'Lopez', 'L', '5'),
('AUTH006', 'Kevin', 'Ramos', 'R', '6'),
('AUTH007', 'Sophia', 'Garcia', 'G', '7'),
('AUTH008', 'Daniel', 'Flores', 'F', '8'),
('AUTH009', 'Nicole', 'Torres', 'T', '9'),
('AUTH010', 'Ethan', 'Perez', 'P', '10'),
('AUTH011', 'Joshua', 'Bautista', 'B', '11'),
('AUTH012', 'Bea', 'Navarro', 'N', '12'),
('AUTH013', 'Christian', 'Aquino', 'A', '13'),
('AUTH014', 'Faith', 'Castillo', 'C', '14'),
('AUTH015', 'Vincent', 'Rivera', 'R', '15'),
('AUTH016', 'Chloe', 'Morales', 'M', '16'),
('AUTH017', 'Ryan', 'Herrera', 'H', '17'),
('AUTH018', 'Alyssa', 'Gomez', 'G', '18'),
('AUTH019', 'Carl', 'Diaz', 'D', '19'),
('AUTH020', 'Jasmine', 'Ramos', 'R', '20'),
('AUTH021', 'Patrick', 'Mendoza', 'M', '21'),
('AUTH022', 'Hannah', 'Reyes', 'R', '22'),
('AUTH023', 'Sean', 'Santos', 'S', '23'),
('AUTH024', 'Angel', 'Cruz', 'C', '24'),
('AUTH025', 'Gabriel', 'Flores', 'F', '25'),
('AUTH026', 'Kim', 'Torres', 'T', '26'),
('AUTH027', 'Nathan', 'Garcia', 'G', '27'),
('AUTH028', 'Ella', 'Lopez', 'L', '28'),
('AUTH029', 'Adrian', 'Perez', 'P', '29'),
('AUTH030', 'Trisha', 'Aquino', 'A', '30'),
('AUTH031', 'Kyle', 'Bautista', 'B', '31'),
('AUTH032', 'Denise', 'Rivera', 'R', '32'),
('AUTH033', 'Matthew', 'Navarro', 'N', '33'),
('AUTH034', 'Princess', 'Castillo', 'C', '34'),
('AUTH035', 'Jacob', 'Diaz', 'D', '35'),
('AUTH036', 'Rica', 'Morales', 'M', '36'),
('AUTH037', 'Aaron', 'Herrera', 'H', '37'),
('AUTH038', 'Bianca', 'Gomez', 'G', '38'),
('AUTH039', 'Paul', 'Ramos', 'R', '39'),
('AUTH040', 'Kate', 'Mendoza', 'M', '40'),
('AUTH041', 'Jericho', 'Reyes', 'R', '41'),
('AUTH042', 'Mae', 'Santos', 'S', '42'),
('AUTH043', 'Joseph', 'Cruz', 'C', '43'),
('AUTH044', 'Christine', 'Flores', 'F', '44'),
('AUTH045', 'Leo', 'Torres', 'T', '45'),
('AUTH046', 'Samantha', 'Garcia', 'G', '46'),
('AUTH047', 'Marco', 'Lopez', 'L', '47'),
('AUTH048', 'Camille', 'Perez', 'P', '48'),
('AUTH049', 'Ivan', 'Aquino', 'A', '49'),
('AUTH050', 'Lovely', 'Bautista', 'B', '50'),
('AUTH051', 'Michael', 'Belmonte', 'B', '51'),
('AUTH052', 'Hannah', 'Basco', 'B', '52'),
('AUTH053', 'Rafael', 'Nery', 'N', '53'),
('AUTH054', 'Daniel', 'Ang', 'A', '54'),
('AUTH055', 'William', 'Fernandez', 'F', '55'),
('AUTH056', 'Wesley', 'Reyes', 'R', '56'),
('AUTH057', 'Robert', 'Lomsoc', 'L', '57'),
('AUTH058', 'Andrew', 'Cabacungan', 'C', '58'),
('AUTH059', 'Quentin', 'Enopia', 'E', '59'),
('AUTH060', 'Joshua', 'Macasaet', 'M', '60'),
('AUTH061', 'Kenneth', 'Tieng', 'T', '61'),
('AUTH062', 'Liam', 'Miller', 'M', '62'),
('AUTH063', 'Choi', 'Min', 'M', '63'),
('AUTH064', 'Ian', 'Cruz', 'C', '64'),
('AUTH065', 'Miguel', 'Lopa', 'L', '65'),
('AUTH066', 'Francis', 'Co', 'C', '66'),
('AUTH067', 'Jacob', 'Ng', 'N', '67'),
('AUTH068', 'Lauren', 'Katigbak', 'K', '68'),
('AUTH069', 'Tristan', 'Salterio', 'S', '69'),
('AUTH070', 'Ethan', 'Paredes', 'P', '70'),
('AUTH071', 'Rafael', 'Diego', 'D', '71'),
('AUTH072', 'Dominic', 'Sison', 'S', '72'),
('AUTH073', 'Julius', 'Quirino', 'Q', '73'),
('AUTH074', 'Gabriel', 'Castillo', 'C', '74'),
('AUTH075', 'Adrian', 'Dizon', 'D', '75'),
('AUTH076', 'Vincent', 'Ramirez', 'R', '76'),
('AUTH077', 'Sophia', 'Cruz', 'C', '77'),
('AUTH078', 'Brian', 'Guzman', 'G', '78'),
('AUTH079', 'Charles', 'Valderama', 'V', '79'),
('AUTH080', 'James', 'Santos', 'S', '80'),
('AUTH081', 'Alexander', 'Villanueva', 'M', '81'),
('AUTH082', 'Patricia', 'Fernandez', 'L', '82'),
('AUTH083', 'Dominic', 'Santiago', 'R', '83'),
('AUTH084', 'Vanessa', 'Mendoza', 'C', '84'),
('AUTH085', 'Elijah', 'Ramos', 'P', '85'),
('AUTH086', 'Krystal', 'Bautista', 'A', '86'),
('AUTH087', 'Nathaniel', 'Flores', 'G', '87'),
('AUTH088', 'Andrea', 'Reyes', 'T', '88'),
('AUTH089', 'Vincent', 'Navarro', 'D', '89'),
('AUTH090', 'Kimberly', 'Garcia', 'S', '90'),
('AUTH091', 'Joshua', 'Santos', 'M', '91'),
('AUTH092', 'Pauline', 'Cruz', 'R', '92'),
('AUTH093', 'Jerome', 'Castillo', 'B', '93'),
('AUTH094', 'Charlene', 'Torres', 'F', '94'),
('AUTH095', 'Matthew', 'Diaz', 'L', '95'),
('AUTH096', 'Cassandra', 'Aquino', 'N', '96'),
('AUTH097', 'Patrick', 'Lopez', 'C', '97'),
('AUTH098', 'Denise', 'Morales', 'G', '98'),
('AUTH099', 'Ethan', 'Rivera', 'V', '99'),
('AUTH100', 'Angela', 'Herrera', 'P', '100'),
('AUTH101', 'Christian', 'Gomez', 'A', '101'),
('AUTH102', 'Trisha', 'Mendoza', 'D', '102'),
('AUTH103', 'Kevin', 'Perez', 'S', '103'),
('AUTH104', 'Nicole', 'Bautista', 'M', '104'),
('AUTH105', 'Raphael', 'Reyes', 'T', '105'),
('AUTH106', 'Bianca', 'Flores', 'C', '106'),
('AUTH107', 'Joshua', 'Santos', 'R', '107'),
('AUTH108', 'Samantha', 'Cruz', 'L', '108'),
('AUTH109', 'Adrian', 'Navarro', 'B', '109'),
('AUTH110', 'Faith', 'Garcia', 'G', '110'),
('AUTH111', 'Daniel', 'Torres', 'P', '111'),
('AUTH112', 'Princess', 'Aquino', 'A', '112'),
('AUTH113', 'Sean', 'Diaz', 'D', '113'),
('AUTH114', 'Camille', 'Lopez', 'F', '114'),
('AUTH115', 'Marco', 'Rivera', 'N', '115'),
('AUTH116', 'Alyssa', 'Morales', 'M', '116'),
('AUTH117', 'Gabriel', 'Herrera', 'S', '117'),
('AUTH118', 'Hannah', 'Gomez', 'T', '118'),
('AUTH119', 'Jacob', 'Ramos', 'C', '119'),
('AUTH120', 'Sophia', 'Mendoza', 'V', '120'),
('AUTH121', 'Ivan', 'Perez', 'L', '121'),
('AUTH122', 'Bea', 'Castillo', 'R', '122'),
('AUTH123', 'Carl', 'Santos', 'P', '123'),
('AUTH124', 'Rica', 'Reyes', 'A', '124'),
('AUTH125', 'Aaron', 'Flores', 'G', '125'),
('AUTH126', 'Lovely', 'Cruz', 'D', '126'),
('AUTH127', 'Jericho', 'Bautista', 'N', '127'),
('AUTH128', 'Chloe', 'Navarro', 'M', '128'),
('AUTH129', 'Nathan', 'Garcia', 'S', '129'),
('AUTH130', 'Ella', 'Torres', 'T', '130');

-- --------------------------------------------------------

--
-- Table structure for table `books`
--

CREATE TABLE `books` (
  `pub_id` varchar(30) NOT NULL,
  `class_no` varchar(50) NOT NULL,
  `call_no` varchar(50) NOT NULL,
  `ISBN` varchar(25) NOT NULL,
  `category` varchar(50) NOT NULL CHECK (`category` in ('Academic','Non-Academic')),
  `audience_type` varchar(50) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `acquired_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `books`
--

INSERT INTO `books` (`pub_id`, `class_no`, `call_no`, `ISBN`, `category`, `audience_type`) VALUES
('PUB001', '512', '512.S23', '978-621-13-9357-5', 'Academic', NULL),
('PUB002', '515', '515.C78', '978-621-42-4926-8', 'Academic', NULL),
('PUB003', '516', '516.R49', '978-621-06-3560-7', 'Academic', NULL),
('PUB004', '519.5', '519.D45', '978-971-61-0332-8', 'Academic', NULL),
('PUB005', '516.245', '516.L86', '978-123-59-1678-6', 'Academic', NULL),
('PUB006', '570', '570.R18', '978-621-64-4509-5', 'Academic', NULL),
('PUB007', '540', '540.G34', '978-123-51-1550-9', 'Academic', NULL),
('PUB008', '530', '530.F56', '978-123-60-6533-9', 'Academic', NULL),
('PUB009', '550', '550.T89', '978-621-12-7217-7', 'Academic', NULL),
('PUB010', '363.7', '363.P45', '978-123-80-8526-7', 'Academic', NULL),
('PUB011', '959.9', '959.B22', '978-971-79-2932-3', 'Academic', NULL),
('PUB012', '909', '909.N14', '978-123-31-3494-6', 'Academic', NULL),
('PUB013', '950', '950.A45', '978-123-71-3963-3', 'Academic', NULL),
('PUB014', '920', '920.C38', '978-621-07-8135-9', 'Academic', NULL),
('PUB015', '930', '930.R57', '978-621-61-3389-3', 'Academic', NULL),
('PUB016', '1.4001', '1.M12', '978-971-20-8992-3', 'Academic', NULL),
('PUB017', '1.4001', '1.H34', '978-123-10-7220-2', 'Academic', NULL),
('PUB018', '1.4001', '1.G56', '978-621-71-6508-4', 'Academic', NULL),
('PUB019', '1.42001', '1.D78', '978-621-14-0620-6', 'Academic', NULL),
('PUB020', '1.43001', '1.R90', '978-123-26-8602-6', 'Academic', NULL),
('PUB021', '423', '423.M22', '978-621-14-9759-4', 'Academic', NULL),
('PUB022', '503', '503.R14', '978-971-58-0043-3', 'Academic', NULL),
('PUB023', '912', '912.S35', '978-123-58-1721-2', 'Academic', NULL),
('PUB024', '400', '4.C18', '978-971-45-4117-7', 'Academic', NULL),
('PUB025', '610', '610.F56', '978-971-00-5412-1', 'Academic', NULL),
('PUB026', '158.1', '158.T45', '978-123-90-4244-3', 'Non-Academic', NULL),
('PUB027', '158.1', '158.G12', '978-621-37-6931-6', 'Non-Academic', NULL),
('PUB028', '155.2', '155.L89', '978-971-90-5716-1', 'Non-Academic', NULL),
('PUB029', '158.1', '158.P34', '978-971-67-1886-7', 'Non-Academic', NULL),
('PUB030', '650.1', '650.A67', '978-621-56-1429-4', 'Non-Academic', NULL),
('PUB031', '641.59', '641.B31', '978-971-34-3190-5', 'Non-Academic', NULL),
('PUB032', '641.81', '641.R32', '978-123-90-5309-8', 'Non-Academic', NULL),
('PUB033', '641.56', '641.N33', '978-971-75-0699-9', 'Non-Academic', NULL),
('PUB034', '641.5956', '641.C34', '978-621-24-8785-3', 'Non-Academic', NULL),
('PUB035', '641.86', '641.D35', '978-971-00-7722-9', 'Non-Academic', NULL),
('PUB036', '741.5', '741.M12', '978-971-10-1017-1', 'Non-Academic', NULL),
('PUB037', '741.5', '741.H34', '978-123-80-8662-2', 'Non-Academic', NULL),
('PUB038', '741.5', '741.G56', '978-123-26-6278-5', 'Non-Academic', NULL),
('PUB039', '741.5', '741.R78', '978-123-91-3425-4', 'Non-Academic', NULL),
('PUB040', '741.5', '741.M90', '978-123-68-9576-9', 'Non-Academic', NULL),
('PUB041', '398.2', '398.R49', '978-123-51-1778-7', 'Non-Academic', NULL),
('PUB042', '372.4', '372.S23', '978-123-56-4844-1', 'Non-Academic', NULL),
('PUB043', '372.7', '372.C78', '978-971-96-5466-7', 'Non-Academic', NULL),
('PUB044', '808.8', '808.F56', '978-971-52-4435-0', 'Non-Academic', NULL),
('PUB045', '590', '590.T89', '978-971-70-0401-3', 'Non-Academic', NULL),
('PUB046', '512.5', '512.G12', '978-621-31-4964-4', 'Academic', NULL),
('PUB047', '547', '547.L67', '978-123-33-2739-3', 'Academic', NULL),
('PUB048', '950', '950.P34', '978-123-29-5572-6', 'Academic', NULL),
('PUB049', '1.4001', '1.A56', '978-123-56-3004-0', 'Academic', NULL),
('PUB050', '158.1', '158.B22', '978-971-06-2103-3', 'Non-Academic', NULL),
('PUB051', '512', '158.B23', '978-621-50-0397-5', 'Academic', NULL),
('PUB052', '519.5', '158.B24', '978-971-40-2045-0', 'Academic', NULL),
('PUB053', '519.2', '158.B25', '978-621-80-4760-0', 'Academic', NULL),
('PUB054', '515.35', '158.B26', '978-971-86-9322-3', 'Academic', NULL),
('PUB055', '511.3', '158.B27', '978-971-07-2170-2', 'Academic', NULL),
('PUB056', '611', '158.B28', '978-621-12-8081-3', 'Academic', NULL),
('PUB057', '576.5', '158.B29', '978-621-94-5376-9', 'Academic', NULL),
('PUB058', '520', '158.B30', '978-123-21-5171-5', 'Academic', NULL),
('PUB059', '578.77', '158.B31', '978-971-23-6423-5', 'Academic', NULL),
('PUB060', '577', '158.B32', '978-621-40-0505-5', 'Academic', NULL),
('PUB061', '959.9', '158.B33', '978-621-84-2637-5', 'Academic', NULL),
('PUB062', '950', '158.B34', '978-123-01-9708-1', 'Academic', NULL),
('PUB063', '940', '158.B35', '978-621-45-8578-6', 'Academic', NULL),
('PUB064', '909.82', '158.B36', '978-123-93-9627-0', 'Academic', NULL),
('PUB065', '306', '158.B37', '978-123-28-4008-4', 'Academic', NULL),
('PUB066', '1.42', '158.B38', '978-971-63-3824-9', 'Academic', NULL),
('PUB067', '1.43', '158.B39', '978-123-93-4820-0', 'Academic', NULL),
('PUB068', '519.5', '158.B40', '978-621-09-2760-3', 'Academic', NULL),
('PUB069', '808.06', '158.B41', '978-621-78-4471-2', 'Academic', NULL),
('PUB070', '808.02', '158.B42', '978-621-55-2985-7', 'Academic', NULL),
('PUB071', '500', 'REF-SCI-071', '978-123-10-6402-3', 'Academic', NULL),
('PUB072', '912', 'REF-ATL-072', '978-123-35-4668-8', 'Academic', NULL),
('PUB073', '423', 'REF-DIC-073', '978-621-41-2672-9', 'Academic', NULL),
('PUB074', '4', 'REF-ITR-074', '978-621-08-1054-7', 'Academic', NULL),
('PUB075', '158.1', 'SH-075', '978-621-78-4253-4', 'Non-Academic', NULL),
('PUB076', '332.024', 'SH-076', '978-971-87-7217-1', 'Non-Academic', NULL),
('PUB077', '155.2', 'SH-077', '978-621-45-3515-6', 'Non-Academic', NULL),
('PUB078', '158.1', 'SH-078', '978-123-18-9257-2', 'Non-Academic', NULL),
('PUB079', '658.4', 'SH-079', '978-971-13-1770-6', 'Non-Academic', NULL),
('PUB080', '641.86', 'CK-080', '978-621-82-3773-5', 'Non-Academic', NULL),
('PUB081', '641.56', '641.B81', '978-971-89-5375-4', 'Non-Academic', NULL),
('PUB082', '641.56', '641.R82', '978-621-55-2385-5', 'Non-Academic', NULL),
('PUB083', '641.86', '641.N83', '978-621-50-3314-9', 'Non-Academic', NULL),
('PUB084', '641.59', '641.C84', '978-971-46-3262-2', 'Non-Academic', NULL),
('PUB085', '641.56', '641.D85', '978-123-53-7301-5', 'Non-Academic', NULL),
('PUB086', '741.5', '741.M86', '978-971-04-7277-2', 'Non-Academic', NULL),
('PUB087', '741.5', '741.H87', '978-971-88-9424-8', 'Non-Academic', NULL),
('PUB088', '741.5', '741.G88', '978-971-81-3866-3', 'Non-Academic', NULL),
('PUB089', '741.5', '741.R89', '978-123-04-3071-3', 'Non-Academic', NULL),
('PUB090', '741.5', '741.M90', '978-971-75-4273-7', 'Non-Academic', NULL),
('PUB091', '372.1', '372.R91', '978-123-15-9877-1', 'Non-Academic', NULL),
('PUB092', '372.7', '372.S92', '978-123-33-1385-3', 'Non-Academic', NULL),
('PUB093', '507', '507.C93', '978-123-19-3666-5', 'Non-Academic', NULL),
('PUB094', '398.2', '398.F94', '978-123-60-6297-0', 'Non-Academic', NULL),
('PUB095', '590', '590.T95', '978-621-41-6638-1', 'Non-Academic', NULL),
('PUB096', '512', '512.G96', '978-971-24-9401-7', 'Academic', NULL),
('PUB097', '530', '530.L97', '978-123-59-0891-0', 'Academic', NULL),
('PUB098', '959.9', '959.P98', '978-971-99-0744-2', 'Academic', NULL),
('PUB099', '1.42001', '1.A99', '978-971-09-8509-8', 'Academic', NULL),
('PUB100', '158.1', '158.B10', '978-621-97-9974-4', 'Non-Academic', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `borrower`
--

CREATE TABLE `borrower` (
  `borrower_id` varchar(10) NOT NULL,
  `user_id` int(11) NOT NULL,
  `borrower_type` varchar(30) NOT NULL,
  `ID_type` varchar(100) DEFAULT NULL,
  `ID_number` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `borrower`
--

INSERT INTO `borrower` (`borrower_id`, `user_id`, `borrower_type`, `ID_type`, `ID_number`) VALUES
('BOR001', 100006, 'Internal', NULL, NULL),
('BOR002', 100005, 'Internal', NULL, NULL),
('BOR003', 100007, 'Internal', NULL, NULL),
('BOR004', 100008, 'Internal', NULL, NULL),
('BOR005', 100009, 'External', NULL, NULL),
('BOR006', 100010, 'External', NULL, NULL),
('BOR007', 100011, 'External', NULL, NULL),
('BOR008', 100012, 'External', NULL, NULL),
('BOR009', 100013, 'External', NULL, NULL),
('BOR010', 100014, 'External', NULL, NULL),
('BOR011', 100015, 'External', NULL, NULL),
('BOR012', 100016, 'External', NULL, NULL),
('BOR013', 100017, 'External', NULL, NULL),
('BOR014', 100018, 'External', NULL, NULL),
('BOR015', 100019, 'External', NULL, NULL),
('BOR016', 100020, 'External', NULL, NULL),
('BOR017', 100021, 'External', NULL, NULL),
('BOR018', 100022, 'External', NULL, NULL),
('BOR019', 100023, 'External', NULL, NULL),
('BOR020', 100024, 'External', NULL, NULL),
('BOR021', 100025, 'External', NULL, NULL),
('BOR022', 100026, 'External', NULL, NULL),
('BOR023', 100027, 'External', NULL, NULL),
('BOR024', 100028, 'External', NULL, NULL),
('BOR025', 100029, 'External', NULL, NULL),
('BOR026', 100030, 'External', NULL, NULL),
('BOR027', 100031, 'External', NULL, NULL),
('BOR028', 100032, 'External', NULL, NULL),
('BOR029', 100033, 'External', NULL, NULL),
('BOR030', 100034, 'External', NULL, NULL),
('BOR031', 100035, 'External', NULL, NULL),
('BOR032', 100036, 'External', NULL, NULL),
('BOR033', 100037, 'External', NULL, NULL),
('BOR034', 100038, 'External', NULL, NULL),
('BOR035', 100039, 'External', NULL, NULL),
('BOR036', 100040, 'External', NULL, NULL),
('BOR037', 100041, 'External', NULL, NULL),
('BOR038', 100042, 'External', NULL, NULL),
('BOR039', 100043, 'External', NULL, NULL),
('BOR040', 100044, 'External', NULL, NULL),
('BOR041', 100045, 'External', NULL, NULL),
('BOR042', 100046, 'External', NULL, NULL),
('BOR043', 100047, 'External', NULL, NULL),
('BOR044', 100048, 'External', NULL, NULL),
('BOR045', 100049, 'External', NULL, NULL),
('BOR046', 100050, 'External', NULL, NULL),
('BOR047', 100051, 'External', NULL, NULL),
('BOR048', 100052, 'External', NULL, NULL),
('BOR049', 100053, 'External', NULL, NULL),
('BOR050', 100054, 'External', NULL, NULL),
('BOR051', 100055, 'External', NULL, NULL),
('BOR052', 100056, 'External', NULL, NULL),
('BOR053', 100057, 'External', NULL, NULL),
('BOR054', 100058, 'External', NULL, NULL),
('BOR055', 100059, 'External', NULL, NULL),
('BOR056', 100060, 'External', NULL, NULL),
('BOR057', 100061, 'External', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `borrowing_policy`
--

CREATE TABLE `borrowing_policy` (
  `policy_id` varchar(20) NOT NULL,
  `max_books_allowed` int(11) NOT NULL,
  `loan_duration_days` int(11) NOT NULL,
  `fine_rate_per_hour` decimal(10,2) NOT NULL DEFAULT 2.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `borrowing_policy` (`policy_id`, `max_books_allowed`, `loan_duration_days`, `fine_rate_per_hour`) VALUES
('POL001', 3, 7, 2.00);

-- --------------------------------------------------------

--
-- Table structure for table `borrows`
--

CREATE TABLE `borrows` (
  `borrow_id` varchar(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `date_borrowed` datetime DEFAULT NULL,
  `date_returned` datetime DEFAULT NULL,
  `due_date` datetime DEFAULT NULL,
  `copy_id` varchar(20) DEFAULT NULL,
  `policy_id` varchar(20) DEFAULT NULL,
  `libstaff_id` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `borrows`
--

INSERT INTO `borrows` (`borrow_id`, `user_id`, `date_borrowed`, `date_returned`, `due_date`, `copy_id`, `policy_id`) VALUES
('BOR001', 100005, '2026-04-20 00:00:00', '2026-04-24 00:00:00', '2026-04-27', NULL, NULL),
('BOR002', 100006, '2026-04-20 00:00:00', '2026-04-24 00:00:00', '2026-04-27', NULL, NULL),
('BOR003', 100007, '2026-04-21 00:00:00', '2026-04-27 00:00:00', '2026-04-28', NULL, NULL),
('BOR004', 100008, '2026-04-21 00:00:00', '2026-04-27 00:00:00', '2026-04-28', NULL, NULL),
('BOR005', 100009, '2026-04-22 00:00:00', '2026-04-28 00:00:00', '2026-04-29', NULL, NULL),
('BOR006', 100010, '2026-04-22 00:00:00', '2026-04-28 00:00:00', '2026-04-29', NULL, NULL),
('BOR007', 100011, '2026-04-23 00:00:00', '2026-04-29 00:00:00', '2026-04-30', NULL, NULL),
('BOR008', 100012, '2026-04-23 00:00:00', '2026-04-29 00:00:00', '2026-04-30', NULL, NULL),
('BOR009', 100013, '2026-04-24 00:00:00', '2026-04-30 00:00:00', '2026-05-01', NULL, NULL),
('BOR010', 100014, '2026-04-24 00:00:00', '2026-05-01 00:00:00', '2026-05-01', NULL, NULL),
('BOR011', 100015, '2026-04-27 00:00:00', '2026-05-01 00:00:00', '2026-05-04', NULL, NULL),
('BOR012', 100016, '2026-04-27 00:00:00', '2026-05-01 00:00:00', '2026-05-04', NULL, NULL),
('BOR013', 100017, '2026-04-28 00:00:00', '2026-05-07 00:00:00', '2026-05-05', NULL, NULL),
('BOR014', 100018, '2026-04-28 00:00:00', '2026-05-04 00:00:00', '2026-05-05', NULL, NULL),
('BOR015', 100019, '2026-04-29 00:00:00', '2026-05-05 00:00:00', '2026-05-06', NULL, NULL),
('BOR016', 100020, '2026-04-29 00:00:00', '2026-05-05 00:00:00', '2026-05-06', NULL, NULL),
('BOR017', 100021, '2026-04-30 00:00:00', '2026-05-06 00:00:00', '2026-05-07', NULL, NULL),
('BOR018', 100022, '2026-04-30 00:00:00', '2026-05-07 00:00:00', '2026-05-07', NULL, NULL),
('BOR019', 100023, '2026-05-01 00:00:00', '2026-05-06 00:00:00', '2026-05-08', NULL, NULL),
('BOR020', 100024, '2026-05-01 00:00:00', '2026-05-09 00:00:00', '2026-05-08', NULL, NULL),
('BOR021', 100025, '2026-05-04 00:00:00', '2026-05-08 00:00:00', '2026-05-11', NULL, NULL),
('BOR022', 100026, '2026-05-04 00:00:00', '2026-05-08 00:00:00', '2026-05-11', NULL, NULL),
('BOR023', 100027, '2026-05-05 00:00:00', '2026-05-11 00:00:00', '2026-05-12', NULL, NULL),
('BOR024', 100028, '2026-05-05 00:00:00', '2026-05-11 00:00:00', '2026-05-12', NULL, NULL),
('BOR025', 100029, '2026-05-06 00:00:00', '2026-05-12 00:00:00', '2026-05-13', NULL, NULL),
('BOR026', 100030, '2026-05-06 00:00:00', '2026-05-12 00:00:00', '2026-05-13', NULL, NULL),
('BOR027', 100031, '2026-05-07 00:00:00', '2026-05-13 00:00:00', '2026-05-14', NULL, NULL),
('BOR028', 100032, '2026-05-07 00:00:00', '2026-05-13 00:00:00', '2026-05-14', NULL, NULL),
('BOR029', 100033, '2026-05-08 00:00:00', '2026-05-14 00:00:00', '2026-05-15', NULL, NULL),
('BOR030', 100034, '2026-05-08 00:00:00', '2026-05-14 00:00:00', '2026-05-15', NULL, NULL),
('BOR031', 100035, '2026-05-11 00:00:00', '2026-05-15 00:00:00', '2026-05-18', NULL, NULL),
('BOR032', 100036, '2026-05-11 00:00:00', '2026-05-15 00:00:00', '2026-05-18', NULL, NULL),
('BOR033', 100037, '2026-05-12 00:00:00', '2026-05-18 00:00:00', '2026-05-19', NULL, NULL),
('BOR034', 100038, '2026-05-12 00:00:00', '2026-05-18 00:00:00', '2026-05-19', NULL, NULL),
('BOR035', 100039, '2026-05-13 00:00:00', '2026-05-19 00:00:00', '2026-05-20', NULL, NULL),
('BOR036', 100040, '2026-05-13 00:00:00', '2026-05-20 00:00:00', '2026-05-20', NULL, NULL),
('BOR037', 100041, '2026-05-14 00:00:00', '2026-05-21 00:00:00', '2026-05-21', NULL, NULL),
('BOR038', 100042, '2026-05-14 00:00:00', '2026-05-21 00:00:00', '2026-05-21', NULL, NULL),
('BOR039', 100043, '2026-05-15 00:00:00', '2026-05-22 00:00:00', '2026-05-22', NULL, NULL),
('BOR040', 100044, '2026-05-15 00:00:00', '2026-05-22 00:00:00', '2026-05-22', NULL, NULL),
('BOR041', 100045, '2026-05-18 00:00:00', '2026-05-22 00:00:00', '2026-05-25', NULL, NULL),
('BOR042', 100046, '2026-05-18 00:00:00', '2026-05-22 00:00:00', '2026-05-25', NULL, NULL),
('BOR043', 100047, '2026-05-19 00:00:00', NULL, '2026-05-26', NULL, NULL),
('BOR044', 100048, '2026-05-19 00:00:00', NULL, '2026-05-26', NULL, NULL),
('BOR045', 100049, '2026-05-20 00:00:00', NULL, '2026-05-27', NULL, NULL),
('BOR046', 100050, '2026-05-20 00:00:00', NULL, '2026-05-27', NULL, NULL),
('BOR047', 100051, '2026-05-21 00:00:00', NULL, '2026-05-28', NULL, NULL),
('BOR048', 100052, '2026-05-21 00:00:00', NULL, '2026-05-28', NULL, NULL),
('BOR049', 100053, '2026-05-22 00:00:00', NULL, '2026-05-29', NULL, NULL),
('BOR050', 100054, '2026-05-22 00:00:00', NULL, '2026-05-29', NULL, NULL),
('BOR051', 100055, '2026-05-25 00:00:00', NULL, '2026-06-01', NULL, NULL),
('BOR052', 100056, '2026-05-25 00:00:00', NULL, '2026-06-01', NULL, NULL),
('BOR053', 100057, '2026-05-25 00:00:00', NULL, '2026-06-01', NULL, NULL),
('BOR054', 100058, '2026-05-25 00:00:00', NULL, '2026-06-01', NULL, NULL),
('BOR055', 100059, '2026-05-25 00:00:00', '2026-05-26 00:00:00', '2026-06-01', NULL, NULL),
('BOR056', 100060, '2026-05-25 00:00:00', '2026-05-25 00:00:00', '2026-06-01', NULL, NULL),
('BOR057', 100061, '2026-05-24 00:00:00', '2026-05-25 00:00:00', '2026-06-01', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `fines`
--

CREATE TABLE `fines` (
  `fine_id` varchar(30) NOT NULL,
  `libstaff_id` varchar(20) DEFAULT NULL,
  `borrow_id` varchar(20) NOT NULL,
  `amount` decimal(10,2) NOT NULL CHECK (`amount` >= 0.00),
  `hours_late` int(11) NOT NULL,
  `rate_applied` decimal(10,2) NOT NULL,
  `date_assessed` datetime NOT NULL,
  `status` varchar(10) NOT NULL DEFAULT 'Unpaid' CHECK (`status` in ('Unpaid','Paid')),
  `date_paid` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `fines`
--

INSERT INTO `fines` (`fine_id`, `libstaff_id`, `borrow_id`, `amount`, `hours_late`, `rate_applied`, `date_assessed`, `status`, `date_paid`) VALUES
('FN001', 'LIB001', 'BOR020', 48.00, 24, 2.00, '2026-05-09 00:00:00', 'Unpaid', NULL),
('FN002', 'LIB001', 'BOR013', 96.00, 48, 2.00, '2026-05-07 00:00:00', 'Unpaid', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `library_staff`
--

CREATE TABLE `library_staff` (
  `libstaff_id` varchar(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `hire_date` date DEFAULT NULL,
  `duty_schedule` varchar(100) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `username` varchar(50) DEFAULT NULL,
  `assigned_counter` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `library_staff`
--

INSERT INTO `library_staff` (`libstaff_id`, `user_id`, `hire_date`, `duty_schedule`, `password`, `username`, `assigned_counter`) VALUES
('LIB001', 100001, '2020-06-15', 'Monday-Friday 8:00am', '$2y$10$Pxdh6WcDlocL4tDXDQgu7..MxAARCrlsOE0YkrbYuCnwqgWUcmi86', 'marksantos', NULL),
('LIB002', 100002, '2020-08-14', 'Monday-Friday 8:00am', '$2y$10$SMEzZMlWjKZGl4C/X97hOeeNNSAk/2pLMlywPMBsfmDcFD/SulHcW', 'jaycruz', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `periodicals`
--

CREATE TABLE `periodicals` (
  `ISSN` varchar(20) NOT NULL CHECK (`ISSN` REGEXP '^ISSN-[A-Za-z0-9][A-Za-z0-9 ./-]*$'),
  `pub_id` varchar(20) NOT NULL,
  `peridodic_type` varchar(100) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `acquired_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
  `copy_number` int(11) NOT NULL,
  `status_id` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pub copies`
--

INSERT INTO `pub copies` (`copy_id`, `pub_id`, `copy_number`, `status_id`) VALUES
('COPY001', 'PUB001', 6, NULL),
('COPY002', 'PUB002', 6, NULL),
('COPY003', 'PUB003', 5, NULL),
('COPY004', 'PUB004', 7, NULL),
('COPY005', 'PUB005', 5, NULL),
('COPY006', 'PUB006', 2, NULL),
('COPY007', 'PUB007', 4, NULL),
('COPY008', 'PUB008', 9, NULL),
('COPY009', 'PUB009', 11, NULL),
('COPY010', 'PUB010', 12, NULL),
('COPY011', 'PUB011', 3, NULL),
('COPY012', 'PUB012', 7, NULL),
('COPY013', 'PUB013', 5, NULL),
('COPY014', 'PUB014', 8, NULL),
('COPY015', 'PUB015', 6, NULL),
('COPY016', 'PUB016', 10, NULL),
('COPY017', 'PUB017', 4, NULL),
('COPY018', 'PUB018', 9, NULL),
('COPY019', 'PUB019', 7, NULL),
('COPY020', 'PUB020', 5, NULL),
('COPY021', 'PUB021', 3, NULL),
('COPY022', 'PUB022', 6, NULL),
('COPY023', 'PUB023', 8, NULL),
('COPY024', 'PUB024', 11, NULL),
('COPY025', 'PUB025', 2, NULL),
('COPY026', 'PUB026', 7, NULL),
('COPY027', 'PUB027', 5, NULL),
('COPY028', 'PUB028', 6, NULL),
('COPY029', 'PUB029', 10, NULL),
('COPY030', 'PUB030', 4, NULL),
('COPY031', 'PUB031', 8, NULL),
('COPY032', 'PUB032', 9, NULL),
('COPY033', 'PUB033', 3, NULL),
('COPY034', 'PUB034', 6, NULL),
('COPY035', 'PUB035', 12, NULL),
('COPY036', 'PUB036', 5, NULL),
('COPY037', 'PUB037', 7, NULL),
('COPY038', 'PUB038', 4, NULL),
('COPY039', 'PUB039', 9, NULL),
('COPY040', 'PUB040', 6, NULL),
('COPY041', 'PUB041', 5, NULL),
('COPY042', 'PUB042', 11, NULL),
('COPY043', 'PUB043', 8, NULL),
('COPY044', 'PUB044', 3, NULL),
('COPY045', 'PUB045', 7, NULL),
('COPY046', 'PUB046', 6, NULL),
('COPY047', 'PUB047', 10, NULL),
('COPY048', 'PUB048', 4, NULL),
('COPY049', 'PUB049', 5, NULL),
('COPY050', 'PUB050', 9, NULL),
('COPY051', 'PUB051', 6, NULL),
('COPY052', 'PUB052', 7, NULL),
('COPY053', 'PUB053', 3, NULL),
('COPY054', 'PUB054', 8, NULL),
('COPY055', 'PUB055', 12, NULL),
('COPY056', 'PUB056', 5, NULL),
('COPY057', 'PUB057', 4, NULL),
('COPY058', 'PUB058', 6, NULL),
('COPY059', 'PUB059', 9, NULL),
('COPY060', 'PUB060', 11, NULL),
('COPY061', 'PUB061', 2, NULL),
('COPY062', 'PUB062', 7, NULL),
('COPY063', 'PUB063', 5, NULL),
('COPY064', 'PUB064', 8, NULL),
('COPY065', 'PUB065', 6, NULL),
('COPY066', 'PUB066', 10, NULL),
('COPY067', 'PUB067', 4, NULL),
('COPY068', 'PUB068', 9, NULL),
('COPY069', 'PUB069', 3, NULL),
('COPY070', 'PUB070', 7, NULL),
('COPY071', 'PUB071', 5, NULL),
('COPY072', 'PUB072', 6, NULL),
('COPY073', 'PUB073', 8, NULL),
('COPY074', 'PUB074', 11, NULL),
('COPY075', 'PUB075', 2, NULL),
('COPY076', 'PUB076', 7, NULL),
('COPY077', 'PUB077', 5, NULL),
('COPY078', 'PUB078', 9, NULL),
('COPY079', 'PUB079', 6, NULL),
('COPY080', 'PUB080', 4, NULL),
('COPY081', 'PUB081', 10, NULL),
('COPY082', 'PUB082', 3, NULL),
('COPY083', 'PUB083', 8, NULL),
('COPY084', 'PUB084', 12, NULL),
('COPY085', 'PUB085', 5, NULL),
('COPY086', 'PUB086', 7, NULL),
('COPY087', 'PUB087', 4, NULL),
('COPY088', 'PUB088', 6, NULL),
('COPY089', 'PUB089', 9, NULL),
('COPY090', 'PUB090', 11, NULL),
('COPY091', 'PUB091', 2, NULL),
('COPY092', 'PUB092', 5, NULL),
('COPY093', 'PUB093', 8, NULL),
('COPY094', 'PUB094', 6, NULL),
('COPY095', 'PUB095', 10, NULL),
('COPY096', 'PUB096', 4, NULL),
('COPY097', 'PUB097', 7, NULL),
('COPY098', 'PUB098', 9, NULL),
('COPY099', 'PUB099', 3, NULL),
('COPY100', 'PUB100', 6, NULL),
('COPY101', 'PUB101', 5, NULL),
('COPY102', 'PUB102', 8, NULL),
('COPY103', 'PUB103', 11, NULL),
('COPY104', 'PUB104', 2, NULL),
('COPY105', 'PUB105', 7, NULL),
('COPY106', 'PUB106', 4, NULL),
('COPY107', 'PUB107', 9, NULL),
('COPY108', 'PUB108', 6, NULL),
('COPY109', 'PUB109', 10, NULL),
('COPY110', 'PUB110', 3, NULL),
('COPY111', 'PUB111', 5, NULL),
('COPY112', 'PUB112', 7, NULL),
('COPY113', 'PUB113', 8, NULL),
('COPY114', 'PUB114', 12, NULL),
('COPY115', 'PUB115', 4, NULL),
('COPY116', 'PUB116', 6, NULL),
('COPY117', 'PUB117', 9, NULL),
('COPY118', 'PUB118', 11, NULL),
('COPY119', 'PUB119', 2, NULL),
('COPY120', 'PUB120', 5, NULL),
('COPY121', 'PUB121', 7, NULL),
('COPY122', 'PUB122', 8, NULL),
('COPY123', 'PUB123', 6, NULL),
('COPY124', 'PUB124', 10, NULL),
('COPY125', 'PUB125', 4, NULL),
('COPY126', 'PUB126', 9, NULL),
('COPY127', 'PUB127', 3, NULL),
('COPY128', 'PUB128', 5, NULL),
('COPY129', 'PUB129', 7, NULL),
('COPY130', 'PUB130', 11, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `publication`
--

CREATE TABLE `publication` (
  `pub_id` varchar(20) NOT NULL CHECK (`pub_id` REGEXP '^PUB[0-9]+$'),
  `title` varchar(100) NOT NULL,
  `series` varchar(100) DEFAULT NULL,
  `edition` varchar(30) DEFAULT NULL,
  `date_published` date NOT NULL,
  `shelf_location` varchar(30) NOT NULL,
  `language_used` varchar(50) NOT NULL,
  `publisher_id` varchar(30) DEFAULT NULL,
  `subtitle` varchar(255) DEFAULT NULL,
  `pages` int(11) NOT NULL,
  `copyright_date` int(11) NOT NULL,
  `publisher` varchar(100) DEFAULT NULL,
  `place_of_publication` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `publication`
--

INSERT INTO `publication` (`pub_id`, `title`, `series`, `edition`, `date_published`, `shelf_location`, `language_used`, `subtitle`, `pages`, `copyright_date`, `publisher`, `place_of_publication`) VALUES
('PUB001', 'Routing & Routers', NULL, NULL, '2020-01-01', 'Shelf A1', 'English', NULL, 100, 2020, 'Publisher Name', 'Philippines'),
('PUB002', 'Advanced Calculus', 'Mathematics Series', '2nd Edition', '2020-03-10', 'Shelf A1', '', '', 275, 2020, NULL, NULL),
('PUB003', 'Geometry Essentials', 'Mathematics Series', '1st Edition', '2018-08-21', 'Shelf A3', 'English', 'Mastering Shapes', 317, 2018, NULL, NULL),
('PUB004', 'Statistics for Beginners', 'Mathematics Series', '4th Edition', '2021-01-12', 'Shelf A4', 'English', 'A Modern Introduction', 290, 2021, NULL, NULL),
('PUB005', 'Trigonometry Simplified', 'Mathematics Series', '5th Edition', '2017-11-05', 'Shelf A5', 'English', 'Steps to Success', 350, 2017, NULL, NULL),
('PUB006', 'General Biology', 'Science Today', '2nd Edition', '2022-05-18', 'Shelf B1', 'English', 'Exploring Life Systems', 320, 2022, NULL, NULL),
('PUB007', 'Chemistry Fundamentals', 'Science Today', '3rd Edition', '2020-09-14', 'Shelf B2', 'English', 'Matter and Atomic Structure', 310, 2020, NULL, NULL),
('PUB008', 'Physics Principles', 'Science Today', '1st Edition', '2019-04-08', 'Shelf B3', 'English', 'Force, Motion, and Energy', 350, 2019, NULL, NULL),
('PUB009', 'Earth and Life Science', 'Science Today', '2nd Edition', '2021-07-30', 'Shelf B4', 'English', 'The Dynamic Planet', 280, 2021, NULL, NULL),
('PUB010', 'Environmental Science', 'Science Today', '4th Edition', '2018-02-27', 'Shelf B5', 'English', 'Ecology and Conservation', 295, 2018, NULL, NULL),
('PUB011', 'Philippine History', 'History Collection', '3rd Edition', '2022-01-19', 'Shelf C1', 'English', 'A Nation\'s Journey', 340, 2022, NULL, NULL),
('PUB012', 'World History Explained', 'History Collection', '1st Edition', '2016-12-01', 'Shelf C2', 'English', 'Global Perspectives', 275, 2016, NULL, NULL),
('PUB013', 'Asian Civilization', 'History Collection', '2nd Edition', '2020-10-10', 'Shelf C3', 'English', 'Cultural Heritage', 310, 2020, NULL, NULL),
('PUB014', 'Rizal’s Life and Works', 'History Collection', '1st Edition', '2021-06-06', 'Shelf C4', 'English', 'The National Hero', 290, 2021, NULL, NULL),
('PUB015', 'Ancient Civilizations', 'History Collection', '5th Edition', '2019-09-25', 'Shelf C5', 'English', 'Origins of Humanity', 325, 2019, NULL, NULL),
('PUB016', 'Practical Research 1', 'Research Series', '2nd Edition', '2022-03-11', 'Shelf D1', 'English', 'Foundations of Inquiry', 210, 2022, NULL, NULL),
('PUB017', 'Practical Research 2', 'Research Series', '3rd Edition', '2018-07-07', 'Shelf D2', 'English', 'Applied Methodologies', 245, 2018, NULL, NULL),
('PUB018', 'Introduction to Research', 'Research Series', '2nd Edition', '2021-02-14', 'Shelf D3', 'English', 'Scholarly Investigations', 190, 2021, NULL, NULL),
('PUB019', 'Quantitative Research', 'Research Series', '1st Edition', '2019-05-20', 'Shelf D4', 'English', 'Statistical Analysis', 315, 2019, NULL, NULL),
('PUB020', 'Qualitative Research Guide', 'Research Series', '3rd Edition', '2023-01-09', 'Shelf D5', 'English', 'Thematic Interpretations', 280, 2023, NULL, NULL),
('PUB021', 'English Dictionary', 'Reference Collection', '10th Edition', '2020-01-15', 'Shelf E1', 'English', 'The Definitive Lexicon', 850, 2020, NULL, NULL),
('PUB022', 'Encyclopedia of Science', 'Reference Collection', '8th Edition', '2019-08-20', 'Shelf E2', 'English', 'Foundations of Knowledge', 1200, 2019, NULL, NULL),
('PUB023', 'Atlas of the World', 'Reference Collection', '5th Edition', '2021-11-11', 'Shelf E3', 'English', 'Cartographic Perspectives', 400, 2021, NULL, NULL),
('PUB024', 'Computer Reference Guide', 'Reference Collection', '2nd Edition', '2018-06-01', 'Shelf E4', 'English', 'Technical Systems Overview', 350, 2018, NULL, NULL),
('PUB025', 'Medical Reference Handbook', 'Reference Collection', '4th Edition', '2022-04-18', 'Shelf E5', 'English', 'Essentials of Healthcare', 600, 2022, NULL, NULL),
('PUB026', 'Think Positive', 'Self Help Series', '1st Edition', '2020-03-10', 'Shelf F1', 'English', 'Mindset for Growth', 210, 2020, NULL, NULL),
('PUB027', 'The Power of Discipline', 'Self Help Series', '2nd Edition', '2019-07-07', 'Shelf F2', 'English', 'Mastery of Will', 195, 2019, NULL, NULL),
('PUB028', 'Improve Your Confidence', 'Self Help Series', '3rd Edition', '2021-01-01', 'Shelf F3', 'English', 'Overcoming Self-Doubt', 230, 2021, NULL, NULL),
('PUB029', 'Success Habits', 'Self Help Series', '2nd Edition', '2022-10-10', 'Shelf F4', 'English', 'Daily Routines for Excellence', 250, 2022, NULL, NULL),
('PUB030', 'Time Management Skills', 'Self Help Series', '1st Edition', '2018-12-12', 'Shelf F5', 'English', 'Efficiency and Focus', 180, 2018, NULL, NULL),
('PUB031', 'Easy Filipino Recipes', 'Recipe Collection', '1st Edition', '2020-09-09', 'Shelf G1', 'English', 'Home-Style Classics', 180, 2020, NULL, NULL),
('PUB032', 'Baking for Beginners', 'Recipe Collection', '2nd Edition', '2021-02-20', 'Shelf G2', 'English', 'Sweet and Savory Breads', 215, 2021, NULL, NULL),
('PUB033', 'Healthy Cooking Guide', 'Recipe Collection', '3rd Edition', '2019-11-11', 'Shelf G3', 'English', 'Nutritious Meal Planning', 200, 2019, NULL, NULL),
('PUB034', 'Asian Cuisine Recipes', 'Recipe Collection', '2nd Edition', '2022-07-14', 'Shelf G4', 'English', 'Flavors of the East', 250, 2022, NULL, NULL),
('PUB035', 'Desserts Made Easy', 'Recipe Collection', '1st Edition', '2018-05-05', 'Shelf G5', 'English', 'Quick Treats and Pastries', 165, 2018, NULL, NULL),
('PUB036', 'Super Kid Comics', 'Comic Series', '1st Edition', '2020-01-10', 'Shelf H1', 'English', 'Origins of Justice', 128, 2020, NULL, NULL),
('PUB037', 'Adventures of Max', 'Comic Series', '2nd Edition', '2021-03-14', 'Shelf H2', 'English', 'The Ultimate Quest', 144, 2021, NULL, NULL),
('PUB038', 'Funny Heroes', 'Comic Series', '3rd Edition', '2019-06-18', 'Shelf H3', 'English', 'Comedy Chronicles', 96, 2019, NULL, NULL),
('PUB039', 'Galaxy Warriors', 'Comic Series', '1st Edition', '2022-09-01', 'Shelf H4', 'English', 'Interstellar Battle', 160, 2022, NULL, NULL),
('PUB040', 'Mystery Detectives', 'Comic Series', '2nd Edition', '2018-10-30', 'Shelf H5', 'English', 'The Secret Casebook', 112, 2018, NULL, NULL),
('PUB041', 'Fairy Tales for Kids', 'Kids Corner', '1st Edition', '2020-02-14', 'Shelf I1', 'English', 'Ancient Stories for Youth', 120, 2020, NULL, NULL),
('PUB042', 'ABC Learning Book', 'Kids Corner', '2nd Edition', '2021-08-08', 'Shelf I2', 'English', 'First Steps in Literacy', 40, 2021, NULL, NULL),
('PUB043', 'Fun with Numbers', 'Kids Corner', '1st Edition', '2019-04-17', 'Shelf I3', 'English', 'Intro to Math for Kids', 48, 2019, NULL, NULL),
('PUB044', 'Bedtime Stories', 'Kids Corner', '3rd Edition', '2022-12-25', 'Shelf I4', 'English', 'Dreamy Evening Tales', 150, 2022, NULL, NULL),
('PUB045', 'Animal Adventures', 'Kids Corner', '2nd Edition', '2018-07-19', 'Shelf I5', 'English', 'Exploring the Wildlife', 85, 2018, NULL, NULL),
('PUB046', 'Linear Algebra', 'Mathematics Series', '2nd Edition', '2020-05-05', 'Shelf A6', 'English', 'Vector Spaces and Matrices', 310, 2020, NULL, NULL),
('PUB047', 'Organic Chemistry', 'Science Today', '1st Edition', '2021-01-15', 'Shelf B6', 'English', 'Structure and Reactivity', 420, 2021, NULL, NULL),
('PUB048', 'Modern Asian History', 'History Collection', '2nd Edition', '2019-09-09', 'Shelf C6', 'English', 'Regional Transformation', 360, 2019, NULL, NULL),
('PUB049', 'Research Writing Skills', 'Research Series', '3rd Edition', '2022-02-02', 'Shelf D6', 'English', 'Mastering Academic Prose', 225, 2022, NULL, NULL),
('PUB050', 'Motivational Thinking', 'Self Help Series', '1st Edition', '2020-10-10', 'Shelf F6', 'English', 'Empowering the Mind', 190, 2020, NULL, NULL),
('PUB051', 'Algebra Workbook Advanced', 'Mathematics Series', '2nd Edition', '2021-03-12', 'Shelf A7', 'English', 'Mastering Higher Algebra Skills', 280, 2021, NULL, NULL),
('PUB052', 'Statistics Applications', 'Mathematics Series', '3rd Edition', '2020-07-18', 'Shelf A8', 'English', 'Real-World Data Analysis', 310, 2020, NULL, NULL),
('PUB053', 'Probability Basics', 'Mathematics Series', '1st Edition', '2019-11-05', 'Shelf A9', 'English', 'Understanding Chance and Outcomes', 350, 2019, NULL, NULL),
('PUB054', 'Differential Equations Intro', 'Mathematics Series', '4th Edition', '2022-02-10', 'Shelf A10', 'English', 'Foundations of Mathematical Change', 400, 2022, NULL, NULL),
('PUB055', 'Mathematical Logic', 'Mathematics Series', '1st Edition', '2018-06-22', 'Shelf A11', 'English', 'Critical Thinking and Reasoning', 220, 2018, NULL, NULL),
('PUB056', 'Human Anatomy Basics', 'Science Today', '2nd Edition', '2021-09-14', 'Shelf B6', 'English', 'Exploring the Human Body', 190, 2021, NULL, NULL),
('PUB057', 'Genetics Fundamentals', 'Science Today', '3rd Edition', '2020-04-09', 'Shelf B7', 'English', 'The Science of Heredity', 215, 2020, NULL, NULL),
('PUB058', 'Astronomy Guide', 'Science Today', '1st Edition', '2019-08-16', 'Shelf B8', 'English', 'Discovering the Universe', 250, 2019, NULL, NULL),
('PUB059', 'Marine Biology', 'Science Today', '2nd Edition', '2022-05-11', 'Shelf B9', 'English', 'Life Beneath the Ocean', 180, 2022, NULL, NULL),
('PUB060', 'Ecology and Environment', 'Science Today', '3rd Edition', '2021-12-01', 'Shelf B10', 'English', 'Protecting Nature and Ecosystems', 165, 2021, NULL, NULL),
('PUB061', 'Philippine Government History', 'History Collection', '2nd Edition', '2020-02-20', 'Shelf C7', 'English', 'Ancient to Modern Era', 520, 2020, NULL, NULL),
('PUB062', 'Asian History Timeline', 'History Collection', '1st Edition', '2018-10-10', 'Shelf C8', 'English', 'Renaissance and Reform', 540, 2018, NULL, NULL),
('PUB063', 'European History', 'History Collection', '3rd Edition', '2021-06-14', 'Shelf C9', 'English', 'Global Conflicts', 350, 2021, NULL, NULL),
('PUB064', 'World Wars Overview', 'History Collection', '2nd Edition', '2019-03-03', 'Shelf C10', 'English', 'Evolution of Traditions', 980, 2019, NULL, NULL),
('PUB065', 'Cultural History Studies', 'History Collection', '1st Edition', '2022-08-08', 'Shelf C11', 'English', 'Fundamental Principles', 410, 2022, NULL, NULL),
('PUB066', 'Research Methodology Guide', 'Research Series', '2nd Edition', '2020-11-11', 'Shelf D7', 'English', 'Narrative and Ethnography', 210, 2020, NULL, NULL),
('PUB067', 'Advanced Qualitative Research', 'Research Series', '3rd Edition', '2021-04-04', 'Shelf D8', 'English', 'Statistical Interpretation', 195, 2021, NULL, NULL),
('PUB068', 'Quantitative Analysis', 'Research Series', '1st Edition', '2019-09-09', 'Shelf D9', 'English', 'Structural Documentation', 180, 2019, NULL, NULL),
('PUB069', 'Thesis Writing Guide', 'Research Series', '2nd Edition', '2022-01-01', 'Shelf D10', 'English', 'Critical Thinking and Style', 365, 2022, NULL, NULL),
('PUB070', 'Academic Writing Skills', 'Research Series', '3rd Edition', '2020-06-06', 'Shelf D11', 'English', 'Foundations of Natural World', 225, 2020, NULL, NULL),
('PUB071', 'Science Encyclopedia Volume 1', 'Reference Collection', '10th Edition', '2021-01-15', 'Shelf E6', 'English', 'Advanced Scientific Discovery', 120, 2021, NULL, NULL),
('PUB072', 'Science Encyclopedia Volume 2', 'Reference Collection', '10th Edition', '2021-01-15', 'Shelf E7', 'English', 'Cartographic Global Overview', 150, 2021, NULL, NULL),
('PUB073', 'World Atlas Updated', 'Reference Collection', '6th Edition', '2022-03-20', 'Shelf E8', 'English', 'Language and Etymology', 95, 2022, NULL, NULL),
('PUB074', 'Dictionary of Terms', 'Reference Collection', '11th Edition', '2019-05-05', 'Shelf E9', 'English', 'Computing and Digital Systems', 210, 2019, NULL, NULL),
('PUB075', 'IT Reference Handbook', 'Reference Collection', '3rd Edition', '2023-07-07', 'Shelf E10', 'English', 'Cultivating Optimism', 180, 2023, NULL, NULL),
('PUB076', 'Positive Mindset Guide', 'Self Help Series', '2nd Edition', '2020-10-10', 'Shelf F7', 'English', 'Personal Wealth Management', 32, 2020, NULL, NULL),
('PUB077', 'Financial Freedom Basics', 'Self Help Series', '1st Edition', '2021-02-14', 'Shelf F8', 'English', 'Building Inner Strength', 40, 2021, NULL, NULL),
('PUB078', 'Self Confidence Booster', 'Self Help Series', '3rd Edition', '2019-07-07', 'Shelf F9', 'English', 'Inspiration for Every Day', 24, 2019, NULL, NULL),
('PUB079', 'Daily Motivation Book', 'Self Help Series', '1st Edition', '2022-12-12', 'Shelf F10', 'English', 'Principles of Team Management', 36, 2022, NULL, NULL),
('PUB080', 'Leadership Skills Guide', 'Self Help Series', '2nd Edition', '2018-08-08', 'Shelf F11', 'English', 'Traditional Sweets', 48, 2018, NULL, NULL),
('PUB081', 'Filipino Dessert Recipes', 'Recipe Collection', '1st Edition', '2021-05-05', 'Shelf G6', 'English', '30-Minute Meals', 24, 2021, NULL, NULL),
('PUB082', 'Easy Home Cooking', 'Recipe Collection', '2nd Edition', '2020-09-09', 'Shelf G7', 'English', 'Finger Foods & Appetizers', 32, 2020, NULL, NULL),
('PUB083', 'Quick Snacks Recipes', 'Recipe Collection', '1st Edition', '2019-12-12', 'Shelf G8', 'English', 'Flavors of the World', 45, 2019, NULL, NULL),
('PUB084', 'International Cuisine', 'Recipe Collection', '3rd Edition', '2022-04-04', 'Shelf G9', 'English', 'Balanced Nutrition Guide', 130, 2022, NULL, NULL),
('PUB085', 'Healthy Diet Recipes', 'Recipe Collection', '2nd Edition', '2018-06-06', 'Shelf G10', 'English', 'The Next Generation', 50, 2018, NULL, NULL),
('PUB086', 'Superhero Adventures', 'Comic Series', '2nd Edition', '2021-03-03', 'Shelf H6', 'English', 'Beyond the Galaxy', 280, 2021, NULL, NULL),
('PUB087', 'Space Explorers Comic', 'Comic Series', '1st Edition', '2020-07-07', 'Shelf H7', 'English', 'Sunday Funnies', 450, 2020, NULL, NULL),
('PUB088', 'Funny Cartoon World', 'Comic Series', '3rd Edition', '2019-11-11', 'Shelf H8', 'English', 'The Crimson Mystery', 520, 2019, NULL, NULL),
('PUB089', 'Detective Stories Comic', 'Comic Series', '2nd Edition', '2022-02-02', 'Shelf H9', 'English', 'Origins of Power', 310, 2022, NULL, NULL),
('PUB090', 'Hero Legends', 'Comic Series', '1st Edition', '2018-09-09', 'Shelf H10', 'English', 'Visual Learning Guide', 215, 2018, NULL, NULL),
('PUB091', 'Learning Colors for Kids', 'Kids Corner', '1st Edition', '2020-01-01', 'Shelf I6', 'English', 'Counting for Beginners', 24, 2020, NULL, NULL),
('PUB092', 'Numbers for Kids', 'Kids Corner', '2nd Edition', '2021-06-06', 'Shelf I7', 'English', 'Easy Experiments', 30, 2021, NULL, NULL),
('PUB093', 'Kids Science Fun', 'Kids Corner', '1st Edition', '2019-03-03', 'Shelf I8', 'English', 'Magical Midnight Tales', 45, 2019, NULL, NULL),
('PUB094', 'Bedtime Fairy Stories', 'Kids Corner', '3rd Edition', '2022-10-10', 'Shelf I9', 'English', 'Habitat and Wildlife', 80, 2022, NULL, NULL),
('PUB095', 'Animal Learning Book', 'Kids Corner', '2nd Edition', '2018-05-05', 'Shelf I10', 'English', 'Equation Solving Techniques', 36, 2018, NULL, NULL),
('PUB096', 'Algebra Mastery', 'Mathematics Series', '2nd Edition', '2021-08-08', 'Shelf A12', 'English', 'Quantum and Mechanics', 320, 2021, NULL, NULL),
('PUB097', 'Physics Advanced', 'Science Today', '3rd Edition', '2020-02-02', 'Shelf B11', 'English', 'Pre-Colonial to Present', 410, 2020, NULL, NULL),
('PUB098', 'History of Philippines Expanded', 'History Collection', '2nd Edition', '2022-11-11', 'Shelf C12', 'English', 'Comprehensive Thesis Guide', 550, 2022, NULL, NULL),
('PUB099', 'Research Writing Mastery', 'Research Series', '1st Edition', '2019-04-04', 'Shelf D12', 'English', 'Achieving Your Goals', 275, 2019, NULL, NULL),
('PUB100', 'Motivation for Success', 'Self Help Series', '3rd Edition', '2021-12-12', 'Shelf F12', 'English', 'Personal Growth & Achievement Guide', 210, 2021, NULL, NULL),
('PUB1001', 'Routers', 'Technology Series', '2nd Edition', '2014-09-14', 'Shelf A2', 'English', 'Networking', 200, 2014, NULL, NULL),
('PUB101', 'Philippine Star', 'Newspaper', 'Daily', '2026-05-12', 'News-Rack 1', 'English', 'Truth Shall Prevail National News', 28, 2026, NULL, NULL),
('PUB102', 'Manila Bulletin', 'Newspaper', 'Daily', '2026-05-12', 'News-Rack 1', 'English', 'The Nation\'s Leading Newspaper', 32, 2026, NULL, NULL),
('PUB103', 'Phil. Daily Inquirer', 'Newspaper', 'Daily', '2026-05-12', 'News-Rack 1', 'English', 'Balanced News, Fearless Views', 30, 2026, NULL, NULL),
('PUB104', 'The Manila Times', 'Newspaper', 'Daily', '2026-05-12', 'News-Rack 2', 'English', 'Trusted Voice in Philippine Journalism', 26, 2026, NULL, NULL),
('PUB105', 'Daily Tribune', 'Newspaper', 'Daily', '2026-05-12', 'News-Rack 2', 'English', 'Without Fear or Favor Broadcaster', 24, 2026, NULL, NULL),
('PUB106', 'BusinessWorld', 'Newspaper', 'Financial/Daily', '2026-05-12', 'News-Rack 2', 'English', 'Southeast Asia\'s First Business Daily', 22, 2026, NULL, NULL),
('PUB107', 'Manila Standard', 'Newspaper', 'Daily', '2026-05-12', 'News-Rack 3', 'English', 'Defining the News for the Global Filipino', 25, 2026, NULL, NULL),
('PUB108', 'BusinessMirror', 'Newspaper', 'Daily', '2026-05-12', 'News-Rack 3', 'English', 'A Broader Look at Banking & Finance', 27, 2026, NULL, NULL),
('PUB109', 'The Freeman', 'Newspaper', 'Regional/Daily', '2026-05-12', 'News-Rack 3', 'English', 'Cebu\'s Oldest and Trusted Daily', 20, 2026, NULL, NULL),
('PUB110', 'Malaya Business', 'Newspaper', 'Financial/Daily', '2026-05-12', 'News-Rack 2', 'English', 'Insightful Corporate & Economic Reporting', 18, 2026, NULL, NULL),
('PUB111', 'Esquire Philippines', 'Magazine', 'Monthly', '2026-05-05', 'Mag-Shelf B', 'English', 'Modern Man\'s Guide to Style & Culture', 120, 2026, NULL, NULL),
('PUB112', 'Reader\'s Digest PH', 'Magazine', 'Asian Ed.', '2026-05-01', 'Mag-Shelf A', 'English', 'Inspiring Stories and Practical Advice', 140, 2026, NULL, NULL),
('PUB113', 'K-Mag', 'Magazine', 'Bi-Monthly', '2026-04-10', 'Mag-Shelf E', 'English', 'The Definitive K-Pop & Hallyu Resource', 95, 2026, NULL, NULL),
('PUB114', 'Preview Magazine', 'Magazine', 'Monthly', '2026-05-01', 'Mag-Shelf B', 'English', 'The Philippines\' Style Authority', 110, 2026, NULL, NULL),
('PUB115', 'Cosmopolitan PH', 'Magazine', 'Monthly', '2026-05-01', 'Mag-Shelf B', 'English', 'Fun, Fearless Female Lifestyle', 130, 2026, NULL, NULL),
('PUB116', 'Top Gear PH', 'Magazine', 'Monthly', '2026-05-01', 'Mag-Shelf C', 'English', 'Number One Automotive Authority', 125, 2026, NULL, NULL),
('PUB117', 'Forbes Philippines', 'Magazine', 'Monthly', '2026-05-01', 'Mag-Shelf D', 'English', 'Wealth, Innovation, and Leadership', 150, 2026, NULL, NULL),
('PUB118', 'Men\'s Health PH', 'Magazine', 'Monthly', '2026-04-01', 'Mag-Shelf E', 'English', 'Fitness and Wellness for the Modern Man', 118, 2026, NULL, NULL),
('PUB119', 'Spot.ph', 'Magazine', 'Quarterly', '2026-02-15', 'Mag-Shelf D', 'English', 'The Ultimate Guide to Manila Living', 90, 2026, NULL, NULL),
('PUB120', 'Home & Design', 'Magazine', 'Annual', '2026-01-10', 'Mag-Shelf F', 'English', 'Interior Inspiration and Architecture', 105, 2026, NULL, NULL),
('PUB121', 'Tempo', 'Tabloid', 'Daily', '2026-05-11', 'Tab-Section', 'English', 'News in a Flash Tabloid', 20, 2026, NULL, NULL),
('PUB122', 'Bulgar', 'Tabloid', 'Daily', '2026-05-12', 'Tab-Section', 'Tagalog', 'Boses ng Pinoy, Mata ng Bayan', 22, 2026, NULL, NULL),
('PUB123', 'Bandera', 'Tabloid', 'Daily', '2026-05-11', 'Tab-Section', 'Bisaya', 'Balita, Karera, at Panalo', 18, 2026, NULL, NULL),
('PUB124', 'People\'s Journal', 'Tabloid', 'Daily', '2026-05-12', 'Tab-Section', 'English', 'The Country\'s Best-Selling Tabloid', 20, 2026, NULL, NULL),
('PUB125', 'Abante', 'Tabloid', 'Daily', '2026-05-12', 'Tab-Section', 'Tagalog', 'Una sa Balita, Una sa Masa', 24, 2026, NULL, NULL),
('PUB126', 'Pilipino Star Ngayon', 'Tabloid', 'Daily', '2026-05-12', 'Tab-Section', 'Tagalog', 'Ang Dyaryo ng Masang Pilipino', 26, 2026, NULL, NULL),
('PUB127', 'Hataw!', 'Tabloid', 'Daily', '2026-05-12', 'Tab-Section', 'Tagalog', 'Diyaryo ng Bayan for General News', 18, 2026, NULL, NULL),
('PUB128', 'Remate', 'Tabloid', 'Daily', '2026-05-12', 'Tab-Section', 'Tagalog', 'Ang Diaryo ng Masa at Katotohanan', 22, 2026, NULL, NULL),
('PUB129', 'Balita', 'Tabloid', 'Daily', '2026-05-12', 'Tab-Section', 'Tagalog', 'Pangunahing Pahayagang Tagalog sa Bansa', 20, 2026, NULL, NULL),
('PUB130', 'Police Files', 'Tabloid', 'Daily', '2026-05-12', 'Tab-Section', 'Tagalog', 'Crime, Justice, and Community Watch', 16, 2026, NULL, NULL),
('PUB3030', 'Web System', 'Technology Series', '2nd Edition', '2026-05-26', 'Shelf A1', 'English', 'Principles & Practice', 200, 2026, NULL, NULL),
('PUB4682', 'Frankenstein', 'Fiction Series', '2nd Edition', '2026-05-26', 'Shelf A2', 'English', 'Fiction', 100, 2026, NULL, NULL),
('PUB6143', 'Routers', 'Technology Series', '2nd Edition', '2026-05-25', 'Shelf A1', 'English', 'Networking', 200, 2026, NULL, NULL),
('PUB8026', 'Routing & Routers', 'Technology Series', '2nd Edition', '2026-05-26', 'Shelf A1', '', '', 156, 2026, NULL, NULL),
('PUB8246', 'Routers', 'Technology Series', '2nd Edition', '2026-05-25', 'Shelf A1', 'English', 'Networking', 200, 2026, NULL, NULL);

UPDATE `publication`
SET `publisher_id` = CONCAT('PBL-', LPAD(CAST(SUBSTRING(`pub_id`, 4) AS UNSIGNED), 3, '0'))
WHERE `pub_id` REGEXP '^PUB[0-9]{3}$'
  AND CAST(SUBSTRING(`pub_id`, 4) AS UNSIGNED) BETWEEN 1 AND 130;

-- --------------------------------------------------------

--
-- Table structure for table `reports`
--

CREATE TABLE `reports` (
  `report_id` int(11) NOT NULL AUTO_INCREMENT,
  `libstaff_id` varchar(20) DEFAULT NULL,
  `report_type` enum('Weekly','Monthly','Annual') NOT NULL,
  `date_generated` datetime NOT NULL DEFAULT current_timestamp(),
  `period_start` date DEFAULT NULL,
  PRIMARY KEY (`report_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reports`
--

INSERT INTO `reports` (`report_id`, `libstaff_id`, `report_type`, `date_generated`, `period_start`) VALUES
(1, 'LIB001', 'Monthly', '2026-04-30 00:00:00', '2026-04-01'),
(2, 'LIB001', 'Annual', '2025-12-31 00:00:00', '2025-01-01'),
(3, 'LIB001', 'Monthly', '2026-05-15 00:00:00', '2026-05-01');

-- --------------------------------------------------------

--
-- Table structure for table `status`
--

CREATE TABLE `status` (
  `status_id` varchar(20) NOT NULL,
  `status_type` varchar(30) DEFAULT NULL,
  `libstaff_id` varchar(20) DEFAULT NULL,
  `condition` varchar(50) NOT NULL CHECK (`condition` in ('Good','Damaged'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `status`
--

INSERT INTO `status` (`status_id`, `status_type`, `libstaff_id`, `condition`) VALUES
('110001', 'Available', 'LIB001', 'Good'),
('110002', 'Available', 'LIB002', 'Good'),
('110003', 'Available', 'LIB001', 'Good'),
('110004', 'Available', 'LIB002', 'Good'),
('110005', 'Available', 'LIB001', 'Good'),
('110006', 'Available', 'LIB002', 'Good'),
('110007', 'Available', 'LIB001', 'Good'),
('110008', 'Available', 'LIB002', 'Good'),
('110009', 'Available', 'LIB001', 'Good'),
('110010', 'Available', 'LIB002', 'Good'),
('110011', 'Borrowed', 'LIB001', 'Good'),
('110012', 'Available', 'LIB002', 'Good'),
('110013', 'Available', 'LIB001', 'Good'),
('110014', 'Available', 'LIB002', 'Good'),
('110015', 'Available', 'LIB001', 'Good'),
('110016', 'Available', 'LIB002', 'Good'),
('110017', 'Available', 'LIB001', 'Good'),
('110018', 'Available', 'LIB002', 'Good'),
('110019', 'Available', 'LIB001', 'Good'),
('110020', 'Available', 'LIB002', 'Good'),
('110021', 'Available', 'LIB001', 'Damaged'),
('110022', 'Overdue', 'LIB002', 'Good'),
('110023', 'Available', 'LIB001', 'Good'),
('110024', 'Available', 'LIB002', 'Good'),
('110025', 'Available', 'LIB001', 'Good'),
('110026', 'Available', 'LIB002', 'Good'),
('110027', 'Available', 'LIB001', 'Good'),
('110028', 'Available', 'LIB002', 'Good'),
('110029', 'Available', 'LIB001', 'Good'),
('110030', 'Available', 'LIB002', 'Good'),
('110031', 'Available', 'LIB001', 'Good'),
('110032', 'Available', 'LIB002', 'Good'),
('110033', 'Available', 'LIB001', 'Good'),
('110034', 'Borrowed', 'LIB002', 'Good'),
('110035', 'Borrowed', 'LIB001', 'Good'),
('110036', 'Borrowed', 'LIB002', 'Good'),
('110037', 'Borrowed', 'LIB001', 'Good'),
('110038', 'Available', 'LIB002', 'Good'),
('110039', 'Available', 'LIB001', 'Good'),
('110040', 'Available', 'LIB002', 'Good'),
('110041', 'Available', 'LIB001', 'Good'),
('110042', 'Available', 'LIB002', 'Good'),
('110043', 'Available', 'LIB001', 'Good'),
('110044', 'Available', 'LIB002', 'Good'),
('110045', 'Available', 'LIB001', 'Good'),
('110046', 'Available', 'LIB002', 'Good'),
('110047', 'Available', 'LIB001', 'Damaged'),
('110048', 'Available', 'LIB002', 'Good'),
('110049', 'Available', 'LIB001', 'Good'),
('110050', 'Available', 'LIB002', 'Good'),
('110051', 'Available', 'LIB001', 'Good'),
('110052', 'Available', 'LIB002', 'Good'),
('110053', 'Borrowed', 'LIB001', 'Good'),
('110054', 'Available', 'LIB002', 'Good'),
('110055', 'Available', 'LIB001', 'Good'),
('110056', 'Available', 'LIB002', 'Good'),
('110057', 'Available', 'LIB001', 'Good'),
('110058', 'Available', 'LIB002', 'Good'),
('110059', 'Available', 'LIB001', 'Good'),
('110060', 'Available', 'LIB002', 'Good'),
('110061', 'Available', 'LIB001', 'Good'),
('110062', 'Available', 'LIB002', 'Good'),
('110063', 'Available', 'LIB001', 'Good'),
('110064', 'Available', 'LIB002', 'Good'),
('110065', 'Available', 'LIB001', 'Good'),
('110066', 'Available', 'LIB002', 'Good'),
('110067', 'Available', 'LIB001', 'Good'),
('110068', 'Available', 'LIB002', 'Good'),
('110069', 'Available', 'LIB001', 'Good'),
('110070', 'Available', 'LIB002', 'Damaged'),
('110071', 'Available', 'LIB001', 'Good'),
('110072', 'Borrowed', 'LIB002', 'Good'),
('110073', 'Available', 'LIB001', 'Good'),
('110074', 'Available', 'LIB002', 'Good'),
('110075', 'Borrowed', 'LIB001', 'Good'),
('110076', 'Borrowed', 'LIB002', 'Good'),
('110077', 'Borrowed', 'LIB001', 'Good'),
('110078', 'Borrowed', 'LIB002', 'Good'),
('110079', 'Available', 'LIB001', 'Good'),
('110080', 'Available', 'LIB002', 'Good'),
('110081', 'Available', 'LIB001', 'Good'),
('110082', 'Available', 'LIB002', 'Good'),
('110083', 'Available', 'LIB001', 'Good'),
('110084', 'Available', 'LIB002', 'Good'),
('110085', 'Available', 'LIB001', 'Good'),
('110086', 'Available', 'LIB002', 'Good'),
('110087', 'Available', 'LIB001', 'Good'),
('110088', 'Available', 'LIB002', 'Good'),
('110089', 'Available', 'LIB001', 'Good'),
('110090', 'Available', 'LIB002', 'Good'),
('110091', 'Available', 'LIB001', 'Good'),
('110092', 'Available', 'LIB002', 'Good'),
('110093', 'Available', 'LIB001', 'Good'),
('110094', 'Overdue', 'LIB002', 'Good'),
('110095', 'Available', 'LIB001', 'Damaged'),
('110096', 'Available', 'LIB002', 'Good'),
('110097', 'Available', 'LIB001', 'Good'),
('110098', 'Available', 'LIB002', 'Good'),
('110099', 'Available', 'LIB001', 'Good'),
('110100', 'Borrowed', 'LIB002', 'Good');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `user_id` int(11) NOT NULL,
  `user_fname` varchar(50) DEFAULT NULL,
  `user_lname` varchar(50) DEFAULT NULL,
  `user_midInit` varchar(50) DEFAULT NULL,
  `birth_date` date NOT NULL,
  `gender` varchar(10) NOT NULL CHECK (`gender` in ('male','female')),
  `email` varchar(100) DEFAULT NULL,
  `user_type` varchar(20) DEFAULT NULL,
  `user_brgy` varchar(100) DEFAULT NULL,
  `user_municipality` varchar(100) DEFAULT NULL,
  `user_province` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`user_id`, `user_fname`, `user_lname`, `user_midInit`, `birth_date`, `gender`, `email`, `user_type`, `user_brgy`, `user_municipality`, `user_province`) VALUES
(100001, 'Anna', 'Reyes', 'A', '1995-06-12', 'Female', 'anna.reyes@gmail.com', 'Librarian', NULL, NULL, NULL),
(100002, 'Mark', 'Santos', 'A', '1998-03-21', 'Male', 'mark.santos@gmail.com', 'Library Clerk', NULL, NULL, NULL),
(100003, 'Joana', 'Cruz', 'D', '1999-05-20', 'Female', 'joana.cruz@gmail.com', 'Library Clerk', NULL, NULL, NULL),
(100004, 'John', 'Dela Cruz', 'F', '1993-11-10', 'Male', 'john.delacruz@gmail.com', 'IT Staff', NULL, NULL, NULL),
(100005, 'Carla', 'Mendoza', 'C', '2002-01-15', 'Female', 'carla.mendoza@gmail.com', 'Borrower', NULL, NULL, NULL),
(100006, 'Kevin', 'Ramos', 'A', '2001-04-10', 'Male', 'kevin.ramos@gmail.com', 'Borrower', NULL, NULL, NULL),
(100007, 'Maria', 'Lopez', 'C', '2000-07-20', 'Female', 'maria.lopez@gmail.com', 'Borrower', NULL, NULL, NULL),
(100008, 'James', 'Garcia', 'B', '1999-09-05', 'Male', 'james.garcia@gmail.com', 'Borrower', NULL, NULL, NULL),
(100009, 'Sophia', 'Cruz', 'S', '2003-02-18', 'Female', 'sophia.cruz@gmail.com', 'Borrower', NULL, NULL, NULL),
(100010, 'Daniel', 'Flores', 'C', '2002-12-11', 'Male', 'daniel.flores@gmail.com', 'Borrower', NULL, NULL, NULL),
(100011, 'Nicole', 'Torres', 'E', '2001-06-25', 'Female', 'nicole.torres@gmail.com', 'Borrower', NULL, NULL, NULL),
(100012, 'Ethan', 'Villanueva', 'W', '2000-03-14', 'Male', 'ethan.villanueva@gmail.com', 'Borrower', NULL, NULL, NULL),
(100013, 'Angela', 'Perez', 'T', '1999-08-09', 'Female', 'angela.perez@gmail.com', 'Borrower', NULL, NULL, NULL),
(100014, 'Joshua', 'Bautista', 'S', '2001-05-01', 'Male', 'joshua.bautista@gmail.com', 'Borrower', NULL, NULL, NULL),
(100015, 'Bea', 'Navarro', 'G', '2002-11-23', 'Female', 'bea.navarro@gmail.com', 'Borrower', NULL, NULL, NULL),
(100016, 'Christian', 'Aquino', 'M', '2003-07-30', 'Male', 'christian.aquino@gmail.com', 'Borrower', NULL, NULL, NULL),
(100017, 'Faith', 'Castillo', 'J', '2001-01-08', 'Female', 'faith.castillo@gmail.com', 'Borrower', NULL, NULL, NULL),
(100018, 'Vincent', 'Rivera', 'K', '2000-10-12', 'Male', 'vincent.rivera@gmail.com', 'Borrower', NULL, NULL, NULL),
(100019, 'Chloe', 'Morales', 'G', '2002-09-19', 'Female', 'chloe.morales@gmail.com', 'Borrower', NULL, NULL, NULL),
(100020, 'Ryan', 'Herrera', 'R', '1999-04-28', 'Male', 'ryan.herrera@gmail.com', 'Borrower', NULL, NULL, NULL),
(100021, 'Alyssa', 'Gomez', 'A', '2001-12-02', 'Female', 'alyssa.gomez@gmail.com', 'Borrower', NULL, NULL, NULL),
(100022, 'Carl', 'Diaz', 'R', '2000-06-17', 'Male', 'carl.diaz@gmail.com', 'Borrower', NULL, NULL, NULL),
(100023, 'Jasmine', 'Ramos', 'C', '2003-03-09', 'Female', 'jasmine.ramos@gmail.com', 'Borrower', NULL, NULL, NULL),
(100024, 'Patrick', 'Mendoza', 'C', '2002-08-21', 'Male', 'patrick.mendoza@gmail.com', 'Borrower', NULL, NULL, NULL),
(100025, 'Hannah', 'Reyes', 'D', '1999-05-13', 'Female', 'hannah.reyes@gmail.com', 'Borrower', NULL, NULL, NULL),
(100026, 'Sean', 'Santos', 'W', '2001-11-27', 'Male', 'sean.santos@gmail.com', 'Borrower', NULL, NULL, NULL),
(100027, 'Angel', 'Cruz', 'S', '2000-02-06', 'Female', 'angel.cruz@gmail.com', 'Borrower', NULL, NULL, NULL),
(100028, 'Gabriel', 'Flores', 'A', '2003-01-16', 'Male', 'gabriel.flores@gmail.com', 'Borrower', NULL, NULL, NULL),
(100029, 'Kim', 'Torres', 'E', '2002-07-07', 'Female', 'kim.torres@gmail.com', 'Borrower', NULL, NULL, NULL),
(100030, 'Nathan', 'Garcia', 'W', '2001-09-22', 'Male', 'nathan.garcia@gmail.com', 'Borrower', NULL, NULL, NULL),
(100031, 'Ella', 'Lopez', 'W', '2000-12-15', 'Female', 'ella.lopez@gmail.com', 'Borrower', NULL, NULL, NULL),
(100032, 'Adrian', 'Perez', 'A', '1999-10-30', 'Male', 'adrian.perez@gmail.com', 'Borrower', NULL, NULL, NULL),
(100033, 'Trisha', 'Aquino', 'A', '2002-06-11', 'Female', 'trisha.aquino@gmail.com', 'Borrower', NULL, NULL, NULL),
(100034, 'Kyle', 'Bautista', 'Z', '2001-04-04', 'Male', 'kyle.bautista@gmail.com', 'Borrower', NULL, NULL, NULL),
(100035, 'Denise', 'Rivera', 'C', '2003-02-28', 'Female', 'denise.rivera@gmail.com', 'Borrower', NULL, NULL, NULL),
(100036, 'Matthew', 'Navarro', 'D', '2000-07-01', 'Male', 'matthew.navarro@gmail.com', 'Borrower', NULL, NULL, NULL),
(100037, 'Princess', 'Castillo', 'G', '2001-08-14', 'Female', 'princess.castillo@gmail.com', 'Borrower', NULL, NULL, NULL),
(100038, 'Jacob', 'Diaz', 'L', '2002-03-17', 'Male', 'jacob.diaz@gmail.com', 'Borrower', NULL, NULL, NULL),
(100039, 'Rica', 'Morales', 'L', '1999-09-09', 'Female', 'rica.morales@gmail.com', 'Borrower', NULL, NULL, NULL),
(100040, 'Aaron', 'Herrera', 'I', '2001-05-24', 'Male', 'aaron.herrera@gmail.com', 'Borrower', NULL, NULL, NULL),
(100041, 'Bianca', 'Gomez', 'O', '2000-01-20', 'Female', 'bianca.gomez@gmail.com', 'Borrower', NULL, NULL, NULL),
(100042, 'Paul', 'Ramos', 'P', '2002-10-08', 'Male', 'paul.ramos@gmail.com', 'Borrower', NULL, NULL, NULL),
(100043, 'Kate', 'Mendoza', 'H', '2003-06-26', 'Female', 'kate.mendoza@gmail.com', 'Borrower', NULL, NULL, NULL),
(100044, 'Jericho', 'Reyes', 'T', '2001-07-03', 'Male', 'jericho.reyes@gmail.com', 'Borrower', NULL, NULL, NULL),
(100045, 'Mae', 'Santos', 'R', '2000-11-18', 'Female', 'mae.santos@gmail.com', 'Borrower', NULL, NULL, NULL),
(100046, 'Joseph', 'Cruz', 'E', '1999-03-12', 'Male', 'joseph.cruz@gmail.com', 'Borrower', NULL, NULL, NULL),
(100047, 'Christine', 'Flores', 'E', '2002-05-29', 'Female', 'christine.flores@gmail.com', 'Borrower', NULL, NULL, NULL),
(100048, 'Leo', 'Torres', 'W', '2001-09-01', 'Male', 'leo.torres@gmail.com', 'Borrower', NULL, NULL, NULL),
(100049, 'Samantha', 'Garcia', 'A', '2003-04-22', 'Female', 'samantha.garcia@gmail.com', 'Borrower', NULL, NULL, NULL),
(100050, 'Marco', 'Lopez', 'B', '2000-08-16', 'Male', 'marco.lopez@gmail.com', 'Borrower', NULL, NULL, NULL),
(100051, 'Camille', 'Perez', 'N', '2001-02-05', 'Female', 'camille.perez@gmail.com', 'Borrower', NULL, NULL, NULL),
(100052, 'Ivan', 'Aquino', 'M', '2002-12-13', 'Male', 'ivan.aquino@gmail.com', 'Borrower', NULL, NULL, NULL),
(100053, 'Lovely', 'Bautista', 'M', '1999-06-27', 'Female', 'lovely.bautista@gmail.com', 'Borrower', NULL, NULL, NULL),
(100054, 'Renzo', 'Rivera', 'M', '2003-01-31', 'Male', 'renzo.rivera@gmail.com', 'Borrower', NULL, NULL, NULL),
(100055, 'Carl', 'Vargaz', 'B', '2004-02-21', 'Male', 'carl.vargaz@gmail.com', 'Borrower', NULL, NULL, NULL),
(100056, 'Mary', 'Rivero', 'B', '2005-03-23', 'Female', 'mary.rivero@gmail.com', 'Borrower', NULL, NULL, NULL),
(100057, 'Olivia', 'Orosco', 'A', '2000-01-31', 'Female', 'olivia.orosco@gmail.com', 'Borrower', NULL, NULL, NULL),
(100058, 'Linda', 'Gomez', 'A', '2003-12-30', 'Female', 'linda.gomez@gmail.com', 'Borrower', NULL, NULL, NULL),
(100059, 'Karen', 'Dayto', 'S', '2002-05-17', 'Female', 'karen.dayto@gmail.com', 'Borrower', NULL, NULL, NULL),
(100060, 'Isabella', 'Jacob', 'S', '2004-09-27', 'Female', 'isabella.jacob@gmail.com', 'Borrower', NULL, NULL, NULL),
(100061, 'Harper', 'Espatinez', 'O', '2008-04-12', 'Female', 'harper.espatinez@gmail.com', 'Borrower', NULL, NULL, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `author`
--
ALTER TABLE `author`
  ADD PRIMARY KEY (`author_id`),
  ADD UNIQUE KEY `author_num` (`author_num`);

--
-- Indexes for table `books`
--
ALTER TABLE `books`
  ADD UNIQUE KEY `uq_books_pub_id` (`pub_id`),
  ADD PRIMARY KEY (`ISBN`),
  ADD KEY `idx_books_created_at` (`created_at`),
  ADD KEY `idx_books_updated_at` (`updated_at`),
  ADD KEY `idx_books_acquired_at` (`acquired_at`),
  ADD KEY `books_ibfk_2` (`pub_id`);

--
-- Indexes for table `borrower`
--
ALTER TABLE `borrower`
  ADD PRIMARY KEY (`borrower_id`),
  ADD UNIQUE KEY `uq_borrower_user` (`user_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `borrowing_policy`
--
ALTER TABLE `borrowing_policy`
  ADD PRIMARY KEY (`policy_id`);

--
-- Indexes for table `borrows`
--
ALTER TABLE `borrows`
  ADD PRIMARY KEY (`borrow_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `fk_borrows_copy` (`copy_id`),
  ADD KEY `fk_borrows_policy` (`policy_id`),
  ADD KEY `fk_borrows_libstaff` (`libstaff_id`);

--
-- Indexes for table `fines`
--
ALTER TABLE `fines`
  ADD PRIMARY KEY (`fine_id`),
  ADD KEY `libclerk_id` (`libstaff_id`),
  ADD KEY `borrow_id` (`borrow_id`);

--
-- Indexes for table `library_staff`
--
ALTER TABLE `library_staff`
  ADD PRIMARY KEY (`libstaff_id`),
  ADD UNIQUE KEY `uq_libstaff_user` (`user_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `periodicals`
--
ALTER TABLE `periodicals`
  ADD PRIMARY KEY (`ISSN`),
  ADD UNIQUE KEY `uq_periodicals_pub_id` (`pub_id`),
  ADD KEY `idx_periodicals_created_at` (`created_at`),
  ADD KEY `idx_periodicals_updated_at` (`updated_at`),
  ADD KEY `idx_periodicals_acquired_at` (`acquired_at`),
  ADD KEY `fk_periodicals_publication` (`pub_id`);

--
-- Indexes for table `pub author`
--
ALTER TABLE `pub author`
  ADD PRIMARY KEY (`pub_id`, `author_id`),
  ADD KEY `author_id` (`author_id`);

--
-- Indexes for table `pub copies`
--
ALTER TABLE `pub copies`
  ADD PRIMARY KEY (`copy_id`),
  ADD KEY `pub_id` (`pub_id`),
  ADD KEY `fk_pubcopies_status` (`status_id`);

--
-- Indexes for table `publication`
--
ALTER TABLE `publication`
  ADD PRIMARY KEY (`pub_id`);

--
-- Indexes for table `reports`
--
ALTER TABLE `reports`
  ADD KEY `libclerk_id` (`libstaff_id`);

--
-- Indexes for table `status`
--
ALTER TABLE `status`
  ADD PRIMARY KEY (`status_id`),
  ADD KEY `libclerk_id` (`libstaff_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`user_id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `books`
--
ALTER TABLE `books`
  ADD CONSTRAINT `fk_books_publication_cascade` FOREIGN KEY (`pub_id`) REFERENCES `publication` (`pub_id`) ON UPDATE CASCADE;

--
-- Constraints for table `borrower`
--
ALTER TABLE `borrower`
  ADD CONSTRAINT `fk_borrower_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

--
-- Constraints for table `borrows`
--
ALTER TABLE `borrows`
  ADD CONSTRAINT `fk_borrows_copy` FOREIGN KEY (`copy_id`) REFERENCES `pub copies` (`copy_id`),
  ADD CONSTRAINT `fk_borrows_libstaff` FOREIGN KEY (`libstaff_id`) REFERENCES `library_staff` (`libstaff_id`),
  ADD CONSTRAINT `fk_borrows_policy` FOREIGN KEY (`policy_id`) REFERENCES `borrowing_policy` (`policy_id`),
  ADD CONSTRAINT `fk_borrows_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

--
-- Constraints for table `fines`
--
ALTER TABLE `fines`
  ADD CONSTRAINT `fk_fines_borrow` FOREIGN KEY (`borrow_id`) REFERENCES `borrows` (`borrow_id`),
  ADD CONSTRAINT `fk_fines_libstaff` FOREIGN KEY (`libstaff_id`) REFERENCES `library_staff` (`libstaff_id`);

--
-- Constraints for table `library_staff`
--
ALTER TABLE `library_staff`
  ADD CONSTRAINT `fk_libstaff_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `periodicals`
--
ALTER TABLE `periodicals`
  ADD CONSTRAINT `fk_periodicals_publication_cascade` FOREIGN KEY (`pub_id`) REFERENCES `publication` (`pub_id`) ON UPDATE CASCADE;

--
-- Constraints for table `pub author`
--
ALTER TABLE `pub author`
  ADD CONSTRAINT `fk_pubauthor_author` FOREIGN KEY (`author_id`) REFERENCES `author` (`author_id`),
  ADD CONSTRAINT `fk_pubauthor_publication_cascade` FOREIGN KEY (`pub_id`) REFERENCES `publication` (`pub_id`) ON UPDATE CASCADE;

--
-- Constraints for table `pub copies`
--
ALTER TABLE `pub copies`
  ADD CONSTRAINT `fk_pubcopies_publication_cascade` FOREIGN KEY (`pub_id`) REFERENCES `publication` (`pub_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pubcopies_status` FOREIGN KEY (`status_id`) REFERENCES `status` (`status_id`);

--
-- Constraints for table `reports`
--
ALTER TABLE `reports`
  ADD CONSTRAINT `fk_reports_libstaff` FOREIGN KEY (`libstaff_id`) REFERENCES `library_staff` (`libstaff_id`);

--
-- Constraints for table `status`
--
ALTER TABLE `status`
  ADD CONSTRAINT `fk_status_libstaff` FOREIGN KEY (`libstaff_id`) REFERENCES `library_staff` (`libstaff_id`);

UPDATE `books` SET `ISBN` = CONCAT('ISBN-', `ISBN`) WHERE `ISBN` NOT LIKE 'ISBN-%';
ALTER TABLE `books` ADD CONSTRAINT `chk_books_isbn`
  CHECK (`ISBN` REGEXP '^ISBN-[A-Za-z0-9][A-Za-z0-9 ./-]*$');

SET FOREIGN_KEY_CHECKS = 0;
UPDATE `borrows` SET `borrow_id` = CONCAT('TRX', SUBSTRING(`borrow_id`, 4));
UPDATE `fines` SET `borrow_id` = CONCAT('TRX', SUBSTRING(`borrow_id`, 4));
SET FOREIGN_KEY_CHECKS = 1;

UPDATE `borrows` SET
  `copy_id` = CONCAT('COPY', LPAD(CAST(SUBSTRING(`borrow_id`, 4) AS UNSIGNED), 3, '0')),
  `policy_id` = 'POL001',
  `libstaff_id` = IF(CAST(SUBSTRING(`borrow_id`, 4) AS UNSIGNED) % 2 = 1, 'LIB001', 'LIB002');
UPDATE `borrows` SET `copy_id` = 'COPY022' WHERE `borrow_id` = 'TRX020';
UPDATE `borrows` SET `copy_id` = 'COPY094' WHERE `borrow_id` = 'TRX013';
UPDATE `borrows` SET `date_returned` = `due_date`
  WHERE `date_returned` IS NULL AND `borrow_id` NOT IN ('TRX043', 'TRX044', 'TRX045');
ALTER TABLE `borrows`
  MODIFY `copy_id` varchar(20) NOT NULL,
  MODIFY `policy_id` varchar(20) NOT NULL,
  MODIFY `libstaff_id` varchar(20) NOT NULL;

UPDATE `borrower` SET `borrower_type` = 'Community Resident';
ALTER TABLE `borrower` ADD CONSTRAINT `chk_borrower_type`
  CHECK (`borrower_type` in ('Student','Teacher','Researcher','Community Resident','Other'));

UPDATE `status` SET `status_type` = 'Available';
INSERT INTO `status` (`status_id`, `status_type`, `libstaff_id`, `condition`) VALUES
('110101', 'Available', 'LIB001', 'Good'),
('110102', 'Available', 'LIB002', 'Good'),
('110103', 'Available', 'LIB001', 'Good'),
('110104', 'Available', 'LIB002', 'Good'),
('110105', 'Available', 'LIB001', 'Good'),
('110106', 'Available', 'LIB002', 'Good'),
('110107', 'Available', 'LIB001', 'Good'),
('110108', 'Available', 'LIB002', 'Good'),
('110109', 'Available', 'LIB001', 'Good'),
('110110', 'Available', 'LIB002', 'Good'),
('110111', 'Available', 'LIB001', 'Good'),
('110112', 'Available', 'LIB002', 'Good'),
('110113', 'Available', 'LIB001', 'Good'),
('110114', 'Available', 'LIB002', 'Good'),
('110115', 'Available', 'LIB001', 'Good'),
('110116', 'Available', 'LIB002', 'Good'),
('110117', 'Available', 'LIB001', 'Good'),
('110118', 'Available', 'LIB002', 'Good'),
('110119', 'Available', 'LIB001', 'Good'),
('110120', 'Available', 'LIB002', 'Good'),
('110121', 'Available', 'LIB001', 'Good'),
('110122', 'Available', 'LIB002', 'Good'),
('110123', 'Available', 'LIB001', 'Good'),
('110124', 'Available', 'LIB002', 'Good'),
('110125', 'Available', 'LIB001', 'Good'),
('110126', 'Available', 'LIB002', 'Good'),
('110127', 'Available', 'LIB001', 'Good'),
('110128', 'Available', 'LIB002', 'Good'),
('110129', 'Available', 'LIB001', 'Good'),
('110130', 'Available', 'LIB002', 'Good');
UPDATE `pub copies` SET `status_id` = CAST(110000 + CAST(SUBSTRING(`copy_id`, 5) AS UNSIGNED) AS CHAR);
UPDATE `status` SET `status_type` = 'Borrowed' WHERE `status_id` IN ('110043', '110044', '110045');
ALTER TABLE `status` ADD CONSTRAINT `chk_status_type`
  CHECK (`status_type` in ('Available','Borrowed','Under Maintenance'));
COMMIT;

DELIMITER $$

CREATE FUNCTION `fn_hours_late`(p_due DATETIME, p_end DATETIME) RETURNS INT
DETERMINISTIC
BEGIN
  IF p_due IS NULL OR p_end IS NULL OR p_end <= p_due THEN
    RETURN 0;
  END IF;
  RETURN FLOOR(TIMESTAMPDIFF(SECOND, p_due, p_end) / 3600);
END$$

CREATE FUNCTION `fn_calc_fine`(p_due DATETIME, p_end DATETIME, p_rate DECIMAL(10,2)) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  RETURN fn_hours_late(p_due, p_end) * p_rate;
END$$

DELIMITER ;

CREATE VIEW `v_overdue_borrows` AS
SELECT
  b.`borrow_id` AS `transaction_id`,
  br.`borrower_id`,
  CONCAT(u.`user_fname`, ' ', u.`user_lname`) AS `borrower_name`,
  b.`copy_id`,
  p.`title`,
  b.`due_date`,
  fn_hours_late(b.`due_date`, NOW()) AS `hours_late`,
  fn_calc_fine(b.`due_date`, NOW(), bp.`fine_rate_per_hour`) AS `live_fine`
FROM `borrows` b
JOIN `borrower` br ON br.`user_id` = b.`user_id`
JOIN `user` u ON u.`user_id` = b.`user_id`
JOIN `pub copies` pc ON pc.`copy_id` = b.`copy_id`
JOIN `publication` p ON p.`pub_id` = pc.`pub_id`
JOIN `borrowing_policy` bp ON bp.`policy_id` = b.`policy_id`
WHERE b.`date_returned` IS NULL AND b.`due_date` < NOW();

CREATE VIEW `v_borrower_status` AS
SELECT
  br.`borrower_id`,
  br.`user_id`,
  CONCAT(u.`user_fname`, ' ', u.`user_lname`) AS `borrower_name`,
  br.`borrower_type`,
  (SELECT COUNT(*) FROM `borrows` b
    WHERE b.`user_id` = br.`user_id` AND b.`date_returned` IS NULL) AS `active_borrows`,
  (SELECT COUNT(*) FROM `borrows` b
    WHERE b.`user_id` = br.`user_id` AND b.`date_returned` IS NULL AND b.`due_date` < NOW()) AS `overdue_count`,
  (SELECT COALESCE(SUM(f.`amount`), 0) FROM `fines` f
    JOIN `borrows` b ON b.`borrow_id` = f.`borrow_id`
    WHERE b.`user_id` = br.`user_id` AND f.`status` = 'Unpaid') AS `unpaid_fine_total`
FROM `borrower` br
JOIN `user` u ON u.`user_id` = br.`user_id`;

DELIMITER $$

CREATE PROCEDURE `sp_borrow`(IN p_borrower_id VARCHAR(10), IN p_copy_id VARCHAR(20), IN p_libstaff_id VARCHAR(20))
BEGIN
  DECLARE v_user_id INT DEFAULT NULL;
  DECLARE v_status_type VARCHAR(30) DEFAULT NULL;
  DECLARE v_condition VARCHAR(50) DEFAULT NULL;
  DECLARE v_unpaid DECIMAL(10,2) DEFAULT 0;
  DECLARE v_overdue INT DEFAULT 0;
  DECLARE v_active INT DEFAULT 0;
  DECLARE v_policy VARCHAR(20) DEFAULT NULL;
  DECLARE v_max INT DEFAULT 0;
  DECLARE v_days INT DEFAULT 0;
  DECLARE v_next INT DEFAULT 0;
  DECLARE v_id VARCHAR(20);
  DECLARE v_now DATETIME;
  DECLARE v_due DATETIME;
  DECLARE v_msg VARCHAR(255) DEFAULT NULL;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;
  START TRANSACTION;
  SELECT `user_id` INTO v_user_id FROM `borrower` WHERE `borrower_id` = p_borrower_id;
  IF v_user_id IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Borrower not found.';
  END IF;
  SELECT s.`status_type`, s.`condition` INTO v_status_type, v_condition
    FROM `pub copies` pc JOIN `status` s ON s.`status_id` = pc.`status_id`
    WHERE pc.`copy_id` = p_copy_id FOR UPDATE;
  IF v_status_type IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Copy not found.';
  END IF;
  IF v_status_type <> 'Available' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Copy is not available.';
  END IF;
  IF v_condition = 'Damaged' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Copy is damaged and cannot be borrowed.';
  END IF;
  SELECT COALESCE(SUM(f.`amount`), 0) INTO v_unpaid
    FROM `fines` f JOIN `borrows` b ON b.`borrow_id` = f.`borrow_id`
    WHERE b.`user_id` = v_user_id AND f.`status` = 'Unpaid';
  IF v_unpaid > 0 THEN
    SET v_msg = CONCAT('Borrower has an unpaid fine of ', FORMAT(v_unpaid, 2), '.');
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_msg;
  END IF;
  SELECT COUNT(*) INTO v_overdue FROM `borrows`
    WHERE `user_id` = v_user_id AND `date_returned` IS NULL AND `due_date` < NOW();
  IF v_overdue > 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Borrower has an overdue book that has not been returned.';
  END IF;
  SELECT `policy_id`, `max_books_allowed`, `loan_duration_days` INTO v_policy, v_max, v_days
    FROM `borrowing_policy` ORDER BY `policy_id` LIMIT 1;
  SELECT COUNT(*) INTO v_active FROM `borrows`
    WHERE `user_id` = v_user_id AND `date_returned` IS NULL;
  IF v_active >= v_max THEN
    SET v_msg = CONCAT('Borrower has reached the maximum of ', v_max, ' books.');
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_msg;
  END IF;
  SELECT COALESCE(MAX(CAST(SUBSTRING(`borrow_id`, 4) AS UNSIGNED)), 0) + 1 INTO v_next FROM `borrows` FOR UPDATE;
  SET v_id = CONCAT('TRX', LPAD(v_next, 3, '0'));
  SET v_now = NOW();
  SET v_due = DATE_ADD(v_now, INTERVAL v_days DAY);
  INSERT INTO `borrows` (`borrow_id`, `user_id`, `date_borrowed`, `date_returned`, `due_date`, `copy_id`, `policy_id`, `libstaff_id`)
    VALUES (v_id, v_user_id, v_now, NULL, v_due, p_copy_id, v_policy, p_libstaff_id);
  UPDATE `status` SET `status_type` = 'Borrowed'
    WHERE `status_id` = (SELECT `status_id` FROM `pub copies` WHERE `copy_id` = p_copy_id);
  COMMIT;
  SELECT v_id AS `transaction_id`, v_due AS `due_date`;
END$$

CREATE PROCEDURE `sp_return`(IN p_borrow_id VARCHAR(20), IN p_libstaff_id VARCHAR(20))
BEGIN
  DECLARE v_copy VARCHAR(20) DEFAULT NULL;
  DECLARE v_returned DATETIME DEFAULT NULL;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    SET @return_staff_id = NULL;
    ROLLBACK;
    RESIGNAL;
  END;
  START TRANSACTION;
  SELECT `copy_id`, `date_returned` INTO v_copy, v_returned
    FROM `borrows` WHERE `borrow_id` = p_borrow_id FOR UPDATE;
  IF v_copy IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaction not found.';
  END IF;
  IF v_returned IS NOT NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Book was already returned.';
  END IF;
  SET @return_staff_id = p_libstaff_id;
  UPDATE `borrows` SET `date_returned` = NOW() WHERE `borrow_id` = p_borrow_id;
  UPDATE `status` SET `status_type` = 'Available'
    WHERE `status_id` = (SELECT `status_id` FROM `pub copies` WHERE `copy_id` = v_copy);
  SET @return_staff_id = NULL;
  COMMIT;
  SELECT b.`borrow_id` AS `transaction_id`, b.`date_returned`, f.`fine_id`, f.`hours_late`,
         COALESCE(f.`amount`, 0) AS `fine_amount`
    FROM `borrows` b LEFT JOIN `fines` f ON f.`borrow_id` = b.`borrow_id`
    WHERE b.`borrow_id` = p_borrow_id;
END$$

CREATE PROCEDURE `sp_pay_fine`(IN p_fine_id VARCHAR(30))
BEGIN
  DECLARE v_status VARCHAR(10) DEFAULT NULL;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;
  START TRANSACTION;
  SELECT `status` INTO v_status FROM `fines` WHERE `fine_id` = p_fine_id FOR UPDATE;
  IF v_status IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Fine not found.';
  END IF;
  IF v_status = 'Paid' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Fine is already paid.';
  END IF;
  UPDATE `fines` SET `status` = 'Paid', `date_paid` = NOW() WHERE `fine_id` = p_fine_id;
  COMMIT;
  SELECT `fine_id`, `status`, `date_paid` FROM `fines` WHERE `fine_id` = p_fine_id;
END$$

CREATE TRIGGER `trg_borrows_after_return` AFTER UPDATE ON `borrows`
FOR EACH ROW
BEGIN
  DECLARE v_hours INT;
  DECLARE v_rate DECIMAL(10,2);
  DECLARE v_next INT;
  IF OLD.`date_returned` IS NULL AND NEW.`date_returned` IS NOT NULL THEN
    SET v_hours = fn_hours_late(NEW.`due_date`, NEW.`date_returned`);
    IF v_hours >= 1 THEN
      SELECT `fine_rate_per_hour` INTO v_rate FROM `borrowing_policy` WHERE `policy_id` = NEW.`policy_id`;
      SELECT COALESCE(MAX(CAST(SUBSTRING(`fine_id`, 3) AS UNSIGNED)), 0) + 1 INTO v_next FROM `fines` FOR UPDATE;
      INSERT INTO `fines` (`fine_id`, `libstaff_id`, `borrow_id`, `amount`, `hours_late`, `rate_applied`, `date_assessed`, `status`, `date_paid`)
        VALUES (CONCAT('FN', LPAD(v_next, 3, '0')), COALESCE(@return_staff_id, NEW.`libstaff_id`), NEW.`borrow_id`,
                fn_calc_fine(NEW.`due_date`, NEW.`date_returned`, v_rate), v_hours, v_rate, NOW(), 'Unpaid', NULL);
    END IF;
  END IF;
END$$

CREATE PROCEDURE `sp_register_borrower`(
  IN p_fname VARCHAR(50), IN p_lname VARCHAR(50), IN p_mid VARCHAR(50), IN p_birth DATE,
  IN p_gender VARCHAR(10), IN p_brgy VARCHAR(100), IN p_municipality VARCHAR(100),
  IN p_province VARCHAR(100), IN p_email VARCHAR(100), IN p_category VARCHAR(30),
  IN p_id_type VARCHAR(100), IN p_id_number VARCHAR(30))
BEGIN
  DECLARE v_exists INT DEFAULT 0;
  DECLARE v_user_next INT DEFAULT 0;
  DECLARE v_bor_next INT DEFAULT 0;
  DECLARE v_borrower_id VARCHAR(10);
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;
  IF NULLIF(TRIM(p_fname), '') IS NULL OR NULLIF(TRIM(p_lname), '') IS NULL
     OR p_birth IS NULL OR NULLIF(TRIM(p_gender), '') IS NULL
     OR NULLIF(TRIM(p_category), '') IS NULL OR NULLIF(TRIM(p_id_type), '') IS NULL
     OR NULLIF(TRIM(p_id_number), '') IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Required field missing.';
  END IF;
  IF p_category NOT IN ('Student', 'Teacher', 'Researcher', 'Community Resident', 'Other') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid borrower category.';
  END IF;
  START TRANSACTION;
  SELECT COUNT(*) INTO v_exists FROM `borrower`
    WHERE `ID_type` = TRIM(p_id_type) AND `ID_number` = TRIM(p_id_number) FOR UPDATE;
  IF v_exists > 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A borrower with this ID type and number already exists.';
  END IF;
  SELECT COALESCE(MAX(`user_id`), 100000) + 1 INTO v_user_next FROM `user` FOR UPDATE;
  SELECT COALESCE(MAX(CAST(SUBSTRING(`borrower_id`, 4) AS UNSIGNED)), 0) + 1 INTO v_bor_next FROM `borrower` FOR UPDATE;
  SET v_borrower_id = CONCAT('BOR', LPAD(v_bor_next, 3, '0'));
  INSERT INTO `user` (`user_id`, `user_fname`, `user_lname`, `user_midInit`, `birth_date`, `gender`, `email`,
                      `user_type`, `user_brgy`, `user_municipality`, `user_province`)
    VALUES (v_user_next, TRIM(p_fname), TRIM(p_lname), NULLIF(TRIM(p_mid), ''), p_birth, TRIM(p_gender),
            NULLIF(TRIM(p_email), ''), 'Borrower', NULLIF(TRIM(p_brgy), ''),
            NULLIF(TRIM(p_municipality), ''), NULLIF(TRIM(p_province), ''));
  INSERT INTO `borrower` (`borrower_id`, `user_id`, `borrower_type`, `ID_type`, `ID_number`)
    VALUES (v_borrower_id, v_user_next, p_category, TRIM(p_id_type), TRIM(p_id_number));
  COMMIT;
  SELECT v_borrower_id AS `borrower_id`;
END$$

DELIMITER ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

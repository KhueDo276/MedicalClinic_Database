SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;


DROP TABLE IF EXISTS `appointment`;
CREATE TABLE `appointment` (
  `patient_id` int(11) NOT NULL,
  `DATE` varchar(10) NOT NULL,
  `CLINIC_ID` int(11) NOT NULL,
  `Doctor` int(11) NOT NULL,
  `Reason` varchar(45) DEFAULT NULL,
  `Time` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `appointment` (`patient_id`, `DATE`, `CLINIC_ID`, `Doctor`, `Reason`, `Time`) VALUES
(1234607, '2022-11-30', 7, 476385, 'cough', '11:30:00'),
(1234608, '2022-12-27', 102, 476385, 'Tummy ache', '10:00:00'),
(1234609, '2022-12-27', 7, 476385, 'Tummy ache', '10:00:00');
DROP TRIGGER IF EXISTS `BillLimit`;
DELIMITER $$
CREATE TRIGGER `BillLimit` BEFORE INSERT ON `appointment` FOR EACH ROW BEGIN

IF (SELECT COUNT(*) FROM bills WHERE Oid = NEW.patient_id AND paid = 0) > 4 
THEN
BEGIN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Too many outstanding bills to make new appointment';
END;
END IF;
END
$$
DELIMITER ;

DROP TABLE IF EXISTS `availability`;
CREATE TABLE `availability` (
  `D_ID` int(11) NOT NULL,
  `Monday` int(11) DEFAULT NULL COMMENT 'Shows clinic id',
  `Tuesday` int(11) DEFAULT NULL COMMENT 'Shows clinic id',
  `Wednesday` int(11) DEFAULT NULL COMMENT 'Shows clinic id',
  `Thursday` int(11) DEFAULT NULL COMMENT 'Shows clinic id',
  `Friday` int(11) DEFAULT NULL COMMENT 'Shows clinic id'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `availability` (`D_ID`, `Monday`, `Tuesday`, `Wednesday`, `Thursday`, `Friday`) VALUES
(342786, 101, 101, 7, 101, 103),
(476385, 7, 101, 7, 7, 7),
(3456789, 7, 7, 103, 102, 101);

DROP TABLE IF EXISTS `bills`;
CREATE TABLE `bills` (
  `bill_id` int(11) NOT NULL,
  `Oid` int(11) NOT NULL,
  `clinic_id` int(11) NOT NULL,
  `Due_date` varchar(10) NOT NULL,
  `paid_date` date NOT NULL DEFAULT '0000-00-00',
  `paid` tinyint(1) NOT NULL DEFAULT '0',
  `Amount` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `bills` (`bill_id`, `Oid`, `clinic_id`, `Due_date`, `paid_date`, `paid`, `Amount`) VALUES
(107, 1234607, 7, '2022-11-29', '2022-11-28', 1, 1222),
(103, 1234607, 7, '2022-11-30', '2022-11-28', 1, 100),
(110, 1234607, 7, '2022-12-01', '2022-11-28', 1, 1000),
(111, 1234607, 7, '2022-12-02', '2022-11-28', 1, 1000),
(112, 1234607, 7, '2022-12-03', '2022-11-28', 1, 1000),
(4, 1234607, 103, '2022-12-31', '2022-11-28', 1, 55),
(102, 1234608, 7, '2022-11-28', '0000-00-00', 0, 12000),
(5, 1234608, 103, '2022-12-31', '2022-11-26', 1, 40);

DROP TABLE IF EXISTS `clinics`;
CREATE TABLE `clinics` (
  `Clinic_Id` int(11) NOT NULL,
  `Adress` varchar(45) NOT NULL,
  `Phone_Number` bigint(15) UNSIGNED NOT NULL,
  `Name` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `clinics` (`Clinic_Id`, `Adress`, `Phone_Number`, `Name`) VALUES
(7, '143 Seafoam Blv.', 8323983445, 'Feel Better Clinic'),
(101, '8 Raod, Houston TX', 1112223333, 'Clinic 1'),
(102, '3 Street, The Woodlands TX', 4445556666, 'Clinic 2'),
(103, '6 Boulevard, Conroe TX', 7778889999, 'Clinic 3');

DROP TABLE IF EXISTS `doctors`;
CREATE TABLE `doctors` (
  `DoctorID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `doctors` (`DoctorID`) VALUES
(342786),
(476385),
(3456789);

DROP TABLE IF EXISTS `e dependent`;
CREATE TABLE `e dependent` (
  `First_Name` varchar(20) NOT NULL,
  `Middle_I` char(1) DEFAULT NULL,
  `Last_Name` varchar(20) NOT NULL,
  `E_Employee ID` int(11) NOT NULL,
  `DOB` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `emergency contact`;
CREATE TABLE `emergency contact` (
  `Pid` int(11) NOT NULL,
  `EC_First_Name` varchar(45) NOT NULL,
  `EC_Last_Name` varchar(45) NOT NULL,
  `EC_Email` varchar(45) DEFAULT NULL,
  `EC_Phone` int(11) NOT NULL,
  `Relation` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `employees`;
CREATE TABLE `employees` (
  `First_Name` varchar(20) NOT NULL,
  `Middle_I` char(1) DEFAULT NULL,
  `Last_Name` varchar(20) DEFAULT NULL,
  `Employee_ID` int(11) NOT NULL,
  `Salary` int(11) NOT NULL,
  `Sex` binary(1) DEFAULT NULL,
  `Ethnicity` varchar(45) DEFAULT NULL,
  `SSN` int(4) NOT NULL,
  `Type` varchar(6) NOT NULL,
  `email` varchar(45) NOT NULL,
  `Phone_Number` bigint(11) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `employees` (`First_Name`, `Middle_I`, `Last_Name`, `Employee_ID`, `Salary`, `Sex`, `Ethnicity`, `SSN`, `Type`, `email`, `Phone_Number`) VALUES
('Jesus', 'M', 'Salazar', 342786, 40000, 0x4d, 'Hispanic', 6758, 'Doctor', 'Jesus@gmail.com', 5555555),
('bob', 't', 'builder', 476385, 653, 0x4d, 'alien', 4532, 'Doctor', 'bob@thebuilder.com', 7135747489),
('Khue', 'N', 'Do', 2095733, 100000, 0x46, 'Asian', 6311, 'Other', 'nhatkhue1997@gmail.com', 8321151213),
('Lucas', '', 'Bartlett', 2095738, 89000, 0x4d, 'White', 6782, 'Nurse', 'lucas@gmail.com', 8323716190),
('John', 'S', 'Smithy', 3456789, 20000, 0x4d, 'White', 3456, 'Doctor', 'Smithy@gmail.com', 12348);
DROP TRIGGER IF EXISTS `usernamecreation2`;
DELIMITER $$
CREATE TRIGGER `usernamecreation2` AFTER INSERT ON `employees` FOR EACH ROW BEGIN
IF NEW.Type = "Doctor" Then
INSERT INTO login(username,password,role) VALUES (NEW.Employee_ID,CONCAT(NEW.Last_Name,NEW.SSN),NEW.Type);
INSERT INTO doctors(DoctorID) VALUES (NEW.Employee_ID);
END IF;
END
$$
DELIMITER ;

DROP TABLE IF EXISTS `login`;
CREATE TABLE `login` (
  `username` varchar(100) NOT NULL,
  `password` varchar(50) NOT NULL,
  `role` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `login` (`username`, `password`, `role`) VALUES
('1234607', '1111', 'Patient'),
('1234609', '1234', 'Patient'),
('342786', 'Salazar6758', 'Doctor'),
('3456789', 'Smithy3456', 'Doctor'),
('476385', 'builder4532', 'Doctor'),
('admin', '1234', 'Administrator');

DROP TABLE IF EXISTS `patient`;
CREATE TABLE `patient` (
  `First_Name` varchar(20) NOT NULL,
  `Middle_Initial` char(1) DEFAULT NULL,
  `Last_Name` varchar(20) NOT NULL,
  `DOB` varchar(10) NOT NULL,
  `Patient_ID` int(11) NOT NULL,
  `Last_4_SSN` smallint(6) NOT NULL,
  `Weight` double NOT NULL,
  `Height` smallint(6) NOT NULL,
  `Sex` binary(1) NOT NULL,
  `Ethnicity` varchar(45) NOT NULL,
  `Pharmacist_Phone` bigint(11) NOT NULL,
  `Pharmacist_Address` varchar(45) NOT NULL,
  `Insurance_ID` int(11) DEFAULT NULL,
  `Insurance_Name` varchar(45) DEFAULT NULL,
  `Phone_Number` bigint(11) UNSIGNED NOT NULL,
  `Email` varchar(45) DEFAULT NULL,
  `Address` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `patient` (`First_Name`, `Middle_Initial`, `Last_Name`, `DOB`, `Patient_ID`, `Last_4_SSN`, `Weight`, `Height`, `Sex`, `Ethnicity`, `Pharmacist_Phone`, `Pharmacist_Address`, `Insurance_ID`, `Insurance_Name`, `Phone_Number`, `Email`, `Address`) VALUES
('John', '', 'Smith', '2000-10-01', 1234607, 1235, 123, 6, 0x30, 'White', 54238907, 'Houston', 1236, 'BlueCross', 712418123, 'entkideste@gmail.com', 'Houston'),
('Esteban', 'J', 'Perez', '1940-11-22', 1234608, 8989, 123, 6, 0x30, 'White', 2134256, 'asd341', 12464, 'Bluecross', 12345, 'entkideste@gmail.com', 'hello it;s me'),
('Kevin', 'N', 'Nguyen', '2015-02-02', 1234609, 7890, 150, 175, 0x30, 'Black', 8327739797, '1111', 1235, 'BlueCross', 8321563245, 'kevin@gmail.com', 'Sugar Land');

DROP TABLE IF EXISTS `patientassigneddoctor`;
CREATE TABLE `patientassigneddoctor` (
  `Doctor` int(11) NOT NULL,
  `Patient` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `patientassigneddoctor` (`Doctor`, `Patient`) VALUES
(342786, 1234608),
(3456789, 1234607),
(3456789, 1234609);

DROP TABLE IF EXISTS `prescription`;
CREATE TABLE `prescription` (
  `Patient_ID` int(11) NOT NULL,
  `Prescriber_ID` int(11) NOT NULL,
  `Medicine_Name` varchar(45) NOT NULL,
  `Amount` smallint(6) NOT NULL,
  `Refills_Left` smallint(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `referrals`;
CREATE TABLE `referrals` (
  `ref_id` int(11) NOT NULL,
  `Patient` int(11) NOT NULL,
  `Doctor` int(11) NOT NULL,
  `Receiving_Doctor` int(11) NOT NULL,
  `Address_Id` int(11) NOT NULL,
  `Approval` tinyint(1) NOT NULL DEFAULT '0',
  `DATE` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `referrals` (`ref_id`, `Patient`, `Doctor`, `Receiving_Doctor`, `Address_Id`, `Approval`, `DATE`) VALUES
(17, 1234607, 342786, 476385, 7, 0, '2022-11-28'),
(16, 1234607, 342786, 476385, 7, 0, '2022-11-30'),
(18, 1234607, 342786, 3456789, 7, 1, '2022-11-28');
DROP TRIGGER IF EXISTS `ReferralTrigger`;
DELIMITER $$
CREATE TRIGGER `ReferralTrigger` BEFORE INSERT ON `referrals` FOR EACH ROW BEGIN

IF (SELECT COUNT(*) FROM referrals WHERE Patient = NEW.Patient and Receiving_Doctor = NEW.Receiving_Doctor AND Doctor = NEW.Doctor AND Address_Id = NEW.Address_Id) >= 2 
THEN
BEGIN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'YOU HAVE TRIED TO REQUEST A REFERRAL TWICE, CALL YOUR DOCTOR';
END;
END IF;
END
$$
DELIMITER ;

DROP TABLE IF EXISTS `work_on`;
CREATE TABLE `work_on` (
  `Doctor_ID` int(11) NOT NULL,
  `Clinic_ID` int(11) NOT NULL,
  `Hours_Worked` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


ALTER TABLE `appointment`
  ADD PRIMARY KEY (`patient_id`,`DATE`,`CLINIC_ID`,`Doctor`,`Time`),
  ADD KEY `fuckyou` (`CLINIC_ID`),
  ADD KEY `killme` (`Doctor`);

ALTER TABLE `availability`
  ADD UNIQUE KEY `D_ID` (`D_ID`),
  ADD KEY `momday` (`Tuesday`),
  ADD KEY `wnedsawqd` (`Monday`),
  ADD KEY `dasd` (`Wednesday`),
  ADD KEY `dasawd` (`Thursday`),
  ADD KEY `dvszxc` (`Friday`);

ALTER TABLE `bills`
  ADD PRIMARY KEY (`Oid`,`clinic_id`,`Due_date`),
  ADD UNIQUE KEY `bill_id` (`bill_id`);

ALTER TABLE `clinics`
  ADD PRIMARY KEY (`Clinic_Id`);

ALTER TABLE `doctors`
  ADD PRIMARY KEY (`DoctorID`);

ALTER TABLE `e dependent`
  ADD KEY `E Employee ID_idx` (`E_Employee ID`);

ALTER TABLE `emergency contact`
  ADD PRIMARY KEY (`Pid`);

ALTER TABLE `employees`
  ADD PRIMARY KEY (`Employee_ID`),
  ADD UNIQUE KEY `Social Security` (`SSN`),
  ADD UNIQUE KEY `Employee ID` (`Employee_ID`);

ALTER TABLE `login`
  ADD PRIMARY KEY (`username`);

ALTER TABLE `patient`
  ADD PRIMARY KEY (`Patient_ID`),
  ADD UNIQUE KEY `patient ID_UNIQUE` (`Patient_ID`),
  ADD UNIQUE KEY `Last 4 SSN_UNIQUE` (`Last_4_SSN`);

ALTER TABLE `patientassigneddoctor`
  ADD PRIMARY KEY (`Doctor`,`Patient`),
  ADD KEY `test` (`Doctor`),
  ADD KEY `test2` (`Patient`);

ALTER TABLE `prescription`
  ADD PRIMARY KEY (`Patient_ID`,`Prescriber_ID`),
  ADD KEY `Doctor ID_idx` (`Prescriber_ID`);

ALTER TABLE `referrals`
  ADD PRIMARY KEY (`Patient`,`Doctor`,`Receiving_Doctor`,`Address_Id`,`DATE`),
  ADD UNIQUE KEY `ref_unique` (`ref_id`),
  ADD KEY `doctor_idx` (`Doctor`),
  ADD KEY `receiving doctor_idx` (`Receiving_Doctor`),
  ADD KEY `Adress ID_idx` (`Address_Id`);

ALTER TABLE `work_on`
  ADD PRIMARY KEY (`Doctor_ID`,`Clinic_ID`),
  ADD KEY `Clinic ID_idx` (`Clinic_ID`);


ALTER TABLE `bills`
  MODIFY `bill_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=113;
ALTER TABLE `patient`
  MODIFY `Patient_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1234610;
ALTER TABLE `referrals`
  MODIFY `ref_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

ALTER TABLE `appointment`
  ADD CONSTRAINT `deawd` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`Patient_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fuckyou` FOREIGN KEY (`CLINIC_ID`) REFERENCES `clinics` (`Clinic_Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `killme` FOREIGN KEY (`Doctor`) REFERENCES `doctors` (`DoctorID`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `availability`
  ADD CONSTRAINT `Dr_availibility` FOREIGN KEY (`D_ID`) REFERENCES `doctors` (`DoctorID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `dasawd` FOREIGN KEY (`Thursday`) REFERENCES `clinics` (`Clinic_Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `dasd` FOREIGN KEY (`Wednesday`) REFERENCES `clinics` (`Clinic_Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `dvszxc` FOREIGN KEY (`Friday`) REFERENCES `clinics` (`Clinic_Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `momday` FOREIGN KEY (`Tuesday`) REFERENCES `clinics` (`Clinic_Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `wnedsawqd` FOREIGN KEY (`Monday`) REFERENCES `clinics` (`Clinic_Id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `bills`
  ADD CONSTRAINT `Oid` FOREIGN KEY (`Oid`) REFERENCES `patient` (`Patient_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `doctors`
  ADD CONSTRAINT `www` FOREIGN KEY (`DoctorID`) REFERENCES `employees` (`Employee_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `e dependent`
  ADD CONSTRAINT `E Employee ID` FOREIGN KEY (`E_Employee ID`) REFERENCES `employees` (`Employee_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `emergency contact`
  ADD CONSTRAINT `Pid` FOREIGN KEY (`Pid`) REFERENCES `patient` (`Patient_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `patientassigneddoctor`
  ADD CONSTRAINT `test` FOREIGN KEY (`Doctor`) REFERENCES `doctors` (`DoctorID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `test2` FOREIGN KEY (`Patient`) REFERENCES `patient` (`Patient_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `prescription`
  ADD CONSTRAINT `Patient ID` FOREIGN KEY (`Patient_ID`) REFERENCES `patient` (`Patient_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Prescriber ID` FOREIGN KEY (`Prescriber_ID`) REFERENCES `doctors` (`DoctorID`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `referrals`
  ADD CONSTRAINT `Address ID` FOREIGN KEY (`Address_Id`) REFERENCES `clinics` (`Clinic_Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Doctor` FOREIGN KEY (`Doctor`) REFERENCES `doctors` (`DoctorID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Patient` FOREIGN KEY (`Patient`) REFERENCES `patient` (`Patient_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Receiving Doctor` FOREIGN KEY (`Receiving_Doctor`) REFERENCES `doctors` (`DoctorID`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `work_on`
  ADD CONSTRAINT `Clinic ID` FOREIGN KEY (`Clinic_ID`) REFERENCES `clinics` (`Clinic_Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Doctor ID` FOREIGN KEY (`Doctor_ID`) REFERENCES `doctors` (`DoctorID`) ON DELETE CASCADE ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

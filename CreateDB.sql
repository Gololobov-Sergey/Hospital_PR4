use [master];
go

if db_id('Hospital_PR4') is not null
begin
	drop database [Hospital_PR4];
end
go

CREATE DATABASE Hospital_PR4;
GO

USE Hospital_PR4;
GO

CREATE TABLE Departments
(
    Id   INT IDENTITY(1,1) NOT NULL,
    Name NVARCHAR(100)     NOT NULL
);
GO

CREATE TABLE Doctors
(
    Id      INT IDENTITY(1,1) NOT NULL,
    Name    NVARCHAR(MAX)    NOT NULL,
    Surname NVARCHAR(MAX)    NOT NULL,
    Premium MONEY           NOT NULL,
    Salary  MONEY           NOT NULL
);
GO

CREATE TABLE Specializations
(
    Id   INT IDENTITY(1,1) NOT NULL,
    Name NVARCHAR(100)     NOT NULL
);
GO

CREATE TABLE Sponsors
(
    Id   INT IDENTITY(1,1) NOT NULL,
    Name NVARCHAR(100)     NOT NULL
);
GO

CREATE TABLE DoctorsSpecializations
(
    Id               INT IDENTITY(1,1) NOT NULL,
    DoctorId         INT NOT NULL,
    SpecializationId INT NOT NULL
);
GO

CREATE TABLE Wards
(
    Id           INT IDENTITY(1,1) NOT NULL,
    Name         NVARCHAR(20)      NOT NULL,
    DepartmentId INT               NOT NULL
);
GO

CREATE TABLE Donations
(
    Id           INT IDENTITY(1,1) NOT NULL,
    Amount       MONEY NOT NULL,
    [Date]       DATE  NOT NULL,
    DepartmentId INT   NOT NULL,
    SponsorId    INT   NOT NULL
);
GO

CREATE TABLE Vacations
(
    Id        INT IDENTITY(1,1) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate   DATE NOT NULL,
    DoctorId  INT  NOT NULL
);
GO

ALTER TABLE Doctors
ADD CONSTRAINT DF_Doctors_Premium DEFAULT (0) FOR Premium;

ALTER TABLE Donations
ADD CONSTRAINT DF_Donations_Date
DEFAULT (CAST(GETDATE() AS DATE)) FOR [Date];

ALTER TABLE Departments
ADD CONSTRAINT PK_Departments PRIMARY KEY (Id);

ALTER TABLE Doctors
ADD CONSTRAINT PK_Doctors PRIMARY KEY (Id);

ALTER TABLE Specializations
ADD CONSTRAINT PK_Specializations PRIMARY KEY (Id);

ALTER TABLE Sponsors
ADD CONSTRAINT PK_Sponsors PRIMARY KEY (Id);

ALTER TABLE DoctorsSpecializations
ADD CONSTRAINT PK_DoctorsSpecializations PRIMARY KEY (Id);

ALTER TABLE Wards
ADD CONSTRAINT PK_Wards PRIMARY KEY (Id);

ALTER TABLE Donations
ADD CONSTRAINT PK_Donations PRIMARY KEY (Id);

ALTER TABLE Vacations
ADD CONSTRAINT PK_Vacations PRIMARY KEY (Id);

ALTER TABLE Departments
ADD CONSTRAINT UQ_Departments_Name UNIQUE (Name);

ALTER TABLE Specializations
ADD CONSTRAINT UQ_Specializations_Name UNIQUE (Name);

ALTER TABLE Sponsors
ADD CONSTRAINT UQ_Sponsors_Name UNIQUE (Name);

ALTER TABLE Wards
ADD CONSTRAINT UQ_Wards_Name UNIQUE (Name);

ALTER TABLE DoctorsSpecializations
ADD CONSTRAINT UQ_Doctor_Specialization
UNIQUE (DoctorId, SpecializationId);


ALTER TABLE Departments
ADD CONSTRAINT CK_Departments_Name_NotEmpty
CHECK (LEN(LTRIM(RTRIM(Name))) > 0);

ALTER TABLE Doctors
ADD CONSTRAINT CK_Doctors_Name_NotEmpty
CHECK (LEN(LTRIM(RTRIM(Name))) > 0);

ALTER TABLE Doctors
ADD CONSTRAINT CK_Doctors_Surname_NotEmpty
CHECK (LEN(LTRIM(RTRIM(Surname))) > 0);

ALTER TABLE Doctors
ADD CONSTRAINT CK_Doctors_Premium
CHECK (Premium >= 0);

ALTER TABLE Doctors
ADD CONSTRAINT CK_Doctors_Salary
CHECK (Salary > 0);

ALTER TABLE Specializations
ADD CONSTRAINT CK_Specializations_Name_NotEmpty
CHECK (LEN(LTRIM(RTRIM(Name))) > 0);

ALTER TABLE Sponsors
ADD CONSTRAINT CK_Sponsors_Name_NotEmpty
CHECK (LEN(LTRIM(RTRIM(Name))) > 0);

ALTER TABLE Wards
ADD CONSTRAINT CK_Wards_Name_NotEmpty
CHECK (LEN(LTRIM(RTRIM(Name))) > 0);

ALTER TABLE Donations
ADD CONSTRAINT CK_Donations_Amount
CHECK (Amount > 0);

ALTER TABLE Donations
ADD CONSTRAINT CK_Donations_Date
CHECK ([Date] <= CAST(GETDATE() AS DATE));

ALTER TABLE Vacations
ADD CONSTRAINT CK_Vacations_Dates
CHECK (EndDate > StartDate);

ALTER TABLE DoctorsSpecializations
ADD CONSTRAINT FK_DoctorsSpecializations_Doctors
FOREIGN KEY (DoctorId)
REFERENCES Doctors(Id);

ALTER TABLE DoctorsSpecializations
ADD CONSTRAINT FK_DoctorsSpecializations_Specializations
FOREIGN KEY (SpecializationId)
REFERENCES Specializations(Id);

ALTER TABLE Wards
ADD CONSTRAINT FK_Wards_Departments
FOREIGN KEY (DepartmentId)
REFERENCES Departments(Id);

ALTER TABLE Donations
ADD CONSTRAINT FK_Donations_Departments
FOREIGN KEY (DepartmentId)
REFERENCES Departments(Id);

ALTER TABLE Donations
ADD CONSTRAINT FK_Donations_Sponsors
FOREIGN KEY (SponsorId)
REFERENCES Sponsors(Id);

ALTER TABLE Vacations
ADD CONSTRAINT FK_Vacations_Doctors
FOREIGN KEY (DoctorId)
REFERENCES Doctors(Id);
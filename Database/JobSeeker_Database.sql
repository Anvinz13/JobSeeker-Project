-- ============================================================================
-- Database Script for JobSeeker Portal (Saaa)
-- Compatible with SQL Server 2014, 2016, 2019, 2022, Express, and LocalDB
-- ============================================================================

USE [master];
GO

-- 1. Create Database if it does not already exist
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'Saaa')
BEGIN
    CREATE DATABASE [Saaa];
    PRINT 'Database [Saaa] created successfully.';
END
ELSE
BEGIN
    PRINT 'Database [Saaa] already exists.';
END
GO

USE [Saaa];
GO

-- ============================================================================
-- 2. Create Tables
-- ============================================================================

-- Logintab: Stores authentication credentials and role type ('employee' or 'company')
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Logintab]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Logintab](
        [Login_id] INT IDENTITY(1,1) NOT NULL,
        [Reg_id]   INT NOT NULL,
        [Username] VARCHAR(50) NOT NULL,
        [Password] VARCHAR(50) NOT NULL,
        [Log_type] VARCHAR(50) NOT NULL,
        CONSTRAINT [PK_Logintab] PRIMARY KEY CLUSTERED ([Login_id] ASC)
    );
    PRINT 'Table [Logintab] created.';
END
GO

-- Employee: Stores Job Seeker profile details
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Employee]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Employee](
        [User_id]       INT NOT NULL,
        [User_name]     VARCHAR(50) NOT NULL,
        [Age]           INT NOT NULL,
        [Address]       VARCHAR(150) NOT NULL,
        [Phone]         VARCHAR(150) NOT NULL,
        [Email]         VARCHAR(50) NOT NULL,
        [Gender]        VARCHAR(50) NOT NULL,
        [Qualification] VARCHAR(250) NOT NULL,
        [Experience]    VARCHAR(50) NOT NULL,
        [Skills]        VARCHAR(50) NOT NULL,
        CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED ([User_id] ASC)
    );
    PRINT 'Table [Employee] created.';
END
GO

-- Company: Stores Employer / Company profile details
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Company]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Company](
        [Company_id]          INT NOT NULL,
        [Company_name]        VARCHAR(50) NOT NULL,
        [Company_address]     VARCHAR(50) NOT NULL,
        [Company_phone]       VARCHAR(50) NOT NULL,
        [Company_web]         VARCHAR(50) NOT NULL,
        [Company_description] VARCHAR(150) NOT NULL,
        CONSTRAINT [PK_Company] PRIMARY KEY CLUSTERED ([Company_id] ASC)
    );
    PRINT 'Table [Company] created.';
END
GO

-- Job_tab: Stores job vacancies posted by employers
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Job_tab]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Job_tab](
        [Job_id]      INT IDENTITY(1,1) NOT NULL,
        [Company_id]  INT NOT NULL,
        [Skills]      VARCHAR(50) NOT NULL,
        [Experience]  VARCHAR(50) NOT NULL,
        [Job_status]  VARCHAR(50) NOT NULL,
        [Last_date]   VARCHAR(50) NOT NULL,
        [Location]    VARCHAR(50) NOT NULL,
        [Job_salary]  INT NOT NULL,
        CONSTRAINT [PK_Job_tab] PRIMARY KEY CLUSTERED ([Job_id] ASC)
    );
    PRINT 'Table [Job_tab] created.';
END
GO

-- Apptab: Stores submitted job applications and uploaded resume paths
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Apptab]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Apptab](
        [app_id]     INT IDENTITY(1,1) NOT NULL,
        [Company_id] INT NOT NULL,
        [User_id]    INT NOT NULL,
        [Job_id]     INT NOT NULL,
        [Resume]     VARCHAR(450) NOT NULL,
        [App_date]   VARCHAR(50) NOT NULL,
        [App_status] VARCHAR(50) NOT NULL,
        CONSTRAINT [PK_Apptab] PRIMARY KEY CLUSTERED ([app_id] ASC)
    );
    PRINT 'Table [Apptab] created.';
END
GO

-- Applicationtab: Compatible with legacy entity schema
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Applicationtab]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Applicationtab](
        [Application_id] INT IDENTITY(1,1) NOT NULL,
        [User_id]        INT NOT NULL,
        [Job_id]         INT NOT NULL,
        [CV]             VARCHAR(450) NOT NULL,
        [App_date]       VARCHAR(50) NOT NULL,
        [App_status]     VARCHAR(50) NOT NULL,
        CONSTRAINT [PK_Applicationtab] PRIMARY KEY CLUSTERED ([Application_id] ASC)
    );
    PRINT 'Table [Applicationtab] created.';
END
GO

-- ============================================================================
-- 3. Stored Procedures
-- ============================================================================

-- sp_maximum: Returns highest Reg_id to auto-generate next registration ID
CREATE OR ALTER PROCEDURE [dbo].[sp_maximum]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT ISNULL(MAX(Reg_id), 0) AS max_reg_id FROM [dbo].[Logintab];
END
GO

-- sp_login: Verifies credentials, returns 1 if matched
CREATE OR ALTER PROCEDURE [dbo].[sp_login]
    @uname VARCHAR(50),
    @pwd   VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT COUNT(Login_id) AS IsValid FROM [dbo].[Logintab] 
    WHERE Username = @uname AND Password = @pwd;
END
GO

-- sp_regid: Retrieves the user/company Reg_id on login
CREATE OR ALTER PROCEDURE [dbo].[sp_regid]
    @una VARCHAR(50),
    @pwd VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Reg_id FROM [dbo].[Logintab] 
    WHERE Username = @una AND Password = @pwd;
END
GO

-- sp_logintype: Retrieves the role type ('employee' or 'company')
CREATE OR ALTER PROCEDURE [dbo].[sp_logintype]
    @una VARCHAR(50),
    @pwd VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Log_type FROM [dbo].[Logintab] 
    WHERE Username = @una AND Password = @pwd;
END
GO

-- sp_insertlogin: Inserts account credentials into Logintab
CREATE OR ALTER PROCEDURE [dbo].[sp_insertlogin]
    @rid   INT,
    @una   VARCHAR(50),
    @pwd   VARCHAR(50),
    @utype VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [dbo].[Logintab] (Reg_id, Username, Password, Log_type)
    VALUES (@rid, @una, @pwd, @utype);
END
GO

-- sp_employ: Registers a new candidate profile into Employee
CREATE OR ALTER PROCEDURE [dbo].[sp_employ]
    @uid      INT,
    @uname    VARCHAR(50),
    @uage     INT,
    @uaddress VARCHAR(150),
    @uphone   VARCHAR(150),
    @uemail   VARCHAR(50),
    @gen      VARCHAR(50),
    @qual     VARCHAR(250),
    @exp      VARCHAR(50),
    @skill    VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [dbo].[Employee] (User_id, User_name, Age, Address, Phone, Email, Gender, Qualification, Experience, Skills)
    VALUES (@uid, @uname, @uage, @uaddress, @uphone, @uemail, @gen, @qual, @exp, @skill);
END
GO

-- sp_company: Registers a new employer profile into Company
CREATE OR ALTER PROCEDURE [dbo].[sp_company]
    @cid     INT,
    @cna     VARCHAR(50),
    @caddr   VARCHAR(50),
    @cphone  VARCHAR(50),
    @cweb    VARCHAR(50),
    @compdes VARCHAR(150)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [dbo].[Company] (Company_id, Company_name, Company_address, Company_phone, Company_web, Company_description)
    VALUES (@cid, @cna, @caddr, @cphone, @cweb, @compdes);
END
GO

-- sp_job: Adds a new job listing
CREATE OR ALTER PROCEDURE [dbo].[sp_job]
    @cmpid  INT,
    @skills VARCHAR(50),
    @exp    VARCHAR(50),
    @jbsts  VARCHAR(50),
    @ldate  VARCHAR(50),
    @loc    VARCHAR(50),
    @jobsal INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [dbo].[Job_tab] (Company_id, Skills, Experience, Job_status, Last_date, Location, Job_salary)
    VALUES (@cmpid, @skills, @exp, @jbsts, @ldate, @loc, @jobsal);
END
GO

-- sp_jobinsert: Secondary insertion procedure for jobs
CREATE OR ALTER PROCEDURE [dbo].[sp_jobinsert]
    @cid       INT,
    @skills    VARCHAR(50),
    @exp       VARCHAR(50),
    @jobstatus VARCHAR(50),
    @lasdate   VARCHAR(50),
    @loc       VARCHAR(50),
    @Jobsala   INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [dbo].[Job_tab] (Company_id, Skills, Experience, Job_status, Last_date, Location, Job_salary)
    VALUES (@cid, @skills, @exp, @jobstatus, @lasdate, @loc, @Jobsala);
END
GO

-- sp_jobpost: Returns all active jobs for listing
CREATE OR ALTER PROCEDURE [dbo].[sp_jobpost]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        Job_id,
        Company_id,
        Skills,
        Experience,
        Job_status,
        Last_date,
        Location,
        Job_salary
    FROM [dbo].[Job_tab];
END
GO

-- sp_search: Returns filtered jobs dynamically based on query criteria
CREATE OR ALTER PROCEDURE [dbo].[sp_search]
    @qry NVARCHAR(MAX) = N''
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @sql NVARCHAR(MAX);
    SET @sql = N'SELECT Job_id, Company_id, Skills, Experience, Job_status, Last_date, Location, Job_salary FROM [dbo].[Job_tab] WHERE 1=1 ' + ISNULL(@qry, N'');
    EXEC sp_executesql @sql;
END
GO

-- sp_countofappid: Checks if candidate has already applied to a specific job
CREATE OR ALTER PROCEDURE [dbo].[sp_countofappid]
    @uid INT,
    @jid INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT COUNT(1) AS HasApplied FROM [dbo].[Apptab] 
    WHERE User_id = @uid AND Job_id = @jid;
END
GO

-- sp_applicationposting: Submits a job application with resume path
CREATE OR ALTER PROCEDURE [dbo].[sp_applicationposting]
    @cid       INT,
    @uid       INT,
    @jid       INT,
    @resume    VARCHAR(450),
    @appdate   VARCHAR(50),
    @appstatus VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [dbo].[Apptab] (Company_id, User_id, Job_id, Resume, App_date, App_status)
    VALUES (@cid, @uid, @jid, @resume, @appdate, @appstatus);
END
GO

-- ============================================================================
-- 4. Sample Seed Data (For Testing & Demonstration)
-- ============================================================================

-- Insert sample companies if empty
IF NOT EXISTS (SELECT 1 FROM [dbo].[Company])
BEGIN
    -- Seed Company 1
    EXEC [dbo].[sp_company] 1, 'TechNova Solutions', '742 Evergreen Terrace, Springfield', '9876543210', 'https://technova.io', 'Enterprise Cloud & Web Development Consultancy';
    EXEC [dbo].[sp_insertlogin] 1, 'technova', 'pass123', 'company';

    -- Seed Company 2
    EXEC [dbo].[sp_company] 2, 'Apex Innovations', '100 Market Street, San Francisco', '9123456780', 'https://apexinno.com', 'AI & Financial Technology Services';
    EXEC [dbo].[sp_insertlogin] 2, 'apex', 'pass123', 'company';
    
    PRINT 'Sample companies seeded.';
END
GO

-- Insert sample candidates if empty
IF NOT EXISTS (SELECT 1 FROM [dbo].[Employee])
BEGIN
    -- Seed Candidate 1
    EXEC [dbo].[sp_employ] 3, 'Alex Johnson', 26, '45 Elm Street, Boston, MA', '9811223344', 'alex.johnson@example.com', 'Male', 'BTECH,MCA', '3 Years', 'C#, ASP.NET, SQL Server, MVC';
    EXEC [dbo].[sp_insertlogin] 3, 'alex', 'pass123', 'employee';

    -- Seed Candidate 2
    EXEC [dbo].[sp_employ] 4, 'Sarah Miller', 24, '12 Maple Avenue, Seattle, WA', '9722334455', 'sarah.miller@example.com', 'Female', 'BCA,BTECH', '2 Years', 'React, JavaScript, TypeScript, CSS';
    EXEC [dbo].[sp_insertlogin] 4, 'sarah', 'pass123', 'employee';

    PRINT 'Sample candidates seeded.';
END
GO

-- Insert sample jobs if empty
IF NOT EXISTS (SELECT 1 FROM [dbo].[Job_tab])
BEGIN
    EXEC [dbo].[sp_job] 1, 'C#, ASP.NET MVC, SQL Server', '2 - 4 Years', 'Active', '2026-12-31', 'New York, NY (Hybrid)', 85000;
    EXEC [dbo].[sp_job] 1, 'Frontend React, JavaScript, HTML5', '1 - 3 Years', 'Active', '2026-12-15', 'Remote', 72000;
    EXEC [dbo].[sp_job] 2, 'Senior .NET Core Backend Engineer', '4 - 7 Years', 'Active', '2026-12-20', 'San Francisco, CA', 125000;
    EXEC [dbo].[sp_job] 2, 'QA Automation Engineer (Selenium, C#)', '2 - 3 Years', 'Active', '2026-12-25', 'Austin, TX (Remote)', 78000;

    PRINT 'Sample jobs seeded.';
END
GO

PRINT '=======================================================';
PRINT 'JobSeeker Database [Saaa] setup completed successfully!';
PRINT 'Sample Accounts:';
PRINT '  Employer 1: Username="technova", Password="pass123"';
PRINT '  Employer 2: Username="apex", Password="pass123"';
PRINT '  Candidate 1: Username="alex", Password="pass123"';
PRINT '  Candidate 2: Username="sarah", Password="pass123"';
PRINT '=======================================================';
GO

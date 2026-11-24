# JobSeeker Portal 🚀

[![.NET Framework](https://img.shields.io/badge/.NET%20Framework-4.7.2-512BD4?logo=dotnet)](https://dotnet.microsoft.com/)
[![ASP.NET MVC](https://img.shields.io/badge/ASP.NET%20MVC-5.2.7-0078D7?logo=microsoft)](https://dotnet.microsoft.com/apps/aspnet/mvc)
[![Entity Framework](https://img.shields.io/badge/Entity%20Framework-6.2.0-68217A)](https://docs.microsoft.com/ef/)
[![SQL Server](https://img.shields.io/badge/SQL%20Server-2016%2B%20%7C%20Express%20%7C%20LocalDB-CC292B?logo=microsoftsqlserver)](https://www.microsoft.com/sql-server/)

**JobSeeker Portal** is a full-featured web application designed to connect ambitious job seekers with verified employers and recruiters. Candidates can discover career openings, filter by tech stack and location, and submit applications with resume attachments, while employers can register company profiles, publish new job openings, and track candidate submissions.

---

## Table of Contents

- [Features](#features)
- [Tech Stack &amp; Architecture](#tech-stack--architecture)
- [System Requirements](#system-requirements)
- [Quick Start Guide](#quick-start-guide)
  - [Step 1: Clone Repository](#step-1-clone-the-repository)
  - [Step 2: Database Setup](#step-2-setup-the-database)
  - [Step 3: Configure Web.config](#step-3-configure-database-connection-in-webconfig)
  - [Step 4: Restore Packages &amp; Build](#step-4-restore-dependencies--build)
  - [Step 5: Run the Portal](#step-5-launch-the-application)
- [Default Test Credentials](#default-test-credentials)
- [Database Schema &amp; Stored Procedures](#database-schema--stored-procedures)
- [Project Directory Structure](#project-directory-structure)
- [Troubleshooting &amp; Common Issues](#troubleshooting--common-issues)
- [License](#license)

---

## Features

### 👤 For Job Seekers (Candidates)
- **Comprehensive Profile Creation**: Register with personal details, qualifications, years of experience, and key technical skills.
- **Dynamic Job Search &amp; Filtering**: Filter available job vacancies by skills (e.g. C#, SQL, React), experience levels, and geographical/remote locations.
- **1-Click Application Submission**: Upload resumes directly (PDF, DOC, DOCX up to 10MB) for immediate employer review.
- **Duplicate Prevention**: Built-in verification prevents candidates from submitting multiple applications to the exact same position.
- **Dedicated Candidate Dashboard**: Access open listings, profile details, and recruitment guidance.

### 🏢 For Employers &amp; Recruiters
- **Company Profile Registration**: Add company name, headquarters address, phone, website URL, and mission description.
- **Job Vacancy Publishing**: Post openings with required skills, experience parameters, application deadlines, and compensation details.
- **Portal Oversight**: View live postings and verify active applicant requirements.
- **Role-Based Authentication**: Secure session redirection based on account role (`employee` vs `company`).

### 🎨 Modern UI / UX
- Clean, responsive layout built with custom modern design tokens and accessible typography.
- Mobile-friendly collapsed navigation with role-aware action buttons.
- Feedback banners and validation alerts for streamlined error prevention.

---

## Tech Stack & Architecture

- **Backend Framework**: ASP.NET MVC 5 (.NET Framework 4.7.2)
- **Language**: C# 7.3
- **Data Access**: Entity Framework 6 (Database First / EDMX) + ADO.NET (`SqlCommand` for dynamic filter queries)
- **Database Engine**: Microsoft SQL Server (Compatible with 2014, 2016, 2019, 2022, Express, and LocalDB)
- **Frontend**: Razor View Engine (`.cshtml`), HTML5, CSS3, JavaScript / jQuery 3.4.1, Bootstrap 3.4.1

---

## System Requirements

Ensure the following tools are installed on your machine:
- **Operating System**: Windows 10 / 11 or Windows Server
- **IDE**: [Visual Studio 2019 / 2022 / Community](https://visualstudio.microsoft.com/) with the **ASP.NET and web development** workload selected
- **.NET Framework**: Developer Pack for **.NET Framework 4.7.2**
- **Database**: Microsoft SQL Server Express, Developer Edition, or LocalDB (`(localdb)\MSSQLLocalDB`)
- **SQL Client**: SQL Server Management Studio (SSMS) or Azure Data Studio

---

## Quick Start Guide

### Step 1: Clone the Repository
```bash
git clone https://github.com/Anvinz13/JobSeeker-Project.git
cd JobSeeker-Project
```

### Step 2: Setup the Database
1. Open **SQL Server Management Studio (SSMS)** or **Azure Data Studio**.
2. Connect to your SQL Server instance (e.g., `.\SQLEXPRESS` or `(localdb)\MSSQLLocalDB` or `localhost`).
3. Open and execute the provided database script:
   ```
   JobSeeker_Database.sql
   ```
   *This script automatically:*
   - Creates the database `[Saaa]`.
   - Generates all tables (`Logintab`, `Employee`, `Company`, `Job_tab`, `Apptab`, `Applicationtab`).
   - Installs all 12 stored procedures.
   - Populates sample seed companies, candidates, and job postings.

### Step 3: Configure Database Connection in `Web.config`
Open `Project/Web.config` and verify or update the connection strings to point to your local SQL Server instance:

```xml
<connectionStrings>
  <!-- Entity Framework Connection String -->
  <add name="SaaaEntities" 
       connectionString="metadata=res://*/Model1.csdl|res://*/Model1.ssdl|res://*/Model1.msl;provider=System.Data.SqlClient;provider connection string=&quot;data source=.\SQLEXPRESS;initial catalog=Saaa;integrated security=True;MultipleActiveResultSets=True;App=EntityFramework&quot;" 
       providerName="System.Data.EntityClient" />

  <!-- Direct ADO.NET Connection String for Search Queries -->
  <add name="importantdataconnection" 
       connectionString="server=.\SQLEXPRESS;database=Saaa;Integrated security=true;" />
</connectionStrings>
```

> **Tip**: If you are using Visual Studio LocalDB instead of SQL Express, change `data source=.\SQLEXPRESS` and `server=.\SQLEXPRESS` to `(localdb)\MSSQLLocalDB`. See [Web.config.example](Web.config.example) for templates.

### Step 4: Restore Dependencies & Build
Open the solution `Project.sln` in Visual Studio, or run in the terminal:
```powershell
.\nuget.exe restore Project.sln
```
Then build the solution using Visual Studio (`Ctrl + Shift + B`) or MSBuild:
```powershell
msbuild Project.sln /p:Configuration=Debug
```

### Step 5: Launch the Application
- Press **F5** or click **IIS Express (Google Chrome / Edge)** in Visual Studio.
- The web browser will open to the home landing page or sign-in page:
  ```
  http://localhost:PORT/
  ```

---

## Default Test Credentials

The database script automatically populates test accounts for immediate verification:

| Role | Username | Password | Notes |
| :--- | :--- | :--- | :--- |
| **Employer / Company** | `technova` | `pass123` | TechNova Solutions (Enterprise Web/Cloud) |
| **Employer / Company** | `apex` | `pass123` | Apex Innovations (AI & FinTech) |
| **Job Seeker** | `alex` | `pass123` | Alex Johnson (C#, .NET, SQL Specialist) |
| **Job Seeker** | `sarah` | `pass123` | Sarah Miller (Frontend React Specialist) |

---

## Database Schema & Stored Procedures

### Tables Overview
- **`Logintab`**: Centralized authentication table holding `Username`, `Password`, and `Log_type` (`employee` vs `company`).
- **`Employee`**: Candidate personal details, educational qualifications, experience, and contact information.
- **`Company`**: Employer corporate records, headquarters location, website, and company summary.
- **`Job_tab`**: Active and closed vacancies with required skills, experience, location, deadline date, and salary.
- **`Apptab`**: Application audit log linking `Company_id`, `User_id`, `Job_id`, uploaded `Resume` path, and status.

### Stored Procedures
| Procedure | Purpose |
| :--- | :--- |
| `sp_login` | Authenticates user credentials and returns match count. |
| `sp_regid` | Retrieves the associated registration ID (`User_id` or `Company_id`). |
| `sp_logintype` | Returns role classification (`employee` or `company`). |
| `sp_maximum` | Gets the highest existing `Reg_id` for sequence generation. |
| `sp_insertlogin` | Creates account credentials in `Logintab`. |
| `sp_employ` | Inserts a candidate profile into `Employee`. |
| `sp_company` | Inserts an employer profile into `Company`. |
| `sp_job` / `sp_jobinsert` | Inserts new job postings into `Job_tab`. |
| `sp_jobpost` | Returns all active job listings for display. |
| `sp_search` | Filters job vacancies based on dynamic criteria (skills, location, experience). |
| `sp_countofappid` | Checks if candidate has already submitted an application for the job. |
| `sp_applicationposting` | Inserts application record and resume file path into `Apptab`. |

---

## Project Directory Structure

```
JobSeeker-Project/
├── JobSeeker_Database.sql         # Complete SQL Server creation script with seed data
├── Web.config.example             # Connection string templates for LocalDB & SQL Server
├── Project.sln                    # Visual Studio Solution file
├── nuget.exe                      # CLI package manager
├── README.md                      # Comprehensive project guide
└── Project/
    ├── App_Start/
    │   ├── BundleConfig.cs        # Script and CSS asset bundling
    │   ├── FilterConfig.cs        # Global action filters
    │   └── RouteConfig.cs         # MVC routing configuration
    ├── Content/
    │   ├── bootstrap.css          # Bootstrap framework stylesheet
    │   └── Site.css               # Modern custom stylesheet & design system
    ├── Controllers/
    │   ├── HomeController.cs      # Landing page, About, and Contact
    │   ├── loginController.cs     # Authentication, role routing, logout
    │   ├── UserController.cs      # Job Seeker profile registration
    │   ├── UniqueController.cs    # Employer / Company profile registration
    │   ├── JobsController.cs      # Job posting submission
    │   ├── JobsearchController.cs # Job browsing & multi-criteria search
    │   └── AppsController.cs      # Resume upload & application processing
    ├── Models/                    # ViewModels and data transfer objects
    ├── Views/
    │   ├── Apps/                  # Resume submission views
    │   ├── Home/                  # Landing, About, Contact
    │   ├── Jobs/                  # Job creation form
    │   ├── Jobsearch/             # Search results & job board
    │   ├── login/                 # Login, Seeker & Employer dashboards
    │   ├── Shared/                # _Layout.cshtml and error templates
    │   ├── Unique/                # Company registration view
    │   └── User/                  # Candidate registration view
    ├── resume/                    # Uploaded candidate resume documents
    ├── Model1.edmx                # Entity Framework Data Model mapping
    └── Web.config                 # Application configuration & connection strings
```

---

## Troubleshooting & Common Issues

#### 1. SQL Server Connection Failed (`SqlException`)
- **Cause**: The SQL Server instance name in `Web.config` does not match your local server.
- **Fix**: Open SQL Server Management Studio and check the Server Name at login. Update both `SaaaEntities` and `importantdataconnection` in `Web.config` with your exact server name (e.g. `.\SQLEXPRESS` or `(localdb)\MSSQLLocalDB`).

#### 2. NuGet Package Restore Errors
- **Cause**: Packages not yet downloaded or cache is missing.
- **Fix**: Run `.\nuget.exe restore Project.sln` in the root folder, or in Visual Studio: Right-click Solution -> **Restore NuGet Packages**.

#### 3. Resume Upload Directory Access Denied
- **Cause**: IIS Express or the ASP.NET worker process does not have write permissions to the `Project/resume` folder.
- **Fix**: Right-click `Project/resume` -> Properties -> Security -> Ensure **Users** or **IIS_IUSRS** has **Write / Modify** permissions.

#### 4. Session Expired or Redirect to Login
- If you access protected actions directly (e.g. submitting an application or posting a job), ensure you have signed in first so that `Session["id"]` is populated.

---

## License

This project is licensed under the [MIT License](LICENSE) - free for academic, portfolio, and commercial extension.

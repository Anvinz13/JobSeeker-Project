# Database Setup & Configuration Guide

This guide explains how to install, configure, and verify the SQL Server database for the **JobSeeker Portal** application (`Saaa`).

---

## 1. Prerequisites
- **Microsoft SQL Server**: 2014, 2016, 2019, 2022, or **SQL Server Express** or **LocalDB**.
- **Management Tool**: SQL Server Management Studio (SSMS), Azure Data Studio, or `sqlcmd`.

---

## 2. One-Click Setup with `JobSeeker_Database.sql`

The repository includes a ready-to-run database initialization script:
- [`JobSeeker_Database.sql`](JobSeeker_Database.sql)

### Option A: Via SQL Server Management Studio (SSMS)
1. Open SSMS and connect to your SQL Server instance (e.g., `.\SQLEXPRESS` or `(localdb)\MSSQLLocalDB`).
2. Go to **File -> Open -> File...** and select `JobSeeker_Database.sql`.
3. Click **Execute** (or press `F5`).
4. The output tab will confirm:
   - Creation of the `[Saaa]` database.
   - Creation of all 6 tables.
   - Compilation of all 12 stored procedures.
   - Insertion of sample test accounts and job postings.

### Option B: Via Command Line (`sqlcmd`)
Run from the repository root:
```cmd
sqlcmd -S .\SQLEXPRESS -E -i "Database\JobSeeker_Database.sql"
```
Or for LocalDB:
```cmd
sqlcmd -S (localdb)\MSSQLLocalDB -E -i "Database\JobSeeker_Database.sql"
```

---

## 3. Database Architecture

### Entity Relationship & Tables
```
[Logintab] (Authentication & Role)
   ├── [Employee] (Candidate Details) [via Reg_id = User_id]
   └── [Company]  (Employer Details)  [via Reg_id = Company_id]
           │
           ▼
       [Job_tab] (Vacancies published by Company)
           │
           ▼
       [Apptab] (Applications linking User_id, Job_id, and Resume file)
```

| Table Name | Description | Key Fields |
| :--- | :--- | :--- |
| `Logintab` | Credentials & role classification | `Login_id` (PK, Identity), `Reg_id`, `Username`, `Password`, `Log_type` |
| `Employee` | Job seeker personal & professional data | `User_id` (PK), `User_name`, `Age`, `Address`, `Phone`, `Email`, `Gender`, `Qualification`, `Experience`, `Skills` |
| `Company` | Registered employers and recruiters | `Company_id` (PK), `Company_name`, `Company_address`, `Company_phone`, `Company_web`, `Company_description` |
| `Job_tab` | Live and past job postings | `Job_id` (PK, Identity), `Company_id`, `Skills`, `Experience`, `Job_status`, `Last_date`, `Location`, `Job_salary` |
| `Apptab` | Candidate applications and resume attachments | `app_id` (PK, Identity), `Company_id`, `User_id`, `Job_id`, `Resume`, `App_date`, `App_status` |

---

## 4. Stored Procedures Reference

1. **`sp_maximum`**: Gets `MAX(Reg_id)` from `Logintab` to increment the registration identifier.
2. **`sp_login @uname, @pwd`**: Validates credentials. Returns `1` for matched account, `0` otherwise.
3. **`sp_regid @una, @pwd`**: Retrieves the `Reg_id` associated with the username and password.
4. **`sp_logintype @una, @pwd`**: Returns role (`employee` or `company`) for session routing.
5. **`sp_insertlogin @rid, @una, @pwd, @utype`**: Stores login credentials upon new user or company registration.
6. **`sp_employ @uid, @uname, @uage, @uaddress, @uphone, @uemail, @gen, @qual, @exp, @skill`**: Inserts a new candidate record.
7. **`sp_company @cid, @cna, @caddr, @cphone, @cweb, @compdes`**: Inserts a new employer record.
8. **`sp_job @cmpid, @skills, @exp, @jbsts, @ldate, @loc, @jobsal`**: Inserts a newly published job vacancy.
9. **`sp_jobpost`**: Selects all job postings ordered for the job board.
10. **`sp_search @qry`**: Dynamically filters jobs by skills, experience, and location.
11. **`sp_countofappid @uid, @jid`**: Verifies whether candidate `@uid` has already applied to job `@jid`.
12. **`sp_applicationposting @cid, @uid, @jid, @resume, @appdate, @appstatus`**: Saves a submitted job application and CV file path.

---

## 5. Seed Test Credentials

| Username | Password | Role | Description |
| :--- | :--- | :--- | :--- |
| `technova` | `pass123` | `company` | TechNova Solutions |
| `apex` | `pass123` | `company` | Apex Innovations |
| `alex` | `pass123` | `employee` | Candidate (C# / .NET) |
| `sarah` | `pass123` | `employee` | Candidate (React / Frontend) |

# Student Notes Sharing Application

## Overview
A beginner-friendly Java web application using Servlets and JSP for student notes sharing, styled after backbencher.club. Students can download notes publicly, while only the admin can upload or delete files. Uses Apache Tomcat as the web server with BASIC authentication for admin access.

## Design
- **Theme:** Dark gradient theme inspired by backbencher.club
- **Typography:** Poppins font family
- **Features:** Hero section, folder navigation, sidebar categories, glassmorphism effects
- **Colors:** Purple/teal gradient background with colorful accent cards

## Project Structure
```
student-notes/
├── src/main/
│   ├── java/com/notes/servlets/
│   │   ├── ListNotesServlet.java       # Lists files/folders for public page
│   │   ├── DownloadServlet.java        # Handles file downloads
│   │   ├── AdminDashboardServlet.java  # Admin dashboard with folder management
│   │   ├── UploadServlet.java          # Handles file uploads to categories
│   │   ├── DeleteServlet.java          # Handles file/folder deletion
│   │   └── CreateFolderServlet.java    # Creates new folders/categories
│   └── webapp/
│       ├── index.jsp                   # Public notes listing with folder navigation
│       └── WEB-INF/
│           ├── admin.jsp               # Admin dashboard with folder management
│           └── web.xml                 # Security configuration
├── conf/
│   └── tomcat-users.xml                # Admin user configuration
├── notes/                              # Uploaded files directory (supports nested folders)
├── pom.xml                             # Maven configuration
├── run.sh                              # Build and run script
└── replit.md                           # This documentation
```

## Technology Stack
- **Java 11+** - Programming language
- **Servlets 4.0** - Server-side logic
- **JSP** - View templates
- **Apache Tomcat 9** - Web server/servlet container
- **Maven** - Build tool
- No frameworks (Spring, Hibernate, etc.)

## Features

### Folder Organization System
- Create nested folders/categories (e.g., Engineering/Semester 1/Mathematics)
- Upload files to specific folders
- Browse folders with breadcrumb navigation
- Sidebar shows all categories with file counts

### Public Features (No Login Required)
- View list of all available notes at `/` or `/list`
- Navigate through folders and subfolders
- Download any note file by clicking on it
- Sidebar category navigation

### Admin Features (Login Required)
- Access admin dashboard at `/admin/dashboard`
- Create new folders/categories
- Upload files to any folder
- Delete files and entire folders
- Navigate folder structure with breadcrumbs
- Protected by HTTP BASIC authentication

## Folder Structure Example
```
notes/
├── Engineering/
│   ├── Semester 1/
│   │   ├── Mathematics.pdf
│   │   └── Physics.pdf
│   └── Semester 2/
│       └── Data Structures.pdf
├── MBA/
│   └── Finance/
│       └── Accounting.pdf
└── General Notes.pdf
```

## Authentication
- **Username:** admin
- **Password:** admin123
- Configured in `conf/tomcat-users.xml`
- Security constraints defined in `src/main/webapp/WEB-INF/web.xml`

## How to Run
The application runs automatically using the configured workflow:
1. Maven builds the WAR file
2. WAR is deployed to Tomcat's webapps directory
3. Tomcat starts on port 5000

## File Storage
Uploaded files are stored in the `notes/` directory at the project root (outside the WAR file). This ensures files persist across redeployments. The folder structure is fully customizable.

## URLs
- **Public Page:** `http://hostname:5000/`
- **Browse Folder:** `http://hostname:5000/list?path=FolderName`
- **Admin Dashboard:** `http://hostname:5000/admin/dashboard`

## Security Notes
- Admin endpoints (`/admin/*`) require authentication
- BASIC authentication is configured via web.xml
- File paths are sanitized to prevent directory traversal attacks
- Hidden files (starting with `.`) are excluded from listings
- Folder names are sanitized to prevent special characters

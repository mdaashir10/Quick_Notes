# Quick Notes - Study Smarter

## Overview
A beginner-friendly Java web application using Servlets and JSP for sharing study materials. Students can download notes publicly from 4 predefined categories (Notes, Question Papers, Text Books, Guides), each with nested directory organization. Only the admin can upload or delete files. Uses Apache Tomcat as the web server with BASIC authentication for admin access.

## Branding
- **Application Name:** Quick Notes
- **Tagline:** Study Smarter, Learn Better
- **Logo:** Neon-styled lightning bolt with notebook design
- **Theme:** Dark gradient theme with modern glassmorphism effects
- **Typography:** Poppins font family

## Design
- **Colors:** Purple/teal gradient background (#0f0c29, #302b63, #24243e) with colorful accent cards
- **Features:** Hero section with logo, 4 category buttons, nested folder navigation, glassmorphism effects
- **Responsive:** Mobile-friendly responsive design

## Project Structure
```
quick-notes/
├── src/main/
│   ├── java/com/notes/servlets/
│   │   ├── ListNotesServlet.java       # Lists files/folders for public page
│   │   ├── DownloadServlet.java        # Handles file downloads
│   │   ├── AdminDashboardServlet.java  # Admin dashboard with folder management
│   │   ├── UploadServlet.java          # Handles file uploads to categories
│   │   ├── DeleteServlet.java          # Handles file/folder deletion
│   │   └── CreateFolderServlet.java    # Creates new folders/categories
│   └── webapp/
│       ├── index.jsp                   # Public page with 4 category buttons and logo
│       ├── logo.png                    # Quick Notes logo
│       └── WEB-INF/
│           ├── admin.jsp               # Admin dashboard with folder management
│           └── web.xml                 # Security configuration
├── conf/
│   └── tomcat-users.xml                # Admin user configuration
├── notes/                              # Uploaded files directory (4 predefined categories)
│   ├── Notes/                          # Category for class notes
│   ├── Question Papers/                # Category for question papers
│   ├── Text Books/                     # Category for textbooks
│   └── Guides/                         # Category for study guides
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

### 4 Main Categories
- **📝 Notes** - Class notes and lecture materials
- **❓ Question Papers** - Past papers and practice questions
- **📖 Text Books** - Reference textbooks and study guides
- **🎯 Guides** - Preparation guides and study strategies

### Nested Directory System Within Each Category
- Create subdirectories (e.g., Notes/Mathematics/Calculus)
- Upload files to any level
- Browse folders with breadcrumb navigation
- Full path sanitization preventing directory traversal attacks

### Public Features (No Login Required)
- View 4 main category buttons with Quick Notes branding
- Navigate through nested directories
- Download any note file by clicking on it
- Clean breadcrumb navigation showing current location

### Admin Features (Login Required)
- Access admin dashboard at `/admin/dashboard`
- Create new subdirectories within any category
- Upload files to any folder
- Delete files and entire folders
- Navigate folder structure with breadcrumbs
- Protected by HTTP BASIC authentication

## Example Folder Structure
```
notes/
├── Notes/
│   ├── Mathematics/
│   │   ├── Algebra.pdf
│   │   └── Calculus.pdf
│   ├── Physics/
│   │   └── Mechanics.pdf
├── Question Papers/
│   ├── 2024/
│   │   ├── Math Q1.pdf
│   │   └── Physics Q1.pdf
├── Text Books/
│   ├── Engineering/
│   │   └── Thermodynamics.pdf
└── Guides/
    └── Exam Preparation.pdf
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
4. 4 category folders are created automatically if missing

## File Storage
Uploaded files are stored in the `notes/` directory at the project root (outside the WAR file). This ensures files persist across redeployments. The folder structure includes 4 predefined categories with full nested directory support.

## URLs
- **Public Page:** `http://hostname:5000/`
- **Browse Category:** `http://hostname:5000/list?path=Notes` or `Question Papers`, `Text Books`, `Guides`
- **Admin Dashboard:** `http://hostname:5000/admin/dashboard`

## Security Notes
- Admin endpoints (`/admin/*`) require authentication
- BASIC authentication is configured via web.xml
- File paths are sanitized to prevent directory traversal attacks
- Hidden files (starting with `.`) are excluded from listings
- Folder names are sanitized to prevent special characters

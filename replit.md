# Student Notes Sharing Application

## Overview
A beginner-friendly Java web application using Servlets and JSP for student notes sharing. Students can download notes publicly, while only the admin can upload or delete files. Uses Apache Tomcat as the web server with BASIC authentication for admin access.

## Project Structure
```
student-notes/
├── src/main/
│   ├── java/com/notes/servlets/
│   │   ├── ListNotesServlet.java      # Lists files for public page
│   │   ├── DownloadServlet.java       # Handles file downloads
│   │   ├── AdminDashboardServlet.java # Admin dashboard
│   │   ├── UploadServlet.java         # Handles file uploads
│   │   └── DeleteServlet.java         # Handles file deletion
│   └── webapp/
│       ├── index.jsp                  # Public notes listing page
│       └── WEB-INF/
│           ├── admin.jsp              # Admin dashboard page
│           └── web.xml                # Security configuration
├── conf/
│   └── tomcat-users.xml               # Admin user configuration
├── notes/                             # Uploaded files directory
├── pom.xml                            # Maven configuration
├── run.sh                             # Build and run script
└── replit.md                          # This documentation
```

## Technology Stack
- **Java 11+** - Programming language
- **Servlets 4.0** - Server-side logic
- **JSP** - View templates
- **Apache Tomcat 9** - Web server/servlet container
- **Maven** - Build tool
- No frameworks (Spring, Hibernate, etc.)

## Features

### Public Features (No Login Required)
- View list of all available notes at `/` or `/list`
- Download any note file by clicking on it

### Admin Features (Login Required)
- Access admin dashboard at `/admin/dashboard`
- Upload new note files
- Delete existing note files
- Protected by HTTP BASIC authentication

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
Uploaded files are stored in the `notes/` directory at the project root (outside the WAR file). This ensures files persist across redeployments.

## URLs
- **Public Page:** `http://hostname:5000/`
- **Admin Dashboard:** `http://hostname:5000/admin/dashboard`

## Security Notes
- Admin endpoints (`/admin/*`) require authentication
- BASIC authentication is configured via web.xml
- File paths are sanitized to prevent directory traversal attacks
- Hidden files (starting with `.`) are excluded from listings

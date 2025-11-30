<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.notes.servlets.AdminDashboardServlet.FileInfo" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Student Notes</title>
    <style>
        /* Reset and base styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 900px;
            margin: 0 auto;
        }
        
        /* Header styles */
        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: white;
            margin-bottom: 30px;
            padding: 20px;
            background: rgba(255,255,255,0.1);
            border-radius: 10px;
        }
        
        header h1 {
            font-size: 1.8em;
        }
        
        .admin-info {
            text-align: right;
        }
        
        .admin-info span {
            display: block;
            font-size: 0.9em;
            opacity: 0.8;
        }
        
        .view-site-link {
            display: inline-block;
            margin-top: 10px;
            color: #4ecdc4;
            text-decoration: none;
        }
        
        .view-site-link:hover {
            text-decoration: underline;
        }
        
        /* Message styles */
        .message {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-weight: 500;
        }
        
        .message.success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .message.error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        /* Card styles */
        .card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.3);
            padding: 30px;
            margin-bottom: 25px;
        }
        
        .card h2 {
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #4ecdc4;
        }
        
        /* Upload form styles */
        .upload-form {
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap;
        }
        
        .file-input-wrapper {
            flex-grow: 1;
        }
        
        .file-input-wrapper input[type="file"] {
            width: 100%;
            padding: 12px;
            border: 2px dashed #ccc;
            border-radius: 8px;
            background: #f8f9fa;
            cursor: pointer;
        }
        
        .file-input-wrapper input[type="file"]:hover {
            border-color: #4ecdc4;
        }
        
        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            font-size: 1em;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .btn-upload {
            background: #4ecdc4;
            color: white;
        }
        
        .btn-upload:hover {
            background: #3dbdb5;
            transform: translateY(-2px);
        }
        
        .btn-delete {
            background: #ff6b6b;
            color: white;
            padding: 8px 15px;
            font-size: 0.9em;
        }
        
        .btn-delete:hover {
            background: #ee5a5a;
        }
        
        /* Files table */
        .files-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .files-table th,
        .files-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #e9ecef;
        }
        
        .files-table th {
            background: #f8f9fa;
            font-weight: 600;
            color: #495057;
        }
        
        .files-table tr:hover {
            background: #f8f9fa;
        }
        
        .file-name {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .file-icon {
            font-size: 1.3em;
        }
        
        /* Empty state */
        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: #6c757d;
        }
        
        .empty-state p {
            margin-top: 10px;
        }
        
        /* Responsive adjustments */
        @media (max-width: 600px) {
            .upload-form {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
            }
            
            .files-table th:nth-child(2),
            .files-table td:nth-child(2),
            .files-table th:nth-child(3),
            .files-table td:nth-child(3) {
                display: none;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Header -->
        <header>
            <h1>Admin Dashboard</h1>
            <div class="admin-info">
                <span>Logged in as: <strong><%= request.getAttribute("adminUser") %></strong></span>
                <a href="/" class="view-site-link">View Public Site</a>
            </div>
        </header>
        
        <!-- Message Display -->
        <%
            String message = (String) request.getAttribute("message");
            String messageType = (String) request.getAttribute("messageType");
            if (message != null && !message.isEmpty()) {
        %>
        <div class="message <%= messageType %>">
            <%= message %>
        </div>
        <%
            }
        %>
        
        <!-- Upload Card -->
        <div class="card">
            <h2>Upload New Note</h2>
            <form action="upload" method="post" enctype="multipart/form-data" class="upload-form">
                <div class="file-input-wrapper">
                    <input type="file" name="noteFile" required>
                </div>
                <button type="submit" class="btn btn-upload">Upload File</button>
            </form>
        </div>
        
        <!-- Files Management Card -->
        <div class="card">
            <h2>Manage Notes</h2>
            
            <%
                List<FileInfo> noteFiles = (List<FileInfo>) request.getAttribute("noteFiles");
                SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy HH:mm");
                
                if (noteFiles == null || noteFiles.isEmpty()) {
            %>
                <div class="empty-state">
                    <span style="font-size: 3em;">📁</span>
                    <p>No notes uploaded yet.</p>
                    <p>Use the form above to upload your first note!</p>
                </div>
            <%
                } else {
            %>
                <table class="files-table">
                    <thead>
                        <tr>
                            <th>File Name</th>
                            <th>Size</th>
                            <th>Last Modified</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (FileInfo file : noteFiles) {
                                // Determine icon based on file extension
                                String icon = "📄";
                                String lowerName = file.getName().toLowerCase();
                                if (lowerName.endsWith(".pdf")) {
                                    icon = "📕";
                                } else if (lowerName.endsWith(".doc") || lowerName.endsWith(".docx")) {
                                    icon = "📘";
                                } else if (lowerName.endsWith(".ppt") || lowerName.endsWith(".pptx")) {
                                    icon = "📙";
                                } else if (lowerName.endsWith(".xls") || lowerName.endsWith(".xlsx")) {
                                    icon = "📗";
                                } else if (lowerName.endsWith(".txt")) {
                                    icon = "📝";
                                } else if (lowerName.endsWith(".zip") || lowerName.endsWith(".rar")) {
                                    icon = "📦";
                                }
                        %>
                        <tr>
                            <td>
                                <div class="file-name">
                                    <span class="file-icon"><%= icon %></span>
                                    <span><%= file.getName() %></span>
                                </div>
                            </td>
                            <td><%= file.getSize() %></td>
                            <td><%= dateFormat.format(new Date(file.getLastModified())) %></td>
                            <td>
                                <form action="delete" method="post" style="display: inline;" 
                                      onsubmit="return confirm('Are you sure you want to delete this file?');">
                                    <input type="hidden" name="fileName" value="<%= file.getName() %>">
                                    <button type="submit" class="btn btn-delete">Delete</button>
                                </form>
                            </td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            <%
                }
            %>
        </div>
    </div>
</body>
</html>

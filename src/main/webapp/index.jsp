<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Notes - Download Study Materials</title>
    <style>
        /* Reset and base styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 800px;
            margin: 0 auto;
        }
        
        /* Header styles */
        header {
            text-align: center;
            color: white;
            margin-bottom: 30px;
        }
        
        header h1 {
            font-size: 2.5em;
            margin-bottom: 10px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
        }
        
        header p {
            font-size: 1.1em;
            opacity: 0.9;
        }
        
        /* Main content card */
        .notes-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            padding: 30px;
        }
        
        .notes-card h2 {
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #667eea;
        }
        
        /* Notes list styles */
        .notes-list {
            list-style: none;
        }
        
        .notes-list li {
            margin-bottom: 12px;
        }
        
        .note-link {
            display: flex;
            align-items: center;
            padding: 15px 20px;
            background: #f8f9fa;
            border-radius: 8px;
            text-decoration: none;
            color: #333;
            transition: all 0.3s ease;
            border: 1px solid #e9ecef;
        }
        
        .note-link:hover {
            background: #667eea;
            color: white;
            transform: translateX(5px);
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }
        
        .note-icon {
            font-size: 1.5em;
            margin-right: 15px;
        }
        
        .note-name {
            font-weight: 500;
            flex-grow: 1;
        }
        
        .download-icon {
            font-size: 1.2em;
            opacity: 0.7;
        }
        
        /* Empty state */
        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: #6c757d;
        }
        
        .empty-state p {
            font-size: 1.1em;
            margin-top: 10px;
        }
        
        /* Footer */
        footer {
            text-align: center;
            color: white;
            margin-top: 30px;
            opacity: 0.8;
        }
        
        footer a {
            color: white;
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Header Section -->
        <header>
            <h1>Student Notes</h1>
            <p>Download study materials shared by your instructor</p>
        </header>
        
        <!-- Main Content Card -->
        <div class="notes-card">
            <h2>Available Notes</h2>
            
            <%
                // Get the list of note files from the servlet
                List<String> noteFiles = (List<String>) request.getAttribute("noteFiles");
                
                if (noteFiles == null || noteFiles.isEmpty()) {
            %>
                <!-- Empty State - No notes available -->
                <div class="empty-state">
                    <span style="font-size: 3em;">📚</span>
                    <p>No notes have been uploaded yet.</p>
                    <p>Please check back later!</p>
                </div>
            <%
                } else {
            %>
                <!-- Notes List -->
                <ul class="notes-list">
                    <%
                        for (String fileName : noteFiles) {
                            // Determine icon based on file extension
                            String icon = "📄"; // default
                            String lowerName = fileName.toLowerCase();
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
                            } else if (lowerName.endsWith(".jpg") || lowerName.endsWith(".png") || lowerName.endsWith(".gif")) {
                                icon = "🖼️";
                            }
                    %>
                    <li>
                        <a href="download?file=<%= java.net.URLEncoder.encode(fileName, "UTF-8") %>" class="note-link">
                            <span class="note-icon"><%= icon %></span>
                            <span class="note-name"><%= fileName %></span>
                            <span class="download-icon">⬇️</span>
                        </a>
                    </li>
                    <%
                        }
                    %>
                </ul>
            <%
                }
            %>
        </div>
        
        <!-- Footer -->
        <footer>
            <p>Student Notes Sharing System</p>
        </footer>
    </div>
</body>
</html>

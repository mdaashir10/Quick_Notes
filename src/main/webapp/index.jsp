<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.notes.servlets.ListNotesServlet.FolderItem" %>
<%@ page import="com.notes.servlets.ListNotesServlet.FileItem" %>
<%@ page import="com.notes.servlets.ListNotesServlet.BreadcrumbItem" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <title>Quick Notes - Study Smarter</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(180deg, #0f0c29 0%, #302b63 50%, #24243e 100%);
            min-height: 100vh;
            color: #fff;
        }
        
        .hero {
            text-align: center;
            padding: 60px 20px 40px;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="%23ffffff10" d="M0,96L48,112C96,128,192,160,288,186.7C384,213,480,235,576,213.3C672,192,768,128,864,128C960,128,1056,192,1152,208C1248,224,1344,192,1392,176L1440,160L1440,0L1392,0C1344,0,1248,0,1152,0C1056,0,960,0,864,0C768,0,672,0,576,0C480,0,384,0,288,0C192,0,96,0,48,0L0,0Z"></path></svg>') no-repeat top center;
        }
        
        .hero-badge {
            display: inline-block;
            background: linear-gradient(135deg, #ff6b6b, #ee5a5a);
            color: white;
            padding: 8px 20px;
            border-radius: 25px;
            font-size: 0.85em;
            font-weight: 600;
            margin-bottom: 20px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .hero h1 {
            font-size: 3em;
            font-weight: 800;
            margin-bottom: 10px;
            background: linear-gradient(135deg, #fff 0%, #a8edea 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .hero h2 {
            font-size: 2.5em;
            font-weight: 700;
            color: #4ecdc4;
            margin-bottom: 15px;
        }
        
        .hero p {
            font-size: 1.1em;
            opacity: 0.8;
            max-width: 600px;
            margin: 0 auto;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }
        
        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 20px 0;
            flex-wrap: wrap;
        }
        
        .breadcrumb a {
            color: #4ecdc4;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s;
        }
        
        .breadcrumb a:hover {
            color: #fff;
        }
        
        .breadcrumb span {
            opacity: 0.5;
        }
        
        .breadcrumb .current {
            color: #fff;
            opacity: 0.8;
        }
        
        .categories-section {
            margin-bottom: 50px;
        }
        
        .categories-title {
            font-size: 1.8em;
            font-weight: 700;
            margin-bottom: 30px;
            text-align: center;
            background: linear-gradient(135deg, #fff 0%, #4ecdc4 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .categories-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
            margin-bottom: 50px;
        }
        
        .category-button {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 15px;
            padding: 40px 30px;
            text-decoration: none;
            color: white;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 15px;
            font-family: 'Poppins', sans-serif;
            text-align: center;
        }
        
        .category-button:nth-child(2) {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }
        
        .category-button:nth-child(3) {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }
        
        .category-button:nth-child(4) {
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
        }
        
        .category-button:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.3);
        }
        
        .category-icon {
            font-size: 3.5em;
        }
        
        .category-name {
            font-size: 1.3em;
            font-weight: 700;
        }
        
        .category-count {
            font-size: 0.9em;
            opacity: 0.9;
        }
        
        .content-grid {
            display: grid;
            grid-template-columns: 1fr;
            gap: 30px;
            margin-bottom: 40px;
        }
        
        .main-content {
            min-height: 400px;
        }
        
        .notes-section {
            background: rgba(255,255,255,0.05);
            border-radius: 20px;
            padding: 30px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.1);
        }
        
        .notes-section h3 {
            font-size: 1.3em;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .folders-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 30px;
        }
        
        .folder-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 12px;
            padding: 20px;
            text-decoration: none;
            color: white;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .folder-card:nth-child(4n+2) {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }
        
        .folder-card:nth-child(4n+3) {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }
        
        .folder-card:nth-child(4n) {
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
        }
        
        .folder-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.3);
        }
        
        .folder-icon {
            font-size: 2em;
        }
        
        .folder-info h4 {
            font-size: 1em;
            font-weight: 600;
            margin-bottom: 3px;
        }
        
        .folder-info span {
            font-size: 0.8em;
            opacity: 0.8;
        }
        
        .files-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 20px;
        }
        
        .file-card {
            background: rgba(255,255,255,0.08);
            border-radius: 12px;
            padding: 20px;
            transition: all 0.3s ease;
            border: 1px solid rgba(255,255,255,0.1);
            text-decoration: none;
            color: white;
            display: block;
        }
        
        .file-card:hover {
            background: rgba(255,255,255,0.15);
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            border-color: #4ecdc4;
        }
        
        .file-header {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 15px;
        }
        
        .file-icon {
            width: 50px;
            height: 50px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5em;
        }
        
        .file-icon.pdf { background: linear-gradient(135deg, #ff6b6b, #ee5a5a); }
        .file-icon.doc { background: linear-gradient(135deg, #4facfe, #00f2fe); }
        .file-icon.ppt { background: linear-gradient(135deg, #f093fb, #f5576c); }
        .file-icon.xls { background: linear-gradient(135deg, #43e97b, #38f9d7); }
        .file-icon.default { background: linear-gradient(135deg, #667eea, #764ba2); }
        
        .file-info h4 {
            font-size: 0.95em;
            font-weight: 600;
            margin-bottom: 5px;
            word-break: break-word;
        }
        
        .file-info span {
            font-size: 0.85em;
            opacity: 0.7;
        }
        
        .download-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            background: linear-gradient(135deg, #4ecdc4, #44a08d);
            color: white;
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.9em;
            transition: all 0.3s ease;
        }
        
        .file-card:hover .download-btn {
            background: linear-gradient(135deg, #44a08d, #4ecdc4);
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
        }
        
        .empty-state .icon {
            font-size: 4em;
            margin-bottom: 20px;
            opacity: 0.5;
        }
        
        .empty-state h4 {
            font-size: 1.3em;
            margin-bottom: 10px;
            opacity: 0.8;
        }
        
        .empty-state p {
            opacity: 0.6;
        }
        
        footer {
            text-align: center;
            padding: 40px 20px;
            border-top: 1px solid rgba(255,255,255,0.1);
            margin-top: 40px;
        }
        
        .footer-links {
            display: flex;
            justify-content: center;
            gap: 30px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        
        .footer-links a {
            color: rgba(255,255,255,0.7);
            text-decoration: none;
            font-size: 0.9em;
            transition: color 0.3s ease;
        }
        
        .footer-links a:hover {
            color: #4ecdc4;
        }
        
        .footer-brand {
            font-size: 1.2em;
            font-weight: 700;
            color: #4ecdc4;
            margin-bottom: 10px;
        }
        
        .footer-copyright {
            font-size: 0.85em;
            opacity: 0.6;
        }
        
        .admin-link {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background: rgba(255,255,255,0.1);
            color: white;
            padding: 12px 20px;
            border-radius: 25px;
            text-decoration: none;
            font-size: 0.9em;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.2);
            transition: all 0.3s ease;
            z-index: 100;
        }
        
        .admin-link:hover {
            background: rgba(255,255,255,0.2);
            transform: translateY(-3px);
        }
        
        @media (max-width: 900px) {
            .categories-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        
        @media (max-width: 768px) {
            .hero h1 {
                font-size: 2em;
            }
            
            .hero h2 {
                font-size: 1.5em;
            }
            
            .categories-grid {
                grid-template-columns: 1fr;
            }
            
            .folders-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }
    </style>
</head>
<body>
    <div class="hero">
        <img src="logo.png" alt="Quick Notes Logo" style="height: 120px; margin-bottom: 20px; border-radius: 20px;">
        <h1>Quick Notes</h1>
        <h2>Study Smarter, Learn Better</h2>
        <p>Access quality study materials organized by category</p>
    </div>
    
    <div class="container">
        <%
            List<FolderItem> folders = (List<FolderItem>) request.getAttribute("folders");
            List<FileItem> files = (List<FileItem>) request.getAttribute("files");
            List<BreadcrumbItem> breadcrumbs = (List<BreadcrumbItem>) request.getAttribute("breadcrumbs");
            String currentPath = (String) request.getAttribute("currentPath");
            if (currentPath == null) currentPath = "";
        %>
        
        <% if (currentPath.isEmpty()) { %>
            <div class="categories-section">
                <h2 class="categories-title">📚 Study Materials</h2>
                <div class="categories-grid">
                    <a href="list?path=Notes" class="category-button">
                        <span class="category-icon">📝</span>
                        <span class="category-name">Notes</span>
                    </a>
                    <a href="list?path=Question Papers" class="category-button">
                        <span class="category-icon">❓</span>
                        <span class="category-name">Question Papers</span>
                    </a>
                    <a href="list?path=Text Books" class="category-button">
                        <span class="category-icon">📖</span>
                        <span class="category-name">Text Books</span>
                    </a>
                    <a href="list?path=Guides" class="category-button">
                        <span class="category-icon">🎯</span>
                        <span class="category-name">Guides</span>
                    </a>
                </div>
            </div>
        <% } %>
        
        <div class="breadcrumb">
            <% if (breadcrumbs != null) {
                for (int i = 0; i < breadcrumbs.size(); i++) {
                    BreadcrumbItem crumb = breadcrumbs.get(i);
                    if (i == breadcrumbs.size() - 1) { %>
                        <span class="current"><%= crumb.getName() %></span>
                    <% } else { %>
                        <a href="list?path=<%= java.net.URLEncoder.encode(crumb.getPath(), "UTF-8") %>"><%= crumb.getName() %></a>
                        <span>/</span>
                    <% }
                }
            } %>
        </div>
        
        <div class="content-grid">
            <main class="main-content">
                <div class="notes-section">
                    <h3>📚 <%= currentPath.isEmpty() ? "All Materials" : currentPath.substring(currentPath.lastIndexOf("/") + 1) %></h3>
                    
                    <% if ((folders == null || folders.isEmpty()) && (files == null || files.isEmpty())) { %>
                        <div class="empty-state">
                            <div class="icon">📚</div>
                            <h4>No materials here yet</h4>
                            <p>Check back later or browse other categories!</p>
                        </div>
                    <% } else { %>
                        
                        <% if (folders != null && !folders.isEmpty()) { %>
                            <div class="folders-grid">
                                <% for (FolderItem folder : folders) { %>
                                    <a href="list?path=<%= java.net.URLEncoder.encode(folder.getPath(), "UTF-8") %>" class="folder-card">
                                        <span class="folder-icon">📁</span>
                                        <div class="folder-info">
                                            <h4><%= folder.getName() %></h4>
                                            <span><%= folder.getFileCount() %> files</span>
                                        </div>
                                    </a>
                                <% } %>
                            </div>
                        <% } %>
                        
                        <% if (files != null && !files.isEmpty()) { %>
                            <div class="files-grid">
                                <% for (FileItem file : files) {
                                    String iconClass = "default";
                                    String fileType = "Document";
                                    String lowerName = file.getName().toLowerCase();
                                    if (lowerName.endsWith(".pdf")) {
                                        iconClass = "pdf";
                                        fileType = "PDF Document";
                                    } else if (lowerName.endsWith(".doc") || lowerName.endsWith(".docx")) {
                                        iconClass = "doc";
                                        fileType = "Word Document";
                                    } else if (lowerName.endsWith(".ppt") || lowerName.endsWith(".pptx")) {
                                        iconClass = "ppt";
                                        fileType = "Presentation";
                                    } else if (lowerName.endsWith(".xls") || lowerName.endsWith(".xlsx")) {
                                        iconClass = "xls";
                                        fileType = "Spreadsheet";
                                    }
                                %>
                                <a href="download?file=<%= java.net.URLEncoder.encode(file.getPath(), "UTF-8") %>" class="file-card">
                                    <div class="file-header">
                                        <div class="file-icon <%= iconClass %>">📄</div>
                                        <div class="file-info">
                                            <h4><%= file.getName() %></h4>
                                            <span><%= fileType %> • <%= file.getSize() %></span>
                                        </div>
                                    </div>
                                    <div class="download-btn">
                                        <span>⬇</span> Download
                                    </div>
                                </a>
                                <% } %>
                            </div>
                        <% } %>
                    <% } %>
                </div>
            </main>
        </div>
    </div>
    
    <footer>
        <div class="footer-links">
            <a href="#">About Us</a>
            <a href="#">Contact</a>
            <a href="#">Privacy Policy</a>
            <a href="#">Terms of Use</a>
        </div>
        <div class="footer-brand">Quick Notes</div>
        <div class="footer-copyright">Copyright 2025 Quick Notes. All rights reserved.</div>
    </footer>
    
    <a href="/admin/dashboard" class="admin-link">🔐 Admin</a>
</body>
</html>

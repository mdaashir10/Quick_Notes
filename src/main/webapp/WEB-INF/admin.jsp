<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.notes.servlets.AdminDashboardServlet.FileInfo" %>
<%@ page import="com.notes.servlets.AdminDashboardServlet.FolderItem" %>
<%@ page import="com.notes.servlets.AdminDashboardServlet.BreadcrumbItem" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <title>Admin Dashboard - Quick Notes</title>
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
            padding: 20px;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        
        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 25px 30px;
            background: rgba(255,255,255,0.08);
            border-radius: 15px;
            margin-bottom: 30px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.1);
        }
        
        .header-left h1 {
            font-size: 1.8em;
            font-weight: 700;
            background: linear-gradient(135deg, #fff 0%, #4ecdc4 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .header-left p {
            font-size: 0.9em;
            opacity: 0.7;
            margin-top: 5px;
        }
        
        .header-right {
            text-align: right;
        }
        
        .admin-badge {
            display: inline-block;
            background: linear-gradient(135deg, #4ecdc4, #44a08d);
            padding: 6px 15px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: 600;
            margin-bottom: 8px;
        }
        
        .view-site-link {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            color: #4ecdc4;
            text-decoration: none;
            font-size: 0.9em;
            transition: all 0.3s ease;
        }
        
        .view-site-link:hover {
            color: #fff;
        }
        
        .message {
            padding: 18px 25px;
            border-radius: 12px;
            margin-bottom: 25px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .message.success {
            background: rgba(78, 205, 196, 0.2);
            color: #4ecdc4;
            border: 1px solid rgba(78, 205, 196, 0.3);
        }
        
        .message.error {
            background: rgba(255, 107, 107, 0.2);
            color: #ff6b6b;
            border: 1px solid rgba(255, 107, 107, 0.3);
        }
        
        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 15px 0;
            margin-bottom: 20px;
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
        
        .card {
            background: rgba(255,255,255,0.08);
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 25px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.1);
        }
        
        .card h2 {
            font-size: 1.3em;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #4ecdc4;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .forms-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .form-card {
            background: rgba(255,255,255,0.05);
            border-radius: 15px;
            padding: 25px;
            border: 1px solid rgba(255,255,255,0.1);
        }
        
        .form-card h3 {
            font-size: 1.1em;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-size: 0.9em;
            opacity: 0.8;
        }
        
        .form-group select,
        .form-group input[type="text"] {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 10px;
            background: rgba(255,255,255,0.05);
            color: white;
            font-family: 'Poppins', sans-serif;
            font-size: 0.95em;
        }
        
        .form-group select option {
            background: #302b63;
            color: white;
        }
        
        .form-group input[type="file"] {
            width: 100%;
            padding: 15px;
            border: 2px dashed rgba(255,255,255,0.3);
            border-radius: 10px;
            background: rgba(255,255,255,0.05);
            cursor: pointer;
            color: white;
            font-family: 'Poppins', sans-serif;
        }
        
        .form-group input[type="file"]:hover {
            border-color: #4ecdc4;
        }
        
        .form-group input[type="file"]::file-selector-button {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 8px 15px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-family: 'Poppins', sans-serif;
            font-weight: 600;
            margin-right: 15px;
        }
        
        .btn {
            padding: 14px 25px;
            border: none;
            border-radius: 10px;
            font-size: 0.95em;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            font-family: 'Poppins', sans-serif;
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .btn-upload {
            background: linear-gradient(135deg, #4ecdc4, #44a08d);
            color: white;
        }
        
        .btn-upload:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(78, 205, 196, 0.3);
        }
        
        .btn-create {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
        }
        
        .btn-create:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
        }
        
        .btn-delete {
            background: linear-gradient(135deg, #ff6b6b, #ee5a5a);
            color: white;
            padding: 8px 15px;
            font-size: 0.85em;
            width: auto;
        }
        
        .btn-delete:hover {
            transform: translateY(-2px);
        }
        
        .items-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 25px;
        }
        
        .folder-item {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 12px;
            padding: 20px;
            display: flex;
            align-items: center;
            gap: 15px;
            transition: all 0.3s;
            cursor: pointer;
            text-decoration: none;
            color: white;
        }
        
        .folder-item:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.3);
        }
        
        .folder-icon {
            font-size: 2em;
        }
        
        .folder-details h4 {
            font-size: 0.95em;
            margin-bottom: 3px;
        }
        
        .folder-details span {
            font-size: 0.8em;
            opacity: 0.8;
        }
        
        .folder-actions {
            margin-left: auto;
        }
        
        .files-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .files-table th,
        .files-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        
        .files-table th {
            background: rgba(255,255,255,0.05);
            font-weight: 600;
            color: #4ecdc4;
            font-size: 0.85em;
            text-transform: uppercase;
        }
        
        .files-table tbody tr {
            transition: all 0.3s ease;
        }
        
        .files-table tbody tr:hover {
            background: rgba(255,255,255,0.05);
        }
        
        .file-name {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .file-icon {
            width: 40px;
            height: 40px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1em;
        }
        
        .file-icon.pdf { background: linear-gradient(135deg, #ff6b6b, #ee5a5a); }
        .file-icon.doc { background: linear-gradient(135deg, #4facfe, #00f2fe); }
        .file-icon.ppt { background: linear-gradient(135deg, #f093fb, #f5576c); }
        .file-icon.xls { background: linear-gradient(135deg, #43e97b, #38f9d7); }
        .file-icon.default { background: linear-gradient(135deg, #667eea, #764ba2); }
        
        .empty-state {
            text-align: center;
            padding: 50px 20px;
        }
        
        .empty-state .icon {
            font-size: 3.5em;
            margin-bottom: 15px;
            opacity: 0.5;
        }
        
        .empty-state h4 {
            font-size: 1.2em;
            margin-bottom: 8px;
            opacity: 0.8;
        }
        
        .empty-state p {
            opacity: 0.6;
            font-size: 0.95em;
        }
        
        @media (max-width: 768px) {
            header {
                flex-direction: column;
                text-align: center;
                gap: 20px;
            }
            
            .header-right {
                text-align: center;
            }
            
            .forms-grid {
                grid-template-columns: 1fr;
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
        <header>
            <div class="header-left">
                <div style="display: flex; align-items: center; gap: 15px; margin-bottom: 10px;">
                    <img src="../logo.png" alt="Quick Notes Logo" style="height: 50px; border-radius: 10px;">
                    <div>
                        <h1 style="margin: 0; font-size: 1.6em;">Quick Notes</h1>
                        <p style="margin: 0; font-size: 0.8em; opacity: 0.7;">Admin Dashboard</p>
                    </div>
                </div>
            </div>
            <div class="header-right">
                <div class="admin-badge">👤 <%= request.getAttribute("adminUser") %></div>
                <br>
                <a href="/" class="view-site-link">← View Public Site</a>
            </div>
        </header>
        
        <%
            String message = (String) request.getAttribute("message");
            String messageType = (String) request.getAttribute("messageType");
            if (message != null && !message.isEmpty()) {
        %>
        <div class="message <%= messageType %>">
            <span><%= "success".equals(messageType) ? "✓" : "✕" %></span>
            <%= message %>
        </div>
        <%
            }
            
            List<FolderItem> folders = (List<FolderItem>) request.getAttribute("folders");
            List<FileInfo> noteFiles = (List<FileInfo>) request.getAttribute("noteFiles");
            List<FolderItem> allCategories = (List<FolderItem>) request.getAttribute("allCategories");
            List<BreadcrumbItem> breadcrumbs = (List<BreadcrumbItem>) request.getAttribute("breadcrumbs");
            String currentPath = (String) request.getAttribute("currentPath");
            if (currentPath == null) currentPath = "";
            SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy HH:mm");
        %>
        
        <div class="breadcrumb">
            📂
            <% if (breadcrumbs != null) {
                for (int i = 0; i < breadcrumbs.size(); i++) {
                    BreadcrumbItem crumb = breadcrumbs.get(i);
                    if (i == breadcrumbs.size() - 1) { %>
                        <span class="current"><%= crumb.getName() %></span>
                    <% } else { %>
                        <a href="dashboard?path=<%= java.net.URLEncoder.encode(crumb.getPath(), "UTF-8") %>"><%= crumb.getName() %></a>
                        <span>/</span>
                    <% }
                }
            } %>
        </div>
        
        <div class="card">
            <h2>➕ Add Content</h2>
            <div class="forms-grid">
                <div class="form-card">
                    <h3>📤 Upload File</h3>
                    <form action="upload" method="post" enctype="multipart/form-data">
                        <div class="form-group">
                            <label>Upload to category:</label>
                            <select name="category">
                                <option value="<%= currentPath %>" selected>
                                    <%= currentPath.isEmpty() ? "📁 Root folder (current)" : "📁 " + currentPath + " (current)" %>
                                </option>
                                <option value="">📁 Root folder</option>
                                <% if (allCategories != null) {
                                    for (FolderItem cat : allCategories) {
                                        if (!cat.getPath().equals(currentPath)) { %>
                                            <option value="<%= cat.getPath() %>">📁 <%= cat.getPath() %></option>
                                        <% }
                                    }
                                } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Select file:</label>
                            <input type="file" name="noteFile" required>
                        </div>
                        <button type="submit" class="btn btn-upload">
                            <span>⬆</span> Upload File
                        </button>
                    </form>
                </div>
                
                <div class="form-card">
                    <h3>📁 Create Folder</h3>
                    <form action="createFolder" method="post">
                        <div class="form-group">
                            <label>Create inside:</label>
                            <select name="parentPath">
                                <option value="<%= currentPath %>" selected>
                                    <%= currentPath.isEmpty() ? "📁 Root folder (current)" : "📁 " + currentPath + " (current)" %>
                                </option>
                                <option value="">📁 Root folder</option>
                                <% if (allCategories != null) {
                                    for (FolderItem cat : allCategories) {
                                        if (!cat.getPath().equals(currentPath)) { %>
                                            <option value="<%= cat.getPath() %>">📁 <%= cat.getPath() %></option>
                                        <% }
                                    }
                                } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Folder name:</label>
                            <input type="text" name="folderName" placeholder="e.g., Semester 1" required>
                        </div>
                        <button type="submit" class="btn btn-create">
                            <span>📁</span> Create Folder
                        </button>
                    </form>
                </div>
            </div>
        </div>
        
        <div class="card">
            <h2>📂 Contents of "<%= currentPath.isEmpty() ? "Root" : currentPath %>"</h2>
            
            <% if ((folders == null || folders.isEmpty()) && (noteFiles == null || noteFiles.isEmpty())) { %>
                <div class="empty-state">
                    <div class="icon">📁</div>
                    <h4>This folder is empty</h4>
                    <p>Upload files or create subfolders using the forms above</p>
                </div>
            <% } else { %>
                
                <% if (folders != null && !folders.isEmpty()) { %>
                    <h3 style="font-size: 1em; margin-bottom: 15px; opacity: 0.8;">📁 Folders</h3>
                    <div class="items-grid">
                        <% for (FolderItem folder : folders) { %>
                            <div class="folder-item">
                                <a href="dashboard?path=<%= java.net.URLEncoder.encode(folder.getPath(), "UTF-8") %>" style="display: flex; align-items: center; gap: 15px; text-decoration: none; color: white; flex: 1;">
                                    <span class="folder-icon">📁</span>
                                    <div class="folder-details">
                                        <h4><%= folder.getName() %></h4>
                                        <span><%= folder.getFileCount() %> files</span>
                                    </div>
                                </a>
                                <div class="folder-actions">
                                    <form action="delete" method="post" style="display: inline;" 
                                          onsubmit="return confirm('Delete folder &quot;<%= folder.getName() %>&quot; and ALL its contents?');">
                                        <input type="hidden" name="filePath" value="<%= folder.getPath() %>">
                                        <input type="hidden" name="deleteType" value="folder">
                                        <input type="hidden" name="currentPath" value="<%= currentPath %>">
                                        <button type="submit" class="btn btn-delete">🗑</button>
                                    </form>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } %>
                
                <% if (noteFiles != null && !noteFiles.isEmpty()) { %>
                    <h3 style="font-size: 1em; margin: 25px 0 15px; opacity: 0.8;">📄 Files</h3>
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
                                    String iconClass = "default";
                                    String lowerName = file.getName().toLowerCase();
                                    if (lowerName.endsWith(".pdf")) {
                                        iconClass = "pdf";
                                    } else if (lowerName.endsWith(".doc") || lowerName.endsWith(".docx")) {
                                        iconClass = "doc";
                                    } else if (lowerName.endsWith(".ppt") || lowerName.endsWith(".pptx")) {
                                        iconClass = "ppt";
                                    } else if (lowerName.endsWith(".xls") || lowerName.endsWith(".xlsx")) {
                                        iconClass = "xls";
                                    }
                            %>
                            <tr>
                                <td>
                                    <div class="file-name">
                                        <div class="file-icon <%= iconClass %>">📄</div>
                                        <span><%= file.getName() %></span>
                                    </div>
                                </td>
                                <td><%= file.getSize() %></td>
                                <td><%= dateFormat.format(new Date(file.getLastModified())) %></td>
                                <td>
                                    <form action="delete" method="post" style="display: inline;" 
                                          onsubmit="return confirm('Delete file &quot;<%= file.getName() %>&quot;?');">
                                        <input type="hidden" name="filePath" value="<%= file.getPath() %>">
                                        <input type="hidden" name="currentPath" value="<%= currentPath %>">
                                        <button type="submit" class="btn btn-delete">🗑 Delete</button>
                                    </form>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                <% } %>
            <% } %>
        </div>
    </div>
</body>
</html>

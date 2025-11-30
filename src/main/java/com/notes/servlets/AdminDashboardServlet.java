package com.notes.servlets;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    
    private static final String NOTES_DIR = System.getProperty("user.dir") + "/notes";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        loadFilesAndForward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        loadFilesAndForward(request, response);
    }
    
    private void loadFilesAndForward(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        File notesFolder = new File(NOTES_DIR);
        if (!notesFolder.exists()) {
            notesFolder.mkdirs();
        }
        
        String currentPath = (String) request.getAttribute("currentPath");
        if (currentPath == null) {
            currentPath = request.getParameter("path");
        }
        if (currentPath == null || currentPath.isEmpty()) {
            currentPath = "";
        }
        currentPath = sanitizePath(currentPath);
        
        File currentFolder = new File(NOTES_DIR, currentPath);
        if (!currentFolder.exists() || !currentFolder.isDirectory()) {
            currentFolder = notesFolder;
            currentPath = "";
        }
        
        if (!currentFolder.getCanonicalPath().startsWith(notesFolder.getCanonicalPath())) {
            currentFolder = notesFolder;
            currentPath = "";
        }
        
        List<FolderItem> folders = new ArrayList<>();
        List<FileInfo> files = new ArrayList<>();
        File[] items = currentFolder.listFiles();
        
        if (items != null) {
            Arrays.sort(items, (f1, f2) -> {
                if (f1.isDirectory() && !f2.isDirectory()) return -1;
                if (!f1.isDirectory() && f2.isDirectory()) return 1;
                return f1.getName().compareToIgnoreCase(f2.getName());
            });
            
            for (File item : items) {
                if (!item.getName().startsWith(".")) {
                    if (item.isDirectory()) {
                        String folderPath = currentPath.isEmpty() ? item.getName() : currentPath + "/" + item.getName();
                        int fileCount = countFiles(item);
                        folders.add(new FolderItem(item.getName(), folderPath, fileCount));
                    } else if (item.isFile()) {
                        String filePath = currentPath.isEmpty() ? item.getName() : currentPath + "/" + item.getName();
                        files.add(new FileInfo(
                            item.getName(),
                            filePath,
                            formatFileSize(item.length()),
                            item.lastModified()
                        ));
                    }
                }
            }
        }
        
        List<BreadcrumbItem> breadcrumbs = new ArrayList<>();
        breadcrumbs.add(new BreadcrumbItem("Root", ""));
        if (!currentPath.isEmpty()) {
            String[] parts = currentPath.split("/");
            StringBuilder pathBuilder = new StringBuilder();
            for (String part : parts) {
                if (!pathBuilder.toString().isEmpty()) {
                    pathBuilder.append("/");
                }
                pathBuilder.append(part);
                breadcrumbs.add(new BreadcrumbItem(part, pathBuilder.toString()));
            }
        }
        
        List<FolderItem> allCategories = new ArrayList<>();
        collectAllFolders(notesFolder, "", allCategories);
        
        request.setAttribute("folders", folders);
        request.setAttribute("noteFiles", files);
        request.setAttribute("currentPath", currentPath);
        request.setAttribute("breadcrumbs", breadcrumbs);
        request.setAttribute("allCategories", allCategories);
        
        String adminUser = request.getRemoteUser();
        request.setAttribute("adminUser", adminUser != null ? adminUser : "Admin");
        
        request.getRequestDispatcher("/WEB-INF/admin.jsp").forward(request, response);
    }
    
    private void collectAllFolders(File folder, String path, List<FolderItem> result) {
        File[] items = folder.listFiles();
        if (items != null) {
            Arrays.sort(items, (f1, f2) -> f1.getName().compareToIgnoreCase(f2.getName()));
            for (File item : items) {
                if (item.isDirectory() && !item.getName().startsWith(".")) {
                    String folderPath = path.isEmpty() ? item.getName() : path + "/" + item.getName();
                    result.add(new FolderItem(item.getName(), folderPath, countFiles(item)));
                    collectAllFolders(item, folderPath, result);
                }
            }
        }
    }
    
    private int countFiles(File folder) {
        int count = 0;
        File[] items = folder.listFiles();
        if (items != null) {
            for (File item : items) {
                if (item.isFile() && !item.getName().startsWith(".")) {
                    count++;
                } else if (item.isDirectory()) {
                    count += countFiles(item);
                }
            }
        }
        return count;
    }
    
    private String formatFileSize(long size) {
        if (size < 1024) {
            return size + " B";
        } else if (size < 1024 * 1024) {
            return String.format("%.1f KB", size / 1024.0);
        } else if (size < 1024 * 1024 * 1024) {
            return String.format("%.1f MB", size / (1024.0 * 1024));
        } else {
            return String.format("%.1f GB", size / (1024.0 * 1024 * 1024));
        }
    }
    
    private String sanitizePath(String path) {
        path = path.replace("\\", "/");
        path = path.replaceAll("\\.{2,}", "");
        path = path.replaceAll("^/+", "");
        path = path.replaceAll("/+$", "");
        path = path.replaceAll("/+", "/");
        return path;
    }
    
    public static class FolderItem {
        private String name;
        private String path;
        private int fileCount;
        
        public FolderItem(String name, String path, int fileCount) {
            this.name = name;
            this.path = path;
            this.fileCount = fileCount;
        }
        
        public String getName() { return name; }
        public String getPath() { return path; }
        public int getFileCount() { return fileCount; }
    }
    
    public static class FileInfo {
        private String name;
        private String path;
        private String size;
        private long lastModified;
        
        public FileInfo(String name, String path, String size, long lastModified) {
            this.name = name;
            this.path = path;
            this.size = size;
            this.lastModified = lastModified;
        }
        
        public String getName() { return name; }
        public String getPath() { return path; }
        public String getSize() { return size; }
        public long getLastModified() { return lastModified; }
    }
    
    public static class BreadcrumbItem {
        private String name;
        private String path;
        
        public BreadcrumbItem(String name, String path) {
            this.name = name;
            this.path = path;
        }
        
        public String getName() { return name; }
        public String getPath() { return path; }
    }
}

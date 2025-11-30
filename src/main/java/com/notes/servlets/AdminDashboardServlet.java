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

/**
 * AdminDashboardServlet - Displays the admin dashboard with file management.
 * 
 * This servlet lists all files and provides the admin interface
 * for uploading and deleting files.
 * Only accessible by authenticated admin users.
 * 
 * @author Admin
 */
@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    
    // Directory where notes are stored
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
    
    /**
     * Loads the list of files and forwards to the admin JSP.
     */
    private void loadFilesAndForward(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Create the notes directory if it doesn't exist
        File notesFolder = new File(NOTES_DIR);
        if (!notesFolder.exists()) {
            notesFolder.mkdirs();
        }
        
        // Get list of all files in the notes directory
        List<FileInfo> noteFiles = new ArrayList<>();
        File[] files = notesFolder.listFiles();
        
        if (files != null) {
            // Sort files by name for consistent display
            Arrays.sort(files, (f1, f2) -> f1.getName().compareToIgnoreCase(f2.getName()));
            
            for (File file : files) {
                // Only include regular files, not directories or hidden files
                if (file.isFile() && !file.getName().startsWith(".")) {
                    noteFiles.add(new FileInfo(
                        file.getName(),
                        formatFileSize(file.length()),
                        file.lastModified()
                    ));
                }
            }
        }
        
        // Store the file list in request attribute for JSP to access
        request.setAttribute("noteFiles", noteFiles);
        request.setAttribute("notesDir", NOTES_DIR);
        
        // Get the logged-in admin username
        String adminUser = request.getRemoteUser();
        request.setAttribute("adminUser", adminUser != null ? adminUser : "Admin");
        
        // Forward to admin.jsp for display
        request.getRequestDispatcher("/WEB-INF/admin.jsp").forward(request, response);
    }
    
    /**
     * Formats file size into human-readable format.
     * 
     * @param size File size in bytes
     * @return Formatted size string (e.g., "1.5 MB")
     */
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
    
    /**
     * Simple class to hold file information for display.
     */
    public static class FileInfo {
        private String name;
        private String size;
        private long lastModified;
        
        public FileInfo(String name, String size, long lastModified) {
            this.name = name;
            this.size = size;
            this.lastModified = lastModified;
        }
        
        public String getName() { return name; }
        public String getSize() { return size; }
        public long getLastModified() { return lastModified; }
    }
}

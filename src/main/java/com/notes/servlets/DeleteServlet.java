package com.notes.servlets;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * DeleteServlet - Handles file deletion for admin users.
 * 
 * This servlet deletes note files from the notes directory.
 * Only accessible by authenticated admin users.
 * 
 * @author Admin
 */
@WebServlet("/admin/delete")
public class DeleteServlet extends HttpServlet {
    
    // Directory where notes are stored
    private static final String NOTES_DIR = System.getProperty("user.dir") + "/notes";
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get the filename to delete from the request
        String fileName = request.getParameter("fileName");
        
        if (fileName == null || fileName.trim().isEmpty()) {
            // No filename provided
            request.setAttribute("message", "Error: No file specified for deletion.");
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("/admin/dashboard").forward(request, response);
            return;
        }
        
        // Sanitize the filename to prevent directory traversal attacks
        fileName = sanitizeFileName(fileName);
        
        // Create path to the file
        Path filePath = Paths.get(NOTES_DIR, fileName);
        File fileToDelete = filePath.toFile();
        
        // Security check: ensure the file is within the notes directory
        if (!fileToDelete.getCanonicalPath().startsWith(new File(NOTES_DIR).getCanonicalPath())) {
            request.setAttribute("message", "Error: Invalid file path.");
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("/admin/dashboard").forward(request, response);
            return;
        }
        
        // Check if file exists
        if (!fileToDelete.exists()) {
            request.setAttribute("message", "Error: File '" + fileName + "' does not exist.");
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("/admin/dashboard").forward(request, response);
            return;
        }
        
        // Check if it's actually a file (not a directory)
        if (!fileToDelete.isFile()) {
            request.setAttribute("message", "Error: Cannot delete directories.");
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("/admin/dashboard").forward(request, response);
            return;
        }
        
        // Attempt to delete the file
        try {
            Files.delete(filePath);
            request.setAttribute("message", "Success: File '" + fileName + "' deleted successfully!");
            request.setAttribute("messageType", "success");
        } catch (IOException e) {
            request.setAttribute("message", "Error: Could not delete file. " + e.getMessage());
            request.setAttribute("messageType", "error");
        }
        
        // Forward to admin dashboard
        request.getRequestDispatcher("/admin/dashboard").forward(request, response);
    }
    
    /**
     * Sanitizes the filename to prevent security issues.
     * Removes potentially dangerous characters and path components.
     * 
     * @param fileName The original filename
     * @return A sanitized, safe filename
     */
    private String sanitizeFileName(String fileName) {
        // Remove any path separators to prevent directory traversal
        fileName = fileName.replaceAll("[/\\\\]", "");
        // Remove any null bytes
        fileName = fileName.replace("\0", "");
        return fileName;
    }
}

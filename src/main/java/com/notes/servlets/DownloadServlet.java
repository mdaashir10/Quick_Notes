package com.notes.servlets;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.nio.file.Files;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * DownloadServlet - Handles file downloads for public users.
 * 
 * This servlet serves note files for download.
 * No authentication required - anyone can download notes.
 * 
 * @author Admin
 */
@WebServlet("/download")
public class DownloadServlet extends HttpServlet {
    
    // Directory where notes are stored
    private static final String NOTES_DIR = System.getProperty("user.dir") + "/notes";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get the filename from the request parameter
        String fileName = request.getParameter("file");
        
        if (fileName == null || fileName.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No file specified");
            return;
        }
        
        // Sanitize the filename to prevent directory traversal attacks
        fileName = sanitizeFileName(fileName);
        
        // Create the file path
        File file = new File(NOTES_DIR, fileName);
        
        // Security check: ensure the file is within the notes directory
        if (!file.getCanonicalPath().startsWith(new File(NOTES_DIR).getCanonicalPath())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }
        
        // Check if file exists
        if (!file.exists() || !file.isFile()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found");
            return;
        }
        
        // Determine the content type based on file extension
        String contentType = getServletContext().getMimeType(fileName);
        if (contentType == null) {
            contentType = "application/octet-stream";
        }
        
        // Set response headers for file download
        response.setContentType(contentType);
        response.setContentLength((int) file.length());
        
        // Set Content-Disposition header to prompt download with original filename
        String encodedFileName = URLEncoder.encode(fileName, "UTF-8").replace("+", "%20");
        response.setHeader("Content-Disposition", 
            "attachment; filename=\"" + fileName + "\"; filename*=UTF-8''" + encodedFileName);
        
        // Stream the file to the response
        try (FileInputStream fis = new FileInputStream(file);
             OutputStream os = response.getOutputStream()) {
            
            byte[] buffer = new byte[4096];
            int bytesRead;
            
            while ((bytesRead = fis.read(buffer)) != -1) {
                os.write(buffer, 0, bytesRead);
            }
        }
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

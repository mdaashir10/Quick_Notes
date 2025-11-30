package com.notes.servlets;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

/**
 * UploadServlet - Handles file uploads for admin users.
 * 
 * This servlet processes multipart form data to upload note files.
 * Only accessible by authenticated admin users.
 * 
 * @MultipartConfig enables multipart/form-data handling for file uploads.
 * 
 * @author Admin
 */
@WebServlet("/admin/upload")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,      // 1 MB - files larger than this are written to disk
    maxFileSize = 1024 * 1024 * 10,       // 10 MB - maximum size per file
    maxRequestSize = 1024 * 1024 * 50     // 50 MB - maximum total request size
)
public class UploadServlet extends HttpServlet {
    
    // Directory where notes are stored
    private static final String NOTES_DIR = System.getProperty("user.dir") + "/notes";
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Ensure the notes directory exists
        File notesFolder = new File(NOTES_DIR);
        if (!notesFolder.exists()) {
            notesFolder.mkdirs();
        }
        
        // Get the uploaded file part from the request
        Part filePart = request.getPart("noteFile");
        
        if (filePart == null || filePart.getSize() == 0) {
            // No file was uploaded
            request.setAttribute("message", "Error: Please select a file to upload.");
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("/admin/dashboard").forward(request, response);
            return;
        }
        
        // Extract the original filename from the Part
        String fileName = extractFileName(filePart);
        
        if (fileName == null || fileName.isEmpty()) {
            request.setAttribute("message", "Error: Invalid file name.");
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("/admin/dashboard").forward(request, response);
            return;
        }
        
        // Sanitize the filename to prevent directory traversal attacks
        fileName = sanitizeFileName(fileName);
        
        // Create the target path for the file
        Path targetPath = Paths.get(NOTES_DIR, fileName);
        
        // Check if file already exists
        if (Files.exists(targetPath)) {
            request.setAttribute("message", "Error: A file with this name already exists. Please rename your file.");
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("/admin/dashboard").forward(request, response);
            return;
        }
        
        // Save the uploaded file
        try (InputStream fileContent = filePart.getInputStream()) {
            Files.copy(fileContent, targetPath, StandardCopyOption.REPLACE_EXISTING);
        }
        
        // Set success message and redirect to admin dashboard
        request.setAttribute("message", "Success: File '" + fileName + "' uploaded successfully!");
        request.setAttribute("messageType", "success");
        request.getRequestDispatcher("/admin/dashboard").forward(request, response);
    }
    
    /**
     * Extracts the filename from the Content-Disposition header of a Part.
     * 
     * @param part The file Part from the multipart request
     * @return The extracted filename, or null if not found
     */
    private String extractFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        
        if (contentDisposition != null) {
            // Parse the Content-Disposition header to find filename
            for (String token : contentDisposition.split(";")) {
                if (token.trim().startsWith("filename")) {
                    // Extract the filename value
                    String fileName = token.substring(token.indexOf('=') + 1).trim();
                    // Remove surrounding quotes if present
                    fileName = fileName.replace("\"", "");
                    // Handle browsers that send full path (IE)
                    int lastSeparator = Math.max(fileName.lastIndexOf('/'), fileName.lastIndexOf('\\'));
                    if (lastSeparator >= 0) {
                        fileName = fileName.substring(lastSeparator + 1);
                    }
                    return fileName;
                }
            }
        }
        return null;
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
        // Replace multiple dots with single dot
        fileName = fileName.replaceAll("\\.{2,}", ".");
        // Remove leading dots
        while (fileName.startsWith(".")) {
            fileName = fileName.substring(1);
        }
        return fileName;
    }
}

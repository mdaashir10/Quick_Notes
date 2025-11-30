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

@WebServlet("/admin/upload")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 50,
    maxRequestSize = 1024 * 1024 * 100
)
public class UploadServlet extends HttpServlet {
    
    private static final String NOTES_DIR = System.getProperty("user.dir") + "/notes";
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        File notesFolder = new File(NOTES_DIR);
        if (!notesFolder.exists()) {
            notesFolder.mkdirs();
        }
        
        String category = request.getParameter("category");
        if (category == null) {
            category = "";
        }
        category = sanitizePath(category);
        
        File targetFolder = category.isEmpty() ? notesFolder : new File(NOTES_DIR, category);
        
        if (!targetFolder.getCanonicalPath().startsWith(notesFolder.getCanonicalPath())) {
            request.setAttribute("message", "Error: Invalid category path.");
            request.setAttribute("messageType", "error");
            request.setAttribute("currentPath", "");
            request.getRequestDispatcher("/admin/dashboard").forward(request, response);
            return;
        }
        
        if (!targetFolder.exists()) {
            targetFolder.mkdirs();
        }
        
        Part filePart = request.getPart("noteFile");
        
        if (filePart == null || filePart.getSize() == 0) {
            request.setAttribute("message", "Error: Please select a file to upload.");
            request.setAttribute("messageType", "error");
            request.setAttribute("currentPath", category);
            request.getRequestDispatcher("/admin/dashboard").forward(request, response);
            return;
        }
        
        String fileName = extractFileName(filePart);
        
        if (fileName == null || fileName.isEmpty()) {
            request.setAttribute("message", "Error: Invalid file name.");
            request.setAttribute("messageType", "error");
            request.setAttribute("currentPath", category);
            request.getRequestDispatcher("/admin/dashboard").forward(request, response);
            return;
        }
        
        fileName = sanitizeFileName(fileName);
        
        Path targetPath = Paths.get(targetFolder.getPath(), fileName);
        
        if (Files.exists(targetPath)) {
            request.setAttribute("message", "Error: A file with this name already exists in this category.");
            request.setAttribute("messageType", "error");
            request.setAttribute("currentPath", category);
            request.getRequestDispatcher("/admin/dashboard").forward(request, response);
            return;
        }
        
        try (InputStream fileContent = filePart.getInputStream()) {
            Files.copy(fileContent, targetPath, StandardCopyOption.REPLACE_EXISTING);
        }
        
        String location = category.isEmpty() ? "root folder" : "'" + category + "'";
        request.setAttribute("message", "Success: File '" + fileName + "' uploaded to " + location + "!");
        request.setAttribute("messageType", "success");
        request.setAttribute("currentPath", category);
        request.getRequestDispatcher("/admin/dashboard").forward(request, response);
    }
    
    private String extractFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        
        if (contentDisposition != null) {
            for (String token : contentDisposition.split(";")) {
                if (token.trim().startsWith("filename")) {
                    String fileName = token.substring(token.indexOf('=') + 1).trim();
                    fileName = fileName.replace("\"", "");
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
    
    private String sanitizeFileName(String fileName) {
        fileName = fileName.replaceAll("[/\\\\]", "");
        fileName = fileName.replace("\0", "");
        fileName = fileName.replaceAll("\\.{2,}", ".");
        while (fileName.startsWith(".")) {
            fileName = fileName.substring(1);
        }
        return fileName;
    }
    
    private String sanitizePath(String path) {
        path = path.replace("\\", "/");
        path = path.replaceAll("\\.{2,}", "");
        path = path.replaceAll("^/+", "");
        path = path.replaceAll("/+$", "");
        path = path.replaceAll("/+", "/");
        return path;
    }
}

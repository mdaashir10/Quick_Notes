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

@WebServlet("/admin/delete")
public class DeleteServlet extends HttpServlet {
    
    private static final String NOTES_DIR = System.getProperty("user.dir") + "/notes";
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String filePath = request.getParameter("filePath");
        String deleteType = request.getParameter("deleteType");
        String currentPath = request.getParameter("currentPath");
        
        if (currentPath == null) {
            currentPath = "";
        }
        currentPath = sanitizePath(currentPath);
        
        if (filePath == null || filePath.trim().isEmpty()) {
            request.setAttribute("message", "Error: No file specified for deletion.");
            request.setAttribute("messageType", "error");
            request.setAttribute("currentPath", currentPath);
            request.getRequestDispatcher("/admin/dashboard").forward(request, response);
            return;
        }
        
        filePath = sanitizePath(filePath);
        
        Path targetPath = Paths.get(NOTES_DIR, filePath);
        File fileToDelete = targetPath.toFile();
        File notesFolder = new File(NOTES_DIR);
        
        if (!fileToDelete.getCanonicalPath().startsWith(notesFolder.getCanonicalPath())) {
            request.setAttribute("message", "Error: Invalid file path.");
            request.setAttribute("messageType", "error");
            request.setAttribute("currentPath", currentPath);
            request.getRequestDispatcher("/admin/dashboard").forward(request, response);
            return;
        }
        
        if (!fileToDelete.exists()) {
            request.setAttribute("message", "Error: File or folder does not exist.");
            request.setAttribute("messageType", "error");
            request.setAttribute("currentPath", currentPath);
            request.getRequestDispatcher("/admin/dashboard").forward(request, response);
            return;
        }
        
        String itemName = fileToDelete.getName();
        
        try {
            if (fileToDelete.isDirectory()) {
                if ("folder".equals(deleteType)) {
                    deleteDirectory(fileToDelete);
                    request.setAttribute("message", "Success: Folder '" + itemName + "' and all its contents deleted!");
                } else {
                    request.setAttribute("message", "Error: Cannot delete folder without confirmation.");
                    request.setAttribute("messageType", "error");
                    request.setAttribute("currentPath", currentPath);
                    request.getRequestDispatcher("/admin/dashboard").forward(request, response);
                    return;
                }
            } else {
                Files.delete(targetPath);
                request.setAttribute("message", "Success: File '" + itemName + "' deleted!");
            }
            request.setAttribute("messageType", "success");
        } catch (IOException e) {
            request.setAttribute("message", "Error: Could not delete. " + e.getMessage());
            request.setAttribute("messageType", "error");
        }
        
        request.setAttribute("currentPath", currentPath);
        request.getRequestDispatcher("/admin/dashboard").forward(request, response);
    }
    
    private void deleteDirectory(File directory) throws IOException {
        File[] files = directory.listFiles();
        if (files != null) {
            for (File file : files) {
                if (file.isDirectory()) {
                    deleteDirectory(file);
                } else {
                    Files.delete(file.toPath());
                }
            }
        }
        Files.delete(directory.toPath());
    }
    
    private String sanitizePath(String path) {
        path = path.replace("\\", "/");
        path = path.replaceAll("\\.\\./", "");
        path = path.replaceAll("\\.\\.\\\\", "");
        path = path.replace("\0", "");
        path = path.replaceAll("^/+", "");
        path = path.replaceAll("/+$", "");
        return path;
    }
}

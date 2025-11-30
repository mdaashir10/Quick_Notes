package com.notes.servlets;

import java.io.File;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/admin/createFolder")
public class CreateFolderServlet extends HttpServlet {
    
    private static final String NOTES_DIR = System.getProperty("user.dir") + "/notes";
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        File notesFolder = new File(NOTES_DIR);
        if (!notesFolder.exists()) {
            notesFolder.mkdirs();
        }
        
        String folderName = request.getParameter("folderName");
        String parentPath = request.getParameter("parentPath");
        
        if (parentPath == null) {
            parentPath = "";
        }
        parentPath = sanitizePath(parentPath);
        
        if (folderName == null || folderName.trim().isEmpty()) {
            request.setAttribute("message", "Error: Please enter a folder name.");
            request.setAttribute("messageType", "error");
            request.setAttribute("currentPath", parentPath);
            request.getRequestDispatcher("/admin/dashboard").forward(request, response);
            return;
        }
        
        folderName = sanitizeFolderName(folderName);
        
        if (folderName.isEmpty()) {
            request.setAttribute("message", "Error: Invalid folder name.");
            request.setAttribute("messageType", "error");
            request.setAttribute("currentPath", parentPath);
            request.getRequestDispatcher("/admin/dashboard").forward(request, response);
            return;
        }
        
        File parentFolder = parentPath.isEmpty() ? notesFolder : new File(NOTES_DIR, parentPath);
        
        if (!parentFolder.getCanonicalPath().startsWith(notesFolder.getCanonicalPath())) {
            request.setAttribute("message", "Error: Invalid parent path.");
            request.setAttribute("messageType", "error");
            request.setAttribute("currentPath", "");
            request.getRequestDispatcher("/admin/dashboard").forward(request, response);
            return;
        }
        
        if (!parentFolder.exists()) {
            parentFolder.mkdirs();
        }
        
        File newFolder = new File(parentFolder, folderName);
        
        if (newFolder.exists()) {
            request.setAttribute("message", "Error: A folder with this name already exists.");
            request.setAttribute("messageType", "error");
            request.setAttribute("currentPath", parentPath);
            request.getRequestDispatcher("/admin/dashboard").forward(request, response);
            return;
        }
        
        if (newFolder.mkdir()) {
            request.setAttribute("message", "Success: Folder '" + folderName + "' created!");
            request.setAttribute("messageType", "success");
        } else {
            request.setAttribute("message", "Error: Could not create folder.");
            request.setAttribute("messageType", "error");
        }
        
        request.setAttribute("currentPath", parentPath);
        request.getRequestDispatcher("/admin/dashboard").forward(request, response);
    }
    
    private String sanitizeFolderName(String name) {
        name = name.replaceAll("[/\\\\:*?\"<>|]", "");
        name = name.replace("\0", "");
        name = name.replaceAll("\\.{2,}", ".");
        while (name.startsWith(".")) {
            name = name.substring(1);
        }
        name = name.trim();
        return name;
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

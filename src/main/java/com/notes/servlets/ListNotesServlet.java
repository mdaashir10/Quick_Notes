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
 * ListNotesServlet - Handles listing all note files for the public page.
 * 
 * This servlet reads the notes directory and passes the list of files
 * to the index.jsp for display. No authentication required.
 * 
 * @author Admin
 */
@WebServlet("/list")
public class ListNotesServlet extends HttpServlet {
    
    // Directory where notes are stored
    private static final String NOTES_DIR = System.getProperty("user.dir") + "/notes";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Create the notes directory if it doesn't exist
        File notesFolder = new File(NOTES_DIR);
        if (!notesFolder.exists()) {
            notesFolder.mkdirs();
        }
        
        // Get list of all files in the notes directory
        List<String> noteFiles = new ArrayList<>();
        File[] files = notesFolder.listFiles();
        
        if (files != null) {
            // Sort files by name for consistent display
            Arrays.sort(files, (f1, f2) -> f1.getName().compareToIgnoreCase(f2.getName()));
            
            for (File file : files) {
                // Only include regular files, not directories or hidden files
                if (file.isFile() && !file.getName().startsWith(".")) {
                    noteFiles.add(file.getName());
                }
            }
        }
        
        // Store the file list in request attribute for JSP to access
        request.setAttribute("noteFiles", noteFiles);
        request.setAttribute("notesDir", NOTES_DIR);
        
        // Forward to index.jsp for display
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%
        // Check if the user is logged in by looking for a session attribute
        HttpSession httpsession = request.getSession(false); // Don't create a new session if it doesn't exist
        String username = (httpsession != null) ? (String) httpsession.getAttribute("username") : null;

        if (username == null) {
            // If no session, redirect to login page
            response.sendRedirect("login.jsp");
        } else {
        	 
        }
    %>
        <h2>Welcome, <%= username %> to your Customer Representative Dashboard!</h2>
</body>
</html>
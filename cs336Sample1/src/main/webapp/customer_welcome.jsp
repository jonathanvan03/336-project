<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Welcome</title>
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
    %>
        <h2>Welcome, <%= username %>!</h2>
        <p>You have successfully logged in.</p>
        <form action="schedule.jsp" method="post">
            <input type="submit" value="View Schedule">
        </form>
        <br>
        <form action="logout.jsp" method="post">
            <input type="submit" value="Logout">
        </form>
    <%
        }
    %>
</body>
</html>
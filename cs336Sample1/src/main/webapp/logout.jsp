<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Invalidate the session to log out the user
    HttpSession httpsession = request.getSession(false); // Get existing session if exists
    if (httpsession != null) {
        httpsession.invalidate(); // Invalidate the session
    }

    // Redirect to the login page after logout
    response.sendRedirect("login.jsp");
%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Customer Representatives</title>
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
        <h1>Manage Customer Representatives</h1>
        <br>
        <br>
        <h2>Add a new representative: </h2>
        <form action="addrep.jsp" method="post">
        	SSN: <input type="text" name="repssn" required/>
        	First name: <input type="text" name="repfname" required/>
        	Last name: <input type="text" name="replname" required/>
        	Username: <input type="text" name="repusername" required/>
        	Password: <input type="password" name="reppass" required/>
            <input type="submit" value="Go">
        </form>
        <br>
        <br>
        <h2>Update an existing representative: </h2>
        <form action="editrep.jsp" method="post">
        	Update representative account with username: <input type="text" name="repusername" required/>
        	<p>Only populate fields you wish to update</p>
        	SSN: <input type="text" name="repssn"/>
        	First name: <input type="text" name="repfname" />
        	Last name: <input type="text" name="replname" />
        	Username: <input type="text" name="newrepusername" />
        	Password: <input type="password" name="reppass" />
            <input type="submit" value="Go">
        </form>
        <br>
        <br>
        <h2>Delete representative account: </h2>
        <form action="deleterep.jsp" method="post">
        	Delete representative account with username: <input type="text" name="repusername" required/>
            <input type="submit" value="Go">
        </form>
        <br>
        <br>
        <h2>Return</h2>
        <form action="admin_dashboard.jsp" method="post">
            <input type="submit" value="Back">
        </form>
    <%
        }
    %>
</body>
</html>
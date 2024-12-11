<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Dashboard</title>
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
        <h2>Welcome, <%= username %> to your admin dashboard!</h2>
        <br>
        <br>
        <p>Manage customer representatives: </p>
        <form action="ManageReps.jsp" method="post">
            <input type="submit" value="Go">
        </form>
        <br>
        <p>Get monthly sales report:</p>
        <form action="salesreport.jsp" method="post">
            Year-Month: <input type="month" name="month" required/>
        <input type="submit" value="Get">
        </form>
        <br>
        <p>Get reservations by transit line:</p>
        <form action="Reservationsbyline.jsp" method="post">
            Transit Line: <input type="text" name="linename" required/>
        <input type="submit" value="Get">
        </form>
        <br>
        <p>Get reservations by customer:</p>
        <form action="Reservationsbycustomer.jsp" method="post">
            Customer username: <input type="text" name="cust_name" required/>
        <input type="submit" value="Get">
        </form>
        <br>
        <p>See revenue by transit line:</p>
        <form action="Revenuebyline.jsp" method="post">
        <input type="submit" value="Get">
        </form>
        <br>
        <p>See reservations by customer:</p>
        <form action="Revenuebycustomer.jsp" method="post">
        <input type="submit" value="Get">
        </form>
        <br>
        <p>See best customer:</p>
        <form action="Bestcustomer.jsp" method="post">
        <input type="submit" value="Get">
        </form>
        <br>
        <p>See 5 most active transit lines:</p>
        <form action="top5lines.jsp" method="post">
        <input type="submit" value="Get">
        </form>
        <br><br><br><br>
        <form action="logout.jsp" method="post">
            <input type="submit" value="Logout">
        </form>
    <%
        }
    %>
</body>
</html>
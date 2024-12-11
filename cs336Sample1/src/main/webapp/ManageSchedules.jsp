<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Schedules</title>
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
        <h1>Manage Schedules</h1>
        <br>
        <br>
      
        <h2>Update an existing schedule: </h2>
        <form action="editschedule.jsp" method="post">
        	<p>Update schedule with: </p>
        	Transit Line <input type="text" name="transit_line" required/>
        	Train ID <input type="text" name="train_id" required/>
        	Departure Time <input type="datetime" name="depart_time" required/>
        	<p>Only populate fields you wish to update</p>
        	Transit Line <input type="text" name="newtransit_line"/>
        	Train ID <input type="text" name="newtrain_id"/>
        	Origin <input type="text" name="origin"/>
        	Destination <input type="text" name="destination"/>
        	Departure Time <input type="datetime" name="newdepart_time"/>
        	Arrival Time <input type="datetime" name="arrival_time"/>
        	Travel Time <input type="number" name="travel_time"/>
        	Number of Stops <input type="number" name="num_stops"/>
            <input type="submit" value="Go">
        </form>
        <br>
        <br>
        <h2>Delete a schedule: </h2>
        <form action="deleteschedule.jsp" method="post">
        	<p>Update schedule with: </p>
        	Transit Line <input type="text" name="transit_line" required/>
        	Train ID <input type="text" name="train_id" required/>
        	Departure Time <input type="datetime" name="depart_time" required/>
            <input type="submit" value="Go">
        </form>
        <br>
        <br>
        <h2>Return</h2>
        <form action="rep_dashboard.jsp" method="post">
            <input type="submit" value="Back">
        </form>
    <%
        }
    %>
</body>
</html>
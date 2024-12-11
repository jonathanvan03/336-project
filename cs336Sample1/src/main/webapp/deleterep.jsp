<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Add Representative</title>
</head>
</head>
	<body>
		<% try {
	
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		
		
	        String username = request.getParameter("repusername");
	        
	        try {
	        	String deleteSql = "DELETE FROM employees WHERE username = ?";
	            stmt = conn.prepareStatement(deleteSql);
	            stmt.setString(1, username);

	            // Execute the statement
	            int rowsDeleted = stmt.executeUpdate();
	            if (rowsDeleted > 0) {
	                out.println("<p>Entry with username '" + username + "' has been successfully deleted!</p>");
	            } else {
	                out.println("<p>No entry found with the username '" + username + "'.</p>");
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	            out.println("<p>Error occurred: " + e.getMessage() + "</p>");
	        } finally {
	            // Close resources
	            if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
	            if (con != null) try { con.close(); } catch (SQLException e) {}
	        }
	       
	        
		%>
			
		<!--  Make an HTML table to show the results in: -->
	

			
		<%} catch (Exception e) {
			out.print(e);
		}%>
	

	</body>
</html>
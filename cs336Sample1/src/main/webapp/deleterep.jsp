<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
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
			PreparedStatement stmt = null;
		
	        String username = request.getParameter("repusername");
	        
	        try {
	        	String deleteSql = "DELETE FROM employee WHERE username = ?";
	            stmt = con.prepareStatement(deleteSql);
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
			
	

			
		<%} catch (Exception e) {
			out.print(e);
		}%>
	<h2>Return</h2>
	        <form action="admin_dashboard.jsp" method="post">
	            <input type="submit" value="Back">
	        </form>

	</body>
</html>
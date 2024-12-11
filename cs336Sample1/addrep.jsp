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
			String fname = request.getParameter("repfname");
			String lname = request.getParameter("replname");
	        String username = request.getParameter("repusername");
	        String password = request.getParameter("reppass");
	        Integer ssn = Integer.parseInt(request.getParameter("repssn"));
	        try {
	            // Prepare SQL statement
	            String sql = "INSERT INTO employee (ssn, first_name, last_name, username, password) VALUES (?, ?, ?, ?, ?)";
            	stmt = con.prepareStatement(sql);
            	stmt.setInt(1, ssn);
            	stmt.setString(2, fname);
            	stmt.setString(3, lname);
            	stmt.setString(4, username);
            	stmt.setString(5, password);

	            // Execute the statement
	            int rowsInserted = stmt.executeUpdate();
	            if (rowsInserted > 0) {
	                out.println("<p>New entry has been successfully created!</p>");
	            } else {
	                out.println("<p>Failed to create new entry.</p>");
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
			<h2>Return</h2>
	        <form action="admin_dashboard.jsp" method="post">
	            <input type="submit" value="Back">
	        </form>
			
		<!--  Make an HTML table to show the results in: -->
	

			
		<%} catch (Exception e) {
			out.print(e);
		}%>
	

	</body>
</html>
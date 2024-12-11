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
		
			String transit_line =  request.getParameter("transit_line");
			String train_id =  request.getParameter("train_id");
			String departTimeStr =  request.getParameter("depart_time");
			Timestamp depart_time = (departTimeStr != null && !departTimeStr.isEmpty()) 
                    ? Timestamp.valueOf(departTimeStr) 
                    : null;
	        
	        try {
	        	String deleteSql = "DELETE FROM schedule WHERE transit_line = ? AND train_id = ? AND depart_time = ?";
	            stmt = con.prepareStatement(deleteSql);
	            stmt.setString(1, transit_line);
	            stmt.setString(2, train_id);
	            stmt.setTimestamp(3, depart_time);
	        

	            // Execute the statement
	            int rowsDeleted = stmt.executeUpdate();
	            if (rowsDeleted > 0) {
	                out.println("<p>Schedule has been successfully deleted!</p>");
	            } else {
	                out.println("<p>Schedule not found.</p>");
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
	<h2>Return</h2>
	        <form action="rep_dashboard.jsp" method="post">
	            <input type="submit" value="Back">
	        </form>

	</body>
</html>
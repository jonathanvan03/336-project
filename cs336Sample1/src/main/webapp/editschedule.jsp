<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<html>
<head>
    <title>Edit Representative</title>
</head>
</head>
	<body>
		<% try {
	
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			PreparedStatement stmt = null;
			Connection con = db.getConnection();		
			String transit_line =  request.getParameter("transit_line");
			String train_id =  request.getParameter("train_id");
			String departTimeStr =  request.getParameter("depart_time");
			Timestamp depart_time = (departTimeStr != null && !departTimeStr.isEmpty()) 
                    ? Timestamp.valueOf(departTimeStr) 
                    : null;
			String newtransit_line =  request.getParameter("new_transit_line");
			String newtrain_id =  request.getParameter("newtrain_id");
			String newDepartTimeStr = request.getParameter("newdepart_time");
		    Timestamp newdepart_time = (newDepartTimeStr != null && !newDepartTimeStr.isEmpty()) 
		                                ? Timestamp.valueOf(newDepartTimeStr) 
		                                : null;
			String origin =  request.getParameter("origin");
			String destination =  request.getParameter("destination");
			String arrivalTimeStr = request.getParameter("arrival_time");
		    Timestamp arrival_time = (arrivalTimeStr != null && !arrivalTimeStr.isEmpty()) 
		                             ? Timestamp.valueOf(arrivalTimeStr) 
		                             : null;
		    String travelTimeStr = request.getParameter("travel_time");
		    Integer travel_time = (travelTimeStr != null && !travelTimeStr.isEmpty()) 
		                          ? Integer.valueOf(travelTimeStr) 
		                          : null;
		    String numStopsStr = request.getParameter("num_stops");
		    Integer num_stops = (numStopsStr != null && !numStopsStr.isEmpty()) 
		                        ? Integer.valueOf(numStopsStr) 
		                        : null;
	        try {
	        	String checkSql = "SELECT * FROM schedule WHERE transit_line = ? AND train_id = ? AND depart_time = ?";
	            stmt = con.prepareStatement(checkSql);
	            stmt.setString(1, transit_line);
	            stmt.setString(2, train_id);
	            stmt.setTimestamp(3, depart_time);
	            ResultSet rs = stmt.executeQuery();

	            if (rs.next()) {
	                // Prepare the update statement
	                StringBuilder updateSql = new StringBuilder("UPDATE schedule SET ");
	                boolean first = true;

	                if (newtransit_line != null && !newtransit_line.isEmpty()) {
	                    updateSql.append("transit_line = ?");
	                    first = false;
	                }
	                if (newtrain_id != null && !newtrain_id.isEmpty()) {
	                	if (!first) updateSql.append(", ");
	                	updateSql.append("train_id = ?");
	                    first = false;
	                }
	                if (newdepart_time != null) {
	                	if (!first) updateSql.append(", ");
	                	updateSql.append("depart_time = ?");
	                    first = false;
	                }
	                if (origin != null && !origin.isEmpty()) {
	                	if (!first) updateSql.append(", ");
	                	updateSql.append("origin = ?");
	                    first = false;
	                }
	                if (destination != null && !destination.isEmpty()) {
	                	if (!first) updateSql.append(", ");
	                	updateSql.append("destination = ?");
	                    first = false;
	                }
	                if (arrival_time != null) {
	                	 if (!first) updateSql.append(", ");
	                	updateSql.append("arrival_time = ?");
	                    first = false;
	                }
	                if (travel_time != null) {
	                    if (!first) updateSql.append(", ");
	                    updateSql.append("travel_time = ?");
	                    first = false;
	                }
	                if (num_stops != null) {
	                    if (!first) updateSql.append(", ");
	                    updateSql.append("num_stops = ?");
	                    first = false;
	                }
	                
	                
	                updateSql.append(" WHERE transit_line = ? AND train_id = ? AND depart_time = ?");

	                stmt = con.prepareStatement(updateSql.toString());

	                int paramIndex = 1;
	                if (newtransit_line != null && !newtransit_line.isEmpty()) {
	                    stmt.setString(paramIndex++, newtransit_line);
	                }
	                if (newtrain_id != null && !newtrain_id.isEmpty()) {
	                    stmt.setString(paramIndex++, newtrain_id);
	                }
	                if (newdepart_time != null) {
	                    stmt.setTimestamp(paramIndex++, newdepart_time);
	                }
	                if (origin != null && !origin.isEmpty()) {
	                    stmt.setString(paramIndex++, newtrain_id);
	                }
	                if (destination != null && !destination.isEmpty()) {
	                    stmt.setString(paramIndex++, destination);
	                }
	                if (arrival_time != null) {
	                    stmt.setTimestamp(paramIndex++, arrival_time);
	                }
	                if (travel_time != null) {
	                    stmt.setInt(paramIndex++, travel_time);
	                }
	                if (num_stops != null) {
	                    stmt.setInt(paramIndex++, num_stops);
	                }
	                
	                stmt.setString(paramIndex++, transit_line);
	                stmt.setString(paramIndex++, train_id);
	                stmt.setTimestamp(paramIndex, depart_time);

	                int rowsUpdated = stmt.executeUpdate();
	                if (rowsUpdated > 0) {
	                    out.println("<p>Schedule has been successfully updated!</p>");
	                } else {
	                    out.println("<p>No changes made or schedule not found.</p>");
	                }
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
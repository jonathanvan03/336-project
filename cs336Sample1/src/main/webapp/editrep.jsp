<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Edit Representative</title>
</head>
</head>
	<body>
		<% try {
	
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		
			String username = = request.getParameter("repusername");
			String fname = request.getParameter("repfname");
			String lname = request.getParameter("replname");
	        String newusername = request.getParameter("newrepusername");
	        String password = request.getParameter("reppass");
	        Integer ssn = Integer.parseInt(request.getParameter("repssn"));
	        try {
	        	String checkSql = "SELECT * FROM employees WHERE username = ?";
	            stmt = conn.prepareStatement(checkSql);
	            stmt.setString(1, username);
	            rs = stmt.executeQuery();

	            if (rs.next()) {
	                // Prepare the update statement
	                StringBuilder updateSql = new StringBuilder("UPDATE employees SET ");
	                boolean first = true;

	                if (fname != null && !fname.isEmpty()) {
	                    updateSql.append("first_name = ?");
	                    first = false;
	                }
	                if (lname != null && !lname.isEmpty()) {
	                    updateSql.append("last_name = ?");
	                    first = false;
	                }
	                if (ssn != null) {
	                    if (!first) updateSql.append(", ");
	                    updateSql.append("ssn = ?");
	                    first = false;
	                }
	                if (newusername != null && !newusername.isEmpty()) {
	                    if (!first) updateSql.append(", ");
	                    updateSql.append("username = ?");
	                }
	                if (password != null && !password.isEmpty()) {
	                    if (!first) updateSql.append(", ");
	                    updateSql.append("password = ?");
	                }
	                
	                updateSql.append(" WHERE username = ?");

	                stmt = con.prepareStatement(updateSql.toString());

	                int paramIndex = 1;
	                if (fname != null && !fname.isEmpty()) {
	                    stmt.setString(paramIndex++, fname);
	                }
	                if (lname != null && !lname.isEmpty()) {
	                    stmt.setString(paramIndex++, lname);
	                }
	                if (ssn != null) {
	                    stmt.setInt(paramIndex++, ssn);
	                }
	                if (newusername != null && !newusername.isEmpty()) {
	                    stmt.setString(paramIndex++, newusername);
	                }
	                if (password != null && !password.isEmpty()) {
	                    stmt.setString(paramIndex++, password);
	                }
	                stmt.setString(paramIndex, username);

	                int rowsUpdated = stmt.executeUpdate();
	                if (rowsUpdated > 0) {
	                    out.println("<p>Entry for username '" + username + "' has been successfully updated!</p>");
	                } else {
	                    out.println("<p>No changes made or entry not found.</p>");
	                }
	            } else {
	                out.println("<p>Entry with username '" + username + "' not found.</p>");
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
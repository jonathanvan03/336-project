<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Sales Report</title>
	</head>
	<body>
		<% try {
	
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		

			//Create a SQL statement
			Statement stmt = con.createStatement();
			String yearMonth = request.getParameter("month");
	        PreparedStatement stmt = null;
	        ResultSet rs = null;
	        String sql = "SELECT * FROM reservations WHERE DATE_FORMAT(res_date, '%Y-%m') = ?";
            stmt = con.prepareStatement(sql);
            stmt.setString(1, yearMonth);
            rs = stmt.executeQuery();
		
			
		<!--  Make an HTML table to show the results in: -->
		 
			int count = 0;
            double sum = 0.0;

            while (rs.next()) {
                int res_num = rs.getInt("res_num");
                Date res_date = rs.getDate("res_date");
                String passenger = rs.getString("passenger");
                double fare = rs.getFloat("fare");
                int origin = rs.getInt("origin");
                int destination = rs.getInt("destination");
                String train_id = rs.getString("train_id");
                String linename = rs.getString("linename")

                out.println("<tr>");
                out.println("<td>" + res_num + "</td>");
                out.println("<td>" + res_date + "</td>");
                out.println("<td>" + passenger + "</td>");
                out.println("<td>" + fare + "</td>");
                out.println("<td>" + origin + "</td>");
                out.println("<td>" + destination + "</td>");
                out.println("<td>" + train_id + "</td>");
                out.println("<td>" + linename + "</td>");
                out.println("</tr>");

                count++;
                sum += fare;
            }
            out.println("</table>");

            // Display summary
            out.println("<p>Number of Tickets: " + count + "</p>");
            out.println("<p>Total Sales: " + sum + "</p>");
			
			
		} catch (Exception e) {
			out.print(e);
		}%>
	

	</body>
</html>
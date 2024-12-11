<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Sales Report</title>
</head>
<body>
<h2>Sales Report</h2>
    <%
        try {
            // Get the database connection
            ApplicationDB db = new ApplicationDB();    
            Connection con = db.getConnection();        

            // Prepare SQL statement with parameter placeholders
            String yearMonth = request.getParameter("month");
            PreparedStatement stmt = null;
            ResultSet rs = null;

            String sql = "SELECT * FROM reservation WHERE DATE_FORMAT(res_date, '%Y-%m') = ?";
            stmt = con.prepareStatement(sql);
            stmt.setString(1, yearMonth); // Set the parameter value

            rs = stmt.executeQuery(); // Execute the query

            int count = 0;
            double sum = 0.0;

            out.println("<table border='1'>");
            out.println("<tr>");
            out.println("<th>Reservation Number</th>");
            out.println("<th>Reservation Date</th>");
            out.println("<th>Passenger Name</th>");
            out.println("<th>Fare</th>");
            out.println("<th>Origin</th>");
            out.println("<th>Destination</th>");
            out.println("<th>Train ID</th>");
            out.println("<th>Line Name</th>");
            out.println("</tr>");

            while (rs.next()) {
                int res_num = rs.getInt("res_num");
                java.sql.Date res_date = rs.getDate("res_date");
                String passenger = rs.getString("passenger");
                double fare = rs.getFloat("fare");
                int origin = rs.getInt("origin");
                int destination = rs.getInt("destination");
                String train_id = rs.getString("train_id");
                String linename = rs.getString("line_name");

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
            out.println("<p>Number of Tickets: " + count + "</p>");
            out.println("<p>Total Sales: " + sum + "</p>");
            out.println("</table>");

            
            
        } catch (Exception e) {
            out.print(e);
        }
    %>
    <h2>Return</h2>
	        <form action="admin_dashboard.jsp" method="post">
	            <input type="submit" value="Back">
	        </form>
</body>
</html>

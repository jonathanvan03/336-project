<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Customers Reservations</title>
</head>
<body>
<h2>Customer Reservations by Transit Line and Date</h2>
    <%
        try {
            // Get the database connection
            ApplicationDB db = new ApplicationDB();    
            Connection con = db.getConnection();        
            
            // Get the customer name from the request
            String transit_line = request.getParameter("transit_line");
            java.sql.Date date = request.getParameter("date");
            
            // Create a SQL statement using a PreparedStatement to prevent SQL injection
            String sql = "SELECT passenger FROM reservation WHERE line_name = ? AND res_date =?";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setString(1, transit_line);
            stmt.setString(2, res_date);
            
            // Run the query against the database
            ResultSet result = stmt.executeQuery();
    %>
    
    <!-- Create an HTML table to show the results -->
    <table border="1">
        <thead>
            <tr>
                <th>Passengers</th>
                
            </tr>
        </thead>
        <tbody>
            <%
            // Parse the results
            while (result.next()) {
            %>
                <tr>    
                  
                    <td><%= result.getString("passenger") %></td>
                    
                </tr>
            <%
            }
            // Close the connection and statement
            if (result != null) result.close();
            if (stmt != null) stmt.close();
            if (con != null) db.closeConnection(con);
            %>
        </tbody>
    </table>

    <h2>Return</h2>
    <form action="rep_dashboard.jsp" method="post">
        <input type="submit" value="Back">
    </form>

    <%
        } catch (Exception e) {
            out.print("An error occurred: " + e.getMessage());
            e.printStackTrace();
        }
    %>
</body>
</html>
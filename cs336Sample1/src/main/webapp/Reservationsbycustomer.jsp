<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Reservations by Customer</title>
</head>
<body>
<h2>Customer Reservations</h2>
    <%
        try {
            // Get the database connection
            ApplicationDB db = new ApplicationDB();    
            Connection con = db.getConnection();        
            
            // Get the customer name from the request
            String customer = request.getParameter("cust_name");
            
            // Create a SQL statement using a PreparedStatement to prevent SQL injection
            String sql = "SELECT * FROM reservation WHERE passenger = ?";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setString(1, customer);
            
            // Run the query against the database
            ResultSet result = stmt.executeQuery();
    %>
    
    <table border="1">
        <thead>
            <tr>
                <th>Reservation Number</th>
                <th>Reservation Date</th>
                <th>Passenger Name</th>
                <th>Fare</th>
                <th>Origin</th>
                <th>Destination</th>
                <th>Train ID</th>
                <th>Line Name</th>
                <th>Class</th>
                <th>Discount</th>
                <th>Trip</th>
            </tr>
        </thead>
        <tbody>
            <%
            // Parse the results
            while (result.next()) {
            %>
                <tr>    
                    <td><%= result.getInt("res_num") %></td>
                    <td><%= result.getDate("res_date") %></td>
                    <td><%= result.getString("passenger") %></td>
                    <td><%= result.getDouble("fare") %></td>
                    <td><%= result.getString("origin") %></td>
                    <td><%= result.getString("destination") %></td>
                    <td><%= result.getString("train_id") %></td>
                    <td><%= result.getString("line_name") %></td>
                    <td><%= result.getString("class") %></td>
                    <td><%= result.getString("discount") %></td>
                    <td><%= result.getString("trip") %></td>
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
    <form action="admin_dashboard.jsp" method="post">
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

<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Viewing Reservations</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid black;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
    <h2>Viewing All Reservations</h2>

    <%
        // Retrieve the session and username of the logged-in user
        HttpSession httpsession = request.getSession(false); // Don't create a new session if it doesn't exist
        String username = (httpsession != null) ? (String) httpsession.getAttribute("username") : null;

        // If no user is logged in, redirect to login page or show an error message
        if (username == null) {
            out.println("<p>Please log in to view your reservations.</p>");
        } else {
            // Retrieve reservation details for the logged-in user from the database
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
            try {
                ApplicationDB db = new ApplicationDB();
                conn = db.getConnection();
                String query = "SELECT * FROM reservation WHERE passenger = ? ORDER BY res_date DESC";
                stmt = conn.prepareStatement(query);
                stmt.setString(1, username);
                rs = stmt.executeQuery();

                // Check if the user has any reservations
                if (rs.next()) {
    %>

                    <table>
                        <thead>
                            <tr>
                                <th>Reservation Number</th>
                                <th>Reservation Date</th>
                                <th>Origin</th>
                                <th>Destination</th>
                                <th>Fare</th>
                                <th>Train ID</th>
                                <th>Class</th>
                                <th>Discount</th>
                                <th>Trip Type</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                // Loop through all reservations and display them in the table
                                do {
                            %>
                            <tr>
                                <td><%= rs.getInt("res_num") %></td>
                                <td><%= rs.getTimestamp("res_date") %></td>
                                <td><%= rs.getString("origin") %></td>
                                <td><%= rs.getString("destination") %></td>
                                <td>$<%= rs.getFloat("fare") %></td>
                                <td><%= rs.getString("train_id") %></td>
                                <td><%= rs.getString("class") %></td>
                                <td><%= rs.getString("discount") %></td>
                                <td><%= rs.getString("trip") %></td>
                                <!-- View Button to cancel or view details of the reservation -->
                                <td>
                                    <a href="cancelRes.jsp?res_num=<%= rs.getInt("res_num") %>">Delete</a>
                                </td>
                            </tr>
                            <%
                                } while (rs.next());
                            %>
                        </tbody>
                    </table>

                <%
                } else {
                    out.println("<p>No reservations found for this user.</p>");
                }

            } catch (SQLException e) {
                e.printStackTrace();
                out.println("<p>Error retrieving reservations: " + e.getMessage() + "</p>");
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    %>

    <br><br>
    <form action="customer_welcome.jsp" method="get">
        <input type="submit" value="Back to Welcome">
    </form>

</body>
</html>

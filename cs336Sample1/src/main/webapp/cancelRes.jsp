<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Delete Reservation</title>
    <script type="text/javascript">
        // JavaScript function to confirm deletion
        function confirmDelete() {
            return confirm("Are you sure you want to delete this reservation?");
        }
    </script>
</head>
<body>
    <h2>Delete Reservation</h2>

    <%
        // This block handles the deletion when the form is submitted
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            int resNum = Integer.parseInt(request.getParameter("res_num"));
            Connection conn = null;
            PreparedStatement stmt = null;

            try {
                ApplicationDB db = new ApplicationDB();
                conn = db.getConnection();

                // Query to delete reservation
                String deleteQuery = "DELETE FROM reservation WHERE res_num = ?";
                stmt = conn.prepareStatement(deleteQuery);
                stmt.setInt(1, resNum);

                int rowsAffected = stmt.executeUpdate();
                if (rowsAffected > 0) {
                    out.println("<p>Reservation with number " + resNum + " has been successfully deleted.</p>");
                } else {
                    out.println("<p>No reservation found with that number.</p>");
                }
            } catch (SQLException e) {
                e.printStackTrace();
                out.println("<p>Error deleting reservation: " + e.getMessage() + "</p>");
            } finally {
                try {
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        } else {
            // This block handles displaying the reservation details before deletion
            int resNum = Integer.parseInt(request.getParameter("res_num"));
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                // Initialize the database connection
                ApplicationDB db = new ApplicationDB();
                conn = db.getConnection();

                // Query to retrieve reservation details by res_num
                String selectQuery = "SELECT * FROM reservation WHERE res_num = ?";
                stmt = conn.prepareStatement(selectQuery);
                stmt.setInt(1, resNum);
                rs = stmt.executeQuery();

                // Check if the reservation exists
                if (rs.next()) {
                    // Display reservation details
    %>

                    <p><strong>Reservation Number:</strong> <%= rs.getInt("res_num") %></p>
                    <p><strong>Reservation Date:</strong> <%= rs.getTimestamp("res_date") %></p>
                    <p><strong>Origin:</strong> <%= rs.getString("origin") %></p>
                    <p><strong>Destination:</strong> <%= rs.getString("destination") %></p>
                    <p><strong>Fare:</strong> $<%= rs.getFloat("fare") %></p>
                    <p><strong>Train ID:</strong> <%= rs.getString("train_id") %></p>
                    <p><strong>Class:</strong> <%= rs.getString("class") %></p>
                    <p><strong>Discount:</strong> <%= rs.getString("discount") %></p>
                    <p><strong>Trip Type:</strong> <%= rs.getString("trip") %></p>

                    <!-- Confirmation form to delete reservation -->
                    <form action="cancelRes.jsp" method="post" onsubmit="return confirmDelete()">
                        <input type="hidden" name="res_num" value="<%= resNum %>">
                        <input type="submit" value="Delete Reservation">
                    </form>

    <%
                } else {
                    out.println("<p>No reservation found with that number.</p>");
                }
            } catch (SQLException e) {
                e.printStackTrace();
                out.println("<p>Error retrieving reservation: " + e.getMessage() + "</p>");
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
    <form action="viewReservation.jsp" method="get">
        <input type="submit" value="Back to All Reservations">
    </form>

</body>
</html>

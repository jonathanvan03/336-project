<%@ page import="java.io.*, java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Stops for Train</title>
</head>
<body>
    <%
        // Retrieve train_id and depart_time from query parameters
        String trainId = request.getParameter("train_id");
        String departTime = request.getParameter("depart_time");

        if (trainId == null || departTime == null) {
            out.println("<p style='color: red;'>Invalid train or departure time.</p>");
            return;
        }

        // Declare necessary objects and variables
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        ResultSet scheduleResult = null;
        ApplicationDB db = null;  // Declare ApplicationDB object here

        try {
            // Use ApplicationDB class to get the database connection
            db = new ApplicationDB();
            conn = db.getConnection();  // Get connection from ApplicationDB

            // First query to fetch the arrival_time for the specified train_id and depart_time
            String scheduleQuery = "SELECT arrival_time FROM schedule WHERE train_id = ? AND depart_time = ?";
            stmt = conn.prepareStatement(scheduleQuery);
            stmt.setString(1, trainId);
            stmt.setString(2, departTime);
            scheduleResult = stmt.executeQuery();

            // If no schedule found, exit the page with an error
            if (!scheduleResult.next()) {
                out.println("<p style='color: red;'>Train schedule not found for the given departure time.</p>");
                return;
            }

            // Get the arrival_time from the result set
            String arrivalTime = scheduleResult.getString("arrival_time");

            // Now query to get all stops for the specified train_id, depart_time, and arrival_time
            String stopQuery = "SELECT s.station_id, s.arrive_time, s.depart_time, s.fare, st.station_name, st.city, st.state " +
                               "FROM stop s " +
                               "JOIN station st ON s.station_id = st.station_id " +
                               "WHERE s.station_id IN (" +
                               "    SELECT station_id FROM stop WHERE depart_time BETWEEN ? AND ?" +
                               ") " +
                               "ORDER BY s.depart_time";  // Order stops by departure time

            stmt = conn.prepareStatement(stopQuery);
            stmt.setString(1, departTime);  // Set depart_time
            stmt.setString(2, arrivalTime); // Set arrival_time
            rs = stmt.executeQuery();

            // Check if any stops were found
            if (!rs.next()) {
                out.println("<p>No stops found for this train.</p>");
            } else {
                out.println("<h2>Stops for Train ID: " + trainId + " (Departing at: " + departTime + ")</h2>");
                out.println("<table border='1'>");
                out.println("<tr><th>Station Name</th><th>City</th><th>State</th><th>Arrival Time</th><th>Departure Time</th><th>Fare</th></tr>");
                do {
                    String stationName = rs.getString("station_name");
                    String city = rs.getString("city");
                    String state = rs.getString("state");
                    String stationArriveTime = rs.getString("arrive_time");
                    String stationDepartureTime = rs.getString("depart_time");
                    float fare = rs.getFloat("fare");  // Get the fare for the stop

                    out.println("<tr>");
                    out.println("<td>" + stationName + "</td>");
                    out.println("<td>" + city + "</td>");
                    out.println("<td>" + state + "</td>");
                    out.println("<td>" + stationArriveTime + "</td>");
                    out.println("<td>" + stationDepartureTime + "</td>");
                    out.println("<td>" + fare + "</td>");  // Display the fare
                    out.println("</tr>");
                } while (rs.next());
                out.println("</table>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
        } finally {
            try {
                // Close resources safely
                if (rs != null) rs.close();
                if (scheduleResult != null) scheduleResult.close();
                if (stmt != null) stmt.close();
                if (conn != null && db != null) db.closeConnection(conn); // Close connection using ApplicationDB
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    %>

    <br>
    <form action="schedule.jsp" method="get">
        <input type="submit" value="Back to All Schedule">
    </form>
    <form action="schedReserve.jsp" method="get">
        <input type="submit" value="Back to Make Reservations">
    </form>
    <br>

    <form action="logout.jsp" method="post">
        <input type="submit" value="Logout">
    </form>
</body>
</html>

<%@ page import="java.io.*, java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>  <!-- Ensure ApplicationDB is imported -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Schedule</title>
</head>
<body>
    <%
        // Check if the user is logged in by looking for a session attribute
        HttpSession httpsession = request.getSession(false); // Don't create a new session if it doesn't exist
        String username = (httpsession != null) ? (String) httpsession.getAttribute("username") : null;

        if (username == null) {
            // If no session, redirect to login page
            response.sendRedirect("login.jsp");
        } else {
    %>
        <h2>Welcome, <%= username %>!</h2>
        <p>Select a transit line to view the schedule:</p>

        <!-- Filter Form (Only for transit line selection) -->
        <form method="get" action="schedule.jsp" id="scheduleForm">
            <label for="transit_line">Transit Line:</label>
            <select name="transit_line" id="transit_line">
                <option value="">Select Transit Line</option>
                <%
                    // Declare the db and conn variables once
                    ApplicationDB db = new ApplicationDB();  // Use the ApplicationDB class
                    Connection conn = db.getConnection();   // Get the connection
                    PreparedStatement transitStmt = conn.prepareStatement("SELECT DISTINCT transit_line FROM schedule");
                    ResultSet transitRs = transitStmt.executeQuery();
                    while (transitRs.next()) {
                        String transitLine = transitRs.getString("transit_line");
                %>
                    <option value="<%= transitLine %>" <%= request.getParameter("transit_line") != null && request.getParameter("transit_line").equals(transitLine) ? "selected" : "" %>><%= transitLine %></option>
                <%
                    }
                    transitRs.close();
                    transitStmt.close();
                %>
            </select>

            <input type="submit" value="Search">
        </form>
        <br>

        <%
            // Retrieve the selected transit line and sort criteria from the request
            String transitLine = request.getParameter("transit_line");
            String sortBy = request.getParameter("sort_by");
            String sortOrder = request.getParameter("sort_order");

            // Default sorting if not specified
            if (sortBy == null) {
                sortBy = "depart_time";
                sortOrder = "asc";
            }
            if (sortOrder == null) {
                sortOrder = "asc";
            }

            if (transitLine != null && !transitLine.isEmpty()) {
        %>
            <!-- Schedule Table -->
            <table id="scheduleTable" border="1">
                <tr>
                    <th>
                        <a href="schedule.jsp?transit_line=<%= transitLine %>&sort_by=origin&sort_order=<%= 
                            "origin".equals(sortBy) && "asc".equals(sortOrder) ? "desc" : "asc" %>">
                            Origin Station
                        </a>
                    </th>
                    <th>
                        <a href="schedule.jsp?transit_line=<%= transitLine %>&sort_by=destination&sort_order=<%= 
                            "destination".equals(sortBy) && "asc".equals(sortOrder) ? "desc" : "asc" %>">
                            Destination Station
                        </a>
                    </th>
                    <th>
                        <a href="schedule.jsp?transit_line=<%= transitLine %>&sort_by=depart_time&sort_order=<%= 
                            "depart_time".equals(sortBy) && "asc".equals(sortOrder) ? "desc" : "asc" %>">
                            Departure Time
                        </a>
                    </th>
                    <th>
                        <a href="schedule.jsp?transit_line=<%= transitLine %>&sort_by=arrival_time&sort_order=<%= 
                            "arrival_time".equals(sortBy) && "asc".equals(sortOrder) ? "desc" : "asc" %>">
                            Arrival Time
                        </a>
                    </th>
                    <th>
                        <a href="schedule.jsp?transit_line=<%= transitLine %>&sort_by=total_fare&sort_order=<%= 
                            "total_fare".equals(sortBy) && "asc".equals(sortOrder) ? "desc" : "asc" %>">
                            Fare
                        </a>
                    </th>
                    <th>Number of Stops</th>
                </tr>
                <%
                    // Build the SQL query based on the selected transit line and sorting criteria
                    StringBuilder sql = new StringBuilder("SELECT s.*, " +
                        "(SELECT COUNT(DISTINCT station_id) FROM stop WHERE train_id = s.train_id AND depart_time BETWEEN s.depart_time AND s.arrival_time) AS num_stops, " +
                        "(SELECT SUM(fare) FROM stop WHERE train_id = s.train_id AND depart_time BETWEEN s.depart_time AND s.arrival_time) AS total_fare " +
                        "FROM schedule s WHERE s.transit_line = ?");

                    // Append the ORDER BY clause dynamically
                    sql.append(" ORDER BY ").append(sortBy).append(" ").append(sortOrder);

                    // Fetch results using the existing db and conn variables
                    try {
                        PreparedStatement stmt = conn.prepareStatement(sql.toString());
                        stmt.setString(1, transitLine); // Set the selected transit line

                        ResultSet rs = stmt.executeQuery();

                        // Loop through the result set and display in table
                        while (rs.next()) {
                            String trainId = rs.getString("train_id");
                            // Query to calculate the number of stops and fare for this train
                            String stopQuery = "SELECT COUNT(DISTINCT station_id) AS num_stops, SUM(fare) AS total_fare " +
                                                "FROM stop WHERE station_id IN (SELECT station_id FROM stop WHERE depart_time BETWEEN ? AND ?)";
                            PreparedStatement stopStmt = conn.prepareStatement(stopQuery);
                            stopStmt.setString(1, rs.getString("depart_time"));
                            stopStmt.setString(2, rs.getString("arrival_time"));
                            ResultSet rsStops = stopStmt.executeQuery();

                            int numStops = 0;
                            float totalFare = 0.0f;
                            if (rsStops.next()) {
                                numStops = rsStops.getInt("num_stops");
                                totalFare = rsStops.getFloat("total_fare");
                            }
                %>
                             <tr>
                                <td><%= rs.getString("origin") %></td>
                                <td><%= rs.getString("destination") %></td>
                                <td><%= rs.getString("depart_time") %></td>
                                <td><%= rs.getString("arrival_time") %></td>
                                <td><%= totalFare %></td> <!-- Display the summed fare -->
                                <td>
                                    <a href="viewStops.jsp?train_id=<%= rs.getString("train_id") %>&depart_time=<%= rs.getString("depart_time") %>">
                                        <%= numStops %>
                                    </a>
                                </td>
                            </tr>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
                    } finally {
                        try {
                            if (conn != null) conn.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                %>
            </table>
        <%
            } else {
        %>
            <!-- Display a message when no transit line is selected -->
            <p>Please select a transit line to view the schedule.</p>
        <%
            }
        %>

        <br>
        <!-- Button to go back to Welcome page -->
        <form action="customer_welcome.jsp" method="get">
            <input type="submit" value="Back to Welcome">
        </form>
        <br>

        <!-- Logout form -->
        <form action="logout.jsp" method="post">
            <input type="submit" value="Logout">
        </form>
    <%
        }
    %>
</body>
</html>

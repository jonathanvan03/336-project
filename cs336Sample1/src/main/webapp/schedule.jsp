<%@ page import="java.io.*, java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>  
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
        <h2>View All Train Schedules</h2>
        <p>Select a transit line to filter the schedule:</p>

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

            // Building the SQL query to fetch data
            StringBuilder sql = new StringBuilder("SELECT s.*, " +
                "(SELECT COUNT(DISTINCT station_id) FROM stop WHERE train_id = s.train_id AND DATE(depart_time) = DATE(s.depart_time)) AS num_stops, " +
                "(SELECT SUM(fare) FROM stop WHERE train_id = s.train_id AND DATE(depart_time) = DATE(s.depart_time)) AS total_fare " +
                "FROM schedule s");

            // Apply a filter for transit line if selected
            if (transitLine != null && !transitLine.isEmpty()) {
                sql.append(" WHERE s.transit_line = ?");
            }

            // Append the ORDER BY clause dynamically
            sql.append(" ORDER BY ").append(sortBy).append(" ").append(sortOrder);

            try {
                PreparedStatement stmt = conn.prepareStatement(sql.toString());

                // If a transit line is selected, bind it to the query
                if (transitLine != null && !transitLine.isEmpty()) {
                    stmt.setString(1, transitLine); // Set the selected transit line
                }

                ResultSet rs = stmt.executeQuery();

                // Display the table with train schedules
                if (rs.isBeforeFirst()) {
        %>
            <table id="scheduleTable" border="1">
                <tr>
                    <th>
                        <a href="schedule.jsp?transit_line=<%= transitLine != null ? transitLine : "" %>&sort_by=origin&sort_order=<%= 
                            "origin".equals(sortBy) && "asc".equals(sortOrder) ? "desc" : "asc" %>">
                            Origin Station
                        </a>
                    </th>
                    <th>
                        <a href="schedule.jsp?transit_line=<%= transitLine != null ? transitLine : "" %>&sort_by=destination&sort_order=<%= 
                            "destination".equals(sortBy) && "asc".equals(sortOrder) ? "desc" : "asc" %>">
                            Destination Station
                        </a>
                    </th>
                    <th>
                        <a href="schedule.jsp?transit_line=<%= transitLine != null ? transitLine : "" %>&sort_by=depart_time&sort_order=<%= 
                            "depart_time".equals(sortBy) && "asc".equals(sortOrder) ? "desc" : "asc" %>">
                            Departure Time
                        </a>
                    </th>
                    <th>
                        <a href="schedule.jsp?transit_line=<%= transitLine != null ? transitLine : "" %>&sort_by=arrival_time&sort_order=<%= 
                            "arrival_time".equals(sortBy) && "asc".equals(sortOrder) ? "desc" : "asc" %>">
                            Arrival Time
                        </a>
                    </th>
                    <th>
                        <a href="schedule.jsp?transit_line=<%= transitLine != null ? transitLine : "" %>&sort_by=total_fare&sort_order=<%= 
                            "total_fare".equals(sortBy) && "asc".equals(sortOrder) ? "desc" : "asc" %>">
                            Fare
                        </a>
                    </th>
                    <th>Number of Stops</th>
                </tr>
                <%
                    // Loop through the result set and display each row in the table
                    while (rs.next()) {
                        // Retrieve data from the result set
                        String origin = rs.getString("origin");
                        String destination = rs.getString("destination");
                        String departTime = rs.getString("depart_time");
                        String arrivalTime = rs.getString("arrival_time");
                        float totalFare = rs.getFloat("total_fare");
                        int numStops = rs.getInt(9);
                %>
                    <tr>
                        <td><%= origin %></td>
                        <td><%= destination %></td>
                        <td><%= departTime %></td>
                        <td><%= arrivalTime %></td>
                        <td><%= totalFare %></td>
                        <td>
                            <a href="viewStops.jsp?train_id=<%= rs.getString("train_id") %>&depart_time=<%= rs.getString("depart_time") %>&arrive_time=<%= rs.getString("arrival_time") %>">
                                <%= numStops %>
                            </a>
                        </td>
                    </tr>
                <%
                    }
                %>
            </table>
        <%
                } else {
                    out.println("<p>No schedules found for the selected criteria.</p>");
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

        <br>
        <form action="schedReserve.jsp" method="post">
            <input type="submit" value="Reserve a Train Ticket">
        </form>
        <br>
        <form action="customer_welcome.jsp" method="get">
            <input type="submit" value="Back to Welcome">
        </form>
    <%
        }
    %>
</body>
</html>

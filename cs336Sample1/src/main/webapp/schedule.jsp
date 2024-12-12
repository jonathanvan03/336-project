<%@ page import="java.io.*, java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Train Schedules</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
    <%
        // Check if the user is logged in by looking for a session attribute
        HttpSession httpsession = request.getSession(false);
        String username = (httpsession != null) ? (String) httpsession.getAttribute("username") : null;

        if (username == null) {
            response.sendRedirect("login.jsp");
        } else {
    %>
        <h2>View Train Schedules</h2>
        <p>Select a transit line to filter schedules:</p>

        <!-- Transit Line Dropdown Form -->
        <form method="get" action="schedule.jsp">
            <label for="transit_line">Transit Line:</label>
            <select name="transit_line" id="transit_line">
                <option value="">All Transit Lines</option>
                <%
                    ApplicationDB db = new ApplicationDB();
                    Connection conn = null;
                    PreparedStatement stmt = null;
                    ResultSet transitRs = null;

                    try {
                        conn = db.getConnection();
                        String transitQuery = "SELECT DISTINCT transit_line FROM schedule";
                        stmt = conn.prepareStatement(transitQuery);
                        transitRs = stmt.executeQuery();

                        while (transitRs.next()) {
                            String transitLine = transitRs.getString("transit_line");
                %>
                            <option value="<%= transitLine %>" <%= request.getParameter("transit_line") != null && request.getParameter("transit_line").equals(transitLine) ? "selected" : "" %>>
                                <%= transitLine %>
                            </option>
                <%
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                        out.println("<p style='color: red;'>Error loading transit lines: " + e.getMessage() + "</p>");
                    } finally {
                        if (transitRs != null) transitRs.close();
                        if (stmt != null) stmt.close();
                    }
                %>
            </select>
            <input type="submit" value="Search">
        </form>

        <%
            // Retrieve the selected transit line
            String transitLine = request.getParameter("transit_line");

            // Build the SQL query
            String sql = "SELECT s.*, " +
                         "(SELECT COUNT(DISTINCT station_id) FROM stop WHERE train_id = s.train_id AND depart_time BETWEEN s.depart_time AND s.arrival_time) AS num_stops, " +
                         "(SELECT SUM(fare) FROM stop WHERE train_id = s.train_id AND depart_time BETWEEN s.depart_time AND s.arrival_time) AS total_fare " +
                         "FROM schedule s";

            if (transitLine != null && !transitLine.isEmpty()) {
                sql += " WHERE s.transit_line = ?";
            }

            sql += " ORDER BY s.depart_time ASC";

            // Execute the query
            PreparedStatement scheduleStmt = null;
            ResultSet rs = null;

            try {
                scheduleStmt = conn.prepareStatement(sql);

                if (transitLine != null && !transitLine.isEmpty()) {
                    scheduleStmt.setString(1, transitLine);
                }

                rs = scheduleStmt.executeQuery();
        %>

        <table>
            <thead>
                <tr>
                    <th>Origin</th>
                    <th>Destination</th>
                    <th>Departure Time</th>
                    <th>Arrival Time</th>
                    <th>Total Fare</th>
                    <th>Number of Stops</th>
                </tr>
            </thead>
            <tbody>
                <%
                    boolean hasResults = false;

                    while (rs.next()) {
                        hasResults = true;
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
                            <td><%= numStops %></td>
                        </tr>
                <%
                    }

                    if (!hasResults) {
                %>
                        <tr>
                            <td colspan="6">No schedules found.</td>
                        </tr>
                <%
                    }
                %>
            </tbody>
        </table>

        <%
            } catch (SQLException e) {
                e.printStackTrace();
                out.println("<p style='color: red;'>Error loading schedules: " + e.getMessage() + "</p>");
            } finally {
                if (rs != null) rs.close();
                if (scheduleStmt != null) scheduleStmt.close();
                if (conn != null) db.closeConnection(conn);
            }
        }
        %>

        <br>
        <form action="customer_welcome.jsp" method="get">
            <input type="submit" value="Back to Welcome">
        </form>
        <br>

        <form action="logout.jsp" method="post">
            <input type="submit" value="Logout">
        </form>

</body>
</html>

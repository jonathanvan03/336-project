<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Train Schedules by Station</title>
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
        // Check if the representative is logged in
        HttpSession httpsession = request.getSession(false);
        String repUsername = (httpsession != null) ? (String) httpsession.getAttribute("username") : null;

        if (repUsername == null) {
            // If no session, redirect to login page
            response.sendRedirect("login.jsp");
        } else {
            // Fetch station names for dropdown
            ApplicationDB db = new ApplicationDB();
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet stationsRs = null;
            try {
                conn = db.getConnection();
                String stationQuery = "SELECT station_name FROM station ORDER BY station_name ASC";
                stmt = conn.prepareStatement(stationQuery);
                stationsRs = stmt.executeQuery();
    %>

        <h2>Welcome, <%= repUsername %> to Train Schedules Search</h2>

        <!-- Search Form -->
        <form method="post" action="repStationSchedules.jsp">
            <label for="station">Select Station:</label>
            <select name="station" id="station" required>
                <option value="">-- Select Station --</option>
                <%
                    while (stationsRs.next()) {
                        String stationName = stationsRs.getString("station_name");
                %>
                        <option value="<%= stationName %>"><%= stationName %></option>
                <%
                    }
                %>
            </select><br><br>

            <label for="type">Search By:</label>
            <select name="type" id="type" required>
                <option value="origin">Origin</option>
                <option value="destination">Destination</option>
            </select><br><br>

            <input type="submit" value="Search">
        </form>

        <%
            } catch (SQLException e) {
                e.printStackTrace();
                out.println("<p style='color: red;'>Error loading station names: " + e.getMessage() + "</p>");
            } finally {
                try {
                    if (stationsRs != null) stationsRs.close();
                    if (stmt != null) stmt.close();
                    if (conn != null) db.closeConnection(conn);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }

            // Process Search Query
            String stationName = request.getParameter("station");
            String type = request.getParameter("type"); // "origin" or "destination"
            if (stationName != null && type != null) {
                PreparedStatement searchStmt = null;
                ResultSet searchRs = null;

                try {
                    conn = db.getConnection();

                    // Get station_id from station_name
                    String stationIdQuery = "SELECT station_id FROM station WHERE station_name = ?";
                    searchStmt = conn.prepareStatement(stationIdQuery);
                    searchStmt.setString(1, stationName);
                    ResultSet stationIdRs = searchStmt.executeQuery();

                    if (stationIdRs.next()) {
                        int stationId = stationIdRs.getInt("station_id");
                        stationIdRs.close();
                        searchStmt.close();

                        // Query stops table for origin or destination
                        String scheduleQuery = "";
                        if ("origin".equals(type)) {
                            scheduleQuery = "SELECT s.depart_time, sc.train_id, sc.transit_line " +
                                            "FROM stop s JOIN schedule sc " +
                                            "ON s.depart_time BETWEEN sc.depart_time AND sc.arrival_time " +
                                            "WHERE s.station_id = ?";
                        } else {
                            scheduleQuery = "SELECT s.arrive_time, sc.train_id, sc.transit_line " +
                                            "FROM stop s JOIN schedule sc " +
                                            "ON s.arrive_time BETWEEN sc.depart_time AND sc.arrival_time " +
                                            "WHERE s.station_id = ?";
                        }

                        searchStmt = conn.prepareStatement(scheduleQuery);
                        searchStmt.setInt(1, stationId);
                        searchRs = searchStmt.executeQuery();

                        // Display Results
        %>
                        <h3>Train Schedules for Station: <%= stationName %> (<%= type %>)</h3>
                        <table>
                            <thead>
                                <tr>
                                    <th>Station Name</th>
                                    <th>Train Number</th>
                                    <th>Transit Line</th>
                                    <th><%= "origin".equals(type) ? "Departure Time" : "Arrival Time" %></th>
                                </tr>
                            </thead>
                            <tbody>
        <%
                        boolean hasResults = false;
                        while (searchRs.next()) {
                            hasResults = true;
                            String timeResult = "origin".equals(type) ? searchRs.getString("depart_time") : searchRs.getString("arrive_time");
                            String trainId = searchRs.getString("train_id");
                            String transitLine = searchRs.getString("transit_line");
        %>
                            <tr>
                                <td><%= stationName %></td>
                                <td><%= trainId %></td>
                                <td><%= transitLine %></td>
                                <td><%= timeResult %></td>
                            </tr>
        <%
                        }
                        if (!hasResults) {
        %>
                            <tr>
                                <td colspan="4">No train schedules found for the specified station.</td>
                            </tr>
        <%
                        }
        %>
                            </tbody>
                        </table>
        <%
                    } else {
                        out.println("<p style='color: red;'>Station not found in the database.</p>");
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
                } finally {
                    try {
                        if (searchRs != null) searchRs.close();
                        if (searchStmt != null) searchStmt.close();
                        if (conn != null) db.closeConnection(conn);
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }
        %>

        <br><br>
        <!-- Back to Dashboard -->
        <form action="rep_dashboard.jsp" method="post">
            <input type="submit" value="Back to Dashboard">
        </form>

    <%
        }
    %>

</body>
</html>

<%@ page import="java.io.*, java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.util.List, java.util.ArrayList" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Reserve a Ticket</title>
    <script type="text/javascript">
        // This function validates that both Transit Line and Date are selected
        function validateForm() {
            var transitLine = document.getElementById("transit_line").value;
            var date = document.getElementById("date").value;

            if (transitLine === "" || date === "") {
                alert("Please select both Transit Line and Date of Travel.");
                return false;  // Prevent form submission
            }

            return true;  // Allow form submission
        }
    </script>
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
        <h2>Reserve a Ticket</h2>
        <form action="schedule.jsp" method="get">
            <input type="submit" value="View All Schedule">
        </form>
        
        <p>Use the filters below to view the schedule:</p>
        
        <!-- Filter form for Transit Line and Date -->
        <form method="get" action="schedReserve.jsp" id="scheduleForm" onsubmit="return validateForm();">
            <label for="transit_line">Transit Line:</label>
            <select name="transit_line" id="transit_line">
                <option value="">Select Transit Line</option>
                <%
                    ApplicationDB db = new ApplicationDB();
                    Connection conn = db.getConnection();
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
            
            <label for="date"> Date of Travel:</label>
            <input type="date" name="date" id="date" value="<%= request.getParameter("date") != null ? request.getParameter("date") : "" %>">

            <input type="submit" value="Search">
        </form>

        <br>

        <!-- Conditional table and dropdowns display -->
        <%
            String transitLine = request.getParameter("transit_line");
            String date = request.getParameter("date");

            boolean showTable = transitLine != null && !transitLine.isEmpty() && date != null && !date.isEmpty();
            boolean hasResults = false; // To track if the query returns rows

            // To store station names from the result set
            List<String> stationNames = new ArrayList<>();

            if (showTable) {
                String stopQuery = "SELECT s.station_id, s.arrive_time, s.depart_time, s.fare, st.station_name, st.city, st.state " +
                                   "FROM stop s " +
                                   "JOIN station st ON s.station_id = st.station_id " +
                                   "WHERE DATE(s.depart_time) = ? " +  // Filter by the specific date
                                   "AND st.station_name IS NOT NULL " +  // Make sure station name exists
                                   "ORDER BY s.depart_time";  // Order stops by departure time

                try {
                    PreparedStatement stopStmt = conn.prepareStatement(stopQuery);
                    stopStmt.setString(1, date);  // Set the date parameter

                    ResultSet stopRs = stopStmt.executeQuery();

                    if (stopRs.next()) {  // If there are results
                        hasResults = true;
                        // Start the table
                        out.println("<table border='1'>");
                        out.println("<tr>");
                        out.println("<th>Station Name</th>");
                        out.println("<th>City</th>");
                        out.println("<th>State</th>");
                        out.println("<th>Arrival Time</th>");
                        out.println("<th>Departure Time</th>");
                        out.println("<th>Fare</th>");
                        out.println("</tr>");

                        // Loop through the result set and display rows
                        do {
                            String stationName = stopRs.getString("station_name");
                            String city = stopRs.getString("city");
                            String state = stopRs.getString("state");
                            String arriveTime = stopRs.getString("arrive_time");
                            String departTime = stopRs.getString("depart_time");
                            double fare = stopRs.getDouble("fare");

                            // Add the station name to the list of station names
                            if (!stationNames.contains(stationName)) {
                                stationNames.add(stationName);
                            }

                            out.println("<tr>");
                            out.println("<td>" + stationName + "</td>");
                            out.println("<td>" + city + "</td>");
                            out.println("<td>" + state + "</td>");
                            out.println("<td>" + arriveTime + "</td>");
                            out.println("<td>" + departTime + "</td>");
                            out.println("<td>" + fare + "</td>");
                            out.println("</tr>");
                        } while (stopRs.next());

                        out.println("</table>");
                    } else {
                        out.println("<p>No stops found for the selected transit line and date.</p>");
                    }

                    stopRs.close();
                    stopStmt.close();
                } catch (SQLException e) {
                    out.println("<p style='color:red;'>An error occurred while retrieving stop details. Please try again later.</p>");
                    e.printStackTrace();
                }
            }
        %>

        <!-- Origin and Destination Dropdowns (only visible if results exist) -->
        <%
            if (hasResults) {
        %>
            <form method="get" action="makeReservation.jsp">
                <label for="origin_station">Origin Station:</label>
                <select name="origin_station" id="origin_station">
                    <option value="">Select Origin Station</option>
                    <%
                        // Dynamically populate dropdown with station names from the result
                        for (String stationName : stationNames) {
                    %>
                        <option value="<%= stationName %>"><%= stationName %></option>
                    <%
                        }
                    %>
                </select>

                <label for="destination_station">Destination Station:</label>
                <select name="destination_station" id="destination_station">
                    <option value="">Select Destination Station</option>
                    <%
                        // Dynamically populate dropdown with station names from the result
                        for (String stationName : stationNames) {
                    %>
                        <option value="<%= stationName %>"><%= stationName %></option>
                    <%
                        }
                    %>
                </select>

                <input type="submit" value="Reserve">
            </form>
        <%
            }
        %>

    <%
        }
    %>
</body>
</html>

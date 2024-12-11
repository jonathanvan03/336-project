<%@ page import="java.io.*, java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %> <!-- Ensure ApplicationDB is imported -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Reserve a Ticket</title>
    <script type="text/javascript">
        // This function checks if all fields are selected before submitting the form
        function validateForm() {
            var origin = document.getElementById("origin").value;
            var destination = document.getElementById("destination").value;
            var date = document.getElementById("date").value;

            if (origin === "" || destination === "" || date === "") {
                alert("Please fill out all the fields (Origin, Destination, Date).");
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
        <p>Use the filters below to view the schedule:</p>

        <form method="get" action="schedReserve.jsp" id="scheduleForm" onsubmit="return validateForm()">
            <label for="origin">Origin:</label>
            <select name="origin" id="origin">
                <option value="">Select Origin</option>
                <%
                    // Declare the db and conn variables once
                    ApplicationDB db = new ApplicationDB();  // Use the ApplicationDB class
                    Connection conn = db.getConnection();   // Get the connection
                    PreparedStatement originStmt = conn.prepareStatement("SELECT DISTINCT origin FROM schedule");
                    ResultSet originRs = originStmt.executeQuery();
                    while (originRs.next()) {
                        String origin = originRs.getString("origin");
                %>
                    <option value="<%= origin %>" <%= request.getParameter("origin") != null && request.getParameter("origin").equals(origin) ? "selected" : "" %>><%= origin %></option>
                <%
                    }
                    originRs.close();
                    originStmt.close();
                %>
            </select>

            <label for="destination">Destination:</label>
            <select name="destination" id="destination">
                <option value="">Select Destination</option>
                <%
                    PreparedStatement destinationStmt = conn.prepareStatement("SELECT DISTINCT destination FROM schedule");
                    ResultSet destinationRs = destinationStmt.executeQuery();
                    while (destinationRs.next()) {
                        String destination = destinationRs.getString("destination");
                %>
                    <option value="<%= destination %>" <%= request.getParameter("destination") != null && request.getParameter("destination").equals(destination) ? "selected" : "" %>><%= destination %></option>
                <%
                    }
                    destinationRs.close();
                    destinationStmt.close();
                %>
            </select>

            <label for="date">Date of Travel:</label>
            <input type="date" name="date" id="date" value="<%= request.getParameter("date") != null ? request.getParameter("date") : "" %>">

            <input type="submit" value="Search">
        </form>
        <br>

        <table id="scheduleTable" border="1">
            <tr>
                <th>Transit Line</th>
                <th>Train ID</th>
                <th>Origin</th>
                <th>Destination</th>
                <th>
                    <a href="schedReserve.jsp?origin=<%= request.getParameter("origin") != null ? request.getParameter("origin") : "" %>&destination=<%= request.getParameter("destination") != null ? request.getParameter("destination") : "" %>&date=<%= request.getParameter("date") != null ? request.getParameter("date") : "" %>&sort_by=depart_time&sort_order=<%= 
                        "depart_time".equals(request.getParameter("sort_by")) && "asc".equals(request.getParameter("sort_order")) ? "desc" : "asc" %>">
                        Departure Time
                    </a>
                </th>
                <th>
                    <a href="schedReserve.jsp?origin=<%= request.getParameter("origin") != null ? request.getParameter("origin") : "" %>&destination=<%= request.getParameter("destination") != null ? request.getParameter("destination") : "" %>&date=<%= request.getParameter("date") != null ? request.getParameter("date") : "" %>&sort_by=arrival_time&sort_order=<%= 
                        "arrival_time".equals(request.getParameter("sort_by")) && "asc".equals(request.getParameter("sort_order")) ? "desc" : "asc" %>">
                        Arrival Time
                    </a>
                </th>
                <th>
                    <a href="schedReserve.jsp?origin=<%= request.getParameter("origin") != null ? request.getParameter("origin") : "" %>&destination=<%= request.getParameter("destination") != null ? request.getParameter("destination") : "" %>&date=<%= request.getParameter("date") != null ? request.getParameter("date") : "" %>&sort_by=total_fare&sort_order=<%= 
                        "total_fare".equals(request.getParameter("sort_by")) && "asc".equals(request.getParameter("sort_order")) ? "desc" : "asc" %>">
                        Fare
                    </a>
                </th>
                <th>Number of Stops</th>
            </tr>
            <%
                String sortBy = request.getParameter("sort_by");
                String sortOrder = request.getParameter("sort_order");
                String origin = request.getParameter("origin");
                String destination = request.getParameter("destination");
                String date = request.getParameter("date");

                // Default sorting
                if (sortBy == null) {
                    sortBy = "arrival_time";
                    sortOrder = "asc";
                }
                if (sortOrder == null) {
                    sortOrder = "asc";
                }

                // Build the SQL query dynamically based on filters
                StringBuilder sql = new StringBuilder("SELECT s.*, " +
                    "(SELECT COUNT(DISTINCT station_id) FROM stop WHERE train_id = s.train_id AND depart_time BETWEEN s.depart_time AND s.arrival_time) AS num_stops, " +
                    "(SELECT SUM(fare) FROM stop WHERE train_id = s.train_id AND depart_time BETWEEN s.depart_time AND s.arrival_time) AS total_fare " +
                    "FROM schedule s WHERE 1=1");

                if (origin != null && !origin.isEmpty()) {
                    sql.append(" AND s.origin = ?");
                }
                if (destination != null && !destination.isEmpty()) {
                    sql.append(" AND s.destination = ?");
                }
                if (date != null && !date.isEmpty()) {
                    sql.append(" AND DATE(s.depart_time) = ?");
                }

                sql.append(" ORDER BY ").append(sortBy).append(" ").append(sortOrder);

                // Fetch results using the existing db and conn variables
                try {
                    PreparedStatement stmt = conn.prepareStatement(sql.toString());
                    int paramIndex = 1;

                    if (origin != null && !origin.isEmpty()) {
                        stmt.setString(paramIndex++, origin);
                    }
                    if (destination != null && !destination.isEmpty()) {
                        stmt.setString(paramIndex++, destination);
                    }
                    if (date != null && !date.isEmpty()) {
                        stmt.setString(paramIndex++, date);
                    }

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
                            <td><%= rs.getString("transit_line") %></td>
                            <td><%= trainId %></td>
                            <td><%= rs.getString("origin") %></td>
                            <td><%= rs.getString("destination") %></td>
                            <td><%= rs.getString("depart_time") %></td>
                            <td><%= rs.getString("arrival_time") %></td>
                            <td><%= totalFare %></td> 
                            <td>
                                <a href="viewStops.jsp?train_id=<%= rs.getString("train_id") %>&depart_time=<%= rs.getString("depart_time") %>">
                                    <%= numStops %>
                                </a>
                            </td>
                            <td>
					        <a href="makeReservation.jsp?train_id=<%= rs.getString("train_id") %>&origin=<%= rs.getString("origin") %>&destination=<%= rs.getString("destination") %>&fare=<%= totalFare %>&depart_time=<%= rs.getString("depart_time") %>&arrival_time=<%= rs.getString("arrival_time") %>">
					            <button>Reserve</button>
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

        <br>
        <form action="customer_welcome.jsp" method="get">
            <input type="submit" value="Back to Welcome">
        </form>
        <br>

        <form action="logout.jsp" method="post">
            <input type="submit" value="Logout">
        </form>
    <%
        }
    %>
</body>
</html>

<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %> <!-- Ensure ApplicationDB is imported -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Reserve a Ticket</title>
    <script type="text/javascript">
        // This function checks if all fields are selected before submitting the form
        function validateForm() {
            var classType = document.querySelector('input[name="class"]:checked');
            var discount = document.querySelector('input[name="discount"]:checked');
            var tripType = document.querySelector('input[name="trip"]:checked');
            
            if (!classType || !discount || !tripType) {
                alert("Please select Class, Discount, and Trip Type.");
                return false;  // Prevent form submission
            }
            return true;  // Allow form submission
        }
    </script>
</head>
<body>
    <%
        // Retrieve the parameters passed from the schedule table
        String trainId = request.getParameter("train_id");
        String origin = request.getParameter("origin");
        String destination = request.getParameter("destination");
        float fare = Float.parseFloat(request.getParameter("fare"));
        String departTime = request.getParameter("depart_time");
        String arrivalTime = request.getParameter("arrival_time");

        // Get the session and username for the logged-in user
        HttpSession httpsession = request.getSession(false); // Don't create a new session if it doesn't exist
        String username = (httpsession != null) ? (String) httpsession.getAttribute("username") : null;

        // Default values for class, discount, and trip
        String classType = "Economy"; // Default class
        String discount = "Normal";   // Default discount
        String trip = "One";         // Default trip type

        // Get the next reservation number (res_num)
        int resNum = 1; // Default if no reservations exist
        try {
            // DB connection to get the latest reservation number
            ApplicationDB db = new ApplicationDB();
            Connection conn = db.getConnection();
            String query = "SELECT MAX(res_num) AS max_res_num FROM reservation";
            PreparedStatement stmt = conn.prepareStatement(query);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                resNum = rs.getInt("max_res_num") + 1; // Increment the max res_num
            }
            rs.close();
            stmt.close();
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Handle form submission
        String action = request.getParameter("action");
        if ("submit".equals(action)) {
            // Handle reservation submission
            classType = request.getParameter("class");
            discount = request.getParameter("discount");
            trip = request.getParameter("trip");

            try {
                // Insert reservation into the database
                ApplicationDB db = new ApplicationDB();
                Connection conn = db.getConnection();
                String insertQuery = "INSERT INTO reservation (res_num, res_date, passenger, fare, origin, destination, train_id, line_name, class, discount, trip) " +
                                     "VALUES (?, NOW(), ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement insertStmt = conn.prepareStatement(insertQuery);
                insertStmt.setInt(1, resNum);
                insertStmt.setString(2, username);
                insertStmt.setFloat(3, fare);
                insertStmt.setString(4, origin);
                insertStmt.setString(5, destination);
                insertStmt.setString(6, trainId);
                insertStmt.setString(7, "Train Line Name"); // Assuming you want to set line_name dynamically
                insertStmt.setString(8, classType);
                insertStmt.setString(9, discount);
                insertStmt.setString(10, trip);
                int result = insertStmt.executeUpdate();
                insertStmt.close();
                conn.close();

                if (result > 0) {
                    httpsession.setAttribute("reservationStatus", "success");
                    httpsession.setAttribute("reservationNumber", resNum);
                    httpsession.setAttribute("reservationMessage", "Reservation confirmed! Your reservation number is: " + resNum);
                } else {
                    httpsession.setAttribute("reservationStatus", "error");
                    httpsession.setAttribute("reservationMessage", "Failed to make a reservation. Please try again.");
                }
            } catch (SQLException e) {
                e.printStackTrace();
                httpsession.setAttribute("reservationStatus", "error");
                httpsession.setAttribute("reservationMessage", "Error: " + e.getMessage());
            }
        }

        // Retrieve session attributes for feedback
        String reservationStatus = (String) httpsession.getAttribute("reservationStatus");
        String reservationMessage = (String) httpsession.getAttribute("reservationMessage");
    %>

    <h2>Reserve Your Ticket</h2>

    <%
        if ("success".equals(reservationStatus)) {
    %>
        <div style="color: green; font-weight: bold;">
            <p><%= reservationMessage %></p>
        </div>
    <%
        } else if ("error".equals(reservationStatus)) {
    %>
        <div style="color: red; font-weight: bold;">
            <p><%= reservationMessage %></p>
        </div>
    <%
        }
    %>

    <form action="makeReservation.jsp" method="post" onsubmit="return validateForm()">
        <input type="hidden" name="train_id" value="<%= trainId %>">
        <input type="hidden" name="origin" value="<%= origin %>">
        <input type="hidden" name="destination" value="<%= destination %>">
        <input type="hidden" name="fare" value="<%= fare %>">
        <input type="hidden" name="depart_time" value="<%= departTime %>">
        <input type="hidden" name="arrival_time" value="<%= arrivalTime %>">

        <input type="hidden" name="action" value="submit">

        <p><strong>Train ID:</strong> <%= trainId %></p>
        <p><strong>Origin:</strong> <%= origin %></p>
        <p><strong>Destination:</strong> <%= destination %></p>
        <p><strong>Fare:</strong> $<%= fare %></p>
        <p><strong>Departure Time:</strong> <%= departTime %></p>
        <p><strong>Arrival Time:</strong> <%= arrivalTime %></p>

        <label>Class:</label><br>
        <input type="radio" name="class" value="Business" <%= classType.equals("Business") ? "checked" : "" %> > Business
        <input type="radio" name="class" value="First" <%= classType.equals("First") ? "checked" : "" %> > First
        <input type="radio" name="class" value="Economy" <%= classType.equals("Economy") ? "checked" : "" %> > Economy
        <br><br>

        <label>Discount:</label><br>
        <input type="radio" name="discount" value="Disabled" <%= discount.equals("Disabled") ? "checked" : "" %> > Disabled
        <input type="radio" name="discount" value="Senior/Child" <%= discount.equals("Senior/Child") ? "checked" : "" %> > Senior/Child
        <input type="radio" name="discount" value="Normal" <%= discount.equals("Normal") ? "checked" : "" %> > Normal
        <br><br>

        <label>Trip Type:</label><br>
        <input type="radio" name="trip" value="Round" <%= trip.equals("Round") ? "checked" : "" %> > Round
        <input type="radio" name="trip" value="One" <%= trip.equals("One") ? "checked" : "" %> > One
        <input type="radio" name="trip" value="Monthly" <%= trip.equals("Monthly") ? "checked" : "" %> > Monthly
        <input type="radio" name="trip" value="Weekly" <%= trip.equals("Weekly") ? "checked" : "" %> > Weekly
        <br><br>

        <input type="submit" value="Submit">
    </form>
    <br>
    <br>
    <form action="schedReserve.jsp" method="get">
        <input type="submit" value="Cancel">
    </form>
</body>
</html>

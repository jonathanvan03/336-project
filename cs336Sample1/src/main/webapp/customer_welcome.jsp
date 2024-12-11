<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Customer Welcome</title>
    <style>
        form {
            display: inline-block;
            margin-right: 10px;
        }
        .profile-info {
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <%
        // Get the session and username
        HttpSession httpsession = request.getSession(false); // Don't create a new session if it doesn't exist
        String username = (httpsession != null) ? (String) httpsession.getAttribute("username") : null;

        if (username == null) {
            // If no session, redirect to login page
            response.sendRedirect("login.jsp");
        } else {
            ApplicationDB db = new ApplicationDB();
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            // Fetch the user's profile information from the database
            try {
                conn = db.getConnection();
                String selectSql = "SELECT * FROM customer WHERE username = ?";
                stmt = conn.prepareStatement(selectSql);
                stmt.setString(1, username);
                rs = stmt.executeQuery();

                if (rs.next()) {
                    String firstName = rs.getString("first_name");
                    String lastName = rs.getString("last_name");
                    String email = rs.getString("email");
    %>
        <h2>Welcome, <%= username %>!</h2>
        <p>You have successfully logged in.</p>
        <form action="schedule.jsp" method="post">
            <input type="submit" value="View All Train Schedules">
        </form>
        <form action="schedReserve.jsp" method="post">
            <input type="submit" value="Reserve a Train Ticket">
        </form>
        <br><br>

    <h2>Profile Information</h2>
    <div class="profile-info">
        <b>First Name:</b> <%= firstName %>
    </div>
    <div class="profile-info">
        <b>Last Name:</b> <%= lastName %>
    </div>
    <div class="profile-info">
        <b>Email:</b> <%= email %>
    </div>

    <br><br>
    <form action="logout.jsp" method="post">
        <input type="submit" value="Logout">
    </form>

    <%
                } else {
                    out.println("<p>User not found!</p>");
                }
            } catch (SQLException e) {
                e.printStackTrace();
                out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (conn != null) db.closeConnection(conn);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    %>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>View Profile</title>
    <style>
        form {
            display: inline-block;
            margin-right: 10px;
        }
    </style>
</head>
<body>
    <%
        HttpSession httpsession = request.getSession(false);
        String username = (httpsession != null) ? (String) httpsession.getAttribute("username") : null;

        if (username == null) {
            // If no session, redirect to login page
            response.sendRedirect("login.jsp");
        } else {
            // Create a connection using ApplicationDB
            ApplicationDB db = new ApplicationDB();
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                // Get the database connection
                conn = db.getConnection();

                // Query to get customer data based on the username
                String sql = "SELECT * FROM customer WHERE username = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, username);

                rs = stmt.executeQuery();

                if (rs.next()) {
                    String firstName = rs.getString("first_name");
                    String lastName = rs.getString("last_name");
                    String email = rs.getString("email");
                    String password = rs.getString("password");
    %>

    <h2>Edit Profile</h2>
    <form action="viewProfile.jsp" method="post">
        First Name: <input type="text" name="firstName" value="<%= firstName %>" required><br><br>
        Last Name: <input type="text" name="lastName" value="<%= lastName %>" required><br><br>
        Email: <input type="email" name="email" value="<%= email %>" required><br><br>
        <input type="submit" value="Update Profile">
    </form>

    <%
                } else {
                    out.println("<p>User not found!</p>");
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
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
</body>
</html>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Customer Registration</title>
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
    <h2>Customer Registration</h2>
    <form action="register.jsp" method="post">
        <!-- Input fields for registration -->
        <div class="profile-info">
            <b>First Name:</b> <input type="text" name="first_name" required><br><br>
        </div>
        <div class="profile-info">
            <b>Last Name:</b> <input type="text" name="last_name" required><br><br>
        </div>
        <div class="profile-info">
            <b>Username</b> <input type="text" name="username" required><br><br>
        </div>
        <div class="profile-info">
            <b>Email:</b> <input type="email" name="email" required><br><br>
        </div>
        <div class="profile-info">
            <b>Password:</b> <input type="password" name="password" required><br><br>
        </div>
        <div class="profile-info">
            <b>Confirm Password:</b> <input type="password" name="confirm_password" required><br><br>
        </div>
        
        <!-- Go button to submit the form -->
        <input type="submit" value="Go">
    </form>
    <form method="post" action="login.jsp">
        <input type="submit" value="Back">
    </form>

    <%
        // Handle form submission for customer registration
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            // Get form parameters
            String firstName = request.getParameter("first_name");
            String lastName = request.getParameter("last_name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirm_password");
            String username = request.getParameter("username");

            // Basic validation for password match
            if (password != null && confirmPassword != null) { 
                if (!password.equals(confirmPassword)) {
                    out.println("<p style='color: red;'>Passwords do not match. Please try again.</p>");
                } else {
                    ApplicationDB db = new ApplicationDB();
                    Connection conn = null;
                    PreparedStatement stmt = null;
                    ResultSet rs = null;

                    try {
                        // Check if the username or email already exists
                        conn = db.getConnection();
                        String checkUserSql = "SELECT * FROM customer WHERE username = ? OR email = ?";
                        stmt = conn.prepareStatement(checkUserSql);
                        stmt.setString(1, username);
                        stmt.setString(2, email);
                        rs = stmt.executeQuery();

                        if (rs.next()) {
                            // Username or email already exists
                            out.println("<p style='color: red;'>Username or Email already taken. Please choose another one.</p>");
                        } else {

                            // Insert the new customer data into the database
                            String insertSql = "INSERT INTO customer (first_name, last_name, email, password, username) VALUES (?, ?, ?, ?, ?)";
                            stmt = conn.prepareStatement(insertSql);
                            stmt.setString(1, firstName);
                            stmt.setString(2, lastName);
                            stmt.setString(3, email);
                            stmt.setString(4, password); // Store the hashed password
                            stmt.setString(5, username);

                            // Execute the update
                            int rowsInserted = stmt.executeUpdate();
                            if (rowsInserted > 0) {
                                out.println("<p style='color: green;'>Registration successful! Please <a href='login.jsp'>log in</a>.</p>");
                            } else {
                                out.println("<p style='color: red;'>Failed to register. Please try again.</p>");
                            }
                        }
                    } catch (SQLException e) {
                        // Handle SQL exception (for example, if there's a database error)
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
            } else {
                out.println("<p style='color: red;'>Please fill in all fields.</p>");
            }
        }
    %>
</body>
</html>

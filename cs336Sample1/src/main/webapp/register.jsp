<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Register</title>
</head>
<body>
    <h2>Register</h2>
    <form method="post" action="login.jsp">
    	<input type="submit" value="Back to Login"/>
    </form>
    <br>
    <form method="post" action="register.jsp">
        Username: <input type="text" name="username" required><br>
        Password: <input type="password" name="password" required><br>
        Email: <input type="email" name="email" required><br>
        
        <input type="submit" value="Register">
    </form>

	<% 
	// Process registration when form is submitted
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String email = request.getParameter("email");

    if (username != null && password != null && email != null) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            // Database connection details
            String dbURL = "jdbc:mysql://localhost:3306/cs336project";
            String dbUser = "root";
            String dbPass = "Pop-ems5384mysql";

            // Load MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish connection
            conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

            // Check if username already exists
            String checkSql = "SELECT username FROM customer WHERE username = ?";
            stmt = conn.prepareStatement(checkSql);
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                out.println("<p style='color: red;'>Username already exists. Please choose another.</p>");
            } else {
                // Insert new user into the database
                String insertSql = "INSERT INTO customer (username, password, email) VALUES (?, ?, ?)";
                stmt = conn.prepareStatement(insertSql);
                stmt.setString(1, username);
                stmt.setString(2, password); // Ideally, hash the password here
                stmt.setString(3, email);
                stmt.executeUpdate();

                out.println("<p style='color: green;'>Registration successful! <a href='login.jsp'>Click here to login</a>.</p>");
            }
            rs.close();
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
        } finally {
            try {
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
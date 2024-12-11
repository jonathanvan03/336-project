<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <title>Transit Login</title>
    </head>
    <body>
        <h2>Login</h2>
        <br>
        <!-- Form to get username and password -->
        <form method="post" action="login.jsp">
            Username: <input type="text" name="username" required>
            <br>
            Password: <input type="password" name="password" required/> 
            <br>
            <input type="submit" value="submit" />
        </form>
        
        <%
        // Get form parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Check if the username and password are provided
        if (username != null && password != null) {
            // Declare variables
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
            ApplicationDB db = new ApplicationDB(); // Instantiate ApplicationDB to get connection

            try {
                // Get the database connection from ApplicationDB
                conn = db.getConnection();

                // Query to check username and password
                String sql = "SELECT * FROM customer WHERE username = ? AND password = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, username);
                stmt.setString(2, password);

                rs = stmt.executeQuery();

                if (rs.next()) {
                    // Username and password are correct, start a session
                    HttpSession httpsession = request.getSession();
                    httpsession.setAttribute("username", username);

                    // Redirect to the welcome page
                    response.sendRedirect("welcome.jsp");
                } else {
                    out.println("<p style='color: red;'>Invalid username or password.</p>");
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
            } finally {
                try {
                    // Close the resources
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (conn != null) db.closeConnection(conn); // Close connection using ApplicationDB
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        %>
    </body>
</html>

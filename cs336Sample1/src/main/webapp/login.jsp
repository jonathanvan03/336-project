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
        <form method="post" action="login.jsp">
            Username: <input type="text" name="username" required>
            <br>
            Password: <input type="password" name="password" required/> 
            <br>
            <!-- Radio buttons to select user type -->
            <input type="radio" name="command" value="customer"/> Customer
            <input type="radio" name="command" value="employee"/> Employee
            <br>
            <input type="submit" value="Submit" />
        </form>
        
        <!-- Registration Link -->
        <form method="post" action="register.jsp">
            <br>
            New Customer? <input type="submit" value="Register Here">
        </form>
        <%
        // Get form parameters
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String command = request.getParameter("command"); // Get the selected role (customer or employee)
        // Ensure that username, password, and command are provided
        if (username != null && password != null && command != null) {
           	Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
            ApplicationDB db = new ApplicationDB(); // Instantiate ApplicationDB to get connection
            try {
                // Get the database connection from ApplicationDB
                conn = db.getConnection();
                // Prepare SQL query based on the selected role
                String sql = "";
                if ("customer".equals(command)) {
                    sql = "SELECT * FROM customer WHERE username = ? AND password = ?";
                } else if ("employee".equals(command)) {
                    sql = "SELECT * FROM employee WHERE username = ? AND password = ?";
                }
                
                // Prepare and execute the query
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, username);
                stmt.setString(2, password); // Ensure passwords are hashed and validated securely
                rs = stmt.executeQuery();
                if (rs.next()) {
                    // Start a session if the username and password are correct
                	HttpSession httpsession = request.getSession();
                	httpsession.setAttribute("username", username);
                   // Redirect based on role
                    if ("customer".equals(command)) {
                        response.sendRedirect("customer_welcome.jsp");
                    } else if ("employee".equals(command)) {
                    	// Check the role of the employee (admin or rep)
                        String role = rs.getString("role");
                        if ("admin".equals(role)) {
                            response.sendRedirect("admin_dashboard.jsp");
                        } else if ("rep".equals(role)) {
                            response.sendRedirect("rep_dashboard.jsp");
                        } else {
                            out.println("<p style='color: red;'>Unknown employee role.</p>");
                        }
                    }
               	} else {
                    out.println("<p style='color: red;'>Invalid username or password.</p>");
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
            } finally {
                // Close resources
                try {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (conn != null) db.closeConnection(conn); // Use the closeConnection method from ApplicationDB
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        } else {
            // Display error if any field is missing
            out.println("<p style='color: red;'>Please fill all fields and select a role.</p>");
        }
        %>
      </body>
</html>
  
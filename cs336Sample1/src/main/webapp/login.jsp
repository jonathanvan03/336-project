<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
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
	
		 <!-- Show html form to i) display something, ii) choose an action via a 
		  | radio button -->
		<!-- forms are used to collect user input 
			The default method when submitting form data is GET.
			However, when GET is used, the submitted form data will be visible in the page address field-->
		<form method="post" action="login.jsp">
		    <!-- note the show.jsp will be invoked when the choice is made -->
			<!-- The next lines give HTML for radio buttons being displayed -->
		  Username: <input type="text" name="username" required>
		  <br>
		  Password: <input type="password" name="password" required/> 
		    <!-- when the radio for bars is chosen, then 'command' will have value 
		     | 'bars', in the show.jsp file, when you access request.parameters -->
		     <br>
		  	<input type="radio" name="command" value="customer"/> Customer
		  	<input type="radio" name="command" value="employee"/> Employee
		  <br>
		  <input type="submit" value="submit" />
		</form>
		
		<form method="post" action="register.jsp">
		<br>
		New Customer? <input type="submit" value="Register Here">
		</form>
		
	<%
	    String username = request.getParameter("username");
	    String password = request.getParameter("password");
	    String command = request.getParameter("command"); // Get the selected role (customer or employee)
	
	    if (username != null && password != null && command != null) {
	        Connection conn = null;
	        PreparedStatement stmt = null;
	        ResultSet rs = null;
	
	        try {
	            // Database connection details
	            String dbURL = "jdbc:mysql://localhost:3306/cs336project";
	            String dbUser = "root";
	            String dbPass = "Pop-ems5384mysql";
	
	            // Load MySQL JDBC Driver
	            Class.forName("com.mysql.jdbc.Driver");
	
	            // Establish connection
	            conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
	
	            // Query to check username and password for customers
	            String sql = "";
	            if ("customer".equals(command)) {
	                sql = "SELECT * FROM customer WHERE username = ? AND password = ?";
	            } else if ("employee".equals(command)) {
	                sql = "SELECT * FROM employee WHERE username = ? AND password = ?";
	            }
	
	            stmt = conn.prepareStatement(sql);
	            stmt.setString(1, username);
	            stmt.setString(2, password); // Ensure passwords are hashed and validated securely
	
	            rs = stmt.executeQuery();
	
	            if (rs.next()) {
	                // Username and password are correct, start a session
	                HttpSession httpsession = request.getSession();
	                httpsession.setAttribute("username", username);
	
	                // Redirect based on role
	                if ("customer".equals(command)) {
	                    response.sendRedirect("customer_welcome.jsp");
	                } else if ("employee".equals(command)) {
	                    response.sendRedirect("employee_welcome.jsp");
	                }
	            } else {
	                out.println("<p style='color: red;'>Invalid username or password.</p>");
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
	    } else {
	        out.println("<p style='color: red;'>Please fill all fields and select a role.</p>");
	    }
	%>	
    </body>
</html>
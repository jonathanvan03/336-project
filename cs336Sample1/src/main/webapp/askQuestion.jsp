<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Create Inquiry</title>
</head>
<body>
    <h2>Submit Your Inquiry</h2>

    <!-- Form for submitting a new question/inquiry -->
    <form method="post" action="askQuestion.jsp">
        <label for="summary">Summary:</label><br>
        <input type="text" name="summary" id="summary" required><br><br>

        <label for="description">Description:</label><br>
        <textarea name="description" id="description" rows="4" cols="50" required></textarea><br><br>

        <input type="submit" value="Submit Inquiry">
    </form>

    <%
        // Handle form submission for submitting an inquiry
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String summary = request.getParameter("summary");
            String description = request.getParameter("description");
            String username = (session != null) ? (String) session.getAttribute("username") : null;

            if (username == null) {
                response.sendRedirect("login.jsp"); // Redirect to login if not logged in
            } else {
                ApplicationDB db = new ApplicationDB();
                Connection conn = null;
                PreparedStatement stmt = null;

                try {
                    conn = db.getConnection();
                    String insertSql = "INSERT INTO messages (username, summary, description, status) VALUES (?, ?, ?, 'unanswered')";
                    stmt = conn.prepareStatement(insertSql);
                    stmt.setString(1, username);
                    stmt.setString(2, summary);
                    stmt.setString(3, description);

                    int rowsInserted = stmt.executeUpdate();
                    if (rowsInserted > 0) {
                        out.println("<p>Your inquiry has been successfully submitted!</p>");
                    } else {
                        out.println("Make sure both fields are filled.");
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
                } finally {
                    try {
                        if (stmt != null) stmt.close();
                        if (conn != null) db.closeConnection(conn);
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
    %>

    <!-- Back to Questions List -->
    <form action="viewInquiry.jsp" method="post">
        <input type="submit" value="Back to Questions List">
    </form>

</body>
</html>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>View All Questions and Inquiries</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
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
    <h2>All Questions and Inquiries</h2>
    <h3>Questions</h3>
    <form method="post" action="keywordSearch.jsp">
    	Search By Keyword: <input type="text" name="keyword">
    	<input type="submit" value="Search">
    </form>
    <form method="post" action="resetSearch.jsp">
    	<input type="submit" value="Reset Search">
    </form>
    <form method="post" action="askQuestion.jsp">
    	<input type="submit" value="Create Inquiry">
    </form>
    
    <br><br>
    <table>
        <thead>
            <tr>
                <th>Message ID</th>
                <th>Username</th>
                <th>Summary</th>
                <th>Description</th>
                <th>Answer</th>
                <th>Answered By</th>
            </tr>
        </thead>
        <tbody>
            <%
                ApplicationDB db = new ApplicationDB();
                Connection conn = null;
                PreparedStatement stmt = null;
                ResultSet rs = null;

                try {
                    conn = db.getConnection();
                    String query = "SELECT message_id, username, summary, description, answer, answered_by FROM messages";
                    stmt = conn.prepareStatement(query);
                    rs = stmt.executeQuery();

                    while (rs.next()) {
                        int messageId = rs.getInt("message_id");
                        String username = rs.getString("username");
                        String summary = rs.getString("summary");
                        String description = rs.getString("description");
                        String answer = rs.getString("answer");
                        String answeredBy = rs.getString("answered_by");
            %>
                        <tr>
                            <td><%= messageId %></td>
                            <td><%= username %></td>
                            <td><%= summary %></td>
                            <td><%= description %></td>
                            <td><%= (answer != null ? answer : "Unanswered") %></td>
                            <td><%= (answeredBy != null ? answeredBy : "Unanswered") %></td>
                        </tr>
            <%
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    out.println("<tr><td colspan='6' style='color: red;'>Error loading data: " + e.getMessage() + "</td></tr>");
                } finally {
                    try {
                        if (rs != null) rs.close();
                        if (stmt != null) stmt.close();
                        if (conn != null) db.closeConnection(conn);
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            %>
        </tbody>
    </table>

    <form action="customer_welcome.jsp" method="post">
        <input type="submit" value="Back to Dashboard">
    </form>
</body>
</html>

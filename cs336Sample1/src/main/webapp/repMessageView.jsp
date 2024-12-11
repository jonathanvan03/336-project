<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Representative Dashboard - View Questions</title>
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
        textarea {
            width: 100%;
            height: 100px;
        }
    </style>
</head>
<body>

    <%
        // Check if the representative is logged in
        HttpSession httpsession = request.getSession(false); 
        String repUsername = (httpsession != null) ? (String) httpsession.getAttribute("username") : null;

        if (repUsername == null) {
            // If no session, redirect to login page
            response.sendRedirect("login.jsp");
        } else {
    %>

        <h2>Welcome, <%= repUsername %> to your Representative Dashboard!</h2>

        <form method="post" action="repMessageView.jsp">
            Search By KeyWord: <input type="text" name="keyword" value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>">
            <input type="submit" value="Search">
        </form>

        <form method="post" action="repMessageView.jsp">
            <input type="submit" value="Reset Search">
        </form>

        <h3>Customer Questions</h3>

        <table>
            <thead>
                <tr>
                    <th>Message ID</th>
                    <th>Username</th>
                    <th>Summary</th>
                    <th>Description</th>
                    <th>Answer</th>
                    <th>Answered By</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    String keyword = request.getParameter("keyword");
                    ApplicationDB db = new ApplicationDB();
                    Connection conn = null;
                    PreparedStatement stmt = null;
                    ResultSet rs = null;

                    try {
                        conn = db.getConnection();
                        String query;

                        if (keyword != null && !keyword.trim().isEmpty()) {
                            // Search for the keyword in summary, description, or answer
                            query = "SELECT message_id, username, summary, description, answer, answered_by FROM messages " +
                                    "WHERE summary LIKE ? OR description LIKE ? OR answer LIKE ?";
                            stmt = conn.prepareStatement(query);
                            String keywordWithWildcard = "%" + keyword + "%";
                            stmt.setString(1, keywordWithWildcard);
                            stmt.setString(2, keywordWithWildcard);
                            stmt.setString(3, keywordWithWildcard);
                        } else {
                            // Show all messages (answered and unanswered)
                            query = "SELECT message_id, username, summary, description, answer, answered_by FROM messages";
                            stmt = conn.prepareStatement(query);
                        }

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
                                <td>
                                    <%
                                        if (answer == null) {  // If the question is unanswered, show "Answer" button
                                    %>
                                            <form method="post" action="repMessageView.jsp">
                                                <input type="hidden" name="message_id" value="<%= messageId %>">
                                                <input type="submit" value="Answer">
                                            </form>
                                    <%
                                        } else {  // If the question is answered, show "Edit Answer" button
                                    %>
                                            <form method="post" action="repMessageView.jsp">
                                                <input type="hidden" name="message_id" value="<%= messageId %>">
                                                <input type="submit" value="Edit Answer">
                                            </form>
                                    <%
                                        }
                                    %>
                                </td>
                            </tr>
                <%
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                        out.println("<tr><td colspan='7' style='color: red;'>Error loading data: " + e.getMessage() + "</td></tr>");
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

        <%
            // Handle Answer Submission
            String messageIdParam = request.getParameter("message_id");
            if (messageIdParam != null) {
                int messageId = Integer.parseInt(messageIdParam);
        %>

        <h3>Answer the Question</h3>
        <form method="post" action="repMessageView.jsp">
            <textarea name="answer" placeholder="Type your answer here..."></textarea><br><br>
            <input type="hidden" name="message_id" value="<%= messageId %>">
            <input type="submit" value="Submit Answer">
        </form>

        <%
            // Handle the form submission for answering or editing the answer
            String answer = request.getParameter("answer");
            if (answer != null && !answer.trim().isEmpty()) {
                ApplicationDB dbUpdate = new ApplicationDB();
                Connection connUpdate = null;
                PreparedStatement stmtUpdate = null;

                try {
                    connUpdate = dbUpdate.getConnection();
                    String updateSql = "UPDATE messages SET answer = ?, status = 'answered', answered_by = ? WHERE message_id = ?";
                    stmtUpdate = connUpdate.prepareStatement(updateSql);
                    stmtUpdate.setString(1, answer);
                    stmtUpdate.setString(2, repUsername);
                    stmtUpdate.setInt(3, messageId);
                    int rowsUpdated = stmtUpdate.executeUpdate();

                    if (rowsUpdated > 0) {
                        // Redirect back to repMessageView.jsp to refresh the table
                        response.sendRedirect("repMessageView.jsp");
                    } else {
                        out.println("<p style='color: red;'>Failed to submit your answer. Please try again.</p>");
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
                } finally {
                    try {
                        if (stmtUpdate != null) stmtUpdate.close();
                        if (connUpdate != null) dbUpdate.closeConnection(connUpdate);
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }
        %>

        <% }} %>

        <form action="rep_dashboard.jsp" method="post">
            <input type="submit" value="Back to Dashboard">
        </form>

</body>
</html>


<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Customers by Line and Date</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>

    <%
        // Fetch transit lines for the dropdown
        ApplicationDB db = new ApplicationDB();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet linesRs = null;

        try {
            conn = db.getConnection();
            String lineQuery = "SELECT DISTINCT line_name FROM reservation ORDER BY line_name ASC";
            stmt = conn.prepareStatement(lineQuery);
            linesRs = stmt.executeQuery();
    %>

    <!-- Form to select line and date -->
    <h2>Select Transit Line and Date</h2>
    <form method="post" action="customersbylinedate.jsp">
        <label for="transit_line">Transit Line:</label>
        <select name="transit_line" id="transit_line" required>
            <option value="">-- Select Transit Line --</option>
            <%
                while (linesRs.next()) {
                    String lineName = linesRs.getString("line_name");
            %>
                    <option value="<%= lineName %>"><%= lineName %></option>
            <%
                }
            %>
        </select><br><br>

        <label for="date">Date:</label>
        <input type="date" name="date" id="date" required><br><br>

        <input type="submit" value="Search">
    </form>

    <%
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<p style='color: red;'>Error loading transit lines: " + e.getMessage() + "</p>");
        } finally {
            try {
                if (linesRs != null) linesRs.close();
                if (stmt != null) stmt.close();
                if (conn != null) db.closeConnection(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        // Process the form submission
        String transitLine = request.getParameter("transit_line");
        String date = request.getParameter("date");

        if (transitLine != null && date != null) {
            PreparedStatement searchStmt = null;
            ResultSet searchRs = null;

            try {
                conn = db.getConnection();

                // Query distinct customers for the specified line and date
                String query = "SELECT DISTINCT r.passenger, c.first_name, c.last_name " +
                               "FROM reservation r " +
                               "JOIN customer c ON r.passenger = c.username " +
                               "WHERE r.line_name = ? AND DATE(r.res_date) = ?";
                searchStmt = conn.prepareStatement(query);
                searchStmt.setString(1, transitLine);
                searchStmt.setString(2, date);

                searchRs = searchStmt.executeQuery();

                // Display results in a table
    %>
                <h2>Customers with Reservations for Line: <%= transitLine %> on <%= date %></h2>
                <table>
                    <thead>
                        <tr>
                            <th>Username</th>
                            <th>First Name</th>
                            <th>Last Name</th>
                        </tr>
                    </thead>
                    <tbody>
    <%
                boolean hasResults = false;
                while (searchRs.next()) {
                    hasResults = true;
                    String username = searchRs.getString("passenger");
                    String firstName = searchRs.getString("first_name");
                    String lastName = searchRs.getString("last_name");
    %>
                    <tr>
                        <td><%= username %></td>
                        <td><%= firstName %></td>
                        <td><%= lastName %></td>
                    </tr>
    <%
                }
                if (!hasResults) {
    %>
                    <tr>
                        <td colspan="3">No customers found for the specified line and date.</td>
                    </tr>
    <%
                }
    %>
                    </tbody>
                </table>
    <%
            } catch (SQLException e) {
                e.printStackTrace();
                out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
            } finally {
                try {
                    if (searchRs != null) searchRs.close();
                    if (searchStmt != null) searchStmt.close();
                    if (conn != null) db.closeConnection(conn);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        } else {
            out.println("<p>Please select a transit line and date to search.</p>");
        }
    %>

    <!-- Back to Dashboard -->
    <br><br>
    <form action="rep_dashboard.jsp" method="post">
        <input type="submit" value="Back to Dashboard">
    </form>

</body>
</html>

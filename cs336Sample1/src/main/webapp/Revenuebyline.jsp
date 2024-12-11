<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Line Revenue</title>
	</head>
	<body>
	<h2>Revenue by Transit Line</h2>
		<% try {
	
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		

			//Create a SQL statement
			Statement stmt = con.createStatement();
			//Make a SELECT query from the table specified by the 'command' parameter at the index.jsp
			String str = "SELECT line_name, SUM(fare) FROM reservation GROUP BY line_name";
			//Run the query against the database.
			ResultSet result = stmt.executeQuery(str);
		%>
			
	<table>
		<tr>    
			<td>Revenue by Line</td>

		</tr>
			<%
			//parse out the results
			while (result.next()) { %>
				<tr>    
					<td><%= result.getString("line_name") %></td>
					<td>
						<%= result.getString("SUM(fare)")%>
						
					</td>
				</tr>
				

			<% }
			//close the connection.
			db.closeConnection(con);
			%>
		</table>
<h2>Return</h2>
    <form action="admin_dashboard.jsp" method="post">
        <input type="submit" value="Back">
    </form>
			
		<%} catch (Exception e) {
			out.print(e);
		}%>
	

	</body>
</html>
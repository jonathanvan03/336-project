<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Most Active Lines</title>
	</head>
	<body>
	<h2>5 Most Active Lines</h2>
		<% try {
	
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		

			//Create a SQL statement
			Statement stmt = con.createStatement();
			//Make a SELECT query from the table specified by the 'command' parameter at the index.jsp
			String str = "SELECT line_name, COUNT(*) FROM reservation GROUP BY line_name ORDER BY COUNT(*) DESC LIMIT 5";
			//Run the query against the database.
			ResultSet result = stmt.executeQuery(str);
		%>
			
	<table>
		<tr>    
			

		</tr>
			<%
			//parse out the results
			while (result.next()) { %>
				<tr>    
					<td><%= result.getString("line_name") %></td>
		
				</tr>
				

			<% }
			//close the connection.
			db.closeConnection(con);
			%>
		</table>

			
		<%} catch (Exception e) {
			out.print(e);
		}%>
	<h2>Return</h2>
    <form action="admin_dashboard.jsp" method="post">
        <input type="submit" value="Back">
    </form>

	</body>
</html>
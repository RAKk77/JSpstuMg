<%@ page import="java.sql.*" %>
<%
    // Database configuration
    String driver = "com.mysql.cj.jdbc.Driver";
    String connectionUrl = "jdbc:mysql://localhost:3306/";
    String database = "dbstumanagrmant"; // Database name
    String userid = "root";
    String password = "123456";

    Connection connection = null;
    PreparedStatement preparedStatement = null;

    // Handle Insert operation
    String name = request.getParameter("name");
    String gender = request.getParameter("gender");
    String dob = request.getParameter("dob"); // Ensure this matches the input name
    String adress = request.getParameter("adress"); // Corrected column name

    if (name != null && gender != null && dob != null && adress != null) {
        try {
            Class.forName(driver);
            connection = DriverManager.getConnection(connectionUrl + database, userid, password);
            String insertQuery = "INSERT INTO tbl_students (name, gender, dob, adress) VALUES (?, ?, ?, ?)"; // Updated column name
            preparedStatement = connection.prepareStatement(insertQuery);
            preparedStatement.setString(1, name);
            preparedStatement.setString(2, gender);
            preparedStatement.setString(3, dob);
            preparedStatement.setString(4, adress); // Updated variable name
            preparedStatement.executeUpdate();

            // Redirect to result.jsp after insertion
            response.sendRedirect("result.jsp");
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error during insertion: " + e.getMessage() + "</p>");
        } finally {
            if (preparedStatement != null) try { preparedStatement.close(); } catch (SQLException e) {}
            if (connection != null) try { connection.close(); } catch (SQLException e) {}
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
     <link rel="stylesheet" href="./css/bootstrap.css">
    <title>Document</title>
  </head>
  <body>
    <!-- Form for data entry -->
            <div style="width: 500px;" class=" bg-outline-success form-control m-auto my-4 rounded-5">
                <h3 class="text-center">input Student Information</h3>
                
                <form method="post" action="index.jsp" class="form-control rounded-5 p-3" >
                    Name: <input class="form-control" type="text" name="name" required><br><br>
                    <%-- Gender: <input class="form-control" type="text" name="gender" required><br><br> --%>
                     Gender: 
                <select class="form-control" name="gender" required>
                    <option value="" disabled selected>Select Gender</option>
                    <option value="male">Male</option>
                    <option value="female">Female</option>
                    <option value="other">Other</option>
                </select><br><br>
                    Date of Birth: <input class="form-control" type="date" name="dob" required><br><br>
                    Address: <input class="form-control" type="text" name="adress" required><br><br> <!-- Corrected name -->
                    <div class="text-center">
                        <input class="btn btn-outline-success" type="submit" value="Insert">
                        <a class="btn btn-outline-success mx-3" href="result.jsp">View Records</a>
                    </div>
                </form>
            </div>
  </body>
</html>
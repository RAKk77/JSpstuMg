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
    ResultSet resultSet = null;

    // Handle Delete operation
    String deleteId = request.getParameter("deleteId");
    if (deleteId != null) {
        try {
            Class.forName(driver);
            connection = DriverManager.getConnection(connectionUrl + database, userid, password);
            String deleteQuery = "DELETE FROM tbl_students WHERE id = ?";
            preparedStatement = connection.prepareStatement(deleteQuery);
            preparedStatement.setInt(1, Integer.parseInt(deleteId));
            preparedStatement.executeUpdate();
            out.println("<p style='color:green;'>Record deleted successfully!</p>");
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error during deletion: " + e.getMessage() + "</p>");
        } finally {
            if (preparedStatement != null) try { preparedStatement.close(); } catch (SQLException e) {}
            if (connection != null) try { connection.close(); } catch (SQLException e) {}
        }
    }

    // Handle Update operation
    String editId = request.getParameter("editId");
    String updatedName = request.getParameter("name");
    String updatedGender = request.getParameter("gender");
    String updatedDob = request.getParameter("dob");
    String updatedAdress = request.getParameter("adress");

    if (editId != null && updatedName != null && updatedGender != null && updatedDob != null && updatedAdress != null) {
        try {
            Class.forName(driver);
            connection = DriverManager.getConnection(connectionUrl + database, userid, password);
            String updateQuery = "UPDATE tbl_students SET name=?, gender=?, dob=?, adress=? WHERE id=?";
            preparedStatement = connection.prepareStatement(updateQuery);
            preparedStatement.setString(1, updatedName);
            preparedStatement.setString(2, updatedGender);
            preparedStatement.setString(3, updatedDob);
            preparedStatement.setString(4, updatedAdress);
            preparedStatement.setInt(5, Integer.parseInt(editId));
            preparedStatement.executeUpdate();
            out.println("<p style='color:green;'>Record updated successfully!</p>");
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error during update: " + e.getMessage() + "</p>");
        } finally {
            if (preparedStatement != null) try { preparedStatement.close(); } catch (SQLException e) {}
            if (connection != null) try { connection.close(); } catch (SQLException e) {}
        }
    }

    // Retrieve sorting preference
    String sortBy = request.getParameter("sortBy");
    if (sortBy == null) sortBy = "name"; // Default sort by name

    // Retrieve all records for display with sorting
    try {
        Class.forName(driver);
        connection = DriverManager.getConnection(connectionUrl + database, userid, password);
        String query = "SELECT * FROM tbl_students ORDER BY " + sortBy;
        preparedStatement = connection.prepareStatement(query);
        resultSet = preparedStatement.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
     <link rel="stylesheet" href="./css/bootstrap.css">
    <title>Document</title>
     
</head>
<body>
       
   <div Class=" mx-5 mt-4 d-flex flex-row-reverse justify-content-between" style="width: 90%;">
        <div class="mx-5 w-100">
            
            <table  Class="table table-striped  bg-info">
                 <!-- Display Records -->
        <h1 class="text-center my-1">Student Information</h1>
        <div class="btn btn-outline-success my-1"><a href="index.jsp" class=" text-decoration-none texr-dack">Insert New Record</a></div>

        <!-- Sorting Options -->
        <form method="get" action="result.jsp">
            <span class="mx-3">Sort by:</span>
            <button class="btn btn-outline-success mx-2" type="submit" name="sortBy" value="name" <%= "name".equals(sortBy) ? "class='selected'" : "" %>>Name</button>
            <button class="btn btn-outline-success " type="submit" name="sortBy" value="id" <%= "id".equals(sortBy) ? "class='selected'" : "" %>>ID</button>
         </form>

            
                        <tr>
                            <th>Student ID</th>
                            <th>Student Name</th>
                            <th>Gender</th>
                            <th>Date of Birth</th>
                            <th>Address</th>
                            <th>Actions</th>
                        </tr>
            
                    <%
                        while (resultSet.next()) {
                            String id = resultSet.getString("id");
                            String name = resultSet.getString("name");
                            String gender = resultSet.getString("gender");
                            String dob = resultSet.getString("dob");
                            String adress = resultSet.getString("adress");
                    %>
            
                        <tr>
                            <td><%= id %></td>
                            <td><%= name %></td>
                            <td><%= gender %></td>
                            <td><%= dob %></td>
                            <td><%= adress %></td>
                            <td>
                                <form method="get" action="result.jsp" style="display:inline;">
                                    <input type="hidden" name="editId" value="<%= id %>">
                                    <input class="btn btn-outline-success" type="submit" value="Edit">
                                </form>
                                <form method="post" action="result.jsp" style="display:inline;">
                                    <input type="hidden" name="deleteId" value="<%= id %>">
                                    <input class="btn btn-outline-danger" type="submit" value="Delete" onclick="return confirm('Are you sure you want to delete this record?');">
                                </form>
                            </td>
                        </tr>
            
                    <%
                        }
                    } catch (Exception e) {
                        out.println("<p style='color:red;'>Error during retrieval: " + e.getMessage() + "</p>");
                    } finally {
                        if (resultSet != null) try { resultSet.close(); } catch (SQLException e) {}
                        if (preparedStatement != null) try { preparedStatement.close(); } catch (SQLException e) {}
                        if (connection != null) try { connection.close(); } catch (SQLException e) {}
                    }
                    // If editId is provided, fetch the record for editing
                    String editName = "";
                    String editGender = "";
                    String editDob = "";
                    String editAdress = "";
                    if (editId != null) {
                        try {
                            Class.forName(driver);
                            connection = DriverManager.getConnection(connectionUrl + database, userid, password);
                            String editQuery = "SELECT * FROM tbl_students WHERE id = ?";
                            preparedStatement = connection.prepareStatement(editQuery);
                            preparedStatement.setInt(1, Integer.parseInt(editId));
                            resultSet = preparedStatement.executeQuery();
                            if (resultSet.next()) {
                                editName = resultSet.getString("name");
                                editGender = resultSet.getString("gender");
                                editDob = resultSet.getString("dob");
                                editAdress = resultSet.getString("adress");
                            }
                        } catch (Exception e) {
                            out.println("<p style='color:red;'>Error during retrieval for edit: " + e.getMessage() + "</p>");
                        } finally {
                            if (resultSet != null) try { resultSet.close(); } catch (SQLException e) {}
                            if (preparedStatement != null) try { preparedStatement.close(); } catch (SQLException e) {}
                            if (connection != null) try { connection.close(); } catch (SQLException e) {}
                        }
                    }
                    %>
            
                <!-- Update Form -->
                
                </table>
        </div>
    <div style=" width: 600px; margin-top: 10px;" id="updateForm"  >
            <h3>Update Student Information</h3>
            <div class="bg-light">
                <form method="post" action="result.jsp">
                    <input type="hidden" name="editId" value="<%= editId %>">
                    <input class="form-control " type="text" name="name"  placeholder="Name" value="<%= editName %>" required><br><br>
                    <input class="form-control " type="text" name="gender" placeholder="Gender" value="<%= editGender %>" required><br><br>
                    <input class="form-control" type="text" name="dob" placeholder="Date of Birth" value="<%= editDob %>" required><br><br>
                    <input class="form-control" type="text" name="adress" placeholder="Address" value="<%= editAdress %>" required><br><br>
                    <div class="text-center">
                        <input class="btn btn-outline-success mx-3 " type="submit" value="Update">
                        <button class="btn btn-outline-warning " type="button" onclick="document.getElementById('updateForm').style.display='none';">Cancel</button>
                    </div>
                </form>
            </div>
    </div>
  </div>
</body>
</html>
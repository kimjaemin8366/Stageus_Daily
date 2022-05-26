<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.sql.DriverManager" %> 
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %> 
<%@ page import="java.sql.ResultSet" %> 

<%

    String id = (String) request.getParameter("input_id");
    String pw = (String) request.getParameter("input_pw");
    String name= (String) request.getParameter("input_name");
    String department = (String) request.getParameter("input_department");
    String position = (String) request.getParameter("input_position");

    Class.forName("com.mysql.jdbc.Driver");
    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/calender","Stageus","8366");
    
    String sql = "INSERT INTO users(user_id, password, name, department,position) VALUES (?,?,?,?,?)";
    PreparedStatement query = connect.prepareStatement(sql);
    query.setString(1, id);
    query.setString(2, pw);
    query.setString(3, name);
    query.setString(4, department);
    query.setString(5, position);

    query.executeUpdate();

%>


<body>
    <script>
        window.onload = function(){
            alert("환영합니다.");
            location.href="../login/login_page.jsp";
        }
    </script>
</body>
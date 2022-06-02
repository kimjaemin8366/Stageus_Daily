<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.sql.DriverManager" %> 
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %> 
<%@ page import="java.sql.ResultSet" %> 
<%@ page import="java.util.Vector"%>

<%

    String input_id = request.getParameter("id");
    String input_pw = request.getParameter("password");

    Class.forName("com.mysql.jdbc.Driver");
    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/calender","Stageus","8366");
    
    String sql = "SELECT * FROM users WHERE user_id = ? AND password=?";
    PreparedStatement query = connect.prepareStatement(sql);
    query.setString(1, input_id);
    query.setString(2, input_pw);

    ResultSet result = query.executeQuery();
    Boolean logged_success = false;

    if(result.next()){
        logged_success = true;
        session.setAttribute("logged_id", input_id);

        String name = result.getString("name");
        String department = result.getString("department");
        String position =  result.getString("position");

        session.setAttribute("name", name);
        session.setAttribute("department",department);
        session.setAttribute("position", position);
    }
%>

<body>

    <script>

        function login_check(){
            var logged_success = <%=logged_success%>
            if(logged_success){
                
                var today = new Date();
                var year = today.getFullYear();
                var month = today.getMonth() + 1;

                location.href="../calender/calender_page.jsp?user_id=<%=input_id%>&year="+year+"&month="+month;
            }else{
                alert("회원정보가 일치하지 않습니다.");
                location.href="login_page.jsp";
            }
        }
        window.onload= function(){

            login_check();
        }
    </script>
</body>
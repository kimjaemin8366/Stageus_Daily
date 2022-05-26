<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.sql.DriverManager" %> 
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %> 
<%@ page import="java.sql.ResultSet" %> 

<%
    String id = (String) session.getAttribute("logged_id");

    if(id==""){
        response.sendRedirect("../login/login_page.jsp");
    }
    
    String screen_year = request.getParameter("now_screen_year");
    String screen_month = request.getParameter("now_screen_month");

    String date = request.getParameter("new_schedule_date");
    String time = request.getParameter("new_schedule_time");
    String content = request.getParameter("new_schedule_content");
    String datetime = date + " " + time+ ":00";

    Class.forName("com.mysql.jdbc.Driver");
    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/calender","Stageus","8366");
    
    String sql = "INSERT INTO schedule(schedule_content, schedule_datetime, user_id) VALUES(?,?,?)";
    PreparedStatement query = connect.prepareStatement(sql);
    query.setString(1, content);
    query.setString(2, datetime);
    query.setString(3, id);

    query.executeUpdate();

%>

<body>

    <script>
        window.onload=function(){
            location.href="./calender_page.jsp?user_id=<%=id%>&year=<%=screen_year%>&month=<%=screen_month%>";
        }
    </script>
</body>
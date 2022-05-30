<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.sql.DriverManager" %> 
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %> 
<%@ page import="java.sql.ResultSet" %> 

<%
    String logged_id = (String) session.getAttribute("logged_id");

    if(logged_id=="" || logged_id==null){
        response.sendRedirect("../login/login_page.jsp");
    }
    
    String screen_year = (String) request.getParameter("now_screen_year");
    String screen_month = (String) request.getParameter("now_screen_month");

    String date = (String) request.getParameter("new_schedule_date");
    String time = (String) request.getParameter("new_schedule_time");
    String content = (String) request.getParameter("new_schedule_content");
    String datetime = date + " " + time+ ":00";

    Class.forName("com.mysql.jdbc.Driver");
    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/calender","Stageus","8366");
    
    String sql = "INSERT INTO schedule(schedule_content, schedule_datetime, user_id) VALUES(?,?,?)";
    PreparedStatement query = connect.prepareStatement(sql);
    query.setString(1, content);
    query.setString(2, datetime);
    query.setString(3, logged_id);

    query.executeUpdate();

%>

<body>

    <script>
        window.onload=function(){
            location.href="./calender_page.jsp?user_id=<%=logged_id%>&year=<%=screen_year%>&month=<%=screen_month%>";
        }
    </script>
</body>
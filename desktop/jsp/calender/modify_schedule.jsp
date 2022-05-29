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
    
    String screen_year = request.getParameter("now_screen_year");
    String screen_month = request.getParameter("now_screen_month");

    String schedule_id = request.getParameter("schedule_id");
    String content = request.getParameter("schedule_content");
    String date = request.getParameter("modified_schedule_date");
    String time = request.getParameter("modified_schedule_time");
    String datetime = date + " " + time;

    Class.forName("com.mysql.jdbc.Driver");
    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/calender","Stageus","8366");


    // 권한이 있는 사람이 수정했는지 체크
    String user_sql = "SELECT user_id FROM schedule WHERE schedule_id = ?";
    PreparedStatement user_query = connect.prepareStatement(user_sql);
    user_query.setString(1, schedule_id);

    ResultSet result = user_query.executeQuery();
    if(result.next()){
        if(logged_id.equals(result.getString(1))){
            response.SendRedirect("./no_auth_alert_page.jsp");
        }
    }

    // 수정 진행
    
    String sql = "UPDATE schedule SET schedule_content=?, schedule_datetime=? WHERE schedule_id=?";
    PreparedStatement query = connect.prepareStatement(sql);
    query.setString(1, content);
    query.setString(2, datetime);
    query.setString(3, schedule_id);

    query.executeUpdate();

%>

<body>
    <script>
        location.href="./calender_page.jsp?user_id=<%=logged_id%>&year=<%=screen_year%>&month=<%=screen_month%>";
    </script>
</body>
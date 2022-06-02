<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.sql.DriverManager" %> 
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %> 
<%@ page import="java.sql.ResultSet" %> 
<%@ page import="java.time.LocalDate"%>

<%
    Boolean input_success = true;
    LocalDate now = LocalDate.now();
    String logged_id = (String) session.getAttribute("logged_id");

    if(logged_id=="" || logged_id==null){
        response.sendRedirect("../login/login_page.jsp");
    }
    
    // 추가 당시 화면에 연도, 월의 값을 서버로 입력받지 못할 경우 직접 추가해줌.
    String screen_year = (String) request.getParameter("now_screen_year");
    if(screen_year=="" || screen_year==null){
        screen_year = String.valueOf(now.getYear());
    }
    
    String screen_month = (String) request.getParameter("now_screen_month");
    if(screen_month=="" || screen_month == null){
        screen_month = String.valueOf(now.getMonth());
    }


    // 내용 조건 확인.
    String date = (String) request.getParameter("new_schedule_date");
    if(date == "" || date == null){
        input_success = false;
    }
    String time = (String) request.getParameter("new_schedule_time");
    if(time == "" || time == null){
        input_success = false;
    }
    String content = (String) request.getParameter("new_schedule_content");
    if(content == "" || content == null){
        input_success = false;
    }

    if(input_success){
        String datetime = date + " " + time+ ":00";
        
        Class.forName("com.mysql.jdbc.Driver");
        Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/calender","Stageus","8366");
        
        String sql = "INSERT INTO schedule(schedule_content, schedule_datetime, user_id) VALUES(?,?,?)";
        PreparedStatement query = connect.prepareStatement(sql);
        query.setString(1, content);
        query.setString(2, datetime);
        query.setString(3, logged_id);
    
        query.executeUpdate();
    }

%>

<body>

    <script>
        window.onload=function(){
            if(!(<%=input_success%>)){
                alert("일정 추가 실패");
            }
            location.href="./calender_page.jsp?user_id=<%=logged_id%>&year=<%=screen_year%>&month=<%=screen_month%>";
        }
    </script>
</body>
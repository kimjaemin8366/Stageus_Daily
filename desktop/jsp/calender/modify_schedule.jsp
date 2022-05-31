<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.sql.DriverManager" %> 
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %> 
<%@ page import="java.sql.ResultSet" %> 
<%@ page import="java.time.LocalDate"%>

<%
    Boolean modify_success = true;
    LocalDate now = LocalDate.now();
    String logged_id = (String) session.getAttribute("logged_id");

    if(logged_id=="" || logged_id==null){
        response.sendRedirect("../login/login_page.jsp");
    }


    // 수정 당시 화면에 연도, 월의 값을 서버로 입력받지 못할 경우 직접 추가해줌.
    String screen_year = request.getParameter("now_screen_year");
    if(screen_year="" || screen_year==null){
        screen_year = String.valueOf(now.getYear());
    }

    String screen_month = request.getParameter("now_screen_month");
    if(screen_month="" || screen_month == null){
        screen_month = String.valueOf(<now class="getMonth"></now>());
    }

    // 내용 빈칸 확인.
    String schedule_id = request.getParameter("schedule_id");
    if(schedule_id =="" || schedule_id == null){
        modify_success = false;
    }

    String content = request.getParameter("schedule_content");
    if(content == "" || content_id == null){
        modify_success = false;
    }

    String date = request.getParameter("modified_schedule_date");
    if(date == "" || date == null){
        modify_success = false;
    }

    String time = request.getParameter("modified_schedule_time");
    if(time == "" || time == null){
        modify_success = false;
    }

    if(modify_success){
        String datetime = date + " " + time;

        Class.forName("com.mysql.jdbc.Driver");
        Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/calender","Stageus","8366");
    
    
        // 권한이 있는 사람이 수정했는지 체크
        String user_sql = "SELECT user_id FROM schedule WHERE schedule_id = ?";
        PreparedStatement user_query = connect.prepareStatement(user_sql);
        user_query.setString(1, schedule_id);
    
        ResultSet result = user_query.executeQuery();
        if(result.next()){
            if(!(logged_id.equals(result.getString(1)))){
                response.sendRedirect("./no_auth_alert_page.jsp");
            }
            else{
                // 수정 진행
                String sql = "UPDATE schedule SET schedule_content=?, schedule_datetime=? WHERE schedule_id=?";
                PreparedStatement query = connect.prepareStatement(sql);
                query.setString(1, content);
                query.setString(2, datetime);
                query.setString(3, schedule_id);
            
                query.executeUpdate();
            }
        }
    }
%>

<body>
    <script>
        window.onload= function(){
            if(!(<%=modify_success%>)){
                alert("일정 수정 실패");
            }
            location.href="./calender_page.jsp?user_id=<%=logged_id%>&year=<%=screen_year%>&month=<%=screen_month%>";
        }
    </script>
</body>
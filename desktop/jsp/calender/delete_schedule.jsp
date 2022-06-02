<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.sql.DriverManager" %> 
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %> 
<%@ page import="java.sql.ResultSet" %> 
<%@ page import="java.time.LocalDate"%>

<%
    String logged_id = (String) session.getAttribute("logged_id");
    LocalDate now = LocalDate.now();

    if(logged_id=="" || logged_id==null){
        response.sendRedirect("../login/login_page.jsp");
    }
    
    // 삭제 당시 화면에 연도, 월의 값을 서버로 입력받지 못할 경우 직접 추가해줌.
    String screen_year = (String) request.getParameter("now_screen_year");
    if(screen_year=="" || screen_year==null){
        screen_year = String.valueOf(now.getYear());
    }
    
    String screen_month = (String) request.getParameter("now_screen_month");
    if(screen_month=="" || screen_month == null){
        screen_month = String.valueOf(now.getMonth());
    }

    // 권한이 있는 사람이 삭제했는지 체크
    String schedule_id = request.getParameter("schedule_id");

    Class.forName("com.mysql.jdbc.Driver");
    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/calender","Stageus","8366");

    String user_sql = "SELECT user_id FROM schedule WHERE schedule_id = ?";
    PreparedStatement user_query = connect.prepareStatement(user_sql);
    user_query.setString(1, schedule_id);
    ResultSet result = user_query.executeQuery();
    // 위에는 필요없을듯
    
    if(result.next()){
        if(!(logged_id.equals(result.getString(1)))){ 
            response.sendRedirect("./no_auth_alert_page.jsp");
        }else{

            // 삭제 진행
            String sql = "DELETE FROM schedule WHERE schedule_id = ?";
            PreparedStatement query = connect.prepareStatement(sql);
            query.setString(1, schedule_id);
        
            query.executeUpdate();
        }
    }


%>

<body>
    <script>
        location.href="./calender_page.jsp?user_id=<%=logged_id%>&year=<%=screen_year%>&month=<%=screen_month%>";
    </script>
</body>
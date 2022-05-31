<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.sql.DriverManager" %> 
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %> 
<%@ page import="java.sql.ResultSet" %> 
<%@ page import="java.util.Vector" %>
<%@page import = "java.util.Enumeration"%>

<%
    String logged_id = (String) session.getAttribute("logged_id");
    String logged_position = (String) session.getAttribute("position");

    if(logged_id=="" || logged_id==null){
        response.sendRedirect("../login/login_page.jsp");
    }
    
%>

<body>
    <script>
        window.onload = function(){
            alert("접근 권한이 없습니다.");
            var today = new Date();
            var year = today.getFullYear();
            var month = today.getMonth() + 1;
            location.href="../calender/calender_page.jsp?user_id=<%=logged_id%>&year="+year+"&month="+month;
        }
    </script>
</body>
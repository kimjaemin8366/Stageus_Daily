<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.sql.DriverManager" %> 
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %> 
<%@ page import="java.sql.ResultSet" %> 

<%

    Cookie[] cookies = request.getCookies();
    if(cookies!=null){
        for(int idx=0; idx<cookies.length; idx++){
            cookies[idx].setMaxAge(0);
            response.addCookie(cookies[idx]);
        }
    }   

    session.invalidate();
%>

<body>
    <script>
        window.onload=function(){
            location.href="../login/login_page.jsp";
        }
    </script>
</body>
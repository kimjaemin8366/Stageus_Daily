<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.sql.DriverManager" %> 
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %> 
<%@ page import="java.sql.ResultSet" %> 

<%
    String logged_id = (String) session.getAttribute("logged_id");
    Boolean logged = false;

    if(logged_id != null){
        logged = true;
    }
%>

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width", initial-scale=1>
    <link rel="stylesheet" type="text/css" href="../../css/font/font.css">
    <link rel="stylesheet" type="text/css" href="../../css/login/login_page.css">
    <title>로그인</title>
</head>
<body>
    <main>
        <form id="login_form" action="login_check.jsp" onsubmit="before_login_check()">
            <div>
                <input class="login_input" type="text" name= "id" placeholder="아이디" maxlength="20">
            </div>
            <div>
                <input class="login_input" type="password" name="password" placeholder="비밀번호" maxlength="20">
            </div>
            <div>
                <input class="login_button" type="submit" value="로그인">
            </div>
            <div>
                <input class="login_button" type="button" value="회원가입" onclick="location.href='../join/join_page.jsp'">
            </div>
        </form>
    </main>

    <script>

        function before_login_check(){
            var inputs = document.getElementsByClassName("login_input");
            var error_message = ["아이디를 입력해주세요", "비밀번호를 입력해주세요"];
            for(var idx=0; idx<=1; idx++){
                if(inputs[idx].value==""){
                    alert(error_message[idx]);
                    event.preventDefault();
                    return;
                }
            }
        }

        window.onload = function(){
            var logged = <%=logged%>;
            if(logged== true){
                var today = new Date();
                var year = today.getFullYear();
                var month = today.getMonth() + 1;
                location.href="../calender/calender_page.jsp?user_id=<%=logged_id%>&year="+year+"&month="+month;
            }
        }
    </script>
</body>

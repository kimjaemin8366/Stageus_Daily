<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.sql.DriverManager" %> 
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %> 
<%@ page import="java.sql.ResultSet" %> 

<%
    String id = (String) request.getParameter("user_id");

    Class.forName("com.mysql.jdbc.Driver");
    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/calender","Stageus","8366");
    
    String sql = "SELECT user_id FROM users WHERE user_id=?";
    PreparedStatement query = connect.prepareStatement(sql);
    query.setString(1, id);

    ResultSet result = query.executeQuery();
    Boolean duplicated = false;

    if(result.next()){
        duplicated= true;
    }

%>

<head>
    <link rel="stylesheet" type="text/css" href="../../css/font/font.css">
    <link rel="stylesheet" type="text/css" href="../../css/join/id_duplicate_check_popup.css">
</head>
<body>
    <form action="id_duplicate_check_popup.jsp">
        <div>
            <input id="input_id_space" type="text" name="user_id">
        </div>
        <div>
            <input class="popup_button" id="id_duplication_button" type="submit" value="중복 확인">
        </div>
        <div>
            <p id="duplicate_check_result"></p>
        </div>
        <div>
            <input class="popup_button" id="use_this_id_button" type="button" value="사용하기" onclick="use_this_id()">
        </div>
    </form>

    <script>

        function can_use_this_id(){
            var duplicated = <%=duplicated%>;
            if(duplicated==true){
                document.getElementById("duplicate_check_result").innerHTML = "사용 중인 아이디입니다.";
                document.getElementById("use_this_id_button").style.visibility = "hidden";
            }else{
                document.getElementById("duplicate_check_result").innerHTML = "사용 가능한 아이디입니다.";
                document.getElementById("use_this_id_button").style.visibility = "visible";
            }
            console.log(<%=duplicated%>)
        }

        function use_this_id(){
            opener.document.join_form.check_duplication.value= "Check";
            opener.document.join_form.input_id.value= "<%=id%>";
            opener.document.join_form.input_id.setAttribute("disabled", true);
            self.close();
        }

        window.onload = function(){
            var input_id = "<%=id%>";
            console.log(input_id);
            document.getElementById("input_id_space").value = input_id;

            can_use_this_id ();
        }
    </script>
</body>
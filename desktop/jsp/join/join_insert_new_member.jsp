<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.sql.DriverManager" %> 
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %> 
<%@ page import="java.io.*" %>
<%@ page import="java.sql.ResultSet" %> 

<%

    Boolean join_success = true;
    String s= "";

    String input_id = (String) request.getParameter("input_id");
    int a = input_id.length();
    if(input_id=="" || input_id==null || input_id.length()>21){
        join_success = false;
    }

    String pw = (String) request.getParameter("input_pw");
    if(pw=="" || pw==null || pw.length()>21){
        s = "2";
        join_success = false;
    }

    String name= (String) request.getParameter("input_name");
    if(name=="" || name==null || name.length()>21){
        s = "3";
        join_success = false;
    }

    String department = (String) request.getParameter("input_department");
    if(department=="" || department==null || department.length()>3){
        s = "4";
        join_success= false;
    }
    String position = (String) request.getParameter("input_position");
    if(position=="" || position==null || position.length()>3){
        s = "5";
        join_success = false;
    }

    if(join_success){
        Class.forName("com.mysql.jdbc.Driver");
        Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/calender","Stageus","8366");
        
        String sql = "INSERT INTO users(user_id, password, name, department,position) VALUES (?,?,?,?,?)";
        PreparedStatement query = connect.prepareStatement(sql);
        query.setString(1, input_id);
        query.setString(2, pw);
        query.setString(3, name);
        query.setString(4, department);
        query.setString(5, position);
    
        query.executeUpdate();
    }

%>


<body>
    <script>
        window.onload = function(){

            if(<%=join_success%>){
                alert("환영합니다.");
                location.href="../login/login_page.jsp";
            }else{
                alert("가입 내용 오류");
                alert("<%=a%>");
                location.href="./join_page.jsp";
            }
        }
    </script>
</body>
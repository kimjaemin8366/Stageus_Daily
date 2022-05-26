<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.sql.DriverManager" %> 
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %> 
<%@ page import="java.sql.ResultSet" %> 
<%@ page import="java.util.Vector" %>

<%
    String id = (String) session.getAttribute("logged_id");
    Boolean logged = false;

    if(id==""){
        response.sendRedirect("../login/login_page.jsp");
    }

    String user_id = request.getParameter("user_id");
    
    Class.forName("com.mysql.jdbc.Driver");
    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/calender","Stageus","8366");
    
    // 사용자 정보
    String user_sql = "SELECT user_id, name, department, position FROM users WHERE user_id = ?";
    PreparedStatement user_query = connect.prepareStatement(user_sql);
    user_query.setString(1, user_id);

    ResultSet user_result = user_query.executeQuery();

    Vector<String> user_data = new Vector<String>();
    
    while(user_result.next()){
        for(int idx=1; idx<=4; idx++){
            user_data.add(user_result.getString(idx));
        }
    }

    // 사용자 일정 정보

    String year = request.getParameter("year");
    String month = request.getParameter("month");
    String compare_start_date = year + "-" + month + "-01";
    String compare_last_date = year + "-" + month + "-31"; 

    String schedule_sql = "SELECT schedule_content, schedule_datetime, user_id FROM schedule WHERE schedule_datetime >= ? AND schedule_datetime <= ? AND user_id=? ORDER BY schedule_datetime";
    PreparedStatement schedule_query = connect.prepareStatement(schedule_sql);
    schedule_query.setString(1, compare_start_date);
    schedule_query.setString(2, compare_last_date);
    schedule_query.setString(3, user_id);

    ResultSet schedule_result = schedule_query.executeQuery();

    Vector<String> schedule_data = new Vector<String>();
    int schedule_count = 0;
    while(schedule_result.next()){
        for(int idx=1; idx<=3; idx++){
            schedule_data.add(schedule_result.getString(idx));
            
        }
        schedule_count++;
    }
%>
<head>
    <link rel="stylesheet" type="text/css" href="../../css/font/font.css">
    <link rel="stylesheet" type="text/css" href="../../css/calender/calender_page.css">
    <title>일정</title>
</head>
<body>
    <header>
        <div id="member_menu_space">
            <button id="member_menu_button" type="button">
                <img src="../../../source/member_menu.png">
            </button>
        </div>
        <p id="name"></p>
        <div id="year_space">
            <button class="date_button" id="year_back" type="button" onclick="move_date(this.id)">
                <img class="date_button_img" id="year_back_button_img" src="../../../source/left.png">
            </button>
            <p id="year"></p>
            <button class="date_button" id="year_forward" type="button" onclick="move_date(this.id)">
                <img class="date_button_img" id="year_forward_button_img" src="../../../source/right.png">
            </button>
        </div>
        <div id="month_space">
            <button class="date_button" id="month_back" type="button" onclick="move_date(this.id)">
                <img class="date_button_img" id="month_back_button_img" src="../../../source/left.png">
            </button>
            <p id="month"></p>
            <button class="date_button" id="month_forward" type="button" onclick="move_date(this.id)">
                <img class="date_button_img" id="month_forward_button_img" src="../../../source/right.png">
            </button>
        </div>
        <div id="logout_space">
            <button id="logout_button" type="button" onclick="location.href='logout.jsp'">
                <p id="logout_button_p">로그아웃</p>
            </button>
        </div>
    </header>
    <section>
        <form id="new_schedule_input_form" action="input_schedule.jsp" onsubmit="before_new_schedule_input()">
            <input type="hidden" id="now_screen_year" name="now_screen_year">
            <input type="hidden" id="now_screen_month" name="now_screen_month">
            <div id="input_datetime_and_add_button_space">
                <div id="input_datetime_space">
                    <input id="input_date" type="date" name="new_schedule_date">
                    <input id="input_time" type="time" name="new_schedule_time">
                </div>
                <div id="input_add_button_space">
                    <input id="add_button" type="submit" value="일정 추가">
                </div>
            </div>
            <div id="input_content_space">
                <input id="input_content" name="new_schedule_content" type="text" placeholder="내용을 입력해주세요">
            </div>
        </form>
    </section>

    <article>
        <!-- <form id="8" class="schedule_form" action="modify_schedule.jsp">
            <div>
                <p class="schedule_day">8일</p>
            </div>
            <div>
                <input class="schedule_content_text" type="text" value="놀기" readonly>
                <input class="before_modified_content" type="hidden">
            </div>
            <div class="schedule_time_and_buttons">
                <p class="schedule_time">오전 10:30</p>
                <input class="modify_date_input" type="date" name="modified_schedule_date">
                <input class="modify_time_input" type="time" name="modified_schedule_time">
                <input class="before_modified_date" type="hidden">
                <input class="before_modified_time" type="hidden">
                <input class="schedule_button" type="button" value="일정 수정">
                <input class="schedule_button" type="button" value="일정 삭제">
                <input class="schedule_button_hidden" type="submit" value="수정 확인">
                <input class="schedule_button_hidden" type="button" value="수정 취소">
            </div>

        </form> -->
    </article>
    <script>

        function move_date(id){
            if(id=="year_back"){
                location.href="./calender_page.jsp?user_id=<%=user_id%>&year=" + (parseInt("<%=year%>")-1) + "&month=<%=month%>";
            }
            else if(id=="year_forward"){
                location.href="./calender_page.jsp?user_id=<%=user_id%>&year=" + (parseInt("<%=year%>")+1) + "&month=<%=month%>";
            }
            else if(id=="month_back"){
                if("<%=month%>" != "1"){
                    location.href="./calender_page.jsp?user_id=<%=user_id%>&year=<%=year%>&month=" + (parseInt("<%=month%>")-1); 
                }else{
                    location.href="./calender_page.jsp?user_id=<%=user_id%>&year=<%=year%>&month=12";
                }
            }
            else{
                if("<%=month%>" != "12"){
                    location.href="./calender_page.jsp?user_id=<%=user_id%>&year=<%=year%>&month=" + (parseInt("<%=month%>")+1); 
                }else{
                    location.href="./calender_page.jsp?user_id=<%=user_id%>&year=<%=year%>&month=1";
                }
            }
        }

        function before_new_schedule_input(){
            var date = document.getElementById("input_date").value;
            var time = document.getElementById("input_time").value;
            var content = document.getElementById("input_content").value;
            var error_message = ["날짜를 선택해주세요.", "시간을 선택해주세요.", "일정 내용을 입력해주세요."];

            if(date==""){
                alert(error_message[0]);
                event.preventDefault();
                return;
            }else if(time==""){
                alert(error_message[1]);
                event.preventDefault();
                return;
            }else if(content==""){
                alert(error_message[2]);
                event.preventDefault();
                return;
            }

        }

        function make_screen(){
            var user_string = "<%=user_data%>";
            var schedule_string = "<%=schedule_data%>";
            var user_data = user_string.substring(1, user_string.length-1).split(", ");
            var schedule_data = schedule_string.substring(1, schedule_string.length-1).split(", ");

            document.getElementById("now_screen_year").value = "<%=year%>";   
            document.getElementById("now_screen_month").value = "<%=month%>";   
            document.getElementById("year").innerHTML = "<%=year%>";
            document.getElementById("month").innerHTML = "<%=month%>"+"월";
            document.getElementById("name").innerHTML = user_data[1];

            if(user_data[3]=="부장" || user_data[3] =="관리자"){
                document.getElementById("member_menu_button").style.visibility = "visible";
            }

            show_schedule_list(user_data, schedule_data);

            console.log(user_data);
            console.log("<%=schedule_data%>");
        }

        function show_schedule_list(user_data, schedule_data){
            var schedule_count = <%=schedule_count%>;
            var list = document.getElementsByTagName("article")[0];
            var last_written_day = "";

            for(var idx=0; idx<schedule_count; idx++){
                var datetime = schedule_data[idx*3+1].split(" ");
                var day = datetime[0].split("-")[2];
                var time = datetime[1].split(":");
                var hour = parseInt(time[0]);
                var minute = time[1];

                var schedule_time = "";
                if(hour<=12){
                    schedule_time = "오전 "+hour+":"+minute;
                }else{
                    schedule_time = "오후 "+(hour-12)+":"+minute;
                }

                if(last_written_day!=day){
                    var new_form = document.createElement("form");
                    new_form.className="schedule_form";
                    new_form.id = day;
                    new_form.setAttribute("action", "modify_schedule.jsp");

                    var new_day_div = document.createElement("div");
                    var new_day_p =document.createElement("p");
                    new_day_p.className="schedule_day";
                    new_day_p.innerHTML = day + "일";
                    new_day_div.appendChild(new_day_p);
                    last_written_day = day;

                    new_form.append(new_day_div, make_content_div(schedule_data[idx*3]), make_bottom_div(schedule_time, datetime[0],datetime[1]));
                    list.appendChild(new_form);
                }
                else{
                    var day_form = document.getElementById(""+day);
                    day_form.append(make_content_div(schedule_data[idx*3]), make_bottom_div(schedule_time, datetime[0],datetime[1]));
                }
            }
        }

        function make_content_div(content){
            
            var new_content_div = document.createElement("div");
            var new_content_input = document.createElement("input");
            new_content_input.type = "text";
            new_content_input.className = "schedule_content_text";
            new_content_input.value = content;
            var new_content_before_modified = document.createElement("input");
            new_content_before_modified.type ="hidden";
            new_content_before_modified.className="before_modified_content";
            new_content_before_modified.value = content;

            new_content_div.append(new_content_input, new_content_before_modified);
            return new_content_div;
        }

        function make_bottom_div(schedule_time, date,time){

            var new_bottom_div = document.createElement("div");
            new_bottom_div.className = "schedule_time_and_buttons";
            
            var new_time_p = document.createElement("p");
            new_time_p.className= "schedule_time";
            new_time_p.innerHTML = schedule_time;
            var new_modify_date_input = document.createElement("input");
            new_modify_date_input.className="modify_date_input";
            new_modify_date_input.type = "date";
            new_modify_date_input.name = "modified_schedule_date";
            var new_modify_time_input = document.createElement("input");
            new_modify_time_input.className="modify_time_input";
            new_modify_time_input.type = "date";
            new_modify_time_input.name = "modified_schedule_time";
            var date_before_modified = document.createElement("input");
            date_before_modified.className="before_modified_date";
            date_before_modified.type = "hidden";
            date_before_modified.value = date;
            var time_before_modified = document.createElement("input");
            time_before_modified.className="before_modified_time";
            time_before_modified.type = "hidden";
            time_before_modified.value = time;
            var modify_button = document.createElement("input");
            modify_button.className="schedule_button";
            modify_button.type = "button";
            modify_button.value = "일정 수정";
            var delete_button = document.createElement("input");
            delete_button.className="schedule_button";
            delete_button.type = "button";
            delete_button.value = "일정 삭제";
            var modify_done_button = document.createElement("input");
            modify_done_button.className="schedule_button_hidden";
            modify_done_button.type = "submit";
            modify_done_button.value = "수정 확인";
            var modify_cancel_button = document.createElement("input");
            modify_cancel_button.className="schedule_button_hidden";
            modify_cancel_button.type = "button";
            modify_cancel_button.value = "수정 취소";
            
            new_bottom_div.append(new_time_p, new_modify_date_input, new_modify_time_input, date_before_modified, time_before_modified, modify_button, delete_button, modify_done_button, modify_cancel_button);
            return new_bottom_div;
        }
        window.onload=function(){
            make_screen();
        }
    </script>
</body>

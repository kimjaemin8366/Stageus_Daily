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
    String user_id = (String) request.getParameter("user_id");
    
    Boolean if_owner = user_id.equals(logged_id);       

    if(logged_id=="" || logged_id==null){
        response.sendRedirect("../login/login_page.jsp");
    }else if(!if_owner && logged_position.equals("사원") ){
        response.sendRedirect("./no_auth_alert_page.jsp");
    }
        
    // 타인 일정 페이지 접속 권한
    
    Class.forName("com.mysql.jdbc.Driver");
    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/calender","Stageus","8366");

    // 사용자 정보
    String user_sql = "SELECT user_id, name FROM users WHERE user_id = ?";
    PreparedStatement user_query = connect.prepareStatement(user_sql);
    user_query.setString(1, user_id);

    ResultSet user_result = user_query.executeQuery();

    Vector<String> user_data = new Vector<String>();
    
    while(user_result.next()){
        for(int idx=1; idx<=2; idx++){
            user_data.add(user_result.getString(idx));
        }
    }


    // 메뉴 목록을 위한 사용자 목록

    String user_list_sql = "SELECT user_id, name FROM users ORDER BY name";
    PreparedStatement user_list_query = connect.prepareStatement(user_list_sql);
    
    ResultSet user_list_result = user_list_query.executeQuery();
    Vector<String> user_list_data = new Vector<String>();
    int user_count = 0;
    while(user_list_result.next()){
        for(int idx=1; idx<=2; idx++){
            user_list_data.add(user_list_result.getString(idx));
        }
        user_count += 1;
    }


    // 사용자 일정 정보

    String year = request.getParameter("year");
    String month = request.getParameter("month");
    String compare_start_date = year + "-" + month + "-01";
    String compare_last_date = year + "-" + month + "-31"; 

    String schedule_sql = "SELECT * FROM schedule WHERE schedule_datetime >= ? AND schedule_datetime <= ? AND user_id=? ORDER BY schedule_datetime";
    PreparedStatement schedule_query = connect.prepareStatement(schedule_sql);
    schedule_query.setString(1, compare_start_date);
    schedule_query.setString(2, compare_last_date);
    schedule_query.setString(3, user_id);

    ResultSet schedule_result = schedule_query.executeQuery();

    Vector<String> schedule_data = new Vector<String>();
    int schedule_count = 0;
    while(schedule_result.next()){
        for(int idx=1; idx<=4; idx++){
            schedule_data.add(schedule_result.getString(idx));
            
        }
        schedule_count++;
    }

%>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width", initial-scale=1>
    <link rel="stylesheet" type="text/css" href="../../css/font/font.css">
    <link rel="stylesheet" type="text/css" href="../../css/calender/calender_page.css">
    <title>일정</title>
</head>
<body>
    <header>
        <div id="member_menu_space">
            <button id="member_menu_button" type="button" onclick="open_menu()">
                <img src="../../../source/member_menu.png" id="menu_img">
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
    <nav>
        <div id="nav_member_list">
            <div id="nav_member_menu_space">
                <button id="nav_member_menu_button" type="button" onclick="close_menu()">
                    <img src="../../../source/member_menu.png" id="menu_img">
                </button>
            </div>
            <!-- <p id="이름" onclick="location.href=''">
                
            </p> -->
        </div>
        <div id="nav_background" onclick="close_menu()">

        </div>
    </nav>
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
        <!-- <form id="8" class="schedule_form" action="modify_schedule.jsp" onsubmit="before_modify_schedule_input()">
            <div>
                <p class="schedule_day">8일</p>
            </div>
            <div>
                <input class="schedule_content_text" type="text" value="놀기" disabled>
                <input class="schedule_content_id" type="hidden" name="content_id">
                <input class="before_modified_content" type="hidden">
            </div>
            <div class="schedule_time_and_buttons">
                <p class="schedule_time">오후 1:30</p>
                <input class="modify_date_input" type="date" name="modified_schedule_date"> 
                <input class="modify_time_input" type="time" name="modified_schedule_time">
                <input class="before_modified_date" type="hidden">
                <input class="before_modified_time" type="hidden">
                <input class="schedule_button" type="button" value="일정 수정" onclick="modify_ready()">
                <input class="schedule_button" type="submit" value="일정 삭제">
                <input class="schedule_button_hidden" type="submit" value="수정 확인">
                <input class="schedule_button_hidden" type="button" value="수정 취소">
            </div>

        </form> -->
    </article>
    <script>

        // 연도, 월 이동
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

        // 일정 추가 검사
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

        // 전체 화면 틀

        function make_screen(){
            var user_string = "<%=user_data%>";
            var schedule_string = "<%=schedule_data%>";
            var user_data = user_string.substring(1, user_string.length-1).split(", ");
            var schedule_data = schedule_string.substring(1, schedule_string.length-1).split(", ");
            var logged_position = "<%=logged_position%>";

            // 헤더 내용
            document.getElementById("now_screen_year").value = "<%=year%>";   
            document.getElementById("now_screen_month").value = "<%=month%>";
            document.getElementById("year").innerHTML = "<%=year%>";
            document.getElementById("month").innerHTML = "<%=month%>"+"월";
            document.getElementById("name").innerHTML = user_data[1];

            console.log(logged_position);

            //회원 메뉴 보여주기 여부
            if(logged_position=="부장" || logged_position =="관리자"){
                document.getElementById("member_menu_space").style.display= "flex";
            }else{
                document.getElementById("member_menu_space").style.display= "none";
            }

            show_schedule_list(user_data, schedule_data);
        }

        // 일자별 설계

        function show_schedule_list(user_data, schedule_data){
            var schedule_count = <%=schedule_count%>;
            var list = document.getElementsByTagName("article")[0];
            var now_time = get_now_time();
            var last_written_day = "";

            for(var idx=0; idx<schedule_count; idx++){
                var datetime = schedule_data[idx*4+2].split(" ");

                var date = datetime[0].split("-");
                var year = date[0];
                var month = parseInt(date[1]);
                var day = date[2];

                var time = datetime[1].split(":");
                var hour = parseInt(time[0]);
                var minute = time[1];

                var schedule_time = "";
                if(hour>12){
                    schedule_time = "오후 "+(hour-12)+":"+minute;
                }else if(hour>0){
                    schedule_time = "오전 "+hour+":"+minute;
                }else{
                    schedule_time = "오전 "+12+":"+minute;
                }


                if(last_written_day!=day){
                    var new_schedule_div = document.createElement("div");
                    new_schedule_div.className="schedule";
                    new_schedule_div.id = day;

                    var new_form = document.createElement("form");
                    new_form.className="schedule_form";
                    new_form.setAttribute("action", "delete_schedule.jsp");

                    var new_day_div = document.createElement("div");
                    var new_day_p =document.createElement("p");
                    new_day_p.className="schedule_day";
                    new_day_p.innerHTML = day + "일";
                    new_day_div.appendChild(new_day_p);
                    last_written_day = day;

                    new_form.append( make_content_div(idx, schedule_data[idx*4], schedule_data[idx*4+1], schedule_data[idx*4+2], now_time), make_bottom_div(idx, schedule_time, datetime[0],datetime[1]));
                    new_schedule_div.append(new_day_div, new_form)
                    list.appendChild(new_schedule_div);
                }  // 새 일자
                else{
                    var day_div = document.getElementById(""+day);
                    var new_form = document.createElement("form");
                    new_form.className="schedule_form";
                    new_form.setAttribute("action", "delete_schedule.jsp");
                    new_form.append(make_content_div(idx, schedule_data[idx*4], schedule_data[idx*4+1], schedule_data[idx*4+2], now_time), make_bottom_div(idx, schedule_time, datetime[0],datetime[1]))
                    day_div.append(new_form);
                } // 하나 일자 여러 일정
            }
        }

        
        // 메뉴 목록 
        function make_members_menu(){
            var members_string = "<%=user_list_data%>";
            var members_list = members_string.substring(1, members_string.length-1).split(", ");
            var member_count = <%=user_count%>;
            var list_div = document.getElementById("nav_member_list");

            for(var idx=0; idx<member_count; idx++){
                var new_member_link = document.createElement("p");
                member_name = members_list[idx*2+1];
                member_id = members_list[idx*2];
                new_member_link.innerHTML = member_name;
                new_member_link.className = "member_link";
                list_div.appendChild(new_member_link);

                move_to_member_schedule(member_id, idx);
            }
        }

        function move_to_member_schedule(member_id, idx){
            var member_link = document.getElementsByClassName("member_link")[idx];
            member_link.addEventListener("click", function(){
                location.href="./calender_page.jsp?user_id="+ member_id + "&year=<%=year%>&month=<%=month%>";       
            })
        }
        

        function open_menu(){
            document.getElementsByTagName("nav")[0].style.visibility = "visible";
        }

        function close_menu(){
            document.getElementsByTagName("nav")[0].style.visibility = "hidden";
        }


        // 내용 div


        //현재 시간 가져오기
        function get_now_time(){
            var date = new Date();
            var year = date.getFullYear();
            var month = ('0'+(date.getMonth()+1)).slice(-2);
            var day = ('0'+date.getDate()).slice(-2);
            var hour = ('0'+date.getHours()).slice(-2);
            var minute = ('0'+date.getMinutes()).slice(-2);
            var now = year + "-" + month + "-" + day + " " + hour + ":" + minute + ":00";
            return now;
        }


        //취소선 함수
        function check_strikethrough(text_space, now_time, schedule_time){
            if(now_time > schedule_time){
                text_space.style.textDecorationLine = "line-through";
            }
        }

        // 각 일자별 내용
        function make_content_div(idx, content_id, content, schedule_time, now_time){

            var new_content_div = document.createElement("div");
            var new_content_input = document.createElement("input");
            new_content_input.type = "text";
            new_content_input.className = "schedule_content_text";
            new_content_input.name = "schedule_content";
            new_content_input.setAttribute("disabled", true);
            new_content_input.value = content;
            check_strikethrough(new_content_input, now_time, schedule_time);
            
            var new_content_before_modified = document.createElement("input");
            new_content_before_modified.type ="hidden";
            new_content_before_modified.className="before_modified_content";
            new_content_before_modified.value = content;
            var new_content_id = document.createElement("input");
            new_content_id.type ="hidden";
            new_content_id.name = "schedule_id";
            new_content_id.value = content_id;

            var now_screen_year = document.createElement("input");
            now_screen_year.type = "hidden";
            now_screen_year.name = "now_screen_year";
            now_screen_year.value = <%=year%>;
            var now_screen_month = document.createElement("input");
            now_screen_month.type = "hidden";
            now_screen_month.name = "now_screen_month";
            now_screen_month.value = <%=month%>;
            new_content_div.append(now_screen_year, now_screen_month, new_content_input, new_content_before_modified, new_content_id);
            return new_content_div;
        }

        // 시간 + 버튼 div
        function make_bottom_div(idx, schedule_time, date, time){

            var new_bottom_div = document.createElement("div");
            new_bottom_div.className = "schedule_time_and_buttons";

            // 시간 div
            var new_time_p = document.createElement("p");
            new_time_p.className= "schedule_time";
            new_time_p.innerHTML = schedule_time;

            if(<%=if_owner%>){

                // 수정 input form
                var new_modify_date_input = document.createElement("input");
                new_modify_date_input.className="modify_date_input";
                new_modify_date_input.type = "date";
                new_modify_date_input.name = "modified_schedule_date";
                var new_modify_time_input = document.createElement("input");
                new_modify_time_input.className="modify_time_input";
                new_modify_time_input.type = "time";
                new_modify_time_input.name = "modified_schedule_time";

                // 수정 전 날짜와 시간
                var date_before_modified = document.createElement("input");
                date_before_modified.className="before_modified_date";
                date_before_modified.type = "hidden";
                date_before_modified.value = date;
                var time_before_modified = document.createElement("input");
                time_before_modified.className="before_modified_time";
                time_before_modified.type = "hidden";
                time_before_modified.value = time;

                // 수정, 삭제 관련 버튼
                var modify_button = document.createElement("input");
                modify_button.className="modify_schedule_button";
                modify_button.id = "modify_ready_button";
                modify_button.type = "button";
                modify_button.value = "일정 수정";
                modify_button.addEventListener("click", function(){
                    modify_ready_event(idx);
                })

                var delete_button = document.createElement("input");
                delete_button.className="delete_schedule_button";
                delete_button.type = "submit";
                delete_button.value = "일정 삭제";

                var modify_done_button = document.createElement("input");
                modify_done_button.className="confirm_modify_button";
                modify_done_button.type = "submit";
                modify_done_button.value = "수정 확인";
                var modify_cancel_button = document.createElement("input");
                modify_cancel_button.className="modify_cancel_button";
                modify_cancel_button.type = "button";
                modify_cancel_button.value = "수정 취소";
                modify_cancel_button.addEventListener("click", function(){
                    modify_cancel_event(idx, date + " " + time);
                })
                new_bottom_div.append(new_time_p, new_modify_date_input, new_modify_time_input, date_before_modified, time_before_modified, modify_button, delete_button, modify_done_button, modify_cancel_button);
            }
            else{
                new_bottom_div.append(new_time_p);
            }
            return new_bottom_div;
        }

        function modify_ready_event(idx){
            var date = document.getElementsByClassName("before_modified_date")[idx].value;
            var time = document.getElementsByClassName("before_modified_time")[idx].value;

            // 수정 버튼,삭제 버튼 사라지기 처리
            document.getElementsByClassName("modify_schedule_button")[idx].style.display = "none";
            document.getElementsByClassName("delete_schedule_button")[idx].style.display = "none";
            document.getElementsByClassName("schedule_time")[idx].style.display = "none";

            // 수정 확인, 수정 취소 버튼 등장 처리
            document.getElementsByClassName("confirm_modify_button")[idx].style.display = "inline";
            document.getElementsByClassName("modify_cancel_button")[idx].style.display = "inline";

            // 날짜,시간 수정란 
            document.getElementsByClassName("modify_date_input")[idx].style.display = "inline";
            document.getElementsByClassName("modify_date_input")[idx].value = date;
            document.getElementsByClassName("modify_time_input")[idx].style.display = "inline";
            document.getElementsByClassName("modify_time_input")[idx].value = time;

            // 취소선 제거 처리, 수정칸 수정 가능하게
            document.getElementsByClassName("schedule_content_text")[idx].style.textDecorationLine = "none";
            document.getElementsByClassName("schedule_content_text")[idx].removeAttribute("disabled");

            document.getElementsByClassName("schedule_form")[idx].setAttribute("action", "modify_schedule.jsp");
        }

        function modify_cancel_event(idx, schedule_time){
            var content = document.getElementsByClassName("before_modified_content")[idx].value;
            var date = document.getElementsByClassName("before_modified_date")[idx].value;
            var time = document.getElementsByClassName("before_modified_time")[idx].value.split(":");
            var hour = time[0]
            var minute = time[1];

            // 수정 버튼 등장 처리

            document.getElementsByClassName("modify_schedule_button")[idx].style.display = "inline";
            document.getElementsByClassName("delete_schedule_button")[idx].style.display = "inline";
            document.getElementsByClassName("schedule_time")[idx].style.display = "block";
            
            // 시간 원래 내용 출력
            if(hour<=12){
                document.getElementsByClassName("schedule_time")[idx].innerHTML = "오전 " + hour + ":" + minute;
            }else{
                document.getElementsByClassName("schedule_time")[idx].innerHTML = "오후 " + hour + ":" + minute;
            }


            // 버튼 사라지기 처리
            document.getElementsByClassName("confirm_modify_button")[idx].style.display = "none";
            document.getElementsByClassName("modify_cancel_button")[idx].style.display = "none";
            document.getElementsByClassName("modify_date_input")[idx].style.display = "none";
            document.getElementsByClassName("modify_time_input")[idx].style.display = "none";

            // 내용란 원 상태로 돌리기
            text_space = document.getElementsByClassName("schedule_content_text")[idx];
            text_space.value = content;
            text_space.setAttribute("disabled", true);

            // 취소선 처리
            check_strikethrough(text_space, get_now_time(), schedule_time);

            document.getElementsByClassName("schedule_form")[idx].setAttribute("action", "delete_schedule.jsp");
        }

        //일정 추가

        function if_another_user_schedule(){
            if(!(<%=if_owner%>)){
                document.getElementsByTagName("section")[0].style.display = "none";
                document.getElementsByTagName("header")[0].style.marginBottom = "50px";
            }
        }

        window.onload=function(){
            make_screen();
            make_members_menu();
            if_another_user_schedule();
        }
    </script>
</body>

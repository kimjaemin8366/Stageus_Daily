<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <link rel="stylesheet" type="text/css" href="../../css/font/font.css">
    <link rel="stylesheet" type="text/css" href="../../css/join/join_page.css">
    <title>회원 가입</title>
</head>
<body>
    <main>
        <form id="join_form" name="join_form" action="join_insert_new_member.jsp" onsubmit="before_join_input()">
            <div>
                <input id="join_input_id" class="join_input" name="input_id" type="text" placeholder="아이디" maxlength="20">
                <div id="duplicate_check_button_space">
                    <input id="duplicate_check_button" type="button" value="중복확인" onclick="id_duplicate_check()">
                    <input type="hidden" id="duplicate_checked" name="check_duplication" value="NoCheck">
                </div>
            </div>
            <div id="pw_space">
                <input id="pw_input" class="join_input" type="password" name="input_pw" placeholder="비밀번호" maxlength="20">
                <div>
                    <input id="pw_confirm_input" class="join_input" type="password" placeholder="비밀번호 확인" maxlength="20" oninput="password_same_check()">
                </div>
                <p id="password_same_check_p"></p>
            </div>
            <div>
                <input id="name_input" class="join_input" type="text" name="input_name" placeholder="이름" maxlength="20">
            </div>
            <div>
                <select class="join_input" name="input_department">
                    <option value="" disabled selected>부서</option>
                    <option value="운용">운용</option>
                    <option value="개발">개발</option>
                    <option value="재무">재무</option>
                    <option value="교육">교육</option>
                </select>
            </div>
            <div>
                <select class="join_input", name="input_position">
                    <option value="" disabled selected>직책</option>
                    <option value="사원">사원</option>
                    <option value="부장">부장</option>
                    <option value="관리자">관리자</option>
                </select>
            </div>
            <div>
                <input class="join_button" type="submit" value="가입">
            </div>
        </form>
    </main>

    <script>

        function password_same_check(){
            var pw = document.getElementById("pw_input").value;
            var pw_confirm = document.getElementById("pw_confirm_input").value;
            var result = document.getElementById("password_same_check_p");
            if(pw!=pw_confirm){
                result.innerHTML = "비밀번호가 일치하지 않습니다.";
            }else{
                result.innerHTML = "비밀번호가 일치합니다.";
            }
        }

        function before_join_input(){
            var inputs = document.getElementsByClassName("join_input");
            var error_message = ["아이디를 입력해주세요.", "비밀번호를 입력해주세요.", "비밀번호 확인을 입력해주세요", "이름을 입력해주세요", "부서를 선택해주세요", "직책을 선택해주세요"];
            var pw = document.getElementById("pw_input").value;
            var pw_confirm = document.getElementById("pw_confirm_input").value;
            var duplicate_checked = document.getElementById("duplicate_checked").value;

            for(var idx=0; idx<6; idx++){
                if(inputs[idx].value == ""){
                    alert(error_message[idx]);
                    event.preventDefault();
                    return;
                }
            }

            if(pw!=pw_confirm){
                alert("비밀번호가 일치하지 않습니다.");
                event.preventDefault();
                return;
            }

            if(duplicate_checked=="NoCheck"){
                alert("아이디 중복확인을 해주세요.");
                event.preventDefault();
                return;
            }
        }

        function id_duplicate_check(){
            
            var input_id = document.getElementById("join_input_id").value;
            if(input_id == ""){
                alert("아이디를 입력해주세요.");
            }else{
                window.open("id_duplicate_check_popup.jsp?user_id="+ input_id, "아이디 중복 확인", "width= 450px, height= 450px, resize=off");
            }
        }

    </script>
</body>

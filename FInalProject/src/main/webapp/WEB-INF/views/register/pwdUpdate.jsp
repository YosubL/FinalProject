<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
    String ctxPath = request.getContextPath();
%>

<style type="text/css">

div.div_f {
	margin: 2% auto 0;
	width: 80%;
	font-size: 10pt;
}

div.div1 {
	margin: 4% auto 0;
	width: 80%;
}

div.div2{
	border: solid 2px black;
	width: 90%;
	padding: 5px;
}

div.div2_display {
	display: inline-block;
}

input{
	border: none; 
	width: 80%; 
	padding: 5px 5px 5px 15px;
}

input.requiredInfo::placeholder{
	font-size: 9pt;
}

span {
	font-weight: bold;
	font-size: 10pt;
}

span.title {
	margin-bottom: 0.5%;
}

span.s_display {
	display: inline-block;
}

span.icon {
	font-size: 10px;
	margin-left: 1%;
}

i.fa-eye,
i.fa-eye-slash {
	display: none;
	font-size: 10pt;
}

span.clear {
	display:none;
	font-size: 10px;
	margin-left: 5%;
}

span.error {
	display: block;
	color: red;
	margin-bottom: 2%;
}

.div2_error {
	border: solid 2px red !important;
	box-shadow: 0 0 1px red;
}

input:focus{
  outline: none;
}

button {
    background-color: #4CAF50; /* 초록 계열 배경색 */
    color: #FFFFFF; /* 흰색 텍스트 */
    padding: 5px 10px; /* 내부 여백 설정 */
    width: 93%;
    border: none; /* 테두리 없음 */
    border-radius: 5px; /* 둥근 모서리 설정 */
    cursor: pointer; /* 포인터 커서로 변경 */
    height: 50px;
}

/* 버튼 호버 효과 추가 (선택 사항) */
button:hover {
	background-color: #45a049; /* 호버 시 배경색 변경 */
}

</style>

<%-- Font Awesome 6 Icons --%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">


<script type="text/javascript" src="<%= ctxPath%>/resources/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="<%= ctxPath%>/resources/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" ></script> 
<script type="text/javascript" src="<%= ctxPath%>/resources/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script>

<script type="text/javascript">

$(document).ready(function(){
	
	
	$("span.error").hide();
	
	// 비밀번호에 값이 들어가면 클리어버튼 비밀번호 확인 버튼 show
	$("input:password").on("input", function(e) {
		if($("input:password").val().trim() != "") {
			$(e.target).closest(".div2").find("span.clear").show();
			$(e.target).closest(".div1").find("i.fa-eye").show();
		}
	});
	
	
	// clear 버튼 누르면 값 지우기
	$("span.clear").on("click", function(e) {
		$(e.target).closest(".div2").find("input").val("");
	});
	
	
	// 현재 비밀번호 유효성검사
	$("input:password[id='current_pwd']").on("focusout", function(e) {
		
		$.ajax({
			url:"<%= ctxPath%>/pwdSha256.gw",
			data:{"current_pwd":$("input:password[id='current_pwd']").val()},
			dataType:"json",
			success:function(json){
				console.log(JSON.stringify(json));
				
				const login_pwd = $("input:hidden[id='login_pwd']").val();
				
				const currnet_pwd = json[0].current_pwd;
				
				 if(currnet_pwd != login_pwd) {
					$(e.target).closest(".div1").find("span.error").show();
					$(e.target).closest(".div2").addClass("div2_error");
					$("input:hidden[id='c_pwd']").val(0);
				}
				else {
					$(e.target).closest(".div1").find("span.error").hide();
					$(e.target).closest(".div2").removeClass("div2_error");
					$("input:hidden[id='c_pwd']").val(1);
				} 
				
			},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		});
		
	});
	
	
	
	// 비밀번호 유효성검사
	$("input:password[name='pwd']").on("focusout", function(e) {
			
		const regExp_pwd = new RegExp(/^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).*$/g); 
		   
		const bool = regExp_pwd.test($(e.target).val());	
		
		if(!bool) {
			// 암호가 정규표현식에 위배된 경우 
			$(e.target).closest(".div1").find("span.error").show();
			$(e.target).closest(".div2").addClass("div2_error");
			$("input:hidden[id='pwd']").val(0);
		}
		else {
			// 암호가 정규표현식에 맞는 경우 
			$(e.target).closest(".div1").find("span.error").hide();
			$(e.target).closest(".div2").removeClass("div2_error");
			$("input:hidden[id='pwd']").val(1);
		}
				
	});
		
	
	// 비밀번호 확인 유효성검사	
	$("input:password[id='pwdcheck']").on("focusout", function(e) {	
				
		if( $("input:password[name='pwd']").val() != $(e.target).val() ) {
			// 암호와 암호확인값이 틀린 경우 
			$(e.target).closest(".div1").find("span.error").show();
			$(e.target).closest(".div2").addClass("div2_error");
			$("input:hidden[id='pwdcheck_v']").val(0);
		}
		else {
			// 암호와 암호확인값이 같은 경우
			$(e.target).closest(".div1").find("span.error").hide();
			$(e.target).closest(".div2").removeClass("div2_error");
			$("input:hidden[id='pwdcheck_v']").val(1);
		}
	
	});
	
	// 현재비밀번호 보이기 숨기기
	$('#showCurrentPassword').on('click', function(){
        var passwordInput = $('input[id="current_pwd"]');
        var passwordIcon = $(this);

        if (passwordInput.attr('type') === 'password') {
            passwordInput.attr('type', 'text');
            passwordIcon.removeClass('fa-eye').addClass('fa-eye-slash');
        } else {
            passwordInput.attr('type', 'password');
            passwordIcon.removeClass('fa-eye-slash').addClass('fa-eye');
        }
    });
	
	
	// 비밀번호 보이기 숨기기
	$('#showPassword').on('click', function(){
        var passwordInput = $('input[name="pwd"]');
        var passwordIcon = $(this);

        if (passwordInput.attr('type') === 'password') {
            passwordInput.attr('type', 'text');
            passwordIcon.removeClass('fa-eye').addClass('fa-eye-slash');
        } else {
            passwordInput.attr('type', 'password');
            passwordIcon.removeClass('fa-eye-slash').addClass('fa-eye');
        }
    });
	
	
	// 비밀번호 확인 보이기 숨기기
	$('#showPasswordCheck').on('click', function(){
        var passwordInput = $('input[id="pwdcheck"]');
        var passwordIcon = $(this);

        if (passwordInput.attr('type') === 'password') {
            passwordInput.attr('type', 'text');
            passwordIcon.removeClass('fa-eye').addClass('fa-eye-slash');
        } else {
            passwordInput.attr('type', 'password');
            passwordIcon.removeClass('fa-eye-slash').addClass('fa-eye');
        }
    });
	
	
	
	
	
	
});


function goPwdUpdate() {
	
	let b_requiredInfo = false;
	
	const requiredInfo_list = document.querySelectorAll(".requiredInfo");
	console.log(requiredInfo_list);
    for(let i=0; i<requiredInfo_list.length; i++){
		const val = requiredInfo_list[i].value.trim();
		if(val == "") {
			alert("비밀번호 변경하시려면 모두 입력해 주세요.");
		    b_requiredInfo = true;
		    break;
		}
	}// end of for-----------------------------
	
	if($("input:hidden[id='c_pwd']").val() != 1) {
		alert("현재 비밀번호와 일치하지 않습니다.");
	    b_requiredInfo = true;
	}
	
	if($("input:hidden[id='pwd']").val() != 1) {
		alert("비밀번호를 올바르게 입력하세요.");
	    b_requiredInfo = true;
	}
	
	if($("input:hidden[id='pwdcheck_v']").val() != 1) {
		alert("비밀번호가 일치하지 않습니다.");
	    b_requiredInfo = true;
	}
	
	if(b_requiredInfo) {
		return; 
	}
	
	const frm = document.pwdUpdateEndFrm;
    frm.action = "<%= ctxPath%>/pwdUpdateEnd.gw";
	frm.method = "post";
	frm.submit();
	
}


</script>


	<form name="pwdUpdateEndFrm">
	
		<input type="text" name="username" style="display: none;" aria-hidden="true">
		
		<div class="div_f"><span style="color: blue;">안전한 비밀번호로 내정보를 보호</span>하세요.</div>
		<div class="div_f"><span style="color: red;">다른 아이디/사이트에서 사용한 적 없는 비밀번호<br>
			이전에 사용한 적 없는 비밀번호</span>가 안전합니다.</div>
		
		
				
		<div class="div1">
			<span class="title s_display">현재 비밀번호</span>
			<div class="div2 div2_display">
				<span class="icon"><i class="fa-solid fa-lock"></i></span>
				<input type="password" id="current_pwd" class="requiredInfo" placeholder="현재 비밀번호" autocomplete="new-password" />
				<span class="clear"><i class="fa-solid fa-circle-xmark" style="color: #6f6d6d;"></i></span>
			</div>
				<i class="fa-solid fa-eye" id="showCurrentPassword"></i>
				<span class="error">현재 비밀번호와 일치하지 않습니다.</span>
				<input type="hidden" id="c_pwd" />
		</div>
				
		<div class="div1">
			<span class="title s_display">새 비밀번호</span>
			<div class="div2 div2_display">
				<span class="icon"><i class="fa-solid fa-lock"></i></span>
				<input type="password" name="pwd" class="requiredInfo" placeholder="비밀번호(8~20자 영문,숫자,특수문자 조합)" autocomplete="new-password" />
				<span class="clear"><i class="fa-solid fa-circle-xmark" style="color: #6f6d6d;"></i></span>
			</div>
				<i class="fa-solid fa-eye" id="showPassword"></i>
				<span class="error">비밀번호는 영문+숫자+특수기호 8글자 이상입니다.</span>
				<input type="hidden" id="pwd" />
		</div>
						
		<div class="div1">
			<span class="title s_display">새 비밀번호 확인</span>
			<div class="div2 div2_display">
				<span class="icon"><i class="fa-solid fa-lock"></i></span>
				<input type="password" id="pwdcheck" class="requiredInfo" placeholder="비밀번호 재입력" autocomplete="new-password"  />
				<span class="clear"><i class="fa-solid fa-circle-xmark" style="color: #6f6d6d;"></i></span>
			</div>
				<i class="fa-solid fa-eye" id="showPasswordCheck"></i>
				<span class="error">비밀번호가 일치하지 않습니다.</span>
				<input type="hidden" id="pwdcheck_v" />
		</div>
					
		<div style="margin: 3% 21% 7%; width: 60%;">
			<button type="button" onclick="goPwdUpdate()">변경하기</button>
		</div>
				
		<input type="hidden" id="login_pwd" value="${requestScope.loginuser.pwd}" />
	</form>



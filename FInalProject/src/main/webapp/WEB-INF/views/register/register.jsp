<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
  
<%
	String ctxPath = request.getContextPath();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>


<script type="text/javascript" src="<%= ctxPath%>/resources/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="<%= ctxPath%>/resources/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" ></script> 
<script type="text/javascript" src="<%= ctxPath%>/resources/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script>

<style type="text/css">

div.div1 {
	margin: 0 23% 1%;
	width: 60%;
}

div.div2{
	border: solid 2px black;
	width: 93%;
	padding: 5px;
	box-sizing: border-box;
}

div.div2_display {
	display: inline-block;
}

input{
	border: none; 
	width: 80%; 
	padding: 5px 5px 5px 15px;
}

select {
	border: none; 
	width: 90%; 
	padding: 5px 5px 5px 15px;
}

span {
	font-weight: bold;
	font-size: 12pt;
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

i.fa-eye {
	display: none;
}

span.clear {
	display:none;
	font-size: 10px;
	margin-left: 5%;
}

div.div_adrress {
	margin-top: 1%; 
	width: 46%; 
	display: inline-block;
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

input:focus,
select:focus {
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

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

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
	
	
	// input태그에 값이 들어가면 클리어버튼 비밀번호 확인 버튼 show
	$("input:text").on("input", function(e) {
		if($("input:text").val().trim() != "") {
			$(e.target).closest(".div2").find("span.clear").show();
		}
	});
	
	
	// clear 버튼 누르면 값 지우기
	$("span.clear").on("click", function(e) {
		$(e.target).closest(".div2").find("input").val("");
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
	
	
	// 휴대전화 유효성검사
	$("input:text[name='phone']").on("focusout", function(e) {
			
		const regExp_phone = new RegExp(/^\d{11}$/);
		
		const bool = regExp_phone.test($(e.target).val());		
		
		if(!bool) {
			$(e.target).closest(".div1").find("span.error").show();
			$(e.target).closest(".div2").addClass("div2_error");
			$("input:hidden[id='phone']").val(0);
		}
		else {
			$(e.target).closest(".div1").find("span.error").hide();
			$(e.target).closest(".div2").removeClass("div2_error");
			$("input:hidden[id='phone']").val(1);
		}
		
	});
	
	
	// 주민번호 유효성검사
	$("input:text[name='jubun']").on("focusout", function(e) {
		
		const regExp_jubun = new RegExp(/^(?:[0-9]{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[1,2][0-9]|3[0,1]))-?[1-4]{1}$/g);
		
		const bool = regExp_jubun.test($(e.target).val());		
		
		if(!bool) {
			$(e.target).closest(".div1").find("span.error").show();
			$(e.target).closest(".div2").addClass("div2_error");
			$("input:hidden[id='jubun']").val(0);
		}
		else {
			$(e.target).closest(".div1").find("span.error").hide();
			$(e.target).closest(".div2").removeClass("div2_error");
			$("input:hidden[id='jubun']").val(1);
		}
	});
	
	
	// 주민번호에서 탭눌러서 우편번호로 넘어가면 다음 주소찾기 띄우기
	$("input:text[name='jubun']").on("blur", function(e) {
		daumPost();
	});
	
	
	// 우편번호 input태그 누르면 다음 주소찾기 띄우기
	$("input:text[name='postcode']").on("click", function(e) {
		daumPost();
	});
	
	
	
	// 은행선택 유효성검사
	$("select[name='bank_name']").on("change", function(e) {
			
		if ($(this).val() === "") {
			$(e.target).closest(".div1").find("span.error").show();
			$(e.target).closest(".div2").addClass("div2_error");
			$("input:hidden[id='bank_name']").val(0);
	    } 
		else {
	    	$(e.target).closest(".div1").find("span.error").hide();
			$(e.target).closest(".div2").removeClass("div2_error");
			$("input:hidden[id='bank_name']").val(1);
	    }
		
	});
	
	
	// 계좌번호 유효성검사
	$("input:text[name='bank_code']").on("focusout", function(e) {
		
		const regExp_phone = new RegExp(/^\d+$/);
		
		const bool = regExp_phone.test($(e.target).val());		
		
		if(!bool) {
			$(e.target).closest(".div1").find("span.error").show();
			$(e.target).closest(".div2").addClass("div2_error");
			$("input:hidden[id='bank_code']").val(0);
		}
		else {
			$(e.target).closest(".div1").find("span.error").hide();
			$(e.target).closest(".div2").removeClass("div2_error");
			$("input:hidden[id='bank_code']").val(1);
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
	
}); // end of $(document).ready(function(){})-------------------

function daumPost() {
	// 주소를 쓰기가능 으로 만들기
	$("input#address").removeAttr("readonly");
    
    // 참고항목을 쓰기가능 으로 만들기
    $("input#extraAddress").removeAttr("readonly");
    
    // 주소를 활성화 시키기
//	$("input#address").removeAttr("disabled");
    
    // 참고항목을 활성화 시키기
//  $("input#extraAddress").removeAttr("disabled");
	
	new daum.Postcode({
        oncomplete: function(data) {
            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

            // 각 주소의 노출 규칙에 따라 주소를 조합한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            let addr = ''; // 주소 변수
            let extraAddr = ''; // 참고항목 변수

            //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
            if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                addr = data.roadAddress;
            } else { // 사용자가 지번 주소를 선택했을 경우(J)
                addr = data.jibunAddress;
            }

            // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
            if(data.userSelectedType === 'R'){
                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if(data.buildingName !== '' && data.apartment === 'Y'){
                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if(extraAddr !== ''){
                    extraAddr = ' (' + extraAddr + ')';
                }
                // 조합된 참고항목을 해당 필드에 넣는다.
                document.getElementById("extraAddress").value = extraAddr;
            
            } else {
                document.getElementById("extraAddress").value = '';
            }

            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            document.getElementById('postcode').value = data.zonecode;
            document.getElementById("address").value = addr;
            $("input:hidden[id='postcode_v']").val(1);
            $("input:hidden[id='address_v']").val(1);
            // 커서를 상세주소 필드로 이동한다.
            document.getElementById("detailAddress").focus();
        }
    }).open();
    
    // 주소를 읽기전용(readonly) 로 만들기
    $("input#address").attr("readonly", true);
    
    // 참고항목을 읽기전용(readonly) 로 만들기
    $("input#extraAddress").attr("readonly", true);
    
    // 주소를 비활성화 로 만들기
//  $("input#address").attr("disabled", true);
    
    // 참고항목을 비활성화 로 만들기
//  $("input#extraAddress").attr("disabled", true);
    
}// end of function daumPost()-----------------


function goRegister() {
	
	let b_requiredInfo = false;
	
	const requiredInfo_list = document.querySelectorAll(".requiredInfo");
	console.log(requiredInfo_list);
    for(let i=0; i<requiredInfo_list.length; i++){
		const val = requiredInfo_list[i].value.trim();
		if(val == "") {
			alert("모든 정보를 입력해 주세요.");
		    b_requiredInfo = true;
		    break;
		}
	}// end of for-----------------------------
	
	
	if($("input:hidden[id='pwd']").val() != 1) {
		alert("비밀번호를 올바르게 입력하세요.");
	    b_requiredInfo = true;
	}
	
	if($("input:hidden[id='pwdcheck_v']").val() != 1) {
		alert("비밀번호가 일치하지 않습니다.");
	    b_requiredInfo = true;
	}
	
	if($("input:hidden[id='phone']").val() != 1) {
		alert("핸드폰 번호가 올바르지 않습니다.");
	    b_requiredInfo = true;
	}
	
	if($("input:hidden[id='jubun']").val() != 1) {
		alert("주민번호가 올바르지 않습니다.");
	    b_requiredInfo = true;
	}
	
	if($("input:hidden[id='postcode_v']").val() != 1) {
		alert("우편번호를 입력해주세요.");
	    b_requiredInfo = true;
	}
	
	if($("input:hidden[id='address_v']").val() != 1) {
		alert("주소를 입력해 주세요.");
	    b_requiredInfo = true;
	}
	
	if($("input:text[name='detailaddress']").val().trim() != "") {
		$("input:hidden[id='detailaddress_v']").val(1);
	}
	
	if($("input:hidden[id='detailaddress_v']").val() != 1) {
		alert("상세주소를 입력해 주세요.");
	    b_requiredInfo = true;
	}
	
	if($("input:hidden[id='bank_name']").val() != 1) {
		alert("은행을 선택해 주세요.");
	    b_requiredInfo = true;
	}
	
	if($("input:hidden[id='bank_code']").val() != 1) {
		alert("계좌번호가 올바르지 않습니다.");
	    b_requiredInfo = true;
	}
	
	
	if(b_requiredInfo) {
		alert("함수종료")
		return; // goRegister() 함수를 종료한다.
	}
	
	const frm = document.RegisterFrm;
	frm.method = "post";
	frm.action = "<%= ctxPath%>/registerEnd.gw";
	frm.submit();
	
}

</script>

</head>
<body style="text-align: center; margin: 0 auto; width: 55%">
	<h1>사원 정보 입력</h1>
	
	<form name="RegisterFrm" style="margin: 0 auto; width: 85%;">
		<div style="text-align: left;" id="employeeRegister">
			
			<div class="div1">
				<span class="title">이메일</span>
				<div class="div2">
					<span class="icon"><i class="fa-regular fa-envelope"></i></span>
					<input type="text" name="email" value="${requestScope.register.EMAIL}" readonly autocomplete="username" />
					<span class="clear"><i class="fa-solid fa-circle-xmark clear" style="color: #6f6d6d;"></i></span>
				</div>
			</div>
				
			<div class="div1">
				<span class="title s_display">비밀번호</span>
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
				<span class="title s_display">비밀번호 확인</span>
				<div class="div2 div2_display">
					<span class="icon"><i class="fa-solid fa-lock"></i></span>
				    <input type="password" id="pwdcheck" class="requiredInfo" placeholder="비밀번호 재입력" autocomplete="new-password"  />
				    <span class="clear"><i class="fa-solid fa-circle-xmark" style="color: #6f6d6d;"></i></span>
				</div>
				<i class="fa-solid fa-eye" id="showPasswordCheck"></i>
				<span class="error">비밀번호가 일치하지 않습니다.</span>
				<input type="hidden" id="pwdcheck_v" />
			</div>
				
			<div class="div1">
				<span class="title">성명</span>
				<div class="div2">
					<span class="icon"><i class="fa-regular fa-user"></i></span>
				    <input type="text" name="name" value="${requestScope.register.NAME}" readonly />
				    <span class="clear"><i class="fa-solid fa-circle-xmark" style="color: #6f6d6d;"></i></span>
				</div>
			</div>
				
			<div class="div1">
				<span class="title s_display">휴대폰 번호</span>
				<div class="div2 div2_display">
					<span class="icon"><i class="fa-solid fa-mobile-screen"></i></span>
					<input type="text" name="phone" class="requiredInfo" placeholder="(-)하이픈 없이  11자로 입력해주세요"  />
					<span class="clear"><i class="fa-solid fa-circle-xmark" style="color: #6f6d6d;"></i></span>
				</div>
				<span class="error">(-)하이픈 없이  11자로 입력해주세요.</span>
				<input type="hidden" id="phone" />
			</div>
			
			<div class="div1">
				<span class="title s_display">주민번호</span>
				<div class="div2 div2_display">
					<span class="icon"><i class="fa-regular fa-calendar"></i></span>
					<input type="text" name="jubun" class="requiredInfo" maxlength="7" placeholder="앞자리 6자리와 뒷자리 1자리만 입력해주세요."  />
					<span class="clear"><i class="fa-solid fa-circle-xmark" style="color: #6f6d6d;"></i></span>
				</div>
				<span class="error">올바른 주민번호를 입력해 주세요.</span>
				<input type="hidden" id="jubun" />
			</div>
			
			<div class="div1">
				<span class="title s_display">우편번호</span>
				<div class="div2 div2_display">
					<span class="icon"><i class="fa-solid fa-house"></i></span>
					<input name="postcode" id="postcode" class="requiredInfo" maxlength="5"  />
					<span class="clear"><i class="fa-solid fa-circle-xmark" style="color: #6f6d6d;"></i></span>
				</div>
				<input type="hidden" id="postcode_v" />
			</div>
			
			<div class="div1">
				<span class="title s_display">주소</span>
				<div class="div2 div2_display">
					<span class="icon"><i class="fa-solid fa-house"></i></span>
					<input type="text" id="address" name="address" class="requiredInfo" placeholder="주소"  />
					<span class="clear"><i class="fa-solid fa-circle-xmark" style="color: #6f6d6d;"></i></span>
				</div>
				<div class="div2 div_adrress">
					<input type="text" name="detailaddress" id="detailAddress" class="address_size requiredInfo" maxlength="200" placeholder="상세주소"  />
				</div>
				<div class="div2 div_adrress">
				<input type="text" name="extraaddress" id="extraAddress" class="address_size" maxlength="200" placeholder="참고항목" />
				</div>
				<input type="hidden" id="address_v" />
				<input type="hidden" id="detailaddress_v" />
			</div>
			
			<div class="div1">
				<span class="title s_display">은행명</span>
				<div class="div2 div2_display">
					<span class="icon"><i class="fa-solid fa-building-columns"></i></span>
					<select name="bank_name" class="requiredInfo">
						<option value="">은행을 선택하세요.</option>
						<option>농협은행</option>
						<option>신한은행</option>
						<option>국민은행</option>
						<option>기업은행</option>
						<option>우리은행</option>
						<option>하나은행</option>
						<option>신협은행</option>
						<option>토스뱅크</option>
						<option>카카오은행</option>
					</select>
				</div>
				<span class="error">은행을 선택해주세요.</span>
				<input type="hidden" id="bank_name" />
			</div>
			
			<div class="div1">
				<span class="title s_display">계좌번호</span>
				<div class="div2 div2_display">
					<span class="icon"><i class="fa-solid fa-money-check-dollar"></i></span>
					<input type="text" name="bank_code" class="requiredInfo"  />
					<span class="clear"><i class="fa-solid fa-circle-xmark" style="color: #6f6d6d;"></i></span>
				</div>
				<span class="error">올바른 계좌번호를 입력해주세요.</span>
				<input type="hidden" id="bank_code" />
			</div>

			
			<input type="hidden" name="employee_id" value="${requestScope.register.EMPLOYEE_ID}" />
			
		</div>
		
		
		
		
		<div style="margin: 3% 21% 7%; width: 60%;">
			<button type="button" onclick="goRegister()">등록</button>
		</div>
	</form>
	
</body>
</html>
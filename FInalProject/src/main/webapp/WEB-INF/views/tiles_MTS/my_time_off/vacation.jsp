<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<%
	String ctxPath = request.getContextPath();
%>

<style type="text/css">
#container {width: 75%; margin:0 auto; margin-top:100px;}
#container1 {width: 70%; margin:0 auto; margin-top:30px;}
#container2 {width: 70%; margin:0 auto; margin-top:70px;}
#shadowDiv {padding: 20px; border-radius: 10px;}
#Navbar {margin-left: 2%; margin-right: 5%; width: 80%; background-size: cover; background-position: center; background-repeat: no-repeat; height: 70px;}

#Navbar > li > a{color: black;}

#Navbar > li > a {
	color: gray;
	font-weight: bold;
	font-size: 17pt;
}

#Navbar > li > a:hover {
	color: black;
}

#hTag {margin-left: 5%; font-weight: bold;}

.table {width: 90%;}

#trRow {background-color: #ccff99;}

#countSum {color: orange; font-size: 8pt; margin-left: 5%;}

.vacSpan {color: gray; font-size: 10pt;}

textarea#vacation_reason {width: 100%; height: 100px; margin: 1% auto; border:solid 2px gray;}

#myModal {
    display: none;
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    width: 100%;
    background-color: rgba(0, 0, 0, 0.5);
    justify-content: center;
    align-items: center;
}

.modal-content {
    background-color: #fff;
    padding: 20px;
    width: 100%;
    height: 50%;
    border-radius: 5px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
}

div.vacBoard {
	border: solid 0px gray;
	border-radius: 10px;   /* 모서리 둥글기 정도를 조절, 필요에 따라 조절하세요 */
    padding: 10px;  
    background-color: white;
    margin: 0 2%;
}

div.vacBoard > img {
	padding-left: 150px;
	
}

div.vacBoard > span {
	margin-left: 5%;       /* 내용과 테두리 간의 간격을 설정, 필요에 따라 조절하세요 */
}

/* 테이블 스타일 변경 */
div.vacBoard, div.listContainer, div.shadow {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 30px;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 12px 16px 0 rgba(0, 0, 0, 0.1);
    padding: 20px; 
}
/* 버튼 스타일링 */
button#modalBtn {
  	padding: 6px 15px; /* 버튼 내부 여백 설정 */
  	cursor: pointer; /* 커서 모양 설정 */
  	background-color: #00ace6; /* 배경 색상 설정 */
  	color: #fff; /* 글자 색상 설정 */
  	border: none; /* 테두리 제거 */
  	border-radius: 5px; /* 테두리 반경 설정 */
  	transition: background-color 0.3s; /* 배경 색상 전환 효과 설정 */
}
button#modalClose {
	padding: 6px 15px; /* 버튼 내부 여백 설정 */
  	cursor: pointer; /* 커서 모양 설정 */
  	background-color: #bfbfbf; /* 배경 색상 설정 */
  	color: #fff; /* 글자 색상 설정 */
  	border: none; /* 테두리 제거 */
  	border-radius: 5px; /* 테두리 반경 설정 */
  	transition: background-color 0.3s; /* 배경 색상 전환 효과 설정 */
}
</style>

<script type="text/javascript">

$(document).ready(function(){
	
	// 모달창에서 신청버튼 클릭시
	$("button#modalBtn").click(function(){
		const vacation_type = $("input#vacation_type").val().trim(); 			 // 사용자가 선택한 휴가종류
		const vacation_start_date = $("input#vacation_start_date").val().trim(); // 사용자가 입력한 시작일 값
        const vacation_end_date = $("input#vacation_end_date").val().trim();     // 사용자가 입력한 종료일 값
        const vacation_reason = $("input#vacation_reason").val().trim();	     // 사용자가 입력한 휴가신청사유
        const annual = $("input:hidden[name='annual']").val().trim();
        
	    const startParts = vacation_start_date.split('-');
	    const endParts = vacation_end_date.split('-');
	
	    const startDate = new Date(startParts[0], startParts[1] - 1, startParts[2]);
	    const endDate = new Date(endParts[0], endParts[1] - 1, endParts[2]);
	
	    const timeDiff = endDate - startDate;
	    const daysDiff = timeDiff / (1000 * 60 * 60 * 24);
	
	    if(daysDiff < 0) { 
	       alert("날짜를 정확하게 입력하세요.");
	       return false;
	    }
	    
	    if(vacation_start_date == "") {
	    	alert("시작일을 지정하세요.");
	    	return false;
	    }
	    
	    if(vacation_end_date == "") {
	    	alert("종료일을 지정하세요.");
	    	return false;
	    }
	    
	    if(vacation_type == 1) {
		    if(annual < daysDiff) {
		    	alert("보유 연차가 신청 일수보다 적습니다.");
		    	return false;
		    }
	    }
	    
	    if(vacation_reason == "") {
	       alert("사유를 입력하세요.");
	       return false;
	    }
	    
	    // 보낼 데이터
	    $("input#daysDiff").val(daysDiff); 
	
	    const frm = document.modalFrm;
	    frm.method = "post";
	    frm.action = "<%= ctxPath %>/annual.gw";
	    frm.submit();
	});
	
	$("button#modalClose").click(function(){
		closeModal();
	});
	
}); // end of $(document).ready(function(){})----------------------------------

//모달 열기
function openModal(vacation_type) {
    document.getElementById('myModal').style.display = 'flex'; // 모달을 보이게 설정
    
    $("input#vacation_type").val(vacation_type);
}
 
// 모달 바깥 부분 클릭시 모달을 닫아주는 함수
function closeModal() {
    document.getElementById('myModal').style.display = 'none'; // 모달을 숨김으로 설정
}

// 모달 바깥 부분 클릭 시 닫기
window.onclick = function(event) {
    var modal = document.getElementById('myModal');
    if (event.target === modal) {
        closeModal();
    }
}                     

</script>

<div id="container" style="">

   <%-- 상단 메뉴바 시작 --%>
   <nav class="navbar navbar-expand-lg mt-5 mb-4">
		<div class="collapse navbar-collapse">
			<ul class="navbar-nav" id="Navbar">
				<li class="nav-item">
					<a class="nav-link" href="<%= ctxPath %>/vacation.gw">휴가 개요</a>
				</li>
				
				<li class="nav-item">
					<a class="nav-link ml-5" href="<%= ctxPath %>/vacation_detail.gw">휴가 상세</a>
				</li>
				
				<c:if test="${sessionScope.loginuser.gradelevel >= 5}">
					<li class="nav-item">
						<a class="nav-link ml-5" href="<%= ctxPath %>/vacation_manage.gw">휴가 관리</a>
					</li>
				</c:if>
				
				<li>
					<a class="nav-link ml-5" href="<%= ctxPath %>/vacation_chart.gw">휴가 통계</a>
				</li>
				
			</ul>
		</div>
	</nav>
   <%-- 상단 메뉴바 끝 --%>
</div>


<%-- 본문 시작 --%>
<div id="container1">
   <div class='shadow border' id='shadowDiv'>
      <div class="container" id="container3">
        <div class="row">
            <div id="annual" class="col-sm-3" onclick="openModal('1')">
            	<div class="vacBoard mt-4" id="annual_div">
	                <img src="<%= ctxPath%>/resources/images/vacation_img/연차아이콘.png"/>
	                <br><br><br>
	                <span>연차</span> <br>
	                <span class='vacSpan'>${requestScope.annual}일</span>
	                <input type="hidden" name="annual" value="${requestScope.annual}"/>
                </div>
            </div>
            <div id="family_care" class="col-sm-3" onclick="openModal('2')">
            	<div class="vacBoard mt-4">
	                <img src="<%= ctxPath%>/resources/images/vacation_img/가족아이콘.png"/>
	                <br><br><br>
	                <span>가족돌봄</span> <br>
	                <span class='vacSpan'>신청 시 1일 지급</span>
                </div>
            </div>
            <div id="reserve_forces" class="col-sm-3" onclick="openModal('3')">
            	<div class="vacBoard mt-4">
	                <img src="<%= ctxPath%>/resources/images/vacation_img/예비군아이콘.png"/>
	                <br><br><br>
	                <span>군소집훈련</span> <br>
	                <span class='vacSpan'>신청 시 지급</span>
                </div>
            </div>
            <div id="infertility_treatment" class="col-sm-3" onclick="openModal('4')">
            	<div class="vacBoard mt-4">
	                <img src="<%= ctxPath%>/resources/images/vacation_img/치료아이콘.png"/>
	                <br><br><br>
	                <span>난임 치료</span> <br>
	                <span class='vacSpan'>매년 3일 지급</span>
                </div>
            </div>
        </div>
        <br>
        <div class="row">    
            <br>
            
            <div id="infertility_treatment" class="col-sm-3" onclick="openModal('5')">
            	<div class="vacBoard mb-4">
	                <img src="<%= ctxPath%>/resources/images/vacation_img/출산아이콘.png"/>
	                <br><br><br>
	                <span>배우자 출산</span> <br>
	                <span class='vacSpan'>매년 3일 지급</span>
                </div>
            </div>
            <div id="infertility_treatment" class="col-sm-3" onclick="openModal('6')">
            	<div class="vacBoard mb-4">
	                <img src="<%= ctxPath%>/resources/images/vacation_img/결혼아이콘.png"/>
	                <br><br><br>
	                <span>결혼</span> <br>
	                <span class='vacSpan'>매년 3일 지급</span>
                </div>
            </div>
            <div id="infertility_treatment" class="col-sm-3" onclick="openModal('7')">
           		<div class="vacBoard mb-4">
	                <img src="<%= ctxPath%>/resources/images/vacation_img/포상아이콘.png"/>
	                <br><br><br>
	                <span>포상</span> <br>
	                <span class='vacSpan'>매년 3일 지급</span>
                </div>
            </div>
        </div>
    </div>
	</div>
  </div>
  
  <%-- ========================================================================= --%>
  <%-- 본문 시작 --%>
<div id="container2">
   <div class='listContainer border'>
      <h5 class='mb-3' id='hTag'>내 휴가 </h5>
      
      <div class="max-form">
      <table class="table ml-5">
         <thead>
            <tr class='row' id='trRow'>
	        	<th class='col'>&nbsp;&nbsp;연차</th>
	            <th class='col'>가족돌봄</th>
	            <th class='col'>군소집훈련</th>
	            <th class='col'>난임치료</th>
	            <th class='col'>배우자출산</th>
	            <th class='col'>결혼</th>
	            <th class='col'>포상</th>
            </tr>
         </thead>
         
         
         <tbody>
            
	        <tr class='row'>
	        	<td class='col'>&nbsp;&nbsp;${requestScope.annual}일</td>
	            <td class='col'>${requestScope.family_care}일</td>
	            <td class='col'>${requestScope.reserve_forces}일</td>
	            <td class='col'>${requestScope.infertility_treatment}일</td>
	            <td class='col'>${requestScope.childbirth}일</td>
	            <td class='col'>${requestScope.marriage}일</td>
	            <td class='col'>${requestScope.reward}일</td>
	        </tr>
         </tbody>
      </table>
      </div>
      <div id='countSum'>연차를 제외한 휴가는 승인된 휴가의 누적합계를 표시합니다.</div>
	</div>
  </div>

<%-- --%>
<div id="myModal" class="modal">
	<form name="modalFrm">
	    <div class="modal-content">
	        <h4>휴가 신청</h4>
	        <div class='flex mr-auto'>
	        	<table style="width: 100%;" class="table table-bordered">
	        	  <tr>
	        	  	<td style='width: 30%;'>시작일</td>
	        	  	<td><input type="date" id="vacation_start_date" name="vacation_start_date" class="border p-2.5" required></td>
	        	  </tr>
	        	  <tr>
	        	  	<td>종료일</td>
	        	  	<td><input type="date" id="vacation_end_date" name="vacation_end_date" class="border p-2.5" required></td>
	        	  </tr>
	        	  <tr>
	        	  	<td>사유</td>
	        	  	<td><input id="vacation_reason" name="vacation_reason" class='border'/></td>
	        	  </tr>
	        	</table>
	        	<input type="hidden"value="${sessionScope.loginuser.employee_id}" name="employee_id"/>
		        <input type="hidden" id="vacation_type" name="vacation_type" />
		        <input type="hidden" id="vacation_reg_date" name="vacation_reg_date" />
		        <input type="hidden" id="daysDiff" name="daysDiff" />
		        <input type="hidden" id="annual" name="annual" value="${requestScope.annual}"/>
	        </div>
	        <div class='text-right'>
	        	<button type="submit" id="modalBtn" class="mr-2 btn-sm">확인</button>	
	        	<button type="reset" id="modalClose" class='btn-sm'>취소</button>	
	        </div>
	    </div>
    </form>
</div>
<%-- ============ 모달 [끝] ============= --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<% String ctxPath = request.getContextPath(); %>   
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
	
	.table table-bordered th {
        background-color: #3eb543; 
        color: white; 
    }
	
	button{
		border: none;
		wid
	}

	th {
		font-weight: bold;
		background-color: #e3f2fd; 
		width: 20%;
		text-align: center;
	}
	
	input,select {
		width:80%;
		border: solid 1px #cccccc;
	}
	
	input[type="date"] {
		cursor: pointer;
	}
	
	input[type="date"]::before {
		content: attr(data-placeholder);
		width: 100%;
	}
	
	input[type="date"]:valid::before {
		display: none;
	}
	input[data-placeholder]::before {
		color: red;
	}
	
	#celebmenu1 {
		color: #086BDE;
	}
	
	#btn_submit{
		width:100px;
		height:50px;
		font-size:17pt;
		font-weight:bold;
		margin-right:-23px;
	}
	
	
	#Navbar {
		margin-left: 2%; 
		margin-right: 5%; 
		width: 80%; 
		background-size: cover; 
		background-position: center; 
		background-repeat: no-repeat; 
		height: 70px;
		white-space: nowrap;}

	#Navbar > li > a{color: black;}

	#Navbar > li > a {
		color: gray;
		font-weight: bold;
		font-size: 17pt;
	}

	#Navbar > li > a:hover {
		color: black;
	}
	
	#frm_celebApply > div:nth-child(1) > h4{
		font-weight:bold;
		font-size:35px;
		margin-left:45px;
	}
	
	#list > h5{
		margin-left:30px;
	}
	
	#list > table > tbody > tr:nth-child(1) > th:nth-child(1),
	#list > table > tbody > tr:nth-child(1) > th:nth-child(3),
	#list > table > tbody > tr:nth-child(2) > th:nth-child(1),
	#list > table > tbody > tr:nth-child(2) > th:nth-child(3){
	 	background-color: #2bc131; 
		color: white; 
	}
	
	
</style>


<script type="text/javascript">
	
	
	$(document).ready(function(){
		
		 $('.eachmenu1').show();
		 
		 $("button#btn_submit").click(function(){
			 
			const celebrate_type = $("select#celebrate_type").val();
		 
			 if(celebrate_type == ''){
				 alert('경조 구분을 선택하세요!');
				 return;
			 }
			 
			 func_submit();
		 });
		
	}); // end of $(document).ready(function(){-----------------------

	// >>> 부문선택값에 따라 하위 셀렉트 팀옵션 다르게 하기 <<< // 
	function func_celebrate_type(value){
		
		var app_pay_1 = ["250000"]; 
		var app_pay_2 = ["100000"]; 
		var app_pay_3 =  ["100000"]; 
		var target = document.getElementById("app_pay");
		
		if(value == "1") {
			var app_pay = app_pay_1;
		}
		else if(value == "2") {
			var app_pay = app_pay_2;
		}
		else if(value == "3") {
			var app_pay = app_pay_3;
		}
		
		target.options.length = 0;

		for (i in app_pay) {
			var opt = document.createElement("option");
			opt.value = app_pay[i];
			opt.innerHTML = app_pay[i];
			target.appendChild(opt);
		}
		
		
	} //function bumunchange(){ -------------------------
		
	function func_submit() {

		const frm = document.frm_celebApply
		frm.action = "<%= ctxPath%>/CelebratePay.gw";
		frm.method = "POST";
		frm.submit();
	}
		
		
		

</script>


<form name="frm_celebApply" id="frm_celebApply">
	<div style='margin: 1% 0 5% 1%; width: 95%;' >
		<h4>복지 포인트 </h4>
		<nav class="navbar navbar-expand-lg mt-5 mb-4">
			<div class="collapse navbar-collapse">
				<ul class="navbar-nav" id="Navbar">
					<li class="nav-item">
						<a class="nav-link" href="<%= ctxPath %>/CelebratePay.gw">복지 포인트 신청</a>
					</li>
					
					<li class="nav-item">
						<a class="nav-link ml-5" href="<%= ctxPath %>/celebrateList.gw">나의 복지포인트 신청 목록</a>
					</li>
					
					<c:if test="${sessionScope.loginuser.gradelevel >= 10}">
					<li class="nav-item">
						<a class="nav-link ml-5" href="<%= ctxPath %>/CelebratePayStatus.gw">(관리자 전용)복지포인트 신청 승인 및 반려 결제 </a>
					</li>
					
					<li class="nav-item">
						<a class="nav-link ml-5" href="<%= ctxPath %>/CelebrateComplete.gw">(관리자 전용)복지포인트 승인 및 반려 결제 취소</a>
					</li>
				</c:if>
				</ul>
			</div>
		</nav>
	</div>
	
	<div id='list' class='m-4' style="width: 95%;">
	<h5>복지포인트 신청</h5>
	
	<%-- 경조구분만 선택가능. 옵션을 누르면 금액은 자동으로 들어오게 해야함.--%>
	
	<table class="table table-bordered m-4 my-3" >
		<c:if test="${ not empty sessionScope.loginuser }">
			<input type="hidden" id="app_no" name="app_no"/>
			<tr>
				<th>사원번호</th>
				<td><input type="text" id="fk_employee_id" name="fk_employee_id" value="${loginuser.employee_id}" readonly/></td>
				<th>사원명</th>
				<td><input type="text" id="name" name="name" value="${loginuser.name}" readonly/></td>
			</tr>
			<tr>
				<th><span style="color:red;">*</span>경조구분</th>
				<td><select id="celebrate_type" name="celebrate_type" onchange="func_celebrate_type(value)">
					<option value="">=== 종류를 선택해주세요 ===</option>
					<option value="1">명절 상여 포인트</option>
					<option value="2">생일 상여 포인트</option>
					<option value="3">휴가 상여 포인트</option>
					</select>
				</td>
				<th><span style="color:red;">*</span>신청포인트</th>
				<td>
					<select type="text" id="app_pay" name="app_pay" readonly >
						<option value=""></option>
					</select>
				</td>
			</tr>
	
		</c:if>
	</table>
	<div align="right">
		<button style="color: white; background-color:#086BDE" class="btn" id="btn_submit">신청</button>
	</div>
	</div>


</form>








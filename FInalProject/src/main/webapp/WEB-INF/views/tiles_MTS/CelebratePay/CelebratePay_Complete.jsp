<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<% String ctxPath = request.getContextPath(); %>   
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    
    
<style>


	button{
		border: none;
	}

	th {
	font-weight: bold;
	background-color: #e3f2fd; 
	text-align: center;
	}
	
	div > button {
		width: 6%;
		display: inline-block;
		margin: 1% 0;
	}
	
	input { 
		width: 40px;
		border: none;
		align-content: center;
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
	
	#mycontent > div:nth-child(4) > h4{
		font-weight:bold;
		font-size:35px;
		margin-left:45px;
	}
	
	#close{
		font-size:18px;
		color: #ffffff;
		font-weight: 700;
		letter-spacing: 2px;
		text-transform: uppercase;
		border: none;
		height:50px;
		width:100px;
		background-color:#d61d1d;
	}
	
	#app_date{
		width:120px;
		height:32px;
	}
	
	.table-bordered.table-sm th {
        background-color: #3eb543; 
        color: white; 
    }
    
    #name{
		margin-left:681px;
		width:140px;
	}
</style>

<script>

	$(document).ready(function(){
	
		
		$("button#btnSearch").click(function(){
	    	const frm = document.searchFrm;
	        const deptName = $("#deptName").val();
	        const title = $("#title").val();
	        const gender = $("#gender").val();
	        const app_status = $("#app_status").val();
	        const app_date = $("#app_date").val();
	        
	        frm.action = "<%= ctxPath%>/CelebrateComplete.gw?app_date=" + app_date + "&app_status=" + app_status + "&deptName=" + deptName + "&title=" + title + "&gender=" + gender;
	        frm.submit();
	    });
	    
		$("button#btnSearch2").click(function(){
	    	const frm = document.searchFrm;
	        const name = $("#name").val();
	        frm.action = "<%= ctxPath%>/CelebrateComplete.gw?name=" + name;
	        frm.submit();
	    });

	   	    // 초기화 버튼 클릭 시 폼 초기화
	   	$("button#btnReset").click(function() {
	   		const frm = document.searchFrm;
	   	    $("#deptName").val(''); // 부서 선택 초기화
	   	   	$("#title").val(''); // 직급 선택 초기화
	   	    $("#gender").val(''); // 성별 선택 초기화
	   	 	$("#app_status").val('') //구분 선택 초기화
			$("#app_date").val(''); //기간 선택 초기화
	   	    frm.action = "<%= ctxPath %>/CelebrateComplete.gw"; // 폼 액션 초기화
	   	    frm.submit();
	   	 });
	
		
	$("input#close").click(function(){	
		
			const gradelevel = parseInt("${sessionScope.loginuser.gradelevel}");
			if(gradelevel < 10) {
				alert("결재 권한이 없습니다.");
				return;
			}
			else {
				const ArrApp_no = new Array();
				const ArrApp_pay = new Array();
				const ArrFk_employee_id = new Array();

				const checkNoCnt = $("input:checkbox[name='checkNo']").length;
				
				for(let i=0; i<checkNoCnt; i++) {
					
	              	if($("input:checkbox[name='checkNo']").eq(i).prop("checked")) {
	              		ArrApp_no.push( $("input:hidden[name='app_no']").eq(i).val() );
	               	} // end of if -----
	               	
				} // end of for----------------------
	
				var vac_approved = confirm("취소 하시겠습니까?");
				
				if(vac_approved) {
					$("input:hidden[name='app_no']").val(ArrApp_no);
					
					const frm = document.vac_manage_frm; 
					
					frm.method = "post";
					frm.action = "<%= ctxPath %>/CelebrateStatus_close.gw";
					frm.submit();
				}
			}
		});
		
		// 다중체크박스
			$("#selectAll").click(function () {
	            $("input:checkbox[name='checkNo']").prop('checked', $(this).prop('checked'));
	        });
			
			// 개별 체크박스 클릭 시 전체선택 체크박스 해제
			$("input:checkbox[name='checkNo']").click(function () {
			    var checkboxLen = $("input:checkbox[name='checkNo']").length;
			    
			    var checkedLen = $("input:checkbox[name='checkNo']:checked").length;

			    $("#selectAll").prop('checked', checkboxLen === checkedLen);
			});
			 
			 
			 
	}); // end of $(document).ready(function(){
		
		
	// >>> Function Declartion<<<	

	// 기존 신청목록 조회 
	function getCelebratePay_list(){
		
		$.ajax({
			url : "<%=ctxPath%>/CelebrateComplete.gw",
			data : {"seq": "${boardvo.seq}"},
			dataType:'json',
			cache:false,
			success:function(jsonArr){
				
	     	},
		     error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		 });
	}	

</script>


<div style='margin: 1% 0 5% 1%'>
	<h4>복지포인트 관리</h4>
	
	<%-- 상단 메뉴바 시작 --%>
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
						<a class="nav-link ml-5" href="<%= ctxPath %>/CelebrateComplete.gw">(관리자 전용)복지포인트 신청 승인 및 반려 결제 취소</a>
					</li>
				</c:if>

				
			</ul>
		</div>
	</nav>
	
	
	
</div>
	<input type="hidden" name="employee_id" value="${loginuser.employee_id}">
	
		
		 <form name="searchFrm" style="margin-left:35px;">
		 <span style="font-size:15pt; margin-right:15px;">복지 포인트 신청현황</span>
			<c:if test="${not empty requestScope.deptNameList}">
			    <select name="deptName" id="deptName" style="height: 30px; width: 120px;">
				    <option value="">부서선택</option>
				    <c:forEach var="dept" items="${requestScope.deptNameList}" varStatus="status">
	                <option value="${dept.department_id}" ${param.deptName == dept.department_id ? 'selected' : ''}>${dept.department_name}</option>
				    </c:forEach>
				</select>
				</c:if>
	
				 <select name="title" id="title" style="height: 30px; width: 120px;">
	            	<option value="">직급선택</option>
		   			    <option value="사장" <c:if test="${param.title eq '사장'}">selected</c:if>>사장</option>
		   			    <option value="부서장" <c:if test="${param.title eq '부서장'}">selected</c:if> >부서장</option>
		   			    <option value="팀장" <c:if test="${param.title eq '팀장'}">selected</c:if>>팀장</option>
		   			    <option value="사원" <c:if test="${param.title eq '사원'}">selected</c:if>>사원</option>
			    </select>
				<select name="gender" id="gender" style="height: 30px; width: 120px;">
				   <option value="">성별선택</option>
				   <option value="남" <c:if test="${param.gender eq '남'}">selected</c:if>>남</option>
				   <option value="여" <c:if test="${param.gender eq '여'}">selected</c:if>>여</option>
				</select>
				<select name="app_status" id="app_status" style="height: 30px; width: 120px;">
				   <option value="">승인구분선택</option>
				   <option value="1" <c:if test="${param.app_status eq '1'}">selected</c:if>>승인완료</option>
				   <option value="2" <c:if test="${param.app_status eq '2'}">selected</c:if>>승인반려</option>
				</select>
				 <input type="date" id="app_date" name="app_date" class="border p-2.5" required>
		      <button type="button" class="btn btn-info btn-sm" id="btnSearch">검색하기</button>
		      <button type="reset" class="btn btn-danger btn-sm" id="btnReset">초기화</button>
		      
		      <input type="text" id="name" name="name" class="border p-2.5" required>
		 	  <button type="button" class="btn btn-success btn-sm" id="btnSearch2">직원명 검색 <i class="fa-solid fa-magnifying-glass"></i></button>

      </form>
	<form name="vac_manage_frm">
	<div class='m-4' style="margin: 7% 0% 5% 0%; width: 95%;">
		<table class="table table-bordered table-sm ">
			<thead>
				<tr>
					<c:if test="${not empty requestScope.CelebrateCompleteList && sessionScope.loginuser.gradelevel == 10}">
	               		<th class='col col-1'><input type="checkbox" id="selectAll" class="mr-2"/>전체선택</th>
	             	</c:if>
					<th>No</th>
					<th>신청번호</th>
					<th>사원번호</th>
					<th>부서이름</th>
					<th>직급</th>
					<th>사원명</th>
					<th>성별</th>
					<th>경조구분</th>
					<th>결제구분</th>
					<th>복지포인트</th>
					<th>신청일</th>
				</tr>
			</thead>
		
			<tbody>
			    <c:if test="${not empty requestScope.CelebrateCompleteList}">
			        <c:forEach var="StatusList" items="${requestScope.CelebrateCompleteList}" varStatus="status" > 
			            <tr class="text-center border">
			                <td class='col col-1'>
			                    <div>    
			                        <c:if test="${sessionScope.loginuser.gradelevel == 10}">
			                            <input type="checkbox" id="checkNo${status.index}" name="checkNo" value="${StatusList.app_no}" />
			                        </c:if>
			                    </div>
			                </td>
			                 <td><c:out value="${status.count}" /></td>
			                <td><span>${StatusList.app_no}</span></td>
			                <td><span>${StatusList.fk_employee_id}</span></td>
			                <td><span>${StatusList.department_name}</span></td>
			                <td><span>${StatusList.title}</span></td>
			                <td><span style="width:50px;">${StatusList.name}</span></td>
			                <td><span>${StatusList.gender}</span></td>
			                <td>
			                    <c:choose>
			                        <c:when test="${StatusList.celebrate_type eq '1'}"><span style="width:180px;">명절 상여 복지 포인트</span></c:when>
			                        <c:when test="${StatusList.celebrate_type eq '2'}"><span style="width:180px;">생일 상여 복지 포인트</span></c:when>
			                        <c:otherwise><span style="width:180px;">휴가 상여 포인트</span></c:otherwise>
			                    </c:choose> 
			                </td>
			                 <td>
			                    <c:choose>
			                        <c:when test="${StatusList.app_status eq '1'}"><span style="width:180px;">승인</span></c:when>
			                        <c:when test="${StatusList.app_status eq '2'}"><span style="width:180px;">반려</span></c:when>
			                    </c:choose> 
			                </td>
			                <td><span style="width:80px;">${StatusList.app_pay}</span></td>
			                <td><span style="width: 110px;">${StatusList.app_date}</span></td>
			            </tr>
			            <!-- 수정된 부분: 각 행에 고유한 id 값 부여 -->
			            <input type="hidden" id="app_no${status.index}" name="app_no" value="${StatusList.app_no}"/>
			            <input type="hidden" id="app_pay${status.index}" name="app_pay" value="${StatusList.app_pay}"/>
			            <input type="hidden" id="fk_employee_id${status.index}" name="fk_employee_id" value="${StatusList.fk_employee_id}"/>
			        </c:forEach>
			    </c:if>
			</tbody>
		</table>
	</div>
	<div align="center">
		<c:if test="${empty requestScope.CelebrateCompleteList}">
					 경조비 신청내역이 존재하지 않습니다.
		</c:if>
	</div>

	<%-- 정보수정 페이지에서 보이는 버튼 --%>
	<c:if test="${not empty requestScope.CelebrateCompleteList}">
		<div align="right" style="margin: 3% 4% 3% 0;">
			<input type="submit" id="close" name="close" value="취소" class="ml-4"/>
		</div>
	</c:if>
	</form>	 

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    String ctxPath = request.getContextPath();
%>
<style type="text/css">
#container {width: 75%; margin:0 auto; margin-top:100px;}
#Navbar {margin-left: 2%; margin-right: 5%; width: 80%; background-size: cover; background-position: center; background-repeat: no-repeat; height: 70px;}
tr.table_tr {background-color: #ccff99; width: 94%;}
#Navbar > li > a {
	color: gray;
	font-weight: bold;
	font-size: 17pt;
}
#Navbar > li > a:hover {
	color: black;
}

/* 휴지통 버튼 */
i.fa-angle-left:hover, i.fa-angle-right:hover {
	color: black;
}

i.fa-angle-left, i.fa-angle-right {
	cursor: pointer;
	color: gray;
}
/* 테이블 스타일 변경 */
div.shadow {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 30px;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 12px 16px 0 rgba(0, 0, 0, 0.1);
}

/* 테이블 스타일 변경 */
.tblShadow{
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 30px;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 12px 16px 0 rgba(0, 0, 0, 0.1);
}
div#monthChoice {display: block; width: 100%;}
.table_tr {background-color: #ccff99; width: 94%;}
div#div_monthChoice {display: flex; margin-left: 40%; margin-top: 39px;}
i#prevMonth, i#nextMonth, div#div_thisMonth {font-size: 20pt;}
span#myDeptName, span#selectDeptName {font-size: 15pt; font-weight: bold;}
div#thisMonth {font-size: 20pt; position: relative; bottom: 6px;}
</style>

<script type="text/javascript">
$(document).ready(function(){
	
	var now = new Date();	
	var year = now.getFullYear();     // 현재 해당 년도
	var month = now.getMonth()+1;     // 현재 해당 월
	var date = now.getDate(); 	      // 현재 해당 일자
	var day = parseInt(now.getDay()); // 현재 해당 요일 1=월, 2=화, 3=수  ... 7=일
	
	var hour = now.getHours(); 	   // 현재 해당 시각
	var minute = now.getMinutes(); // 현재 해당 분
	var second = now.getSeconds(); // 현재 해당 초
	
	let end;
	
	if(day != 5){ // 오늘이 금요일이 아니라면	
		end = new Date(now.setDate(now.getDate()+(5-day))); // 이번주의 금요일 구하기			
		let enddate = end.getDate();
		if(enddate < 10){enddate = '0'+enddate;}
		
		end = end.getFullYear() + "-" + (end.getMonth()+1) + "-" + enddate + "(" + day_kor(end.getDay()) + ")";
	}
	else { // 오늘이 금요일 이라면
		end = year + "-" + month + "-" + date + "(" + day_kor(day) + ")";
	}
	
	// 한 자리 수일 때 앞에 0 붙이기
	minute = (minute < 10) ? '0' + minute : minute;
	second = (second < 10) ? '0' + second : second;
	month = (month < 10) ? '0' + month : month;
	
	const thisMonth = year+"-"+month; 			 // 2023-12
	
	const FullDate = year+"-"+month+"-"+date; 	 // 2023-12-27
	const FullTime = hour+":"+minute+":"+second; // 16:31:25
	
	$("div#thisMonth").text(thisMonth); // 현재 년도와 해당 월의 값을 꽂아줌
	
	// '<' 클릭시 이전달로 바꾸기
	$("#prevMonth").click(function(){ // ------------------------------------
		
		let monthVal = $("#thisMonth").text();
		
		monthVal = new Date(monthVal.substr(0,4), parseInt(monthVal.substr(5,2))-2);
		
		$("tbody#empWorkListDisplay").empty();
		
		let newMonth;
		if( parseInt(monthVal.getMonth())+1 <10 ){
			newMonth = monthVal.getFullYear()+"-0"+(parseInt(monthVal.getMonth())+1);
		}
		else {
			newMonth = monthVal.getFullYear()+"-"+(parseInt(monthVal.getMonth())+1);
		}
		
		$("#thisMonth").text(newMonth);
		
	}); // end of $("#prevMonth").click() -----------------------------------
	
	// '>' 클릭시 다음달로 바꾸기
	$("#nextMonth").click(function(){ // ------------------------------------
		
		let monthVal = $("#thisMonth").text();
	
		$("tbody#empWorkListDisplay").empty();
		
		if(thisMonth != monthVal){			
			monthVal = new Date(monthVal.substr(0,4), parseInt(monthVal.substr(5,2)));
			
			let newMonth;
			if( parseInt(monthVal.getMonth())+1 <10 ){
				newMonth = monthVal.getFullYear()+"-0"+(parseInt(monthVal.getMonth())+1);
			}
			else {
				newMonth = monthVal.getFullYear()+"-"+(parseInt(monthVal.getMonth())+1);
			}
			
			$("#thisMonth").text(newMonth);
		}
		
	}); // end of $("#nextMonth").click() ------------------------------------
	
	// 해당 사원 클릭시 해당 사원의 근무일자를 가져옴
	$(".empList").click(function(e){
		const employee_id = $(this).find("td:eq(1) > input").val();
		
		empWorkList(employee_id); // 사원 클릭시 해당 사원의 근태내역 뿌리는 함수 ajax
	});
	
	
	// 부서 선택시
	$("select#deptSelect").change(function(e){
		var selectVal = $(e.target).val();
		$("#empListDisplay").hide(); // select 옵션 변경시 기존 정보 숨기기
		
		$("#myDeptName").hide(); // 기존 부서명 숨기기
		
		var deptIdSelectVal = $("#deptSelect").val();
		
		getSelectDeptName(deptIdSelectVal); // (관리자용) select 옵션의 값에 따라 해당 부서명 가져오는 함수 호출
		
		empWorkList_admin(selectVal);// (관리자용) select 옵션의 값에 따라 해당 부서의 직급, 이름 가져오는 함수 호출
	});
	
});

// 해당 사원의 근태내역 뿌리는 함수 ajax
function empWorkList(employee_id){
	var thisMonth = $("div#thisMonth").text();
	
	$.ajax({
		url:"<%=ctxPath%>/empWorkList.gw",
		data:{"employee_id":employee_id,
			  "thisMonth":thisMonth},
		dataType:"JSON",
		success:function(json){
			html = "";
			
			if(json.length > 0) {
				$.each(json, function(index, item) {
					
					var workDate = new Date(item.work_date);
                    var daysOfWeek = ['일', '월', '화', '수', '목', '금', '토'];
                    var dayOfWeek = daysOfWeek[workDate.getDay()];
					
					html += "<tr class='row text-center' style='width: 94%;'>"+
					        	"<td class='col'>"+item.work_date+ " (" + dayOfWeek + ")" +"</td>"+
					        	"<td class='col'>"+item.work_start_time+"</td>"+
					        	"<td class='col'>"+item.work_end_time+"</td>"+
					            "<td class='col'>"+item.timeDiff+"</td>"+
					        "</tr>";
				}); // end of $.each(json, function(index, item)--------------
			}
			else {
				html += "<tr>"+
							"<td>데이터가 없습니다</td>"+
						"</tr>";
			}
			
		  	$("#empWorkListDisplay").html(html);
		},
		error: function(request, status, error){
		  	alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	  	}
	});
}

// (관리자용) select 옵션의 값에 따라 해당 부서의 직급, 이름 가져오기
function empWorkList_admin(department_id) {
	var selectVal = $("select#deptSelect").val();
	
	$.ajax({
		url:"<%=ctxPath%>/deptSelectList.gw",
		data:{"selectVal":selectVal},
		dataType:"JSON",
		success:function(json){
			html = "";
			if(json.length > 0) {
				$.each(json, function(index, item) {
					html += "<tr class='deptSelectEmpList'>"+
								"<td>"+item.job_name+"</td>"+
								"<td style='align-items: center; display: flex;'>"+item.name+
									"<span class='employee_id' style='display: none;'>"+item.employee_id+"</span>";
					if(item.work_start_time != null) {
						html += "<span class='material-icons-outlined ml-4' style='color:green;'>check_circle_outline</span>";
					}
					else {
						html += "<span class='material-icons-outlined ml-4'>highlight_off</span>";
					}
									
					html +=	"</td>"+
							"</tr>";		
				}); // end of $.each(json, function(index, item)
			}
			$("tbody#selectValDisplay").html(html);
			$(document).on("click", ".deptSelectEmpList", function (e) {
				var employee_id = $(this).find(".employee_id").text();
				
				empWorkList(employee_id); // 사원 클릭시 해당 사원의 근태내역 뿌리는 함수 ajax
			});
		},
		error: function(request, status, error){
		  	alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	  	}
	});
}

//(관리자용) select 옵션의 값에 따라 해당 부서명 가져오는 함수
function getSelectDeptName(deptIdSelectVal) {
	
	var IdSelectVal = $("#deptSelect").val();
	
	$.ajax({
		url:"<%=ctxPath%>/getSelectDeptName.gw",
		data:{"IdSelectVal":IdSelectVal},
		dataType:"JSON",
		success:function(json){
			$("#selectDeptName").text(json.getSelectDeptName);
		},
		error: function(request, status, error){
		  	alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	  	}
	});
	
}

function day_kor(day){
	switch (day) {
	
	case 1:
		result = "월"	
		break;
	case 2:
		result = "화"
		break;
	case 3:
		result = "수"
		break;
	case 4:
		result = "목"
		break;
	case 5:
		result = "금"
		break;
		
	} // end of switch
	
	return result;
}
</script>

<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons+Outlined" rel="stylesheet">

<div id="container">
	
    <%-- 상단 메뉴바 시작 --%>
    <nav class="navbar navbar-expand-lg mt-5 mb-4">
		<div class="collapse navbar-collapse">
			<ul class="navbar-nav" id="Navbar">
				<li class="nav-item">
					<a class="nav-link" href="<%= ctxPath %>/my_work.gw">근퇴조회</a>
				</li>
				
				<li class="nav-item">
					<a class="nav-link ml-5" href="<%= ctxPath %>/my_work_manage.gw">근퇴신청관리</a>
				</li>
				
				<c:if test="${sessionScope.loginuser.gradelevel >= 5}">
					<li class="nav-item">
						<a class="nav-link ml-5" href="<%= ctxPath %>/dept_work_manage.gw">부서관리</a>
					</li>
				</c:if>
				
			</ul>
		</div>
	</nav>
	
	<%-- 본문 내용 [시작] --%>
    <div class="mt-5" style="display: flex;">
      <div style="width: 30%; margin-top: 6.4%;">
      	<div class='mb-2' style="display: flex;">
      		<span id="myDeptName">${requestScope.getMyDeptName}</span>
      		<span id="selectDeptName">
      		
      		</span>
      		<div style="margin-left: auto;">
      		<c:if test="${sessionScope.loginuser.gradelevel > 5}">
      		  <select id='deptSelect' style='height: 20pt;'>
      		  	<c:forEach var="getAllDeptIdList" items="${requestScope.getAllDeptIdList}">
      			  <option value='${getAllDeptIdList.department_id}'>${getAllDeptIdList.department_name}</option>
      			</c:forEach>
      		  </select>
      		</c:if>
      		</div>
      	</div>
    	<table class="table table-hover shadow">
    		<tr style='background-color: #ccff99;'>
    			<th style="width: 60%;">직급</th>
    			<th>이름</th>
    		</tr>
    		<c:if test="${not empty requestScope.myDeptEmpList}">
    			<c:forEach varStatus="status" var="myDeptEmpList" items="${requestScope.myDeptEmpList}">
    				<tr class="empList" id="empListDisplay">
    					<td>${myDeptEmpList.job_name}</td>
    					<td style='align-items: center; display: flex;'>${myDeptEmpList.name}
    						<c:if test="${myDeptEmpList.work_start_time != null}">
    							<span class='material-icons-outlined ml-4' style='color:green;'>check_circle_outline</span>
    						</c:if>
    						<c:if test="${myDeptEmpList.work_start_time == null}">
    							<span class='material-icons-outlined ml-4'>highlight_off</span>
    						</c:if>
    						<input type="hidden" name="employee_id" value="${myDeptEmpList.employee_id}" />
    					</td>
    				</tr>
    			</c:forEach>
    		</c:if>
    		<tbody id='selectValDisplay'>
    		</tbody>
    	</table>
      </div>
    	
    	
   	  <div id='monthChoice'>
    	<div class="p-4" id='div_monthChoice'>
	        <div>
	            <span><i class="fa-solid fa-angle-left" id="prevMonth"></i></span>
	        </div>
	        <div class="mx-3" id="thisMonth"></div>
	        <div>
	            <span><i class="fa-solid fa-angle-right" id="nextMonth"></i></span>
	        </div>
	    </div>
	    
    	<div>
    		<table class="table ml-5">
	         <thead>
	            <tr class='row table_tr text-center'>
	               	<th class='col'>근무일자</th>
	               	<th class='col'>출근시간</th>
		        	<th class='col'>퇴근시간</th>
		            <th class='col'>총근무시간</th>
	            </tr>
	         </thead>
	         <tbody id="empWorkListDisplay"></tbody>
	      </table>
    	</div>
   	 </div>
   </div>
</div>
<%-- 본문 내용 [끝] --%>


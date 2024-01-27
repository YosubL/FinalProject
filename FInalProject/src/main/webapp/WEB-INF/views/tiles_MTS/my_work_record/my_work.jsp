<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    String ctxPath = request.getContextPath();
%>

<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/resources/jquery-ui-1.13.1.custom/jquery-ui.css">

<style>
	#container {width: 75%; margin:0 auto; margin-top:100px;}
	#Navbar {margin-left: 2%; margin-right: 5%; width: 80%; background-size: cover; background-position: center; background-repeat: no-repeat; height: 70px;}
    a {
		margin-right: 10px;
		text-decoration: none !important;
		color: black;
		font-size: 13pt;
    }
   
    #Navbar > li > a {
		color: gray;
		font-weight: bold;
		font-size: 17pt;
	}
	#Navbar > li > a:hover {
		color: black;
	}
   
   .modal-content, #dropdown {
	    background-color: #fff;
	    padding: 20px;
	    width: 100%;
	    height: 50%;
	    border-radius: 5px;
	    box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
	}	

   .horizontal-scroll {
		display: flex;
		overflow-x: auto;
		gap: 1rem;
   }
   .horizontal-scroll::-webkit-scrollbar {
   		display: none;	
   }
   
   i.fa-angle-left:hover, i.fa-angle-right:hover {
   		color: black;
   }
   
   i.fa-angle-left, i.fa-angle-right {
   		cursor: pointer;
   		color: gray;
   }
   
   button#toggleBtn1, #toggleBtn2, #toggleBtn3, #toggleBtn4, #toggleBtn5 {
   		background-color: white;
   }
   
   button#toggleBtn1:hover, #toggleBtn2:hover, #toggleBtn3:hover, #toggleBtn4:hover, #toggleBtn5:hover {
   		background-color: #F5F5F5;
   		
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
	div#thisMonth {font-size: 20pt; position: relative; bottom: 6px;}
	i#prevMonth, i#nextMonth {font-size: 20pt;}
	div#leftDiv {width: 18%; margin-left: 13%; margin-right: auto;}
	div#middleDiv {width: 18%; margin: 0 auto;}
	div#rightDiv {width: 18%; margin-right: 13%; margin-left: auto;}
	input#workDate {height: 30px; border: solid 1px gray;}
	div#choiceMonth{display: flex; margin-left: 40%;}
	div#max_container {min-height: 840px;}
	
</style>

<script type="text/javascript">
$(document).ready(function(){
	
	var now = new Date();	
	var year = now.getFullYear();  // 현재 해당 년도
	var month = now.getMonth()+1;  // 현재 해당 월
	var day = now.getDate(); 	   // 현재 해당 일자
	
	var hour = now.getHours(); 	   // 현재 해당 시각
	var minute = now.getMinutes(); // 현재 해당 분
	var second = now.getSeconds(); // 현재 해당 초
	
	// 한 자리 수일 때 앞에 0 붙이기 (함수 활용)
	hour = padZero(hour);
	minute = padZero(minute);
	second = padZero(second);
	month = padZero(month);
	day = padZero(day);

	const thisMonth = year+"-"+month; 			 // 2023-12
	const FullDate = year+"-"+month+"-"+day; 	 // 2023-12-27
	const FullTime = hour+":"+minute+":"+second; // 16:31:25
	
	$("div#thisMonth").text(thisMonth); // 현재 년도와 해당 월의 값을 꽂아줌
	
	getMyWorkList(); // 토글형식 근무내역 띄우는 ajax 함수 호출 
	
	// '<' 클릭시 이전달로 바꾸기
	$("#prevMonth").click(function(){ // ------------------------------------
		
		let monthVal = $("#thisMonth").text();
		
		monthVal = new Date(monthVal.substr(0,4), parseInt(monthVal.substr(5,2))-2);
		
		let newMonth;
		if( parseInt(monthVal.getMonth())+1 <10 ){
			newMonth = monthVal.getFullYear()+"-0"+(parseInt(monthVal.getMonth())+1);
		}
		else {
			newMonth = monthVal.getFullYear()+"-"+(parseInt(monthVal.getMonth())+1);
		}
		
		$("#thisMonth").text(newMonth);
		getMyWorkList();
		
	}); // end of $("#prevMonth").click() -----------------------------------
	
	// '>' 클릭시 다음달로 바꾸기
	$("#nextMonth").click(function(){ // ------------------------------------
		
		let monthVal = $("#thisMonth").text();
		
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
			getMyWorkList();
		}
		
	}); // end of $("#nextMonth").click() ------------------------------------
	
    // 출근 버튼 클릭시  근무 테이블에 insert
    $("button#goToWork").click(function(){

    	$("input[name='work_date']").val(FullDate);
    	$("input[name='work_start_time']").val(FullTime);
    	
    	const frm = document.goToWorkInsert;
	    frm.method = "post";
	    frm.action = "<%= ctxPath %>/goToWorkInsert.gw";
	    frm.submit(); 
	    
    }); // end of $("button#goToWork").click(function()--------------------
    
 	// 퇴근 버튼 클릭시  근무 테이블 update
    $("button#leaveWork").click(function(){
    	
    	$("input[name='work_date']").val(FullDate);
	    $("input:hidden[name='work_end_time']").val(FullTime);
	    
		/////////////////////////////////////////////////////
		// 출근시간 날짜형식으로 변환
	    var TodayStartTime = $('#todayST').val(); // 로그인 한 사원의 오늘 출근 시간
	    
	    var TodayHour = TodayStartTime.substr(0, 2); // 출근 시 구하기
	    
	    var TodayMinute = TodayStartTime.substr(3, 2); // 출근 분 구하기
	    
	    var TodaySecond = TodayStartTime.substr(6); // 출근 초 구하기
	    
	    todayStartTimeVal = new Date();
	    
	    todayStartTimeVal.setHours(TodayHour);
	    todayStartTimeVal.setMinutes(TodayMinute);
	    todayStartTimeVal.setSeconds(TodaySecond);
	    
	    /////////////////////////////////////////////////////
	    // 근무 시간 가져오기
	    var workTimeNow = now - todayStartTimeVal;
	    var workTimeH = Math.floor(workTimeNow / (1000 * 60 * 60));  // 근무 시간
	    var workTimeM = Math.floor(workTimeNow / (1000 * 60) % 60); // 근무 분
	    var workTimeC = Math.floor((workTimeNow / 1000) % 60);	    // 근무 초
	    var workTimeVal = padZero(workTimeH)+":"+padZero(workTimeM)+":"+padZero(workTimeC);
	 	///////////////////////////////////////////////////////////////
	 	// 연장 근무 시간 구하기
	 	// 9시간의 밀리초는 32400000 - 23611081 = 12345125
	 	
	 	if(workTimeNow > 32400000) { // 연장근무인 경우
	 		var calculateTime = workTimeNow - 32400000;
	 		var calH = Math.floor(calculateTime / (1000 * 60 * 60));  // 연장 시간
		    var calM = Math.floor(calculateTime / (1000 * 60) % 60); // 연장 분
		    var calC = Math.floor((calculateTime / 1000) % 60); 	 // 연장 초
	 		
		    var overTimeVal = padZero(calH)+":"+padZero(calM)+":"+padZero(calC);
		 	            
		 	$("input[name='extended_end_time']").val(overTimeVal);
		 	
		 	const frm = document.goToWorkUpdateWithExtended; 
			frm.method = "post";
		    frm.action = "<%= ctxPath %>/goToWorkUpdateWithExtended.gw";
			frm.submit();
	 	}
	 	else {
	 		const frm = document.goToWorkUpdateWithExtended; 
			frm.method = "post";
		    frm.action = "<%= ctxPath %>/goToWorkUpdate.gw";
			frm.submit();
	 	}
    }); // end of $("button#goToWork").click(function()--------------------
    		
    // 근무신청 버튼 클릭시
   	$("button#workRequestPlace").click(function(){
   		workRequestModal(); // 모달창 띄우는 함수
   	});
    
    
    // 누적근무시간을 이용해 이번주 잔여근무시간, 이번주 연장근무시간 구하기
    var hourVal = $("span#workRecordHour").text();
    var minuteVal = $("span#workRecordMinute").text();
    
    if(hourVal == "" && minuteVal == "") { // 근무 내역이 없다면
    	$("span#workRecordHour").text("0");
    	$("span#workRecordMinute").text("0");
    }
    
    if(minuteVal < 10) { // 분 단위가 한자리라면
    	minuteVal = "0" + minuteVal; // 앞에 '0' 붙이기
    }
    
    if(hourVal < 40) {
    	// 여긴 잔여근무시간
    	$("span#overHour").text("0");
    	$("span#overMinute").text("0");
    	
    	if(minuteVal == 0) { // '분' 이 0 이라면
    		hourVal = 52 - hourVal; // 주 최대 근무시간 52시간 - 이번주 근무시간
    		$("span#shortHour").text(hourVal);
    		$("span#shortMinute").text(minuteVal);
    	}
    	else { // '분' 이 0 이 아니라면 시간 - 1
    		hourVal = 52 - hourVal - 1; // 주 최대 근무시간 52시간 - 이번주 근무시간 - 1
    		$("span#shortHour").text(hourVal);
    		
    		minuteVal = 60 - minuteVal;
    		$("span#shortMinute").text(minuteVal);
    	}
    	minuteVal = 60 - minuteVal;
    }
    else {
    	// 여긴 연장근무시간
    	$("span#shortHour").text("0");
   		$("span#shortMinute").text("0");
    	
    	hourVal = Number(hourVal) - 40;

    	$("span#overHour").text(hourVal);
    	$("span#overMinute").text(minuteVal);
    }
    
    // 모달창에서 확인 버튼 클릭시 근무관리테이블에 insert 하기
    $("input#workRequest").click(function(){
    	const workSelect = $("select#workSelect").val();
    	
    	if(workSelect == "") {
    		alert("신청할 근무를 선택하세요");
    		$("select#workSelect").focus();
    		return false;
    	}
    	if($("input[name='workDate']").val() == "") {
    		alert("신청일자를 선택하세요");
    		$("input[name='workDate']").focus();
    		return false;
    	}
    	
    	var workDate = $("input[name='workDate']").val();
    	var newDate = new Date(workDate);
    	
    	if(newDate < now) {
    		alert("근무일보다 이전 날짜의 근무신청은 불가합니다.");
    		$("input[name='workDate']").val("").focus();
    		return false;
    	}
    	
    	if($("input[name='requestStartTime']").val() == "") {
    		alert("시간을 선택하세요");
    		$("input[name='requestStartTime']").focus();
    		return false;
    	}
    	
    	if($("input[name='requestEndTime']").val() == "") {
    		alert("시간을 선택하세요");
    		$("input[name='requestEndTime']").focus();
    		return false;
    	}
    	
    	if($("input[name='requestStartTime']").val() > $("input[name='requestEndTime']").val()) {
    		alert("시작시간보다 이전 시간의 근무신청은 불가합니다.");
    		$("input[name='requestEndTime']").val("");
			return false;
    	}
    	
    	$("input:hidden[name='workSelectVal']").val(workSelect);
    	
   		const frm = document.modal_frm;
   	    frm.method = "post";
   	    frm.action = "<%= ctxPath %>/workRequest.gw";
   	    frm.submit();	
    }); 
    
    // 모달창에서 취소 클릭시 닫아주기
    $("input#cancle").click(function(){
    	closeModal();
    });
    	
});// end of $(document).ready(function() -------------------------

// 주차별 근태기록 가져오기
function getMyWorkList() {
	
	const thisMonthVal = $("#thisMonth").text();
	const fk_employee_id = "${sessionScope.loginuser.employee_id}";
	
	$.ajax({
		url:"<%=ctxPath%>/getMyWorkList.gw",
		data:{"thisMonthVal":thisMonthVal,
			  "fk_employee_id":fk_employee_id},
		dataType:"JSON",
		success:function(json){
			let html = "";
		
			html += "<div id='week1' class='widths' style='width: 60%; margin-left: 20%;'>"+
						"<div onclick='toggle(\"week1\")' class='weeks'>"+
						"<span class='fas fa-angle-down' style='font-size: 10pt;'></span>"+
						"&nbsp;1 주차"+
					"</div>"+
					"<hr>"+
					"<div id='table_week1' class='mt-6 bg-white p-4 border text-center tblShadow'>"+
						"<table class='table table-hover tables tblShadow'>"+
							"<thead>"+
								"<tr class='row border' style='background-color: #ccff99;'>"+
									"<th class='col'>일자</th>"+
									"<th class='col'>업무시작</th>"+
									"<th class='col'>업무종료</th>"+
									"<th class='col'>총근무시간</th>"+
								"</tr>"+
							"</thead>"+
							"<tbody>";
			if(json.length > 0) {
				$.each(json, function(index, item) {
					
					let work_start_time = item.work_date;
					let work_end_time = item.work_end_time;
					
					var workDate = new Date(item.work_date);
                    var daysOfWeek = ['일', '월', '화', '수', '목', '금', '토'];
                    var dayOfWeek = daysOfWeek[workDate.getDay()];
					
					html += "<tr class='row border'>"+
			    				"<td class='col'>"+item.work_date+ " (" + dayOfWeek + ")" +"</td>"+
			    				"<td class='col' id='work_start_time'>"+item.work_start_time+"</td>"+
			    				"<td class='col endTime'>"+item.work_end_time+"</td>"+
			    				"<td class='col'>"+item.timeDiff+"</td>"+
			    			"</tr>";
					
					if(index == 4) {
						html += "</tbody>"+
							"</table>"+
						"</div>"+
					"</div>"+
					"<div id='week2' class='widths' style='width: 60%; margin-left: 20%;'>"+
						"<div onclick='toggle(\"week2\")' class='weeks'>"+
							"<span class='fas fa-angle-down' style='font-size: 10pt;'></span>"+
							"&nbsp;2 주차"+
						"</div>"+
						"<hr>"+
						"<div id='table_week2' class='mt-6 bg-white p-4 border text-center'>"+
							"<table class='table table-hover tables tblShadow'>"+
								"<thead>"+
									"<tr class='row border' style='background-color: #ccff99;'>"+
										"<th class='col'>일자</th>"+
										"<th class='col'>업무시작</th>"+
										"<th class='col'>업무종료</th>"+
										"<th class='col'>총근무시간</th>"+
									"</tr>"+
								"</thead>"+
								"<tbody>";
					} // end of if(index == 4)
						
					if(index == 9) {
						html += "</tbody>"+
							"</table>"+
						"</div>"+
					"</div>"+
					"<div id='week3' class='widths' style='width: 60%; margin-left: 20%;'>"+
						"<div onclick='toggle(\"week3\")' class='weeks'>"+
							"<span class='fas fa-angle-down' style='font-size: 10pt;'></span>"+
							"&nbsp;3 주차"+
						"</div>"+
						"<hr>"+
						"<div id='table_week3' class='mt-6 bg-white p-4 border text-center'>"+
							"<table class='table table-hover tables'>"+
								"<thead>"+
									"<tr class='row border' style='background-color: #ccff99;'>"+
										"<th class='col'>일자</th>"+
										"<th class='col'>업무시작</th>"+
										"<th class='col'>업무종료</th>"+
										"<th class='col'>총근무시간</th>"+
									"</tr>"+
								"</thead>"+
								"<tbody>";
					} // end of if(index == 9)
					
					if(index == 14){
						html += "</tbody>"+
						"</table>"+
					"</div>"+
				"</div>"+
				"<div id='week4' class='widths' style='width: 60%; margin-left: 20%;'>"+
					"<div onclick='toggle(\"week4\")' class='weeks'>"+
						"<span class='fas fa-angle-down' style='font-size: 10pt;'></span>"+
						"&nbsp;4 주차"+
					"</div>"+
					"<hr>"+
					"<div id='table_week4' class='mt-6 bg-white p-4 border text-center'>"+
						"<table class='table table-hover tables tblShadow'>"+
							"<thead>"+
								"<tr class='row border' style='background-color: #ccff99;'>"+
									"<th class='col'>일자</th>"+
									"<th class='col'>업무시작</th>"+
									"<th class='col'>업무종료</th>"+
									"<th class='col'>총근무시간</th>"+
								"</tr>"+
							"</thead>"+
							"<tbody>";
					} // end of if(index == 14)
						
					if(index == 19){
						html += "</tbody>"+
						"</table>"+
					"</div>"+
				"</div>"+
				"<div id='week5' class='widths' style='width: 60%; margin-left: 20%;'>"+
					"<div onclick='toggle(\"week5\")' class='weeks'>"+
						"<span class='fas fa-angle-down' style='font-size: 10pt;'></span>"+
						"&nbsp;5 주차"+
					"</div>"+
					"<hr>"+
					"<div id='table_week5' class='mt-6 bg-white p-4 border text-center'>"+
						"<table class='table table-hover tables tblShadow'>"+
							"<thead>"+
								"<tr class='row border' style='background-color: #ccff99;'>"+
									"<th class='col'>일자</th>"+
									"<th class='col'>업무시작</th>"+
									"<th class='col'>업무종료</th>"+
									"<th class='col'>총근무시간</th>"+
								"</tr>"+
							"</thead>"+
							"<tbody>";
					} // end of if(index == 19)
					
					
				});
								
				html += "</tbody></table></div></div>";
				  
			  	$("#weeksPlace").html(html);
			  	
				$("#table_week1").hide();
				$("#table_week2").hide();
				$("#table_week3").hide();
				$("#table_week4").hide();
				$("#table_week5").hide();
					
				const today = new Date();
				weekOpen(today);
			}
			else {
				html += "<tr class='row border'>"+
							"<td class='col'>데이터가 없습니다</td>"+
						"</tr>";
				
				html += "</tbody></table></div></div>";
				
				$("#weeksPlace").html(html);
			}
		},
	  	error: function(request, status, error){
		  	alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	  	}
	}); // end of $.ajax({})----------------------
	
} // end of function getMyWorkList()--------------------------- 


// 근무신청 모달창
function workRequestModal(){
	$('#openModal').modal('show');
} // end of function requestWorkModal()------------


//오늘이 이번달의 몇번째 주인지 구하기	
function weekNumOfMonth(date){
	var week_kor = ["1", "2", "3", "4", "5"];
	var thursday_num = 5;	// 첫째주의 기준은 목요일(4)이다. 

	var firstDate = new Date(date.getFullYear(), date.getMonth()+ 1);
	var firstDayOfWeek = firstDate.getDay();

	var firstThursday = 1 + thursday_num - firstDayOfWeek;	// 첫째주 목요일
	if(firstThursday <= 0){
		firstThursday = firstThursday + 7;	// 한주는 7일
	}
	var untilDateOfFirstWeek = firstThursday-7+3;	// 월요일기준으로 계산 (월요일부터 한주의 시작)
	var weekNum = Math.ceil((date.getDate()-untilDateOfFirstWeek) / 7) - 1;

	if(weekNum < 0){	// 첫째주 이하일 경우 전월 마지막주 계산
		var lastDateOfMonth = new Date(date.getFullYear(), date.getMonth(), 0);
	 	var result = Util.Date.weekNumOfMonth(lastDateOfMonth);
	 	return result;
	}

	return week_kor[weekNum];
}

// 1~5주차 따로 열기(토글)
function weekOpen(date){
	const weekNo = weekNumOfMonth(date);
	
	const now = new Date();	
	
	const year = now.getFullYear();
	const month = now.getMonth()+1;
	
	const compairDate = now.getFullYear() + "-" + (now.getMonth()+1) ;
	if($("#thisMonth").text() == compairDate){
		
		switch (weekNo) {
		case "1":
			$("#table_week1").show();
			break;
			
		case "2":
			$("#table_week2").show();
			break;
			
		case "3":
			$("#table_week3").show();
			break;
	
		case "4":
			$("#table_week4").show();
			break;
			
		case "5":
			$("#table_week5").show();	
			break;
		}
	}
	else{
		$("#table_week1").show();
	}
}

// 토글 띄우기
function toggle(e){	
	const id = 'table_'+e;
	$('#'+id).slideToggle("fast");
}

// 오늘 날짜 출력해주는 함수 ex) 2023-12-20
function todayDate() {
	// 서버에서 가져온 현재 날짜를 JavaScript 변수로 설정
    var currentDate = new Date();
    
 	// 년, 월, 일을 가져와서 원하는 형식으로 조합
    var year = currentDate.getFullYear();
    var month = ('0' + (currentDate.getMonth() + 1)).slice(-2);
    var day = ('0' + currentDate.getDate()).slice(-2);

    // 2023-12-21 형식으로 바꾸기
    var todayDate = year+'-'+month+'-'+day;
}

// 출퇴근 관련 함수 [시작]
// 출근 버튼 클릭시 클릭한 시간을 표시하는 함수
function recordStartTime() {
    var startTimeElement = $("input#substring_start_time").val();
    var currentTime = new Date();
    var hours = currentTime.getHours();
    var minutes = currentTime.getMinutes();
    var seconds = currentTime.getSeconds();
    var formattedTime = padZero(hours) + ":" + padZero(minutes) + ":" + padZero(seconds);
    startTimeElement.textContent = formattedTime;
}

//퇴근 버튼 클릭시 클릭한 시간을 표시하는 함수
function recordEndTime() {
    var endTimeElement = document.getElementById('endTime');
    var currentTime = new Date();
    var hours = currentTime.getHours();
    var minutes = currentTime.getMinutes();
    var seconds = currentTime.getSeconds();
    var formattedTime = padZero(hours) + ":" + padZero(minutes) + ":" + padZero(seconds);
    endTimeElement.textContent = formattedTime;
}
//출퇴근 관련 함수 [끝]

// 문자열 형식의 시간을 밀리초로 변환하는 함수
function parseTime(timeString) {
    var timeParts = timeString.split(":");
    
    var hours = parseInt(timeParts[0], 10) * 60 * 60 * 1000;
    var minutes = parseInt(timeParts[1], 10) * 60 * 1000;
    var seconds = parseInt(timeParts[2], 10) * 1000;

    return hours + minutes + seconds;
}
 
// 주어진 값이 10보다 작을 경우 그 앞에 0을 붙여서 두 자리 수로 만드는 함수
function padZero(value) {
    return value < 10 ? "0" + value : value;
}

// 모달 닫는 함수
function closeModal() {
	$('#openModal').modal('hide');
}
</script>

<div id='max_container'>
  <div id='container'>
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
				
				<li class="ml-auto mt-2" style="">
					<button type="button" id="workRequestPlace" class="mr-3">근무신청</button>
					<button id="goToWork" class="button" style="width: 50px;">출근</button>
                	<button id="leaveWork" class="button ml-3" style="width: 50px;">퇴근</button>
                	
                	<form name="goToWorkInsert">
                		<input type="hidden" name="work_date"/>
                		<input type="hidden" name="work_start_time"/>
                		<input type="hidden" name="fk_employee_id" value="${sessionScope.loginuser.employee_id}"/>
                	</form>
                	
                	<%-- 연장근무인 경우 보낼 form --%>
                	<form name="goToWorkUpdateWithExtended">
                		<input type="hidden" name="work_date"/>
                		<input type="hidden" name="work_end_time"/>
                		<input type="hidden" name="extended_end_time"/>
                		<input type="hidden" name="fk_employee_id" value="${sessionScope.loginuser.employee_id}"/>
                	</form>
				</li>
			</ul>
			
		</div>
	</nav>
</div>
<%-- 상단 메뉴바 끝 --%>

<%-- 본문 내용 [시작] --%>
<div class="container text-center">
    <div class="p-4" id='choiceMonth'>
        <div>
            <span><i class="fa-solid fa-angle-left" id="prevMonth"></i></span>
        </div>
        <div class="mx-3" id="thisMonth"></div>
        <div>
            <span><i class="fa-solid fa-angle-right" id="nextMonth"></i></span>
        </div>
    </div>

    <div class="mt-6 horizontal-scroll">
        <div id='leftDiv'>
            <h4>이번주 <br>누적근무시간</h4>
            <p><span id='workRecordHour'>${requestScope.myWorkRecord.time}</span>시간 <span id='workRecordMinute'>${requestScope.myWorkRecord.minute}</span>분</p>
        </div>
        <div id='middleDiv'>
            <h4>이번주 <br>잔여근무시간</h4>
            <p><span id='shortHour'></span>시간 <span id='shortMinute'></span>분</p>
        </div>
        <div id='rightDiv'>
            <h4>이번주 <br>연장근무시간</h4>
            <p><span id='overHour'></span>시간 <span id='overMinute'></span>분</p>
        </div>
        <input type='hidden' id='todayST' value='${requestScope.myTodayStartTime}'/>
    </div>
</div>
<%-- 본문 내용 [끝] --%>

<%-- 토글 [시작] --%>
<div id="weeksPlace">
</div>
<%-- 토글 [끝] --%>

<%-- 모달창 --%>
<div class="modal fade" id="openModal" role="dialog" data-backdrop="static">
  <span onclick="closeModal()" style="cursor: pointer;">&times;</span> <!-- 닫기 버튼 -->
  <div class="modal-dialog" style="width: 500px;">
    <div class="modal-content">
    
      <!-- Modal header -->
      <div class="modal-header" style="border-bottom: none;">
        <h4 class="modal-title">근무신청</h4>
        <button type="button" class="close modal_close" data-dismiss="modal">&times;</button>
      </div>
      
      <!-- Modal body -->
      <div class="modal-body">
          <form name="modal_frm">
          <table style="width: 100%;" class="table table-bordered">
              <tr>
               	  <td style="width: 25%;">신청인</td>
	        	  <td id="frm_name">${sessionScope.loginuser.name}</td>
              </tr>
              <tr>
               	  <td>종류</td>
	        	  <td>
	        	  	<select style='height: 30px;' id='workSelect'>
	        	  	  <option value="">선택하세요</option>
				      <option value="1" id='workOut'>외근</option>
				      <option value="2" id='workTrip'>출장</option>
				      <option value="3" id='workRemote'>재택</option>
	        	  	</select> 
	        	  </td>
              </tr>
              <tr>
               	  <td>신청일자</td>
	        	  <td><input type="date" name='workDate' class="rounded-lg block w-full p-2.5" required></td>
              </tr>
              <tr>
               	  <td>시작시간</td>
	        	  <td>
  					<input id="requestStartTime" name="requestStartTime" type="time"/>
  				  </td>
              </tr>
              <tr>
               	  <td>종료시간</td>
	        	  <td>
  					<input id="requestEndTime" name="requestEndTime" type="time"/>
  				  </td>
              </tr>
              <tr>
               	  <td>장소 <span style="font-size: 10pt;">(선택)</span></td>
	        	  <td>
  					<input id="work_place" name="work_place" type="text"/>
  				  </td>
              </tr>
              <tr>
               	  <td>사유 <span style="font-size: 10pt;">(선택)</span></td>
	        	  <td>
  					<input id="work_reason" name="work_reason" type="text"/>
  				  </td>
              </tr>
           </table>
           
           <!-- Modal footer -->
	       <div class="modal-footer">
	           <input type="submit" id="workRequest" value="확인" />
	           <input type="reset" id="cancle" value="취소"/>
	           <input type="hidden" id="workSelectVal" name="workSelectVal" />
	       </div>
           </form>   
      </div>
    </div>
  </div>
 </div>
</div>

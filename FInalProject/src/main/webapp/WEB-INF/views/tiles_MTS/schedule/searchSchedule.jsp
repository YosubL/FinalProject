<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<% 
	String ctxPath = request.getContextPath(); 
%>

<style type="text/css">
	
	th, td{
	 	padding: 10px 5px;
	 	vertical-align: middle;
	}
	
	tr.infoSchedule{
		background-color: white;
		cursor: pointer;
	}
	
	a{
	    color: #395673;
	    text-decoration: none;
	    cursor: pointer;
	}
	
	a:hover {
	    color: #395673;
	    cursor: pointer;
	    text-decoration: none;
		font-weight: bold;
	}
	
	button.btn_normal{
		background-color: #0071bd;
		border: none;
		color: white;
		width: 50px;
		height: 30px;
		font-size: 12pt;
		padding: 3px 0px;
	}
	.searchSubject{
		font-size:20px;
	}
	
	div#searchPart{
		display:flex;
	}
	div#searchDiv{
		margin: 0 auto;
	}
	
	span.searchSubject{
		margin-right:50px;
	}
	div.searchDiv2{
		margin:10px;
	}
	
</style>

<%-- 검색할 때 필요한 datepicker 의 색상을 기본값으로 사용하기 위한 것임 --%>
<link rel="stylesheet" href="//code.jquery.com/ui/1.13.0/themes/base/jquery-ui.css"> 

<script type="text/javascript">

	$(document).ready(function(){
		
		// 검색할 때 필요한 datepicker
		// 모든 datepicker에 대한 공통 옵션 설정
	    $.datepicker.setDefaults({
	         dateFormat: 'yy-mm-dd'  // Input Display Format 변경
	        ,showOtherMonths: true   // 빈 공간에 현재월의 앞뒤월의 날짜를 표시
	        ,showMonthAfterYear:true // 년도 먼저 나오고, 뒤에 월 표시
	        ,changeYear: true        // 콤보박스에서 년 선택 가능
	        ,changeMonth: true       // 콤보박스에서 월 선택 가능                
	        ,monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'] //달력의 월 부분 텍스트
	        ,monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] //달력의 월 부분 Tooltip 텍스트
	        ,dayNamesMin: ['일','월','화','수','목','금','토'] //달력의 요일 부분 텍스트
	        ,dayNames: ['일요일','월요일','화요일','수요일','목요일','금요일','토요일'] //달력의 요일 부분 Tooltip 텍스트             
	    });
		
		// input 을 datepicker로 선언
	    $("input#fromDate").datepicker();                    
	    $("input#toDate").datepicker(); 
		    
	 // From의 초기값을 한달전 날짜로 설정
	    $('input#fromDate').datepicker('setDate', '-1M'); //(-1D:하루전, -1M:한달전, -1Y:일년전), (+1D:하루후, +1M:한달후, +1Y:일년후)
	    
	    // To의 초기값을 오늘 날짜로 설정
	//  $('input#toDate').datepicker('setDate', 'today'); //(-1D:하루전, -1M:한달전, -1Y:일년전), (+1D:하루후, +1M:한달후, +1Y:일년후)	
		
	    // To의 초기값을 한달후 날짜로 설정
	    $('input#toDate').datepicker('setDate', '+1M'); //(-1D:하루전, -1M:한달전, -1Y:일년전), (+1D:하루후, +1M:한달후, +1Y:일년후)	
		    
		    
		$("tr.infoSchedule").click(function(){
		//	console.log($(this).html());
			var scheduleno = $(this).children(".scheduleno").text();
			goDetail(scheduleno);
		});
		
		// 검색 할 때 엔터를 친 경우
	    $("input#searchWord").keyup(function(event){
		   if(event.keyCode == 13){ 
			  goSearch();
		   }
	    });
	      
	    if(${not empty requestScope.paraMap}){
	    	  $("input[name=startdate]").val("${requestScope.paraMap.startdate}");
	    	  $("input[name=enddate]").val("${requestScope.paraMap.enddate}");
			  $("select#searchType").val("${requestScope.paraMap.searchType}");
			  $("input#searchWord").val("${requestScope.paraMap.searchWord}");
			  $("select#sizePerPage").val("${requestScope.paraMap.str_sizePerPage}");
			  $("select#fk_lgcatgono").val("${requestScope.paraMap.fk_lgcatgono}");
		}
		 
	    
	}); // end of $(document).ready(function(){}-------------
	
	
	// ~~~~~~~ Function Declartion ~~~~~~~
	
	function goDetail(scheduleno){
		var frm = document.goDetailFrm;
		frm.scheduleno.value = scheduleno;
		
		frm.method="get";
		frm.action="<%= ctxPath%>/schedule/detailSchedule.gw";
		frm.submit();
	} // end of function goDetail(scheduleno){}-------------------------- 
			

	// 검색 기능
	function goSearch(){
		
		if( $("#fromDate").val() > $("#toDate").val() ) {
			alert("검색 시작날짜가 검색 종료날짜 보다 크므로 검색할 수 없습니다.");
			return;
		}
	    
		if( $("select#searchType").val()=="" && $("input#searchWord").val()!="" ) {
			alert("검색대상 선택을 해주세요!!");
			return;
		}
		
		if( $("select#searchType").val()!="" && $("input#searchWord").val()=="" ) {
			alert("검색어를 입력하세요!!");
			return;
		}
		
		var frm = document.searchScheduleFrm;
        frm.method="get";
        frm.action="<%= ctxPath%>/schedule/searchSchedule.gw";
        frm.submit();
	}
	
	function excel(){
		if(${empty requestScope.scheduleList}){
			alert("검색을 해주세요.");
		}
		else{
			var frm = document.searchExcel;
			frm.method="post";
			frm.action="<%= ctxPath%>/downloadSearchExcelFile.gw";
			frm.submit();
		}
	}
	
	
</script>

<div style="margin-left: 80px; width: 88%; margin-top: 100px;">
	<div style="border:solid 0px gray;">
	
		<div style="text-align: center;">
            <h1 style="display: inline-block;">일정 검색</h1>
        </div>
		

		<div id="searchPart" style="margin-top: 50px;">
			
				<div id="searchDiv" >
				<form name="searchScheduleFrm">
				
					<div class="searchDiv2">
						<span class="searchSubject">달력분류</span>
						<select id="fk_lgcatgono" name="fk_lgcatgono" style="height: 30px; width: 700px;">
							<option value="">모든 캘린더</option>
							<option value="1">개인 캘린더</option>
							<option value="2">회사 캘린더</option>
							<option value="3">부서 캘린더</option>
						</select>&nbsp;&nbsp;	
					</div>
					
					<div class="searchDiv2">
						<span class="searchSubject">검색분류</span>
						<select id="searchType" name="searchType" style="height: 30px; width: 700px;">
							<option value="">검색대상선택</option>
							<option value="subject">제목</option>
							<option value="content">내용</option>
							<option value="joinuser">공유자</option>
						</select>&nbsp;&nbsp;
					</div>	
					
					<div class="searchDiv2">
						<span class="searchSubject">검색단어</span>
						<input type="text" id="searchWord" value="${requestScope.searchWord}" style="height: 30px; width:420px;" name="searchWord"/> 
						&nbsp;&nbsp;
						
						<select id="sizePerPage" name="sizePerPage" style="height: 30px; width:150px;">
							<option value="">보여줄개수</option>
							<option value="10">10</option>
							<option value="15">15</option>
							<option value="20">20</option>
						</select>&nbsp;&nbsp;
						<button type="button" class="btn_normal" style="display: inline-block; width:100px; background-color:rgb(3,199,90); font-weight:bold;" onclick="goSearch()">검색</button>
					</div>
					
					<div class="searchDiv2">
						<span class="searchSubject">검색기간</span>
					<i class="fa-solid fa-calendar-days fa-lg " style="margin-right:10px;" ></i><input type="text" id="fromDate" name="startdate" style="width: 300px;" readonly="readonly">&nbsp;&nbsp; 
	  				<i class="fa-solid fa-minus "></i>&nbsp;&nbsp;
	  				<i class="fa-solid fa-calendar-days fa-lg " style="margin-right:10px;" ></i><input type="text" id="toDate" name="enddate" style="width: 300px;" readonly="readonly">&nbsp;&nbsp;
	            	</div>
	            	
					<input type="hidden" name="fk_employee_id" value="${sessionScope.loginuser.employee_id}"/>
					<input type="hidden" name="fk_department_id" value="${sessionScope.loginuser.fk_department_id}"/>
					<input type="hidden" name="fk_email" value="${sessionScope.loginuser.email}"/>
					</form>
					
				</div>
			
		</div>
	</div>
		<div style="text-align:right; margin-top:50px;">
		<form name="searchExcel">
			<button style="margin-right:100px; background-color:rgb(43,61,79); color:white;"  type="button" onclick="excel()">검색결과 Excel 다운로드</button>
		</form>	
		</div>
	<table id="schedule" class="table table-hover" style="margin: 50px 0 30px 0;">
		<thead>
			<tr>
				<th style="text-align: center; width: 21%;">일자</th>
				<th style="text-align: center; width: 15%;">캘린더종류</th>
				<th style="text-align: center; width: 7%;">등록자</th>
				<th style="text-align: center; width: 22%">제목</th>
				<th style="text-align: center;">내용</th>
			</tr>
		</thead>
		
		<tbody>
			<c:if test="${empty requestScope.scheduleList}">
				<tr>
					<td colspan="5" style="text-align: center;">검색 결과가 없습니다.</td>
				</tr>
			</c:if>
			<c:if test="${not empty requestScope.scheduleList}">
				<c:forEach var="map" items="${requestScope.scheduleList}">
					<tr class="infoSchedule">
						<td style="display: none;" class="scheduleno">${map.SCHEDULENO}</td>
						<td>${map.STARTDATE} - ${map.ENDDATE}</td>
						<td style="padding-left:30px;">${map.LGCATGONAME} - ${map.SMCATGONAME}</td>
						<td style="padding-left:30px;">${map.NAME}</td>  <%-- 캘린더 작성자명 --%>
						<td style="padding-left:30px;">${map.SUBJECT}</td>
						<td style="padding-left:30px;">${map.CONTENT}</td>
					</tr>
				</c:forEach>
			</c:if>
		</tbody>
	</table>
	
	<div align="center" style="width: 70%; border: solid 0px gray; margin: 20px auto; ">${requestScope.pageBar} </div>
	
   <div style="margin-bottom: 20px; float:right;"><button style="background-color:rgb(43,61,79); color:white;" type="button" onclick="location.href='<%= ctxPath%>/schedule/scheduleManagement.gw'">뒤로가기</button>&nbsp;</div>
    
</div>

<form name="goDetailFrm"> 
   <input type="hidden" name="scheduleno"/>
   <input type="hidden" name="listgobackURL_schedule" value="${requestScope.listgobackURL_schedule}"/>
</form> 


      
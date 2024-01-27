<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    String ctxPath = request.getContextPath();
%>

<style type="text/css">
#container {width: 75%; margin:0 auto; margin-top:100px;}
#Navbar {margin-left: 2%; margin-right: 5%; width: 80%; background-size: cover; background-position: center; background-repeat: no-repeat; height: 70px;}
#Navbar > li > a {
	color: gray;
	font-weight: bold;
	font-size: 17pt;
}
#Navbar > li > a:hover {
	color: black;
}

/* 휴지통 버튼 */
i#deleteIcon {
  color: gray;
}

i#deleteIcon:hover {
  color: black;
  cursor: pointer;
}

/* 테이블 스타일 변경 */
div.listContainer {
	width: 93%; 
	margin: 0 auto; 
	padding: 20px; 
	border-radius: 10px;
	border-collapse: collapse;
    margin-bottom: 30px;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 12px 16px 0 rgba(0, 0, 0, 0.1);
    }
tr.table_tr {background-color: #ccff99; width: 94%;}
</style>

<script type="text/javascript">
$(document).ready(function(){
	$("td#listHide").hide();
	$("td#seqHide").hide();
});

// 근무신청 승인해주는 함수
function requestApproved(i){
	var seq = $("#seq"+i).val();
	$("input[name='requestApproveSeq']").val(seq);
	
	const frm = document.approveWork; 
	
	frm.method = "post";
	frm.action = "<%= ctxPath %>/approveWork.gw";
	frm.submit();
}

//근무신청 반려해주는 함수
function requestReturn(i){
	var seq = $("#seq"+i).val();
	$("input[name='requestApproveSeq']").val(seq);

	const frm = document.approveWork; 
	
	frm.method = "post";
	frm.action = "<%= ctxPath %>/requestReturn.gw";
	frm.submit();
}

//휴지통 클릭시 삭제하기
function deleteRequest(seq){
	var vac_approved = confirm("근무신청을 철회 하시겠습니까?");
	
	if(vac_approved) {
		$("input:hidden[name='work_request_seq']").val(seq);
		
		const frm = document.workDeleteFrm; 
		
		frm.method = "post";
		frm.action = "<%= ctxPath %>/work_request_delete.gw";
		frm.submit();
	}
}
</script>


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
	
	<!-- 내 근태 신청 내역 [시작] -->
   <div class='listContainer border mb-5 tblShadow'>
      <h5 class='mb-3 ml-5' style="font-weight: bold;">나의 근태 신청 내역</h5>
      <div class="max-form">
      <table class="table ml-5 text-center">
         <thead>
            <tr class='row table_tr'>
               	<th style='width: 40px;'>&nbsp;&nbsp;no</th>
               	<th class='col'>근무일자</th>
	        	<th class='col'>시작시간</th>
	            <th class='col'>종료시간</th>
	            <th class='col'>근무종류</th>
	            <th class='col'>장소</th>
	            <th class='col'>사유</th>
	            <th class='col'>신청일자</th>
	            <th class='col'>결재상태</th>
	            <th style='width: 35px;'></th>
            </tr>
         </thead>
         <tbody>
            <c:if test="${not empty requestScope.workRequestList}">
       		  <c:forEach var="workRequestList" items="${requestScope.workRequestList}" varStatus="status">
		        <tr class='row' style="width: 94%;" id='trSeq'>
		        	<td style='width: 40px;'>&nbsp;&nbsp;${status.index+1}</td>
		        	<td class='col'>${workRequestList.work_request_start_date}</td>
		        	<td class='col'>${workRequestList.work_request_start_time}</td>
		            <td class='col'>${workRequestList.work_request_end_time}</td>
		            
		            <c:choose>
						<c:when test="${workRequestList.work_request_type == '1'}"> 
							<td class='col'>외근</td>
						</c:when>	
						<c:when test="${workRequestList.work_request_type == '2'}"> 
							<td class='col'>출장</td>
						</c:when>
						<c:when test="${workRequestList.work_request_type == '3'}"> 
							<td class='col'>재택</td>
						</c:when>
					</c:choose>
					
		            <td class='col'>${workRequestList.work_request_place}</td>
		            <td class='col'>${workRequestList.work_request_reason}</td>
		            <td class='col'>${workRequestList.work_request_date}</td>
		            <td class='col' id="listHide">${workRequestList.fk_employee_id}</td>
		            <td class='col' id="seqHide">${workRequestList.work_request_seq}</td>
		            
		            <c:choose>
					   <c:when test="${workRequestList.work_request_confirm == '0'}"> 
						    <td class='col'>대기<i onclick="deleteRequest('${workRequestList.work_request_seq}')" class="fa-solid fa-trash-can ml-2" style="font-size:13pt;" id='deleteIcon'></i></td>
					   </c:when>	
					   <c:when test="${workRequestList.work_request_confirm == '1'}"> 
							<td class='col'>승인</td>
					   </c:when>
					   <c:when test="${workRequestList.work_request_confirm == '2'}"> 
							<td class='col'>반려</td>
					   </c:when>
					</c:choose>
		        </tr>	
	        </c:forEach>
	      </c:if>
        <c:if test="${empty requestScope.workRequestList}">
        	<tr>
        		<td class='col'>데이터가 없습니다.</td>
        	</tr>
        </c:if>
         </tbody>
      </table>
     </div>
   </div>
   <!-- 내 근태 신청 내역 [끝] -->
   
   
   <!-- 내 부서원의 근태 결제대기 내역[시작] -->
   <c:if test="${sessionScope.loginuser.gradelevel >= 5}">
   <div class='listContainer border mb-5 tblShadow'>
      <h5 class='mb-3 ml-5' style="font-weight: bold;">근태 결제대기 내역 (관리자용)</h5>
      <div class="max-form">
      <table class="table ml-5 text-center">
         <thead>
            <tr class='row table_tr'>
               	<th style='width: 40px;'>&nbsp;&nbsp;no</th>
               	<th class='col'>이름</th>
               	<th class='col'>근무일자</th>
	        	<th class='col'>시작시간</th>
	            <th class='col'>종료시간</th>
	            <th class='col'>근무종류</th>
	            <th class='col'>장소</th>
	            <th class='col'>사유</th>
	            <th class='col'>신청일자</th>
	            <th class='col'>승인or반려</th>
	            <th></th>
            </tr>
         </thead>
         <tbody>
            <c:if test="${not empty requestScope.myDeptRequestList}">
       		  <c:forEach var="myDeptRequestList" items="${requestScope.myDeptRequestList}" varStatus="status">
		        <tr class='row' style="width: 94%;">
		        	<td style='width: 40px;'>&nbsp;&nbsp;${status.index+1}</td>
		        	<td class='col'>${myDeptRequestList.name}</td>
		        	<td class='col'>${myDeptRequestList.work_request_start_date}</td>
		        	<td class='col'>${myDeptRequestList.work_request_start_time}</td>
		            <td class='col'>${myDeptRequestList.work_request_end_time}</td>
		            
		            <c:choose>
						<c:when test="${myDeptRequestList.work_request_type == '1'}"> 
							<td class='col'>외근</td>
						</c:when>	
						<c:when test="${myDeptRequestList.work_request_type == '2'}"> 
							<td class='col'>출장</td>
						</c:when>
						<c:when test="${myDeptRequestList.work_request_type == '3'}"> 
							<td class='col'>재택</td>
						</c:when>
					</c:choose>
		            <td class='col'>${myDeptRequestList.work_request_place}</td>
		            <td class='col'>${myDeptRequestList.work_request_reason}</td>
		            <td class='col'>${myDeptRequestList.work_request_date}</td>
		            <td class='col' id="listHide" class="employee_id">${myDeptRequestList.fk_employee_id}</td>
		            <td class='col' id="seqHide" class="work_request_seq">${myDeptRequestList.work_request_seq}</td>
		            <td class='col'><input type='button' onclick="requestApproved(${status.index+1})" value='승인'/><input type='button' onclick="requestReturn(${status.index+1})" value='반려' class="ml-1" /></td>
		        </tr>
		        <input type='hidden' value='${myDeptRequestList.fk_employee_id}' name='fk_employee_id'/>
		        <input type='hidden' id="seq${status.index+1}" value='${myDeptRequestList.work_request_seq}'/>
	        </c:forEach>
        </c:if>
        <c:if test="${empty requestScope.myDeptRequestList}">
        	<tr>
        		<td class='col'>데이터가 없습니다.</td>
        	</tr>
        </c:if>
         </tbody>
      </table>
      <form name="workRequestFrm">
      	 <input type="hidden" name="request_seq" />
      	 <input type="hidden" name="fk_employee_id" />
      </form>
      
      <form name='approveWork'>
		 <input type='hidden' name='requestApproveSeq' />
      </form>
      
      <form name="workDeleteFrm">
     	  <input type="hidden" name="work_request_seq"/>
      </form>
     </div>
   </div>
   </c:if>
   <!-- 내 부서원의 근태 결제대기 내역[끝] -->
   
   <!-- 내 부서원의 근태 결제승인 내역[시작] -->
   <c:if test="${sessionScope.loginuser.gradelevel >= 5}">
   <div class='listContainer border mb-5 tblShadow'>
      <h5 class='mb-3 ml-5' style="font-weight: bold;">근태 결제승인 내역 (관리자용)</h5>
      <div class="max-form">
      <table class="table ml-5 text-center">
         <thead>
            <tr class='row table_tr'>
               	<th style='width: 40px;'>&nbsp;&nbsp;no</th>
               	<th class='col'>이름</th>
               	<th class='col'>근무일자</th>
	        	<th class='col'>시작시간</th>
	            <th class='col'>종료시간</th>
	            <th class='col'>근무종류</th>
	            <th class='col'>장소</th>
	            <th class='col'>사유</th>
	            <th class='col'>신청일자</th>
	            <th></th>
            </tr>
         </thead>
         <tbody>
            <c:if test="${not empty requestScope.myDeptApprovedList}">
       		  <c:forEach var="myDeptApprovedList" items="${requestScope.myDeptApprovedList}" varStatus="status">
		        <tr class='row' style="width: 94%;">
		        	<td style='width: 40px;'>&nbsp;&nbsp;${status.index+1}</td>
		        	<td class='col'>${myDeptApprovedList.name}</td>
		        	<td class='col'>${myDeptApprovedList.work_request_start_date}</td>
		        	<td class='col'>${myDeptApprovedList.work_request_start_time}</td>
		            <td class='col'>${myDeptApprovedList.work_request_end_time}</td>
		            
		            <c:choose>
						<c:when test="${myDeptApprovedList.work_request_type == '1'}"> 
							<td class='col'>외근</td>
						</c:when>	
						<c:when test="${myDeptApprovedList.work_request_type == '2'}"> 
							<td class='col'>출장</td>
						</c:when>
						<c:when test="${myDeptApprovedList.work_request_type == '3'}"> 
							<td class='col'>재택</td>
						</c:when>
					</c:choose>
		            <td class='col'>${myDeptApprovedList.work_request_place}</td>
		            <td class='col'>${myDeptApprovedList.work_request_reason}</td>
		            <td class='col'>${myDeptApprovedList.work_request_date}</td>
		        </tr>
	        </c:forEach>
        </c:if>
        <c:if test="${empty requestScope.myDeptApprovedList}">
        	<tr>
        		<td class='col'>데이터가 없습니다.</td>
        	</tr>
        </c:if>
         </tbody>
      </table>
     </div>
   </div>
   </c:if>
   <!-- 내 부서원의 근태 결제대기 내역[끝] -->
   
   <!-- 내 부서원의 근태 결제반려 내역[시작] -->
   <c:if test="${sessionScope.loginuser.gradelevel >= 5}">
   <div class='listContainer border mb-5 tblShadow'>
      <h5 class='mb-3 ml-5' style="font-weight: bold;">근태 결제반려 내역 (관리자용)</h5>
      <div class="max-form">
      <table class="table ml-5 text-center">
         <thead>
            <tr class='row table_tr'>
               	<th style='width: 40px;'>&nbsp;&nbsp;no</th>
               	<th class='col'>이름</th>
               	<th class='col'>근무일자</th>
	        	<th class='col'>시작시간</th>
	            <th class='col'>종료시간</th>
	            <th class='col'>근무종류</th>
	            <th class='col'>장소</th>
	            <th class='col'>사유</th>
	            <th class='col'>신청일자</th>
	            <th></th>
            </tr>
         </thead>
         <tbody>
            <c:if test="${not empty requestScope.myDeptReturnList}">
       		  <c:forEach var="myDeptReturnList" items="${requestScope.myDeptReturnList}" varStatus="status">
		        <tr class='row' style="width: 94%;">
		        	<td style='width: 40px;'>&nbsp;&nbsp;${status.index+1}</td>
		        	<td class='col'>${myDeptReturnList.name}</td>
		        	<td class='col'>${myDeptReturnList.work_request_start_date}</td>
		        	<td class='col'>${myDeptReturnList.work_request_start_time}</td>
		            <td class='col'>${myDeptReturnList.work_request_end_time}</td>
		            
		            <c:choose>
						<c:when test="${myDeptReturnList.work_request_type == '1'}"> 
							<td class='col'>외근</td>
						</c:when>	
						<c:when test="${myDeptReturnList.work_request_type == '2'}"> 
							<td class='col'>출장</td>
						</c:when>
						<c:when test="${myDeptReturnList.work_request_type == '3'}"> 
							<td class='col'>재택</td>
						</c:when>
					</c:choose>
		            <td class='col'>${myDeptReturnList.work_request_place}</td>
		            <td class='col'>${myDeptReturnList.work_request_reason}</td>
		            <td class='col'>${myDeptReturnList.work_request_date}</td>
		        </tr>
	        </c:forEach>
        </c:if>
        <c:if test="${empty requestScope.myDeptReturnList}">
        	<tr>
        		<td class='col'>데이터가 없습니다.</td>
        	</tr>
        </c:if>
         </tbody>
      </table>
     </div>
   </div>
   </c:if>
   <!-- 내 부서원의 근태 결제반려 내역[끝] -->
</div>






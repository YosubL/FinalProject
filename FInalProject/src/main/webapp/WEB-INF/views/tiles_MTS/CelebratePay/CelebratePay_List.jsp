<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<% String ctxPath = request.getContextPath(); %>   
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

    
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
	span{
		vertical-align: middle;
	}
	
    
    #viewDetailinfo{
	    position: fixed;
		left: -5%;
		top: 5%;
 	}
 	#mycontent > div:nth-child(8) > table > thead > tr > th:nth-child(1)~*{
    	white-space: nowrap;
	}
	
	#mycontent > div:nth-child(6) > table > thead > tr > th:nth-child(1)~*{
	white-space: nowrap;
	}

	#mycontent > div:nth-child(7) > table > thead > tr{
		white-space: nowrap;
	}
	.table-bordered.table-sm th {
        background-color: #3eb543; 
        color: white; 
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
	
	#mycontent > div:nth-child(3) > h4{
		font-weight:bold;
		font-size:35px;
		margin-left:45px;
	}
	
	#delete_button{
		color:white;
		background-color:#d71a1a;
	}
 	
</style>

<script>

	$(document).ready(function(){
		
		 $('.eachmenu1').show();
		
		// 삭제 버튼 클릭시 삭제하기
   		$("#delete_button").click(function() {
   			var vac_approved = confirm("신청 취소 하시겠습니까?");
			if(vac_approved) {
				// 승인 대기중인 복지포인트 목록 하나 삭제하기
		   		const seq_frm = $("input:hidden[id='seq_frm']").val();
		   		$("input:hidden[name='app_no']").val(seq_frm);
		   		
				const frm = document.seq_delete; 
				frm.method = "post";
				frm.action = "<%= ctxPath %>/celebrate_delete.gw";
				frm.submit();
			}
   		});
	}); // end of $(document).ready(function(){
		
		
</script>


<div style='margin: 1% 0 5% 1%; width: 95%;' >
	<h4>나의 복지 포인트 목록 </h4>
	
	<nav class="navbar navbar-expand-lg mt-5 mb-4">
		<div class="collapse navbar-collapse">
			<ul class="navbar-nav" id="Navbar">
				<li class="nav-item">
					<a class="nav-link" href="<%= ctxPath %>/CelebratePay.gw">복지 포인트 신청</a>
				</li>
				
				<li class="nav-item">
					<a class="nav-link ml-5" href="<%= ctxPath %>/celebrateList.gw">나의 복지포인트 목록</a>
				</li>
				
				<c:if test="${sessionScope.loginuser.gradelevel >= 10}">
					<li class="nav-item">
						<a class="nav-link ml-5" href="<%= ctxPath %>/CelebratePayStatus.gw">(관리자 전용)복지포인트 신청 승인 맟 반려 결제 </a>
					</li>
					
					<li class="nav-item">
						<a class="nav-link ml-5" href="<%= ctxPath %>/CelebrateComplete.gw">(관리자 전용)복지포인트 신청 승인 및 반려 결제 취소</a>
					</li>
				</c:if>
			</ul>
		</div>
	</nav>
</div>
	
	<div class='m-4' style="margin: 7% 0% 3% 0%; width: 95%;" >
		<h5>복지 포인트 신청목록</h5>
		<table class="table table-bordered table-sm ">
			<thead>
				<tr>
					<th>증명서번호</th>
					<th>사원번호</th>
					<th>부서이름</th>
					<th>직급</th>
					<th>사원이름</th>
					<th>경조구분</th>
					<th>복지포인트</th>
					<th>전자결재상태</th>
					<th>신청일</th>
					<th>신청 취소</th>
				</tr>
			</thead>
			<tbody>  
			<c:if test="${not empty requestScope.CelebratePay_HoldList}">
				<c:forEach var="celebListItem" items="${requestScope.CelebratePay_HoldList}" varStatus="status">
				        <tr class="text-center border">
				            <td>${celebListItem.app_no}</td>
				            <td>${celebListItem.fk_employee_id}</td>
				            <td>${celebListItem.department_name}</td>
				            <td>${celebListItem.title}</td>
				            <td>${celebListItem.name}</td>
				            <td>
				                <c:choose>
				                    <c:when test="${celebListItem.celebrate_type eq '1'}">명절 상여 복지 포인트</c:when>
				                    <c:when test="${celebListItem.celebrate_type eq '2'}">생일 상여 복지 포인트</c:when>
				                    <c:otherwise>휴가 상여 복지 포인트</c:otherwise>
				                </c:choose>
				            </td>
				            <td><fmt:formatNumber value="${celebListItem.app_pay}" pattern="#,###" /></td>
				            <td>
				                <c:choose>
				                    <c:when test="${celebListItem.app_status eq '0'}">미승인</c:when>
				                    <c:otherwise>승인완료</c:otherwise>
				                </c:choose>
				            </td>
				            <td>${fn:substring(celebListItem.app_date, 0, 10)}</td>
				            <td class='col col-1' id="vacDelete"><button id = "delete_button">삭제</button></td>
				        </tr>
				        <input type="hidden" value="${celebListItem.app_no}" id="seq_frm"/>
				</c:forEach>
			</c:if>
			<c:if test="${empty requestScope.CelebratePay_HoldList}">
		        <tr>
		        	<td class='col'>데이터가 없습니다.</td>
		        </tr>
		    </c:if>
			</tbody>
		</table>
	</div>
	
	
	<div class='m-4' style="margin: 7% 0% 3% 0%; width: 95%;" >
		<h5>복지 포인트 승인 완료 목록</h5>
		<table class="table table-bordered table-sm ">
			<thead>
				<tr>
					<th>증명서번호</th>
					<th>사원번호</th>
					<th>부서이름</th>
					<th>직급</th>
					<th>사원이름</th>
					<th>경조구분</th>
					<th>복지포인트</th>
					<th>전자결재상태</th>
					<th>신청일</th>
				</tr>
			</thead>
			<tbody>  
			<c:if test="${not empty requestScope.CelebratePay_completeList}">
				<c:forEach var="celebListItem2" items="${requestScope.CelebratePay_completeList}" varStatus="status">
				        <tr class="text-center border">
				            <td>${celebListItem2.app_no}</td>
				            <td>${celebListItem2.fk_employee_id}</td>
				            <td>${celebListItem2.department_name}</td>
				             <td>${celebListItem2.title}</td>
				            <td>${celebListItem2.name}</td>
				            
				            <td>
				                <c:choose>
				                    <c:when test="${celebListItem2.celebrate_type eq '1'}">명절 상여 복지 포인트</c:when>
				                    <c:when test="${celebListItem2.celebrate_type eq '2'}">생일 상여 복지 포인트</c:when>
				                    <c:otherwise>휴가 상여 복지 포인트</c:otherwise>
				                </c:choose>
				            </td>
				            <td><fmt:formatNumber value="${celebListItem2.app_pay}" pattern="#,###" /></td>
				            <td>
				                <c:choose>
				                    <c:when test="${celebListItem2.app_status eq '1'}">승인완료</c:when>
				                    <c:otherwise>미승인</c:otherwise>
				                </c:choose>
				            </td>
				            <td>${fn:substring(celebListItem2.app_date, 0, 10)}</td>
				        </tr>
				</c:forEach>
			</c:if>
			<c:if test="${empty requestScope.CelebratePay_completeList}">
		        <tr>
		        	<td class='col'>데이터가 없습니다.</td>
		        </tr>
		    </c:if>
			</tbody>
		</table>
	</div>
	
	<div class='m-4' style="margin: 7% 0% 3% 0%; width: 95%;" >
	<h5>복지 포인트 승인 반려 목록</h5>
		<table class="table table-bordered table-sm ">
			<thead>
				<tr>
					<th>증명서번호</th>
					<th>사원번호</th>
					<th>부서이름</th>
					<th>직급</th>
					<th>사원이름</th>
					<th>경조구분</th>
					<th>복지포인트</th>
					<th>전자결재상태</th>
					<th>신청일</th>
				</tr>
			</thead>
			<tbody>  
			<c:if test="${not empty requestScope.CelebratePay_rejectList}">
				<c:forEach var="celebListItem3" items="${requestScope.CelebratePay_rejectList}" varStatus="status">
				        <tr class="text-center border">
				            <td>${celebListItem3.app_no}</td>
				            <td>${celebListItem3.fk_employee_id}</td>
				            <td>${celebListItem3.department_name}</td>
				             <td>${celebListItem3.title}</td>
				            <td>${celebListItem3.name}</td>
				            
				            <td>
				                <c:choose>
				                    <c:when test="${celebListItem3.celebrate_type eq '1'}">명절 상여 복지 포인트</c:when>
				                    <c:when test="${celebListItem3.celebrate_type eq '2'}">생일 상여 복지 포인트</c:when>
				                    <c:otherwise>휴가 상여 복지 포인트</c:otherwise>
				                </c:choose>
				            </td>
				            <td><fmt:formatNumber value="${celebListItem3.app_pay}" pattern="#,###" /></td>
				            <td>
				                <c:choose>
				                    <c:when test="${celebListItem3.app_status eq '2'}">승인반려</c:when>
				                    <c:otherwise>미승인</c:otherwise>
				                </c:choose>
				            </td>
				            <td>${fn:substring(celebListItem3.app_date, 0, 10)}</td>
				        </tr>
				</c:forEach>
			</c:if>
			<c:if test="${empty requestScope.CelebratePay_rejectList}">
		        <tr>
		        	<td class='col'>데이터가 없습니다.</td>
		        </tr>
		    </c:if>
			</tbody>
		</table>
	</div>
	
  <form name="seq_delete">
      	<input type="hidden" name="app_no"/>
  </form>






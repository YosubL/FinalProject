<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<% String ctxPath=request.getContextPath(); %>
<style>

a {
	color: black;
}

a:hover {
	text-decoration: none;
}


.listContainer {
	font-size: small;
	margin-bottom: 5%;
}

.approveThis {
	text-align: center;
	background-color: #E0F8EB;
}

.activeBtn {
	color: white;
	background-color: #03c75a;
	cursor: pointer;
}

.card-deck {
	font-size: small;
}

.card-deck:hover {
	cursor: pointer;
}

</style>	

<script>

$(document).ready(function(){
	// 사이드바 메뉴 글씨색 변경
	$('a#home').css('color','#03c75a');
	
	// 결재대기문서 카드에 hover시 색상 변경
	$('div.card').hover(function() {
        $(this).find('.approveThis').addClass('activeBtn');
    }, function() {
        $(this).find('.approveThis').removeClass('activeBtn');
    });

}); // end of $(document).ready(function(){})-----------------
</script>
	
<div style='margin: 1% 0 5% 1%'>
	<h4>전자결재</h4>
</div>

<div class='m-4'>

	<c:if test="${sessionScope.loginuser.gradelevel != 1}">
	<div class='listContainer'>
		<h5 class='mb-3'>결재 대기 문서</h5>
		<h6 class='mb-3'>결재해야 할 문서가 <span style='color:#03c75a'>${requestedDraftCnt}</span>건 있습니다.</h6>
		
		<div class='card-deck'>
			<c:if test="${not empty requestedDraftList}">
				<c:forEach items="${requestedDraftList}" var="rdraft">
					<div class="card p-0 mr-3" onclick="location.href='<%=ctxPath%>/approval/draftDetail.gw?draft_no=${rdraft.draft_no}&fk_draft_type_no=${rdraft.fk_draft_type_no}'">
					  <div class="card-body">
					  	<h5 class="title m-0">${rdraft.draft_subject}&nbsp;&nbsp;
					  	<c:if test="${rdraft.urgent_status == '1'}"><span style='font-size:x-small;' class="badge badge-pill badge-danger">긴급</span></c:if>
					  	</h5><br>
					  	문서번호: <span class='draft_no'>${rdraft.draft_no}</span><br>
					  	기안자: <span class='draft_emp_name'>${rdraft.draft_emp_name}</span><br>
					  	기안일: <span class='draft_date'>${fn:substring(rdraft.draft_date,0,10)}</span><br>
					  	종류: <span class='draft_type'>${rdraft.draft_type}</span>
					  </div>
					  <div class="card-footer approveThis">결재하기</div>
					</div>
				</c:forEach>
			</c:if>
		</div>
			<div class='text-right mr-2 mt-4 more'>
			<a href='<%=ctxPath%>/approval/requested.gw'><i class="fas fa-angle-double-right"></i> 더보기</a>
		</div>
	</div>
	</c:if>
	<div class='listContainer'>
		<h5 class='mb-3'>기안 진행 문서</h5>
		<h6 class='mb-3'>진행 중인 문서가 <span style='color:#03c75a'>${fn:length(processingDraftList)}</span>건 있습니다.</h6>
		<table class="table">
			<thead>
				<tr class='row'>
					<th class='col col-1'>기안일</th>
					<th class='col col-1'>종류</th>
					<th class='col col-2'>문서번호</th>
					<th class='col'>제목</th>
				</tr>
			</thead>
			<tbody>
				<c:choose>
               		<c:when test="${not empty processingDraftList}">
                    <c:forEach items="${processingDraftList}" var="processing" end="4">
                        <tr class='row'>
							<td class='col col-1'>${fn:substring(processing.draft_date, 0, 10)}</td>
                            <td class='col col-1'>${processing.draft_type}</td>
                            <td class='col col-2'>${processing.draft_no}</td>
                            <td class='col'>
                            <a href='<%=ctxPath%>/approval/draftDetail.gw?draft_no=${processing.draft_no}&fk_draft_type_no=${processing.fk_draft_type_no}'>
                            <c:if test="${processing.urgent_status == '1'}"><span style='font-size:x-small;' class="badge badge-pill badge-danger">긴급</span></c:if>
                            ${processing.draft_subject}</a></td>
                        </tr>
                    </c:forEach>
                	</c:when>
                <c:otherwise>
                    <tr>
                        <td colspan='6' class='text-center'>진행 중인 문서가 없습니다.</td>
                    </tr>
                </c:otherwise>            
            </c:choose>
			</tbody>
		</table>
		<div class='text-right mr-2 mt-4 more'>
			<a href='<%=ctxPath%>/approval/personal/sent.gw'><i class="fas fa-angle-double-right"></i> 더보기</a>
		</div>

	</div>
	<div class='listContainer'>
		<h5 class='mb-3'>결재 완료 문서</h5>

		<table class="table">
			<thead>
				<tr class='row'>
					<th class='col col-1'>결재완료일</th>
					<th class='col col-1'>종류</th>
					<th class='col col-2'>문서번호</th>
					<th class='col'>제목</th>
					<th class='col col-1'>기안일</th>
					<th class='col col-1'>결재상태</th>
				</tr>
			</thead>
			<tbody>
				<c:choose>
               		<c:when test="${not empty processedDraftList}">
                    <c:forEach items="${processedDraftList}" var="processed" >
                        <tr class='row'>
							<td class='col col-1'>${fn:substring(processed.approval_date, 0, 10)}</td>
                            <td class='col col-1'>${processed.draft_type}</td>
                            <td class='col col-2'>${processed.draft_no}</td>
                            <td class='col'>
                            <a href='<%=ctxPath%>/approval/draftDetail.gw?draft_no=${processed.draft_no}&fk_draft_type_no=${processed.fk_draft_type_no}'>
                            <c:if test="${processed.urgent_status == '1'}"><span style='font-size:x-small;' class="badge badge-pill badge-danger">긴급</span></c:if>
                            ${processed.draft_subject}</a></td>
							<td class='col col-1'>${fn:substring(processed.draft_date, 0, 10)}</td>
                            <td class='col col-1'>
                            	<c:if test="${processed.draft_status == '1'}">
	                            	<span class="badge badge-secondary">완료</span>
                            	</c:if>
                            	<c:if test="${processed.draft_status == '2'}">
                            		<span class="badge badge-danger">반려</span>
                            	</c:if>
                            </td>
                        </tr>
                    </c:forEach>
                	</c:when>
                <c:otherwise>
                    <tr>
                        <td colspan='6' class='text-center'>진행 중인 문서가 없습니다.</td>
                    </tr>
                </c:otherwise>            
            </c:choose>
			</tbody>
		</table>
		<div class='text-right mr-2 mt-4 more'>
			<a href='<%=ctxPath%>/approval/personal/sent.gw'><i class="fas fa-angle-double-right"></i> 더보기</a>
		</div>
	</div>
  
</div>
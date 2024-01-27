<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% String ctxPath = request.getContextPath(); %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
#goWriteBtn:hover{
	border: 1px solid #03C75A;
	color: white;
	background-color: #03C75A;
}

/* 색상 변경 */
.formChoice {
  accent-color: green;
}

.topMenu:hover {
	cursor: pointer;
}

#okBtn {
	background-color: #03C75A;
	color: white;
}

#okBtn:hover {
	background-color: #E0F8EB;
	color: #03C75A;
}

.modal-body > div {
	display: table-row-group;
}

label:hover {
	cursor: pointer;
	background-color: #E0F8EB;
}
</style>

<script>
$(document).ready(function(){
	// 사이드 메뉴 닫기
	$(".subMenus").hide(); 
	
	// 메뉴 선택시 다른 메뉴 닫기      
    $(".topMenu").click(function(e) {
        const target = $(e.target.children[0]); // 클릭이 일어난 태그의 자식태그 중 첫번째 태그를 뜻함
        if ($(target).is(":visible")) { // 요소가 화면에 보이는 상태인지 확인한다.
           $(".subMenus").slideUp("fast"); // 위로 숨김
        }
        else { // 요소가 화면에 보이지 않는다면
           $(".subMenus").slideUp("fast"); // 위로 숨김 
           $(target).slideToggle("fast"); // 보이거나 숨긴다.
        }
        
    });
});

function selectApv() {
	$('#selectApvForm').modal();
};

function goWriteForm() {
	const forms = Array.from($('.formChoice')); // class 값이 .formChoice 인 태그들을 유사 배열 객체로 만든다.
	const selected = forms.filter(el => $(el).is(':checked'))[0].id; // .filter 태그는 데이터 집합에서 특정 조건을 만족하는 값만 반환한다. 이 경우는 유사배열에서 체크된 값을 가져온다.
	
	location.href="<%=ctxPath%>/approval/write.gw?type_no="+selected;
}
</script>

<!-- A vertical navbar -->
<nav class="navbar bg-light">

 	<!-- Links -->
	<ul class="navbar-nav" style='width:100%'>
	<li class="nav-item">
		<h4 class='mb-4'>전자결재</h4>
	</li>
	<li class="nav-item mb-4">

	<button id="goWriteBtn" type="button" style='width:100%' class="btn btn-outline-dark"  onclick="selectApv()">기안문서 작성</button>

    </li>
    <li class="nav-item">
		<a id="home" class="nav-link" href="<%=ctxPath%>/approval/home.gw">홈</a>
    </li>
    <c:if test="${sessionScope.loginuser.gradelevel != 1}">
    <li class="nav-item topMenu">결재하기
    	<ul class='subMenus processingMenu'>
     		<li><a id="requestedList" class="nav-link" href="<%=ctxPath%>/approval/requested.gw">결재 대기 문서</a></li>
     		<c:if test="${sessionScope.loginuser.gradelevel > 3}">
     		<li><a id="upcomingList" class="nav-link" href="<%=ctxPath%>/approval/upcoming.gw">결재 예정 문서</a></li>
     		</c:if>     	
  		</ul>
    </li>
    </c:if>
    <li style="margin-top: 7px;" class="nav-item topMenu">개인 문서함
		<ul class='subMenus personalMenu'>
     		<li><a id="sentList" class="nav-link" href="<%=ctxPath%>/approval/personal/sent.gw">상신함</a></li>
     		<c:if test="${sessionScope.loginuser.gradelevel != 1}">
     		<li><a id="processedList" class="nav-link" href="<%=ctxPath%>/approval/personal/processed.gw">결재함</a></li>
     		</c:if>
     		<li><a id="savedList" class="nav-link" href="<%=ctxPath%>/approval/personal/saved.gw">임시저장함</a></li>
     	</ul>
    </li>
    <li class="nav-item">
		<a id="teamList" class="nav-link" href="<%=ctxPath%>/approval/department.gw">부서 문서함</a>
    </li>
    <li class="nav-item topMenu">환경설정
      	<ul class='subMenus configMenu'>
      		<li style="margin-top: 7px;"><a id="approvalLine" class="nav-link" href="<%=ctxPath%>/approval/config/approvalLine.gw">결재라인</a></li>
      		<li><a id="signature" class="nav-link" href="<%=ctxPath%>/approval/config/signature.gw">서명 관리</a></li>
      	</ul>
    </li>
	<c:if test="${loginuser != null && loginuser.gradelevel > 3 && loginuser.fk_department_id == '200'}">
    <li style="margin-top: 7px;" class="nav-item topMenu">관리자메뉴
      	<ul class='subMenus adminMenu'>
      		<li style="margin-top: 7px;"><a id="officialApprovalLine" class="nav-link" href="<%=ctxPath%>/approval/admin/officialApprovalLine.gw">공통 결재라인 설정</a></li>
      	</ul>
    </li>
	</c:if>
  </ul>

</nav>

<!-- 결재양식 선택 모달 -->
<div class="modal text-left" id="selectApvForm">
	<div class="modal-dialog modal-dialog-centered ">
		<div class="modal-content">

	<!-- Modal Header -->
	<div class="modal-header">
		<h5 class="modal-title">결재양식 선택</h5>
		<button type="button" class="close" data-dismiss="modal">&times;</button>
	</div>

	<!-- Modal body -->
	<div class="modal-body" style='display: table'>
		<div>
			<input type="radio" id="1" name="formChoice" class='formChoice mr-3'>
			<label for='1'>업무품의</label>
		</div>
		<div>
			<input type="radio" id="2" name="formChoice" class='formChoice mr-3'>
			<label for='2'>지출결의서</label>
		</div>
		<div>
			<input type="radio" id="3" name="formChoice" class='formChoice mr-3'>
			<label for='3'>출장보고서</label>
		</div>
	</div>

	<!-- Modal footer -->
	<div class="modal-footer">
		<button type="button" id='calcelBtn' class="btn btn-secondary" data-dismiss="modal">취소</button>
		<button type="button" id='okBtn' class="btn" data-dismiss="modal" onclick='goWriteForm()'>확인</button>
			</div>
		</div>
	</div>
</div>
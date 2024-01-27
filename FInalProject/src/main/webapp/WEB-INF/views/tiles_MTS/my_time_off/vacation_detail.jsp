<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
   String ctxPath = request.getContextPath();
%>

<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

<link href="https://fonts.googleapis.com/icon?family=Material+Icons+Outlined" rel="stylesheet">

<style type="text/css">
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
   
   div.listContainer {
      font-size: small;
      margin-bottom: 5%;
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
	
	/* 버튼 스타일링 */
	input[type="button"], input#return_insert {
	  padding: 6px 15px; /* 버튼 내부 여백 설정 */
	  cursor: pointer; /* 커서 모양 설정 */
	  background-color: #00ace6; /* 배경 색상 설정 */
	  color: #fff; /* 글자 색상 설정 */
	  border: none; /* 테두리 제거 */
	  border-radius: 5px; /* 테두리 반경 설정 */
	  transition: background-color 0.3s; /* 배경 색상 전환 효과 설정 */
	  position: relative;
	  bottom: 5px;
	}
	
	/* 마우스 호버 시 배경 색상 변경 */
	input[type="button"]:hover, input#return_insert:hover {
	  background-color: #0086b3;
	}
	
	/* 휴지통 버튼 */
	i#deleteIcon {
	  color: gray;
	}
	
	i#deleteIcon:hover {
	  color: black;
	  cursor: pointer;
	}
	
	/* 두 번째 버튼에 대한 추가적인 스타일링 */
	input#return_reset {
	  padding: 6px 15px; /* 버튼 내부 여백 설정 */
	  cursor: pointer; /* 커서 모양 설정 */
	  background-color: #f44336; /* 두 번째 버튼의 배경 색상 설정 */
	  color: #fff; /* 글자 색상 설정 */
	  border: none; /* 테두리 제거 */
	  border-radius: 5px; /* 테두리 반경 설정 */
	  transition: background-color 0.3s; /* 배경 색상 전환 효과 설정 */
	  position: relative;
	  bottom: 5px;
	}
	
	input#return_reset:hover {
	  background-color: #d32f2f; /* 두 번째 버튼의 호버 시 배경 색상 변경 */
	}
	
	/* 모달관련 css */
	.modal {
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
    
    /* 모달관련 css */
    .modal span {
	    position: absolute;
	    top: 0;
	    right: 0;
	    padding: 10px;
	    cursor: pointer;
	}
	
	/* 모달관련 css */
	.modal span:hover {
	    background-color: #f1f1f1;
	}
	.maxHight {
	    height: 200px;  
	    max-height: 300px; /* 최대 높이 설정 */
	    overflow-y: auto; /* 세로 스크롤 적용 */
	    overflow-x: hidden; /* 가로 스크롤 비활성화 */
	}
	div#container {width: 75%; margin:0 auto; margin-top:100px;}
	nav.navbar {margin-left: 2%; margin-right: 5%; width: 80%; background-size: cover; background-position: center; background-repeat: no-repeat; height: 70px}
	.table_tr {background-color: #ccff99;}
	table.table ml-5 {width: 90%;}
	input#frm_vacation_reason {border: solid 1px gray;}
	input[name='frm_vacation_reason'] {border: solid 1px gray;}
</style>

<script type="text/javascript">
   	$(document).ready(function(){
      	
   		// 해당 행을 클릭하면 모달창을 띄움
	   	$("input#openModal").click(function (e) {
	   		// 가져온 값들을 정의
	   		const vacation_seq = $("input:hidden[name='send_seq']").val();					// 휴가 번호
	   		const name = $("input:hidden[name='send_name']").val();							// 신청자 성명
	   		const fk_employee_id = $("input:hidden[name='send_fk_employee_id']").val();		// 신청자 사원번호
	   		const start_date = $("input:hidden[name='send_start_date']").val();				// 시작 일자
	   		const end_date = $("input:hidden[name='send_end_date']").val();					// 종료 일자
	   		const reg_date = $("input:hidden[name='send_reg_date']").val();					// 신청 일자
	   		const return_date = $("input:hidden[name='send_return_date']").val();			// 반려 일자
	   		const confirm = $("input:hidden[name='send_confirm']").val();					// 결재 상태
	   		const type = $("input:hidden[name='send_type']").val();							// 휴가 종류
	   		const manager_name = $("input:hidden[name='send_manager_name']").val();			// 결재자 성명
	   		const manager = $("input:hidden[name='send_manager']").val();					// 결재자 사원번호
	   		const return_reason = $("input:hidden[name='send_return_reason']").val();		// 반려사유
	   		
	   		const type_text = $('tr#empinfo td:nth-child(4)').text(); // 휴가종류를 텍스트로 뽑은것
    	  	// alert(type_text); // 결혼휴가
	   		
	   		// 값 꽂아주기
	   		$("td#frm_name").text(name);
	   		$("td#frm_employee_id").text(fk_employee_id);
	   		$("input:text[name='frm_vacation_start_date']").val(start_date);
	   		$("input:text[name='frm_vacation_end_date']").val(end_date);
	   		$("td#frm_vacation_reg_date").text(reg_date);
	   		$("td#frm_vacation_return_date").text(return_date);
	   		$("td#frm_vacation_confirm").text(confirm);
	   		
	   		$("td#frm_manager_name").text(manager_name);
	   		$("td#frm_return_reason").text(return_reason);
	   		
	   		// 모달창 내 휴가종류 값 꽂아주기
	   		if(type==1) {
	   			$("td#frm_vacation_type").text("연차휴가");
	   		}
	   		if(type==2) {
	   			$("td#frm_vacation_type").text("가족돌봄휴가");
	   		}
	   		if(type==3) {
	   			$("td#frm_vacation_type").text("군소집훈련휴가");
	   		}
	   		if(type==4) {
	   			$("td#frm_vacation_type").text("난임치료휴가");
	   		}
	   		if(type==5) {
	   			$("td#frm_vacation_type").text("배우자출산휴가");
	   		}
	   		if(type==6) {
	   			$("td#frm_vacation_type").text("결혼휴가");
	   		}
	   		if(type==7) {
	   			$("td#frm_vacation_type").text("포상휴가");
	   		}
	   		
	   		// 모달창 내에서 보낼 값 꽂아주기
	   		$("input:hidden[name='vacation_seq']").val(vacation_seq);
	   		$("input:hidden[name='vacation_type']").val(type);
	   		$("input:hidden[name='vacation_manager_name']").val(manager_name);
	   		$("input:hidden[name='manager_id']").val(manager);
	   		$("input:hidden[name='employee_id']").val(fk_employee_id);
	   		
    	  	$('div#openModal').modal('show', vacation_seq); // 모달창에 태워서 보낼 해당 항목의 seq
    	  	
    	 	// 휴가신청시 띄울 달력 
        	$(function() {
                // 서버에서 가져온 현재 날짜를 JavaScript 변수로 설정
                const currentDate = "${currentDate}";

                // datepicker에 오늘 날짜를 설정
                $("input:text[name='frm_vacation_start_date']").datepicker({
                    dateFormat: "yy-mm-dd",
                    defaultDate: currentDate
                });
                $("input:text[name='frm_vacation_end_date']").datepicker({
                    dateFormat: "yy-mm-dd",
                    defaultDate: currentDate
                });
            });
    	  	
    	 	// 승인 버튼 클릭시 tbl_vacation 테이블에 update
    		$("input#return_insert").click(function(){
    		    const frm = document.modal_frm; 
				frm.method = "post";
				frm.action = "<%= ctxPath %>/vac_insert_insert.gw";
				frm.submit();	
    		});
      	}); // end of $(document).on("click", "table#emptbl tr#empinfo", function (e) -----------------
      
	 	// return_reset 버튼 클릭 시 모달 닫기
   		$("input#return_reset").click(function(){
   		    closeModal();
   		});

   		// 모달이 닫힐 때 입력값 초기화
   		$('div#openModal').on('hidden.bs.modal', function () {
   		    document.getElementById("modal_frm").reset();
   		});
   		
   		// 휴지통 클릭시 삭제하기
   		$("i#deleteIcon").click(function() {
   			var vac_approved = confirm("휴가 철회 하시겠습니까?");
			if(vac_approved) {
				// 승인 대기중인 휴가 삭제하기
		   		const seq_frm = $("input:hidden[id='seq_frm']").val();
		   		$("input:hidden[name='vacation_seq']").val(seq_frm);
		   		
				const frm = document.seq_delete; 
				frm.method = "post";
				frm.action = "<%= ctxPath %>/seq_delete.gw";
				frm.submit();
			}
   		}); 
   	});// end of $(document).ready(function(){})--------
   
    // Function Decalation
	function closeModal() {
	    $('div#openModal').modal('hide');
	}
</script>

<div id="container">
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
   <%-- 상단 메뉴바 [끝] --%>
   
   <%-- 승인대기중인휴가 [시작] --%>
   <div class='listContainer border mb-5'>
   	
      <h5 class='mb-3 ml-5' style="font-weight: bold;">승인 대기중인 휴가</h5>
	  <div class='maxHight'>
      <table class="table ml-5">
         <thead>
            <tr class='row table_tr'>
               	<th class='col col-1'>no</th>
	        	<th class='col col-1'>이름</th>
	            <th class='col col-2'>신청휴가종류</th>
	            <th class='col col-2'>사유</th>
	            <th class='col'>신청일</th>
	            <th class='col'>시작일</th>
	            <th class='col'>종료일</th>
	            <th class='col col-1'>결재상태</th>
	            <th class='col col-1'></th>
            </tr>
         </thead>
         
         <tbody>
            <c:if test="${not empty requestScope.myHoldList}">
            	<c:forEach var="List" items="${requestScope.myHoldList}" varStatus="status">
			        <tr class='row'>
			        	<td class='col col-1'>${status.index+1}</td>
			        	<td class='col col-1'>${List.name}</td>
			            <c:choose>
							<c:when test="${List.vacation_type == '1'}"> 
								<td class='col col-2' id="type_text">연차</td>
							</c:when>	
							<c:when test="${List.vacation_type == '2'}"> 
								<td class='col col-2' id="type_text">가족돌봄휴가</td>
							</c:when>
							<c:when test="${List.vacation_type == '3'}"> 
								<td class='col col-2' id="type_text">예비군휴가</td>
							</c:when>
							<c:when test="${List.vacation_type == '4'}"> 
								<td class='col col-2' id="type_text">난임치료휴가</td>
							</c:when>
							<c:when test="${List.vacation_type == '5'}"> 
								<td class='col col-2' id="type_text">출산휴가</td>
							</c:when>
							<c:when test="${List.vacation_type == '6'}"> 
								<td class='col col-2' id="type_text">결혼휴가</td>
							</c:when>
							<c:when test="${List.vacation_type == '7'}"> 
								<td class='col col-2' id="type_text">포상휴가</td>
							</c:when>
						</c:choose>
			            <td class='col col-2'>${List.vacation_reason}</td>
			            <td class='col'>${List.vacation_reg_date}</td>
			            <td class='col'>${List.vacation_start_date}</td>
			            <td class='col'>${List.vacation_end_date}</td>
			            <c:choose>
			            	<c:when test="${List.vacation_confirm == '1'}">
			            		<td class='col col-1'>대기</td>
			            	</c:when>
			            	<c:when test="${List.vacation_confirm == '2'}">
			            		<td class='col col-1'>승인</td>
			            	</c:when>
			            	<c:when test="${List.vacation_confirm == '3'}">
			            		<td class='col col-1'>반려</td>
			            	</c:when>
			            </c:choose>
			            <td class='col col-1' id="vacDelete"><i class="fa-solid fa-trash-can" style="font-size:13pt;" id="deleteIcon"></i></td>
			        </tr>
			        <input type="hidden" value="${List.vacation_seq}" id="seq_frm"/>
	        	</c:forEach>
       		</c:if>
        	<c:if test="${empty requestScope.myHoldList}">
	        	<tr>
	        		<td class='col'>데이터가 없습니다.</td>
	        	</tr>
	        </c:if>
         </tbody>
      </table>
      </div>
      </div>
      <form name="seq_delete">
      	<input type="hidden" name="vacation_seq"/>
      </form>
      <%-- 승인대기중인휴가 [끝] --%>
   
   <%-- 승인된휴가 [시작] --%>
   <div class='listContainer border'>
   	
      <h5 class='mb-3 ml-5' style="font-weight: bold;" >승인 완료된 휴가</h5>
	  <div class='maxHight'>
      <table class="table ml-5">
         <thead>
            <tr class='row table_tr'>
               	<th class='col col-1'>no</th>
	        	<th class='col col-1'>이름</th>
	            <th class='col col-2'>신청휴가종류</th>
	            <th class='col col-2'>사유</th>
	            <th class='col'>신청일</th>
	            <th class='col'>시작일</th>
	            <th class='col'>종료일</th>
	            <th class='col'>결재상태</th>
            </tr>
         </thead>
         
         <tbody>
            <c:if test="${not empty requestScope.myApprovedList}">
            	<c:forEach var="List" items="${requestScope.myApprovedList}" varStatus="status">
			        <tr class='row'>
			        	<td class='col col-1'>${status.index+1}</td>
			        	<td class='col col-1'>${List.name}</td>
			            <c:choose>
						<c:when test="${List.vacation_type == '1'}"> 
							<td class='col col-2' id="type_text">연차</td>
						</c:when>	
						<c:when test="${List.vacation_type == '2'}"> 
							<td class='col col-2' id="type_text">가족돌봄휴가</td>
						</c:when>
						<c:when test="${List.vacation_type == '3'}"> 
							<td class='col col-2' id="type_text">예비군휴가</td>
						</c:when>
						<c:when test="${List.vacation_type == '4'}"> 
							<td class='col col-2' id="type_text">난임치료휴가</td>
						</c:when>
						<c:when test="${List.vacation_type == '5'}"> 
							<td class='col col-2' id="type_text">출산휴가</td>
						</c:when>
						<c:when test="${List.vacation_type == '6'}"> 
							<td class='col col-2' id="type_text">결혼휴가</td>
						</c:when>
						<c:when test="${List.vacation_type == '7'}"> 
							<td class='col col-2' id="type_text">포상휴가</td>
						</c:when>
					</c:choose>
			            <td class='col'>${List.vacation_reason}</td>
			            <td class='col'>${List.vacation_reg_date}</td>
			            <td class='col'>${List.vacation_start_date}</td>
			            <td class='col'>${List.vacation_end_date}</td>
			            <c:choose>
			            	<c:when test="${List.vacation_confirm == '1'}">
			            		<td class='col'>대기</td>
			            	</c:when>
			            	<c:when test="${List.vacation_confirm == '2'}">
			            		<td class='col'>승인</td>
			            	</c:when>
			            	<c:when test="${List.vacation_confirm == '3'}">
			            		<td class='col'>반려</td>
			            	</c:when>
			            </c:choose>
			        </tr>
	        	</c:forEach>
       		</c:if>
        	<c:if test="${empty requestScope.myApprovedList}">
	        	<tr>
	        		<td class='col'>데이터가 없습니다.</td>
	        	</tr>
	        </c:if>
         </tbody>
      </table>
      </div>
      </div>
      <%-- 승인된휴가 [끝] --%>
      
      
      <%-- 반려휴가 [시작] --%>
      <div class='listContainer border mt-5 mb-5'>
      <h5 class='mb-5 ml-5' style="font-weight: bold;">반려된 휴가</h5>
      <div class='maxHight'>
      <table class="table ml-5" id="emptbl">
         <thead>
            <tr class='row table_tr'>
            	<th class='col col-1'>no</th>
	        	<th class='col col-1'>이름</th>
	            <th class='col col-2'>신청휴가종류</th>
	            <th class='col col-2'>신청일</th>
	            <th class='col col'>반려일</th>
	            <th class='col'></th>
            </tr>
         </thead>
         
         <tbody>
            <c:if test="${not empty requestScope.myReturnList}">
            	<c:forEach var="ReturnList" items="${requestScope.myReturnList}" varStatus="status">
			        <tr class='row' id="empinfo">
			        	<td class='col col-1'>${status.index+1}</td>
			        	<td class='col col-1'>${ReturnList.name}</td>
			            <c:choose>
							<c:when test="${ReturnList.vacation_type == '1'}"> 
								<td class='col col-2'>연차</td>
							</c:when>	
							<c:when test="${ReturnList.vacation_type == '2'}"> 
								<td class='col col-2'>가족돌봄휴가</td>
							</c:when>
							<c:when test="${ReturnList.vacation_type == '3'}"> 
 								<td class='col col-2'>예비군휴가</td>
							</c:when>
							<c:when test="${ReturnList.vacation_type == '4'}"> 
								<td class='col col-2'>난임치료휴가</td>
							</c:when>
							<c:when test="${ReturnList.vacation_type == '5'}"> 
								<td class='col col-2'>출산휴가</td>
							</c:when>
							<c:when test="${ReturnList.vacation_type == '6'}"> 
								<td class='col col-2'>결혼휴가</td>
							</c:when>
							<c:when test="${ReturnList.vacation_type == '7'}"> 
								<td class='col col-2'>포상휴가</td>
							</c:when>
						</c:choose>
						<td class='col col-2'>${ReturnList.vacation_reg_date}</td>
						<td class='col col-2'>${ReturnList.vacation_return_date}</td>
			            <td class='col' style="margin-left: 20%;">
			            	<input type="button" value="상세보기" id="openModal"/>
			           	</td>
			            <td class='col'>
				            <input type="hidden" name="send_seq" value="${ReturnList.vacation_seq}"/>
				            <input type="hidden" name="send_name" value="${ReturnList.name}"/>
				            <input type="hidden" name="send_fk_employee_id" value="${ReturnList.fk_employee_id}"/>
				            <input type="hidden" name="send_start_date" value="${ReturnList.vacation_start_date}"/>
				            <input type="hidden" name="send_end_date" value="${ReturnList.vacation_end_date}"/>
				            <input type="hidden" name="send_reg_date" value="${ReturnList.vacation_reg_date}"/>
				            <input type="hidden" name="send_return_date" value="${ReturnList.vacation_return_date}"/>
				            <input type="hidden" name="send_confirm" value="${ReturnList.vacation_confirm}"/>
				            <input type="hidden" name="send_type" value="${ReturnList.vacation_type}"/>
				            <input type="hidden" name="send_manager_name" value="${ReturnList.vacation_manager_name}"/>
				            <input type="hidden" name="send_manager" value="${ReturnList.vacation_manager}"/>
				            <input type="hidden" name="send_return_reason" value="${ReturnList.vacation_return_reason}"/>
			            </td>
			            <td class='col'></td>
			        </tr>
	        	</c:forEach>
       		</c:if>
        	<c:if test="${empty requestScope.myReturnList}">
	        	<tr>
	        		<td class='col'>데이터가 없습니다.</td>
	        	</tr>
	        </c:if>
         </tbody>
      </table>
      </div>
      </div>
      <%-- 반려휴가 [끝] --%>
      
	</div>
  
  <%-- 모달창 --%>
 <div class="modal fade" id="openModal" role="dialog" data-backdrop="static">
  <div class="modal-dialog" style="width: 500px;">
    <div class="modal-content">
    
      <!-- Modal header -->
      <div class="modal-header">
        <h4 class="modal-title">반려 상세보기</h4>
        <button type="button" class="close modal_close" data-dismiss="modal">&times;</button>
      </div>
      
      <!-- Modal body -->
      <div class="modal-body">
          <form name="modal_frm">
          <table style="width: 100%;" class="table table-bordered" >
              <tr>
               	  <td style="width: 30%;">이름</td>
	        	  <td id="frm_name">
	        	  	<span id="name"></span>
	        	  </td>
              </tr>
              <tr>
               	  <td>사원번호</td>
	        	  <td id="frm_employee_id"></td>
              </tr>
              <tr>
               	  <td>신청휴가종류</td>
	        	  <td id="frm_vacation_type"></td>
              </tr>
              <tr>
               	  <td>반려사유</td>
	        	  <td id="frm_return_reason"></td>
              </tr>
              <tr>
               	  <td>휴가사유</td>
	        	  <td id="frm_vacation_reason"><input type="text" name="frm_vacation_reason"/></td>
              </tr>
              <tr>
               	  <td>시작일</td>
	        	  <td><input type="date" name="frm_vacation_start_date" class="border p-2.5" required></td>
              </tr>
              <tr>
               	  <td>종료일</td>
	        	  <td>&nbsp;<input type="date" name="frm_vacation_end_date" class="border p-2.5" required></td>
              </tr>
              <tr>
               	  <td>신청일</td>
	        	  <td id="frm_vacation_reg_date"></td>
              </tr>
              <tr>
               	  <td>반려일</td>
	        	  <td id="frm_vacation_return_date"></td>
              </tr>
              <tr>
                 <td>결재자</td>
                 <td id="frm_manager_name"></td>
              </tr>
           </table>
           <input type="hidden" name="vacation_seq" />
           <input type="hidden" name="vacation_type" />
           <input type="hidden" name="manager_id" />
           <input type="hidden" id="return_reason" name="return_reason" />
           <input type="hidden" id="employee_id" name="employee_id" />
           <!-- Modal footer -->
	       <div class="modal-footer">
	           <input type="submit" id="return_insert" value="상신"/>
	           <input type="reset" id="return_reset" value="취소" style="margin-left: 1.5%;" />
	       </div>
           
           </form>   
      </div>
    </div>
  </div>
</div>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" 	uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
   String ctxPath = request.getContextPath();
%>

<style type="text/css">
   
   a {
      margin-right: 10px;
      text-decoration: none !important;
      color: black;
      font-size: 13pt;
   }
   
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
  
   div#container {width: 75%; margin:0 auto; margin-top:100px;}
   
	
	#Navbar > li > a {
		color: gray;
		font-weight: bold;
		font-size: 17pt;
	}
	#Navbar > li > a:hover {
		color: black;
	}
	
	
	.max-form{
	    height: 200px;  
	    max-height: 300px; /* 최대 높이 설정 */
	    overflow-y: auto; /* 세로 스크롤 적용 */
	    overflow-x: hidden; /* 가로 스크롤 비활성화 */
	}
	
	#first_tr > th {
		font-size: 11pt;
	}
	
	span#returnSpan {color: orange; font-size: 9pt; position: relative; top:23px; right:105px;}
	
	/* 버튼 스타일링 */
	input[type="submit"] {
	  padding: 6px 15px; /* 버튼 내부 여백 설정 */
	  cursor: pointer; /* 커서 모양 설정 */
	  background-color: #00ace6; /* 배경 색상 설정 */
	  color: #fff; /* 글자 색상 설정 */
	  border: none; /* 테두리 제거 */
	  border-radius: 5px; /* 테두리 반경 설정 */
	  transition: background-color 0.3s; /* 배경 색상 전환 효과 설정 */
	}
	
	/* 마우스 호버 시 배경 색상 변경 */
	input[type="submit"]:hover {
	  background-color: #0086b3;
	}
	
	/* 두 번째 버튼에 대한 추가적인 스타일링 */
	#return {
	  background-color: #f44336; /* 두 번째 버튼의 배경 색상 설정 */
	}
	
	#return:hover {
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
	
	nav.navbar {
		margin-left: 2%; 
		margin-right: 5%; 
		width: 80%; 
		background-size: cover; 
		background-position: center; 
		background-repeat: no-repeat; 
		height: 70px
	}
	span#spanReturn {color: orange; font-size: 9pt; margin-left: 1%;}
    tr.table_tr {background-color: #ccff99;}
    input#vacation_return_reason {border: solid 1px gray;}
</style>

<script type="text/javascript">

   	$(document).ready(function(){
   		const total_count = document.getElementById('total_count').value;
   		// alert(total_count); 
   		
   		if(total_count < 1) {
   			$("h6#count_display").hide();
	    	$("input:submit[id='approved']").hide();
   		    $("input:submit[id='return']").hide();
   		    $("span#return_info").hide();
   		}
   		
		// 승인 버튼 클릭시 tbl_vacation 테이블에 update
		$("input#approved").click(function(){
			
			const gradelevel = parseInt("${sessionScope.loginuser.gradelevel}");
			if(gradelevel < 5) {
				alert("결재 권한이 없습니다.");
				return;
			}
			else {
				const ArrStartDate = new Array();
				const ArrEndDate = new Array();
				const ArrEmployee_id = new Array();
				const ArrcheckSeq = new Array();
				const ArrVacationType = new Array();
				const ArrdaysDiff = new Array();
				const ArrDepartment_id = new Array();
				const ArrName = new Array();
				const ArrEmail = new Array();
				
				const checkNoCnt = $("input:checkbox[name='checkNo']").length;
				
				for(let i=0; i<checkNoCnt; i++) {
					
	              	if($("input:checkbox[name='checkNo']").eq(i).prop("checked")) {
	              		
	              		const startDate = $("input:hidden[name='vacation_start_date']").eq(i).val(); // 해당 사원의 시작일자
	              		// alert(startDate);
	              		const endDate = $("input:hidden[name='vacation_end_date']").eq(i).val(); // 해당 사원의 종료일자
	              		// alert(endDate);
	              		const daysDiff = calculateDaysDiff(startDate, endDate); // 
	              		// alert(daysDiff);
	              		
	              		ArrcheckSeq.push( $("input:hidden[name='vacation_seq']").eq(i).val() );
	              		ArrStartDate.push($("input:hidden[name='vacation_start_date']").eq(i).val() );
	              		ArrEndDate.push( $("input:hidden[name='vacation_end_date']").eq(i).val() );
	              		ArrEmployee_id.push( $("input:hidden[name='fk_employee_id']").eq(i).val() );
	              		ArrVacationType.push( $("input:hidden[name='vacation_type']").eq(i).val() );
	              		ArrDepartment_id.push( $("input:hidden[name='fk_department_id']").eq(i).val() );
	              		ArrName.push( $("input:hidden[name='name']").eq(i).val() );
	              		ArrEmail.push( $("input:hidden[name='email']").eq(i).val() );
	              		ArrdaysDiff.push(daysDiff);
	              		
	               	} // end of if -----
	               	
				} // end of for----------------------
	
				if(ArrStartDate == "") {
					alert("결재할 번호를 선택하세요.");
					return false;
				}
				
				var vac_approved = confirm("휴가 승인 하시겠습니까?");
				
				if(vac_approved) {
				
					$("input:hidden[name='vacation_seq']").val(ArrcheckSeq);
					$("input:hidden[name='vacation_start_date']").val(ArrStartDate);
              		$("input:hidden[name='vacation_end_date']").val(ArrEndDate);
              		$("input:hidden[name='fk_employee_id']").val(ArrEmployee_id);
              		$("input:hidden[name='vacation_type']").val(ArrVacationType);
              		$("input:hidden[name='daysDiff']").val(ArrdaysDiff);
              		$("input:hidden[name='fk_department_id']").val(ArrDepartment_id);
              		$("input:hidden[name='name']").val(ArrName);
              		$("input:hidden[name='email']").val(ArrEmail);
					
					const frm = document.vac_manage_frm; 
					
					frm.method = "post";
					frm.action = "<%= ctxPath %>/vacUpdate.gw";
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
		
		var myGrade = $("input:hidden[id='myGradeLevel']").val(); // 로그인 한 유저의 gradelevel
		
		if(myGrade != 10) {
			$(document).on("click", "table#emptbl tr#empinfo", function (e) {
	   			
	   			// 행 클릭이 아닌 체크박스를 클릭했을땐 체크박스만 체크되고 모달창이 뜨지 않게 함
	   			if ($(e.target).is(":checkbox")) { 
	   		        return;
	   		    }
	   			
				const gradelevel = parseInt('${sessionScope.loginuser.gradelevel}');
				
				if(gradelevel < 5) {
					alert("결재 권한이 없습니다.");
					return;
				}
				else {
					const vacation_seq = $(this).find("td:eq(0) > div > input").val();
		       		const name = $(this).find("td#name").text();
		       		const employee_id = $(this).find("td#employee_id").text();
		       		const vacation_start_date = $(this).find("td#vacation_start_date").text();
		       		const vacation_end_date = $(this).find("td#vacation_end_date").text();
		       		const vacation_confirm = $(this).find("td#vacation_confirm").text();
		       		const vacation_type = $(this).find("td#vacation_type").text();
		       		
		       		$('#openModal').modal('show', vacation_seq);
		       		
					// 값 꽂아주기
		    	    $("input#vacation_seq").val(vacation_seq);
		    	    $("td#frm_name").text(name);
		    	    $("td#frm_employee_id").text(employee_id);
		    	    $("td#frm_vacation_start_date").text(vacation_start_date);
		    	    $("td#frm_vacation_end_date").text(vacation_end_date);
		    	    $("td#frm_vacation_confirm").text(vacation_confirm);
		    	    $("td#frm_vacation_type").text(vacation_type);
		    	    
		    	    $("input#employee_id").val(employee_id);
		    	    
		    	    // alert(vacation_seq);
		    	    
		    	    // 확인 클릭시
		    	    $("input#vacation_return_button").click(function(){
		    	    	
		    	    	if($("input#vacation_return_reason").val().trim() == "") {
		    	    		alert("사유를 입력하세요");
		    	    		return false;
		    	    	}
		    	    	else {
		    	    		var vac_return = confirm("휴가 반려 하시겠습니까?");
		    				
		    				if(vac_return) {
		    					const select_result = $("select#approvalStatus").val(); // 결재상태 선택 결과값
			    	    		const reason = $("input#vacation_return_reason").val(); // 입력한 반려사유 값
			    	    		
			    	    		$("input#return_reason").val(reason);
			        	    	
			    				const frm = document.modal_frm; 
			    				
			    				frm.method = "post";
			    				frm.action = "<%= ctxPath %>/vacInsert_return.gw";
			    				frm.submit();	
		    				}
		    	    	}
		    	    });
				}
	    	}); // end of $(document).on("click", "table#emptbl tr#empinfo", function (e) ----------------
		}
		
   		// return_reset 버튼 클릭 시 모달 닫기
   		$("input#return_reset").click(function(){
   		    closeModal();
   		});

   		// 모달이 닫힐 때 입력값 초기화
   		$('#openModal').on('hidden.bs.modal', function () {
   		    document.getElementById("modal_frm").reset();
   		});
		
	}); // document.ready -------------------
	
	// 모달창 닫기 함수
	function closeModal() {
	    $('#openModal').modal('hide');
	}
	
	// 휴가 시작일자와 종료일자의 차이를 구하는 함수
	function calculateDaysDiff(startDate, endDate) {
		
        const startParts = startDate.split('-');
        const endParts = endDate.split('-');

        const startDateObj = new Date(startParts[0], startParts[1] - 1, startParts[2]);
        const endDateObj = new Date(endParts[0], endParts[1] - 1, endParts[2]);

        const timeDiff = endDateObj - startDateObj;
        const daysDiff = timeDiff / (1000 * 60 * 60 * 24);
        
        return daysDiff;
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
   <%-- 상단 메뉴바 끝 --%>
   
   <%-- 본문 시작 --%>
   <%-- 대기중인 회원 [시작] --%>
   <div class='listContainer border'>
      <h5 class='mb-3 ml-5' style="font-weight: bold;">대기중인 휴가</h5>
      
      <c:if test="${not empty total_count}">
	      <h6 class='mb-3 ml-5' id="count_display">결재 대기 중인 휴가가 
	      <span style='color:#086BDE;' id="hold_count">
	      	${total_count}
	      	<input type="hidden" id="total_count" value="${total_count}"/>
	      </span>건 있습니다.</h6>
	     
      </c:if>
       
      <form name="vac_manage_frm">
      <div class="max-form">
      <table class="table ml-4" id="emptbl">
         <thead>
            <tr class='row table_tr'>
              <c:if test="${not empty requestScope.vacList && sessionScope.loginuser.gradelevel != 10}">
               	<th class='col col-1'><input type="checkbox" id="selectAll" class="mr-2"/>전체선택</th>
              </c:if>
              <c:if test="${sessionScope.loginuser.gradelevel == 10}">
                <th class='col col-1'>no</th>
              </c:if>
	        	<th class='col col-1'>이름</th>
	            <th class='col col-1'>사원번호</th>
	            <th class='col col-2'>신청 휴가 종류</th>
	            <th class='col col-2'>사유</th>
	            <th class='col'>신청일</th>
	            <th class='col'>시작일</th>
	            <th class='col'>종료일</th>
	            <th class='col'>결재상태</th>
            </tr>
         </thead>
         
         <tbody>
            <c:if test="${not empty requestScope.vacList}">
            <input type='hidden' id='myGradeLevel' value='${sessionScope.loginuser.gradelevel}'/> <%-- 로그인한 유저의 gradelevel 확인용 --%>
             <c:if test="${sessionScope.loginuser.gradelevel > 4}">
       		  <c:forEach var="vacList" items="${requestScope.vacList}" varStatus="status">
		        <tr class='row' id="empinfo">
		        	<td class='col col-1'>
		        		<div style="display: flex; margin-top: 5%;">     		
		        		    <c:if test="${sessionScope.loginuser.gradelevel != 10}">
		        				<input type="checkbox" id="${status.index}" name="checkNo" value="${vacList.vacation_seq}" />
		        			</c:if>
		        			<span class="ml-2" >${status.index+1}</span>
		        			<input type="hidden" name="vacation_seq" value="${vacList.vacation_seq}"/>
		            		<input type="hidden" name="vacation_start_date" value="${vacList.vacation_start_date}"/>
		            		<input type="hidden" name="vacation_end_date" value="${vacList.vacation_end_date}"/>
		            		<input type="hidden" name="fk_employee_id" value="${vacList.fk_employee_id}"/>
		            		<input type="hidden" name="vacation_type" value="${vacList.vacation_type}"/>
		            		<input type="hidden" name="fk_department_id" value="${vacList.fk_department_id}"/>
		            		<input type="hidden" name="name" value="${vacList.name}"/>
		            		<input type="hidden" name="email" value="${vacList.email}"/>
		            		<input type="hidden" name="daysDiff" class="daysDiffClass" />
		        		</div>
		        	</td> 
		        	<td class='col col-1' id="name">${vacList.name}</td>
		            <td class='col col-1' id="employee_id">${vacList.fk_employee_id}</td>
		            
		            <c:choose>
						<c:when test="${vacList.vacation_type == '1'}"> 
							<td class='col col-2' id="vacation_type">연차</td>
						</c:when>	
						<c:when test="${vacList.vacation_type == '2'}"> 
							<td class='col col-2' id="vacation_type">가족돌봄휴가</td>
						</c:when>
						<c:when test="${vacList.vacation_type == '3'}"> 
							<td class='col col-2' id="vacation_type">예비군휴가</td>
						</c:when>
						<c:when test="${vacList.vacation_type == '4'}"> 
							<td class='col col-2' id="vacation_type">난임치료휴가</td>
						</c:when>
						<c:when test="${vacList.vacation_type == '5'}"> 
							<td class='col col-2' id="vacation_type">출산휴가</td>
						</c:when>
						<c:when test="${vacList.vacation_type == '6'}"> 
							<td class='col col-2' id="vacation_type">결혼휴가</td>
						</c:when>
						<c:when test="${vacList.vacation_type == '7'}"> 
							<td class='col col-2' id="vacation_type">포상휴가</td>
						</c:when>
					</c:choose>
		            
		            <td class='col col-2'>${vacList.vacation_reason}</td>
		            <td class='col'>${vacList.vacation_reg_date}</td>
		            <td class='col' id="vacation_start_date">${vacList.vacation_start_date}</td>
		            <td class='col' id="vacation_end_date">${vacList.vacation_end_date}</td>
		            <c:choose>
		            	<c:when test="${vacList.vacation_confirm == '1'}">
		            		<td class='col ml-3' id="vacation_confirm">대기</td>
		            	</c:when>
		            	<c:when test="${vacList.vacation_confirm == '2'}">
		            		<td class='col ml-3' id="vacation_confirm">승인</td>
		            	</c:when>
		            	<c:when test="${vacList.vacation_confirm == '3'}">
		            		<td class='col ml-3' id="vacation_confirm">반려</td>
		            	</c:when>
		            </c:choose>
		        </tr>
		        
	        </c:forEach>
	        </c:if>
        </c:if>
        
        <c:if test="${empty requestScope.vacList}">
        	<tr>
        		<td class='col'>데이터가 없습니다.</td>
        	</tr>
        </c:if>
         </tbody>
      </table>
      </div>
      <c:if test="${sessionScope.loginuser.gradelevel != 10}">
	      <input type="submit" id="approved" name="approved" value="승인" class="ml-4"/>
	      <span id='spanReturn' style="" id="return_info">반려를 하시려면 해당 회원을 누르세요</span>
		  <input type="hidden" id="str_checkNo" name="str_checkNo" />
	  </c:if>
      </form>
   </div>
   <%-- 휴가 대기중인 회원 [끝] --%>
   
   <br><br>
   
   <!-- 휴가 반려된 회원 [시작] -->
   <div class='listContainer border'>
      <h5 class='mb-3 ml-5' style="font-weight: bold;">반려됨</h5>
      <div class="max-form">
      <table class="table ml-5">
         <thead>
            <tr class='row table_tr'>
               	<th class='col col-1'>no</th>
	        	<th class='col col-1'>이름</th>
	            <th class='col col-1'>사원번호</th>
	            <th class='col col-2'>신청 휴가 종류</th>
	            <th class='col col-2'>사유</th>
	            <th class='col'>신청일</th>
	            <th class='col'>시작일</th>
	            <th class='col'>종료일</th>
	            <th class='col'>결재상태</th>
            </tr>
         </thead>
         <tbody>
            <c:if test="${not empty requestScope.vacReturnList}">
            <c:if test="${sessionScope.loginuser.gradelevel > 4}">
       		<c:forEach var="vacReturnList" items="${requestScope.vacReturnList}" varStatus="status">
		        <tr class='row'>
		        	<td class='col col-1'>
		        		<div style="display: flex; margin-top: 5%;">    		
		        			<span>${status.index+1}</span>
		        		</div>
		        	</td>
		        	<td class='col col-1'>${vacReturnList.name}</td>
		            <td class='col col-1'>${vacReturnList.fk_employee_id}</td>
		            
		            <c:choose>
						<c:when test="${vacReturnList.vacation_type == '1'}"> 
							<td class='col col-2 '>연차</td>
						</c:when>	
						<c:when test="${vacReturnList.vacation_type == '2'}"> 
							<td class='col col-2'>가족돌봄휴가</td>
						</c:when>
						<c:when test="${vacReturnList.vacation_type == '3'}"> 
							<td class='col col-2'>예비군휴가</td>
						</c:when>
						<c:when test="${vacReturnList.vacation_type == '4'}"> 
							<td class='col col-2'>난임치료휴가</td>
						</c:when>
						<c:when test="${vacReturnList.vacation_type == '5'}"> 
							<td class='col col-2'>출산휴가</td>
						</c:when>
						<c:when test="${vacReturnList.vacation_type == '6'}"> 
							<td class='col col-2'>결혼휴가</td>
						</c:when>
						<c:when test="${vacReturnList.vacation_type == '7'}"> 
							<td class='col col-2'>포상휴가</td>
						</c:when>
					</c:choose>
		            
		            <td class='col col-2'>${vacReturnList.vacation_reason}</td>
		            <td class='col'>${vacReturnList.vacation_end_date}</td>
		            <td class='col'>${vacReturnList.vacation_start_date}</td>
		            <td class='col'>${vacReturnList.vacation_end_date}</td>
		            <c:choose>
		            	<c:when test="${vacReturnList.vacation_confirm == '1'}">
		            		<td class='col ml-3'>대기</td>
		            	</c:when>
		            	<c:when test="${vacReturnList.vacation_confirm == '2'}">
		            		<td class='col ml-3'>승인</td>
		            	</c:when>
		            	<c:when test="${vacReturnList.vacation_confirm == '3'}">
		            		<td class='col ml-3'>반려</td>
		            	</c:when>
		            </c:choose>
		        </tr>
	        </c:forEach>
	      </c:if>
        </c:if>
        <c:if test="${empty requestScope.vacReturnList}">
        	<tr>
        		<td class='col'>데이터가 없습니다.</td>
        	</tr>
        </c:if>
         </tbody>
      </table>
      </div>
   </div>
   <!-- 휴가 반려된 회원 [끝] -->
   
   <br><br>
   
   <!-- 휴가 승인된 회원 [시작] -->
   <div class='listContainer border mb-5'>
      <h5 class='mb-3 ml-5' style="font-weight: bold;">승인됨</h5>
      <div class="max-form">
      <table class="table ml-5">
         <thead>
            <tr class='row table_tr'>
               	<th class='col col-1'>no</th>
	        	<th class='col col-1'>이름</th>
	            <th class='col col-1'>사원번호</th>
	            <th class='col col-2'>신청 휴가 종류</th>
	            <th class='col col-2'>사유</th>
	            <th class='col'>신청일</th>
	            <th class='col'>시작일</th>
	            <th class='col'>종료일</th>
	            <th class='col'>결재상태</th>
            </tr>
         </thead>
         <tbody>
            <c:if test="${not empty requestScope.vacApprovedList}">
             <c:if test="${sessionScope.loginuser.gradelevel > 4}">
       		  <c:forEach var="vacApprovedList" items="${requestScope.vacApprovedList}" varStatus="status">
		        <tr class='row'>
		        	<td class='col col-1'>
		        		<div style="display: flex; margin-top: 5%;">     		
		        			<span>${status.index+1}</span>
		        		</div>
		        	</td>
		        	<td class='col col-1'>${vacApprovedList.name}</td>
		            <td class='col col-1'>${vacApprovedList.fk_employee_id}</td>
		            
		            <c:choose>
						<c:when test="${vacApprovedList.vacation_type == '1'}"> 
							<td class='col col-2'>연차</td>
						</c:when>	
						<c:when test="${vacApprovedList.vacation_type == '2'}"> 
							<td class='col col-2'>가족돌봄휴가</td>
						</c:when>
						<c:when test="${vacApprovedList.vacation_type == '3'}"> 
							<td class='col col-2'>예비군휴가</td>
						</c:when>
						<c:when test="${vacApprovedList.vacation_type == '4'}"> 
							<td class='col col-2'>난임치료휴가</td>
						</c:when>
						<c:when test="${vacApprovedList.vacation_type == '5'}"> 
							<td class='col col-2'>출산휴가</td>
						</c:when>
						<c:when test="${vacApprovedList.vacation_type == '6'}"> 
							<td class='col col-2'>결혼휴가</td>
						</c:when>
						<c:when test="${vacApprovedList.vacation_type == '7'}"> 
							<td class='col col-2'>포상휴가</td>
						</c:when>
					</c:choose>
		            
		            <td class='col col-2'>${vacApprovedList.vacation_reason}</td>
		            <td class='col'>${vacApprovedList.vacation_reg_date}</td>
		            <td class='col'>${vacApprovedList.vacation_start_date}</td>
		            <td class='col'>${vacApprovedList.vacation_end_date}</td>
		            <c:choose>
		            	<c:when test="${vacApprovedList.vacation_confirm == '1'}">
		            		<td class='col ml-3'>대기</td>
		            	</c:when>
		            	<c:when test="${vacApprovedList.vacation_confirm == '2'}">
		            		<td class='col ml-3'>승인</td>
		            	</c:when>
		            	<c:when test="${vacApprovedList.vacation_confirm == '3'}">
		            		<td class='col ml-3'>반려</td>
		            	</c:when>
		            </c:choose>
		        </tr>
	        </c:forEach>
	      </c:if>  
        </c:if>
        <c:if test="${empty requestScope.vacApprovedList}">
        	<tr>
        		<td class='col'>데이터가 없습니다.</td>
        	</tr>
        </c:if>
         </tbody>
      </table>
      </div>
   </div>
   <!-- 휴가 승인된 회원 [끝] -->
 </div>
 
 <%-- 모달창 --%>
 <div class="modal fade" id="openModal" role="dialog" data-backdrop="static">
  <div class="modal-dialog" style="width: 500px;">
    <div class="modal-content">
    
      <!-- Modal header -->
      <div class="modal-header">
        <h4 class="modal-title">휴가반려</h4>
        <span id='returnSpan'>휴가 반려 사유를 입력하세요</span>
        <button type="button" class="close modal_close" data-dismiss="modal">&times;</button>
      </div>
      
      <!-- Modal body -->
      <div class="modal-body">
          <form name="modal_frm">
          <table style="width: 100%;" class="table table-bordered">
              <tr>
               	  <td style="width: 30%;">이름</td>
	        	  <td id="frm_name"></td>
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
               	  <td>사유</td>
	        	  <td><input type="text" id="vacation_return_reason" name="vacation_return_reason" /></td>
              </tr>
              
              <tr>
               	  <td>시작일</td>
	        	  <td id="frm_vacation_start_date"></td>
              </tr>
              <tr>
               	  <td>종료일</td>
	        	  <td id="frm_vacation_end_date"></td>
              </tr>
              <tr>
               	  <td>결재상태</td>
	        	  <td id="frm_vacation_confirm"></td>
              </tr>
              <tr>
                 <td>결재자</td>
                 <td>${sessionScope.loginuser.name}</td>
              </tr>
           </table>
           
           <input type="hidden" id="vacation_seq" name="vacation_seq" />
           <input type="hidden" id="return_reason" name="return_reason" />
           <input type="hidden" id="employee_id" name="employee_id" />
           <!-- Modal footer -->
	       <div class="modal-footer">
	           <input type="submit" id="vacation_return_button" value="확인" />
	           <input type="reset" id="return_reset" value="취소" />
	       </div>
           </form>   
      </div>
    </div>
  </div>
</div>
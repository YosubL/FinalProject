<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<% String ctxPath=request.getContextPath(); %>

<link rel = "stylesheet" href = "<%=ctxPath%>/resources/css/draft_form_style.css">

<script>

//수신처 배열
const recipientArr = JSON.parse('${recipientArr}');

// 파일 정보를 담아 둘 배열
let fileList = [];

//네이버 스마트 에디터용 전역변수
var obj = [];

$(() => {

	/* 네이버 스마트 에디터  프레임생성 */
	nhn.husky.EZCreator.createInIFrame({
		oAppRef: obj,
		elPlaceHolder: "draft_content",
		sSkinURI: "<%=ctxPath%>/resources/smarteditor/SmartEditor2Skin.html",
		htParams: {
			// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
			bUseToolbar: true,
			// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
			bUseVerticalResizer: true,
			// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
			bUseModeChanger: true,
		}
	});
	
	/* 확인 버튼 클릭 시 */
	$("button#writeBtn").click(function(){
		// 에디터에서 textarea에 대입
		obj.getById["draft_content"].exec("UPDATE_CONTENTS_FIELD", []);
		
		// 글제목 유효성 검사
		const draft_subject = $("input#draft_subject").val().trim();
		if(draft_subject == "") {
			swal("글제목을 입력하세요!")
			.then(function (result) {
				document.getElementById("draft_subject").focus(); //포커싱
		      })
			return;
		}
	    
	    // 출장정보 유효성검사
	    if ($("#trip_purpose").val() == "" || $("#trip_start_date").val() == "" || $("#trip_end_date").val() == "" ||$("#trip_location").val() == "") {
	    	swal("출장정보를 모두 입력하세요!");
			return;
	    }
	    
		// 글내용 유효성검사
	    var draft_content = $("#draft_content").val();

	    if( draft_content == ""  || draft_content == null || draft_content == '&nbsp;' || draft_content == '<p>&nbsp;</p>')  {
			obj.getById["draft_content"].exec("FOCUS"); //포커싱
			swal("출장결과를 작성하세요!")
			.then(function (result) {
				obj.getById["draft_content"].exec("FOCUS"); //포커싱
		      })
			return;
	         
	    }
	    
	    // 결재라인 유효성검사
	    let aprvLineInfo = aprvTblBody.html();
	    if (aprvLineInfo.indexOf('tr') == -1) {
	    	swal("결재라인을 설정하세요!");
 		return;
	    }
		
		// 의견 및 긴급 여부 체크 모달 띄우기
		$("#myModal").modal();

	});
	
	/* 임시저장 버튼 클릭 시 */
	$("button#saveBtn").click(function(){
		// 에디터에서 textarea에 대입
		obj.getById["draft_content"].exec("UPDATE_CONTENTS_FIELD", []);
		
		// 글내용 유효성검사
	    var draft_content = $("#draft_content").val();

	    if( draft_content == ""  || draft_content == null || draft_content == '&nbsp;' || draft_content == '<p>&nbsp;</p>')  {
			obj.getById["draft_content"].exec("FOCUS"); //포커싱
			swal("출장결과를 작성하세요!!")
			.then(function (result) {
				obj.getById["draft_content"].exec("FOCUS"); //포커싱
		      })
			return;
	         
	    }
		
	    // 출장정보 유효성검사
	    if ($("#trip_purpose").val() == "" || $("#trip_start_date").val() == "" || $("#trip_end_date").val() == "" ||$("#trip_location").val() == "") {
	    	swal("출장정보를 모두 입력하세요!");
			return;
	    }
	    
		saveTemp();
		
	});
	

	/* 파일 드래그 & 드롭 */
	// 파일 드롭 영역
	const $drop = document.querySelector(".dropBox");
	
	// 드래그한 파일 객체가 해당 영역에 놓였을 때
	$drop.ondrop = function(e) {
		e.preventDefault();
		e.stopPropagation();
		
		// 드롭된 파일 리스트 가져오기
		const files = Array.from(e.dataTransfer.files);
		
		if(files != null && files != undefined){
		    let tag = "";
		    
	        let length = fileList.length;

		    for(i=0; i<files.length; i++){
		        let f = files[i];

		        // 파일리스트 전역변수에 파일 담기
		        fileList.push(f);
		        
		        let fileName = f.name;
		        let fileSize = f.size / 1024 / 1024;
		        fileSize = fileSize < 1 ? fileSize.toFixed(3) : fileSize.toFixed(1);
		     	// 파일 정보 표시하기
		        tag += 
		                "<div class='fileList'>" +
		                    "<span class='fileName'>" + fileName + "</span>" +
		                    "<span class='fileSize'>" + fileSize +" MB</span>" +
		                    "<span class='digitFileSize' style='display:none'>" + f.size + "</span>" +
		                    "<span class='removeFile btn small name='removeFile'>삭제</span>" +
		                "</div>";
		    }
		    $(".dropBox span").hide();
		    $(this).append(tag);
		    $(this).addClass('active');
		}
	}

	$drop.ondragover = (e) => {
	  e.preventDefault();
	  e.stopPropagation();
	}
	
	// 드래그한 파일이 최초로 진입했을 때
	$drop.ondragenter = (e) => {
	  e.preventDefault();
	  e.stopPropagation();
	  $drop.classList.add("active");
	}

	// 드래그한 파일이 영역을 벗어났을 때
	$drop.ondragleave = (e) => {
	  e.preventDefault();
	  e.stopPropagation();
	  $drop.classList.remove("active");
	}

	// 파일 삭제 버튼 클릭시
	$(document).on('click','[name=removeFile]', function(){
   	 	const $this = $(this);
   	 	delete_file_name = $this.parent().children('.fileName').text();
   	 	delete_file_size = $this.parent().children('.digitFileSize').text();
   	 	
   	 	for(let i = 0; i < fileList.length; i++) {
   	 		if(fileList[i].name = delete_file_name && delete_file_size == fileList[i].size )  {
   	 			
   	 			fileList.splice(i, 1);
   	 		    i--;
   	 		  }
   	 	}
   	 $(this).parent().remove();
   	 
	});
	
});

//긴급 여부 체크
const checkUrgent = () => {
	
	let urgent = $("#urgent_status");

	if(urgent.prop("checked")){
		urgent.val(1);
	}else{
		urgent.val(0);
	}
	
}


//첨부파일 가져오기
const getFiles = formData => {

	if(fileList.length > 0){
	   fileList.forEach(function(f){
	       formData.append("fileList", f);
	   });
	}
}

/* 폼 제출하기 */
const submitDraft = () => {
	
	// 긴급 여부 값 넣어주기
	checkUrgent();
	
	// formData 가져오기
	let formData = new FormData($("#draftForm")[0]);
	
	// 첨부파일 formData에 추가하기
	getFiles(formData);
	
	// 수신처 결재라인 추가하기
	if (recipientArr != null && recipientArr.length > 0) {
		
		// 내부결재라인 결재자 수
		const aprvLength = aprvTblBody.children('tr').length;
		
		// 수신처 결재자 추가
		recipientArr.forEach((el, i) => {
			formData.append("avoList[" + (aprvLength + i)+ "].levelno", (aprvLength + i + 1));
			formData.append("avoList[" + (aprvLength + i) + "].fk_approval_empno", el.empno);
			formData.append("avoList[" + (aprvLength + i) + "].external", 1);
		});
	}
	
	 $.ajax({
	     url : "<%=ctxPath%>/approval/addDraft.on",
	     data : formData,
	     type:'POST',
	     enctype:'multipart/form-data',
	     processData:false,
	     contentType:false,
	     dataType:'json',
	     cache:false,
	     success:function(json){
	     	if(json.result == true) {
	 	    	swal("등록 완료", "기안이 상신되었습니다.", "success")
	 	    	.then((value) => {
		    	    	location.href = "<%=ctxPath%>/approval/personal/sent.on";
		    		});
	     	}
	     	else
	     		swal("등록 실패", "등록에 실패하였습니다.", "error");
	     },
	     error: function(request, status, error){
			alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
	 });
	
}

/* 임시저장하기 */
const saveTemp = () => {
	
	let formData = new FormData($("#draftForm")[0]);
	
	$.ajax({
		url : "<%=ctxPath%>/approval/saveDraft.on",
		data : formData,
		type:'POST',
		enctype:'multipart/form-data',
		processData:false,
		contentType:false,
		dataType:'json',
		cache:false,
		success:function(json){
   	     	if(json.temp_draft_no != "" && json.temp_draft_no !== undefined) {
   	     		swal("저장 완료", "임시저장 되었습니다.", "success")
   	     		.then((value) => {
   	 	    		$("input[name='temp_draft_no']").val(json.temp_draft_no); // 임시저장 번호 대입
 	     		});
   	     	}
	    	else
	    		swal("저장 실패", "임시저장 실패하였습니다.", "error");
	    },
	    error: function(request, status, error){
		alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		}
	});
}

/* 저장된 결재라인 선택창 */
const getMyApprovalLine = () => {
	
	$.ajax({
		type: "GET",
		url:"<%=ctxPath%>/approval/getSavedAprvLine.on",
		dataType:"json",
		success : function(aprvLine){

			// 저장된 결재라인 불러오기
			let html = "";
			
			if (aprvLine.length > 0) {
				aprvLine.forEach((el, index) => {
					html += "<tr>"
							+ "<td><input type='radio' name='aprvLine' value=" + el.aprv_line_no + " id='radio" + index + "'></td>" 
							+ "<td><label for='radio" + index + "'>" + el.aprv_line_name + "</label></td>"
							+ "</tr>";
				});
			} else {
				html = "<tr><td colspan='2' style='text-align: center'>저장된 결재라인이 없습니다.</td></tr>";
			}
			
			$("#modalBody").html(html);
			
			$("#myApprovalLineModal").modal();
			
			$("#lineOkBtn").click(()=>{
				// 결재자 정보 검색하기
				getApprovalEmpInfo(aprvLine);
			});
		},
		error: function(request, status, error){
         alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
 	}
	});
	
}

/* 선택한 저장된 결재라인 출력하기 */
const getApprovalEmpInfo = aprvLine => {
	const selectedNo = $('input[name=aprvLine]:checked').val();
	
	const selectedAprvLine = aprvLine.filter(el => el.aprv_line_no == selectedNo);
	
	if (selectedAprvLine.length == 0) {
		swal("선택된 결재라인이 없습니다.");
		return;
	}
	
	$.ajax({
		type: "GET",
		url:"<%=ctxPath%>/approval/getSavedAprvEmpInfo.on",
		data: {"selectedAprvLine": JSON.stringify(selectedAprvLine)},
		dataType:"json",
		success : function(json){
						
			emptyApprovalLine();
			
			json.forEach((emp, index) => {

				var html = "<tr>"
			 			+ "<td class='levelno'>" + (index+1) + "</td>"
						+ "<td class='department'>" + emp.department + "</td>"
						+ "<td class='position'>" + emp.position + "</td>"
						+ "<input type='hidden' name='avoList[" + index + "].levelno' value='" + (index+1) + "'></td>"
						+ "<input type='hidden' name='avoList[" + index + "].fk_approval_empno' value='" + emp.empno + "'></td>"
						+ "<input type='hidden' name='avoList[" + index + "].external' value='0'></td>"
						+ "<td class='name'>" + emp.name + "</td></tr>";
					
				aprvTblBody.append(html);
			});
		},
		error: function(request, status, error){
         alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
 	}
	});
}


/* 결재자 선택하기 */
const selectApprovalLine = empno => {
	emptyApprovalLine();
	
	const popupWidth = 800;
	const popupHeight = 500;

	const popupX = (window.screen.width / 2) - (popupWidth / 2);
	const popupY= (window.screen.height / 2) - (popupHeight / 2);
	
	window.open('<%=ctxPath%>/approval/selectApprovalLine.on?type=personal','결재라인 선택','height=' + popupHeight  + ', width=' + popupWidth  + ', left='+ popupX + ', top='+ popupY);
}	


/* 선택된 결재자 출력하기 */
const receiveMessage = async (e) =>
{
	const jsonArr = e.data;

	// 선택된 사원을 테이블에 표시함
	jsonArr.forEach((emp, index) => {

		var html = "<tr>"
	 			+ "<td class='levelno'>" + emp.levelno + "</td>"
				+ "<td class='department'>" + emp.department + "</td>"
				+ "<td class='position'>" + emp.position + "</td>"
				+ "<input type='hidden' name='avoList[" + index + "].levelno' value='" + emp.levelno + "'></td>"
				+ "<input type='hidden' name='avoList[" + index + "].fk_approval_empno' value='" + emp.empno + "'></td>"
				+ "<input type='hidden' name='avoList[" + index + "].external' value='0'></td>"
				+ "<td class='name'>" + emp.name + "</td></tr>";
			
		aprvTblBody.append(html);
		
	});
	
}

window.addEventListener("message", receiveMessage, false);


/* 결재라인 비우기 */
const emptyApprovalLine = () => {
	aprvTblBody.empty();
}
</script>

<div style='margin: 1% 0 5% 1%'>
	<h4>기안문서 작성</h4>
</div>

<div class="container bizTripFrmContainer">

	<div class="card">
		<div class="card-header py-3" align="center">
			<h3>
				<strong>출 장 보 고 서</strong>
			</h3>

		</div>
		<div class="card-body text-center p-4">
		<!-- 문서 작성  폼 -->
		<form id="draftForm" enctype="multipart/form-data">
			<input type='hidden' name='fk_draft_empno' value='${loginuser.empno}'/>
			<input type='hidden' name='fk_draft_type_no' value='3'/>
			<input type='hidden' name='temp_draft_no' value='${draftMap.dvo.draft_no}'/>
			
			<!-- 문서정보 -->
			<div class='draftInfo' style='width: 20%'>
				<h5 class='text-left my-4'>문서정보</h5>
				<table class='table table-sm table-bordered text-left'>
					<tr>
						<th>기안자</th>
						<td>${loginuser.name}</td>
					</tr>
					<tr>
						<th>소속</th>
						<td>${loginuser.department}</td>
					</tr>
					<tr>
						<th>기안일</th>
						<td></td>
					</tr>
					<tr>
						<th>문서번호</th>
						<td></td>
					</tr>
				</table>
			</div>
				
			<!-- 결재라인 -->
			<div class='approvalLineInfo' style='width: 60%'>
			
				<h5 class='my-4' style='display: inline-block; float: left'>결재라인</h5>
				<button id='setLineBtn' type="button" class="btn btn-sm ml-2 my-4" onclick='selectApprovalLine()'>선택하기</button>
				<button id='resetLineBtn' type="button" class="btn btn-sm apvLineBtn ml-2 my-4" onclick='emptyApprovalLine()'>비우기</button>
				<button id='getLineBtn' type="button" class="btn btn-sm apvLineBtn my-4" onclick='getMyApprovalLine()'>불러오기</button>
				
				<table class='mr-4 table table-sm table-bordered text-left' id='approvalLine'>
				    <thead>
				      <tr>
				        <th>순서</th>
				        <th>소속</th>
				        <th>직급</th>
				        <th>성명</th>
				      </tr>
				    </thead>
				    <tbody id="aprvTblBody">
					<c:if test="${not empty draftMap.internalList}">
					    <c:forEach items="${draftMap.internalList}" var="emp" varStatus="sts">
					    <tr>
					    	<td>${emp.levelno}
					    	<input type='hidden' name='avoList[${sts.index}].levelno' value='${emp.levelno}'/>
					    	<input type='hidden' name='avoList[${sts.index}].fk_approval_empno' value='${emp.fk_approval_empno}'/>
					    	<input type='hidden' name='avoList[${sts.index}].external' value='0'>
					    	</td>
					    	<td>${emp.department}</td>
					    	<td>${emp.position}</td>
					    	<td>${emp.name}</td>
					    	
					    </tr>
					    </c:forEach>
				    </c:if>				    
				    </tbody>
				</table>
			</div>
							
			<script>
				const aprvTblBody = $('#aprvTblBody');
			</script>

			<!-- 수신처 -->
			<c:if test="${recipientArr != '[]'}">
			<div class='recipientLineInfo' style='width: 60%'>
				<h5 class='my-4' style='display: inline-block; float: left'>수신처</h5>
				<table class='mr-4 table table-sm table-bordered text-left' id='recipient'>
				    <thead>
				      <tr>
				        <th>순서</th>
				        <th>소속</th>
				        <th>직급</th>
				        <th>성명</th>
				      </tr>
				    </thead>
				    <tbody id="recipientTblBody">
				    </tbody>
				</table>
			    <script>
			    	const recipientTblBody = $('#recipientTblBody');
			    	// 수신처 결재라인을 테이블에 표시함
			    	recipientArr.forEach((emp, index) => {

			    		var html = "<tr>"
			    	 			+ "<td class='levelno'>" + (index + 1) + "</td>"
			    				+ "<td class='department'>" + emp.department + "</td>"
			    				+ "<td class='position'>" + emp.position + "</td>"
			    				+ "<td class='name'>" + emp.name + "</td></tr>";
			    			
	    				recipientTblBody.append(html);
			    		
			    	});
			    </script>
			</div>
			</c:if>

			<div style="clear: both; height: 30px; padding-top: 8px; margin-bottom: 30px;">
				<hr>
			</div>
			<button id='saveBtn' type="button" class="btn btn-sm btn-light m-2"
						style='display: inline-block; float: right;'>임시저장</button>
			<!-- 기안내용 -->
			<table class='table table-sm table-bordered text-left' id='draftTable'>
				<tr>
					<th>제목</th>
					<td><input type="text" name="draft_subject" id="draft_subject" 
					placeholder='제목을 입력하세요' style='width: 100%;' value="${draftMap.dvo.draft_subject}"/></td>
				</tr>
				<tr>
					<th>출장목적</th>
					<td><textarea style="width: 100%; height: 50px;" name="trip_purpose" id="trip_purpose" placeholder='내용을 입력하세요'>${draftMap.brvo.trip_purpose}</textarea></td>
				</tr>
				<tr>
					<th>출장기간</th>
					<td>
						<input type='date' name="trip_start_date" value="${fn:substring(draftMap.brvo.trip_start_date,0,10)}"> ~ 
						<input type='date' name="trip_end_date" value="${fn:substring(draftMap.brvo.trip_end_date,0,10)}">
					</td>
				</tr>
				<tr>
					<th>출장지역</th>
					<td><input type="text" name="trip_location" id="trip_location" value="${draftMap.brvo.trip_location}"/></td>
				</tr>
				<tr>
					<th>출장결과</th>
					<td><textarea style="width: 100%; height: 400px;" name="draft_content" id="draft_content" placeholder='내용을 입력하세요'>${draftMap.dvo.draft_content}</textarea></td>
				</tr>
			</table>
			<!-- 기안내용 끝 -->

			<!-- 파일첨부 -->
			<div class="filebox">
				<div class="dropBox mt-2">
					<span style='font-size: small'>이곳에 파일을 드롭해주세요.</span>
				</div>
			</div>
			<!-- 결재의견 및 긴급여부 체크 모달 -->
				<div class="modal text-left" id="myModal">
					<div class="modal-dialog modal-dialog-centered ">
						<div class="modal-content">
			
							<!-- Modal Header -->
							<div class="modal-header">
								<h5 class="modal-title">결재 상신</h5>
								<button type="button" class="close" data-dismiss="modal">&times;</button>
							</div>
			
							<!-- Modal body -->
							<div class="modal-body">
								<h6 class='text-secondary'>기안의견</h6>
								<textarea name="draft_comment" placeholder="기안의견을 입력해주세요(선택)" style='width: 100%; min-height: 150px'></textarea>
								<h6 class='text-secondary mt-4'>긴급문서</h6>
								<input type="checkbox" id='urgent_status' name='urgent_status'/><label for='urgentDraft'>긴급(결재자의 대기문서 가장 상단에 표시됩니다.)</label>
							</div>
			
							<!-- Modal footer -->
							<div class="modal-footer">
								<button type="button" id='calcelBtn' class="btn btn-secondary" data-dismiss="modal">취소</button>
								<button type="button" id='submitBtn' class="btn" data-dismiss="modal" onclick='submitDraft()'>상신</button>
							</div>
						</div>
					</div>
				</div>
				<div style="margin: 20px;">
					<button type="button" class="btn btn-secondary " onclick="javascript:history.back()">취소</button>
					<button type="button" class="btn btn-primary mr-3" id="writeBtn">확인</button>
				</div>
			</form>
		</div>
	</div>
</div>
<!-- 저장된 결재라인 불러오기 모달 -->
<div class="modal text-left" id="myApprovalLineModal">
	<div class="modal-dialog modal-dialog-centered ">
		<div class="modal-content">

	<!-- Modal Header -->
	<div class="modal-header">
		<h5 class="modal-title">결재라인 불러오기</h5>
		<button type="button" class="close" data-dismiss="modal">&times;</button>
	</div>

	<!-- Modal body -->
	<div class="modal-body">
		<table class='table' id='approveLineTable'>
			<thead class="thead-light">
		      <tr>
		        <th>선택</th>
		        <th>결재라인명</th>
		      </tr>
		    </thead>
		    <tbody id="modalBody">
		    </tbody>
		</table>
	</div>

	<!-- Modal footer -->
	<div class="modal-footer">
		<button type="button" id='lineCalcelBtn' class="btn btn-secondary" data-dismiss="modal">취소</button>
		<button type="button" id='lineOkBtn' class="btn" data-dismiss="modal" >확인</button>
			</div>
		</div>
	</div>
</div>
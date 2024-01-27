<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%
 	String ctxPath = request.getContextPath();
	
%>

<style type="text/css">
	
  
         
	table {
  border-collapse: collapse;
  width: 100%;
}

th, td {
  border: 1px solid #dddddd;
  text-align: center;
  padding: 8px;
  width:50px;
}

th {
	background-color:rgb(230,255,230);
}

select{
	width:200px;
}
button#updateDocument,button#deleteDocument{
	border-radius:30%; 
	background-color:rgb(230,255,230); 
	margin-left:10px;
}

</style>

<script type="text/javascript">
	
	$(document).ready(function(){
		
		$("input[name=attach]").off().on("change", function(){

			if (this.files && this.files[0]) {

				var maxSize = 10 * 1024 * 1024;
				var fileSize = this.files[0].size;

				if(fileSize > maxSize){
					alert("첨부파일 사이즈는 10MB 이내로 등록 가능합니다.");
					$(this).val('');
					return false;
				}
			}
		});// end of $("input[name=attach]").off().on("change", function()
		
		$("input#searchWord").keyup(function(event){
			if(event.keyCode == 13){ 
				goSearch();
			}
		});
		
		
		
	});// end of $(document).ready(function()
	
	
// function declaration

//재직증명서 모달 열기
function documentpage1(){
	$('#modal_document').modal('show');	
}

//재직증명서 모달 유효성
function goDocument(){
	
	if($("select#purpose").val()==""){
		alert("발급용도를 선택하세요");
		return;
	}
	
	if($("select#category").val()==""){
		alert("발급유형을 선택하세요");
		return;
	}
	
	const frm = document.modal_frm;
		
		var pop_title = "popupOpener" ;
	
		var width = 1000;
	    var height = 900;

	    // Calculate the center position for the popup window
	    var left = (window.innerWidth - width) / 2 + window.screenX;
	    var top = (window.innerHeight - height) / 2 + window.screenY;
	    
		var options = "width=1000, height=900, left=" + left + ", top=" + top;
		window.open("", pop_title, options);

		frm.method="POST";
		frm.target = pop_title;
	    frm.action="<%= ctxPath%>/documentDown.gw";
	    frm.submit();
}// 재직증명서 모달 끝

// 문서 등록 모달 열기
function registerDocumentModal(){
	$('#modal_registerDocument').modal('show');	
}

// ㄴ
function registerDocument() {
	
	if($("input#documentSubject").val() == ""){
		alert("문서제목을 입력해주세요.")
		return;
	}
	
	if($("input#attach").val() == ""){
		alert("파일을 선택해주세요.")
		return;
	}
	
	  const frm = document.documentRegister;
	  frm.method = "post";
	  frm.action = "<%= ctxPath%>/registerDocument.gw";
	  frm.submit();
}

function deleteDocument(seq) {
	
	//console.log(seq);
	$.ajax({
        url: "<%= ctxPath %>/deleteDocument.gw",
        type: "post",
        data: { "seq": seq },
        dataType: "json",
        success: function (json) {
        	
        	if(json.n==1){
        		alert("문서 삭제를 성공했습니다.")
        	}
        	else{
        		alert("문서 삭제가 실패했습니다.")
        	}
        	
        	location.href = "<%= ctxPath %>/document.gw";
            		
        },
        error: function (request, status, error) {
            alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
        }
    }); // end of ajax
	
}

//문서 다운로드
function documentDown(seq){
	//alert(seq);
	location.href = "<%= ctxPath %>/documentDown.gw?seq="+seq;
	
}

//문서 수정하기 모달열기
function updateDocument(seq){
	$("input[name='seq']").val(seq);
	$('#modal_updateDocument').modal('show');
}

// 문서 수정하기 전송
function goupdateDocument(){
	
	if($("input#updateDocumentSubject").val() == ""){
		alert("문서제목을 입력해주세요.")
		return;
	}
	
	if($("input#updateAttach").val() == ""){
		alert("파일을 선택해주세요.")
		return;
	}
	
	
	
	  const frm = document.documentUpdate;
	  frm.method = "post";
	  frm.action = "<%= ctxPath%>/updateDocument.gw";
	  frm.submit();
}

// 검색 메소드
function goSearch() {
	
	var frm = document.searchDucFrm;
	frm.method = "GET";
	frm.action = "<%= ctxPath %>/document.gw";
	frm.submit();
	
} // end of function goSearch
</script>

<div class="container" style="margin-top:50px;  text-align:center; padding-bottom:100px;">
	<h3>증명서 발급</h3>
	<table style="margin-bottom:50px;">
	 <thead>
		<tr>
			<th>결제양식</th>
			<th>제목</th>
			<th>다운로드</th>
		</tr>
	 </thead>
	 
	 <tbody>	
		<tr>
			<td>재직증명서(개인)</td>
			<td>재직증명서</td>
			<td><a href="javascript:documentpage1()">발급받기</a></td>
		</tr>
		
	</tbody>
	
	</table>
	
	
	<h3 style="display:inline-block;">문서 다운로드</h3>
	
	<c:if test="${sessionScope.loginuser.gradelevel == '10'}">
	<div style="display:flex; ">
		<button style=" margin-bottom:20px;margin-left:auto; background-color:white;" type="button" onclick="registerDocumentModal()">문서 등록하기</button>
	</div>
	</c:if>
	
	<table style="">
	 <thead>
		<tr>
			
			<th>문서제목</th>
			<th>다운로드</th>
		</tr>
	 </thead>
	 
	 <c:if test="${sessionScope.loginuser.gradelevel != '10' && not empty requestScope.documentList }">
	 <c:forEach var="paraMap" items="${requestScope.documentList}">
		 <tbody>	
			<tr>
				<td>${paraMap.documentsubject}</td>
				<td>
					<a style="color:blue; cursor:pointer;" onclick="javascript:documentDown('${paraMap.seq}')">다운로드</a>
				</td>
			</tr>
		</tbody>
	</c:forEach>
	</c:if>
	 
	 
	 
	 <c:if test="${sessionScope.loginuser.gradelevel == '10' && not empty requestScope.documentList }">
	 
	 <c:forEach var="paraMap" items="${requestScope.documentList}">
		 <tbody>	
			<tr>
				<td>${paraMap.documentsubject}</td>
				<td>
					<a style="color:blue; cursor:pointer;" onclick="javascript:documentDown('${paraMap.seq}')">다운로드</a>
						
					<button type="button" id="updateDocument" onclick="updateDocument('${paraMap.seq}')">수정</button>
					<button type="button" id="deleteDocument" onclick="deleteDocument('${paraMap.seq}')">삭제</button>
				</td>
			</tr>
		</tbody>
	</c:forEach>
	</c:if>
	
	<c:if test="${empty requestScope.documentList }">
	 <tbody>	
			<tr>
				<td colspan=2> 문서가 존재하지 않습니다.</td>
				
			</tr>
		</tbody>
	
	</c:if>
	
	</table>
	<div style="margin-top:20px;">
		${requestScope.pagebar}
	</div>
	
	
	<div id="search">
		<form name ="searchDucFrm">
		<input type="text" name="searchWord" placeholder="문서 제목을 검색하세요"/>
		<button type="button" onclick="goSearch()">검색</button>
		</form>
	</div>
	
	
	</div>


<%--증명서 프린트하기 모달 --%>
<div class="modal fade" id="modal_document" role="dialog" data-backdrop="static">
  <div class="modal-dialog">
    <div class="modal-content">
    
      <!-- Modal header -->
      <div class="modal-header">
        <h4 class="modal-title">재직 증명서 발급 받기</h4>
        <button type="button" class="close modal_close" data-dismiss="modal">&times;</button>
      </div>
      
      <!-- Modal body -->
      <div class="modal-body">
       	<form name="modal_frm">
       	<table style="width: 100%;" class="table table-bordered">
     			<tr>
     				<td style="text-align: center; width:100px;">발급용도</td>
     				<td>
     					<select id="purpose" name="purpose">
						  <option value="">선택하세요</option>
						  <option value="개인 확인용">개인 확인용</option>
						  <option value="금융기관 제출용">금융기관 제출용</option>
						  <option value="관공서 제출용">관공서 제출용</option>
						  <option value="기타">기타</option>
						</select>
     				</td>
     			</tr>
     			<tr>
     				<td style="text-align: center; width:100px;">발급유형</td>
     				<td>
     					<select id="category" name="category">
						  <option value="">선택하세요</option>
						  <option value="전자도장">전자도장</option>
						  <option value="직인">직인</option>
						</select>
     				</td>
     			</tr>
     		</table>
     		<input type="hidden" value="${sessionScope.loginuser.employee_id}" name="employee_id"/>
     		<input type="hidden" value="재직 증명서" name="document_name"/>
       	</form>	
      </div>
      
      <!-- Modal footer -->
      <div class="modal-footer">
      	<button type="button" id="goDocument" class="btn btn-sm" style="background-color:rgb(3,199,90);" onclick="goDocument()">발급받기</button>
          <button type="button" class="btn btn-danger btn-sm modal_close" data-dismiss="modal">취소</button>
      </div>
      
    </div>
  </div>
</div>

<%--문서 등록하기 모달 --%>
<div class="modal fade" id="modal_registerDocument" role="dialog" data-backdrop="static">
  <div class="modal-dialog">
    <div class="modal-content">
    
      <!-- Modal header -->
      <div class="modal-header">
        <h4 class="modal-title">문서 등록하기</h4>
        <button type="button" class="close modal_close" data-dismiss="modal">&times;</button>
      </div>
      
      <!-- Modal body -->
      <div class="modal-body">
       	<form name="documentRegister" enctype="multipart/form-data">
       	<table style="width: 100%;" class="table table-bordered">
     			<tr>
     				<td style="text-align: center; width:100px;">문서제목</td>
     				<td>
     					<input type="text" id="documentSubject" name="documentSubject"/>
     				</td>
     			</tr>
     			<tr>
     				<td style="text-align: center; width:100px;">문서파일</td>
     				<td>
     					<input type="file" id="attach" name="attach"/>
     				</td>
     			</tr>
     		</table>
     		<input type="hidden" value="${sessionScope.loginuser.employee_id}" name="fk_employee_id"/>
       	</form>	
      </div>
      
      <!-- Modal footer -->
      <div class="modal-footer">
      	<button type="button" id="goDocument" class="btn btn-sm" style="background-color:rgb(3,199,90);" onclick="registerDocument()">등록하기</button>
          <button type="button" class="btn btn-danger btn-sm modal_close" data-dismiss="modal">취소</button>
      </div>
      
    </div>
  </div>
</div>


<%--문서 수정하기 모달 --%>
<div class="modal fade" id="modal_updateDocument" role="dialog" data-backdrop="static">
  <div class="modal-dialog">
    <div class="modal-content">
    
      <!-- Modal header -->
      <div class="modal-header">
        <h4 class="modal-title">문서 수정하기</h4>
        <button type="button" class="close modal_close" data-dismiss="modal">&times;</button>
      </div>
      
      <!-- Modal body -->
      <div class="modal-body">
       	<form name="documentUpdate" enctype="multipart/form-data">
       	<table style="width: 100%;" class="table table-bordered">
     			<tr>
     				<td style="text-align: center; width:100px;">문서제목</td>
     				<td>
     					<input type="text" id="updateDocumentSubject" name="documentSubject"/>
     				</td>
     			</tr>
     			<tr>
     				<td style="text-align: center; width:100px;">문서파일</td>
     				<td>
     					<input type="file" id="updateAttach" name="attach"/>
     				</td>
     			</tr>
     		</table>
     		<input type="hidden" value="${sessionScope.loginuser.employee_id}" name="fk_employee_id"/>
     		<input type="text" name="seq" value=""/>
       	</form>	
      </div>
      
      <!-- Modal footer -->
      <div class="modal-footer">
      	<button type="button" id="goDocument" class="btn btn-sm" style="background-color:rgb(3,199,90);" onclick="goupdateDocument()">등록하기</button>
          <button type="button" class="btn btn-danger btn-sm modal_close" data-dismiss="modal">취소</button>
      </div>
      
    </div>
  </div>
</div>


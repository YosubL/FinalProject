<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 
   String ctxPath2 = request.getContextPath(); 
   //    /board
%> 
<script type="text/javascript">

function goAddMyCal2(){
	
	if($("input.add_my_smcatgoname").val().trim() == ""){
 		  alert("추가할 개인 캘린더 소분류명을 입력하세요!!");
 		  return;
 	}
 	
	else {
 		  $.ajax({
 			 url: "<%= ctxPath2%>/schedule/addMyCalendar.gw",
 			 type: "post",
 			 data: {"my_smcatgoname": $("input.add_my_smcatgoname").val(), 
 				    "fk_employee_id": "${sessionScope.loginuser.employee_id}",
 				   "fk_department_id": "${sessionScope.loginuser.fk_department_id}"},
 				    
 			 dataType: "json",
 			 success:function(json){
 				 
 				 if(json.n!=1){
 					alert("이미 존재하는 '개인 캘린더 소분류명' 입니다.");
 					return;
 				 }
 				 else if(json.n==1){
 					 $('#modal_addMyCal').modal('hide'); // 모달창 감추기
 					 alert("개인 캘린더에 "+$("input.add_my_smcatgoname").val()+" 소분류명이 추가되었습니다.");
 					 
 					 $("input.add_my_smcatgoname").val("");
 					location.reload();
 				 }
 			 },
 			 error: function(request, status, error){
  	            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
    	     }	 
 		 });
 	  }
	
}// end of function goAddMyCal(){}-----------------------

function goAddDepCal2(){
	
	if($("input.add_dep_smcatgoname").val().trim() == ""){
 		  alert("추가할 회사캘린더 소분류명을 입력하세요!!");
 		  return;
 	}
	
 	else {
 		 $.ajax({
 			 url: "<%= ctxPath2%>/schedule/addDepCalendar.gw",
 			 type: "post",
 			 data: {"dep_smcatgoname": $("input.add_dep_smcatgoname").val(), 
 				    "fk_employee_id": "${sessionScope.loginuser.employee_id}",
 				   "fk_department_id": "${sessionScope.loginuser.fk_department_id}"},
 			 dataType: "json",
 			 success:function(json){
 				 if(json.n != 1){
  					alert("이미 존재하는 '부서캘린더 소분류명' 입니다.");
  					return;
  				 }
 				 else if(json.n == 1){
 					 $('#modal_addDepCal').modal('hide'); // 모달창 감추기				
 					 alert("부서 캘린더에 "+$("input.add_dep_smcatgoname").val()+" 소분류명이 추가되었습니다.");
 					 
 					 $("input.add_dep_smcatgoname").val("");
 					location.reload();
 				 }
 			 },
 			 error: function(request, status, error){
  	            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
    	     }	 
 		 });
 	  }
	
}// end of function goAddComCal(){}------------------------------------

//=== 회사 캘린더 추가 모달창에서 추가 버튼 클릭시 ===
function goAddComCal2(){
	
	if($("input.add_com_smcatgoname").val().trim() == ""){
 		  alert("추가할 회사캘린더 소분류명을 입력하세요!!");
 		  return;
 	}
	
 	else {
 		 $.ajax({
 			 url: "<%= ctxPath2%>/schedule/addComCalendar.gw",
 			 type: "post",
 			 data: {"com_smcatgoname": $("input.add_com_smcatgoname").val(), 
 				    "fk_employee_id": "${sessionScope.loginuser.employee_id}",
 				    "fk_department_id": "${sessionScope.loginuser.fk_department_id}"},
 			 dataType: "json",
 			 success:function(json){
 				 if(json.n != 1){
  					alert("이미 존재하는 '회사캘린더 소분류명' 입니다.");
  					return;
  				 }
 				 else if(json.n == 1){
 					 $('#modal_addComCal').modal('hide'); // 모달창 감추기				
 					 alert("회사 캘린더에 "+$("input.add_com_smcatgoname").val()+" 소분류명이 추가되었습니다.");
 					 
 					 $("input.add_com_smcatgoname").val("");
 					location.reload();
 				 }
 			 },
 			 error: function(request, status, error){
  	            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
    	     }	 
 		 });
 	  }
	
}// end of function goAddComCal(){}------------------------------------

</script>
<%-- === 부서 캘린더 추가 Modal === --%>
<div class="modal fade" id="modal_addDepCal2" role="dialog" data-backdrop="static">
  <div class="modal-dialog">
    <div class="modal-content">
    
      <!-- Modal header -->
      <div class="modal-header">
        <h4 class="modal-title">부서 캘린더 추가</h4>
        <button type="button" class="close modal_close" data-dismiss="modal">&times;</button>
      </div>
      
      <!-- Modal body -->
      <div class="modal-body">
       	<form name="modal_frm">
       	<table style="width: 100%;" class="table table-bordered">
     			<tr>
     				<td style="text-align: left; ">소분류명</td>
     				<td><input type="text" class="add_dep_smcatgoname"/></td>
     			</tr>
     			<tr>
     				<td style="text-align: left;">만든이</td>
     				<td style="text-align: left; padding-left: 5px;">${sessionScope.loginuser.name}</td>
     			</tr>
     		</table>
       	</form>	
      </div>
      
      <!-- Modal footer -->
      <div class="modal-footer">
      	<button type="button" id="addDep" class="btn btn-sm" style="background-color:rgb(3,199,90);" onclick="goAddDepCal2()">추가</button>
          <button type="button" class="btn btn-danger btn-sm modal_close" data-dismiss="modal">취소</button>
      </div>
      
    </div>
  </div>
</div>



<%-- === 내 캘린더 추가 Modal === --%>
<div class="modal fade" id="modal_addMyCal2" role="dialog" data-backdrop="static">
  <div class="modal-dialog">
    <div class="modal-content">
      
      <!-- Modal header -->
      <div class="modal-header">
        <h4 class="modal-title">개인 캘린더 추가</h4>
        <button type="button" class="close modal_close" data-dismiss="modal">&times;</button>
      </div>
      
      <!-- Modal body -->
      <div class="modal-body">
          <form name="modal_frm">
       	<table style="width: 100%;" class="table table-bordered">
     			<tr>
     				<td style="text-align: left; ">소분류명</td>
     				<td><input type="text" class="add_my_smcatgoname" /></td>
     			</tr>
     			<tr>
     				<td style="text-align: left;">만든이</td>
     				<td style="text-align: left; padding-left: 5px;">${sessionScope.loginuser.name}</td> 
     			</tr>
     		</table>
     		</form>
      </div>
      
      <!-- Modal footer -->
      <div class="modal-footer">
      	<button type="button" id="addMy" class="btn btn-sm" style="background-color:rgb(3,199,90);" onclick="goAddMyCal2()">추가</button>
          <button type="button" class="btn btn-danger btn-sm modal_close" data-dismiss="modal">취소</button>
      </div>
      
    </div>
  </div>
</div>

<%-- === 회사 캘린더 추가 Modal === --%>
<div class="modal fade" id="modal_addComCal2" role="dialog" data-backdrop="static">
  <div class="modal-dialog">
    <div class="modal-content">
    
      <!-- Modal header -->
      <div class="modal-header">
        <h4 class="modal-title">회사 캘린더 추가</h4>
        <button type="button" class="close modal_close" data-dismiss="modal">&times;</button>
      </div>
      
      <!-- Modal body -->
      <div class="modal-body">
       	<form name="modal_frm">
       	<table style="width: 100%;" class="table table-bordered">
     			<tr>
     				<td style="text-align: left; ">소분류명</td>
     				<td><input type="text" class="add_com_smcatgoname"/></td>
     			</tr>
     			<tr>
     				<td style="text-align: left;">만든이</td>
     				<td style="text-align: left; padding-left: 5px;">${sessionScope.loginuser.name}</td>
     			</tr>
     		</table>
       	</form>	
      </div>
      
      <!-- Modal footer -->
      <div class="modal-footer">
      	<button type="button" id="addCom" class="btn btn-sm" style="background-color:rgb(3,199,90);" onclick="goAddComCal2()">추가</button>
          <button type="button" class="btn btn-danger btn-sm modal_close" data-dismiss="modal">취소</button>
      </div>
      
    </div>
  </div>
</div>
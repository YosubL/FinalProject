<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>   
<%
    String ctxPath = request.getContextPath();
%>
    <style type="text/css">
    /* 전체 스타일 코드 */
    body {
        font-family: Arial, sans-serif;
        background-color: #f4f4f4;
        margin: 0;
        padding: 0;
    }

    h2 {
        text-align: center;
        margin: 50px 0;
    }

    /* 폼 스타일 변경 */
    form {
        display: flex;
        justify-content: right;
        align-items: center;
        margin-bottom: 20px;
        background-color: #ffffff;
        padding: 15px;
        border-radius: 8px;
        box-shadow: 0 8px 12px 0 rgba(0, 0, 0, 0.1);
    }

    /* 입력 필드 및 버튼 스타일 변경 */
    select,
    input[type="text"] {
        height: 30px;
        margin-right: 40px;
        /* 여기서 마진값을 조절하여 간격을 조정할 수 있습니다. */
        border-radius: 5px;
        border: 1px solid #ddd;
        padding: 0 15px;
        transition: border-color 0.3s ease-in-out, box-shadow 0.3s ease-in-out;
    }

    /* 버튼 스타일 변경 */
    button#department_set {
        color: white;
        border: none;
        cursor: pointer;
    }

    /* 버튼 호버 효과 */
    button#department_set:hover {
        opacity: 0.8;
    }

    /* 테이블 스타일 변경 */
    table {
        width: 100%;
        border-collapse: collapse;
        margin-bottom: 30px;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 8px 12px 0 rgba(0, 0, 0, 0.1);
    }

    /* 테이블 헤더 스타일 변경 */
    table th {
        background-color: #ffffff;
        text-align: center;
        padding: 12px;
        font-weight: bold;
    }

    /* 테이블 셀 스타일 변경 */
    table td {
        border: solid 1px #ddd;
        padding: 8px;
        text-align: center;
    }

    /* 테이블 로우 스타일 변경 */
    tr.deptinfo, tr.teaminfo {
        cursor: pointer;
        transition: background-color 0.3s ease;
    }

    /* 테이블 로우 호버 효과 */
    tr.deptinfo:hover,
    tr.teaminfo:hover {
        background-color: #ccc;
    }

    /* Set max height and apply overflow to tbody for scrolling */
    .overscroll {
    max-height: 600px; /* Adjust this value as needed */
    overflow: auto; /* Apply vertical scrollbar */
	}

    /* Fix the header to prevent it from scrolling */
    .fixed-header th {
        position: sticky;
        top: 0;
        
        background-color: #ffffff;
    }
</style>

<script type="text/javascript">
 $(document).ready(function(){
	 
	 // 부서정보 가져오기
	 select_department();
	 
	 // 팀정보 가져오기
	 select_team();
	 
	 // 부서 생성시 필요한 부서번호 조회
	 department_id_max()
	 
	 // 부서 이름 뿌리기
	 populateDepartmentsDropdown();
	 
	 // 부서장 가능자 조회하기 
	 $.ajax({
		 url:"<%= ctxPath%>/emp/manager_id.gw",
		 dataType:"json",
		 success:function(json){
		      // console.log(JSON.stringify(json));
		    
		      let v_html = "<option value=''>미정</option>";
		      
		      if(json.length > 0) {
		    	  $.each(json, function(index, item){
		    		  v_html += "<option value='"+ item.manager_id +"'>"+ item.name +"</option>";
		    	  });
		      }
		      
		      $("select[name='manager_id']").html(v_html);
		      
		 },
		 error: function(request, status, error){
			alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		 }
	 });
	 

	 // 팀장 가능자 조회하기 
	 $.ajax({
		 url:"<%= ctxPath%>/emp/T_manager_id.gw",
		 dataType:"json",
		 success:function(json){
		      console.log(JSON.stringify(json));
		    
		      let tm_html = "<option value=''>미정</option>";
		      
		      if(json.length > 0) {
		    	  $.each(json, function(index, item){
		    		  tm_html += "<option value='"+ item.manager_id +"'>"+ item.name +"</option>";
		    	  });
		      }
		      
		      $("select[name='t_manager_id']").html(tm_html);
		      
		 },
		 error: function(request, status, error){
			alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		 }
	 });

	 // 신규부서 등록하기
	 $("button#deptset").click(function(){
		 
		 const department_name = $("input[name='department_name']").val().trim();
		 if(department_name == "") {
			 alert("부서명을 입력하세요!!");
			 return;
		 }
		 else {
			 const queryString = $("form[name='add_department_frm']").serialize(); 
			 $.ajax({
				 url:"<%= ctxPath%>/emp/department_add.gw",
				 data:queryString,
				 dataType:"json",
				 success:function(json){
				      //console.log(JSON.stringify(json));
				      /*
				        {"n":1} 또는 {"n":0}
				      */
				      if(json.n == 0) {
				    	  alert("입력하신 부서번호 "+ $("input[name='department_id']").val() +"은 이미 존재하므로 다른 부서번호를 입력하세요!!");
				      }
				      
				      if(json.n == 1) {
				    	  document.getElementsByName("add_department_frm")[0].reset(); // form 리셋하기
				    	  
				    	  select_department(); // 모든부서 출력해주기
				    	  select_team();		// 모든 팀 출력해주기
				    	  $("#departmentModal").modal("hide"); // 모달 끄기     

				      }
				 },
				 error: function(request, status, error){
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				 }
			 });
		 }
	 });
	 
	// 신규 팀 등록하기
	 $("button#teamset").click(function(){
		 
		 const team_name = $("input[name='team_name']").val().trim();
		 if(team_name == "") {
			 alert("팀명을 입력하세요!!");
			 return;
		 }
		 else {
			 const queryString = $("form[name='add_team_frm']").serialize(); 
			 $.ajax({
				 url:"<%= ctxPath%>/emp/team_add.gw",
				 data:queryString,
				 dataType:"json",
				 success:function(json){
				      console.log(JSON.stringify(json));
				      /*
				        {"n":1} 또는 {"n":0}
				      */
				      if(json.n == 0) {
				    	  alert("입력하신 팀번호 "+ $("input[name='team_id']").val() +"은 이미 존재하므로 다른 부서번호를 입력하세요!!");
				      }
				      
				      if(json.n == 1) {
				    	  document.getElementsByName("add_team_frm")[0].reset(); // form 리셋하기
				    	  
				    	  select_department(); // 모든부서 출력해주기
				    	  select_team(); // 모든팀 출력해주기
				    	  $("#teamModal").modal("hide"); // 모달 끄기     
				      }
				 },
				 error: function(request, status, error){
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				 }
			 });
		 }
	 });
	 
	  // 특정 회원을 클릭하면 회원의 상세정보
		$(document).on("click", "table#depttbl tr.deptinfo", function (e) {
      		
			const department_id = $(this).find("td.department_id").text(); // Retrieve department_id from the clicked row
	         alert("부서번호: " + department_id);
			
	        $.ajax({
	            url: "<%= ctxPath %>/emp/get_department_info.gw",
	            data: { "department_id": department_id },
	            dataType: "json",
	            success: function (json) {
	                console.log(JSON.stringify(json));
	            	html = "";
	    			if(json.length > 0) {
	    				$.each(json, function(index, item) {
	    					html += "<tr class='deptSelectEmpList'>"+
	    								"<td>"+item.job_name+"</td>"+
	    								"<td>"+item.name+"</td>"+
	    								"<td>"+item.phone+"</td>"+
	    							"</tr>"		
	    				}); // end of $.each(json, function(index, item)
	    			}
	    			$("tbody#deptEmpList").html(html);
	    			
	    	        $("#deptInfoModal").modal("show"); // 모달 띄우기     
				 },
				 error: function(request, status, error){
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				 }
			 });
			
			
 		}); // end of $(document).on("click", "table#depttbl tr.deptinfo", function (e) {
 			
 			
 		 // 특정 회원을 클릭하면 회원의 팀 상세정보
		$(document).on("click", "table#teamtbl tr.teaminfo", function (e) {
      
			const team_id = $(this).find("input:hidden[name='team_id']").val(); // Retrieve department_id from the clicked row
	         alert("팀번호: " + team_id);
			
			 $.ajax({
		            url: "<%= ctxPath %>/emp/get_team_info.gw",
		            data: { "team_id": team_id },
		            dataType: "json",
		            success: function (json) {
		                console.log(JSON.stringify(json));
		            	html = "";
		    			if(json.length > 0) {
		    				$.each(json, function(index, item) {
		    					html += "<tr class='teamSelectEmpList'>"+
		    								"<td>"+item.job_name+"</td>"+
		    								"<td>"+item.name+"</td>"+
		    								"<td>"+item.phone+"</td>"+
		    							"</tr>"		
		    				}); // end of $.each(json, function(index, item)
		    			}
		    			$("tbody#teamEmpList").html(html);
		    			
		    	        $("#teamInfoModal").modal("show"); // 모달 띄우기     
					 },
					 error: function(request, status, error){
						alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
					 }
				 });
	        
 		}); // end of $(document).on("click", "table#depttbl tr.deptinfo", function (e) {
 			
 	 
 		$("select[name='dept_id']").change(function () {
 		    const selectedDepartmentId = $(this).val();
 		    // alert(selectedDepartmentId);
 		    team_id_max(selectedDepartmentId);
 		});
 		$("select[name='del_dept_id']").change(function () {
 		    const selectedDepartmentId = $(this).val();
 		    // alert(selectedDepartmentId);
 		    team_id_select(selectedDepartmentId);
 		});
 			
 		
 		  $("#deptdel").click(function(){
 		        const department_id = $("form[name='del_department_frm'] select[name='dept_id']").val();

 		        if(department_id === "") {
 		            alert("삭제할 부서를 선택해주세요.");
 		            return;
 		        }

 		        else if(confirm("부서번호 "+ department_id +"번 부서를 정말로 삭제하시겠습니까?")) {
 				     $.ajax({
 						     url:"<%= ctxPath%>/emp/department_del.gw",
 						     data:{"department_id":department_id},
 						     dataType:"json",
 						     success:function(json){
 						          console.log(JSON.stringify(json));
 						         /*
 						            {"n":1} 또는 {"n":0}
 						         */
 						         if(json.n == 0) {
 						    	     alert("삭제하시려는 부서번호 "+ department_id +"에 근무하는 사원이 존재하므로 부서번호 삭제가 불가합니다");
 						         }
 						      
 						         if(json.n == 1) {
 						    	     department_id_max();  // 신규부서번호 입력해주기
 						    	     select_department(); // 모든부서 출력해주기
 							    	 select_team(); // 모든팀 출력해주기
 							   	 	 populateDepartmentsDropdown(); // 부서 이름 뿌리기
 	 						        $("#departmentDelModal").modal("hide"); // 모달 띄우기

 						         }
 						     },
 							 error: function(request, status, error){
 								alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
 							 }

 					 });	   
 			     }
 		    });
 		  
 		 $("#teamdel").click(function(){
		        const team_id = $("form[name='del_team_frm'] select[name='del_team_id']").val();
				alert(team_id);
		        if(team_id === "") {
		            alert("삭제할 팀을 선택해주세요.");
		            return;
		        }

		        else if(confirm("팀 "+ team_id +"번 팀을 정말로 삭제하시겠습니까?")) {
				     $.ajax({
						     url:"<%= ctxPath%>/emp/team_del.gw",
						     data:{"team_id":team_id},
						     dataType:"json",
						     success:function(json){
						          console.log(JSON.stringify(json));
						         /*
						            {"n":1} 또는 {"n":0}
						         */
						         if(json.n == 0) {
						    	     alert("삭제하시려는 부서번호 "+ team_del +"에 근무하는 사원이 존재하므로 부서번호 삭제가 불가합니다");
						         }
						      
						         if(json.n == 1) {
						    	     department_id_max();  // 신규부서번호 입력해주기
						    	     select_department(); // 모든부서 출력해주기
							    	 select_team(); // 모든팀 출력해주기
							    	 $("#teamDelModal").modal("hide"); // 모달 띄우기
						         }
						         
						     },
							 error: function(request, status, error){
									alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
								 }

					 });	   
			     }
		    });
 }) //  $(document).ready(function(){
	 
//Function Declaration
 // 신규부서번호 알아오기 
 function department_id_max(){
	 $.ajax({
		 url:"<%= ctxPath%>/emp/department_id_max.gw",
		 dataType:"json",
		 success:function(json){
		      //console.log(JSON.stringify(json));
		      /*
		        {"department_id_max":900} 
		      */

		      $("input[name='department_id']").val(json.department_id_max);
		      $("input[name='department_id']").attr("readonly", true);
		      
		 },
		 error: function(request, status, error){
			alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		 }
	 });
 }
 

 // 부서정보 조회하기
 function select_department(){
	 $.ajax({
		 url:"<%= ctxPath%>/emp/select_department.gw",
		 dataType:"json",
		 success:function(json){
		      //console.log(JSON.stringify(json));
		      
		      let v_html = "";

		      if(json.length > 0) {
		    	  $.each(json, function(index, item){
		    		  
		    		  v_html += "<tr class='deptinfo'>";
		    		  v_html +=    "<td width='10%' class='department_id'>"+ item.department_id +"</td>"; 
			          v_html +=    "<td width='10%'>"+ item.department_name +"</td>";
			          v_html +=    "<td width='10%'>"+ item.name +"</td>"; 
			          v_html +=    "<td width='20%'>"+ item.phone +"</td>";
			          v_html +=  "<tr>"; 
		    	  });
		      }
		      
		      else {
	    		  v_html +=  "<td colspan='6'>부서정보 없음</td>";
	    		  v_html +=  "<tr>"; 
		      }
		      
		      v_html +=  "</table>"; 
		      
		      $("tbody#departments_content").html(v_html);
		      
		 },
		 error: function(request, status, error){
			alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		 }
	 });
 }
 
 
 // 팀정보 조회하기
 function select_team(){
	 $.ajax({
		 url:"<%= ctxPath%>/emp/select_team.gw",
		 dataType:"json",
		 success:function(json){
		      //console.log(JSON.stringify(json));
		      
		      
		      let t_html = "";

		      if(json.length > 0) {
		    	  $.each(json, function(index, item){
		    		  
		    		  t_html += "<tr class='teaminfo'>";
		    		  t_html +=    "<td class='team_id'> <input name='team_id' type='hidden' value="+item.team_id+">"+ item.department_name +"</td>"; 
			          t_html +=    "<td width='10%'>"+ item.team_name +"</td>";
			          t_html +=    "<td width='10%'>"+ item.t_manager_name +"</td>"; 
			          t_html +=    "<td width='20%'>"+ item.t_manager_phone +"</td>";
			          t_html +=  "<tr>"; 
		    	  });
		      }
		      
		      else {
	    		  v_html +=  "<td colspan='6'>팀 정보 없음</td>";
	    		  v_html +=  "<tr>"; 
		      }
		      
		      t_html +=  "</table>"; 
		      
		      $("tbody#teamtbl_content").html(t_html);
		      
		 },
		 error: function(request, status, error){
			alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		 }
	 });
 }
 
 function populateDepartmentsDropdown() {
	    $.ajax({
	        url: "<%= ctxPath%>/emp/select_department.gw", 
	        dataType: "json",
	        success: function (json) {
	        	//console.log(JSON.stringify(json));
	        
	            let dropdownOptions = "<option value=''>부서 선택</option>";

	            if (json.length > 0) {
	                $.each(json, function (index, item) {
	                    dropdownOptions += "<option value="+item.department_id+">"+item.department_name+"</option>";
	                });
	            }

	            $("select[name='dept_id']").html(dropdownOptions);
	            $("select[name='del_dept_id']").html(dropdownOptions);
	        },
	        error: function (request, status, error) {
	            alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
	        }
	    });
	}
 function team_id_max(departmentId) {
	    // 부서에 따른 최대 팀 값 아오기
	    $.ajax({
	        url: "<%= ctxPath%>/emp/team_id_max_by_department.gw",
	        data: { "department_id": departmentId },
	        dataType: "json",
	        success: function (json) {
	            console.log(JSON.stringify(json));
	            // {"team_id_max_by_department":503}
	            
	            let maxTeamId = json.team_id_max_by_department;
	            if (maxTeamId === null) {
	                maxTeamId = 1; // If no team exists for the selected department, set default as 1
	            } else {
	                maxTeamId++; // Increment the maximum team ID by 1 for the new team
	            }

	            // Set the team ID in the form
	            $("input[name='team_id']").val(maxTeamId);
	        },
	        error: function (request, status, error) {
	            alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
	        }
	    });
 	}
 
 function team_id_select(department_id) {
	    // 부서에 따른 팀 값 아오기
	    $.ajax({
	        url: "<%= ctxPath%>/emp/team_id_select_by_department.gw",
	        data: { "department_id": department_id },
	        dataType: "json",
	        success: function (json) {
	            console.log(JSON.stringify(json));
	            //[{"team_id":"101","team_name":"개발1팀","t_manager_id":"9901","name":"김진영"},{"team_id":"102","team_name":"개발2팀","t_manager_id":"9902","name":"이경영"},{"team_id":"103","team_name":"개발3팀","t_manager_id":"9903","name":"홍길동"}]
	            
	            let dropdownOptions = "<option value=''>팀 선택</option>";

	            if (json.length > 0) {
	                $.each(json, function (index, item) {
	                    dropdownOptions += "<option value="+item.team_id+">"+item.team_name+"</option>";
	                });
	            }

	            $("select[name='del_team_id']").html(dropdownOptions);
	            
	        },
	        error: function (request, status, error) {
	            alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
	        }
	    });
	}
 
 
 
</script>
<div style="display: flex; justify-content: space-between; width: 90%; margin-left:5%;">
    <div style="width: 48%; text-align: left;">
	<h2> 부서 관리 </h2>
 
	<div style="font-size: 10pt; margin-top: 2.5%;">
	
	    <div id="departments"  class="overscroll">
		    <table id="depttbl" class='table table-border'>
			    <thead class="fixed-header">
			   <tr> 
			     <th width="20%">부서번호</th>
			     <th width="25%">부서명</th>
			     <th width="25%">부서장명</th>
			     <th width="30%">부서장번호</th> 
			     
			   </tr>
			   </thead>
			   <tbody id="departments_content" ></tbody>
			   </table>
		        </div>
		<div class="text-right"> 
		<button class="btn btn-sm btn-primary" id="department_set" data-toggle="modal" data-target="#departmentModal">
		    부서 추가 등록
		</button>
		<button class="btn btn-sm btn-danger" id="department_del" data-toggle="modal" data-target="#departmentDelModal">
		    부서 삭제
		</button>
		</div>
	</div>
</div> 


<div style="width: 48%; text-align: left;">
	<h2> 팀 관리 </h2>
	 
		<div style="font-size: 10pt; margin-top: 2.5%;">
		
		    <div id="employees" class="overscroll">
			    <table id="teamtbl" class='table table-border'>
				    <thead class="fixed-header">
				   <tr> 
				   	 <th width="20%">부서명</th>
				     <th width="25%">팀 명</th>
				     <th width="25%">팀장명</th>
				     <th width="30%">팀장번호</th>
				   </tr>
				   </thead>
				   <tbody id="teamtbl_content"></tbody>
				   </table>
			        </div>
			<div class="text-right"> 
			<button class="btn btn-sm btn-primary" id="team_set" data-toggle="modal" data-target="#teamModal">
			    팀 추가 등록
			</button>
			<button class="btn btn-sm btn-danger" id="team_del" data-toggle="modal" data-target="#teamDelModal">
			    팀 삭제
			</button>
			</div>
		</div>
	</div> 
</div>



<!-- 부서 관리 폼 모달 -->
<div class="modal" id="departmentModal">
    <div class="modal-dialog">
        <div class="modal-content">
            <!-- Modal Header -->
            <div class="modal-header">
                <h4 class="modal-title">부서 추가 등록</h4>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            
            <!-- Modal Body -->
            <div class="modal-body">
              
                <form name="add_department_frm">
				   <table class="table">
				  		
				      <tr>
				          <th><input type="hidden" name="department_id" />부서명</th>
				          <td><input type="text" name="department_name" /></td>
				      </tr>
				      <tr>
				          <th>부서장</th>
				          <td><select name="manager_id"></select></td>
				      </tr>
				      
				   </table>
				</form>
			
            </div>
            
            <!-- Modal Footer -->
            <div class="modal-footer">
                <button type="button" id="deptset" class="btn btn-success mr-3">등록</button>
                <button type="button" class="btn btn-danger btn_reset" data-dismiss="modal">취소</button>
            </div>
        </div>
    </div>
</div>


<!-- 부서 관리 폼 모달 -->
<div class="modal" id="departmentDelModal">
    <div class="modal-dialog">
        <div class="modal-content">
            <!-- Modal Header -->
            <div class="modal-header">
                <h4 class="modal-title">부서 삭제</h4>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            
            <!-- Modal Body -->
            <div class="modal-body">
              
                <form name="del_department_frm">
				   <table class="table">
				  
				      <tr>
				          <th>부서명</th>
				          <td><select name="dept_id"> </select></td>
				      </tr>
				      
				      
				   </table>
				</form>
			
            </div>
            
            <!-- Modal Footer -->
            <div class="modal-footer">
                <button type="button" id="deptdel" class="btn btn-success mr-3">삭제</button>
                <button type="button" class="btn btn-danger btn_reset" data-dismiss="modal">취소</button>
            </div>
        </div>
    </div>
</div>

<!-- 팀 관리 폼 모달 -->
<div class="modal" id="teamModal">
    <div class="modal-dialog">
        <div class="modal-content">
            <!-- Modal Header -->
            <div class="modal-header">
                <h4 class="modal-title">팀 추가 등록</h4>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            
            <!-- Modal Body -->
            <div class="modal-body">
              
                <form name="add_team_frm">
				   <table class="table">
				      <tr>
				          <th>부서번호</th>
				          <td><select name="dept_id"></select></td>
				      </tr>				  
				      <tr>
				          <th>팀 번호</th>
				          <td><input type="text" name="team_id" /></td>
				      </tr>
				      <tr>
				          <th>팀 명</th>
				          <td><input type="text" name="team_name" placeholder="부서명 + 부서끝번호 팀"/></td>
				      </tr>
				      <tr>
				          <th>팀장 대상자</th>
				          <td><select name="t_manager_id"></select></td>
				      </tr>
				   </table>
				</form>
            </div>
            
            <!-- Modal Footer -->
            <div class="modal-footer">
                <button type="button" id="teamset" class="btn btn-success mr-3">등록</button>
                <button type="button" class="btn btn-danger btn_reset" data-dismiss="modal">취소</button>
            </div>
        </div>
    </div>
</div>



<!-- 부서 관리 폼 모달 -->
<div class="modal" id="teamDelModal">
    <div class="modal-dialog">
        <div class="modal-content">
            <!-- Modal Header -->
            <div class="modal-header">
                <h4 class="modal-title">팀 삭제</h4>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            
            <!-- Modal Body -->
            <div class="modal-body">
              
                <form name="del_team_frm">
				   <table class="table">
				  
				      <tr>
				          <th>부서명</th>
				          <td><select name="del_dept_id"> </select></td>
				      </tr>
				      <tr>
				          <th>팀 명</th>
				          <td><select name="del_team_id"> </select></td>
				      </tr>
				      
				   </table>
				</form>
			
            </div>
            
            <!-- Modal Footer -->
            <div class="modal-footer">
                <button type="button" id="teamdel" class="btn btn-success mr-3">삭제</button>
                <button type="button" class="btn btn-danger btn_reset" data-dismiss="modal">취소</button>
            </div>
        </div>
    </div>
</div>

<!-- 모달 창 -->
<div class="modal fade" id="deptInfoModal">
  <div class="modal-dialog">
    <div class="modal-content">
    
      <!-- 모달 헤더 -->
      <div class="modal-header">
        <h4 class="modal-title">부서 상세 정보</h4>
        <button type="button" class="close" data-dismiss="modal">&times;</button>
      </div>
      
	      <div style="width: 95%; margin: auto;">
	      	<div class="mb-2" style="display: flex;">
	      		<span style="font-size: 15pt; font-weight: bold;" id="myDeptName"></span>
	      		
	      	</div>
	    	<table class="table table-hover shadow">
	    		<thead><tr style="background-color: #ccff99;">
	    			<th style="width: 20%;">직급</th>
	    			<th style="width: 20%;">성함</th>
	    			<th style="width: 20%;">연락처</th>
	    		</thead>
	    		<tbody id="deptEmpList">
	    		</tbody>
	    	</table>
	      </div>
      
    </div>
  </div>
</div>



<!-- 모달 창 -->
<div class="modal fade" id="teamInfoModal">
  <div class="modal-dialog">
    <div class="modal-content">
    
      <!-- 모달 헤더 -->
      <div class="modal-header">
        <h4 class="modal-title">팀 상세 정보</h4>
        <button type="button" class="close" data-dismiss="modal">&times;</button>
      </div>
      
	      <div style="width: 95%; margin: auto;">
	      	<div class="mb-2" style="display: flex;">
	      		<span style="font-size: 15pt; font-weight: bold;" id="myTeamName"></span>
	      		
	      	</div>
	    	<table class="table table-hover shadow">
	    		<thead><tr style="background-color: #ccff99;">
	    			<th style="width: 20%;">직급</th>
	    			<th style="width: 20%;">성함</th>
	    			<th style="width: 20%;">연락처</th>
	    		</thead>
	    		<tbody id="teamEmpList">
	    		</tbody>
	    	</table>
	      </div>
      
    </div>
  </div>
</div>
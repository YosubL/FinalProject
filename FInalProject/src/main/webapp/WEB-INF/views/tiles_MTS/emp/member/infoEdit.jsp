<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
	String ctxPath = request.getContextPath();
%>

<style>

body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    margin: 0;
    padding: 0;
}

table.myinfo_tbl {
    width: 100%;
    border-collapse: collapse;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 8px 12px 0 rgba(0, 0, 0, 0.1);
}


table.myinfo_tbl th {
	border: solid 1px #ddd;
    background-color: #ffffff;
    text-align: center;
    padding: 12px;
    font-weight: bold;
    
}


table.myinfo_tbl td {
    border: solid 1px #ddd;
    padding: 8px;
    text-align: center;
    
}

table#table1{
	width: 70%; 
	margin-left: 10px;
}

table#table2{
	width: 82.3%; 
	margin: 3% auto 0;
}

tr {
	height: 53px;
}

table#table2 td.input_size {
	padding-left: 2%;
	text-align: left;
}

input {
	padding-left: 3%;
}

select {
	
    height: 25px;
    text-align: center;
}

div#photo {
	border: solid 1px #ddd;
	width: 200px; 
	height: 200px; 
	vertical-align: top; 
	text-align: center;
	border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 8px 12px 0 rgba(0, 0, 0, 0.1);
}

img {
	width: 200px;
	height: 200px;
}

div#top {
	text-align: center; 
	display: flex; 
	align-items: center;
}

h1 {
	margin: 2% 0 2% 9.5%; 
	margin-right: auto;
}

button#btnUpdate {
	margin-right: 1%;
	background-color: rgb(3, 199, 90);
    color: #fff; 
    border: 1px solid #4CAF50; 
    padding: 10px 20px; 
    font-size: 16px;
    cursor: pointer; 
    border-radius: 5px; 
    transition: background-color 0.3s ease;
}

button#btnCancel {
	margin-right: 10%;
	background-color: rgb(255, 0, 0);
    color: #fff; 
    border: 1px solid #4CAF50; 
    padding: 10px 20px; 
    font-size: 16px;
    cursor: pointer; 
    border-radius: 5px; 
    transition: background-color 0.3s ease;
}

.filebox label {
    display: inline-block;
    color: #fff;
    vertical-align: middle;
    text-align: center;
    background-color: #999999;
    cursor: pointer;
    height: 40px;
    margin: 1% 0 0 9.5%;
    padding-top: 9px;
    width: 10.5%;
}

.filebox input[type="file"] {
	position: absolute;
	width: 0;
	height: 0;
	padding: 0;
	overflow: hidden;
	border: 0;
}

.error {
	border: solid 2px red !important;
	box-shadow: 0 0 1px red;
}
    
</style>



<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script type="text/javascript">

$(document).ready(function(){

	 // 부서 이름 뿌리기
  	 populateDepartmentsDropdown();
  	 
	$("input.error").removeClass("error");
	$("input.check").val(1);
	
	
	
	$("select[name='fk_job_id']").change(function () {
	    const selectedJobId = $(this).val();
	    const selectedOption = $(this).find("option[value='" + selectedJobId + "']");
	    const fkTeamId = selectedOption.data("fk_team_id");
	    //alert("Selected Job ID: " + selectedJobId + ", FK Team ID: " + fkTeamId);
	});


	
	
	$("select[name='fk_department_id']").change(function () {
		    const selectedDepartmentId = $(this).val();
		     //alert(selectedDepartmentId);
		     job_id_select(selectedDepartmentId);
		});
	
}); // end of $(document).ready(function(){})----------------


function job_id_select(department_id) {
	    // 부서에 따른 팀 값 아오기
	    $.ajax({
	        url: "<%= ctxPath%>/emp/job_id_select_by_department.gw",
	        data: { "department_id": department_id },
	        dataType: "json",
	        success: function (json) {
	            //console.log(JSON.stringify(json));
	            //
	            
	            let dropdownOptions = "<option value=''>직책 선택</option>";
				
	            if (json.length > 0) {
	                $.each(json, function (index, item) {
	                	  
	                    dropdownOptions += "<option value='" + item.job_id + "' data-gradelevel='" + item.gradelevel + "' data-fk_team_id='" + item.fk_team_id + "'>" + item.job_name + "</option>";
	                	
	                });
	            }
	          
	            $("select[name='fk_job_id']").html(dropdownOptions);
	            
	        },
	        error: function (request, status, error) {
	            alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
	        }
	    });
	}

function btnUpdate() {
	
	const frm = document.myinfoEditFrm;
    const selectedJobId = $("select[name='fk_job_id']").val();
    const selectedOption = $("select[name='fk_job_id'] option:selected");
    const fkTeamId = selectedOption.data("fk_team_id");
    const gradelevel = selectedOption.data("gradelevel");

    // input 엘리먼트에 값을 설정
    frm.fk_team_id.value = fkTeamId;
    frm.gradelevel.value = gradelevel;

    frm.method = "post";
    frm.action = "<%= ctxPath%>/emp/infoEditEnd.gw";
    frm.submit();
	
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

	            $("select[name='fk_department_id']").html(dropdownOptions);
	           
	        },
	        error: function (request, status, error) {
	            alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
	        }
	    });
	}


</script>
	
	<div id="top">
	    <h1>인사이동</h1>
	   
	</div>
	
	<form name="myinfoEditFrm" enctype="multipart/form-data">
		<div style="display: flex; justify-content: center;">
		
			<div id="photo">
				<img src="<%= ctxPath%>/resources/images/empImg/${requestScope.empOneDetail.photo}" id="previewImg" />
			</div>
				
			<table id="table1" class="myinfo_tbl">
		 
				<tr>
					<th>성명</th>
					<td colspan="2">${requestScope.empOneDetail.name}</td>
					<th>사원번호</th>
					<td>${requestScope.empOneDetail.employee_id}<input type="hidden" name="employee_id" value="${requestScope.empOneDetail.employee_id}"/></td>
				</tr>
		 
				<tr>
					<th>부서명</th>
					<td>${requestScope.empOneDetail.department_name}</td><td><select name="fk_department_id"></select></td>
					<th>팀명</th>
					<td>${requestScope.empOneDetail.team_name} <input type="hidden" name="fk_team_id" /></td>
				</tr>
				
				<tr>
					<th>직급</th>
					<td>${requestScope.empOneDetail.job_name}<input type="hidden" name="gradelevel"/></td><td><select name="fk_job_id"></select></td>
					<th>입사일자</th>
					<td>${requestScope.empOneDetail.hire_date}</td>
				</tr>
				
			
			</table>
			
		</div>
		
		
		<table id="table2" class="myinfo_tbl">
		
			<tr>
				<th>이메일</th>
				<td class="input_size">${requestScope.empOneDetail.email}</td>
				<th>연락처</th>
				<td class="input_size">
					${requestScope.empOneDetail.phone}
				</td>
			</tr>
	
			<tr>
				<th>생년월일</th>
				<td class="input_size">${requestScope.empOneDetail.birthday.substring(0, 2)}년 ${requestScope.empOneDetail.birthday.substring(3, 5)}월 ${requestScope.empOneDetail.birthday.substring(6, 8)}일</td>
				<th>성별</th>
				<td class="input_size">${requestScope.empOneDetail.gender}</td>
			</tr>
			
			<tr>
				<th>우편번호</th>
				<td class="input_size">${requestScope.empOneDetail.postcode}</td>
				<th>주   소</th>
				<td class="input_size">${requestScope.empOneDetail.address}</td>
			</tr>
			
			
			<tr>
				<th>은행명</th>
				<td class="input_size">
					
					${requestScope.empOneDetail.bank_name}
						
				</td>
				<th>계좌번호</th>
				<td class="input_size">
					${requestScope.empOneDetail.bank_code}
				</td>
			</tr>
			
		</table>
		
	</form>
	
	<div class="my-5 text-center">
	 <button type="button" id="btnUpdate" onclick="btnUpdate()">수정하기</button>
	    <button type="button" id="btnCancel">취소</button>  
	</div>









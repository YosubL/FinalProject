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

table#sal_tbl {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 30px;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 8px 12px 0 rgba(0, 0, 0, 0.1);
}


table#sal_tbl th {
    background-color: #ffffff;
    text-align: center;
    padding: 12px;
    font-weight: bold;
}


table#sal_tbl td {
    border: solid 1px #ddd;
    padding: 8px;
    text-align: center;
}


div[align="center"] {
    border: solid 0px gray;
    width: 80%;
    margin: 30px auto;
}


div#name {
    text-align: center;
    margin-bottom: 50px;
}
    
    
button.green-button {
	background-color: #4CAF50;
	color: #FFFFFF; 
	padding: 5px 10px; 
	border: none; 
	border-radius: 5px; 
	cursor: pointer; 
}


button.green-button:hover {
  background-color: #45a049; 
}

</style>

<script type="text/javascript">

$(document).ready(function(){
	
	// ==== Excel 파일로 다운받기 시작 ==== // 
	$("button#btnSalaryExcel").click(function(){
		
		const arr_year_month = new Array();
		
		$("input:checkbox[name='year_month']:checked").each(function(index, item){ 
			arr_year_month.push($(item).val());
		});
		   
		const str_year_month = arr_year_month.join();
		   
	  	console.log("~~~ 확인용 str_year_month => " + str_year_month);
		// ~~~ 확인용 str_year_month => 2023-12,2023-11,2023-09
		  
		const frm = document.selectExcelFrm;
		frm.str_year_month.value = str_year_month;
		frm.method = "post";
		frm.action = "<%= ctxPath%>/salary/downloadExcelFile.gw";  
		frm.submit();  	
	});
    // ==== Excel 파일로 다운받기 끝 ==== //
	
});// end of $(document).ready(function(){})---------------------

function salaryStatement(year_month, fk_employee_id) {

	const frm = document.salaryFrm;
	frm.year_month.value = year_month;
	frm.fk_employee_id.value = fk_employee_id;
	frm.method = "post";
	frm.action = "<%= ctxPath%>/salaryStatement.gw";  
	frm.submit();
}

</script>

<div style="width: 80%; margin: 0 auto;">
	<button type="button" class="green-button" style="margin: 3% 0; float: right;" id="btnSalaryExcel">Excel파일로저장</button>
	<form name="selectExcelFrm">
	<table id="sal_tbl">
		<thead>
			<tr>
				<th style="width: 5%;"></th>
				<th style="width: 12.5%;">귀속연월</th>
				<th style="width: 20%;">산정 기간</th>
				<th style="width: 12.5%;">지급일</th>
				<th style="width: 12.5%;">지급 총액</th>
				<th style="width: 12.5%;">공제 총액</th>
				<th style="width: 12.5%;">실수령액</th>
				<th style="width: 12.5%;">급여 명세서</th>
			</tr>
		</thead>
		
		
		
		<c:forEach var="monthsal" items="${requestScope.monthSalList}">
	        <tr>
	            <td><input type="checkbox" name="year_month" id="${status.index}" value="${monthsal.year_month}" /></td>
	            <td>${monthsal.year_month}</td>
	            <td>${monthsal.year_month}-01 ~ ${monthsal.last_day_of_month}</td>
	            <td>${monthsal.next_month}-15</td>
	            <td>${monthsal.p_sum}</td>
	            <td>${monthsal.m_sum}</td>
	            <td>${monthsal.total}</td>
	            <td><button type="button" class="green-button" onclick="salaryStatement('${monthsal.year_month}', '${monthsal.fk_employee_id}')">보기</button></td>
	        </tr>
	        
	    </c:forEach>
	</table>
	<input type="hidden" name="str_year_month" />
	</form>
</div>



<form name="salaryFrm">
	<input type="hidden" name="year_month" />
	<input type="hidden" name="fk_employee_id" />
	
</form>
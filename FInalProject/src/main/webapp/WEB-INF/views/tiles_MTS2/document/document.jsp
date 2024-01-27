<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	String ctxPath = request.getContextPath();
%>

<style>
	
        
    table {
        border-collapse: collapse;
        width: 100%;
    }

    td, th {
        border: 1px solid #dddddd;
        text-align: left;
        padding: 8px;
    }
    
    span {
    	display:inline-block;
    	font-weight:bold;
    }
</style>

<script>
    $(document).ready(function(){
    	
    	var currentDate = new Date();
    	var currentYear = currentDate.getFullYear();
    	var currentMonth = currentDate.getMonth() + 1; // 월은 0부터 시작하므로 1을 더해줍니다.
    	var currentDay = currentDate.getDate();
    	
    	$("span#sysdate").html(currentYear+"년 "+currentMonth+"월 "+currentDay+"일 ");

    	console.log(currentYear, currentMonth, currentDay);
    	
    });//end of $(document).ready(function()
    		
    
    function printContent() {
    	$("#print").hide();
        window.print();
    }
</script>

<div class="container" style="margin-top:50px;">
	<div id="print" style="width:100%; text-align:right;">
		<button type="button" style="background-color:white;" onclick="printContent()"><i class="fa-3x fa-solid fa-print"></i></button>
	</div>
	 <div style="width:100%; text-align:center;">
		<h3>재직증명서</h3>
	 </div>
	 
	<table style="width:100%; border:solid 1px red;">
		<tr>
			<td>소 속</td>
			<td>${requestScope.paraMap.department_name}</td>
			<td>직 위</td>
			<td>${requestScope.paraMap.job_name}</td>
		</tr>
		
		<tr>
			<td>성 명</td>
			<td>${requestScope.paraMap.name}</td>
			<td>생년월일</td>
			<td>${requestScope.paraMap.birthday}</td>
		</tr>
		
		<tr>
			<td>입사년월일</td>
			<td>${requestScope.paraMap.hire_date}</td>
			<td>주민등록번호</td>
			<td>${requestScope.paraMap.jubun}</td>
		</tr>
		
		<tr>
			<td>주 소</td>
			<td colspan="3">${requestScope.paraMap.address}</td>
			
		</tr>
		
		<tr>
			<td colspan="4">
			
				<span style="margin:50px 50px;">( 용도 : ${requestScope.paraMap.purpose} )</span>
				
				
				<span style="display:block; margin:50px 50px;">상기와 같이 재직하고 있음을 증명함.</span>
				
				<div style=" width:100%; margin-top:150px; text-align:right;">
					<span id="sysdate" style="margin-right:150px;"></span>
				</div>
				
				<div style="display:flex; margin-top:50px;">
					<span style="display:block; font-size:30px; margin:0 auto;">그룹웨어 회사[직인]</span>
					
					<c:if test="${requestScope.paraMap.category =='전자도장'}">
						<img style="position:absolute; width:100px; height:100px; margin-top:-25px; left: 55%;" src="<%=ctxPath%>/resources/images/법인도장.png"/>
					</c:if>
					
				</div>
				
				<div style="display:flex; margin-top:20px;">
					<span style="display:block; font-size:30px; margin:0 auto;">대표이사:문새한</span>
				</div>
				
				
				
				
			</td>
			
		</tr>
	</table>
	
</div>
	
	
	

	
	


<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
   String ctxPath = request.getContextPath();
%>

<style type="text/css">

table#table2 {
    border: solid 2px black;
    width: 100%;
    border-collapse: collapse;
}

table#table2 th, td {
    border: solid 1px black;
    padding: 8px
}


table#table2 > tbody > tr > th,
table#table2 > tbody > tr:nth-child(1) > td {
   text-align: center;
}

table#table2 > tbody > tr > td:nth-child(2) {
   text-align: right;
}

table#table1 th {
   text-align: center;
}

button {
   float: right; 
   display: flex; 
   align-items: center; 
   justify-content: center;
   width: 8%;
   height: 50px;
}

img {
   width: 100px;
   height: 100px;
}
    
</style>

<link href="https://fonts.googleapis.com/icon?family=Material+Icons"
      rel="stylesheet">

<link href="https://fonts.googleapis.com/icon?family=Material+Icons+Outlined"
      rel="stylesheet">

<script type="text/javascript">

$(document).ready(function(){

   

}); // end of $(document).ready(function(){})---------------------------

function print() {
    var tableHTML = $("#table1").prop('outerHTML') + $("#table2").prop('outerHTML');
    var styles = "<style>" +
                    "#table2 {" +
                        "border: solid 2px black;" +
                        "width: 100%;" +
                        "border-collapse: collapse;" +
                    "}" +
                    "#table2 th, #table2 td {" +
                        "border: solid 1px black;" +
                        "padding: 8px;" +
                    "}" +
                    // Add more styles if needed
                "</style>";

    var printWindow = window.open('', '_blank');
    printWindow.document.write('<html><head><title>Print</title>' + styles + '</head><body>');
    printWindow.document.write(tableHTML);
    printWindow.document.write('</body></html>');
    printWindow.document.close();
    
    printWindow.print();
}
</script>


<div style="width: 60%; margin: 0 auto 5%;">

   <button type="button" onclick="print()">
       <span class="material-icons-outlined">print</span>
   </button>
   
   <table id="table1" style=" width: 100%;">
      <tr style="height: 100px;">
         <th style="width: 25%; font-size: 15pt;">(${requestScope.salaryStatement.YEAR_MONTH})</th>
         <th colspan="2" style="width: 50%; font-size: 20pt;">급여명세서</th>
         <th style="width: 25%;"></th>
      </tr>
   </table>
   
   <table id="table2" style=" width: 100%;">
   
      <tr>
         <th style="width: 25%;">이름</th>
         <th style="width: 25%;">${requestScope.salaryStatement.NAME} ${requestScope.salaryStatement.JOB_NAME}님</th>
         <th style="width: 25%;">지급일</th>
         <td style="width: 25%;">${requestScope.salaryStatement.YEAR_MONTH}-15일</td>
      </tr>
      
      
      <tr>
         <th>기본급여</th>
         <td>
            <fmt:formatNumber value="${requestScope.salaryStatement.SALARY}" pattern="#,###" />원
         </td>
         <td colspan="2"></td>
      </tr>
      
      <tr>
         <th>직책수당</th>
         <td>
            <c:if test="${requestScope.salaryStatement.POSITION_ALLOWANCE ne 0}">
               <fmt:formatNumber value="${requestScope.salaryStatement.POSITION_ALLOWANCE}" pattern="#,###" />원
            </c:if>
            <c:if test="${requestScope.salaryStatement.POSITION_ALLOWANCE eq 0}">
               -
            </c:if>
         </td>
         <td colspan="2"></td>
      </tr>
      
      <tr>
         <th>추가근무수당</th>
         <td>
            <c:if test="${requestScope.salaryStatement.EXTRA_WORK_ALLOWANCE ne 0}">
               <fmt:formatNumber value="${requestScope.salaryStatement.EXTRA_WORK_ALLOWANCE}" pattern="#,###" />원
            </c:if>
            <c:if test="${requestScope.salaryStatement.EXTRA_WORK_ALLOWANCE eq 0}">
               -
            </c:if>
         </td>
         <td colspan="2"></td>
      </tr>
      
      <tr>
         <th>상여금</th>
         <td>
            <c:if test="${requestScope.salaryStatement.BONUS ne 0}">
               <fmt:formatNumber value="${requestScope.salaryStatement.BONUS}" pattern="#,###" />원
            </c:if>
            <c:if test="${requestScope.salaryStatement.BONUS eq 0}">
               -
            </c:if>
         </td>
         <td colspan="2">연 200% (3,6,9,12월 지급)</td>
      </tr>
      
      <tr>
         <th>급여계</th>
         <td><fmt:formatNumber value="${requestScope.salaryStatement.P_SUM}" pattern="#,###" />원</td>
         <td colspan="2"></td>
      </tr>
      
      <tr>
         <th>휴가비</th>
         <td>
            <c:if test="${requestScope.salaryStatement.VACATION_BONUS ne 0}">
               <fmt:formatNumber value="${requestScope.salaryStatement.VACATION_BONUS}" pattern="#,###" />원
            </c:if>
            <c:if test="${requestScope.salaryStatement.VACATION_BONUS eq 0}">
               -
            </c:if>
         </td>
         <td colspan="2">비과세 (1,7월 지급)</td>
      </tr>
      
      <tr>
         <th>국민연금</th>
         <td>
            <fmt:formatNumber value="${requestScope.salaryStatement.NATIONAL_PENSION}" pattern="#,###" />원
         </td>
         <td colspan="2"></td>
      </tr>
      
      <tr>
         <th>장기요양</th>
         <td>
            <fmt:formatNumber value="${requestScope.salaryStatement.LONG_TERM_CARE_PEE}" pattern="#,###" />원
         </td>
         <td colspan="2"></td>
      </tr>
      
      <tr>
         <th>건강보험</th>
         <td>
            <fmt:formatNumber value="${requestScope.salaryStatement.HEALTH_INSURANCE}" pattern="#,###" />원
         </td>
         <td colspan="2"></td>
      </tr>
      
      <tr>
         <th>고용보험</th>
         <td>
            <fmt:formatNumber value="${requestScope.salaryStatement.EMPLOYMENT_INSURANCE}" pattern="#,###" />원
         </td>
         <td colspan="2"></td>
      </tr>
      
      <tr>
         <th>공제합계</th>
         <td>
            <fmt:formatNumber value="${requestScope.salaryStatement.M_SUM}" pattern="#,###" />원
         </td>
         <td colspan="2"></td>
      </tr>
      
      <tr>
         <th>비과세수당</th>
         <td>
            <c:if test="${requestScope.salaryStatement.MEAL_ALLOWANCE ne 0}">
               <fmt:formatNumber value="${requestScope.salaryStatement.MEAL_ALLOWANCE}" pattern="#,###" />원
            </c:if>
            <c:if test="${requestScope.salaryStatement.MEAL_ALLOWANCE eq 0}">
               -
            </c:if>
         </td>
         <td colspan="2">식비 1일 1만원</td>
      </tr>
      
      <tr>
         <th>실 지급액</th>
         <td>
            <fmt:formatNumber value="${requestScope.salaryStatement.TOTAL}" pattern="#,###" />원
         <td colspan="2">*급여계 - 공제합계</td>
      </tr>
      
      <tr>
         <th>날인 (서명)</th>
         <td colspan="3">
            <img src="<%= ctxPath%>/resources/images/sign/별확인.jpg" /> 
         </td>
      </tr>
      
   </table>
   
   
   
</div>
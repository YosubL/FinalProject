<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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

#noSal {
   font-size: 20pt;
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



.highcharts-figure,
.highcharts-data-table table {
    min-width: 310px;
    max-width: 1450px;
    margin: 1em auto;
}

#container {
    height: 400px;
}

.highcharts-data-table table {
    font-family: Verdana, sans-serif;
    border-collapse: collapse;
    border: 1px solid #ebebeb;
    margin: 10px auto;
    text-align: center;
    width: 100%;
    max-width: 500px;
}

.highcharts-data-table caption {
    padding: 1em 0;
    font-size: 1.2em;
    color: #555;
}

.highcharts-data-table th {
    font-weight: 600;
    padding: 0.5em;
}

.highcharts-data-table td,
.highcharts-data-table th,
.highcharts-data-table caption {
    padding: 0.5em;
}

.highcharts-data-table thead tr,
.highcharts-data-table tr:nth-child(even) {
    background: #f8f8f8;
}

.highcharts-data-table tr:hover {
    background: #f1f7ff;
}

#highcharts-f06jkva-0 > svg > rect.highcharts-background {
   width: 1450px;
}



</style>


<script src="<%= ctxPath%>/resources/Highcharts-10.3.3/code/highcharts.js"></script>
<script src="<%= ctxPath%>/resources/Highcharts-10.3.3/code/modules/exporting.js"></script>
<script src="<%= ctxPath%>/resources/Highcharts-10.3.3/code/modules/export-data.js"></script>
<script src="<%= ctxPath%>/resources/Highcharts-10.3.3/code/modules/accessibility.js"></script>   


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
   
    
    $.ajax({
      url: "<%= ctxPath%>/salaryChart.gw",
      dataType: "json",
      success: function (json){
      //   console.log(JSON.stringify(json));
         
         let salaryArr = [];
         let dateArr = [];
         for(let i=0; i<json.length; i ++){
            salaryArr.push(Number(json[i].total));
            dateArr.push(json[i].year_month);
         }
         
         dateArr.reverse();
      //   console.log(salaryArr);
      //   console.log(dateArr);
      
         if(dateArr.length == 0){
             $("div#container").empty();
          }
          else{
         
         /////////////////////////////////////////////////////////
         Highcharts.chart('container', {
             chart: {
                 type: 'column'
             },
             title: {
                 text: '급여'
             },
             xAxis: {
                 categories: dateArr,
                 crosshair: true
             },
             yAxis: {
                 min: 0,
                 title: {
                     text: '급여'
                 }
             },
             tooltip: {
                 headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                 pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                     '<td style="padding:0"><b>{point.y:f} 원</b></td></tr>',
                 footerFormat: '</table>',
                 shared: true,
                 useHTML: true
             },
             plotOptions: {
                 column: {
                     pointPadding: 0.2,
                     borderWidth: 0
                 }
             },
             series: [{
                 name: '급여',
                 data: salaryArr
         
             }]
         });
         ////////////////////////////////////////////////////////////
          }
      },
      error: function(request, status, error){
         alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
      }
    });
    
  
   $("#checkAll").click(function () {
      $("input:checkbox[name='year_month']").prop('checked', $(this).prop('checked'));
   });
   
   $("input:checkbox[name='year_month']").click(function () {

      let checkboxLength = $("input:checkbox[name='year_month']").length;
       
       let checkdLength = $("input:checkbox[name='year_month']:checked").length;

       $("#checkAll").prop('checked', checkboxLength === checkdLength);
   });
    
    
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
            <th style="width: 5%;">
               <input type="checkbox" id="checkAll" />
            </th>
            <th style="width: 12.5%;">귀속연월</th>
            <th style="width: 20%;">산정 기간</th>
            <th style="width: 12.5%;">지급일</th>
            <th style="width: 12.5%;">지급 총액</th>
            <th style="width: 12.5%;">공제 총액</th>
            <th style="width: 12.5%;">실수령액</th>
            <th style="width: 12.5%;">급여 명세서</th>
         </tr>
      </thead>
      
      <c:if test="${empty requestScope.monthSalList}">
         <tr>
               <td colspan="8" id="noSal">급여 내역이 없습니다.</td>
           </tr>
      </c:if>
      <c:if test="${not empty requestScope.monthSalList}">
      <c:forEach var="monthsal" items="${requestScope.monthSalList}">
            <tr>
               <td><input type="checkbox" name="year_month" id="${status.index}" value="${monthsal.year_month}" /></td>
               <td>${monthsal.year_month}</td>
               <td>${monthsal.year_month}-01 ~ ${monthsal.last_day_of_month}</td>
               <td>${monthsal.next_month}-15</td>
               <td>
                  <fmt:formatNumber value="${monthsal.p_sum}" pattern="#,###" />원
               </td>
               <td>
                  <fmt:formatNumber value="${monthsal.m_sum}" pattern="#,###" />원
               </td>
               <td>
                  <fmt:formatNumber value="${monthsal.total}" pattern="#,###" />원
               
               </td>
               <td><button type="button" class="green-button" onclick="salaryStatement('${monthsal.year_month}', '${monthsal.fk_employee_id}')">보기</button></td>
           </tr>
       </c:forEach>
       </c:if>
   </table>
   <input type="hidden" name="str_year_month" />
   </form>
</div>


<figure class="highcharts-figure">
    <div id="container"></div>
</figure>



<form name="salaryFrm">
   <input type="hidden" name="year_month" />
   <input type="hidden" name="fk_employee_id" />
   
</form>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" 	uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
   String ctxPath = request.getContextPath();
%>

<style type="text/css">
div#container {width: 75%; margin:0 auto; margin-top:100px;}
div#div_chart {width: 80%; min-height: 1100px; margin:auto;}
a {
	margin-right: 10px;
	text-decoration: none !important;
	color: black;
	font-size: 13pt;
}

#Navbar > li > a {
	color: gray;
	font-weight: bold;
	font-size: 17pt;
}
#Navbar > li > a:hover {
	color: black;
}

/* 테이블 스타일 변경 */
div.listContainer{
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 30px;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 12px 16px 0 rgba(0, 0, 0, 0.1);
}
	
/* 차트 관련 css*/
.highcharts-figure,
.highcharts-data-table table {
    min-width: 320px;
    max-width: 800px;
    margin: 1em auto;
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

input[type="number"] {
    min-width: 50px;
}

nav.navbar {margin-left: 2%; margin-right: 5%; width: 80%; background-size: cover; background-position: center; background-repeat: no-repeat; height: 70px}
</style>
<%-- HighChart 관련 --%>
<script src="<%= ctxPath%>/resources/Highcharts-10.3.3/code/highcharts.js"></script>
<script src="<%= ctxPath%>/resources/Highcharts-10.3.3/code/modules/exporting.js"></script>
<script src="<%= ctxPath%>/resources/Highcharts-10.3.3/code/modules/export-data.js"></script>
<script src="<%= ctxPath%>/resources/Highcharts-10.3.3/code/modules/accessibility.js"></script>

<script src="<%= ctxPath%>/resources/Highcharts-10.3.3/code/modules/series-label.js"></script>

<script type="text/javascript">
// Data retrieved from https://netmarketshare.com
$(document).ready(function(){
	$.ajax({
		url:"<%= ctxPath%>/monthlyVacCnt.gw",
		dataType:"json",
		success:function(json){
			let resultArr = [];
			
			for(let i=0; i<json.length; i++) {
				
				let startDate_Arr = [];
				startDate_Arr.push(Number(json[i].nowMonth11));
				startDate_Arr.push(Number(json[i].nowMonth10));
				startDate_Arr.push(Number(json[i].nowMonth9));
				startDate_Arr.push(Number(json[i].nowMonth8));
				startDate_Arr.push(Number(json[i].nowMonth7));
				startDate_Arr.push(Number(json[i].nowMonth6));
				startDate_Arr.push(Number(json[i].nowMonth5));
				startDate_Arr.push(Number(json[i].nowMonth4));
				startDate_Arr.push(Number(json[i].nowMonth3));
				startDate_Arr.push(Number(json[i].nowMonth2));
				startDate_Arr.push(Number(json[i].nowMonth1));
				startDate_Arr.push(Number(json[i].nowMonth));
               
                let obj = {data: startDate_Arr};
                
                resultArr.push(obj); // 배열속에 객체 넣은것
				
			} // end of for --------------------
			/////////////////////////////////////
			Highcharts.chart('chart_container', {

                title: {
                    text: '최근 1년 우리회사 월별 휴가사용수'
                },
            
                yAxis: {
                    title: {
                        text: '휴가 사용수'
                    }
                },
            
                xAxis: {
                    accessibility: {
                        rangeDescription: '범위: 2001 to 2008'
                    }
                },
            
                legend: {
                    layout: 'vertical',
                    align: 'right',
                    verticalAlign: 'middle'
                },
            
                plotOptions: {
                    series: {
                        label: {
                            connectorAllowed: false
                        },
                        pointStart: 02
                    }
                },
            
                series: resultArr,
            
                responsive: {
                    rules: [{
                        condition: {
                            maxWidth: 500
                        },
                        chartOptions: {
                            legend: {
                                layout: 'horizontal',
                                align: 'center',
                                verticalAlign: 'bottom'
                            }
                        }
                    }]
                }
            
            });
            ///////////////////////////////////////////////////////////////
		},
		error: function(request, status, error){
		 	alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	  	}
	});
}); // end of $(document).ready()


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
   
	<div style="display: flex;">   
		<div id='div_chart'>
		   <h2 style="margin: 50px 0;">기간별 휴가 사용 통계</h2>
		   <div id="chart_container"></div>
		   <div id="table_container" style="margin: 40px 0 0 0;"></div>
		</div>
	</div>
</div>
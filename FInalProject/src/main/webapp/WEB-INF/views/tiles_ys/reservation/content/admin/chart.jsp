<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
   String ctxPath = request.getContextPath();
%>

<style type="text/css">
.highcharts-figure,
.highcharts-data-table table {
    min-width: 360px;
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

</style>
	
<script src="<%= ctxPath%>/resources/Highcharts-10.3.3/code/highcharts.js"></script>
<script src="<%= ctxPath%>/resources/Highcharts-10.3.3/code/modules/series-label.js"></script>
<script src="<%= ctxPath%>/resources/Highcharts-10.3.3/code/modules/exporting.js"></script>
<script src="<%= ctxPath%>/resources/Highcharts-10.3.3/code/modules/export-data.js"></script>
<script src="<%= ctxPath%>/resources/Highcharts-10.3.3/code/modules/accessibility.js"></script>



<figure class="highcharts-figure">
    <div id="container" style="margin-top:200px;"></div>
    <p class="highcharts-description">
        Basic line chart showing trends in a dataset. This chart includes the
        <code>series-label</code> module, which adds a label to each line for
        enhanced readability.
    </p>
</figure>





<script type="text/javascript">
$.ajax({
    url: "<%= ctxPath%>/meetingroomchart.gw",
    dataType: "json",
    success: function (json) {
        //console.log(JSON.stringify(json));
        
        resultArr = [];
        
        for(var i=0; i<json.length; i++){
        	
        	let objArr = [];
        	objArr.push( Number(json[i].nowMonth6));
        	objArr.push( Number(json[i].nowMonth5));
        	objArr.push( Number(json[i].nowMonth4));
        	objArr.push( Number(json[i].nowMonth3));
        	objArr.push( Number(json[i].nowMonth2));
        	objArr.push( Number(json[i].nowMonth1));
        	
        	
        	let obj = {};
        	
        	obj ={'name':json[i].MeetingRoom,
        		  'data':objArr};
        	resultArr.push(obj);
        }
        
        

        Highcharts.chart('container', {
            title: {
                text: '월별 회의실 예약 통계',
                align: 'left'
            },
            subtitle: {
                text: 'Source: db',
                align: 'left'
            },
            yAxis: {
                title: {
                    text: '예약자 수'
                }
            },
            xAxis: {
                accessibility: {
                    rangeDescription: '월별 예약자수'
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
                    pointStart: 07
                }
            },
            series: resultArr /* [{
                name: 'Installation & Developers',
                data: [43934, 48656, 65165, 81827, 112143, 142383]
            }, {
                name: 'Manufacturing',
                data: [24916, 37941, 29742, 29851, 32490, 30282]
            }, {
                name: 'Sales & Distribution',
                data: [11744, 30000, 16005, 19771, 20185, 24377]
            }, {
                name: 'Operations & Maintenance',
                data: [null, null, null, null, null, null]
            }, {
                name: 'Other',
                data: [21908, 5548, 8105, 11248, 8989, 11814]
            }] */,
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
    },
    error: function (request, status, error) {
        alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
    }
});

</script>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    String ctxPath = request.getContextPath();
%>
<link href='<%=ctxPath %>/resources/fullcalendar_5.10.1/main.min.css' rel='stylesheet' />

    <style>
                 
                  /* 전역 스타일 */
                 body {
                     font-family: Arial, sans-serif;
                     background-color: #f4f4f4;
                     paddig : 20px;
                 }
                 .parent {
               display: grid;
               grid-template-columns: repeat(6, 1fr);
               grid-template-rows: repeat(6, 1fr);
               grid-column-gap: 20px;
               grid-row-gap: 20px;
               height:600px;
               }
               
               .div1 { grid-area: 1 / 2 / 6 / 5; }
               .div2 { grid-area: 4 / 2 / 5 / 4; }
               .div3 { grid-area: 5 / 2 / 6 / 5; }
               .div4 { grid-area: 1 / 1 / 2 / 2; }
               .div5 { grid-area: 2 / 1 / 6 / 2; }
               .div6 { grid-area: 1 / 5 / 5 / 7; }
               .div7 { grid-area: 3 / 5 / 5 / 7; }
               .div8 { grid-area: 5 / 5 / 6 / 7; }
               
               .widget-container {
                   background-color: #ffffff;
                   padding: 20px;
                   border-radius: 8px;
                   box-shadow: 0 8px 12px 0 rgba(0, 0, 0, 0.1);   
         
               }
                 
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
            
            ul{ list-style: none;
               align-items: center;
               justify-content: center;
               }
         .fc-day-sun a {
              color: red;
              text-decoration: none;
            }
            
            /* 토요일 날짜 파란색 */
            .fc-day-sat a {
              color: blue;
              text-decoration: none;
            }
         
         
         /* ========== full calendar css 시작 ========== */
         .fc-header-toolbar {
            height: 30px;
         }
         
         a, a:hover, .fc-daygrid {
             color: #000;
             text-decoration: none;
             background-color: transparent;
             cursor: pointer;
             
         } 
         
         .fc-sat { color: #0000FF; }    /* 토요일 */
         .fc-sun { color: #FF0000; }    /* 일요일 */
         /* ========== full calendar css 끝 ========== */
         
         ul{
            list-style: none;
         }
         
         button.btn_normal{
            background-color: #990000;
            border: none;
            color: white;
            width: 50px;
            height: 30px;
            font-size: 12pt;
            padding: 3px 0px;
            border-radius: 10%;
         }
         
         button.btn_edit{
            border: none;
            background-color: #f5f5f5;
         }
         
         
            #registerbtn:hover{
            border: 1px solid #086BDE;
            color: white;
            background-color: rgb(3,199,90);
            font-weight:bold;
         }
         
         #registerbtn{
            width:90%;
            
         }
             
    </style>
    
<script src="<%= ctxPath%>/resources/Highcharts-10.3.3/code/highcharts.js"></script>
<script src="<%= ctxPath%>/resources/Highcharts-10.3.3/code/modules/exporting.js"></script>
<script src="<%= ctxPath%>/resources/Highcharts-10.3.3/code/modules/export-data.js"></script>
<script src="<%= ctxPath%>/resources/Highcharts-10.3.3/code/modules/accessibility.js"></script>
<script src='<%=ctxPath %>/resources/fullcalendar_5.10.1/main.min.js'></script>
<script src='<%=ctxPath %>/resources/fullcalendar_5.10.1/ko.js'></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.24.0/moment.min.js"></script>
    
<script>

$(document).ready(function(){
   
   showWeather();
      // AJAX 요청
    $.ajax({
        url: "<%= ctxPath%>/scheduleselect.gw",
        type: "get",
        dataType: "json",
        success: function (json) {
           // console.log(JSON.stringify(json));
                      
           console.log(json.length);
           $("span#scheduleCnt").html(json.length);
           
           let s_html = "";
           
            if(json.length > 0) {
               $.each(json, function(index, item){
                  
                  s_html += "<tr class='scheduleinfo'>";
                  s_html +=    "<td style='font-size:7pt;'>"+ item.enddate +"</td>";
                  s_html +=    "<td>"+ item.subject +"</td>"; 
                  s_html +=  "</tr>"; 
               });
            }
            
            else {
               s_html +=  "<tr>";
               s_html +=  "<td colspan='3'>일정 없음</td>";
               s_html +=  "</tr>";
            }
            
              
            $("tbody#scheduleinfo").html(s_html);
                   
        },
        error: function (request, status, error) {
            alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
        }
    }); // end of ajax
    
    
    // 출근, 퇴근 신청 [시작]
    var now = new Date();   
   var year = now.getFullYear();  // 현재 해당 년도
   var month = now.getMonth()+1;  // 현재 해당 월
   var day = now.getDate();       // 현재 해당 일자
   
   var hour = now.getHours();       // 현재 해당 시각
   var minute = now.getMinutes(); // 현재 해당 분
   var second = now.getSeconds(); // 현재 해당 초
   
   // 한 자리 수일 때 앞에 0 붙이기 (함수 활용)
   hour = padZero(hour);
   minute = padZero(minute);
   second = padZero(second);
   month = padZero(month);
   day = padZero(day);

   const FullDate = year+"-"+month+"-"+day;     // 2023-12-27
   const FullTime = hour+":"+minute+":"+second; // 16:31:25

   // 출, 퇴근, 누적 시간 display 숨겨놓기
   $('#start_time_dis').hide();
   $('#end_time_dis').hide();
   $('#append_time_dis').hide();
   
	// 출, 퇴근, 누적 시간 뿌리는 함수 호출
	getMyWorkTime(FullDate);
   
    // 출근 버튼 클릭시  근무 테이블에 insert
    $("button#goToWork").click(function(){

       $("input[name='work_date']").val(FullDate);
       $("input[name='work_start_time']").val(FullTime);
       
       const frm = document.goToWorkInsert;
       frm.method = "post";
       frm.action = "<%= ctxPath %>/goToWorkInsertIndex.gw";
       frm.submit(); 
       
    }); // end of $("button#goToWork").click(function()--------------------
    
    // 퇴근 버튼 클릭시  근무 테이블 update
    $("button#leaveWork").click(function(){
       
       $("input[name='work_date_ex']").val(FullDate); // 오늘 날짜
       $("input:hidden[name='work_end_time']").val(FullTime); // 현재 시간
       
      /////////////////////////////////////////////////////
      // 출근시간 날짜형식으로 변환
       var TodayStartTime = $('#start_time').text(); // 로그인 한 사원의 오늘 출근 시간
       
       var TodayHour = TodayStartTime.substr(0, 2); // 출근 시 구하기
       
       var TodayMinute = TodayStartTime.substr(3, 2); // 출근 분 구하기
       
       var TodaySecond = TodayStartTime.substr(6); // 출근 초 구하기
       
       todayStartTimeVal = new Date();
       
       todayStartTimeVal.setHours(TodayHour);
       todayStartTimeVal.setMinutes(TodayMinute);
       todayStartTimeVal.setSeconds(TodaySecond);
       
       /////////////////////////////////////////////////////
       // 근무 시간 가져오기
       var workTimeNow = now - todayStartTimeVal;
       
       var workTimeH = Math.floor(workTimeNow / (1000 * 60 * 60)); // 근무 시간
       
       var workTimeM = Math.floor(workTimeNow / (1000 * 60) % 60); // 근무 분
       
       var workTimeC = Math.floor((workTimeNow / 1000) % 60);       // 근무 초
       
       var workTimeVal = padZero(workTimeH)+":"+padZero(workTimeM)+":"+padZero(workTimeC);
       
       ///////////////////////////////////////////////////////////////
       // 연장 근무 시간 구하기
       // 9시간의 밀리초는 32400000 - 23611081 = 12345125
       
       if(workTimeNow > 32400000) { // 연장근무인 경우
          var calculateTime = workTimeNow - 32400000;

          var calH = Math.floor(calculateTime / (1000 * 60 * 60)); // 연장 시간
          
          var calM = Math.floor(calculateTime / (1000 * 60) % 60); // 연장 분
          
          var calC = Math.floor((calculateTime / 1000) % 60);     // 연장 초
          
          var overTimeVal = padZero(calH)+":"+padZero(calM)+":"+padZero(calC);
                      
          $("input[name='extended_end_time']").val(overTimeVal);
          
          const frm = document.goToWorkUpdateWithExtended; 
         frm.method = "post";
          frm.action = "<%= ctxPath %>/goToWorkUpdateWithExtendedIndex.gw";
         frm.submit();
       }
       else {
          const frm = document.goToWorkUpdateWithExtended; 
         frm.method = "post";
          frm.action = "<%= ctxPath %>/goToWorkUpdateIndex.gw";
         frm.submit();
       }
       
       document.getElementById('end_time_dis').style.display = 'show';
       document.getElementById('append_time_dis').style.display = 'show';
    }); // end of $("button#goToWork").click(function()--------------------
    // 출근, 퇴근 신청 [끝]

   // ==== 풀캘린더와 관련된 소스코드 시작(화면이 로드되면 캘린더 전체 화면 보이게 해줌) ==== //
   var calendarEl = document.getElementById('calendar');
        
    var calendar = new FullCalendar.Calendar(calendarEl, {
    // === 구글캘린더를 이용하여 대한민국 공휴일 표시하기 시작 === //
     //   googleCalendarApiKey : "자신의 Google API KEY 입력",
        /*
            >> 자신의 Google API KEY 을 만드는 방법 <<
            1. 먼저 크롬 웹브라우저를 띄우고, 자신의 구글 계정으로 로그인 한다.
            2. https://console.developers.google.com 에 접속한다. 
            3. "API  API 및 서비스" 에서 "사용자 인증 정보" 를 클릭한다.
            4. ! 이 페이지를 보려면 프로젝트를 선택하세요 에서 "프로젝트 만들기" 를 클릭한다.
            5. 프로젝트 이름은 자동으로 나오는 값을 그대로 두고 그냥 "만들기" 버튼을 클릭한다. 
            6. 상단에 보여지는 사용자 인증 정보 옆의  "+ 사용자 인증 정보 만들기" 를 클릭하여 보여지는 API 키를 클릭한다.
                            그러면 API 키 생성되어진다.
            7. 생성된 API 키가  자신의 Google API KEY 이다.
            8. 애플리케이션에 대한 정보를 포함하여 OAuth 동의 화면을 구성해야 합니다. 에서 "동의 화면 구성" 버튼을 클릭한다.
            9. OAuth 동의 화면 --> User Type --> 외부를 선택하고 "만들기" 버튼을 클릭한다.
           10. 앱 정보 --> 앱 이름에는 "웹개발테스트"
                     --> 사용자 지원 이메일에는 자신의 구글계정 이메일 입력
                             하단부에 보이는 개발자 연락처 정보 --> 이메일 주소에는 자신의 구글계정 이메일 입력 
           11. "저장 후 계속" 버튼을 클릭한다. 
           12. 범위 --> "저장 후 계속" 버튼을 클릭한다.
           13. 테스트 사용자 --> "저장 후 계속" 버튼을 클릭한다.
           14. "API  API 및 서비스" 에서 "라이브러리" 를 클릭한다.
               Google Workspace --> Google Calendar API 를 클릭한다.
               "사용" 버튼을 클릭한다. 
        */
       googleCalendarApiKey : "AIzaSyDddbLQG8Sb4etqNLFlZeCHtdGTngORdec",
        eventSources :[ 
            {
            //  googleCalendarId : '대한민국의 휴일 캘린더 통합 캘린더 ID'
                googleCalendarId : 'ko.south_korea#holiday@group.v.calendar.google.com'
              , color: '#f5f5f5'   // 옵션임! 옵션참고 사이트 https://fullcalendar.io/docs/event-source-object
              , textColor: 'red' // 옵션임! 옵션참고 사이트 https://fullcalendar.io/docs/event-source-object 
            } 
        ],
     // === 구글캘린더를 이용하여 대한민국 공휴일 표시하기 끝 === //

        initialView: 'dayGridMonth',
        locale: 'ko',
        selectable: true,
       editable: false,
       headerToolbar: {
            left: 'prev,next today',
             center: 'title',
             right: 'dayGridMonth dayGridWeek dayGridDay'
       },
       dayMaxEventRows: true, // for all non-TimeGrid views
       views: {
         timeGrid: {
           dayMaxEventRows: 3 // adjust to 6 only for timeGridWeek/timeGridDay
         }
       },
      
       // ===================== DB 와 연동하는 법 시작 ===================== //
       events:function(info, successCallback, failureCallback) {
   
           $.ajax({
                 url: '<%= ctxPath%>/schedule/selectSchedule.gw',
                 data:{"fk_employee_id":"${sessionScope.loginuser.employee_id}",
                      "fk_department_id": "${sessionScope.loginuser.fk_department_id}",
                      "fk_email": "${sessionScope.loginuser.email}"},
                 dataType: "json",
                 success:function(json) {
                    //console.log(JSON.stringify(json));
                        
                    var events = [];
                     if(json.length > 0){
                         
                             $.each(json, function(index, item) {
                                    var startdate = moment(item.startdate).format('YYYY-MM-DD HH:mm:ss');
                                    var enddate = moment(item.enddate).format('YYYY-MM-DD HH:mm:ss');
                                    var subject = item.subject;
                              
                                   // 회사 캘린더로 등록된 일정을 풀캘린더 달력에 보여주기 
                                   // 일정등록시 회사 캘린더에서 선택한 소분류에 등록된 일정을 풀캘린더 달력 날짜에 나타내어지게 한다.
                                         
                                           
                                  events.push({
                                               id: item.scheduleno,
                                                title: item.subject,
                                                start: startdate,
                                                end: enddate,
                                               url: "<%= ctxPath%>/schedule/detailSchedule.gw?scheduleno="+item.scheduleno,
                                                color: item.color,
                                                cid: item.fk_smcatgono  // 회사캘린더 내의 서브캘린더 체크박스의 value값과 일치하도록 만들어야 한다. 그래야만 서브캘린더의 체크박스와 cid 값이 연결되어 체크시 풀캘린더에서 일정이 보여지고 체크해제시 풀캘린더에서 일정이 숨겨져 안보이게 된다. 
                                   }); // end of events.push({})---------
                                                                                 
                                  
                      			 if(item.joinuser == null){
                              	   item.joinuser = "";
                                 }
                                  // 공유받은 캘린더(다른 사용자가 내캘린더로 만든 것을 공유받은 경우임)
                                   if (item.fk_lgcatgono==1 && item.fk_employee_id != "${sessionScope.loginuser.employee_id}" && (item.joinuser).indexOf("${sessionScope.loginuser.userid}") != -1 ){  
                                        
                                        events.push({
                                                    id: "0",  // "0" 인 이유는  배열 events 에 push 할때 id는 고유해야 하는데 위의 회사캘린더 및 내캘린더에서 push 할때 id값으로 item.scheduleno 을 사용하였다. item.scheduleno 값은 DB에서 1 부터 시작하는 시퀀스로 사용된 값이므로 0 값은 위의 회사캘린더나 내캘린더에서 사용되지 않으므로 여기서 고유한 값을 사용하기 위해 0 값을 준 것이다. 
                                                     title: item.subject,
                                                     start: startdate,
                                                     end: enddate,
                                                    url: "<%= ctxPath%>/schedule/detailSchedule.gw?scheduleno="+item.scheduleno,
                                                     color: item.color,
                                                     cid: "0"  // "0" 인 이유는  공유받은캘린더 에서의 체크박스의 value 를 "0" 으로 주었기 때문이다.
                                        }); // end of events.push({})--------- 
                                        
                                      }// end of if------------------------- 
                                
                             }); // end of $.each(json, function(index, item) {})-----------------------
                         }                             
                         
                      // console.log(events);                       
                         successCallback(events);                               
                  },
              error: function(request, status, error){
                     alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
               }   
                                            
          }); // end of $.ajax()--------------------------------
        
        }, // end of events:function(info, successCallback, failureCallback) {}---------
        // ===================== DB 와 연동하는 법 끝 ===================== //
                   
          // === 회사캘린더, 내캘린더, 공유받은캘린더의 체크박스에 체크유무에 따라 일정을 보여주거나 일정을 숨기게 하는 것이다. === 
        eventDidMount: function (arg) {
                          
              arg.el.style.display = "block"; // 풀캘린더에서 일정을 보여준다.
              
         }
  });
    
  calendar.render();  // 풀캘린더 보여주기
    
}); // end of $(document).ready(function(){})-----------------

// ------ 기상청 날씨정보 공공API XML 데이터 호출하기 ------ //
function showWeather(){
   
   $.ajax({
      url:"<%= ctxPath%>/opendata/weatherXML.gw",
      type:"get",
      dataType:"xml",
      success:function(xml){
         const rootElement = $(xml).find(":root"); 
      //   console.log("확인용 : " + $(rootElement).prop("tagName") );
         // 확인용 : current
         
         const weather = rootElement.find("weather"); 
         const updateTime = $(weather).attr("year")+"년 "+$(weather).attr("month")+"월 "+$(weather).attr("day")+"일 "+$(weather).attr("hour")+"시"; 
      //   console.log(updateTime);
         // 2023년 12월 19일 10시
         
         const localArr = rootElement.find("local");
      //   console.log("지역개수 : " + localArr.length);
         // 지역개수 : 97
         
         let html = "날씨정보 발표시각 : <span style='font-weight:bold;'>"+updateTime+"</span>&nbsp;";
               html += "<span style='color:blue; cursor:pointer; font-size:9pt;' onclick='javascript:showWeather();'>업데이트</span><br/><br/>";
               html += "<table class='table table-hover' align='center'>";
              html += "<tr>";
              html += "<th>지역</th>";
              html += "<th>날씨</th>";
              html += "<th>기온</th>";
              html += "</tr>";
          
           // ====== XML 을 JSON 으로 변경하기  시작 ====== //
            var jsonObjArr = [];
          // ====== XML 을 JSON 으로 변경하기  끝 ====== //    
              
          for(let i=0; i<localArr.length; i++){
             
             let local = $(localArr).eq(i);
            
             
              let icon = $(local).attr("icon");  
              if(icon == "") {
                 icon = "없음";
              }
            
              html += "<tr>";
            html += "<td>"+$(local).text()+"</td><td><img src='<%= ctxPath%>/resources/images/weather/"+icon+".png' />"+$(local).attr("desc")+"</td><td>"+$(local).attr("ta")+"</td>";
            html += "</tr>";
              
            
            // ====== XML 을 JSON 으로 변경하기  시작 ====== //
               var jsonObj = {"locationName":$(local).text(), "ta":$(local).attr("ta")};
               
               jsonObjArr.push(jsonObj);
            // ====== XML 을 JSON 으로 변경하기  끝 ====== //
            
          }// end of for------------------------ 
          
          html += "</table>";
          
          $("div#displayWeather").html(html);
          
          
       // ====== XML 을 JSON 으로 변경된 데이터를 가지고 차트그리기 시작  ====== //
         var str_jsonObjArr = JSON.stringify(jsonObjArr); 
                           // JSON객체인 jsonObjArr를 String(문자열) 타입으로 변경해주는 것 
                           
         $.ajax({
            url:"<%= ctxPath%>/opendata/weatherXMLtoJSON.gw",
            type:"POST",
            data:{"str_jsonObjArr":str_jsonObjArr},
            dataType:"JSON",
            success:function(json){
               
            //   alert(json.length);
               
               // ======== chart 그리기 ========= // 
               var dataArr = [];
               $.each(json, function(index, item){
                  dataArr.push([item.locationName, 
                               Number(item.ta)]);
               });// end of $.each(json, function(index, item){})------------
               
               
               Highcharts.chart('weather_chart_container', {
                   chart: {
                       type: 'column'
                   },
                   title: {
                       text: '오늘의 전국 기온(℃)'   // 'ㄹ' 을 누르면 ℃ 가 나옴.
                   },
                   subtitle: {
                   //    text: 'Source: <a href="http://en.wikipedia.org/wiki/List_of_cities_proper_by_population">Wikipedia</a>'
                   },
                   xAxis: {
                       type: 'category',
                       labels: {
                           rotation: -45,
                           style: {
                               fontSize: '10px',
                               fontFamily: 'Verdana, sans-serif'
                           }
                       }
                   },
                   yAxis: {
                       min: -10,
                       title: {
                           text: '온도 (℃)'
                       }
                   },
                   legend: {
                       enabled: false
                   },
                   tooltip: {
                       pointFormat: '현재기온: <b>{point.y:.1f} ℃</b>'
                   },
                   series: [{
                       name: '지역',
                       data: dataArr, // **** 위에서 만든것을 대입시킨다. **** 
                       dataLabels: {
                           enabled: true,
                           rotation: -90,
                           color: '#FFFFFF',
                           align: 'right',
                           format: '{point.y:.1f}', // one decimal
                           y: 10, // 10 pixels down from the top
                           style: {
                               fontSize: '10px',
                               fontFamily: 'Verdana, sans-serif'
                           }
                       }
                   }]
               });
               // ====== XML 을 JSON 으로 변경된 데이터를 가지고 차트그리기 끝  ====== //
            },
            error: function(request, status, error){
               alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
            }
         });                  
         ///////////////////////////////////////////////////
         
      },// end of success: function(xml){ }------------------
      
      error: function(request, status, error){
         alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
      }
   });
   
}// end of function showWeather()--------------------


function selectOneEmail(send_email_seq){
   
   alert(send_email_seq);  
   // 패스워드 체크
   $.ajax({
      url:"<%= ctxPath%>/getEmailPwd.gw",
      type:"post",
      data:{"send_email_seq":send_email_seq },
        success:function(json){
           if(json != "" && json != null){
              
              alert("비밀 메일입니다. 암호를 입력해주세요.");
              location.href="<%=ctxPath%>/digitalmailview.gw?send_email_seq="+send_email_seq;
              <%--  
              if(value == json.pwd){
                 if(mailRecipientNo!=null){
                    location.href="<%=ctxPath%>/mail/viewMail.on?mailNo="+mailno+"&mailRecipientNo"+mailRecipientNo;
                 }
                 else{
                    location.href="<%=ctxPath%>/mail/viewMail.on?mailNo="+mailno;
                 }
                }
                else{
                   swal("잘못된 암호입니다. 다시 확인해주세요.");
                }
                --%>    
           }
           else{
              alert("비밀 메일이 아닙니다.");
              if(mailRecipientNo!=null){
                 location.href="<%=ctxPath%>/digitalmailview.gw?send_email_seq="+send_email_seq+"&mailRecipientNo"+mailRecipientNo;
              }
              else{
                 location.href="<%=ctxPath%>/digitalmailview.gw?send_email_seq="+send_email_seq;
              }
          }

  
        },
        error: function(request, status, error){
            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
        }
    });
   
}
// 주어진 값이 10보다 작을 경우 그 앞에 0을 붙여서 두 자리 수로 만드는 함수
function padZero(value) {
    return value < 10 ? "0" + value : value;
}

//출,퇴근 시간 뿌리는 함수
function getMyWorkTime(myWorkDate){
	
	$.ajax({
		url:"<%= ctxPath%>/getMyWorkTime.gw",
		type:"post",
		data:{"myWorkDate":myWorkDate},
		dataType:"JSON",
		success:function(json){
			$("span#start_time").text(json.work_start_time);
			$("span#end_time").text(json.work_end_time);	
			
			const startTimeVal = $("span#start_time").text();
			const endTimeVal = $("span#end_time").text();
			const appendTimeVal = $("span#end_time").text();
			
			if(startTimeVal != "") {
				$('#start_time_dis').show();
			}
			if(endTimeVal != "") {
				$('#end_time_dis').show();
			}
			if(startTimeVal != " " && endTimeVal != " ") {
				$("span#append_time").text(json.timeDiff);
			}
			if(appendTimeVal != "") {
				$('#append_time_dis').show();
			}
        },
        error: function(request, status, error){
            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
        }
	});
}
</script>
   
    
<body>
   <div class="parent">
      <div class="widget-container div4">
               <div class="widget-header mb-2">프로필  <a href="<%=ctxPath%>/myinfo.gw"><i class="fa-solid fa-share-from-square"></i></a></div>
                  <div >
            
               <div id="photo" class="mx-2">
                  <img src="<%= ctxPath%>/resources/images/empImg/${requestScope.loginuser.photo}" style="width: 100px; height: 100px; border-radius: 50%;" />
               </div>
                  
               <table id="table1" class="myinfo_tbl">
                  <tr>
                     <th width="50%;">성명</th>
                     <td>${requestScope.loginuser.name}</td>
                  </tr>
                  <tr>   
                     <th>이메일</th>
                     <td>${requestScope.loginuser.email}</td>
                  </tr>
                  
               </table>
               
               <ul>
               <li class="ml-auto mt-2 text-center" style="margin-right: 13%;">
               <button id="goToWork" class="btn btn-sm btn-success" style="width: 50px;">출근</button>
                   <button id="leaveWork" class="btn btn-sm btn-danger ml-3" style="width: 50px;">퇴근</button>
                   
                   <form name="goToWorkInsert">
                      <input type="hidden" name="work_date"/>
                      <input type="hidden" name="work_start_time"/>
                      <input type="hidden" name="fk_employee_id" value="${sessionScope.loginuser.employee_id}"/>
                   </form>
                   
                   <%-- 연장근무인 경우 보낼 form --%>
                   <form name="goToWorkUpdateWithExtended">
                      <input type="hidden" name="work_date_ex"/>
                      <input type="hidden" name="work_end_time"/>
                      <input type="hidden" name="extended_end_time"/>
                      <input type="hidden" name="fk_employee_id" value="${sessionScope.loginuser.employee_id}"/>
                   </form>
                   <input type='hidden' id='todayST' value='${requestScope.myTodayStartTime}'/>
            </li>
            </ul>
            <table style='width: 100%;'>
				<tr id='start_time_dis'>
					<th style='width: 45%;'>출근시간</th>
					<td><span id='start_time'></span></td>
				</tr>
				<tr id='end_time_dis'>	
					<th>퇴근시간</th>
					<td><span id='end_time'></span></td>
				</tr>
				<tr id='append_time_dis'>	
					<th>근무누적시간</th>
					<td><span id='append_time'></span></td>
				</tr>
			</table>
            
         </div>
        </div>
       <!-- todo -->
       <div class="widget-container div5">
           <div class="widget-header mb-2">결제 / 승인 <a href="<%=ctxPath%>/approval/home.gw"><i class="fa-solid fa-share-from-square"></i></a></div>
              <div class="listContainer " style="font-size: 9pt;">
               <c:if test="${sessionScope.loginuser.gradelevel != 1}">
               <div class='listContainer'>
               <h5 class='mb-3'>결재 대기 문서</h5>
               <h6 class='mb-3'>결재해야 할 문서가 <a style='color:red;' href="<%=ctxPath%>/approval/home.gw">${requestedDraftCnt}</a>건 있습니다.</h6>
               </div>
               </c:if>
               <div class='listContainer'>
               
                  <h5 class='mb-3'>기안 진행 문서</h5>
                  <h6 class='mb-3'>진행 중인 문서가 <span style='color:red;'>${fn:length(processingDraftList)}</span>건 있습니다.</h6>
                  <table class="table">
                     <thead>
                        <tr class='tr'>
                           <th>종류</th>
                           <th>제목</th>
                        </tr>
                     </thead>
                     <tbody>
                        <c:choose>
                                 <c:when test="${not empty processingDraftList}">
                                <c:forEach items="${processingDraftList}" var="processing" end="4">
                                    <tr>
                                 <td >${processing.draft_type}</td>
                                        <td>
                                        <a href='<%=ctxPath%>/approval/draftDetail.gw?draft_no=${processing.draft_no}&fk_draft_type_no=${processing.fk_draft_type_no}'>
                                        <c:if test="${processing.urgent_status == '1'}"><span style='font-size:x-small;' class="badge badge-pill badge-danger">긴급</span></c:if>
                                        ${processing.draft_subject}</a></td>
                                    </tr>
                                </c:forEach>
                               </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan='6' class='text-center'>진행 중인 문서가 없습니다.</td>
                                </tr>
                            </c:otherwise>            
                        </c:choose>
                     </tbody>
                  </table>
               </div>
               
               <div class='listContainer'>
		      <h5 class='mb-3'>결재 완료 문서</h5>
		
		      <table class="table" style="font-size: 9pt;">
		         <thead>
		            <tr class='tr'>
		               <th>결재상태</th>
		               <th>제목</th>
		               
		            </tr>
		         </thead>
		         <tbody>
		            <c:choose>
		                     <c:when test="${not empty processedDraftList}">
		                    <c:forEach items="${processedDraftList}" var="processed" >
		                        <tr>
		                     <td>
                                <c:if test="${processed.draft_status == '1'}">
                                   <span class="badge badge-secondary">완료</span>
                                </c:if>
                                <c:if test="${processed.draft_status == '2'}">
                                   <span class="badge badge-danger">반려</span>
                                </c:if>
                             </td>
		                     <td>
	                            <a href='<%=ctxPath%>/approval/draftDetail.gw?draft_no=${processed.draft_no}&fk_draft_type_no=${processed.fk_draft_type_no}'>
		                            <c:if test="${processed.urgent_status == '1'}"><span style='font-size:x-small;' class="badge badge-pill badge-danger">긴급</span></c:if>
		                            ${processed.draft_subject}
		                        </a>
	                          </td>
		                     
		                            
		                        </tr>
		                    </c:forEach>
		                   </c:when>
		                <c:otherwise>
		                    <tr>
		                        <td colspan='6' class='text-center'>진행 중인 문서가 없습니다.</td>
		                    </tr>
		                </c:otherwise>            
		            </c:choose>
		         </tbody>
		      </table>
		      
		   </div>
      
            </div>
            
       </div>
       
           <!-- 일정관리 -->
           <div class="widget-container div1 ">
               <div class="widget-header mb-2">일정관리  <a href="<%=ctxPath%>/schedule/scheduleManagement.gw"><i class="fa-solid fa-share-from-square"></i></a></div>
               
               <div style="margin-left: 40px; width: 88%; margin-top: 100px;">
                <%-- 풀캘린더가 보여지는 엘리먼트  --%>
            <div id="calendar" style="margin: 100px 0 50px 0;" ></div>
            </div>
                     
               
           </div>
            <!--  웹메일 -->     
          <div class="widget-container div6">
             <div class="widget-header mb-2">웹메일  <a href="<%=ctxPath%>/digitalmail.gw"><i class="fa-solid fa-share-from-square"></i></a></div>
             <!-- 이메일 리스트 -->
             <div class="emailList_list">
                 <table class="table">
                     <thead>
                         <tr class='tr'>
                             <th class='col col-3'>보낸사람</th>
                             <th class='col col-3'>제목</th>
                             <th class='col col-3'>보낸시간</th>
                         </tr>
                     </thead>
                     <tbody>
                        <tr>
                            
                         <c:if test="${empty requestScope.emailVOList}">
                         <td colspan="3">
                             <div class="emailRow" style="width: 100%; display: flex;">
                                 <span style="display:inline-block; margin: 0 auto;">받은 메일이 없습니다.</span>
                             </div>
                             </td>
                         </c:if>
                            
                         </tr>
                         <c:if test="${not empty requestScope.emailVOList}">
                             <c:forEach var="emailVO" items="${requestScope.emailVOList}" varStatus="status">
                                 <tr>
                                     <td>
                                         <span class="emailRow_title ml-2">${emailVO.job_name}&nbsp;${emailVO.name}</span>
                                         <!-- 수신자 정보 -->
                                     </td>
                                     <td>
                                         <!-- 제목 -->
                                         <div class="emailRow_message" onclick="selectOneEmail('${emailVO.send_email_seq}')">
                                             <span>${emailVO.email_subject}</span>
                                         </div>
                                         <!-- 제목 -->
                                     </td>
                                     <td>
                                         <!-- 전송시간 -->
                                         <span class="mr-3" onclick="selectOneEmail('${emailVO.send_email_seq}')">${emailVO.send_time}</span>
                                         <!-- 전송시간 -->
                                     </td>
                                 </tr>
                             </c:forEach>
                         </c:if>
                     </tbody>
                 </table>
             </div>
         </div>

       
        <!-- 나머지 위젯을 옆으로 배치하기 위한 div 추가 -->
      <div class="div8 widget-container">
         <%-- 차트그리기 --%>
         <figure class="highcharts-figure">
             <div id="weather_chart_container"></div>
         </figure>
         </div> 
 </div>
      
    
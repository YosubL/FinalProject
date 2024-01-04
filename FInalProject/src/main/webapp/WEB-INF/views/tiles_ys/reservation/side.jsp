<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<% String ctxPath = request.getContextPath(); %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style type="text/css">
	
	.topMenu:hover {
		cursor: pointer;
	}

	#insertBtn:hover{
		border: 1px solid #086BDE;
		color: white;
		background-color: rgb(3,199,90);
		font-weight:bold;
	}

	.reservationMenu {
		color: rgb(3,199,90) !important;
		font-weight: bold;
	}
	
	.side_input_style {
	  padding: 5px; /* Some padding */ 
	  border: 1px solid #ccc; /* Gray border */
	  border-radius: 4px; /* Rounded borders */
	  box-sizing: border-box; /* Make sure that padding and width stays in place */
	  margin-top: 5px; /* Add a top margin */
	  resize: vertical; /* Allow the user to vertically resize the textarea (not horizontally) */
	  vertical-align: middle;
	}
	
	.ui-autocomplete {
		max-height: 200px;
		overflow-y: auto;
		z-index:2147483647 !important;
	}

</style>

<script type="text/javascript">

	var now = new Date();
	var menu = "";
	var smcatgono = "";
	$(document).ready(function(){
		
		
		// 메뉴 선택시 다른 메뉴 닫기      
	    $(".topMenu").click(function(e) {
	        
	    	const target = $(e.target.children[0]);
	        
	        if ($(target).is(":visible")) {
	           $(".subMenus").slideUp("fast");
	           
	        }
	        else {
	           $(".subMenus").slideUp("fast");
	           $(target).slideToggle("fast");
	           
	        }
	        
	    });
		
		// 사이드 메뉴 선택한 부분에 색 주기
	    var pathName = window.location.pathname;
	    var ctxPath = '<%=ctxPath%>';
	    var slashIndex = pathName.lastIndexOf("/");
	    var menuName = pathName.substring(slashIndex+1);
		var index = menuName.indexOf(".");
		menuName = menuName.substring(0,index) || 'index';
		
		$('a#'+menuName).addClass('reservationMenu'); // 현재 메뉴에 색 입히기
		
		//console.log(menuName);
		if(menuName == 'meetingRoom'){
			menu = '1';
		}
		else if(menuName == 'device'){
			menu = '2';
		}
		else if(menuName == 'vehicle'){
			menu = '3';
		}
		else {
			menu = '1';
		}
		//console.log(menu);
		
		// 자원 예약 모달창에서 이전 날짜 예약 막기 시작
    	$("input#startDate").change(function(){
    		startDate = $("input#startDate").val();
	    	
	    	// 이전 날짜 선택 막기
	    	blockSelectDate(startDate);
	    	blockSelectStartTime(startDate);
	    }); // end of  $("input#reservStartDate").change(function()
    	
	    $("input#endDate").change(function(){
    		endDate = $("input#endDate").val();
	    	
	    	// 이전 날짜 선택 막기
	    	blockSelectDate(endDate);
	    	blockSelectEndTime(endDate);
	    }); // end of  $("input#reservStartDate").change(function()
		// 자원 예약 모달창에서 이전 날짜 예약 막기 끝
		
		
		
		// 실사용자 자동완성
		addRealUserAutoComplete();
		
		// x아이콘 클릭시 참석자 제거하기
		$(document).on('click','div.displayUserList > span.plusUser > i',function(){
			var joinUserName = $(this).parent().text(); // 이순신(leess/leesunsin@naver.com)
			
			var confirmation = confirm("공유자에서 " + joinUserName + " 님을 삭제하시겠습니까?");

			if (confirmation) {
			    // 삭제
			    $(this).parent().remove();
			} else {
			    // 삭제 취소
			    alert("공유자 삭제를 취소하였습니다.");
			}		

		}); // end of $(document).on('click','div.displayUserList > span.plusUser > i',function()
	    
	    
		// 모달 창에서 입력된 값 초기화 시키기 //
		$("button.modal_close").on("click", function(){

			  var modal_frmArr = document.querySelectorAll("form[name=addReservation_frm]");
			  for(var i=0; i<modal_frmArr.length; i++) {
				  modal_frmArr[i].reset();
			  }
			  $("div.displayUserList span.plusUser").remove();
			  
		}); // end of $("button.modal_close").on("click", function()
		
				
		$("select#reservType").change(function() {
		    // select 요소가 변경될 때 실행되는 코드
			$("select.small_category").hide();
		    // 선택된 값 가져오기
		    
		    var fk_lgcatgono = $(this).val();
		    if(fk_lgcatgono =='1'){
		    	 var smcatgono = '1';
		    }
		    else if(fk_lgcatgono =='2'){
		    	var smcatgono = '5';
		    }
		    else{
		    	var smcatgono = '6';
		    }
		   

		    // 다른 처리 코드...

		    // AJAX 요청
		    $.ajax({
		        url: "<%= ctxPath %>/reservation/reservationTable.gw",
		        type: "get",
		        data: { "fk_lgcatgono": fk_lgcatgono },
		        dataType: "json",
		        success: function (json) {
		            var html = "";
		            if (json.length > 0) {
		                $.each(json, function (index, item) {
		                    html += "<option value='" + item.smcatgono + "'>" + item.smcatgoname + "</option>";
		                });
		                
		                $("select.small_category").html(html);
		                $("select.small_category").show();
		                $("select.small_category").val(smcatgono).prop("selected", true);
		            }
		        },
		        error: function (request, status, error) {
		            alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
		        }
		    }); // end of ajax
		});
				
	}); // end of ready
	
	
	
	// 실사용자 자동완성
	function addRealUserAutoComplete(){
		// 공유자 추가하기
		$("input#realuserInput").bind("keyup",function(){
				var joinUserName = $(this).val();
			//	console.log("확인용 joinUserName : " + joinUserName);
				$.ajax({
					url:"<%= ctxPath%>/schedule/insertSchedule/searchJoinUserList.gw",
					data:{"joinUserName":joinUserName},
					dataType:"json",
					success : function(json){
						var joinUserArr = [];
				    
					//  input태그 공유자입력란에 "이" 를 입력해본 결과를 json.length 값이 얼마 나오는지 알아본다. 
					//	console.log(json.length);
					
						if(json.length > 0){
							
							$.each(json, function(index,item){
								var name = item.name;
								if(name.includes(joinUserName)){ // name 이라는 문자열에 joinUserName 라는 문자열이 포함된 경우라면 true , 
									                             // name 이라는 문자열에 joinUserName 라는 문자열이 포함되지 않은 경우라면 false 
								   joinUserArr.push(name+"("+item.email+")");
								}
							});
							
							$("#realuserInput").autocomplete({  // 참조 https://jqueryui.com/autocomplete/#default
								source:joinUserArr,
								select: function(event, ui) {       // 자동완성 되어 나온 공유자이름을 마우스로 클릭할 경우 
									addRealUser(ui.item.value);    // 아래에서 만들어 두었던 add_joinUser(value) 함수 호출하기 
									                                // ui.item.value 이  선택한이름 이다.
									return false;
						        },
						        focus: function(event, ui) {
						            return false;
						        }
							}); 
							
						}// end of if------------------------------------
					}// end of success-----------------------------------
				});
		});
		
		
	} // end of function addRealUserAutoComplete()
	

	
	// 예약 모달창 클릭 메소드
	function insertReservation(selectDate, selectTime, fk_lgcatgono, smcatgono){
		
		
		
		addRealUserAutoComplete();
		
		// 지난 시간 td 클릭 금지 시작
		// 현재 시간 날짜 구해오기
		var now_year = now.getFullYear();
		var now_month = now.getMonth();
		var now_date = now.getDate();
		var now_hours = now.getHours();
		
		if(now_month < 10) {
			now_month = "0"+(now_month+1);
		} else {
			now_month = now_month + 1;
		}
		
		if(now_date < 10) {
			now_date = "0"+now_date;
		} 
		
		var now_day =  now_year.toString() + "-" + now_month.toString() + "-" + now_date.toString();
		
		// 오늘의 경우에만 시간 제약을 둔다
		if(selectDate == now_day) {
			
			if(now_hours < 10) {
				now_hours = "0"+now_hours;
			} 
			
			if(Number(now_hours +1) > Number(selectTime)) {
				alert("지난 시간은 예약할 수 없습니다.");
				return false;
			}
		}
		// 지난 시간 td 클릭 금지 끝
		
		$('#modal_addReservation').modal('show'); // 모달창 보여주기	
		
		// 캘린더 소분류 카테고리 숨기기
		$("select.small_category").hide();
		
		// === *** 달력(type="date") 관련 시작 *** === //
		
		// 오늘 날짜의 경우에는 현재 시간 이전에는 시간 선택을 하지 못하게 해준다
		blockSelectStartTime(selectDate, selectTime);
		blockSelectEndTime(selectDate, selectTime);
		
		// === *** 달력(type="date") 관련 끝 *** === //
		
		// 선택한 날짜가 있을 경우에 내가 선택한 날짜 넣어주기
		if(selectDate != undefined && selectDate != null) {
			$("input#startDate").val(selectDate);
			$("input#endDate").val(selectDate);
		}
		
		
		
		
		
		// 10 이하의 시간들 0 추가해주기
		if( (Number(selectTime)) < 10 ) {
			var selectEndTime = String('0' + (Number(selectTime) + 1));
		} else {
			var selectEndTime = String(Number(selectTime) + 1)
		}
		
		// 9시 선택했을 경우에 10 을 바꿔주기
		if (selectEndTime == '010') {
			selectEndTime = '10';
		} 
		
		// 23시를 선택했을 경우에 다음날 00시로 지정해주기
		if(selectTime == '23') {
			var dateType_selectDate = new Date(selectDate);
			var dateType_selectNextDate = new Date(Date.parse(dateType_selectDate) + 1 * 1000 * 60 * 60 * 24);
			var stType_selectNextDate =  dateType_selectNextDate.toISOString();
			var selectNextDate = stType_selectNextDate.substring(0,10);
			$("input#endDate").val(selectNextDate);
			selectEndTime = '00';
		}
		
		// 내가 선택한 시간 select 로 잡아주기
		if(selectTime != undefined) {
			$("select#startHour").val(selectTime).prop("selected",true);
			$("select#endHour").val(selectEndTime).prop("selected",true);
		}
		
		// 사이드 바의 일정등록을 클릭한 경우 fk_lgcatgono 가 null 이므로 바꿔준다.
		if(fk_lgcatgono == null){
			fk_lgcatgono = menu;
			if(fk_lgcatgono == '1'){
				smcatgono = '1';
			}
			else if(fk_lgcatgono =='2'){
				smcatgono = '5';
			}
			else{
				smcatgono = '6';
			}
			
		}
		// 내가 선택한 회의실 select 잡아주기
		if(fk_lgcatgono == '1') {
			$("select#reservType").val('1').prop("selected",true);
		} else if (fk_lgcatgono == '2') {
			$("select#reservType").val('2').prop("selected",true);
		} else if (fk_lgcatgono == '3') {
			$("select#reservType").val('3').prop("selected",true);
		}
		
		
		// 자원 항목 불러오기부터 시작(특정 자원 예약을 선택해서 예약을 진행하는 경우)
		
		if(fk_lgcatgono != null) {
			$.ajax({
				url:"<%= ctxPath%>/reservation/reservationTable.gw",
				type:"get",
				data:{"fk_lgcatgono":fk_lgcatgono},
				dataType:"json",
				success:function(json){
					
					var html = "";
					if(json.length > 0){
						
						$.each(json, function(index, item){
							html+="<option value='"+item.smcatgono+"'>"+item.smcatgoname+"</option>"
						});
						$("select.small_category").show();
						$("select.small_category").html(html);
						$("select.small_category").val(smcatgono).prop("selected",true);
					}	
				},
				error: function(request, status, error){
			    	alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			    }	 	
			}); // end of ajax
		}
		
		
		
		// 자원 예약 모달창에서 이전 날짜 예약 막기 시작
    	$("input#startDate").change(function(){
    		startDate = $("input#startDate").val();
    		
	    	// 이전 날짜 선택 막기
	    	blockSelectDate(startDate);
	    	blockSelectStartTime(startDate, selectTime);
	    }); // end of  $("input#reservStartDate").change(function()
    	
	    $("input#endDate").change(function(){
    		endDate = $("input#endDate").val();
	    	
	    	// 이전 날짜 선택 막기
	    	blockSelectDate(endDate);
	    	blockSelectEndTime(endDate, selectTime);
	    }); // end of  $("input#reservStartDate").change(function()
		// 자원 예약 모달창에서 이전 날짜 예약 막기 끝
		
	}// end of function insertReservation(){}--------------------
	
	
	// 예약 확인 버튼
	function goAddReservation() {
		
		var endDate = $("input#endDate").val();
		var startDate = $("input#startDate").val();
		
		if(startDate == null || endDate == null ){
			alert("날짜 선택을 해주세요");
			return;
		}
		if(startDate == "" || endDate == "" ){
			alert("날짜 선택을 해주세요");
			return;
		}
		
		// 일자 유효성 검사 (시작일자가 종료일자 보다 크면 안된다!!)
		
		
    	var sArr = startDate.split("-");
    	startDate= "";	
    	for(var i=0; i<sArr.length; i++){
    		startDate += sArr[i];
    	}
    	
    		
    	var eArr = endDate.split("-");   
     	var endDate= "";
     	for(var i=0; i<eArr.length; i++){
     		endDate += eArr[i];
     	}
		
     	var startHour= $("select#startHour").val();
     	var endHour = $("select#endHour").val();
        
     	// 조회기간 시작일자가 종료일자 보다 크면 경고
        if (Number(endDate) - Number(startDate) < 0) {
        	alert("반납 날짜 및 시간을 예약 날짜 및 시간 이후로 설정해주세요."); 
         	return;
        }
     	// 시작일과 종료일 같을 때 시간과 분에 대한 유효성 검사
        else if(Number(endDate) == Number(startDate)) {
        	
        	if(Number(startHour) > Number(endHour)){
        		alert("반납 날짜 및 시간을 예약 날짜 및 시간 이후로 설정해주세요."); 
        		return;
        	}
        	else if(Number(startHour) == Number(endHour)){
        		alert("반납 날짜 및 시간을 예약 날짜 및 시간 이후로 설정해주세요."); 
       			return;
        	}
        }// end of else if---------------------------------
    	
         
     	
        // 일정분류 선택 유무 검사
		var reservType = $("select.reservType").val().trim();
		if(reservType==""){
			alert("예약 항목을 선택하세요."); 
			return;
		}
		
		// 최대 24 시간 예약 제한걸기
		var sdate = startDate+$("select#startHour").val();
		var edate = endDate+$("select#endHour").val();
		
		
		
		if(!canMakeReservation(sdate, edate)){
			alert("최대 예약시간은 24시간 입니다. 그 이상은 관리자에게 문의하세요");
			return;
		}
		
		
		
		// 달력 형태로 만들어야 한다.(시작일과 종료일)
		// 오라클에 들어갈 date 형식(년월일시분초)으로 만들기
		var sdate = startDate+$("select#startHour").val()+"0000";
		var edate = endDate+$("select#endHour").val()+"0000";
		
	//	console.log($("select#startHour").val()); // 20221203070000
	//	console.log($("select#startMinute").val());
		
		$("input[name=startdate]").val(sdate);
		$("input[name=enddate]").val(edate);
		
		// 실사용자 넣어주기
		var plusUser_elm = document.querySelectorAll("div.displayUserList > span.plusUser");
		var realUserArr = new Array();
		
		plusUser_elm.forEach(function(item,index,array){
			realUserArr.push(item.innerText.trim());
		});
		
		var realuser = realUserArr.join(",");
		
		$("input[name=realuser]").val(realuser);
		
		
		var frm = document.addReservation_frm;
		frm.action="<%= ctxPath%>/reservation/addReservation.gw";
		frm.method="post";
		frm.submit();
		
	} // end of function goAddReservation()
	
	
	// 이전날짜 선택 막는 메소드
	function blockSelectDate(selectDate) {
		
		// 현재 시간 날짜 구해오기
		var now_year = now.getFullYear();
		var now_month = now.getMonth();
		var now_date = now.getDate();
		var now_hours = now.getHours();
		
		if(now_month < 10) {
			now_month = "0"+(now_month+1);
		} else {
			now_month = now_month + 1;
		}
		
		if(now_date < 10) {
			now_date = "0"+now_date;
		} 
		
		if(now_hours < 10) {
			now_hours = "0"+now_hours;
		} 
		
		var now_day =  now_year.toString() + now_month.toString() + now_date.toString();
		var today_date =  now_year.toString() + "-" + now_month.toString() + "-" + now_date.toString();
		
		var str_selectDay = selectDate.substring(0,4).toString() + selectDate.substring(5,7).toString() + selectDate.substring(8,10).toString();
		if(now_day > str_selectDay) {
			alert("지난 날짜는 예약할 수 없습니다.");
			$("input#reservStartDate").val(today_date);
			$("input#startDate").val(today_date);
			$("input#endDate").val(today_date);
			return false;
		}
		
	} // end of function blockSelectDate(now_day, selectDate, today_date) 
	
	
	// 자원 예약 시간 오늘 날짜인 경우 현재 시간 이후로 선택
	function blockSelectStartTime(selectDate, selectTime) {
		
		// 현재 시간 날짜 구해오기
		var now_year = now.getFullYear();
		var now_month = now.getMonth();
		var now_date = now.getDate();
		var now_hours = now.getHours();
		
		if(now_month < 10) {
			now_month = "0"+(now_month+1);
		} else {
			now_month = now_month + 1;
		}
		
		if(now_date < 10) {
			now_date = "0"+now_date;
		} 
		
		var now_day =  now_year.toString() + "-" + now_month.toString() + "-" + now_date.toString();
		
		// 시작시간, 종료시간		
		var html="";
		$("select#startHour").val();
		
		// 오늘이 아닐 때
		if(selectDate != now_day) {
			for(var i=0; i<24; i++){
				if(i<10){
					html+="<option value='0"+i+"'>0"+i+"</option>";
				}
				else{
					html+="<option value="+i+">"+i+"</option>";
				}
			}// end of for----------------------
			
			$("select#startHour").html(html);
			
		} else if (selectDate == now_day) {
			
			for(var i=(now_hours+1); i<24; i++){
				if(i<10){
					html+="<option value='0"+i+"'>0"+i+"</option>";
				}
				else{
					html+="<option value="+i+">"+i+"</option>";
				}
			}// end of for----------------------
			
			$("select#startHour").html(html);
		
		}
		
	} // end of function blockSelectTime(selectDate)
	
	
	// 자원 반납 시간 오늘 날짜인 경우 현재 시간 이후로 선택
	function blockSelectEndTime(selectDate, selectTime) {
		
		// 현재 시간 날짜 구해오기
		var now_year = now.getFullYear();
		var now_month = now.getMonth();
		var now_date = now.getDate();
		var now_hours = now.getHours();
		
		if(now_month < 10) {
			now_month = "0"+(now_month+1);
		} else {
			now_month = now_month + 1;
		}
		
		if(now_date < 10) {
			now_date = "0"+now_date;
		} 
		
		var now_day =  now_year.toString() + "-" + now_month.toString() + "-" + now_date.toString();
		
		// 시작시간, 종료시간		
		var html="";
		$("select#EndHour").val();
		
		// 오늘이 아닐 때
		if(selectDate != now_day) {
			for(var i=0; i<24; i++){
				if(i<10){
					html+="<option value='0"+i+"'>0"+i+"</option>";
				}
				else{
					html+="<option value="+i+">"+i+"</option>";
				}
			}// end of for----------------------
			
			$("select#endHour").html(html);
			
		// 오늘인데 23선택했을 때
		} else if (selectDate == now_day && selectTime == "23" && $("#endDate").val() != now_day) {
			
			for(var i=(now_hours+1); i<24; i++){
				if(i<10){
					html+="<option value='0"+i+"'>0"+i+"</option>";
				}
				else{
					html+="<option value="+i+">"+i+"</option>";
				}
			}// end of for----------------------
			
			$("select#startHour").html(html);
			
			var html2 = "";
			for(var i=0; i<24; i++){
				if(i<10){
					html2+="<option value='0"+i+"'>0"+i+"</option>";
				}
				else{
					html2+="<option value="+i+">"+i+"</option>";
				}
			}// end of for----------------------
			
			$("select#endHour").html(html2);
		
		// 오늘일 때
		} else if (selectDate == now_day) {
			
			for(var i=(now_hours+1); i<24; i++){
				if(i<10){
					html+="<option value='0"+i+"'>0"+i+"</option>";
				}
				else{
					html+="<option value="+i+">"+i+"</option>";
				}
			}// end of for----------------------
			
			$("select#endHour").html(html);
		}
		
	} // end of function blockSelectTime(selectDate)
	
	

	
			
	// div.displayUserList 에 공유자를 넣어주는 함수
	function addRealUser(value){  // value 가 공유자로 선택한이름 이다.
		
		var plusUser_es = $("div.displayUserList > span.plusUser").text();
		
		if(plusUser_es.includes(value)) {  // plusUser_es 문자열 속에 value 문자열이 들어있다라면 
			alert("이미 추가한 회원입니다.");
		}
		
		else {
			$("div.displayUserList").append("<span class='plusUser badge rounded-pill mr-2' style='color:white; background-color:rgb(3,199,90);'>"+value+"<i class='ml-2 far fa-times-circle'></i></span>");
		}
		
		$("input#realuserInput").val("");
	
	}// end of function add_joinUser(value){}----------------------------		
	
	
	
	// 자원 안내 수정
	function goEditContent(lgcatgono){
		$("input[name=lgcatgono]").val(lgcatgono);
		
		var frm = document.editContentFrm;
	    frm.method="get";
	    frm.action="<%= ctxPath%>/reservation/admin/editResourceContent.gw";
	    frm.submit();
	}
	
	function canMakeReservation(dateStr1, dateStr2) {
	    // "20231215" 형식의 문자열을 날짜로 변환
	    console.log(dateStr1);
	    console.log(dateStr2);
	    
	    var year1 = parseInt(dateStr1.substring(0, 4));
	    var month1 = parseInt(dateStr1.substring(4, 6)) - 1; // JavaScript의 월은 0부터 시작하므로 1을 빼줍니다.
	    var day1 = parseInt(dateStr1.substring(6, 8));
	    var hours1 = parseInt(dateStr1.substring(8, 10));
	    var date1 = new Date(year1, month1, day1, hours1);
		
	    var year2 = parseInt(dateStr2.substring(0, 4));
	    var month2 = parseInt(dateStr2.substring(4, 6)) - 1;
	    var day2 = parseInt(dateStr2.substring(6, 8));
	    var hours2 = parseInt(dateStr2.substring(8, 10));
	    var date2 = new Date(year2, month2, day2, hours2);
		
	    console.log(date2);
	    console.log(date1);
	    // 두 날짜의 차이 계산 (밀리초 단위)
	    var timeDifference = date2 - date1;
		console.log(timeDifference);
	    // 차이를 시간으로 변환 (밀리초 -> 시간)
	    bool = false;
	    
	    var hoursDifference = timeDifference / (1000 * 60 * 60);
	    
	    if(hoursDifference < 24){
	    	bool = true;
	    }
	    

	    // 36시간 이상인 경우 예약 불가
	    return bool;
	}
	
		
	
</script>




<!-- A vertical navbar -->
<nav class="navbar bg-light">

	<ul class="navbar-nav" style='width:100%'>
	
		<li class="nav-item">
			<h4 class='mb-4'>자원예약</h4>
		</li>
		
		<li class="nav-item mb-4">
      		<button id="insertBtn" type="button" style='width:100%;' class="btn btn-outline-dark" onclick="insertReservation();">자원 예약하기</button>
   	 	</li>
	
	    <li class="nav-item">
			<a id="meetingRoom" class="nav-link" href="<%=ctxPath%>/reservation/meetingRoom.gw">회의실 예약</a>
	    </li>
	    
	    <li class="nav-item">
			<a id="device" class="nav-link" href="<%=ctxPath%>/reservation/device.gw">기기 예약</a>
	    </li>
	    
	    <li class="nav-item">
			<a id="vehicle" class="nav-link" href="<%=ctxPath%>/reservation/vehicle.gw">차량 예약</a>
	    </li>
	    
	    <li class="nav-item">
			<a id="confirm" class="nav-link" href="<%=ctxPath%>/reservation/confirm.gw">예약 내역</a>
	    </li>
	    
	    <c:if test="${loginuser != null && loginuser.fk_job_id == '3'}">
	    <li style="margin-top: 7px;" class="nav-item topMenu">관리자 메뉴
	      	<ul class='subMenus adminMenu'>
	      		<li style="margin-top: 7px;"><a id="adminConfirm" class="nav-link" href="<%=ctxPath%>/reservation/admin/adminConfirm.gw">예약 내역 및 승인</a></li>
	      		<li><a id="managementResource" class="nav-link" href="<%=ctxPath%>/reservation/admin/managementResource.gw">자원 관리</a></li>
	      		<%-- <li><a id="management" class="nav-link" href="<%=ctxPath%>/reservation/admin/management.on">이용 안내 관리</a></li> --%>
	      	</ul>
	    </li>
		</c:if>
    
	</ul>

</nav>








<%-- 자원 예약 모달창 --%>
<div class="modal fade" id="modal_addReservation" role="dialog" data-backdrop="static">
	<div class="modal-dialog">
    	<div class="modal-content">
    
      		<!-- Modal header -->
      		<div class="modal-header">
        		<h4 class="modal-title">자원 예약하기</h4>
        		<button type="button" class="close modal_close" data-dismiss="modal">&times;</button>
      		</div>
      
      		<!-- Modal body -->
      		<div class="modal-body">
       			<form name="addReservation_frm">
       				<table style="width: 100%;" class="table table-borderless">
     					<tr>
     						<td class="col-3" style="text-align: left; vertical-align: middle;">자원 예약 시간</td>
     						<td>
								<input class="side_input_style" type="date" id="startDate" min="sysdate" value="${requestScope.chooseDate}"/>&nbsp; 
								<select id="startHour" class="side_input_style"></select>
								<span class="ml-1" id="startHour_text">시</span> 
							</td>
     					</tr>
     					
     					<tr>
     						<td style="text-align: left; vertical-align: middle;">자원 반납 시간</td>
     						<td>
								<input class="side_input_style" type="date" id="endDate" value="${requestScope.chooseDate}"/>&nbsp;
								<select id="endHour" class="side_input_style"></select>
								<span class="ml-1" id="endHour_text">시</span>
							</td>
						</tr>
						
						<tr> 
     						<td style="text-align: left; vertical-align: middle;">예약 항목 선택</td>
     						<td style="text-align: left; padding-left: 11px;">
     							<select class="reservType side_input_style" name="fk_lgcatgono" id="reservType">
									<option value="">선택하세요</option>
									<option value="1">회의실 예약</option>
									<option value="2">기기 예약</option>
									<option value="3">차량 예약</option>
								</select>
								<select class="small_category side_input_style" name="fk_smcatgono"></select>
     						</td>
     					</tr>
						
						<tr>
							<td  style="text-align: left; vertical-align: middle;">공유자</td>
							<td>
								<input type="text" id="realuserInput" name="realuserInput" class="side_input_style" placeholder="이용할 회원명을 입력하세요"/>
								<div class="displayUserList"></div>
								<input type="hidden" name="realuser"/>
							</td>
						</tr>
						
     					<tr>
     						<td style="text-align: left; vertical-align: middle;">예약자</td>
     						<td style="text-align: left; padding-left: 11px;">${sessionScope.loginuser.name}</td>
     					</tr>
     					
     				</table>
     				<input type="hidden" value="${sessionScope.loginuser.employee_id}" name="employee_id"/>
     				<input type="hidden" value="${sessionScope.loginuser.employee_id}" name="startdate"/>
     				<input type="hidden" value="${sessionScope.loginuser.employee_id}" name="enddate"/>
     				<input type="hidden" name="listgobackURL_reserv" value="${requestScope.listgobackURL_reserv}"/>
       			</form>	
      		</div>
      
      		<!-- Modal footer -->
      		<div class="modal-footer">
				<button type="button" class="btn btn-light btn-sm modal_close" data-dismiss="modal">취소</button>
      			<button type="button" style="background-color:rgb(3,199,90); color:white;" id="addTeam" class="btn btn-sm" onclick="goAddReservation()">예약</button>
      		</div>
      
    	</div>
  	</div>
</div>






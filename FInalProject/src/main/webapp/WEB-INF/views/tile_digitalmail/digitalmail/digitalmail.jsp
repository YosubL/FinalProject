<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
   String ctxPath = request.getContextPath();
%>
<link href="https://fonts.googleapis.com/icon?family=Material+Icons"
      rel="stylesheet">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons+Outlined"
      rel="stylesheet">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.Date" %>

  <script>
  
      // 페이지 로딩 후 실행되는 함수
      $(document).ready(function(){	 
    	  
    	  var war = $("input#pageupdown").val();
    	  
    	  if(war == "up"){
    		  alert("마지막 페이지입니다 마지막 페이지에 머뭅니다.");
    	  }
    	  if(war == "down"){
    		  alert("첫번째 페이지입니다 첫번째 페이지에 머뭅니다.");
    	  }
    	  
    	  var plzCount = $("span.plz0").length;
    	  var alertCount = $("span.alert0").length;
    	  var eventCount = $("span.event0").length;
    	  
    	  if(plzCount != 0){
    		  alert("안읽은 업무지시메일이 " + plzCount + "개 있습니다.");
    	  }
    	  if(alertCount != 0){
    		  alert("안읽은 긴급메일이 " + alertCount + "개 있습니다.");
    	  }
    	  if(eventCount != 0){
    		  alert("안읽은 공지사항이 " + eventCount + "개 있습니다.");
    	  }
    	  
    	  
    	  <%--
    	  // alert("war=>"+war);    	  
    	  // 시간 검사
          var date = "";
          var time ="";
          var hour = "";
          var minute = "";
          var send_time = "";
          
          var spanCount = $("span.gettime").length;

          for (var i = 0; i < spanCount; i++) {
              var date = $("span.gettime").eq(i).text();
              // alert(date);
              
              
              var redate = date.split("-");
           	  var reYear =  redate[0];
           	  var reMonth = redate[1];
           	  var reDay =   redate[2];
           	  var retime = time.split(":"); 
           	  var rehour =  retime[0];
           	  var remi =    retime[1];
           	   
           	  var reservation_date = new Date(reYear, reMonth, reDay, rehour, remi);      			       
    	            
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
	            
	         	const FullDate = year+"-"+month+"-"+day + " " + hour+":"+minute; 
	         	
	         	
	         	//alert("date=>"+date);
	         	// date=>2024-01-11 21:34
	         	//alert("FullDate=>"+FullDate);
	         	// 2024-01-08 12:00
              	
	         	if(FullDate<date){
            	  	$("div.gettime").eq(i).hide();
              	}
              
          }       	  
--%>
       	
    	  
    	  
    	  
    	  
    	  
    	  
    	  
    	  
    	  
    	  /*
	      // 각 섹션에 대한 클릭 이벤트 리스너 등록
	      $('div.section').click(function() {
		      alert('섹션 클릭됨!');
	      	  // 기존에 선택된 섹션들에서 'section_selected' 클래스 제거
	          $('div.section').removeClass('section_selected');
	          // 현재 클릭된 섹션에 'section_selected' 클래스 추가
	          $(this).addClass('section_selected');
	      });
		  */
		  
	      /* 안쓰는듯?
	      $('div.opti').click(function() {
	         alert('시발섹션 클릭됨!');

	         // 기존에 선택된 섹션들에서 'section_selected' 클래스 제거
	         $('div.hide').removeClass('section_selected');
	         $('div.show').addClass('section_selected');
	        	
	      });
		  */
		  
		  /*
	      // 각 섹션에 대한 클릭 이벤트 리스너 등록
	  	  $('div.opt').click(function() {
	          alert('섹션 클릭됨!');
	          $('div.hide').show();
	   	      // 기존에 선택된 섹션들에서 'section_selected' 클래스 제거
	       	  $('div.section').removeClass('section_selected');
	          $('div.hide').addClass('section_selected');
	         // iconText와 menuNameText 가져오기
	      	  var iconText = $(this).find('.material-icons-outlined').text().trim();
	      	  var menuNameText = $(this).find('.menu_name').text().trim();
	  	      // console.log(iconText,menuNameText);
		      $('div.hide .material-icons-outlined').text(iconText);
	          $('div.hide .list_name').text(menuNameText);
	      });
	      */
	      
	      let type = "${requestScope.type}";
	      // alert(type);
	      if(type=="null"){
	      	 
	      }
	      else{
	      if(type == "fk_sender_email"){
	    	  var iconText = 'forward_to_inbox';
	      	  var menuNameText = '보낸메일함';
	  	      // console.log(iconText,menuNameText);
		      $('div.show .material-icons-outlined').text(iconText);
	          $('div.show .list_name').text(menuNameText);  
	      }
	      if(type=="noread"){
	    	  var iconText = 'mark_email_unread';
	      	  var menuNameText = '안읽은메일함';
	  	      // console.log(iconText,menuNameText);
		      $('div.show .material-icons-outlined').text(iconText);
	          $('div.show .list_name').text(menuNameText);  
	      }
	      if(type=="impt"){
	    	  var iconText = 'priority_high';
	      	  var menuNameText = '중요메일함';
	  	      // console.log(iconText,menuNameText);
		      $('div.show .material-icons-outlined').text(iconText);
	          $('div.show .list_name').text(menuNameText);  
	      }
	      if(type=="fav"){
	    	  var iconText = 'favorite';
	      	  var menuNameText = '즐겨찾기';
	  	      // console.log(iconText,menuNameText);
		      $('div.show .material-icons-outlined').text(iconText);
	          $('div.show .list_name').text(menuNameText);  
	      }
	      if(type=="del"){
	    	  var iconText = 'delete';
	      	  var menuNameText = '휴지통';
	  	      // console.log(iconText,menuNameText);
		      $('div.show .material-icons-outlined').text(iconText);
	          $('div.show .list_name').text(menuNameText);  
	      }
	      if(type=="me"){
	    	  var iconText = 'edit_note';
	      	  var menuNameText = '내게쓴메일함';
	  	      // console.log(iconText,menuNameText);
		      $('div.show .material-icons-outlined').text(iconText);
	          $('div.show .list_name').text(menuNameText);  
	      }
	      if(type=="sell"){
	    	  var iconText = 'sell';
	      	  var menuNameText = '카테고리메일함';
	  	      // console.log(iconText,menuNameText);
		      $('div.show .material-icons-outlined').text(iconText);
	          $('div.show .list_name').text(menuNameText);  
	      }
	      if(type=="read"){
	    	  var iconText = 'drafts';
	      	  var menuNameText = '읽은메일함';
	  	      // console.log(iconText,menuNameText);
		      $('div.show .material-icons-outlined').text(iconText);
	          $('div.show .list_name').text(menuNameText);  
	      }
	      if(type=="team"){
	    	  var iconText = 'face';
	      	  var menuNameText = '우리팀메일함';
	  	      // console.log(iconText,menuNameText);
		      $('div.show .material-icons-outlined').text(iconText);
	          $('div.show .list_name').text(menuNameText);  
	      }
	      if(type=="dept"){
	    	  var iconText = 'face';
	      	  var menuNameText = '우리부서메일함';
	  	      // console.log(iconText,menuNameText);
		      $('div.show .material-icons-outlined').text(iconText);
	          $('div.show .list_name').text(menuNameText);  
	      }
	      }
	      
	      
		  // 체크 메뉴
	      $(".digitalmail_check").click(function(){
	          let bFlag = false;
	          $(".digitalmail_check").each(function(){
	              var Checkedbox = $(this).prop("checked");
	              if(!Checkedbox) {
	                  $("#all_check").prop("checked",false);
	                  bFlag = true;
	                  return false;
	              }  
	          });
	          if(!bFlag) {
	            $("#all_check").prop("checked",true);
			  }
          });	      
      
      });
      
      // 함수 정의 시작      
      
    // 체크박스 전체 체크 해제 
    function allCheckBox() {
          
    	  var bool = $("#all_check").is(":checked");          
          $(".digitalmail_check").prop("checked", bool);
        
    }// end of function allCheckBox()------------------------- 다했음
      
  	function selectOneEmail(send_email_seq){
		
    	//alert(send_email_seq);  
    	// 패스워드 체크
		$.ajax({
			url:"<%= ctxPath%>/getEmailPwd.gw",
			type:"post",
			data:{"send_email_seq":send_email_seq},
			dataType:"json",
	        success:function(json){
	        	if(json.pwd != null || json.pwd != "null"){
	        		alert("비밀 메일입니다. 암호를 입력해주세요.=>"+json.pwd);
	        		var enteredPwd = prompt("비밀 메일입니다. 암호를 입력해주세요.");
	        		if (enteredPwd === json.pwd) {
	                    alert("암호가 일치합니다.");
	                    location.href="<%=ctxPath%>/digitalmailview.gw?send_email_seq="+send_email_seq+"&type="+'${requestScope.type}';
	                } else {
	                    alert("암호가 일치하지 않습니다. 다시 시도해주세요.");
	                }
	  			}
	        	else{
	        		alert("비밀 메일이 아닙니다."+ json.pwd);
	        		location.href="<%=ctxPath%>/digitalmailview.gw?send_email_seq="+send_email_seq+"&type="+'${requestScope.type}';
	    		}

      
	        },
	        error: function(request, status, error){
                alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
            } 
		});
	}
<%--   
 	// receipt_favorites update 하기
	function receipt_favorites_update(receipt_mail_seq , type){
 		$.ajax({
			url:"<%= ctxPath%>/receipt_favorites_update.gw",
			type:"post",
			data:{"receipt_mail_seq":receipt_mail_seq,
				  "type":type},
			dataType:"json",
	        success:function(json){
	        	console.log(json);
	        	// {"receipt_favorites":"0"}
	        	
        		if(json.receipt_favorites1 === "1"){
	        		$("span#"+receipt_mail_seq).text("favorite");
	        		$("span#"+receipt_mail_seq).css("color", "red");
	        	}
	        	
	        	else{
	        		$("span#"+receipt_mail_seq).text("favorite_border");
	        		$("span#"+receipt_mail_seq).css("color", "black");
	        	}
	        	
	        },
	        error: function(request, status, error){
                alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
            }
			
		});
		
	};
--%>	
	
	// receipt_favorites update 하기
	function receipt_favorites_update(receipt_mail_seq){
		// alert("type=>"+'${requestScope.type}');
		$.ajax({
			url:"<%= ctxPath%>/receipt_favorites_update.gw",
			type:"post",
			data:{"receipt_mail_seq":receipt_mail_seq,
				"type":'${requestScope.type}'},
			dataType:"json",
	        success:function(json){
	        //	console.log(json);
	        	// {"receipt_favorites":"0"}
        		if(json.receipt_favorites === "1"){
	        		$("span."+receipt_mail_seq+"fav").text("favorite");
	        		$("span."+receipt_mail_seq+"fav").css("color", "red");
	        	}
	        	else{
	        		$("span."+receipt_mail_seq+"fav").text("favorite_border");
	        		$("span."+receipt_mail_seq+"fav").css("color", "black");
	        	}
	        },
	        error: function(request, status, error){
                alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
            }
		});
	};
	
	
	// email_receipt_read_count update 하기
	function email_receipt_read_count_update(receipt_mail_seq){
		$.ajax({
			url:"<%= ctxPath%>/email_receipt_read_count_update.gw",
			type:"post",
			data:{"receipt_mail_seq":receipt_mail_seq},
			dataType:"json",
	        success:function(json){
	        //	console.log(json);
	        	
        		$("span#"+receipt_mail_seq+"rc").text("drafts");
        		$("span#"+receipt_mail_seq+"rc").css("color", "black");
	        	
	        },
	        error: function(request, status, error){
                alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
            }
		});
	};
	
	
	// receipt_important update 하기
	function receipt_important_update(receipt_mail_seq){
		$.ajax({
			url:"<%= ctxPath%>/receipt_important_update.gw",
			type:"post",
			data:{"receipt_mail_seq":receipt_mail_seq,
			"type":'${requestScope.type}'},
			dataType:"json",
	        success:function(json){
	        	console.log(json);
	        	// {"receipt_favorites":"0"}
        		if(json.receipt_important === "1"){
	        		$("span#"+receipt_mail_seq+"imp").text("priority_high");
	        		$("span#"+receipt_mail_seq+"imp").css("color", "orange");
	        	}
	        	else{
	        		$("span#"+receipt_mail_seq+"imp").text("priority_high");
	        		$("span#"+receipt_mail_seq+"imp").css("color", "black");
	        	}
	        },
	        error: function(request, status, error){
                alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
            }
		});
	};
	
	function goDel(deltype){
  		
		var deltype = deltype;
  		// alert("클릭했습니다.")
  		const receipt_mail_seq_check = $("input:checkbox[name='receipt_mail_seq']:checked").length;
  		// alert("empidcheck = >" + empidcheck);
  		
  		if(receipt_mail_seq_check < 1) {
             alert("삭제할 이메일을 선택하세요");
             return;
        }
		else {
			const allCnt = $("input:checkbox[name='receipt_mail_seq']").length;      
            const receipt_mail_seq_Arr = new Array();        
			for(let i=0; i<allCnt; i++) {
				if($("input:checkbox[name='receipt_mail_seq']").eq(i).prop("checked")) {
  	            receipt_mail_seq_Arr.push($("input:checkbox[name='receipt_mail_seq']").eq(i).val() );
  				} // end of if -----
  	            
			}// end of for---------------------------
			
			let uniqueArray = receipt_mail_seq_Arr.filter((value, index, self) => {
				  return self.indexOf(value) === index;
			});

			
        	//alert("uniqueArray=>"+uniqueArray);
			
          	console.log("삭제 이메일 번호: " + uniqueArray);
          
            console.log("삭제 이메일 번호: " + receipt_mail_seq_Arr);
            const receipt_mail_seq_join = uniqueArray.join();
          
            console.log("삭제 이메일 번호: " + receipt_mail_seq_join);
  		
            const bool = confirm("정말로 삭제하시겠습니까?");
         	
            //alert("deltype=>"+deltype);
          	if(bool) {   
                $.ajax({
              		url:"<%= ctxPath%>/email_del.gw",
                  	type:"POST",
                  	data:{
                  		"receipt_mail_seq_join":receipt_mail_seq_join,
                  		"deltype":deltype
                  	},
                  	dataType:"JSON",     
                  	success:function(json){
                  	
      					if (json.delsuc) {
      						alert("삭제를 완료했습니다.");	
      						F5frm();
      					} 
      					else {
      						alert("삭제를 실패했습니다.");	
      					}
      				},
      				error: function(request, status, error){
      					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
      				}
              
            
          });
           
	} 
          
          
          
  	} // else { ----------------------------------------
  	
  	
  	
  	}
  	
	function total_email_receipt_read_count_update(readcount){
  		
		var readcnt = readcount;
  		// alert("클릭했습니다.")
  		const receipt_mail_seq_check = $("input:checkbox[name='receipt_mail_seq']:checked").length;
  		// alert("empidcheck = >" + empidcheck);
  		
  		if(receipt_mail_seq_check < 1) {
             alert("변경할 이메일을 선택하세요");
             return;
        }
		else {
			const allCnt = $("input:checkbox[name='receipt_mail_seq']").length;      
            const receipt_mail_seq_Arr = new Array();        
			for(let i=0; i<allCnt; i++) {
				if($("input:checkbox[name='receipt_mail_seq']").eq(i).prop("checked")) {
  	            receipt_mail_seq_Arr.push($("input:checkbox[name='receipt_mail_seq']").eq(i).val() );
  				} // end of if -----
  	            
			}// end of for---------------------------
          
          
            console.log("삭제 이메일 번호: " + receipt_mail_seq_Arr);
            const receipt_mail_seq_join = receipt_mail_seq_Arr.join();
          
            console.log("삭제 이메일 번호: " + receipt_mail_seq_join);
  		
            const bool = confirm("정말로 삭제하시겠습니까?");
         
          	if(bool) {   
                $.ajax({
              		url:"<%= ctxPath%>/total_email_receipt_read_count_update.gw",
                  	type:"POST",
                  	data:{
                  		"receipt_mail_seq_join":receipt_mail_seq_join,
                  		"readcnt":readcnt
                  	},
                  	dataType:"JSON",     
                  	success:function(json){
                  	
      					if (json.readCountcnt) {
      						alert("업데이트 완료");
      						F5frm();
      					} 
      					else {
      						alert("업데이트 실패");	
      					}
      				},
      				error: function(request, status, error){
      					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
      				}
              
            
          });
           
	} 
          
          
          
  	} // else { ----------------------------------------
  	
  	
  	
  	}
	
	function F5frm(){
		
		var F5frm = document.F5Frm;
		F5frm.method = "get";
		F5frm.action = "<%= ctxPath%>/digitalmail.gw";
		F5frm.submit(); 
	}
	
	// 주어진 값이 10보다 작을 경우 그 앞에 0을 붙여서 두 자리 수로 만드는 함수
	function padZero(value) {
	    return value < 10 ? "0" + value : value;
	}
	
      
  
  </script>



	<!-- 결과물 시작하기 <div class="main_body"> -->
	<!-- Email List  <div class="emailList"> -->
	<!-- 메일함 리스트 세팅-->
	
	<div class="emailList_settings">
		<input type="hidden" id="pageupdown" value='${requestScope.war}'/>
		<!--왼쪽 세팅-->
		<div class="emailList_settingsLeft">
	        <input type="checkbox" id="all_check" onclick="allCheckBox();">                        
			<div class="icon_set ml-3 mr-3" onclick="F5frm()">
				<span class="material-icons-outlined icon_img" style="font-size: 24pt;">redo</span>
				<span class="icon_text">새로고침</span>
			</div>
			<c:if test="${requestScope.type ne 'fk_sender_email' and requestScope.type ne 'del' and requestScope.type ne 'senddel'}">
				<div class="icon_set mr-3">
					<span id="${emailVO.receipt_mail_seq}rc" class="material-icons-outlined ml-2" onclick="total_email_receipt_read_count_update('1')" style="font-size: 24pt;">drafts</span>
					<span class="icon_text">읽음</span>
				</div>
			
				<div class="icon_set mr-3">
					<span id="${emailVO.receipt_mail_seq}rc" class="material-icons-outlined ml-2" onclick="total_email_receipt_read_count_update('0')" style="color: red; font-size: 24pt;">mark_email_unread</span>
					<span class="icon_text">안읽음</span>
				</div>	
			</c:if>					           
			<div class="icon_set mr-3" onclick="goDel('${requestScope.type}');">
				<span class="material-icons-outlined icon_img" style="font-size:24pt;">delete</span>
				<span class="icon_text">휴지통</span>
			</div>
			
			<c:if test="${requestScope.type == 'del'}">
				<div class="icon_set mr-3" onclick="goDel('plus');">
					<span class="material-icons-outlined icon_img" style="font-size: 24pt;">delete</span>
					<span class="icon_text">복구하기</span>
				</div>
			</c:if>
			<c:if test="${requestScope.type == 'senddel'}">
				<div class="icon_set mr-3" onclick="goDel('senddelplus');">
					<span class="material-icons-outlined icon_img" style="font-size: 24pt;">delete</span>
					<span class="icon_text">복구하기</span>
				</div>
			</c:if>                           
		</div>
        <!--왼쪽 세팅-->
        <form name="F5Frm">
		</form>
        <!--오른쪽 세팅-->
        <div class="emailList_settingsRight">
			${requestScope.pageBar}  
		</div>
		<!--오른쪽 세팅-->
		
	</div>
	
	<!--셀렉션 세팅-->
	<div class="emailList_sections">
    	<div class="section section_selected show">
        	<span class="material-icons-outlined" style="font-size:24px;"> inbox </span> 
			<span class="list_name">받은메일함</span>
		</div>
		<div class="section hide">
			<span class="material-icons-outlined">quiz</span> 
            <span class="list_name">메뉴를 선택해주세요</span>
        </div>
	</div> 
	<!--셀렉션 세팅 끝-->
	
	<!--이메일 리스트-->
	<div class="emailList_list">
		
		<c:if test="${empty requestScope.emailVOList}">
    		<div class="emailRow" style="width: 100%; display: flex;">
				<span style="display:inline-block; margin: 0 auto;">받은 메일이 없습니다.</span>
			</div>
		</c:if>
		
		<c:if test="${not empty requestScope.emailVOList}">
			
			<c:forEach var="emailVO" items="${requestScope.emailVOList}" varStatus="status">
				<div class="emailRow gettime" id="${emailVO.receipt_mail_seq}time">
					<c:if test="${requestScope.type != 'fk_sender_email' and requestScope.type != 'senddel'}">
						
						<!-- 즐겨찾기 여부 -->
						<div class="emailRow_options" style="width:15%;">
							<input type="checkbox" type="checkbox" name="receipt_mail_seq" value="${emailVO.receipt_mail_seq}" class="digitalmail_check">
		
			                <c:if test="${emailVO.receipt_favorites==0}">
			                	<span class="${emailVO.receipt_mail_seq}fav material-icons-outlined ml-2" onclick="receipt_favorites_update('${emailVO.receipt_mail_seq}')">favorite_border</span>
			                </c:if>
			                <c:if test="${emailVO.receipt_favorites==1}">
			                	<span class="${emailVO.receipt_mail_seq}fav material-icons-outlined ml-2" onclick="receipt_favorites_update('${emailVO.receipt_mail_seq}')" style="color: red;">favorite</span>
			                </c:if>
			                <!-- 읽음 여부 정보 -->
							<c:if test="${emailVO.email_receipt_read_count==0}">
		                		<span id="${emailVO.receipt_mail_seq}rc" class="material-icons-outlined ml-2" onclick="email_receipt_read_count_update('${emailVO.receipt_mail_seq}')" style="color: red;">mark_email_unread</span>
		                	</c:if>
		                	<c:if test="${emailVO.email_receipt_read_count==1}">
		                		<span id="${emailVO.receipt_mail_seq}rc" class="material-icons-outlined ml-2" onclick="email_receipt_read_count_update('${emailVO.receipt_mail_seq}')">drafts</span>
		                	</c:if>		
				        	<!-- 읽음 여부 정보 -->
				        	<!-- 중요메일 여부 -->
							<c:if test="${emailVO.receipt_important==0}">
			                	<span id="${emailVO.receipt_mail_seq}imp" class="material-icons-outlined" onclick="receipt_important_update('${emailVO.receipt_mail_seq}')" style="color: black;"> priority_high </span>
			                </c:if>
			                <c:if test="${emailVO.receipt_important==1}">
			                	<span id="${emailVO.receipt_mail_seq}imp" class="material-icons-outlined" onclick="receipt_important_update('${emailVO.receipt_mail_seq}')" style="color: orange;"> priority_high </span>
			                </c:if>
			                <c:if test="${emailVO.category==1}">
			                	<span class="material-icons-outlined ml-2 plz${emailVO.email_receipt_read_count}" style="color: green; font-size: 12pt;">업무지시</span>
			                </c:if>
			                <c:if test="${emailVO.category==2}">
			                	<span class="material-icons-outlined ml-2 alert${emailVO.email_receipt_read_count}" style="color: red; font-size: 12pt;">긴급</span>
			                </c:if>
			                <c:if test="${emailVO.category==3}">
			                	<span class="material-icons-outlined ml-2 event${emailVO.email_receipt_read_count}" style="color: blue; font-size: 12pt;">공지사항</span>
			                </c:if>		
					        <!-- 중요메일 여부 -->
						</div>
						<!-- 즐겨찾기 여부 -->
						<!-- 수신자 정보 -->
						<span class="emailRow_title ml-2">${emailVO.job_name}&nbsp;${emailVO.name}</span>
						<!-- 수신자 정보 -->
					
						<!-- 제목-->
					
						<div class="emailRow_message" onclick = "selectOneEmail('${emailVO.send_email_seq}')">
							<c:if test="${emailVO.filename==null}">
								파일 없음
							</c:if>
							<c:if test="${emailVO.filename != null}">
								파일 있음
							</c:if>
							<span>${emailVO.email_subject}</span>
						</div>
						<!-- 제목 -->
						
						<!--전송시간-->
						<span id="${emailVO.receipt_mail_seq}time" class="mr-3 gettime" onclick = "selectOneEmail('${emailVO.send_email_seq}')">${emailVO.send_time}</span>
						<!--전송시간-->
					</c:if>
					
					<c:if test="${requestScope.type == 'fk_sender_email'}">
						<div class="emailRow_options" style="width:15%;">
							<input type="checkbox" type="checkbox" name="receipt_mail_seq" value="${emailVO.send_email_seq}" class="digitalmail_check">
			                <c:if test="${emailVO.sender_favorites==0}">
			                	<span class="${emailVO.send_email_seq}fav material-icons-outlined ml-2" onclick="receipt_favorites_update('${emailVO.send_email_seq}')">favorite_border</span>
			                </c:if>
			                <c:if test="${emailVO.sender_favorites==1}">
			                	<span class="${emailVO.send_email_seq}fav material-icons-outlined ml-2" onclick="receipt_favorites_update('${emailVO.send_email_seq}')" style="color: red;">favorite</span>
			                </c:if>
				        	<!-- 중요메일 여부 -->
							<c:if test="${emailVO.sender_important==0}">
			                	<span id="${emailVO.send_email_seq}imp" class="material-icons-outlined" onclick="receipt_important_update('${emailVO.send_email_seq}')" style="color: black;"> priority_high </span>
			                </c:if>
			                <c:if test="${emailVO.sender_important==1}">
			                	<span id="${emailVO.send_email_seq}imp" class="material-icons-outlined" onclick="receipt_important_update('${emailVO.send_email_seq}')" style="color: orange;"> priority_high </span>
			                </c:if>		
					        <!-- 중요메일 여부 -->
					        <!-- 읽음 여부 정보 -->
							<c:if test="${emailVO.email_total_read_count == 0}">
		                		<span style="font-size: 12px">0명 읽음</span>
		                	</c:if>
		                	<c:if test="${emailVO.email_total_read_count != 0}">
		                		<span style="font-size: 12px">${emailVO.email_total_read_count}명 읽음</span>
		                	</c:if>		
				        	<!-- 읽음 여부 정보 -->
						</div>
												<!-- 즐겨찾기 여부 -->
					
						<!-- 수신자 정보 -->
						<span class="emailRow_title ml-2">${emailVO.job_name}&nbsp;${emailVO.name}</span>
						<!-- 수신자 정보 -->
					
						<!-- 제목-->
					
						<div class="emailRow_message" onclick = "selectOneEmail('${emailVO.send_email_seq}')">
							<c:if test="${emailVO.filename==null}">
								파일 없음
							</c:if>
							<c:if test="${emailVO.filename != null}">
								파일 있음
							</c:if>
							<c:if test="${emailVO.category==1}">
			                	<span class="material-icons-outlined ml-2 plz${emailVO.email_receipt_read_count}" style="color: green; font-size: 12pt;">업무지시</span>
			                </c:if>
			                <c:if test="${emailVO.category==2}">
			                	<span class="material-icons-outlined ml-2 alert${emailVO.email_receipt_read_count}" style="color: red; font-size: 12pt;">긴급</span>
			                </c:if>
			                <c:if test="${emailVO.category==3}">
			                	<span class="material-icons-outlined ml-2 event${emailVO.email_receipt_read_count}" style="color: blue; font-size: 12pt;">공지사항</span>
			                </c:if>
							<span>${emailVO.email_subject}</span>
						</div>
						<!-- 제목 -->
						
						<!--전송시간-->
						<span id="${emailVO.receipt_mail_seq}time" class="mr-3 gettime" onclick = "selectOneEmail('${emailVO.send_email_seq}')">${emailVO.send_time}</span>
						<!--전송시간-->
						
						
						
					</c:if>
					
					<c:if test="${requestScope.type == 'senddel'}">
						<div class="emailRow_options" style="width:15%;">
							<input type="checkbox" type="checkbox" name="receipt_mail_seq" value="${emailVO.send_email_seq}" class="digitalmail_check">
			                <!-- 읽음 여부 정보 -->
							<c:if test="${emailVO.email_total_read_count==0}">
		                		<span style="font-size: 12px">0명 읽음</span>
		                	</c:if>
		                	<c:if test="${emailVO.email_total_read_count!=0}">
		                		<span style="font-size: 12px">${emailVO.email_total_read_count}명 읽음</span>
		                	</c:if>		
				        	<!-- 읽음 여부 정보 -->
				        	<!-- 중요메일 여부 -->
					        <!-- 중요메일 여부 -->
						</div>
					
						<!-- 즐겨찾기 여부 -->
					
						<!-- 수신자 정보 -->
						<span class="emailRow_title ml-2">${emailVO.job_name}&nbsp;${emailVO.name}</span>
						<!-- 수신자 정보 -->
					
						<!-- 제목-->
					
						<div class="emailRow_message" onclick = "selectOneEmail('${emailVO.send_email_seq}')">
							<c:if test="${emailVO.filename==null}">
								파일 없음
							</c:if>
							<c:if test="${emailVO.filename != null}">
								파일 있음
							</c:if>
							<c:if test="${emailVO.category==1}">
			                	<span class="material-icons-outlined ml-2 plz${emailVO.email_receipt_read_count}" style="color: green; font-size: 12pt;">업무지시</span>
			                </c:if>
			                <c:if test="${emailVO.category==2}">
			                	<span class="material-icons-outlined ml-2 alert${emailVO.email_receipt_read_count}" style="color: red; font-size: 12pt;">긴급</span>
			                </c:if>
			                <c:if test="${emailVO.category==3}">
			                	<span class="material-icons-outlined ml-2 event${emailVO.email_receipt_read_count}" style="color: blue; font-size: 12pt;">공지사항</span>
			                </c:if>
							<span>${emailVO.email_subject}</span>
						</div>
						<!-- 제목 -->
						
						<!--전송시간-->
						<span id="${emailVO.receipt_mail_seq}time" class="mr-3 gettime" onclick = "selectOneEmail('${emailVO.send_email_seq}')">${emailVO.send_time}</span>
						<!--전송시간-->
					
					</c:if>
					
				</div>
			</c:forEach>
		</c:if>
	</div>

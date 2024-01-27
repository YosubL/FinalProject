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


  <script>
  
      // 페이지 로딩 후 실행되는 함수
      $(document).ready(function(){
	      
	      // 각 섹션에 대한 클릭 이벤트 리스너 등록
	      $('div.section').click(function() {
		      // alert('섹션 클릭됨!');
	      	  // 기존에 선택된 섹션들에서 'section_selected' 클래스 제거
	          $('div.section').removeClass('section_selected');
	          // 현재 클릭된 섹션에 'section_selected' 클래스 추가
	          $(this).addClass('section_selected');
	      });
		  	
	      /* 안쓰는듯?
	      $('div.opti').click(function() {
	         alert('시발섹션 클릭됨!');

	         // 기존에 선택된 섹션들에서 'section_selected' 클래스 제거
	         $('div.hide').removeClass('section_selected');
	         $('div.show').addClass('section_selected');
	        	
	      });
		  */
		  
	      // 각 섹션에 대한 클릭 이벤트 리스너 등록
	  	  $('div.opt').click(function() {
	          // alert('섹션 클릭됨!');
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
      
  	function selectStoprEmail(send_emailstop_seq){
		
    	// alert(send_emailstop_seq);  
    	location.href="<%=ctxPath%>/digitalmailstopwrite.gw?send_emailstop_seq="+send_emailstop_seq;
	}
	
	function goDel(){
  		
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
          
          
            console.log("삭제 이메일 번호: " + receipt_mail_seq_Arr);
            const receipt_mail_seq_join = receipt_mail_seq_Arr.join();
          
            console.log("삭제 이메일 번호: " + receipt_mail_seq_join);
  		
            const bool = confirm("정말로 삭제하시겠습니까?");
         
          	if(bool) {   
                $.ajax({
              		url:"<%= ctxPath%>/emailstop_del.gw",
                  	type:"POST",
                  	data:{
                  		"send_emailstop_seq":receipt_mail_seq_join
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
  	
	function F5frm(){
		
		var F5frm = document.F5Frm;
		F5frm.method = "get";
		F5frm.action = "<%= ctxPath%>/digitalmail.gw";
		F5frm.submit(); 
	}
    
      
      
  
  </script>



	<!-- 결과물 시작하기 <div class="main_body"> -->
	<!-- Email List  <div class="emailList"> -->
	<!-- 메일함 리스트 세팅-->
	
	<div class="emailList_settings">
		
		<!--왼쪽 세팅-->
		<div class="emailList_settingsLeft">
	        <input type="checkbox" id="all_check" onclick="allCheckBox();">                        
			<div class="icon_set ml-3 mr-3" onclick="F5frm();">
				<span class="material-icons-outlined icon_img" style="font-size: 24pt;">redo</span>
				<span class="icon_text">새로고침</span>
			</div>					           
			<div class="icon_set mr-3" onclick="goDel();">
				<span class="material-icons-outlined icon_img" style="font-size: 24pt;">delete</span>
				<span class="icon_text">휴지통</span>
			</div>                        
		</div>
        <!--왼쪽 세팅-->
        
        <!--오른쪽 세팅-->
        <div class="emailList_settingsRight">
			${requestScope.pageBar}  
		</div>
		<form name="F5Frm">
		</form>
		<!--오른쪽 세팅-->
		
	</div>
	
	<!--셀렉션 세팅-->
	<div class="emailList_sections">
    	<div class="section section_selected show">
        	<span class="material-icons-outlined" style="font-size:24px;"> note_add </span> 
			<span class="list_name">임시보관함</span>
		</div>
		<div class="section hide">
			<span class="material-icons-outlined">quiz</span> 
            <span class="list_name">메뉴를 선택해주세요</span>
        </div>
	</div> 
	<!--셀렉션 세팅 끝-->

	<!--이메일 리스트-->
	<div class="emailList_list">
		
		<c:if test="${empty requestScope.emailstopList}">
    		<div class="emailRow" style="width: 100%; display: flex;">
				<span style="display:inline-block; margin: 0 auto;">받은 메일이 없습니다.</span>
			</div>
		</c:if>
		
		<c:if test="${not empty requestScope.emailstopList}">
			<c:forEach var="EmailStopVO" items="${requestScope.emailstopList}" varStatus="status">
				<div class="emailRow">
					
					<!-- 즐겨찾기 여부 -->
					<div class="emailRow_options">
						<input type="checkbox" type="checkbox" name="receipt_mail_seq" value="${EmailStopVO.send_emailstop_seq}" class="digitalmail_check">
					</div>
					<!-- 즐겨찾기 여부 -->
					
	  
					<!-- 수신자 정보 -->
					<span class="emailRow_title ml-2">임시 저장 중인 메일</span>
					<!-- 수신자 정보 -->
					
					<!-- 제목-->
					<div class="emailRow_message" onclick = "selectStoprEmail('${EmailStopVO.send_emailstop_seq}')">
						<span>${EmailStopVO.email_subject}</span>
					</div>
					<!-- 제목 -->
						
					<!--전송시간-->
					<span class="mr-3" onclick = "selectStoprEmail('${EmailStopVO.send_emailstop_seq}')">${EmailStopVO.stoptime}</span>
					<!--전송시간-->
				</div>
			</c:forEach>
		</c:if>
	</div>

     

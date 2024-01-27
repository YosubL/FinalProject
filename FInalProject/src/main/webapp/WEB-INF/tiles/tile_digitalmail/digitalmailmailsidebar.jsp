<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String ctxPath = request.getContextPath();
%>

  <script>
  // 페이지 로딩 후 실행되는 함수
  $(document).ready(function(){
      $('div.more_memu').hide();
	  $('div.hide').hide();
	  
	  // 클릭 이벤트 리스너 등록
	  $('div.more').click(function(){
          // 알람 메시지 표시
   		  //alert('더보기 클릭됨!');
       	  /*
       	  var menu_html = "<div class='sidebarOption'>"
       	  menu_html += "<span class='material-icons-outlined'>drafts</span>"
       	  menu_html += "<span class='menu_name'>읽은메일함</span></div>"	
          menu_html += "<div class='sidebarOption'>"
          menu_html += "<span class='material-icons-outlined'>edit_note</span>"
          menu_html += "<span class='menu_name'>내게쓴메일함</span></div>"	
          menu_html += "<div class='sidebarOption'>"
          menu_html += "<span class='material-icons-outlined'>face</span>"
          menu_html += "<span class='menu_name'>우리팀메일</span></div>"	
          menu_html += "<div class='sidebarOption'>"
		  menu_html += "<span class='material-icons-outlined'>account_circle</span>"
          menu_html += "<span class='menu_name'>우리부서메일</span></div>"	
          menu_html += "<div class='sidebarOption'>"
		  menu_html += "<span class='material-icons-outlined'>expand_less</span>"
          menu_html += "<span class='menu_name'>접기</span></div>"	
          $("div.more_menu").html(menu_html);
          */
		  
          // 더보기 버튼 숨기기
		  $('div.more').hide();
	      $('div.more_memu').show();
                
      });
        	
   	  // 클릭 이벤트 리스너 등록
      $('div.reset').click(function(){
          $('div.more_memu').hide();
          $('div.more').show();
           
      });
        	 
  }); 
        
  </script>


	<!--사이드바 시작-->
	<div class="sidebar ml-4 mt-1">
    	<div class="cart__mainbtns mb-1">
     		<button type="button" class="cart__bigorderbtn left" onclick="window.location.href='<%=ctxPath%>/digitalmailwrite.gw'">메일 쓰기</button>
 		</div>
       	<div class="sidebarOption opt">
			<span class="material-icons-outlined">mail_outline</span>
			<a href="<%= ctxPath %>/digitalmail.gw" class="menu_name">받은메일함</a>
        </div>
        <div class="sidebarOption opt" style="vertical-align: center;">
			<span class="material-icons-outlined">forward_to_inbox</span>
            <a class="menu_name" href='<%= ctxPath %>/digitalmail.gw?type=fk_sender_email'>보낸메일함</a>
        </div>
        <div class="sidebarOption opt">
			<span class="material-icons-outlined">note_add</span>
			<a href="<%= ctxPath %>/emailaddstoplist.gw" class="menu_name">임시보관함</a>
		</div>
		<div class="sidebarOption opt">
			<span class="material-icons-outlined">mark_email_unread</span>
			<a class="menu_name" href='<%= ctxPath %>/digitalmail.gw?type=noread'>안읽은메일함</a>
        </div>
		<div class="sidebarOption opt">
			<span class="material-icons-outlined" style="color: orange;"> priority_high </span> 
			<a class="menu_name" href='<%= ctxPath %>/digitalmail.gw?type=impt'>중요메일함</a>
		</div>
		<div class="sidebarOption opt">
			<span class="material-icons-outlined" style="color: red;"> favorite </span> 
			<a class="menu_name" href='<%= ctxPath %>/digitalmail.gw?type=fav'>즐겨찾기</a>
		</div>
		<div class="sidebarOption opt">
			<span class="material-icons-outlined"> delete </span> 
			<a class="menu_name" href='<%= ctxPath %>/digitalmail.gw?type=del'>휴지통</a>
		</div>
		<div class="sidebarOption more">
			<span class="material-icons-outlined"> expand_more </span> 
			<span class="menu_name">더보기</span>
		</div>
		<div class="more_memu">
			<div class="sidebarOption opt">
				<span class="material-icons-outlined">edit_note</span>
	            <a class="menu_name" href='<%= ctxPath %>/digitalmail.gw?type=me'>내게쓴메일함</a>
			</div>
			<div class="sidebarOption opt">
				<span class="material-icons-outlined">sell</span>
				<a class="menu_name" href='<%= ctxPath %>/digitalmail.gw?type=sell'>카테고리메일함</a>
			</div>
			<div class="sidebarOption opt">
				<span class="material-icons-outlined">drafts</span>
				<a class="menu_name" href='<%= ctxPath %>/digitalmail.gw?type=read'>읽은메일함</a>
			</div>
			<div class="sidebarOption opt">
				<span class="material-icons-outlined">face</span> 
	            <a class="menu_name" href='<%= ctxPath %>/digitalmail.gw?type=team'>우리팀메일함</a>
			</div>
			<div class="sidebarOption opt">
				<span class="material-icons-outlined">face</span> 
	            <a class="menu_name" href='<%= ctxPath %>/digitalmail.gw?type=dept'>우리부서메일함</a>
			</div>
			<div class="sidebarOption opt">
				<span class="material-icons-outlined">delete</span> 
	            <a class="menu_name" href='<%= ctxPath %>/digitalmail.gw?type=senddel'>보낸메일휴지통</a>
			</div>
			<div class="sidebarOption opt">
				<span class="material-icons-outlined">date_range</span> 
	            <a class="menu_name" href='<%= ctxPath %>/digitalmail.gw?type=time'>예약예정메일</a>
			</div>
	        <div class="sidebarOption reset">
				<span class="material-icons-outlined">expand_less</span> 
				<span class="menu_name">접기</span>
			</div>
		</div>
	</div>
	<!--사이드바 끝-->
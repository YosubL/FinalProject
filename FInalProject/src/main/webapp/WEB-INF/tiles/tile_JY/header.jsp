<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- ===== #28. tile 중 header 페이지 만들기 ===== --%>
<%
	String ctxPath = request.getContextPath();
%>
<script type="text/javascript">
$(document).ready(function(){
	
	loopshowNowTime();
	
});

function showNowTime() {
    
	const now = new Date();
 
	let month = now.getMonth() + 1;
    if(month < 10) {
       month = "0"+month;
    }
    
    let date = now.getDate();
    if(date < 10) {
       date = "0"+date;
    }
    
    let strNow = now.getFullYear() + "-" + month + "-" + date;
    
    let hour = "";
     if(now.getHours() < 10) {
         hour = "0"+now.getHours();
     } 
     else {
        hour = now.getHours();
     }
    
     
    let minute = "";
    if(now.getMinutes() < 10) {
       minute = "0"+now.getMinutes();
    } else {
       minute = now.getMinutes();
    }
    
    let second = "";
    if(now.getSeconds() < 10) {
       second = "0"+now.getSeconds();
    } else {
       second = now.getSeconds();
    }
    
    strNow += " "+hour + ":" + minute + ":" + second;
    
    $("span#clock").html(strNow);
 
 }// end of function showNowTime() -----------------------------
 
 function loopshowNowTime() {
     showNowTime();
     
     const timejugi = 1000;   // 시간을 1초 마다 자동 갱신하려고.
     
     setTimeout(function() {
                 loopshowNowTime();   
              }, timejugi);
     
  }// end of loopshowNowTime() --------------------------
 
</script>
     

    <div class="d-flex justify-content-between align-items-center w-10">
        <div style="font-size: 8pt;">
            <span>현재시각 : <span id="clock"></span></span>
        </div>
        <%-- === #49. 로그인이 성공되어지면 로그인되어진 사용자의 이메일 주소를 출력하기 === --%>
        <c:if test="${not empty sessionScope.loginuser}">
            <div style="font-size: 8pt;">
               <i class="fa-solid fa-circle-user"></i> <span style="color: navy; font-weight: bold;">${sessionScope.loginuser.name}</span> 님<br>로그인중..
			<a class="btn btn-danger btn-sm" href="<%=ctxPath%>/logout.gw"></a> 
             </div>
        </c:if>
    </div>

<%-- 상단 네비게이션 끝 --%>
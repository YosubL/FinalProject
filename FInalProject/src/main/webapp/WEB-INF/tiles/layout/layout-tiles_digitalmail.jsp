<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>

<%
   String ctxPath = request.getContextPath();
%>  
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>전자메일</title>

	<!-- Required meta tags -->
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"> 
	
	<%-- Bootstrap CSS --%>
	<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/resources/bootstrap-4.6.2-dist/css/bootstrap.min.css" > 
	<%-- Font Awesome 6 Icons --%>
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
	
	<%-- Optional JavaScript --%>
	<script type="text/javascript" src="<%= ctxPath%>/resources/js/jquery-3.7.1.min.js"></script>
	<script type="text/javascript" src="<%= ctxPath%>/resources/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" ></script> 
	<script type="text/javascript" src="<%= ctxPath%>/resources/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script>
	<%-- 스피너 / datapicker를 사용하기 위한 jQueryUI CSS 및 JS --%>
	<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/resources/jquery-ui-1.13.1.custom/jquery-ui.min.css" />
	<script type="text/javascript" src="<%= ctxPath%>/resources/jquery-ui-1.13.1.custom/jquery-ui.min.js"></script>
	
	<%-- ajax로 파일을 업로드 할때 가장 널리 사용하는 방법 ajaxForm 이용 --%>
	<script type="text/javascript" src="<%= ctxPath%>/resources/js/jquery.form.min.js"></script>
	
	<%-- 구글 아이콘 --%>
	<link href="https://fonts.googleapis.com/icon?family=Material+Icons"
      rel="stylesheet">
	<link href="https://fonts.googleapis.com/icon?family=Material+Icons+Outlined"
      rel="stylesheet">
      
    <%-- 전자메일 CSS --%>
    <link rel="stylesheet" href="<%= ctxPath%>/resources/css/digitalmail.css"> 
	
	<script>
	    // 1초 후에 실행되는 함수
	    setTimeout(function() {
	        // 해당 요소들을 찾아 제거
	        var loaderArea = document.querySelector('.loader-area');
	        var loader = document.querySelector('.loader');
	        if (loaderArea) {
	            loaderArea.remove();
	        }
	    }, 2000); // 2000밀리초 = 1초
	</script>
	
	<style type="text/css">
	
		.loader-area div {
      		width: 60px;
      		height: 60px;
      		border: 4px solid #fff;
      		border-radius: 50%;
      		border-top: 4px solid #1876f3;
      		animation: rot 1s ease-in infinite;
    	}
		@keyframes rot {
      		to {
        		transform: rotate(360deg);
      		}
    	}
		
	</style>
	
	
</head>
<body>  

   	 <div class="loader-area fixed-top bg-white d-flex align-items-center justify-content-center" style="width: 100vw; height: 100vh;">
       	<div></div>
   	 </div>
	 <div class="header">
	 	<tiles:insertAttribute name="header" />
	 </div>	
	 <div class="main_body">
	 	<tiles:insertAttribute name="sideinfo" />
	 	<div class="emailList">
         <tiles:insertAttribute name="content" />
        </div>
	 </div>

</body>
</html>
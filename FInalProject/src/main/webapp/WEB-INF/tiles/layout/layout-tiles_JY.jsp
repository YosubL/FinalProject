<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    <%-- === #24. tiles 를 사용하는 레이아웃 Final_MTS 페이지 만들기 === --%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>

<%
   String ctxPath = request.getContextPath();
%>  
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Final_MTS</title>

	<!-- Required meta tags -->
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"> 
	
	<%-- Bootstrap CSS --%>
	<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/resources/bootstrap-4.6.2-dist/css/bootstrap.min.css" > 
	
	<%-- Font Awesome 6 Icons --%>
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
	
	<%-- 직접 만든 CSS 2 --%>
	<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/resources/css/style.css" />
	
	<%-- Optional JavaScript --%>
	<script type="text/javascript" src="<%= ctxPath%>/resources/js/jquery-3.7.1.min.js"></script>
	<script type="text/javascript" src="<%= ctxPath%>/resources/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" ></script> 
	<script type="text/javascript" src="<%= ctxPath%>/resources/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script>

	<%-- 스피너 / datapicker를 사용하기 위한 jQueryUI CSS 및 JS --%>
	<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/resources/jquery-ui-1.13.1.custom/jquery-ui.min.css" />
	<script type="text/javascript" src="<%= ctxPath%>/resources/jquery-ui-1.13.1.custom/jquery-ui.min.js"></script>
	
	<%-- ajax로 파일을 업로드 할때 가장 널리 사용하는 방법 ajaxForm 이용 --%>
	<script type="text/javascript" src="<%= ctxPath%>/resources/js/jquery.form.min.js"></script>
	
	
<style>
@import url("https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.6/dist/web/static/pretendard.css");

*{
	font-family: -apple-system, BlinkMacSystemFont, "Apple SD Gothic Neo", "Pretendard Variable", Pretendard, Roboto, "Noto Sans KR", "Segoe UI", "Malgun Gothic", "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", sans-serif;
}

#myContent {
	min-height: 1200px;
}

#mysideinfo	{
	position: relative;
	z-index: 1;
}

#mySide {
	position: relative;
	min-height: 1200px;
	background-color: #F9F9F9;
	padding-top: 4%;
}

#mySide a {
	color: black;
}

#mySide .navbar-nav {
	margin-left: 10%;
}

#mySide ul {
	list-style-type: none;
}

#mySide nav li {
	font-size: 12.5pt;
}

#mySide nav li li {
	font-size: 11.5pt;
}

.badge {
	vertical-align: middle;
}

.row{
	max-height: 1000px;
	overflow-y: auto;
}
</style>
	
</head>
<body>

<div id="mycontainer">

      <div id="myheader">
         <tiles:insertAttribute name="header" />
      </div>
      
      <div id="mysideinfo">
         <tiles:insertAttribute name="sideinfo" />
      </div>
      
      <div class="row">
		 <div class="col col-2 container" id="mySide">
			<tiles:insertAttribute name="side" />
		 </div>
		 <div class="col m-5 pl-0 pr-4" id="myContent">
			<tiles:insertAttribute name="content" />
		 </div>
	  </div>
      
   </div>

</body>
</html>
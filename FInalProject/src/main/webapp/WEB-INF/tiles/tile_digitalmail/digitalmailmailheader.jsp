<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String ctxPath = request.getContextPath();
%>

  <script type="text/javascript">     	
  
  $(document).ready(function(){
	  
	  $("li.searchopt").click(function (e) {
		    
		    $("input[name='searchType']").val($(e.target).text());
		    
		    if($("input[name='searchType']").val()=="이름"){
	  			$("input[name='searchType']").val("name") 
	  		}
		    
		    if($("input[name='searchType']").val()=="제목"){
	  			$("input[name='searchType']").val("subject") 
	  		}
		    
		    if($("input[name='searchType']").val()=="직급"){
	  			$("input[name='searchType']").val("job") 
	  		}
		    
		    if($("input[name='searchType']").val()=="내용"){
		    	alert('내용은 자동완성 기능이 제공되지 않습니다. 제목 검색으로 이동합니다.');
		    	$("input[name='searchType']").val("subject") 
	  		}

	  });

      $("input:text[name='searchWord']").bind("keyup", function(e){
		  if(e.keyCode == 13){ // 엔터를 했을 경우 
			  //alert("가보자고");
			  goSearch();
		  }  
	  });
      
	  // 검색시 검색조건 및 검색어값 유지시키기
	  if(${not empty requestScope.paraMap}) {
		  $("input[name='searchType']").val("${requestScope.paraMap.searchType}");
		  $("input[name='searchWord']").val("${requestScope.paraMap.searchWord}");
	  } 
	  
	  <%-- === 검색어 입력시 자동글 완성하기 === --%>
	  $("div#displayList").hide();
	  
	  $("input[name='searchWord']").keyup(function(){
		
		  const wordLength = $(this).val().trim().length;
		  // 검색어에서 공백을 제거한 길이를 알아온다.
		  const myEmail = "${sessionScope.loginuser.email}";
		  
		  if(wordLength == 0) {
			  $("div#displayList").hide();
		  }
		  else {
			  if( $("input[name='searchType']").val() == "subject" || 
				  $("input[name='searchType']").val() == "name" ||
				  $("input[name='searchType']").val() == "job") {
			  
				  $.ajax({
					  url:"<%= ctxPath%>/emailwordSearchShow.gw",
					  type:"get",
					  data:{"searchType":$("input[name='searchType']").val(),
						  "searchWord":$("input[name='searchWord']").val(),
						  "myEmail": myEmail
					  },
				      dataType:"json",
				      success:function(json){
				      	
				    	  console.log(JSON.stringify(json));
				    	  
				    	  if(json.length > 0) {
				    		  
				    		  let v_html = ``;
				    		  
				    		  $.each(json, function(index, item){
				    			  const word = item.word;
				    			  const idx = word.toLowerCase().indexOf($("input[name='searchWord']").val().toLowerCase()); 
		
				    			  const len = $("input[name='searchWord']").val().length; 

				    		      const result = word.substring(0, idx) + "<span style='color:green;'>"+word.substring(idx, idx+len)+"</span>" + word.substring(idx+len); 
				    			  
				    		      v_html += `<span style='cursor:pointer;' class='result'>\${result}</span><br>`; 
				    		  
				    		  });// end of $.each()----------------
				    		  
				    		  const input_width = $("input[name='searchWord']").css("width"); // 검색어 input 태그 width 값 알아오기 
				    		  
				    		  $("div#displayList").css({"width":input_width}); // 검색결과 div 의 width 크기를 검색어 입력 input 태그의 width 와 일치시키기 
				    		  
				    		  $("div#displayList").html(v_html);
				    		  $("div#displayList").show();
				    	  }
				    	  
				      },
				      error: function(request, status, error){
						alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
					  }
				  });
			  }
		  } 
		  
	  });// end of $("input[name='searchWord']").keyup(function(e){})--------- 
	  
	  
	  <%-- === #113. 검색어 입력시 자동글 완성하기 8 === --%>
	  $(document).on("click", "span.result", function(){
		  const word = $(this).text();
		  $("input[name='searchWord']").val(word); // 텍스트박스에 검색된 결과의 문자열을 입력해준다. 
		  $("div#displayList").hide(); 
		  
		  goSearch();
		 
	  });
	  
  });
  
  function goSearch() {
      const frm = document.searchFrm;
	  frm.method = "get";
	  frm.action = "<%= ctxPath%>/digitalmail.gw";
	  frm.submit();
  }// end of function goSearch()----------------
  
  </script>


	<!-- 왼쪽-->
	<div class="header_left ml-4">
		<img class="imglogo" src="<%= ctxPath%>/resources/img/logo.png" alt="logo">
	</div>

	<!-- 중앙-->
	<div class="header_middle">
		<span class="material-icons">search</span>
			<input type="text" name="searchWord" id="searchWord" placeholder="Search email">
			<input type="text" style="display: none;"/> <%-- form 태그내에 input 태그가 오로지 1개 뿐일경우에는 엔터를 했을 경우 검색이 되어지므로 이것을 방지하고자 만든것이다. --%> 
		<div id="displayList" style="display: block; max-height: 80px; overflow-y: auto;">
			<%-- 메일 자동완성 --%>
		</div>
		<div class="dropdown">
	    	<button type="button" class="dropdown-toggle" id="searchDropdown" data-toggle="dropdown" style="cursor: pointer;">
	            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	        </button>
			<ul class="dropdown-menu text-center">
		    	<li class="searchopt"><span class="dropdown-item">이름</span></li>
		    	<li class="searchopt"><span class="dropdown-item">제목</span></li>
		    	<li class="searchopt"><span class="dropdown-item">내용</span></li>
		    	<li class="searchopt"><span class="dropdown-item">직급</span></li>
			</ul>
		</div>
	</div>
	
	<form name="searchFrm">
		<input type="hidden" name="searchWord"/>
		<input type="hidden" name="searchType" value="subject"/>
	</form>
	
	<!-- 오른쪽-->
	<div class="mr-4 textbox" style="display: flex;">
	
		<div class="icon_set mr-3">
			<a href="https://mail.naver.com"><span class="material-icons-outlined icon_img" style="font-size: 28pt;">forward_to_inbox</span></a>
			<span class="icon_text">외부메일</span>
		</div>

		<div class="icon_set mr-3">
			<span class="material-icons icon_img" style="font-size: 28pt;">account_circle</span>
			<span class="icon_text">${sessionScope.loginuser.name} 님</span>
		</div>

		<div class="icon_set mr-3">
			<a href="<%= ctxPath%>/index.gw"><span class="material-icons-outlined icon_img" style="font-size: 28pt;">logout</span>
			<span class="icon_text">로그아웃</span></a>
		</div>

	</div>
	
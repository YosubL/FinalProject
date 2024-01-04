<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
	String ctxPath = request.getContextPath();
%>

<style type="text/css">
    
	
	#mycontent > div > div > a{
	position:relative;
	bottom:60px;
	width:100px;
	height:40px;
	text-align: center;
	font-size:20px;
	margin-left:880px;
	}
    
    th {background-color: #ddd}
    
    .subjectStyle {font-weight: bold;
                   color: navy;
                   cursor: pointer; }
                   
    a {text-decoration: none !important;} /* 페이지바의 a 태그에 밑줄 없애기 */
    
    .circle {
        margin: 0 auto;
        width: 100px;
        height: 100px;
        border: 15px solid rgb(163, 151, 198);
        border-radius: 50%;
    }
    
    .wrapper {
        margin: 0 auto;
        padding: 30px;
        max-width: 1170px;
    }
    
        /* 전체 스타일 코드 */
    body {
        font-family: Arial, sans-serif;
        background-color: #f4f4f4;
        margin: 0;
        padding: 0;
     }

      h2 {
          text-align: center;
          margin: 50px 0;
      }
		/* 폼 스타일 변경 */
	form[name="searchFrm"] 
	{
	    display: flex;
	    justify-content: center;
	    align-items: center;
	    margin-bottom: 20px;
	    background-color: #ffffff;
	    padding: 15px;
	    border-radius: 8px;
	    box-shadow: 0 8px 12px 0 rgba(0, 0, 0, 0.1);
	}
		
	/* 입력 필드 및 버튼 스타일 변경 */
	select,
	input[type="text"],
	button##mycontent > div > div > form > button{
	    height: 30px;
	    margin-right: 40px; /* 여기서 마진값을 조절하여 간격을 조정할 수 있습니다. */
	    border-radius: 5px;
	    border: 1px solid #ddd;
	    padding: 0 15px;
	    transition: border-color 0.3s ease-in-out, box-shadow 0.3s ease-in-out;
	}
		
	/* 검색 및 초기화 버튼 스타일 변경 */
	button#btnSearch,
	button#btnReset {
	    color: white;
	    border: none;
	    cursor: pointer;
	    padding: 0 15px;
	}
	
	/* 검색 버튼 호버 효과 */
	button#btnSearch:hover,
	button#btnReset:hover {
	    opacity: 0.8;
	}

       /* 테이블 스타일 변경 */
       table {
           width: 100%;
           border-collapse: collapse;
           margin-bottom: 30px;
           border-radius: 8px;
           overflow: hidden;
           box-shadow: 0 8px 12px 0 rgba(0, 0, 0, 0.1);
       }

       /* 테이블 헤더 스타일 변경 */
       table th {
           background-color: #ffffff;
           text-align: center;
           padding: 12px;
           font-weight: bold;
       }

       /* 테이블 셀 스타일 변경 */
       table td {
           border: solid 1px #ddd;
           padding: 8px;
           text-align: center;
       }

       /* 테이블 로우 스타일 변경 */
       tr {
           cursor: pointer;
           transition: background-color 0.3s ease;
       }

       /* 테이블 로우 호버 효과 */
       tr:hover {
           background-color: #f9f9f9;
       }

       /* 페이지 바 스타일 */
       div[align="center"] {
           border: solid 0px gray;
           width: 80%;
           margin: 30px auto;
       }

       /* 이름 디자인 */
       div#name {
           text-align: center;
           margin-bottom: 50px;
       }
	        
	 /* 모달 내의 테이블 스타일링 */
	.modal-body table {
	    width: 100%;
	    border-collapse: collapse;
	    margin-bottom: 20px;
	}
	
	/* 테이블 헤더 스타일 */
	.modal-body th {
	    background-color: #f2f2f2;
	    border: 1px solid #ddd;
	    padding: 8px;
	    text-align: left;
	}
	
	/* 테이블 데이터 셀 스타일 */
	.modal-body td {
	    border: 1px solid #ddd;
	    padding: 8px;
	    text-align: left;
	}
	
	/* 테이블 둥근 테두리와 그림자 효과 */
	.modal-body table {
	    border-radius: 8px;
	    box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
	}
    
    #displayList{
	position:relative;
	left:213px;
	bottom:35px;
	background-color:#eef8ef;
	}
    
    #mycontent > div:nth-child(3) > div > table > thead > tr{
	border-top:solid 3px;
	}


	#mycontent > div:nth-child(3) > div > table > tbody > tr:nth-child(10){
	border-bottom:solid 3px;
	}

	#mycontent > div:nth-child(3) > div > form > input[type=text]:nth-child(2){
	border:none;
	border-bottom:solid 2px;
	}
    
	#mycontent > div:nth-child(3) > div > form > select{
	height:30px;
	margin-right:14px;
	}

	#mycontent > div:nth-child(3) > div > form > button{
	margin-left:14px;
	width:100px;
	background-color:#ababab;
	color:black;
	height:30px;
	}
	
	#mycontent > div:nth-child(3) > div > a{
	position:relative;
	left:387px;
	bottom:70px;
	background-color:#aaaaaa;
	width:100pt;
	}
	
    
</style>

<script type="text/javascript">

	$(document).ready(function(){
	  
		$("span.subject").bind("mouseover", function(e){
			$(e.target).addClass("subjectStyle");
	    });
	  
	    $("span.subject").bind("mouseout", function(e){
		    $(e.target).removeClass("subjectStyle");
	    });
	  
	    $("input:text[name='searchWord']").bind("keyup", function(e){
			if(e.keyCode == 13){ // 엔터를 했을 경우 
				goSearch();
		    }  
	    });
	  
	  
	    // 검색시 검색조건 및 검색어값 유지시키기
		if(${not empty requestScope.paraMap}) {
			$("select[name='searchType']").val("${requestScope.paraMap.searchType}");
		    $("input[name='searchWord']").val("${requestScope.paraMap.searchWord}");
	    } 
	  
	    $("div#displayList").hide();
	    
	    //===== 검색어 입력시 자동글 완성하기 시작 =========
	    $("input[name='searchWord']").keyup(function(){
		
	    	const wordLength = $(this).val().trim().length;
		    
			if(wordLength == 0) {
		    	$("div#displayList").hide();
			}
		  
		  	else{
				if( $("select[name='searchType']").val() == "subject" || 
				    $("select[name='searchType']").val() == "name" ) {
			  
				    $.ajax({
					    url:"<%= ctxPath%>/notice_wordSearchShow.gw",
						type:"get",
						data:{"searchType":$("select[name='searchType']").val()
							 ,"searchWord":$("input[name='searchWord']").val()},
					    dataType:"json",
					    success:function(json){
					
				    	    if(json.length > 0) {
				    		  
				    		    let v_html = ``;
				    		  
				    		    $.each(json, function(index, item){
					    	        const word = item.word;
					    		    const idx = word.toLowerCase().indexOf($("input[name='searchWord']").val().toLowerCase()); 
					    		    const len = $("input[name='searchWord']").val().length; 
					    		    const result = word.substring(0, idx) + "<span style='color:purple;'>"+word.substring(idx, idx+len)+"</span>" + word.substring(idx+len); 
				    			  
				    		        v_html += `<span style='cursor:pointer;' class='result'>\${result}</span><br>`; 
				    		  
				    		    });// end of $.each()----------------
				    		  
				              const input_width = $("input[name='searchWord']").css("width"); 
				    		  
				    		  $("div#displayList").css({"width":input_width}); 
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
	       	  
	});// end of $("input[name='searchWord']").keyup(function(){ ----------------
	////===== 검색어 입력시 자동글 완성하기 끝 =========   
		
    	$(document).on("click", "span.result", function(){
		    const word = $(this).text();
		    $("input[name='searchWord']").val(word); // 텍스트박스에 검색된 결과의 문자열을 입력해준다. 
			$("div#displayList").hide();
			goSearch();
		}); // end of $(document).on("click", "span.result", function(){----------------

    });// end of $(document).ready(function(){})-----------

  
    // Function Declaration
    // ===== 글의 상세 정보를 보기 위한 함수시작  ==========
	function goView(seq) {
	
		const goBackURL = "${requestScope.goBackURL}";
		//    goBackURL = "/list.action?searchType=name&searchWord=문새한&currentShowPageNo=9"; 
		const frm = document.goViewFrm;
		frm.seq.value = seq;
		frm.goBackURL.value = goBackURL;
	 
		 if(${not empty requestScope.paraMap}){ // 검색조건이 있을 경우 
			 frm.searchType.value = "${requestScope.paraMap.searchType}";
			 frm.searchWord.value = "${requestScope.paraMap.searchWord}";
		  } 
	 
	 frm.method = "post"; 
	 frm.action = "<%= ctxPath%>/notice_view_2.gw";
	 frm.submit();
	 
    }// end of function goView(seq)---------------
    //===== 글의 상세 정보를 보기 위한 함수 끝  ==========
  
  
  
  //검색한 페이지를 보여주기 
  function goSearch(){
     const frm = document.searchFrm;
   	 frm.method = "get";
   	 frm.action = "<%= ctxPath%>/noticeboard.gw";
   	 frm.submit();
  }// end of function goSearch()----------------
  
</script>

<div style="display: flex;">
<div style="margin: auto; padding-left: 3%;">
<h2 style="margin-bottom: 30px;">공지사항 목록 </h2> 
	
	<table style="width: 1400px" class="table table-bordered">
		<thead>   
		    <tr>
				<th style="width: 70px;  text-align: center;">글번호</th>
				<th style="width: 360px; text-align: center;">제목</th>
				<th style="width: 70px;  text-align: center;">성명</th>
				<th style="width: 70px;  text-align: center;">부서명</th>
				<th style="width: 150px; text-align: center;">날짜</th>
				<th style="width: 70px;  text-align: center;">조회수</th>
		    </tr>
		 </thead>

		 <tbody>
		    <c:if test="${not empty requestScope.boardList}">
		         <c:forEach var="boardvo" items="${requestScope.boardList}"> 
		             <tr>
			             <td align="center">${boardvo.seq}</td>
			             <td align="left">
			                <%-- === 공지사항 게시판 시작 === --%>
			                <%-- 첨부파일이 없는 경우 시작 --%>
			             	<c:if test="${empty boardvo.file_Name}">
							    <span class="subject" onclick="goView('${boardvo.seq}')">${boardvo.subject}</span>  
						    </c:if>  
		                	<%-- 첨부파일이 없는 경우 끝 --%>
		                    
		                	<%-- 첨부파일이 있는 경우 시작 --%>
		                    <c:if test="${not empty boardvo.file_Name}">
								<span class="subject" onclick="goView('${boardvo.seq}')">${boardvo.subject}<span style="vertical-align: super;"></span></span>&nbsp;<img src="<%= ctxPath%>/resources/images/disk.gif" />             
							</c:if>   
		                    <%-- 첨부파일이 있는 경우 끝 --%>
		                    <%-- == 공지사항 게시판  끝 == --%>
						</td>
						<td align="center">${boardvo.name}</td>
						<td align="center">${boardvo.department_name}</td>
						<td align="center">${boardvo.reg_Date}</td>
						<td align="center">${boardvo.read_Count}</td>
						
		             
					 </tr>
				 </c:forEach>
			</c:if>
		    
			<c:if test="${empty requestScope.boardList}">
				<tr>
					<td colspan="5">데이터가 없습니다</td>
				</tr>
			</c:if>
		</tbody>
	</table>
    
	<%-- === 페이지바 보여주기 === --%>
	<div align="center" style="border: solid 0px gray; width: 80%; margin: 30px auto;"> 
		${requestScope.pageBar}
    </div>
    <c:if test="${sessionScope.loginuser.gradelevel >= 5}">
   			<a type="button" class="btn btn-secondary btn-sm" href="<%= ctxPath %>/noticeadd.gw">글쓰기</a>
	</c:if>  
    
    <%-- ===== 글검색 폼 추가하기 : 글제목, 글쓴이로 검색을 하도록 한다. ===== --%>
    <form name="searchFrm">
		<select name="searchType">
			<option value="subject">글제목</option>
			<option value="content">글내용</option>
			<option value="subject_content">글제목+글내용</option>
			<option value="name">글쓴이</option>
		</select>
		<input type="text" name="searchWord" size="40" autocomplete="off" /> 
		<input type="text" style="display: none;"/> <%-- form 태그내에 input 태그가 오로지 1개 뿐일경우에는 엔터를 했을 경우 검색이 되어지므로 이것을 방지하고자 만든것이다. --%> 
		<button type="button" class="btn btn-secondary btn-sm" onclick="goSearch()"><i class="fa-solid fa-magnifying-glass"></i></button>
		
	</form> 
	
	<%-- === 검색어 입력시 자동글 완성하기 === --%>  
    <div id="displayList" style="border:solid 1px gray; border-top:0px; height:100px; margin-top:-1px; margin-bottom:30px; margin-left:322px; overflow:auto;">
	</div>
</div>
</div>


<%-- // ===== 페이징 처리되어진 후 특정 글제목을 클릭하여 상세내용을 본 이후
	 //       사용자가 "검색된결과목록보기" 버튼을 클릭했을때 돌아갈 페이지를 알려주기 위해
	 //       현재 페이지 주소를 뷰단으로 넘겨준다.  --%>
	 <div class="text-center">
		<form name="goViewFrm">
			<input type="hidden" name="seq" />
			<input type="hidden" name="goBackURL" />
			<input type="hidden" name="searchType" />
			<input type="hidden" name="searchWord" />
		</form>
	</div>


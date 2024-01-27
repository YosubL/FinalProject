<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<% String ctxPath = request.getContextPath(); %>

<style>
	img#profile {
		border-radius: 50%;
		width: 35px;
	}
	
	
	button { border-style: none;	}
	
	textarea {
	    height: 30px;
	    overflow-y: hidden;
	    resize: none;
	}
	
	a{ color:black;	}
	
	span.move  {cursor: pointer; color: navy;}
	.moveColor {color: #660029; font-weight: bold; background-color: #ffffe6;}
    a {text-decoration: none !important;}
    
   body,h1,h2,h3,h4,h5,h6 {font-family: Verdana, sans-serif;}
	

	#mycontent > div > div{
		position:relative;
		right:200px;
	}
	
	#mycontent > div > div > p:nth-child(4){
		text-align:left;
	}
	
	#mycontent > div > div > span{
		margin-right:1240px;
    }
	
	#mycontent > div > div > div:nth-child(15) > div,
	#mycontent > div > div > div:nth-child(14) > div{
		text-align:left;
	}
	
	#mycontent > div > div > div:nth-child(13) > div,
	#mycontent > div > div > div:nth-child(12) > div{
		text-align:left;	
	}


	#blank{
		height:15px;
	}

	#showList{	
	   font-size: 17px;
	   color: #ffffff;
	   font-weight: 700;
	   letter-spacing: 2px;
	   text-transform: uppercase;
	   border: none;
	   padding: 10px 15px;
	   border-radius: 2px;
	   background-color:#4F6F52;
	}
	
	#del_button{
	   font-size: 17px;
	   color: #ffffff;
	   font-weight: 700;
	   letter-spacing: 2px;
	   text-transform: uppercase;
	   border: none;
	   padding: 10px 15px;
	   border-radius: 2px;
	   background-color:#739072;
	}
	
	
	#edit_button{
	   font-size:17px;
	   color: #ffffff;
	   font-weight: 700;
	   letter-spacing: 2px;
	   text-transform: uppercase;
	   border: none;
	   padding: 10px 15px;
	   border-radius: 2px;
	   background-color:#86A789;
	}
	
</style>

<script type="text/javascript">
  
$(document).ready(function(){
	
    $("span.move").hover(function(){
		$(this).addClass("moveColor");
	},function(){
		$(this).removeClass("moveColor");
	});

});// end of $(document).ready(function(){})-------------


	   
	//====이전 페이지나 다음페이지로 넘어가기 시작====
    function goView(seq) {
		const goBackURL = "${requestScope.goBackURL}";

		const frm = document.goViewFrm;
		frm.seq.value = seq;
		frm.goBackURL.value = goBackURL;
 
		if(${not empty requestScope.paraMap}) { // 검색조건이 있을 경우 
			frm.searchType.value = "${requestScope.paraMap.searchType}";
			frm.searchWord.value = "${requestScope.paraMap.searchWord}";
		} 
 
		frm.method = "post";
		frm.action = "<%= ctxPath%>/notice_view_2.gw";
		frm.submit();

	}// end of function goView(seq)---------------
	//====이전 페이지나 다음페이지로 넘어가기 끝====
  
		
	function goView2() {

		const goBackURL = "${requestScope.goBackURL}";
		const frm = document.goViewFrm;
	  	//frm.seq.value = input ;
		frm.goBackURL.value = goBackURL;

		frm.method = "post";
		frm.action = "<%= ctxPath%>/notice_view_2.gw";
		frm.submit();
	
    }// end of function goView2(seq)---------------
  

</script>


<div style="width: 90%;" class="text-center container">
	<div style="margin: auto; width:1600px;">
		
		<c:if test="${not empty requestScope.boardvo}">
			<div class="text-left" style="margin-top: 80px;">
				<div name="subject_name" style="font-weight: bold; font-size: 30px;">${requestScope.boardvo.subject}<br>
					<div style="margin-bottom:20px;"></div>
				      	<div>
						  <span style="font-size: 15.5px; font-weight:bold; margin-bottom: 10px;">작성자 &nbsp; ${requestScope.boardvo.name}</span>
					      <span style="font-size: 15.5px; margin-bottom: 10px;"><i class="far fa-eye mx-2"></i>${requestScope.boardvo.read_Count}</span>
					      <span style="font-size: 15.5px; margin-bottom: 10px;"><i class="far fa-clock mx-2"></i> ${requestScope.boardvo.reg_Date}</span>
				    	</div>
			    	</div>
		    <hr style="border-top: solid 1.2px black">
				
			<%-- 글수정, 삭제 버튼은 작성자만 보임 --%>		
	
			<!-- 글 내용 -->
			</div>
			<div style="text-align:left;"><p>${requestScope.boardvo.content}</p></div>
			
			<div style="height:220px;"></div>
			</c:if>  		
			<!-- 첨부파일 -->		
			<c:if test="${requestScope.boardvo.attachfile == 1}">
				<div style='margin-top: 30px; margin-right:20px;' class='text-small text-right'>
					<span>첨부파일: </span>
						<c:if test="${sessionScope.loginuser != null}">
							<a href="<%= ctxPath%>/download.gw?seq=${requestScope.boardvo.seq}">${requestScope.fileboardvo.orgFilename}</a>  
						</c:if>
						<c:if test="${sessionScope.loginuser == null}">
							${requestScope.fileboardvo.orgFilename}
						</c:if>
						<c:forEach items="${fileList}" var="file" varStatus="sts">
							<a href="<%= ctxPath%>/notice_download.gw?fileno=${file.fileno}">${file.orgFilename}</a>
							<c:if test="${sts.count != fn:length(fileList) }">,</c:if>
						</c:forEach>
					<div id="blank"> </div>
				</div>
				</c:if> 
				<%-- 버튼 모음 시작 --%>
				<div style="text-align: right;">
						<button type="button" id="showList" class="btn btn-secondary btn-sm mr-3" onclick="javascript:location.href='<%= ctxPath%>${requestScope.goBackURL}'"><i class="fa-solid fa-list"></i>&nbsp;목록 보기</button>

					
					<c:if test="${not empty sessionScope.loginuser && (sessionScope.loginuser.employee_id == requestScope.boardvo.fk_emp_id or sessionScope.loginuser.gradelevel == 10)}">
						  <button type="button" class="btn btn-danger btn-sm mr-3" id = "del_button" onclick="javascript:location.href='<%= ctxPath%>/notice_del.gw?seq=${requestScope.boardvo.seq}'"><i class="fa-solid fa-trash"></i>&nbsp;글 삭제하기</button>	
					</c:if> 

					<%-- 글수정, 삭제 버튼은 작성자만 보임 --%>	
					<c:if test="${not empty sessionScope.loginuser && sessionScope.loginuser.employee_id == requestScope.boardvo.fk_emp_id}">
						<button type="button" id = "edit_button" class="btn btn-success btn-sm mr-3" onclick="javascript:location.href='<%= ctxPath%>/notice_edit.gw?seq=${requestScope.boardvo.seq}'"><i class="fa-solid fa-wrench"></i>&nbsp;글 수정하기</button>
					</c:if>
				</div>
				<%-- 버튼 모음 끝 --%>

				<c:if test="${empty requestScope.boardvo}">
					<div style="padding: 20px 0; font-size: 16pt; color: red;" >존재하지 않습니다</div> 
				</c:if>
									
			
		
		    <hr style="border-top: solid 1.2px black">
		    	<div>
		    		<div style="margin-bottom: 1%; text-align:left;"><i style='vertical-align: bottom;' class="fas fa-sort-up"></i> 다음글제목&nbsp;&nbsp;
		    		<span class="move" onclick="goView('${requestScope.boardvo.nextseq}')">${requestScope.boardvo.nextsubject}</span></div>
		    	</div>
		    	<div>
		    		<div style="margin-bottom: 1%; text-align:left;"><i style='vertical-align: top;' class="fas fa-sort-down"></i> 이전글제목&nbsp;&nbsp;
		    		<span class="move" onclick="goView('${requestScope.boardvo.previousseq}')">${requestScope.boardvo.previoussubject}</span></div>
		    	</div>
		    <hr style="border-top: solid 1.2px black">
		    
	</div>
</div>	
	

<form name="goViewFrm">
	<input type="hidden" name="seq" />
	<input type="hidden" name="goBackURL" />
	<input type="hidden" name="searchType" />
	<input type="hidden" name="searchWord" />
</form>	
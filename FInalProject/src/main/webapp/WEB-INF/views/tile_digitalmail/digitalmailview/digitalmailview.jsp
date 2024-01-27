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
          /*
          $('div.section').click(function() {
		      alert('섹션 클릭됨!');
              // 기존에 선택된 섹션들에서 'section_selected' 클래스 제거
              $('div.section').removeClass('section_selected');
			  // 현재 클릭된 섹션에 'section_selected' 클래스 추가
              $(this).addClass('section_selected');
	      });
          */          
	   	  // 글쓰기 버튼
	   	  $('button#replyWrite').click(function(){
	   		  alert('확인 요청!');
	 	     const frm = document.replyWriteFrm;
		     
		     frm.action = "<%= ctxPath%>/digitalmailwrite.gw";
		     frm.method = "get";
		     frm.submit();
	   	  
	   	  });
      });
      
   // receipt_favorites update 하기
  	function receipt_favorites_update(receipt_mail_seq){
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
  	        		$("span#"+receipt_mail_seq+"fav").text("favorite");
  	        		$("span#"+receipt_mail_seq+"fav").css("color", "red");
  	        	}
  	        	else{
  	        		$("span#"+receipt_mail_seq+"fav").text("favorite_border");
  	        		$("span#"+receipt_mail_seq+"fav").css("color", "black");
  	        	}
  	        },
  	        error: function(request, status, error){
                  alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
              }
  		});
  	};
  	
 	// 메일 하나 삭제하기
  	function onedel(receipt_mail_seq){
  		$.ajax({
  			url:"<%= ctxPath%>/onedel.gw",
  			type:"post",
  			data:{"receipt_mail_seq":receipt_mail_seq,
  				"type":'${requestScope.type}'},
  			dataType:"json",
  	        success:function(json){
				if(json.n == 1){
					alert("삭제성공");
					location.href="<%=ctxPath%>/digitalmail.gw";
				}
				else{
					alert("삭제실패");
				}
          		
  	        },
  	        error: function(request, status, error){
                  alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
              }
  		});
  	};
  	
 	// 메일 하나 삭제하기
  	function timedel(send_email_seq, filename){
  		alert("filename=>"+filename);
 		$.ajax({
  			url:"<%= ctxPath%>/timedel.gw",
  			type:"post",
  			data:{"send_email_seq":send_email_seq,
  				  "orgfilename":filename
  				},
  			dataType:"json",
  	        success:function(json){
				if(json.n != 0){
					alert("삭제성공");
					location.href="<%=ctxPath%>/digitalmail.gw";
				}
				else{
					alert("삭제실패");
				}
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
        		if(json.receipt_important == "1"){
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
      
      
      

      
        
        
  </script>
  
  <style type="text/css">
  	
  	div.range{
  		margin:0px auto;
  		max-width:1000px;
  	
  	}
  	
  	div.main{
  		background:#ffffff; 
  		border-radius:8px;
  	
  	}
  	
  	td.tdsize{
  		padding:20px 0; 
  		text-align:center;
  	}
  	
  	table.tablesize{
  		margin: 0 auto; 
  		width: 100%; 
  		border-collapse: collapse; 
  		background: #ffffff; 
  		border-radius: 8px;" 
  	}
  	
  	p.pline{
  		border-top:solid 4px #f9f9f9;
  		font-size:1px;
  		margin:0px auto;
  		width:100%;
  	}
  	
  	div.title{
  		font-size:16px;
  		font-weight: bold;
  		line-height:24px;
  		text-align:left;
  		color: black;"
  	}
  	
  	div.Emailinfo{
  	   display: inline-block;
   	   float: left;
  	}
  	
  	div.Emailinfotable {
   		font-size: small;
	}

	.Emailinfotable th {
	   background-color: #E0F8EB;
	   vertical-align: middle;
	   text-align: center;
	}	
	
	
	.o_span{
	     padding: 1px 5px;
	     margin: 1px 5px;
	     background-color: #E0F8EB;
	     align-items: center;
	     width: 33%;
	     text-align: center;
	     border-radius: 5px; 
	 }
	 
	 div.file_span{
	 
	 	 padding: 1px 5px;
	     margin: 1px 5px;
	     background-color: #E0F8EB;
	     align-items: center;
	     width: 45%;
	     text-align: center;
	     border-radius: 5px; 
	 
	 
	 }
	 
	 .btn_set{
	
		display: flex; 
		align-items: center; 
		border-bottom-width: 2px; 
		padding: 15px; 
		min-width: 200px; 
		color: black; 
		border-width: 0; 
		cursor: pointer;
	}
	
	
  
  </style>
  <c:if test="${requestScope.type ne 'fk_sender_email' and requestScope.type ne 'time' and requestScope.type ne 'senddel'}">
 
    
	<div class="emailList_settings">
	<!--왼쪽 세팅-->
		<div class="emailList_settingsLeft">
			<!-- 즐겨찾기 여부 -->
			<div class="icon_set mr-3">
                <c:if test="${requestScope.emailVO2.receipt_favorites==0}">
                	<span id="${emailVO2.receipt_mail_seq}fav" class="material-icons-outlined ml-2" onclick="receipt_favorites_update('${emailVO2.receipt_mail_seq}')" style="font-size: 24pt;">favorite_border</span>
                	<span class="icon_text">즐겨찾기</span>
                </c:if>
                <c:if test="${requestScope.emailVO2.receipt_favorites==1}">
                	<span id="${emailVO2.receipt_mail_seq}fav" class="material-icons-outlined ml-2" onclick="receipt_favorites_update('${emailVO2.receipt_mail_seq}')" style="color: red; font-size: 24pt;">favorite</span>
                	<span class="icon_text">즐겨찾기</span>
                </c:if>
			</div>
			<!-- 즐겨찾기 여부 -->
			<!-- 중요 여부 -->
			<div class="icon_set mr-3">
					<c:if test="${requestScope.emailVO2.receipt_important==0}">
	                	<span id="${requestScope.emailVO2.receipt_mail_seq}imp" class="material-icons-outlined" onclick="receipt_important_update('${emailVO2.receipt_mail_seq}')" style="color: black; font-size: 24pt;"> priority_high </span>
	                	<span class="icon_text">중요</span>
	                </c:if>
	                <c:if test="${requestScope.emailVO2.receipt_important==1}">
	                	<span id="${requestScope.emailVO2.receipt_mail_seq}imp" class="material-icons-outlined" onclick="receipt_important_update('${emailVO2.receipt_mail_seq}')" style="color: orange; font-size: 24pt;"> priority_high </span>
	                	<span class="icon_text">중요</span>
	                </c:if>	
			</div>
			
			<!-- 즐겨찾기 여부 -->						           
			<div class="icon_set mr-3">
				<span class="material-icons-outlined icon_img" style="font-size: 24pt;" onclick="onedel('${emailVO2.receipt_mail_seq}')">delete</span>
				<span class="icon_text">휴지통</span>
			</div>                        
		</div>
        <!--오른쪽 세팅-->
        <div class="emailList_settingsRight">
			<div class="icon_set">
				<span class="material-icons-outlined icon_img" style="font-size: 24pt;">chevron_left</span>
				<span class="icon_text">이전</span>
			</div>
			<div class="icon_set">
				<span class="material-icons-outlined icon_img" style="font-size: 24pt;">chevron_right</span>
				<span class="icon_text">다음</span>
			</div>     
		</div>
	</div>
	<!--셀렉션 세팅-->
	
	
	
	<div class="emailList_sections">
    	<div class="section section_selected show">
        	<span class="material-icons-outlined" style="font-size:24px;"> inbox </span> 
			<span class="list_name">메일보기</span>
		</div>
		<div class="ml-auto btn_set">
			<button type="button" id="replyWrite" name="replyWrite" class="replyWrite">답장하기</button>
			<form name="replyWriteFrm">
				<input type="hidden" name="sender" value="${requestScope.emailVO.fk_sender_email}">
				<!-- <input type="hidden" name="content" value="${requestScope.emailVO.email_contents}">  -->
				<input type="hidden" name="subject" value="${requestScope.emailVO.email_subject}">
				<input type="hidden" name="send_email_seq" value="${requestScope.emailVO.send_email_seq}">
			</form>
		</div>
	</div> 
	<!--셀렉션 세팅 끝-->
	
	<!--이메일 리스트-->                   
	<div class="emailList_list">
  		<div style="background-color: #f4f5f6;">
    		<div class="range">
      			<table class="tablesize">
        			<tbody>
          				<tr>
            				<td class="tdsize">
            					<div class="range main">
                				<table class="tablesize">
                  				<tbody>
                    				<tr>
										<td class="tdsize">
											<div class="range">
											<table class="tablesize">
												<tr>
					                            	<td align="center" style="padding:10px 25px;">
                                					<table>
                                  						<tbody>
															<tr>
																<td style="width:200px;"><img style="border:0; display:block; height:auto; width:100%;" alt="Logo" src="<%= ctxPath%>/resources/img/logo.png"></td>
															</tr>
                                  						</tbody>
                               						</table>
                            						</td>
                            									<%-- 상단 이미지 공간 --%>
                           						</tr>
                         					</table>
                        					</div>

                        					<div style="display:inline-block; vertical-align:top; width:100%;">
                          						<table class="tablesize" >
                          							<tr>
                            							<td class="tdsize"><p class="pline"></p></td>
                                					</tr>		
                            						<tr>
                              							<td style="padding:10px 25px;">
												            <h5 class='text-left' style="margin: 0; font-size: 20px; line-height: 40px; font-weight: 700;">메일 정보
												            <c:if test="${emailVO.category==1}">
			                									<span class="material-icons-outlined ml-2 plz${emailVO.email_receipt_read_count}" style="color: green; font-size: 12pt;">업무지시</span>
											                </c:if>
											                <c:if test="${emailVO.category==2}">
											                	<span class="material-icons-outlined ml-2 alert${emailVO.email_receipt_read_count}" style="color: red; font-size: 12pt;">긴급</span>
											                </c:if>
											                <c:if test="${emailVO.category==3}">
											                	<span class="material-icons-outlined ml-2 event${emailVO.email_receipt_read_count}" style="color: blue; font-size: 12pt;">공지사항</span>
											                </c:if>
												            </h5>
															<h5 class='text-left' style="font-size: 10px;">시간 : ${requestScope.emailVO.send_time}</h5>
														<table class='table Emailinfotable table-bordered text-left'>
															<tr>
																<th>보낸사람</th>
																<td><div class="o_span">${requestScope.emailVO.fk_sender_email}</div></td>
															</tr>
											                <tr>
											                    <th>받은사람</th>
											                    <td>
												                    <c:if test="${emailVO.individual ne '1'}"> 
													                    <div style="display: flex; flex-wrap: wrap;">
																		<c:forEach var="fk_recipient_email" items="${emailVO.fk_recipient_email_split}" varStatus="status">
																		    <div class="o_span">${fk_recipient_email}</div>
																		</c:forEach>   
																	    </div>
																	</c:if>
																	<c:if test="${emailVO.individual eq '1'}"> 
													                    <div style="display: flex; flex-wrap: wrap;">
																		    <div class="o_span">${sessionScope.loginuser.email}:${sessionScope.loginuser.name}</div> 
																	    </div>
																	</c:if>
																	
											                    </td>
										                    </tr>
															<tr>
																<th>참조자</th>
																<td>
																	<c:if test="${not empty emailVO.fk_reference_email}">
																		<div style="display: flex; flex-wrap: wrap;">
														                <c:if test="${emailVO.individual ne '1'}">   	
														                  	<c:forEach var="Fk_reference_email" items="${emailVO.fk_reference_email_split}" varStatus="status">
																				<div class="o_span">${Fk_reference_email}</div>
																			</c:forEach>
																		</c:if>
																		<c:if test="${emailVO.individual eq '1'}">   	
																			
																		</c:if>
																		</div>
																	</c:if> 
																</td>
															</tr>              
															<c:if test="${not empty emailVO.fk_hidden_reference_email}">
																<c:if test="${emailVO.individual ne '1'}">
													                <c:if test="${emailVO.individual ne '1'}">	
													                	<c:forEach var="Fk_hidden_reference_email" items="${emailVO.fk_hidden_reference_email_split}" varStatus="status">
																	    	<c:if test="${Fk_hidden_reference_email == sessionScope.loginuser.email}">
																				<tr>																																	               
														                    		<th>숨은참조자</th>
														               	    		<td><div class="o_span">${sessionScope.loginuser.email}</div></td>	
																				</tr>
																			</c:if>
																	    </c:forEach>
																	</c:if>
																</c:if>
															</c:if>
															<tr>
																<th>첨부파일</th>
																<td>
																<c:if test="${not empty emailVO.filename}">
																	<div style="display: flex; flex-wrap: wrap;">
														             	<c:forEach var="orgFileName" items="${emailVO.filename_split}" varStatus="status">
																			<div class="file_span"><a href="<%= request.getContextPath()%>/email_downloadfile.gw?send_email_seq=${requestScope.emailVO.send_email_seq}&index=${status.index}">${emailVO.filename_split[status.index]}</a>&nbsp;&nbsp;<span style="font-size: 8pt;">${emailVO.filesize_split[status.index]}</span></div>
																		 </c:forEach>
																	  </div>
																  </c:if>
																</td>
															</tr>
														</table>
														</td>
                            						</tr>		                             								<tr>
													<tr>
                              							<td class="tdsize"><p class="pline"></p></td>
                            						</tr>
                            						<tr>
								                    	<td align="left" style="padding:10px 25px;">
								                        <div style="font-size:18px;font-weight:400;line-height:24px;text-align:left;color:#000000;">
								                        	<h5 style="margin: 0; font-size: 20px; line-height: 40px; font-weight: 700;">제목:&nbsp;${requestScope.emailVO.email_subject}</h5>
								                        </div>        	
								                        </td>       	
								                    </tr>     	
								                    <tr>
                              							<td align="left" style="font-size:0px;padding:10px 25px;">
                                							<div style="font-size:18px;font-weight:400;line-height:24px;text-align:left;color:#000000;">${requestScope.emailVO.email_contents}
                                							</div>		
                              							</td>
                            						</tr>        		
                            					</table>		
                            				</div>			
								        </td>	                  
								    </tr>                  
                            	</tbody>							
							</table>	                        
						</div>		                   
						</td>						
                    </tr>						
                </tbody>						
               </table> 					
              </div>					
		</div>				
	</div>		
	</c:if>	
	
	
	<c:if test="${requestScope.type eq 'fk_sender_email' || requestScope.type eq 'time' || requestScope.type eq 'senddel'}">
	<div class="emailList_settings">
	<!--왼쪽 세팅-->
		<div class="emailList_settingsLeft">
			<c:if test="${requestScope.type eq 'fk_sender_email'}">
				<!-- 즐겨찾기 여부 -->
				<div class="icon_set mr-3">
	                
	                <c:if test="${requestScope.emailVO.sender_favorites==0}">
	                	<span id="${emailVO.send_email_seq}fav" class="material-icons-outlined ml-2" onclick="receipt_favorites_update('${emailVO.send_email_seq}')" style="font-size: 24pt;">favorite_border</span>
	                	<span class="icon_text">즐겨찾기</span>
	                </c:if>
	                <c:if test="${requestScope.emailVO.sender_favorites==1}">
	                	<span id="${emailVO.send_email_seq}fav" class="material-icons-outlined ml-2" onclick="receipt_favorites_update('${emailVO.send_email_seq}')" style="color: red; font-size: 24pt;">favorite</span>
	                	<span class="icon_text">즐겨찾기</span>
	                </c:if>
				</div>
			
				<!-- 즐겨찾기 여부 -->
				<!-- 중요 여부 -->
				<div class="icon_set mr-3">
						<c:if test="${requestScope.emailVO.sender_important==0}">
		                	<span id="${emailVO.send_email_seq}imp" class="material-icons-outlined" onclick="receipt_important_update('${emailVO.send_email_seq}')" style="color: black; font-size: 24pt;"> priority_high </span>
		                	<span class="icon_text">중요</span>
		                </c:if>
		                <c:if test="${requestScope.emailVO.sender_important==1}">
		                	<span id="${emailVO.send_email_seq}imp" class="material-icons-outlined" onclick="receipt_important_update('${emailVO.send_email_seq}')" style="color: orange; font-size: 24pt;"> priority_high </span>
		                	<span class="icon_text">중요</span>
		                </c:if>	
				</div>
			</c:if>	
			<!-- 즐겨찾기 여부 -->
			<c:if test="${requestScope.type eq 'fk_sender_email'}">						           
				<div class="icon_set mr-3">
					<span class="material-icons-outlined icon_img" style="font-size: 24pt;" onclick="onedel('${emailVO.send_email_seq}')">delete</span>
					<span class="icon_text">휴지통</span>
				</div>
			</c:if>
			<c:if test="${requestScope.type eq 'time'}">						           
				<div class="icon_set mr-3">
					<span class="material-icons-outlined icon_img" style="font-size: 24pt;" onclick="timedel('${emailVO.send_email_seq}','${emailVO.orgfilename}')">delete</span>
					<span class="icon_text">예약취소</span>
				</div>
			</c:if>  	                       
		</div>
        <!--오른쪽 세팅-->
        <div class="emailList_settingsRight">
			<div class="icon_set">
				<span class="material-icons-outlined icon_img" style="font-size: 24pt;">chevron_left</span>
				<span class="icon_text">이전</span>
			</div>
			<div class="icon_set">
				<span class="material-icons-outlined icon_img" style="font-size: 24pt;">chevron_right</span>
				<span class="icon_text">다음</span>
			</div>     
		</div>
	</div>
	<!--셀렉션 세팅-->
	
	
	
	<div class="emailList_sections">
    	<div class="section section_selected show">
        	<span class="material-icons-outlined" style="font-size:24px;"> inbox </span> 
			<span class="list_name">메일보기</span>
		</div>
		<div class="ml-auto btn_set">
			<button type="button" id="replyWrite" name="replyWrite" class="replyWrite">답장하기</button>
			<form name="replyWriteFrm">
				<input type="hidden" name="sender" value="${requestScope.emailVO.fk_sender_email}">
				<!-- <input type="hidden" name="content" value="${requestScope.emailVO.email_contents}">  -->
				<input type="hidden" name="subject" value="${requestScope.emailVO.email_subject}">
				<input type="hidden" name="send_email_seq" value="${requestScope.emailVO.send_email_seq}">
			</form>
		</div>
	</div> 
	<!--셀렉션 세팅 끝-->
	
	<!--이메일 리스트-->                   
	<div class="emailList_list">
  		<div style="background-color: #f4f5f6;">
    		<div class="range">
      			<table class="tablesize">
        			<tbody>
          				<tr>
            				<td class="tdsize">
            					<div class="range main">
                				<table class="tablesize">
                  				<tbody>
                    				<tr>
										<td class="tdsize">
											<div class="range">
											<table class="tablesize">
												<tr>
					                            	<td align="center" style="padding:10px 25px;">
                                					<table>
                                  						<tbody>
															<tr>
																<td style="width:200px;"><img style="border:0; display:block; height:auto; width:100%;" alt="Logo" src="<%= ctxPath%>/resources/img/logo.png"></td>
															</tr>
                                  						</tbody>
                               						</table>
                            						</td>
                            									<%-- 상단 이미지 공간 --%>
                           						</tr>
                         					</table>
                        					</div>

                        					<div style="display:inline-block; vertical-align:top; width:100%;">
                          						<table class="tablesize" >
                          							<tr>
                            							<td class="tdsize"><p class="pline"></p></td>
                                					</tr>		
                            						<tr>
                              							<td style="padding:10px 25px;">
												            <h5 class='text-left' style="margin: 0; font-size: 20px; line-height: 40px; font-weight: 700;">메일 정보
												            <c:if test="${emailVO.category==1}">
			                									<span class="material-icons-outlined ml-2 plz${emailVO.email_receipt_read_count}" style="color: green; font-size: 12pt;">업무지시</span>
											                </c:if>
											                <c:if test="${emailVO.category==2}">
											                	<span class="material-icons-outlined ml-2 alert${emailVO.email_receipt_read_count}" style="color: red; font-size: 12pt;">긴급</span>
											                </c:if>
											                <c:if test="${emailVO.category==3}">
											                	<span class="material-icons-outlined ml-2 event${emailVO.email_receipt_read_count}" style="color: blue; font-size: 12pt;">공지사항</span>
											                </c:if>
											                <c:if test="${emailVO.individual==1}">
											                	<span class="material-icons-outlined ml-2 event${emailVO.email_receipt_read_count}" style="color: black; font-size: 12pt;">개인별전송</span>
											                </c:if>
												            </h5>
												            <h5 class='text-left' style="font-size: 12px;">읽음여부 : ${requestScope.emailVO.email_total_read_count}명</h5>
															<h5 class='text-left' style="font-size: 12px;">시간 : ${requestScope.emailVO.send_time}</h5>
														<table class='table Emailinfotable table-bordered text-left'>
															<tr>
																<th>보낸사람</th>
																<td><div class="o_span">${requestScope.emailVO.fk_sender_email}</div></td>
															</tr>
											                <tr>
											                    <th>받은사람</th>
											                    <td>
												                    <div style="display: flex; flex-wrap: wrap;">
																	<c:forEach var="fk_recipient_email" items="${emailVO.fk_recipient_email_split}" varStatus="status">
																	    <div class="o_span">${fk_recipient_email}</div>
																	</c:forEach>   
																    </div>
											                    </td>
										                    </tr>
															<tr>
																<th>참조자</th>
																<td>
																	<c:if test="${not empty emailVO.fk_reference_email}">
																		<div style="display: flex; flex-wrap: wrap;">
														                  	<c:forEach var="Fk_reference_email" items="${emailVO.fk_reference_email_split}" varStatus="status">
																				<div class="o_span">${Fk_reference_email}</div>
																			</c:forEach>
																		</div>
																	</c:if> 
																</td>
															</tr>              
															<tr>																																	               
																<th>숨은참조자</th>
																<td>
												                	<div style="display: flex; flex-wrap: wrap;">
													                	<c:forEach var="Fk_hidden_reference_email" items="${emailVO.fk_hidden_reference_email_split}" varStatus="status">	
														               		<div class="o_span">${Fk_hidden_reference_email}</div>
																	    </c:forEach>
																    </div>
															    </td>	
															    </tr>
															
															<tr>
																<th>첨부파일</th>
																<td>
																<c:if test="${not empty emailVO.filename}">
																	<div style="display: flex; flex-wrap: wrap;">
														             	<c:forEach var="orgFileName" items="${emailVO.filename_split}" varStatus="status">
																			<div class="file_span"><a href="<%= request.getContextPath()%>/email_downloadfile.gw?send_email_seq=${requestScope.emailVO.send_email_seq}&index=${status.index}">${emailVO.filename_split[status.index]}</a>&nbsp;&nbsp;<span style="font-size: 8pt;">${emailVO.filesize_split[status.index]}</span></div>
																		 </c:forEach>
																	  </div>
																  </c:if>
																</td>
															</tr>
														</table>
														</td>
                            						</tr>		                             								<tr>
													<tr>
                              							<td class="tdsize"><p class="pline"></p></td>
                            						</tr>
                            						<tr>
								                    	<td align="left" style="padding:10px 25px;">
								                        <div style="font-size:18px;font-weight:400;line-height:24px;text-align:left;color:#000000;">
								                        	<h5 style="margin: 0; font-size: 20px; line-height: 40px; font-weight: 700;">제목:&nbsp;${requestScope.emailVO.email_subject}</h5>
								                        </div>        	
								                        </td>       	
								                    </tr>     	
								                    <tr>
                              							<td align="left" style="font-size:0px;padding:10px 25px;">
                                							<div style="font-size:18px;font-weight:400;line-height:24px;text-align:left;color:#000000;">${requestScope.emailVO.email_contents}
                                							</div>		
                              							</td>
                            						</tr>        		
                            					</table>		
                            				</div>			
								        </td>	                  
								    </tr>                  
                            	</tbody>							
							</table>	                        
						</div>		                   
						</td>						
                    </tr>						
                </tbody>						
               </table> 					
              </div>					
		</div>				
	</div>		
	</c:if>	
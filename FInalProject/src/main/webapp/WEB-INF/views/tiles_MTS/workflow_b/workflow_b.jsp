<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    String ctxPath = request.getContextPath();
%>
<style>
  
  .title {
    font-size: 32px;
    font-weight: 700;
    margin-bottom: 5px;
  }
  
  .bolder {
    color: #333;
  }
  
  .comment {
    font-size: 14px;
    margin-bottom: 20px;
  }
  
  .formbox {
    display: block;
    width: 400px;
  }
  
  .inputbody {
    font-size: 16px;
    padding: 8px 10px;
    border: 1px solid #bdc7d8;
    border-radius: 5px;
    color: #333;
    margin-bottom: 10px;
    width: 100%;
  }

  .show {
    font-size: 12px;
    color: #777;
    margin: 12px 0 12px;
  }
  
  .link {
    color: #22B4E6;
    cursor: pointer;
  }
  
  .btn_send {
    font-size: 18px;
    font-weight: 700;
    letter-spacing: 1px;
    color: #fff;
    min-width: 196px;
    padding: 7px 20px;
    text-align: center;
    border-radius: 5px;
    background: linear-gradient(#67ae55, #578843);
    box-shadow: inset 0 1px 1px #a4e388;
    border: 1px solid;
    border-color: #3b6e22 #3b6e22 #2c5115;
    margin-top: 10px;
    margin-bottom: 10px;
    text-shadow: 0 1px 2px rgba(0, 0, 0, 0.5);
    cursor: pointer;
  }
  
  
  .btn_send:hover {
    background: linear-gradient(#79bc64, #578843);
  }
  
  
  .create {
    border-top: 1px solid #a0a9c0;
    color: #666;
    font-size: 12px;
    font-weight: bold;
    margin-top: 10px;
    padding-top: 15px;
  }
  
  
  
  table {
  	border-top: solid 1.5px black;
  	border-collapse: collapse;
  	width: 100%;
  	font-size: 14px;
  }

  thead {
  	text-align: center;
  	font-weight: bold;
  	font-size: 14pt;
  }

  tbody {
	text-align: center;
    font-size: 14px;
  }

  td {
  	padding: 15px 0px;
  	border-bottom: 1px solid lightgrey;
  } 
    
    
  .delbtn {
    background-color: red;
	font-size: 10px;
	border: lightgrey solid 1px;
	padding: 7px;
  }

  thead > tr {
    color:black;
  }
  
  .max-form{
  	height: 500px;  
  }

  .overscroll {
    max-height: 350px; /* 최대 높이 설정 */
    overflow-y: auto; /* 세로 스크롤 적용 */
  }

  
</style>


<script type="text/javascript">
	let b_email_uq_click = false;
	
	$(document).ready(function(){
		
    	var t_html = "<option value='error'>부서를 먼저 선택하세요</option>";
    	$("select[name='fk_team_id']").html(t_html);
		
    	var j_html = "<option value='error'>팀을 먼저 선택하세요</option>";
        $("select[name='fk_job_id']").html(j_html);
       	       
		$("select[name='fk_department_id']").change(function(e){
       	    var department = $(this).val();
            $("input.parksw").prop("disabled", true);
        	if(department == "error") {
        		$("select[name='fk_team_id']").empty();
            	t_html = "<option value='error'>부서를 먼저 선택하세요</option>";
        		$("select[name='fk_team_id']").html(t_html);
        		$("select[name='fk_job_id']").empty();
                j_html = "<option value='error'>팀을 먼저 선택하세요</option>";
        		$("select[name='fk_job_id']").html(j_html);
        	} // end of if -------------------------------------
        	else {
				t_html = "";
		    	j_html = "<option value='error'>팀을 먼저 선택하세요</option>";
		        $("select[name='fk_job_id']").html(j_html);
 				
		        $.ajax({
					url:"<%= ctxPath%>/FinalProject/searchteam.gw",
					type:"get",
					async:false, 
					data:{"deptno":$("select[name='fk_department_id']").val()},
				    dataType:"json",
				    success:function(json){
				    // console.log(JSON.stringify(json));
					
				    if(json.length > 0) {
						t_html = "<option value='error'>부서를 선택하세요</option>"
						$.each(json, function(index, item){
							t_html += "<option value='"+item.team_id+"'>"+item.team_name+"</option>";
				    	});// end of $.each()----------------
					} // end of if -----
				    else{
				    	t_html = "<option value='error'>아직 팀이 생성되지 않았습니다.</option>"
			    	}
					
		            $("select[name='fk_team_id']").html(t_html);
		            
					$("select[name='fk_team_id']").change(function(e){
						$("input.parksw").prop("disabled", true);
		            	var team = $(this).val();
		            	// alert(team);
			            if(team == "error") {
			            	$("select[name='fk_job_id']").empty();
			            	j_html = "<option value='error'>팀을 먼저 선택하세요</option>";
			            	$("select[name='fk_job_id']").html(j_html);
			            		
			    		} // end of if -------------------------------------
	
			    		else {
							j_html = "";   
			 				$.ajax({
								url:"<%= ctxPath%>/FinalProject/searchjobs.gw",
								type:"get",
								async:false, 
								data:{"teamno":$("select[name='fk_team_id']").val()},
							    dataType:"json",
							    success:function(json){
							    console.log(JSON.stringify(json));
							    
								if(json.length > 0) {
									j_html = "<option value='error'>팀을 선택하세요</option>"
									$.each(json, function(index, item){
										j_html += "<option value='"+item.job_id+"'>"+item.job_name+"</option>";
							    	});// end of $.each()----------------
							    	
								} // end of if -----
								
					            $("select[name='fk_job_id']").html(j_html);		            
							    
					            $("select[name='fk_job_id']").change(function(e){
					            	
					            	var job = $(this).val();
					            	if(job == "error") {
					            		$("input.parksw").prop("disabled", true);
/* 							            	$("select[name='fk_job_id']").empty();
							            	j_html = "<option value='error'>팀을 먼저 선택하세요</option>";
							            	$("select[name='fk_job_id']").html(j_html); */
							            		
							    	} // end of if -------------------------------------
					            	
							    	else{
						            	$.ajax({
											url:"<%= ctxPath%>/FinalProject/emptyjob.gw",
											type:"get",
											async:false, 
											data:{"jobno":$("select[name='fk_job_id']").val()},
										    dataType:"json",
										    success:function(json){
										    
										    	if (json.flag) {
										    		alert("선택 가능합니다.");
												} 
												else {
													alert("이미 책임자가 있습니다. 다시 한번 확인하세요.");	
													$("select[name='fk_job_id']").val("error");
													$("input.parksw").prop("disabled", true);
												}
										    
										    
										    }, // end of suc --------------------------------------------------------
									         
										    error: function(request, status, error){
												alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
										  	}
									    
						 				}); // end of ajax ------------------------------------------------
					            	
							    	}
					            	
								});
								}, // end of suc --------------------------------------------------------
						         
							    error: function(request, status, error){
									alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
							  	}
						    
			 				}); // end of ajax ------------------------------------------------
			        		
			        	} // end of else --------------------
		    		
		    	
		            }); // end of $("select[name='fk_team_id']").change(function(e) ------
				    
				    }, // end of suc --------------------------------------------------------
			         
				    error: function(request, status, error){
						alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				  	}
			    
 				}); // end of ajax ------------------------------------------------
        		
        	} // end of else --------------------
        	
        });
        
		if ($("select[name='fk_job_id']").val() == 'error') {
            $("input.parksw").prop("disabled", true);
        }
		
        $("select[name='fk_job_id']").change(function(e){
        	
        	if($("select[name='fk_job_id']").val() == 'error'){
                $("input.parksw").prop("disabled", true);
        	}
        	else{
                 $("input.parksw").prop("disabled", false);
        	}

        });
        
        $("input[name='name']").blur( (e) => {
       		
       		var regExp_name = /^[가-힣]{2,6}$/;
         	var bool_name = regExp_name.test($(e.target).val());
       	    
       	    if(!bool_name){
       	    	
       	    	$("input.parksw").prop("disabled", true);  
       			$(e.target).prop("disabled", false);     		     	
       			$(e.target).val("").focus(); 
             
       		}
       		else {
                $("input.parksw").prop("disabled", false);
       			
       		}
       		
       	});
        
    	$("input[name='email']").blur( (e) => {
    		
    		var regExp_email = new RegExp(/^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i);  
			var bool = regExp_email.test($(e.target).val());	
    			
   			if(!bool) {
   				
          	    	$("input.parksw").prop("disabled", true);  
          			$(e.target).prop("disabled", false);
      				$(e.target).val("").focus(); 
   			}
   			else {
   				$("input.parksw").prop("disabled", false);

   			}
    			
    	});// 아이디가 email 인 것은 포커스를 잃어버렸을 경우(blur) 이벤트를 처리해주는 것이다.
    	
    	$("input[name='phone']").blur( (e) => {
    		
	   		var regExp_user_phone = new RegExp(/^\d{11}$/);  
	   		var bool = regExp_user_phone.test($(e.target).val());		
	   			
   			if(!bool) {
   				
   				$("input.parksw").prop("disabled", true);  
          			$(e.target).prop("disabled", false);
          			$(e.target).val("").focus(); 
   			}
   			else {
 
   				$("input.parksw").prop("disabled", false);
   			    
   			}
    			
    	});
    	
    	
    	$(".chkbox_seq").click(function(){
	        let bFlag = false;
	        $(".chkbox_seq").each(function(){
	            var Checkedbox = $(this).prop("checked");
	            if(!Checkedbox) {
	                $("#allCheckOrNone").prop("checked",false);
	                bFlag = true;
	                return false;
	             }  
	        });
	        if(!bFlag) {
	            $("#allCheckOrNone").prop("checked",true);
	        }
	        
		});
        
	});// end of $(document).ready()-------------------------------------
	
	
	// Function Declaration
	
	
	function email_uq(){
		
		
		// alert($("input[name='email']").val())
		b_email_uq_click = true;
		$.ajax({
			
			url:"<%= ctxPath%>/FinalProject/email_uq.gw",
			data:{"uq_email":$("input[name='email']").val()},  
			type:"post",  
			dataType:"json",
			success:function(json){
				
				if (json.flag) {
					// "email_uq" 속성이 true일 때 실행됩니다.
					alert("이미있는 email 입니다. 다시 한번 확인하세요.");	
					$("input[name='email']").val(""); 
					b_email_uq_click = false;
				} 
				else {
					// "email_uq" 속성이 true일 때 실행됩니다.
					alert("없는 email 입니다.");
				}
				
				
			
				
			}, error: function(request, status, error){
			       alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			   }
			
		});
		
	}
	function F5frm(){
		
		var F5frm = document.F5Frm;
		F5frm.method = "get";
		F5frm.action = "<%= ctxPath%>/workflow_b.gw";
		F5frm.submit(); 
	
	}
	
	function sendmail(){
		var frm = document.sendmailFrm;
	    
		let fk_department_id = frm.fk_department_id.value;
		let fk_team_id = frm.fk_team_id.value;
		let fk_job_id = frm.fk_job_id.value;
		
		let name = frm.name.value;
		let email = frm.email.value;
	    let phone = frm.phone.value;
	    
	    alert(fk_department_id+fk_team_id+fk_job_id+name+email+phone);
	
	    if (fk_department_id == "error" || fk_team_id == "error"|| fk_job_id == "error" || name == "" || email == "" 
	    		|| phone=="" || b_email_uq_click == false) { // 수정된 부분
	        alert("Error: Please select a valid department");
	        alert("Error: Please select a valid team");
	        alert("Error: Please select a valid job");
	        return;
	    }
	    
	    alert("굿");
	    
 		frm.method = "POST";
		frm.action = "<%= ctxPath%>/invitation_email.gw";
<%--    		frm.action = "<%= ctxPath%>/welcome_mail.gw"; --%>
        frm.submit();   

	}
	
	
	
	
	function allCheckBox() {
		   
	      var bool = $("#allCheckOrNone").is(":checked");
	      /*
	      
	      $("#allCheckOrNone").is(":checked"); 은
	             선택자 $("#allCheckOrNone") 이 체크되어지면 true를 나타내고,
	             선택자 $("#allCheckOrNone") 이 체크가 해제되어지면 false를 나타내어주는 것이다.
	      
		  */
	      
	      $(".chkbox_seq").prop("checked", bool);
	    
	}// end of function allCheckBox()------------------------- 다했음
	
	function goDel(){
		
		// alert("클릭했습니다.")
		const empidcheck = $("input:checkbox[name='empid']:checked").length;
		// alert("empidcheck = >" + empidcheck);
		
		if(empidcheck < 1) {
           alert("가입허가를 취소할 회원을 선택하세요");
           return;
        }
        else {
 
           const allCnt = $("input:checkbox[name='empid']").length;
           const gradelevel_Arr = new Array();      
           const empid_Arr = new Array();        
             
        	for(let i=0; i<allCnt; i++) {
	                
	        	if($("input:checkbox[name='empid']").eq(i).prop("checked")) {
	               
	        		empid_Arr.push($("input:checkbox[name='empid']").eq(i).val() );
	        		gradelevel_Arr.push( $("input.gradelevel").eq(i).val() );
	              
	               
	            } // end of if -----
	            
	            
	            
	           
            
        }// end of for---------------------------
        
        
       	console.log("사원번호: " + empid_Arr + " 등급: " + gradelevel_Arr);
       	const gradelevel_join = gradelevel_Arr.join();
        const empid_join = empid_Arr.join();
        
        console.log("사원번호: " + empid_join + "등급: " + gradelevel_join);
		
        const bool = confirm("정말로 삭제하시겠습니까?");
        
        if(bool) {   
            $.ajax({
            	url:"<%= ctxPath%>/FinalProject/unready_del.gw",
                type:"POST",
                data:{
                    "gradelevel_join":gradelevel_join,
                	"empid_join":empid_join
                    
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
	

</script>

<div class="row mt-5">

	<%-- 메일 전송 form --%>	
	<div class="col-6">
	<div style="width:90%; border-right: 1px solid #a0a9c0;" class="ml-5">
	
	<div class="max-form">
	<form name="sendmailFrm">    
	    <div class="title bolder mb-4">초대메일보내기 &nbsp;<i class="fa-regular fa-paper-plane"></i></div>
	    <div class="comment bolder">초대메일을 보낼 사원정보를 입력해주세요!</div>
		<div class="formbox">	  	
	    	<select name="fk_department_id" class="inputbody inlen">
                <option value="error">부서명을 선택하세요</option>
                <c:if test="${empty requestScope.department_List}">
                	<option value="error">아직 부서가 없습니다.</option>
                </c:if>
                <c:if test="${!empty requestScope.department_List}">
				    <option value="0">관리자</option>
				    <c:forEach var="departmentvo" items="${requestScope.department_List}" varStatus="status">       
                		<option value="${departmentvo.department_id}">${departmentvo.department_name}</option>
           		    </c:forEach>
                </c:if>
            </select>
	  	</div>
		<div class="formbox" id="teambox">
			<select name='fk_team_id' class='inputbody inlen'></select>
		</div>
		
		<div class="formbox" id="jobbox">
			<select name='fk_job_id' class='inputbody inlen'></select>
		</div>
		
		<div class="formbox" id="hiddenbox">
			
		</div>
		
	    <div class="formbox">
	    	<input type="text" name="name" class="inputbody inlen parksw" placeholder="이름">
	  	</div>
	  
	  	<div class="formbox">
	  		<input type="text" name="email" class="inputbody inlen parksw" placeholder="이메일">
	  		<button type="button" onclick="email_uq()">이메일중복확인</button>
	  	</div>
	  	
	  	<div class="formbox">
	  		<input type="text" name ="phone" class="inputbody inlen parksw" placeholder="전화번호">
	  	</div>
	    
	</form>
	</div>
	
	<div>
		<div class="formbox text-center mt-3">
			<button type="button" onclick="sendmail()" class="btn_send bolder">전송하기</button>
		</div>
		<form name="F5Frm">
		</form>
	</div>
	
	</div>    
	</div>
	
	<div class="col-6">
	<div style="width:90%;" class="ml-3">
	
	<div class="max-form">
	<form>    
	    <div class="title bolder mb-4">가입대기현황 &nbsp;<i class="fa-regular fa-circle-user"></i></div>
	    <div class="comment bolder">취소하려면 선택하세요 !</div>
	    
	    
	    <div class="overscroll">
        <table class="cart__list">
           <thead>
               <tr>
                   <td><input type="checkbox" id="allCheckOrNone" onclick="allCheckBox();"></td>
                   <td>이름</td>
                   <td>직급</td>
                   <td>전화번호</td> 
                   <td>email</td>
                   <td>전송일자</td>        
               </tr>
           </thead>
           <tbody>
    	   <c:if test="${not empty unreadyMember}">
	           <tr>
	               <td colspan="6" align="center">
	                   <span style="color: red; font-weight: bold;">
	               	      가입대기중인 회원이 없습니다.
	                   </span>
	               </td>   
	           </tr>
	       </c:if>  
	       <c:forEach var="unready_member" items="${requestScope.unready_member}"> 
		       <tr>
		           <td><input type="checkbox" name="empid" class="chkbox_seq" id="chkbox_seq${unready_member.employee_id}" value="${unready_member.employee_id}"/></td>
		           <td><span>${unready_member.name}</span>
		           <input type="hidden" class="gradelevel" value="${unready_member.gradelevel}"/> 
		           </td>
		           <td><span>${unready_member.job_name}</span></td>
		           <td><span>${unready_member.phone}</span></td>
		           <td><span>${unready_member.email}</span></td>
		           <td><span>${unready_member.hire_date}</span></td>
		       </tr>
		   </c:forEach>
		   </tbody>
        </table>
	    </div>
    </form>
    <div class="show text-center">최근가입한  사람을 조회하려면 <a href="<%= ctxPath %>/emp/empList.gw" class="link">여기</a> 를 클릭하세요</div>
	</div>
   	<div class="text-center mt-3">
		<button type="submit" class="btn_send bolder" onclick="goDel()">취소하기</button>
	</div>
	</div>    
	</div>
</div>
	
</html>
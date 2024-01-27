<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
	String ctxPath = request.getContextPath();
%>

<link href="https://fonts.googleapis.com/icon?family=Material+Icons"
      rel="stylesheet">

<link href="https://fonts.googleapis.com/icon?family=Material+Icons+Outlined"
      rel="stylesheet">

<style type="text/css">
	#mycontent > form > div > div > div:nth-child(3) > div.ml-2 > input[type=file]{
		position:relative;
		right:110px;
	}
	
	#file_drop,
	#content {
    	overflow: auto; /* 또는 overflow: scroll; */
	}
	
	.emailList_sections{
	    position: sticky;
	    top: 0;
	    display: flex;
	    background-color: white;
	    border-bottom: 1px solid whitesmoke;
	    z-index: 999;
	}

	.section_selected{
	    background-color: white;
	    border-width: 4px;
	    color: #70c4fa;
	    border-bottom: 3px solid #70c4fa;
	}
	
	.section_selected .material-icons-outlined{
	    color: #70c4fa;
	}
	
	.section:hover{
	    background-color: whitesmoke;
	    border-width: 3px;
	}
	
	.section span.list_name{
	    font-size: 18px;
	    font-weight:bold;
	    margin-left: 23px;
	}
	
	
	.emailRow_options{
	    display: flex;
	    align-items: center;
	}
		
	 #fileDrop{ 
	 	display: inline-block; 
        width: 100%; 
        height: 100px;
        overflow: auto;
        background-color: #fff;
        padding-left: 10px;}
                 
   span.delete{display:inline-block; width: 20px; border: solid 1px gray; text-align: center;} 
   span.delete:hover{background-color: #000; color: #fff; cursor: pointer;}
   #fileDrop > div.fileList > span.fileName{padding-left: 10px;}
   #fileDrop > div.fileList > span.fileSize{padding-right: 20px; float:right;} 
   span.clear{clear: both;}   


	html{
	   background-color: #03C75A;
	}
	
	#mycontent > div > form > div.ml-auto > div > button.btn.btn-danger.btn-lg.ml-3,
	#btnWrite{
		position:relative;
		bottom:40px;
	}
	
	#mycontent > div > div > h2{
		padding-right:880px;
	}
	

</style>    

<script type="text/javascript">

	
$(document).ready(function(){
	<%-- === jQuery 를 사용하여 드래그앤드롭(DragAndDrop)을 통한 파일 업로드 시작 === --%>
	let file_arr = []; // 첨부된어진 파일 정보를 담아 둘 배열

    // == 파일 Drag & Drop 만들기 == //
    $("#file").on("dragenter", function(e){ 
        e.preventDefault();
	    e.stopPropagation();
	    }).on("dragover", function(e){ 
	        e.preventDefault();
	        e.stopPropagation();
	        $(this).css("background-color", "#ffd8d8");
	    }).on("dragleave", function(e){ 
	        e.preventDefault();
	        e.stopPropagation();
	        $(this).css("background-color", "#fff");
	    }).on("drop", function(e){     
	        e.preventDefault();
	
	        var files = e.originalEvent.dataTransfer.files;  

	        if(files != null && files != undefined){
          
	            let html = "";
	            const f = files[0]; 
	        	let fileSize = f.size/1024/1024;  
	        	
	        	if(fileSize >= 10) {
	        		alert("10MB 이상인 파일은 업로드할 수 없습니다.!!");
	        		$(this).css("background-color", "#fff");
	        		return;
	        	}
	        	
	        	else {
	        		file_arr.push(f);
		        	const fileName = f.name; 
		        	
	        	    fileSize = fileSize < 1 ? fileSize.toFixed(3) : fileSize.toFixed(1);
	        	    html += 
	                    "<div class='fileList'>" +
	                        "<span class='delete'>&times;</span>" +    //&times;는 x로 보여주는 것이다. 
	                        "<span class='fileName'>"+fileName+"</span>" + 
	                        "<span class='fileSize'>"+fileSize+" MB</span>" +
	                        "<span class='clear'></span>" + //"<span class='clear'></span>"는 
	                    "</div>";
		            $(this).append(html);

	        	}
	        }// end of if(files != null && files != undefined)--------------------------
	        
	        $(this).css("background-color", "#fff");
	    });
		
		
	    // == Drop 되어진 파일목록 제거하기 == // 
	    $(document).on("click", "span.delete", function(e){
	    	let idx = $("span.delete").index($(e.target));
	    
	      	file_arr.splice(idx,1);    
          $(e.target).parent().remove();    
	    });

	<%-- === jQuery 를 사용하여 드래그앤드롭(DragAndDrop)을 통한 파일 업로드 끝 === --%>
	
	
	<%-- === 스마트 에디터 구현 시작 === --%>
    var obj = [];
	    
    //스마트에디터 프레임생성
    nhn.husky.EZCreator.createInIFrame({
	    oAppRef: obj,
	    elPlaceHolder: "content", 
	    sSkinURI: "<%= ctxPath%>/resources/smarteditor/SmartEditor2Skin.html",
	    htParams : {
	        bUseToolbar : true,            
	        bUseVerticalResizer : true,    
	        bUseModeChanger : true,
        }
    }); //end of nhn.husky.EZCreator.createInIFrame({ ---------------------
   <%-- === 스마트 에디터 구현 끝 === --%>
     
     
    // ===== 글쓰기 버튼을 눌렀을 때의 유효성 검사와 전송 시작 =====
    $("button#btnWrite").click(function(){
	  
		obj.getById["content"].exec("UPDATE_CONTENTS_FIELD", []);
	    // 글제목 유효성 검사
	    const subject = $("input:text[name='subject']").val().trim();
	   
        if(subject == "") {
	        alert("글제목을 입력하세요!!");
	        return; // 종료
	    } 
	   <%-- === 글내용 유효성 검사(스마트 에디터 사용 할 경우) 시작 === --%>
	   let contentval = $("textarea#content").val();
		  
	   // 글내용 유효성 검사 하기 
	   contentval = contentval.replace(/&nbsp;/gi, ""); 
       contentval = contentval.substring(contentval.indexOf("<p>")+3);
       contentval = contentval.substring(0, contentval.indexOf("</p>"));
	                
       if(contentval.trim().length == 0) {
      	   alert("글내용을 입력하세요!!");
           return;
       }
	   <%-- === 글내용 유효성 검사(스마트 에디터 사용 할 경우) 끝 === --%> 
		
	   // 글암호 유효성 검사
	   const pw = $("input:password[name='pw']").val();
	   if(pw == "") {
	       alert("글암호를 입력하세요!!");
	  	   return; // 종료
	   }
	   
	   var formData = new FormData($("form[name='notice_addFrm']").get(0)); // $("form[name='addFrm']").get(0) 폼 에 작성된 모든 데이터 보내기 
	      
       if(file_arr.length > 0) { // 파일첨부가 있을 경우 
     	  let sum_file_size = 0;
	          for(let i=0; i<file_arr.length; i++) {
	              sum_file_size += file_arr[i].size;
	          }// end of for---------------
	            
	          if( sum_file_size >= 10*1024*1024 ) { 
	              alert("첨부한 파일의 총합의 크기가 10MB 이상이라서 파일을 업로드할 수 없습니다.!!");
	        	  return; // 종료
	          }
	          else { // formData 속에 첨부파일 넣어주기
	        	  file_arr.forEach(function(item){
	                  formData.append("file_arr", item); 
	              });
	          }

       $("div.loader").show(); // CSS 로딩화면 보여주기
   
       $.ajax({
           url : "<%= ctxPath%>/notice_addEnd.gw",
           type : "post",
           data : formData,
           processData:false,  // 파일 전송시 설정 
           contentType:false,  // 파일 전송시 설정 
           dataType:"json",
           success:function(json){
               if(json.result == 1 ) {
            	   location.href="<%= ctxPath%>/noticeboard.gw"; 
               }
               else {
             	  alert("메일보내기가 실패했습니다.");
               }
           },
           error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		      }
       });
       
    }
    else{ //파일이 없는거
    	  $.ajax({
              url : "<%= ctxPath%>/nofile_notice_add.gw",
              type : "post",
              data : formData,
              processData:false,  // 파일 전송시 설정 
              contentType:false,  // 파일 전송시 설정 
              dataType:"json",
              success:function(json){
               	   location.href="<%= ctxPath%>/noticeboard.gw"; 
                 
              },
              error: function(request, status, error){
   				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
   		      }
          });   
          
    }
	   
    }); //end of  $("button#btnWrite").click(function(){ -------------
    // ===== 글쓰기 버튼을 눌렀을 때의 유효성 검사와 전송 끝 =====
	  
});// end of $(document).ready(function(){})-----------

</script>
<div style="width: 80%;" class="text-center container">
	<%-- == 원글쓰기 인 경우 == --%>
	<div style="padding: 0 0 1% 5%;">
		<h2 style="font-size:40px;" ><i class="fa-solid fa-pen-to-square"></i>&nbsp;글쓰기</h2>
	</div>
	    <%-- ===== 파일첨부하기 시작 ====== --%>
	    <form name="notice_addFrm" enctype="multipart/form-data" style="margin: 2% 0;">
	   		<div class="section-title" style="background-color: #f4f5f6; margin-bottom: 30px; display: flex; align-items: center; ">
	      		<span  style=" font-weight: 600;
						line-height: 21px;
						text-transform: uppercase;
						padding-left: 20px;
						position: relative; font-size: 18px; width: 10%;">성명</span>
				<div style="width: 8%;">
					<input type="hidden" name="fk_emp_id" value="${sessionScope.loginuser.employee_id}" readonly />
					<input type="text" name="name" value="${sessionScope.loginuser.name}"  style="width: 160%;" readonly/> 
				</div>
	   		</div>
	    		
	    			
			<div class="section-title" style="background-color: #f4f5f6; margin-bottom: 30px; display: flex; align-items: center; ">
       			<span  style=" font-weight: 600;
					line-height: 21px;
					text-transform: uppercase;
					padding-left: 20px;
					position: relative; font-size: 18px; width: 10%;">제목</span>
				<div style="width: 8%;">
     				    <input type="text" name="subject" size="100" maxlength="200" /> 
				</div>
    		</div>
	    				
			<div class="section-title" style="background-color: #f4f5f6; margin-bottom: 30px; display: flex; align-items: center; ">
     			<span  style=" font-weight: 600;
			line-height: 21px;
			text-transform: uppercase;
			position: relative; font-size: 18px; width: 10%;">첨부파일</span>
			<div style="text-align : left;width: 50%; display: flex; cursor: pointer; color: black;">
	            <div class="filebox">
					<div class="dropBox mt-2">
						<div class=row id="dropzone" style="margin-left:-1.5%; display: flex; align-items: center; justify-content: center; margin-bottom: 30px;">
				            	<div style="margin-right:610px; ">여기에 첨부 파일을 끌어 오세요</div>
				                <div id="file" name="file" style="display: inline-block; border: solid 2px; margin-left: 10px; width:850px; height:80px; background-color:white;"></div>
				            </div>
					</div>
				</div>
	    	</div>
		</div>	
		
		<textarea style="width: 100%; height: 500px;" name="content" id="content"></textarea>
		<input type="hidden" name="seq" value="${requestScope.seq}" readonly />
	        
        <div style="margin-top: 3%;" class='text-left ml-3'>
	        <span style=" font-weight: bold; font-size: 15pt; margin-right: 5%;">글암호</span>
			
			<input type="password" name="pw" maxlength="20" />
		</div>
			
		<div class="ml-auto" style="display: flex; cursor: pointer;">
			<div style="margin-left: auto;">
				<button type="button" id="btnWrite" class="btn btn-success btn-lg">글쓰기</button>
				<button type="button" class="btn btn-danger btn-lg ml-3" onclick="javascript:history.back()">취소</button>  
			</div>
		</div>
			
		</form>
	<%-- ===== 파일첨부 하기 끝 ====== --%>    
</div>	    

    
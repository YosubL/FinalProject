<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String ctxPath=request.getContextPath(); %>
<link href="https://fonts.googleapis.com/icon?family=Material+Icons"
      rel="stylesheet">

<link href="https://fonts.googleapis.com/icon?family=Material+Icons+Outlined"
      rel="stylesheet">
<style>

.dropBox {
	background-color: #eee;
	min-height: 50px;
	min-height: 50px;
	overflow:auto;
	font-size: small;
	text-align: center;
	vertical-align: middle;
}

.dropBox.active {
	background-color: #E3F2FD;
}

button {
	border-style: none;
}

#submitBtn, #getSavedPostBtn {
	color: white;
	background-color: #086BDE;
}

#submitBtn, #cancelBtn {
	font-size: small;
}


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
		
	 #fileDrop{ display: inline-block; 
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
	
	#mycontent > div > div:nth-child(1) > h2{
		padding-right:870px;
	}
	
	
</style>


<script>
	//네이버 스마트 에디터용 전역변수
	var obj = [];	

	
	$(document).ready(function(){
		
		/* 네이버 스마트 에디터  프레임생성 */
		nhn.husky.EZCreator.createInIFrame({
			oAppRef: obj,
			elPlaceHolder: "content",
			sSkinURI: "<%=ctxPath%>/resources/smarteditor/SmartEditor2Skin.html",
			htParams: {
				// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
				bUseToolbar: true,
				// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
				bUseVerticalResizer: true,
				// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
				bUseModeChanger: true,
			}
		});
		
		
		<%-- === jQuery 를 사용하여 드래그앤드롭(DragAndDrop)을 통한 파일 업로드 시작 === --%>
		let file_arr = []; // 첨부된어진 파일 정보를 담아 둘 배열

      // == 파일 Drag & Drop 만들기 == //
	    $("#file").on("dragenter", function(e){ /* "dragenter" 이벤트는 드롭대상인 박스 안에 Drag 한 파일이 최초로 들어왔을 때 */ 
	        e.preventDefault();
	        e.stopPropagation();
	 
	    }).on("dragover", function(e){ /* "dragover" 이벤트는 드롭대상인 박스 안에 Drag 한 파일이 머물러 있는 중일 때. 필수이벤트이다. dragover 이벤트를 적용하지 않으면 drop 이벤트가 작동하지 않음 */ 
	        e.preventDefault();
	        e.stopPropagation();
	        $(this).css("background-color", "#ffd8d8");
	    }).on("dragleave", function(e){ /* "dragleave" 이벤트는 Drag 한 파일이 드롭대상인 박스 밖으로 벗어났을 때  */
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
		        	const fileName = f.name; // 파일명	
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

	    
	    	file_arr.splice(idx,1); // 드롭대상인 박스 안에 첨부파일을 드롭하면 파일들을 담아둘 배열인 file_arr 에서 파일을 제거시키도록 한다.
	   
          $(e.target).parent().remove(); // <div class='fileList'> 태그를 삭제하도록 한다.	    
	    });

<%-- === jQuery 를 사용하여 드래그앤드롭(DragAndDrop)을 통한 파일 업로드 끝 === --%>
	
		
		// 파일 삭제 버튼 클릭시
		$(document).on('click','[name=removeFile]', function(){
	   	 	const $this = $(this);
	   	 	delete_file_name = $this.parent().children('.fileName').text();
	   	 	delete_file_size = $this.parent().children('.digitFileSize').text();
	   	 	
	   	 	for(let i = 0; i < fileList.length; i++) {
	   	 		if(fileList[i].name = delete_file_name && delete_file_size == fileList[i].size )  {
	   	 			
	   	 			fileList.splice(i, 1);
	   	 		    i--;
	   	 		  }
	   	 	}
	   	 $(this).parent().remove();
	   	 
		}); // end of $(document).on('click','[name=removeFile]') ------------------
		
		// 기존 첨부파일 조회
		getExistingFiles();
		
		
		
		/* 확인 버튼 클릭 시 */
		$("button#submitBtn").click(function(){
			// 에디터에서 textarea에 대입
			obj.getById["content"].exec("UPDATE_CONTENTS_FIELD", []);
			
			// 글제목 유효성 검사
			const subject = $("#subject").val().trim();
			if(subject == "") {
				alert("글제목을 입력하세요!");
			
				return;
			}
			
			// 글내용 유효성검사
		    var content = $("#content").val();
	
		    if( content == ""  || content == null || content == '&nbsp;' || content == '<p>&nbsp;</p>')  {
				alert("글내용을 입력하세요!");
				return;
		    }
		   
		
		    var formData = new FormData($("form[name='editFrm']").get(0));
     	  	// 첨부한 파일의 총합의 크기가 10MB 이상 이라면 메일 전송을 하지 못하게 막는다.
   	     	let sum_file_size = 0;
          	for(let i=0; i<file_arr.length; i++) {
            	sum_file_size += file_arr[i].size;
          	}// end of for---------------
	            
          	if( sum_file_size >= 10*1024*1024 ) { // 첨부한 파일의 총합의 크기가 10MB 이상 이라면 
            	alert("첨부한 파일의 총합의 크기가 10MB 이상이라서 파일을 업로드할 수 없습니다.!!");
        	  	return; // 종료
	        }
	        else { // formData 속에 첨부파일 넣어주기
	         	file_arr.forEach(function(item){
	            formData.append("file_arr", item); 
	        	});
          	}
	
	 	 	$.ajax({
				url : "<%=ctxPath%>/notice_editEnd.gw",
	 	     	data : formData,
 	     		type:'POST',
	 	     	enctype:'multipart/form-data',
	 	     	processData:false,
	 	     	contentType:false,
	 	     	dataType:'json',
	 	     	cache:false,
	 	     	success:function(json){
	 	     		if(json.result == true) {
 		    	    	location.href="<%=ctxPath%>/notice_editAfter_view.gw?seq=${boardvo.seq}";
	
	 	     		}
		 	     	else
	 	     			swal("수정 실패", "게시글 수정을 실패하였습니다.", "error");
	 	     	},
	 	     	error: function(request, status, error){
	 				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	 			}
	 	 	});
	
		}); // end of $("button#submitBtn").click() ------------------------------
		
		
	}); // end of $(document).ready() =====================================================



	// 기존 첨부파일 조회 
	function getExistingFiles(){
		
		$.ajax({
			url : "<%=ctxPath%>/getNotice_BoardFiles.gw",
			data : {"seq": "${boardvo.seq}"},
			dataType:'json',
			cache:false,
			success:function(jsonArr){
				
				let html = "";
				
				// 첨부파일이 있을 경우			
				if(jsonArr.length > 0) {
					jsonArr.forEach(el => {
						html += "<div>"+el.orgFilename+"<button type='button' class='ml-2' onclick='deleteFile("+el.fileno+")'>삭제</button></div>"
					});
				}
				$("#attachedfile").html(html);
	     	},
		     error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		 });
	}
	
	// 새로 첨부된 파일 가져오기
	function getNewFiles(formData){
		
		if(fileList.length > 0){
		    fileList.forEach(function(f){
		        formData.append("fileList", f);
		    });
		}
		
	}
	
	getNewFiles(formData);

	
	function deleteFile(fileno){
		
		$.ajax({
		     url : "<%=ctxPath%>/notice_deleteFile.gw",
		     data : {"fileno": fileno,
		    	 	"fk_seq":${boardvo.seq}
		     },
		     type:'POST',
		     dataType:'json',
		     cache:false,
		     success:function(json){
		     	if(json.result == true) {
		     		// 첨부파일 다시 조회
		     		getExistingFiles();
		     	}
		     	else
		     		swal("등록 실패", "게시글 작성을 실패하였습니다.", "error");
		     },
		     error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				}
		 });
		
	}
	
</script>   



 <div style="width: 80%;" class="text-center container">
		<%-- == 원글쓰기 인 경우 == --%>
	<div style="padding: 0 0 1% 5%;">    
		<h2 style="font-size:40px;" ><i class="fa-solid fa-pen-to-square"></i>&nbsp;글 수정</h2>
	</div>

	
	
	<div class="ml-auto" style="display: flex; cursor: pointer;">
			<div style="margin-left: auto;">
		    </div>
	</div>
        

	
	
	<form id="editFrm" name="editFrm">
		<div class="section-title" style="background-color: #f4f5f6; margin-bottom: 30px; display: flex; align-items: center; ">
	       			<span class="left_span" style=" font-weight: 600;
						line-height: 21px;
						text-transform: uppercase;
						padding-left: 20px;
						position: relative; font-size: 18px; width: 10%;">성명</span>
		<div style="width: 8%;">

					<input type="text" name="name" value="${sessionScope.loginuser.name}"  style="width: 160%;" readonly/> 
				</div>
	    	</div>
		<input type="hidden" name="seq" value="${boardvo.seq}"/>
		<div class="section-title" style="background-color: #f4f5f6; margin-bottom: 30px; display: flex; align-items: center; ">
	       			<span class="left_span" style=" font-weight: 600;
						line-height: 21px;
						text-transform: uppercase;
						padding-left: 20px;
						position: relative; font-size: 18px; width: 10%;">제목</span>
		
		<input type="text" name="subject" id="subject" placeholder='제목을 입력하세요' style='width: 76%; 
		font-size: small;' value="${boardvo.subject}"/>
		</div>
		
		<div class="section-title" style="background-color: #f4f5f6; margin-bottom: 30px; display: flex; align-items: center; ">
      			<span  style=" font-weight: 600;
				line-height: 21px;
				text-transform: uppercase;
				position: relative; font-size: 18px; width: 10%;">첨부파일</span>
				<div style="text-align : left;width: 50%; display: flex; cursor: pointer; color: black;">
		            <div class="filebox">
						<div style="width:940px; class="dropBox mt-2">
							<div class=row id="dropzone" style="margin-left:-1.5%; display: flex; align-items: center; justify-content: center; margin-bottom: 30px;">
					            	<div style="margin-right:710px; ">여기에 첨부 파일을 끌어 오세요</div>
					                <div id="file" name="file" style="display: inline-block; border: solid 2px; margin-right:90px; width:850px; height:80px; background-color:white; overflow-y: auto;"></div>
					         </div>
						</div>
					</div>
		    	</div>
			</div>	
		
		<textarea style="width: 100%; height: 612px;" name="content" id="content" placeholder='내용을 입력하세요'>${boardvo.content}</textarea>
		
		<div class='card'>
			<div class='card-header small'>첨부된 파일</div>
			<div class='card-body small' id='attachedfile'>
			</div>
		</div>
	
		
	</form>
	
	<div style="margin: 20px; text-align: center;">
		<button type="button" id='cancelBtn' class='btn btn-secondary rounded' onclick="javascript:history.back()">취소</button>
		<button type="button" class='btn rounded ml-2' id="submitBtn">확인</button>
	</div>
</div>

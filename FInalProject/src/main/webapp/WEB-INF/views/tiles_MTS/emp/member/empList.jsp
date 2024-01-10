<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>     
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
   String ctxPath = request.getContextPath(); 
	System.out.println("ctxPath" + ctxPath);
%>
<style type="text/css">
    
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
		    justify-content: right;
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
		button#btnSearch,
		button#btnReset {
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
        table#emptbl {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 8px 12px 0 rgba(0, 0, 0, 0.1);
        }

        /* 테이블 헤더 스타일 변경 */
        table#emptbl th {
            background-color: #ffffff;
            text-align: center;
            padding: 12px;
            font-weight: bold;
        }

        /* 테이블 셀 스타일 변경 */
        table#emptbl td {
            border: solid 1px #ddd;
            padding: 8px;
            text-align: center;
        }

        /* 테이블 로우 스타일 변경 */
        tr.empinfo {
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        /* 테이블 로우 호버 효과 */
        tr.empinfo:hover {
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

        
    </style>

<script type="text/javascript">

$(document).ready(function(){
	
    $("button#btnSearch").click(function(){
        const frm = document.searchFrm;
        const deptName = $("#deptName").val();
        const gradeLV = $("#gradeLV").val();
        const gender = $("#gender").val();
        
        
        // Append selected values to the URL query parameters
        frm.action = "<%= ctxPath%>/emp/empList.gw?deptName=" + deptName + "&gradeLV=" + gradeLV + "&gender=" + gender;
        frm.submit();
    });
    

   	    // 초기화 버튼 클릭 시 폼 초기화
   	    $("button#btnReset").click(function() {
   	      const frm = document.searchFrm;
   	      $("#deptName").val(''); // 부서 선택 초기화
   	   	  $("#gradeLV").val(''); // 직급 선택 초기화
   	      $("#gender").val(''); // 성별 선택 초기화

   	      frm.action = "<%= ctxPath %>/emp/empList.gw"; // 폼 액션 초기화
   	      frm.submit();
   	    });

   	    
  	  // 특정 회원을 클릭하면 회원의 상세정보
   		$(document).on("click", "table#emptbl tr.empinfo", function (e) {
//         alert("클릭");
       	const imagePath = '<%= ctxPath %>/resources/images/files/';
	    const employee_id = $(this).find("input:hidden[name='employee_id']").val();
		 alert(employee_id);
	    const modalPhoto = document.getElementById('modal_photo');
		$.ajax({
			url:"<%= ctxPath%>/emp/empOneDetail.gw",
		     data:{"employee_id":employee_id},
		     dataType:"json",
		     success:function(json){
		           //console.log(JSON.stringify(json));
		           // {"empOneDetail":{"fk_department_id":"100","t_manager_name":"이요섭","salary":"100000000","t_manager_id":"10000","gradelevel":"5","t_manager_email":"leeys@naver.com","t_manager_job_name":"개발 부서장","manager_phone":"01097370275","manager_id":"9999","t_manager_phone":"01097370275","jubun":"8607191","email":"leeys@naver.com","fk_team_id":"1","address":"  ","idle":"0","department_name":"개발부","manager_job_name":"개발 부서장","hire_date":"2023-12-05 17:07:56","manager_name":"이요섭","job_name":"개발 부서장","phone":"01097370275","employee_id":"9999","name":"이요섭","basic_salary":"100000000","manager_email":"leeys@naver.com","status":"1"}}
					if (json && json.empOneDetail) {
				        const empData = json.empOneDetail;
				
				        // 모달에 데이터 삽입
   				        const photoFileName = empData.photo; // 이미지 파일명을 가져오는 로직
       					$("#modal_photo").html(`<img src="${imagePath}${photoFileName}">`);

				        $("#modal_department_name").text(empData.department_name);
				        $("#modal_job_name").text(empData.job_name);
				        $("#modal_name").text(empData.name);
				        $("#modal_email").text(empData.email);
				        $("#modal_phone").text(empData.phone);
				        $("#modal_hire_date").text(empData.hire_date);
				        //$("#modal_postcode").text(empData.postcode);
				        //$("#modal_address").text(empData.address);

				        $("#modal_salary").text(empData.salary);
				        $("#modal_bank_code").text(empData.bank_code);
				        $("#modal_bank_name").text(empData.bank_name);
				        
				        $("#modal_manager_job_name").text(empData.t_manager_job_name);
				        $("#modal_manager_email").text(empData.t_manager_email);
				        $("#modal_manager_name").text(empData.t_manager_name);
				        //$("#modal_manager_phone").text(empData.t_manager_phone);
				        
				        $("#modal_t_manager_job_name").text(empData.t_manager_job_name);
				        $("#modal_t_manager_email").text(empData.t_manager_email);
				        $("#modal_t_manager_name").text(empData.t_manager_name);
				        //$("#modal_t_manager_phone").text(empData.t_manager_phone);
				        
				        // 모달 열기
				        $("#modal_member").modal("show");

				       				        
				    } else {
				        alert("JSON 데이터가 유효하지 않습니다.");
				    }
		     }
		     , error: function(request, status, error){
			     alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		     }
		          
		     });
 		
    });
  	  
		

}); // end of $(document).ready(function(){})----------------------------------


</script>


<div style="display: flex; justify-content: center; margin-bottom: 50px;">
    <div style="width: 80%; min-height: 900px; margin:auto;">
   		<div id="name">
         	  <h2>인사관리</h2>
   		</div>
   	  <form name="searchFrm" style="right: 10%;">

		<c:if test="${not empty requestScope.deptNameList}">
		    <select name="deptName" id="deptName" style="height: 30px; width: 120px;">
			    <option value="">부서선택</option>
			    <c:forEach var="dept" items="${requestScope.deptNameList}" varStatus="status">
                <option value="${dept.department_id}" ${param.deptName == dept.department_id ? 'selected' : ''}>${dept.department_name}</option>
			    </c:forEach>
			</select>
			</c:if>

			 <select name="gradeLV" id="gradeLV" style="height: 30px; width: 120px;">
            	<option value="">직급선택</option>
	   			    <option value="사장" <c:if test="${param.gradeLV eq '사장'}">selected</c:if>>사장</option>
	   			    <option value="부서장" <c:if test="${param.gradeLV eq '부서장'}">selected</c:if> >부서장</option>
	   			    <option value="팀장" <c:if test="${param.gradeLV eq '팀장'}">selected</c:if>>팀장</option>
	   			    <option value="사원" <c:if test="${param.gradeLV eq '사원'}">selected</c:if>>사원</option>
		    </select>
			<select name="gender" id="gender" style="height: 30px; width: 120px;">
			   <option value="">성별선택</option>
			   <option value="남자" <c:if test="${param.gender eq '남자'}">selected</c:if>>남자</option>
			   <option value="여자" <c:if test="${param.gender eq '여자'}">selected</c:if>>여자</option>
			</select>
	      <button type="button" class="btn btn-info btn-sm" id="btnSearch">검색하기</button>
	      <button type="reset" class="btn btn-danger btn-sm" id="btnReset">초기화</button>

      </form>
      
      <br> 	
      <table id="emptbl">
         <thead>
            <tr>
               
               <th style = "width: 10%;">부서명</th>
               <th style = "width: 10%;">직급</th>
               <th style = "width: 10%;">사원명</th>
               <th style = "width: 25%;">웹메일</th>
               <th style = "width: 10%;">입사일자</th>
               <th style = "width: 15%;">월급</th>
               <th style = "width: 10%;">성별</th>
               <th style = "width: 10%;" >나이</th>
            </tr>
         </thead>
         <tbody>
            <c:if test="${not empty requestScope.empList}">
               <c:forEach var="map" items="${requestScope.empList}">
                  <tr class="empinfo">
                     <td style="text-align: center;">
                     <input name="employee_id" type="hidden" value="${map.employee_id}" />
                     ${map.department_name}</td>
                     <td style="text-align: center;">${map.gradeLV}</td>
                     <td style="text-align: center;">${map.name}</td>
		             <td style="text-align: center;">${map.email}</td>  <%-- department_id 은 hr.xml 에서 정의해준 HashMap의 키이다.  --%>
                     
                     <td style="text-align: center;">${map.hire_date}</td>
                     <td style="text-align: center;"><fmt:formatNumber value="${map.Yearsal}" pattern="#,###"></fmt:formatNumber>원</td>
                     <td style="text-align: center;">${map.gender}</td>
                     <td style="text-align: center;">${map.age}</td>
                  </tr>
 
               </c:forEach>
               
            </c:if>
         </tbody>
      </table>
   
   
    <div align="right" style="border: solid 0px gray; width: 80%; margin: 30px auto;"> 
       <button type="button" class="btn btn-sm btn-secondary" onclick="<%= ctxPath%>/emp/payment.gw">월급 지급하기</button>
    </div>
    
    
    
    
    
<%-- ============ 모달 [시작] ============= --%>
<div class="modal fade" id="modal_member" role="dialog" data-backdrop="static">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
    
      <!-- Modal header -->
      <div class="modal-header">
        <h4 class="modal-title">개인 프로필</h4>
        <button type="button" class="close modal_close" data-dismiss="modal">&times;</button>
      </div>
      
      <!-- Modal body -->
    <div class="modal-body">
 <table class="table table-bordered vertical-table">
    <tbody>
        <tr>
            <th rowspan="7"><img src="<%= ctxPath%>/resources/images/files/<span id='modal_photo'></span>"></th>
        </tr>
        <tr>
            <th>부서명</th>
            <td><span id="modal_department_name"></span></td>
        </tr>
        <tr>
            <th>직책</th>
            <td><span id="modal_job_name"></span></td>
        </tr>
        <tr>
            <th>이름</th>
            <td><span id="modal_name"></span></td>
        </tr>
        <tr>
            <th>이메일</th>
            <td><span id="modal_email"></span></td>
        </tr>
        <tr>
            <th>입사일</th>
            <td><span id="modal_hire_date"></span></td>
        </tr>
        <tr>
            <th>전화번호</th>
            <td><span id="modal_phone"></span></td>
        </tr>
        <tr>
            <th>급여</th>
            <td><span id="modal_salary"></span></td>
        </tr>
        <tr>
            <th>은행명</th>
            <td><span id="modal_bank_name"></span></td>
        </tr>
        <tr>
            <th>은행 코드</th>
            <td><span id="modal_bank_code"></span></td>
        </tr>
        <tr>
            <th>부서장 직책</th>
            <td><span id="modal_manager_job_name"></span></td>
        </tr>
        <tr>
            <th>부서장 이메일</th>
            <td><span id="modal_manager_email"></span></td>
        </tr>
        <tr>
            <th>부서장 이름</th>
            <td><span id="modal_manager_name"></span></td>
        </tr>
        <tr>
            <th>팀장 직책</th>
            <td><span id="modal_t_manager_job_name"></span></td>
        </tr>
        <tr>
            <th>팀장 이메일</th>
            <td><span id="modal_t_manager_email"></span></td>
        </tr>
        <tr>
            <th>팀장 이름</th>
            <td><span id="modal_t_manager_name"></span></td>
        </tr>
        
    </tbody>
</table>


</div>
      
    </div>
  </div>
</div>
<%-- ============ 모달 [끝] ============= --%>
   </div>
</div>




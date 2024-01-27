<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
   String ctxPath = request.getContextPath();
%>

<style>

body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    margin: 0;
    padding: 0;
}

table.myinfo_tbl {
    width: 100%;
    border-collapse: collapse;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 8px 12px 0 rgba(0, 0, 0, 0.1);
}


table.myinfo_tbl th {
   border: solid 1px #ddd;
    background-color: #ffffff;
    text-align: center;
    padding: 12px;
    font-weight: bold;
    width: 15%;
}


table.myinfo_tbl td {
    border: solid 1px #ddd;
    padding: 8px;
    text-align: center;
    width: 35%;
}

table#table1{
   width: 70%; 
   margin-left: 10px;
}

table#table2{
   width: 82.3%; 
   margin: 3% auto 0;
}

tr {
   height: 53px;
}

table#table2 td.input_size {
   padding-left: 2%;
   text-align: left;
}

input {
   padding-left: 3%;
}

select {
   width: 82.5%;
    height: 25px;
    text-align: center;
}

div#photo {
   border: solid 1px #ddd;
   width: 200px; 
   height: 200px; 
   vertical-align: top; 
   text-align: center;
   border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 8px 12px 0 rgba(0, 0, 0, 0.1);
}

img {
   width: 200px;
   height: 200px;
}

div#top {
   text-align: center; 
   display: flex; 
   align-items: center;
}

h1 {
   margin: 2% 0 2% 9.5%; 
   margin-right: auto;
}

button#btnUpdate {
   margin-right: 1%;
   background-color: rgb(3, 199, 90);
    color: #fff; 
    border: 1px solid #4CAF50; 
    padding: 10px 20px; 
    font-size: 16px;
    cursor: pointer; 
    border-radius: 5px; 
    transition: background-color 0.3s ease;
}

button#btnCancel {
   margin-right: 10%;
   background-color: rgb(255, 0, 0);
    color: #fff; 
    border: 1px solid #4CAF50; 
    padding: 10px 20px; 
    font-size: 16px;
    cursor: pointer; 
    border-radius: 5px; 
    transition: background-color 0.3s ease;
}

.filebox label {
    display: inline-block;
    color: #fff;
    vertical-align: middle;
    text-align: center;
    background-color: #999999;
    cursor: pointer;
    height: 40px;
    margin: 1% 0 0 9.5%;
    padding-top: 9px;
    width: 10.5%;
}

.filebox input[type="file"] {
   position: absolute;
   width: 0;
   height: 0;
   padding: 0;
   overflow: hidden;
   border: 0;
}

.error {
   border: solid 2px red !important;
   box-shadow: 0 0 1px red;
}
    
</style>



<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script type="text/javascript">

$(document).ready(function(){
   
   $("input.error").removeClass("error");
   $("input.check").val(1);
   
   // 사원증 사진 미리보기
   $(document).on("change", "input.img_file", function(e){
      
      $("img#previewImg").show();
      
      const input_file = $(e.target).get(0);
      const fileReader = new FileReader();
      
      fileReader.readAsDataURL(input_file.files[0])
      fileReader.onload = function() {
       //   console.log(fileReader.result);
         document.getElementById("previewImg").src = fileReader.result;
      };
   });
   
   
   // 휴대전화 유효성검사
   $("input:text[name='phone']").on("focusout", function(e) {
         
      const regExp_phone = new RegExp(/^\d{11}$/);
      
      const bool = regExp_phone.test($(e.target).val());
      
      if(!bool) {
         $(e.target).addClass("error");
         $("input:hidden[id='phone']").val(0);
      }
      else {
         $(e.target).removeClass("error");
         $("input:hidden[id='phone']").val(1);
      }
      
   });
   
   
   // 우편번호 input태그 누르면 다음 주소찾기 띄우기
   $("input:text[name='postcode']").on("focus", function(e) {
      $("input#address").removeAttr("readonly");
       
       // 참고항목을 쓰기가능 으로 만들기
       $("input#extraAddress").removeAttr("readonly");
       
      new daum.Postcode({
           oncomplete: function(data) {
              
               let addr = ''; 
               let extraAddr = ''; 

               //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
               if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                   addr = data.roadAddress;
               } else { // 사용자가 지번 주소를 선택했을 경우(J)
                   addr = data.jibunAddress;
               }

               // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
               if(data.userSelectedType === 'R'){
                   // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                   // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                   if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                       extraAddr += data.bname;
                   }
                   // 건물명이 있고, 공동주택일 경우 추가한다.
                   if(data.buildingName !== '' && data.apartment === 'Y'){
                       extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                   }
                   // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                   if(extraAddr !== ''){
                       extraAddr = ' (' + extraAddr + ')';
                   }
                   // 조합된 참고항목을 해당 필드에 넣는다.
                   document.getElementById("extraAddress").value = extraAddr;
               
               } else {
                   document.getElementById("extraAddress").value = '';
               }

               // 우편번호와 주소 정보를 해당 필드에 넣는다.
               document.getElementById('postcode').value = data.zonecode;
               document.getElementById("address").value = addr;
               $("input:hidden[id='postcode_v']").val(1);
               $("input:hidden[id='address_v']").val(1);
               // 커서를 상세주소 필드로 이동한다.
               document.getElementById("detailAddress").focus();
               
           },
           onclose: function(state) {
               // 다음 우편번호 서비스 창이 닫혔을 때 호출되는 콜백
               if (state === 'FORCE_CLOSE') {
                   // 사용자가 창을 강제로 닫았을 경우, 여기에 원하는 동작을 추가할 수 있습니다.
                   // 예를 들어, 다른 곳으로 포커스를 이동하거나 다른 동작을 수행할 수 있습니다.
                   document.getElementById("bank_name").focus();
               }
           }
       }).open();
      
       // 주소를 읽기전용(readonly) 로 만들기
       $("input#address").attr("readonly", true);
       
       // 참고항목을 읽기전용(readonly) 로 만들기
       $("input#extraAddress").attr("readonly", true);
   });
   
   
   // 주소 변경시 상세주소 비우기
   $("input:text[id='detailAddress']").on("focus", function(e){
      
      $(e.target).val("");
      
   });
   
   // 상세주소 유효성검사
   $("input:text[id='detailAddress']").on("focusout", function(e){
      
      if($(e.target).val() == ""){
         $(e.target).addClass("error");
         $("input:text[id='detailaddress_v']").val(0);
      }
      else{
         $(e.target).removeClass("error");
         $("input:text[id='detailaddress_v']").val(1);
      }
      
   });
         
   
   // 계좌번호 유효성검사
   $("input:text[name='bank_code']").on("focusout", function(e) {
      
      const regExp_phone = new RegExp(/^\d+$/);
      
      const bool = regExp_phone.test($(e.target).val());      
      
      if(!bool) {
         $(e.target).addClass("error");
         $("input:hidden[id='bank_code']").val(0);
      }
      else {
         $(e.target).removeClass("error");
         $("input:hidden[id='bank_code']").val(1);
      }
      
   });
   
   
   // 취소버튼 클릭시 이전페이지 이동
   $("button#btnCancel").click(function() {
      const cancel = confirm("프로필 수정을 취소하시겠습니까?")
      if(cancel) {
         window.history.back();
      }
   });
   
   
   
}); // end of $(document).ready(function(){})----------------


function btnUpdate() {
   
   let b_requiredInfo = false;
   
   const requiredInfo_list = document.querySelectorAll(".requiredInfo");
   console.log(requiredInfo_list);
    for(let i=0; i<requiredInfo_list.length; i++){
      const val = requiredInfo_list[i].value.trim();
      if(val == "") {
         alert("모든 정보를 입력해 주세요.");
          b_requiredInfo = true;
          break;
      }
   }// end of for-----------------------------
   
   
   if($("input:hidden[id='phone']").val() != 1) {
      alert("핸드폰 번호가 올바르지 않습니다.");
       b_requiredInfo = true;
   }
   
   
   if($("input:hidden[id='postcode_v']").val() != 1) {
      alert("우편번호를 입력해주세요.");
       b_requiredInfo = true;
   }
   
   if($("input:hidden[id='address_v']").val() != 1) {
      alert("주소를 입력해 주세요.");
       b_requiredInfo = true;
   }
   
   
   if($("input:text[id='detailaddress_v']").val() != 1) {
      alert("상세주소를 입력해 주세요.");
       b_requiredInfo = true;
   }
   
   if($("input:hidden[id='bank_code']").val() != 1) {
      alert("계좌번호가 올바르지 않습니다.");
       b_requiredInfo = true;
   }
   
   
   if(b_requiredInfo) {
      return; // goRegister() 함수를 종료한다.
   }
   
   const frm = document.myinfoEditFrm;
   frm.method = "post";
   frm.action = "<%= ctxPath%>/myinfoEditEnd.gw";
   frm.submit();
   
}

</script>
   
   <div id="top">
       <h1>프로필 수정</h1>
       <button type="button" id="btnUpdate" onclick="btnUpdate()">수정하기</button>
       <button type="button" id="btnCancel">취소</button>  
   </div>
   
   <form name="myinfoEditFrm" enctype="multipart/form-data">
      <div style="display: flex; justify-content: center;">
      
         <div id="photo">
            <img src="<%= ctxPath%>/resources/images/empImg/${requestScope.loginuser.photo}" id="previewImg" />
         </div>
            
         <table id="table1" class="myinfo_tbl">
       
            <tr>
               <th>성명</th>
               <td>${requestScope.loginuser.name}</td>
               <th>사원번호</th>
               <td>${requestScope.loginuser.employee_id}</td>
            </tr>
       
            <tr>
               <th>부서명</th>
               <td>${requestScope.dept_team.DEPARTMENT_NAME}</td>
               <th>팀명</th>
               <td>${requestScope.dept_team.TEAM_NAME}</td>
            </tr>
            
            <tr>
               <th>직급</th>
               <td>${requestScope.dept_team.JOB_NAME}</td>
               <th>입사일자</th>
               <td>${requestScope.loginuser.hire_date}</td>
            </tr>
            
         </table>
         
      </div>
      
      <div class="filebox">
         <label for="attach">사원증 변경하기</label> 
         <input type="file" id="attach" class="img_file" name="attach" accept="image/jpeg, image/png">
      </div>
      
      <table id="table2" class="myinfo_tbl">
      
         <tr>
            <th>이메일</th>
            <td class="input_size"><input type="text" name="email" value="${requestScope.loginuser.email}" readonly /></td>
            <th>연락처</th>
            <td class="input_size">
               <input type="text" class="error requiredInfo" name="phone" value="${requestScope.loginuser.phone}" />
               <input type="hidden" id="phone" class="check" />
            </td>
         </tr>
   
         <tr>
            <th>생년월일</th>
            <td class="input_size"><input type="text" name="jubun" value="${requestScope.gender_birthday.BIRTHDAY.substring(0, 4)}년 ${requestScope.gender_birthday.BIRTHDAY.substring(4, 6)}월 ${requestScope.gender_birthday.BIRTHDAY.substring(6, 8)}일" readonly /></td>
            <th>성별</th>
            <td class="input_size"><input type="text" name="gender" value="${requestScope.gender_birthday.GENDER}" readonly /></td>
         </tr>
         
         <tr>
            <th>우편번호</th>
            <td class="input_size">
               <input type="text" class="error requiredInfo" name="postcode" id="postcode" value="${requestScope.loginuser.postcode}" />
               <input type="hidden" id="postcode_v" class="check" />
            </td>
            <th>주소 참고사항</th>
            <td class="input_size"><input type="text" class="error requiredInfo" name="extraaddress" id="extraAddress" size="30" value="${requestScope.loginuser.extraaddress}" /></td>
         </tr>
         
         <tr>
            <th>주소</th>
            <td class="input_size">
               <input type="text" class="error requiredInfo" name="address" id="address" style="margin-bottom: 1%;" size="30" value="${requestScope.loginuser.address}" />
               <input type="hidden" id="address_v" class="check" />
            </td>
            <th>상세주소</th>
            <td class="input_size">
               <input type="text" class="error requiredInfo" name="detailaddress" id="detailAddress" size="30" value="${requestScope.loginuser.detailaddress}" />
               <input type="text" id="detailaddress_v" class="check" />
            </td>
         </tr> 
         
         <tr>
            <th>은행명</th>
            <td class="input_size">
               <select name="bank_name" id="bank_name">
                  <option>${requestScope.loginuser.bank_name}</option>
                  <option>농협은행</option>
                  <option>신한은행</option>
                  <option>국민은행</option>
                  <option>기업은행</option>
                  <option>우리은행</option>
                  <option>하나은행</option>
                  <option>신협은행</option>
                  <option>토스뱅크</option>
                  <option>카카오은행</option>
               </select>
            </td>
            <th>계좌번호</th>
            <td class="input_size">
               <input type="text" class="error requiredInfo" name="bank_code" value="${requestScope.loginuser.bank_code}" />
               <input type="hidden" id="bank_code" class="check" />
            </td>
         </tr>
         
      </table>
      
      <input type="hidden" value="${requestScope.loginuser.photo}" name="photo" />
      <input type="hidden" value="${requestScope.loginuser.employee_id}" name="employee_id" />
   </form>
   








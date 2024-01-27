<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.net.InetAddress" %>

<%
    String ctxPath = request.getContextPath();

   // === #195. (웹채팅관련3) ===
   // === 서버 IP 주소 알아오기(사용중인 IP주소가 유동IP 이라면 IP주소를 알아와야 한다.) ===
   
   InetAddress inet = InetAddress.getLocalHost();
   String serverIP = inet.getHostAddress();
   
   //System.out.println("serverIP : " + serverIP);
   // serverIP : 192.168.10.206
   
   // String serverIP = "211.238.142.72"; 만약에 사용중인 IP주소가 고정IP 이라면 IP주소를 직접입력해주면 된다.
   
   // === 서버 포트번호 알아오기 === //
   int portnumber = request.getServerPort();
   //System.out.println("portnumber : " + portnumber);
   //portnumber : 9090
   
   String serverName = "http://"+serverIP+":"+portnumber;
   //System.out.println("serverName : " + serverName);
   //serverName : http://192.168.10.206:9090
%>

<style>.sidebar, toggle-btn:hover {
        width: 250px;
        position: fixed;
        height: 100%;
        overflow-y: auto;
        top: 0;
        left: 0; /* Initially hide the sidebar */
        background-color: rgb(3, 199, 90);
        transition: all 0.1s;
        padding-top: 30px;
    }
	.nav-icon {
        position: fixed; /* 또는 relative 사용 가능 */
        left: 15px; /* 아이콘 위치 조정 */
       
    }
    .sidebar.hidden {
        left: -250px; /* Hide the sidebar by moving it to the left */
    }

    .sidebar ul {
        list-style: none;
        padding: 15px;
        
    }

    .sidebar ul li.nav-item {
        padding: 20px 7px;
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    }

    .toggle-btn  {
        position: fixed;
        left: 20px;
        top: 20px;
        cursor: pointer;
        color: #fff;
        font-size: 10px;
        transition: all 0.3s;
        z-index: 999; /* Set a higher z-index to keep the toggle button above other elements */
    }

    .sidebar ul li .nav-link-text,
    .nav-icon {
        color: #fff !important;
        text-decoration: none !important;
        font-size: 12pt !important;
    }
    .sidebar ul li .nav-link-text{
        padding-left:20px;
    }
    
    
     /* 하위 메뉴 스타일 */
    .sub-menu {
        display: none;
    }
    
    /* 활성화된 하위 메뉴 표시 */
    .sub-menu.active {
        display: block;
    }
</style>

<script>   
document.addEventListener('DOMContentLoaded', function () {
    const sidebar = document.querySelector('.sidebar');
    const toggleBtn = document.querySelector('.toggle-btn');

    // 페이지 로딩 시 사이드바를 숨김
    sidebar.classList.add('hidden');

    const subMenus = document.querySelectorAll('.nav-down > a');
    subMenus.forEach(function (subMenu) {
        subMenu.addEventListener('click', function (event) {
            event.preventDefault();
            const clickedSubMenu = this.nextElementSibling;
            subMenus.forEach(function (menu) {
                if (menu.nextElementSibling !== clickedSubMenu) {
                    menu.nextElementSibling.classList.remove('active');
                }
            });
            clickedSubMenu.classList.toggle('active');
        });
    });

    toggleBtn.addEventListener('click', function() {
        sidebar.classList.toggle('hidden');
    });

    document.addEventListener('click', function (event) {
        const isClickInside = sidebar.contains(event.target);
        if (!isClickInside && !sidebar.classList.contains('hidden') && !toggleBtn.contains(event.target)) {
            sidebar.classList.add('hidden');
        }
    });
}); //마지막으로 레알 고침

function showPopup() {
    var chatWindowName = "chatRoom";
    var width = 700;
    var height = 900;

    // Calculate the center position for the popup window
    var left = (window.innerWidth - width) / 2 + window.screenX;
    var top = (window.innerHeight - height) / 2 + window.screenY;

    // Open the popup window
    window.open("<%= serverName %><%= ctxPath %>/chatting/multichat.gw", chatWindowName, "width=" + width + ", height=" + height + ", top=" + top + ", left=" + left);
}


</script>
<div class="sidebar" id="sidebar">
    <div class="toggle-btn" onclick="toggleSidebar()">
        <i class="fas fa-bars nav-icon"></i>
        <i class="fas fa-times" style="display: none;"></i>
    </div>
    <ul class="list-unstyled">
        <!-- 홈 항목 추가 -->
        <li class="nav-item">
            <a href="<%= ctxPath %>/index.gw">
                <i class="fa-solid fa-house-user nav-icon"></i>
                <span class="nav-link-text">홈으로</span>
            </a>
        </li>   
     <c:if test="${not empty sessionScope.loginuser && sessionScope.loginuser.email eq 'leess@naver.com'}">
            <!-- 관리자 모드 항목 추가 -->
            <li class="nav-item nav-down">
                <a href="#">
                   <i class="fa-solid fa-user-tie nav-icon"></i>
                    <span class="nav-link-text">관리자 모드</span>
                </a>
                <ul class="list-unstyled sub-menu">
                    <li class="nav-item">
                        <a href="<%= ctxPath %>/emp/empList.gw">
                            <i class="fa-solid fa-people-roof nav-icon"></i>
                            <span class="nav-link-text">인사관리</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="<%= ctxPath %>/emp/department_management.gw">
                            <i class="fa-solid fa-building nav-icon"></i>
                            <span class="nav-link-text">부서관리</span>
                        </a>
                    </li>
                    
                    <li class="nav-item">
                        <a href="<%= ctxPath %>/workflow_b.gw">
                            <i class="fa-solid fa-person-circle-plus nav-icon"></i>
                            <span class="nav-link-text">회원 초대</span>
                        </a>
                    </li>
                </ul>
            </li>
        </c:if>

        <!-- 프로필 항목 추가 -->
        <li class="nav-item">
            <a href="<%= ctxPath %>/myinfo.gw">
                <i class="fa-solid fa-id-card nav-icon nav-icon"></i>
                <span class="nav-link-text">프로필</span>
            </a>
        </li>
          <li class="nav-item">
            <a href="<%= ctxPath %>/chart.gw">
                <i class="fa-solid fa-sitemap nav-icon"></i>
                <span class="nav-link-text">조직도</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="<%= ctxPath %>/digitalmail.gw">
                <i class="fa-solid fa-envelope nav-icon"></i>
                <span class="nav-link-text">웹메일</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="<%= ctxPath %>/noticeboard.gw">
                <i class="fa-solid fa-bullhorn nav-icon"></i>
                <span class="nav-link-text">공지사항</span>
            </a>
        </li>
      <!-- 일정관리 항목 추가 -->
        <li class="nav-item">
            <a href="<%= ctxPath %>/schedule/scheduleManagement.gw">
                <i class="fa-solid fa-calendar-days nav-icon"></i>
                <span class="nav-link-text">일정관리</span>
            </a>
        </li>
        <!-- 채팅 항목 추가 -->
        <li class="nav-item">
            <a onclick="showPopup()">
                <i class="fa-solid fa-comments nav-icon"></i>
                <span class="nav-link-text">채팅</span>
            </a>
        </li>
        <!-- 근무 항목 추가 -->
        <li class="nav-item">
            <a href="<%= ctxPath %>/my_work.gw">
                <i class="fa-solid fa-file-word nav-icon"></i>
                <span class="nav-link-text">근무</span>
            </a>
        </li>
        <!-- 휴가 항목 추가 -->
        <li class="nav-item">
            <a href="<%= ctxPath %>/vacation.gw">
                <i class="fa-solid fa-plane nav-icon"></i>
                <span class="nav-link-text">휴가</span>
            </a>
        </li>
        <!-- 워크플로우 A 항목 추가 -->
        <li class="nav-item">
             <a href="<%= ctxPath %>/approval/home.gw">
                <i class="fa-solid fa-list-check nav-icon"></i>
                <span class="nav-link-text">전자결재</span>
            </a>
        </li>
        <!-- 워크플로우 B 항목 추가 -->
        <li class="nav-item">
            <a href="<%= ctxPath %>/reservation/meetingRoom.gw">
                <i class="fa-brands fa-resolving nav-icon"></i>
                <span class="nav-link-text">자원예약</span>
            </a>
        </li>
        <!-- 급여 항목 추가 -->
        <li class="nav-item">
             <a href="<%= ctxPath %>/salary.gw">
                <i class="fa-solid fa-sack-dollar nav-icon"></i>
                <span class="nav-link-text">급여</span>
            </a>
        </li>
        <!-- 문서 및 증명서 발급 항목 추가 -->
        <li class="nav-item">
             <a href="<%= ctxPath %>/document.gw">
                <i class="fa-regular fa-folder-open nav-icon"></i>
                <span class="nav-link-text">문서 및 증명서 발급</span>
            </a>
        </li>
        <!-- 자유게시판 항목 추가 -->
        <li class="nav-item">
             <a href="<%= ctxPath %>/freeboard.gw">
                <i class="fa-solid fa-face-meh nav-icon"></i>
                <span class="nav-link-text">자유게시판</span>
            </a>
        </li>
    </ul>
</div>
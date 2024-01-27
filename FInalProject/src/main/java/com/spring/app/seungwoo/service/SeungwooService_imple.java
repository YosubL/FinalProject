package com.spring.app.seungwoo.service;


import java.util.*;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;
import com.spring.app.common.GoogleMail;
import com.spring.app.domain.EmployeesVO;
import com.spring.app.domain.JobsVO;
import com.spring.app.domain.TeamVO;
import com.spring.app.seungwoo.model.*;

import net.nurigo.java_sdk.api.Message;
import net.nurigo.java_sdk.exceptions.CoolsmsException;

// ==== #31. Service 선언 ====
// 트랜잭션 처리를 담당하는 곳, 업무를 처리하는 곳, 비지니스(Business)단 
// @Component
@Service
public class SeungwooService_imple implements SeungwooService {

	// === #34. 의존객체 주입하기(DI: Dependency Injection) ===
 	@Autowired  // Type에 따라 알아서 Bean 을 주입해준다.
	private SeungwooDAO dao;
	// Type 에 따라 Spring 컨테이너가 알아서 bean 으로 등록된 com.spring.board.model.BoardDAO_imple 의 bean 을  dao 에 주입시켜준다. 
    // 그러므로 dao 는 null 이 아니다.
	
 	
	// === #37. 시작페이지에서 메인 이미지를 보여주는 것 === //
	@Override
	public List<String> getImgfilenameList() {
		List<String> imgfilenameList = dao.getImgfilenameList();
		return imgfilenameList;
	}

    ////////////////////////////////////////////////////////	
	@Override
	public ModelAndView index(ModelAndView mav) {
		List<String> imgfilenameList = dao.getImgfilenameList();
		
	// System.out.println("~~~ 확인용 imgfilenameList.size() => " + imgfilenameList.size());
	//  ~~~ 확인용 imgfilenameList.size() => 4
			
		mav.addObject("imgfilenameList", imgfilenameList);
		mav.setViewName("main/index.tiles_MTS");
		//  /WEB-INF/views/tiles1/main/index.jsp 파일을 생성한다.
					
		return mav;
	}
    ////////////////////////////////////////////////////////

	// 승우 일단 작업 할 페이지
	@Override
	public ModelAndView workflow_b(ModelAndView mav) {
		
		List<Map<String, String>> unready_member = dao.unready_member();
		
		// System.out.println("뭐들어있노" + unready_member);
		
		List<String> department_List = dao.getdepartmentList();
		
		mav.addObject("unready_member", unready_member);
		mav.addObject("department_List", department_List);
		mav.setViewName("workflow_b/workflow_b.tiles_MTS");
		
		return mav;
	}
		
	// 부서에 해당하는 팀 찾기
	@Override
	public List<TeamVO> searchteam(String deptno) {
		List<TeamVO> teamList = dao.searchteam(deptno);
		return teamList;
	}

	// 팀에 해당하는 직업 찾기
	@Override
	public List<JobsVO> searchjob(String teamno) {
		List<JobsVO> jobList = dao.searchjob(teamno);
		return jobList;
	}
	
	// 시퀀스 채번하기
	@Override
	public String searchseq() {
		String seq = dao.searchseq();
		return seq;
	}

	// 정보에 해당하는 값 받아오기
	@Override
	public Map<String, String> selectinfo(Map<String, String> paraMap) {
		
		Map<String, String> selectinfomap = dao.selectinfo(paraMap);
		
		return selectinfomap;
	}
	

	
	// 정보에 해당하는 값 넣기
	@Override
	public int insertinfo(EmployeesVO empvo) {
		
		int n = dao.insertinfo(empvo);
		return n;
		
	}
	
	@Override
	public int t_m_update(Map<String, String> gradeMap) {
		int n = dao.t_m_update(gradeMap);
		return n;
	}
	
	// 사원 테이블 팀장 번호 업데이트
	@Override
	public int emp_t_m_update(Map<String, String> gradeMap) {
		int n2 = dao.emp_t_m_update(gradeMap);
		return n2;
	}
	
	@Override
	public boolean invitationEmail(EmployeesVO empvo, Map<String, String> selectinfomap) {
		
		String name = empvo.getName();
		String deptname = selectinfomap.get("department_name");
		String teamname = selectinfomap.get("team_name");
		String jobname = selectinfomap.get("job_name");
		String email = empvo.getEmail();
		String phone = empvo.getPhone();
		
		
		GoogleMail mail = new GoogleMail(); 
		
		StringBuilder sb = new StringBuilder();
        
		sb.append("<body>");
        sb.append("<table border='0' cellpadding='0' cellspacing='0' width='100%' bgColor='#F4F5F7' style='padding: 20px 16px 82px; color: #191919;' class='wrapper'>");
        sb.append("<tbody style='display: block; max-width: 600px; margin: 0 auto;'>");
        sb.append("<tr width='100%' style='display: block;'>");
        sb.append("<td width='100%' style='display: block; margin-top: 12%;'>");
		sb.append("<table width='100%' border='0' cellpadding='0' cellspacing='0' bgColor='#FFFFFF' style='display: inline-block; padding: 32px; text-align: left; border-top: 3px solid #22B4E6; border-collapse: collapse;' class='container'>");
		sb.append("<tbody style='display: block;'>");
		sb.append("<tr>");
		sb.append("<td style='padding-bottom: 32px; font-size: 20px; font-weight: bold;'>");
		sb.append("<img width='150' src='http://127.0.0.1:9090/GW/resources/images/headlogo.png'>"); 
		sb.append("</td>");
		sb.append("</tr>");
		sb.append("<tr>");
		sb.append("<td>");
		sb.append("<h1>입사를 환영합니다.</h1>");
		sb.append("</td>");
		sb.append("</tr>");
		sb.append("<tr>");
		sb.append("</tr>");
		sb.append("<tr width='100%' style='display: block; margin-bottom: 32px;'>");
		sb.append("<td width='100%' style='display: block;'>");
		sb.append("<table border='0' cellpadding='0' cellspacing='0' width='100%' bgColor='#F8F9FA' style='padding: 40px 20px; border-radius: 4px; text-align: center;' class='content'>");
		sb.append("<tbody style='display: block;'>");
		sb.append("<tr style='display: block; margin-bottom: 10px;'>");
		sb.append("<td style='display: block; padding-bottom: 16px; font-size: 20px; font-weight: bold; text-align: left;'>");
		sb.append("환영합니다</td>");
		sb.append("</tr>");
		sb.append("<tr>");
		sb.append("<td style ='text-align: left;'>안녕하세요 ");
		sb.append("<span style='color: black; font-weight:bold;'>"+name+"</span> 님 !<br>");
		sb.append("<span style='font-weight: bold; color:#22B4E6'>코퍼레이션</span> "+ deptname +"의  <br> "+teamname+ "&nbsp;" + jobname+ "으로 입사하신것을 진심으로 환영합니다.<br><br>");
		sb.append("<a href= 'http://localhost:9090/FinalProject/register.gw?"+"&email="+email+"'style='color:#22B4E6; font-weight: bold;'>초대를 수락해주세요!</a>");
		sb.append("</td>");
		sb.append("</tr>");
		sb.append("</tbody>");
		sb.append("</table>");
		sb.append("</td>");
		sb.append("</tr>");
		sb.append("<tr>");
		sb.append("<td style='padding-bottom: 24px; color: #A7A7A7; font-size: 12px; line-height: 20px;'>Copyright 2023 flex. All rights reserved. <br> ※ 본 메일은 발신전용이며, 메일 수신 설정은 &nbsp;");
		sb.append("<a href='#' style='color:#22B4E6; font-weight: bold;'>여기</a> 에서 할 수 있습니다.");
		sb.append("</td>");
		sb.append("</tr>");
		sb.append("<tr width='100%' style='display:block; padding-top: 24px; border-top: 1px solid #e9e9e9;'>");
		sb.append("<td style='position: relative; line-height: 20px;'>");
		sb.append("<img height='20' style='vertical-align: middle; padding: 0 5px 0 0;' src='http:http://127.0.0.1:9090/GW/resources/images/headlogo.png'>");
		sb.append("<img height='20' style='vertical-align: middle; border-left: 1px solid #E9E9E9; padding: 0 8px;' src='http://127.0.0.1:9090/GW/resources/images/headlogo.png'>");
		sb.append("</td>");
		sb.append("</tr>");
		
		sb.append("</tbody>");
		sb.append("</table>");
		
		sb.append("</td>");
		sb.append("</tr>");
		
		sb.append("</tbody>");
		sb.append("</table>");
		sb.append("</body>");
		
        String emailContents = sb.toString();
        
        try {
        	mail.sendmail_OrderFinish(name,deptname,teamname,jobname,email,emailContents);
        } catch (Exception e) {
        	e.printStackTrace();
        }
        // 메일 끝나고  
        
        //String api_key = "발급받은 본인의 API Key";  // 발급받은 본인 API Key
        String api_key = "NCSIQDXMOEEYSYZC";  
        
        //String api_secret = "발급받은 본인의 API Secret";  // 발급받은 본인 API Secret
        String api_secret = "OIBOXYYZA7AN4XMMUPO7WATULJYXXAL6";  
        
        Message coolsms = new Message(api_key, api_secret);
        // net.nurigo.java_sdk.api.Message 임. 
        // 먼저 다운 받은  javaSDK-2.2.jar 를 /MyMVC/WebContent/WEB-INF/lib/ 안에 넣어서  build 시켜야 함.
        
        
        System.out.println(phone);
        // == 4개 파라미터(to, from, type, text)는 필수사항이다. == 
        HashMap<String, String> Map = new HashMap<String, String>();
        Map.put("to", phone); // 수신번호
        Map.put("from", "01031417056"); // 발신번호
        Map.put("type", "SMS"); // Message type ( SMS(단문), LMS(장문), MMS, ATA )
        Map.put("text", name +"님 코퍼레이션 GW " + deptname + "에서 입사메일을 전송하였습니다. 확인해주시기 바랍니다.");   
        Map.put("app_version", "JAVA SDK v2.2"); // application name and version
        try {
        	JSONObject jsonObj = (JSONObject) coolsms.send(Map);
    	} catch (CoolsmsException e2) {
    		e2.printStackTrace();
    	}
        
		return true;
	}

	@Override
	public EmployeesVO email_uq(String uq_email) {
		EmployeesVO empvo = dao.email_uq(uq_email); 
		return empvo;
	}

	// 부서장 팀장 중복여부 체크
	@Override
	public EmployeesVO emptyjob(String jobno) {
		EmployeesVO empvo = dao.emptyjob(jobno); 
		return empvo;
	}
	
	
	// dept, team 테이블 책임자 번호 업데이트
	@Override
	public int dept_team_update(Map<String, String> upMap) {
		int dept_team = dao.dept_team_update(upMap);
		return dept_team;
	}
	
	// emp테이블  dept, team 테이블 책임자 번호 업데이트
	@Override
	public int emp_dept_team(Map<String, String> upMap) {
		int emp_dept_team = dao.emp_dept_team(upMap);
		return emp_dept_team;
	}
	
	// 최종적으로 대기회원 삭제
	@Override
	public int last_unreadydel(Map<String, Object> empidMap) {
		int del = dao.last_unreadydel(empidMap);
		return del;
	}
	

	






	


}

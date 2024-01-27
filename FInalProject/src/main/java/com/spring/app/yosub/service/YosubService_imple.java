package com.spring.app.yosub.service;

import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import com.spring.app.digitalmail.domain.EmailVO;
import com.spring.app.domain.Calendar_schedule_VO;
import com.spring.app.domain.DraftVO;
import com.spring.app.domain.EmployeesVO;
// import com.spring.app.common.AES256;
import com.spring.app.yosub.model.*;


@Service
public class YosubService_imple implements YosubService {

 	@Autowired  // Type에 따라 알아서 Bean 을 주입해준다.
	private YosubDAO dao;

 	@Override
	public ModelAndView index(ModelAndView mav, HttpServletRequest request) {

 		HttpSession session = request.getSession();
	    EmployeesVO loginuser = (EmployeesVO) session.getAttribute("loginuser"); 
		
		mav.addObject("loginuser", loginuser);
		
		Map<String, Object> paraMap = new HashMap<>();
		
		// System.out.println("loginuser.getEmployee_id()"+loginuser.getEmployee_id());
		
		paraMap.put("empno", loginuser.getEmployee_id());
		paraMap.put("email", loginuser.getEmail());
		
		// 전체 글 개수 구하기
		int requestedDraftCnt = dao.getRequestedDraftCnt(paraMap);
		// System.out.println("requestedDraftCnt"+requestedDraftCnt);
		
		List<EmailVO> emailVOList = null;
		emailVOList = dao.SelectMyEmail_withPaging(paraMap);
		List<DraftVO> processingDraftList = dao.getMyDraftProcessing(loginuser.getEmployee_id());
		List<DraftVO> processedDraftList = dao.getMyDraftProcessed(loginuser.getEmployee_id());
		mav.addObject("emailVOList", emailVOList);
		mav.addObject("requestedDraftCnt", requestedDraftCnt);
		mav.addObject("processingDraftList", processingDraftList);
		mav.addObject("processedDraftList", processedDraftList);
		
		mav.setViewName("main/index.tiles_MTS");
		//  /WEB-INF/views/tiles1/main/index.jsp 파일을 생성한다.
					
		return mav;
	} // public ModelAndView index(ModelAndView mav) {
    ////////////////////////////////////////////////////////

	@Override
	public ModelAndView login(ModelAndView mav) {
		
		mav.setViewName("login/loginform.tiles_MTS2");
		
		return mav;
	} // public ModelAndView login(ModelAndView mav) {
	
	

	///////////////////////////////////////////////////////////////////////////  
	@Override
	public ModelAndView loginEnd(ModelAndView mav, Map<String, String> paraMap, HttpServletRequest request) {
		
		EmployeesVO loginuser = dao.getLoginMember(paraMap);
		
				
		if(loginuser == null) { // 로그인 실패시
			String message = "아이디 또는 암호가 틀립니다.";
	 		String loc = request.getHeader("referer");
			
			mav.addObject("message", message);
			mav.addObject("loc", loc);
			
			mav.setViewName("msg");
	
		}
		else { // 아이디와 암호가 존재하는 경우 
			
			
			if("1".equals(loginuser.getIdle())) { // 로그인 한지 1년이 경과한 경우
				
				String message = "현재 휴직 상태 입니다.\\n관리자에게 문의 바랍니다.";
				String loc = request.getContextPath()+"/index.gw";

				
				mav.addObject("message", message);
				mav.addObject("loc", loc);
				
				mav.setViewName("msg");
			}
			
			else {	// 로그인 한지 1년 이내인 경우
				
				HttpSession session = request.getSession();
				// 메모리에 생성되어져 있는 session 을 불러온다.
				
				session.setAttribute("loginuser", loginuser);
					String goBackURL = (String) session.getAttribute("goBackURL");
					
					if(goBackURL != null) {
						mav.setViewName("redirect:"+goBackURL);
						session.removeAttribute("goBackURL"); // 세션에서 반드시 제거해주어야 한다. 
					}
					else {
						mav.setViewName("redirect:/index.gw"); // 시작페이지로 이동
					}
				}
			}
		
		
		return mav;
	} // public ModelAndView loginEnd(ModelAndView mav, Map<String, String> paraMap, HttpServletRequest request) {

    ///////////////////////////////////////////////////////////////////////////

	// 로그아웃 처리하기
	@Override
	public ModelAndView logout(ModelAndView mav, HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		session.invalidate();
		
		String message = "로그아웃 되었습니다.";
		String loc = request.getContextPath()+"/index.gw";
		
		mav.addObject("message", message);
		mav.addObject("loc", loc);
		
		mav.setViewName("msg");
		
		return mav;
	}// end of 	public ModelAndView logout(ModelAndView mav, HttpServletRequest request) {

	@Override
	public List<Calendar_schedule_VO> scheduleselect(Map<String, Object> paraMap) {

		List<Calendar_schedule_VO> scheduleselectList = dao.scheduleselect(paraMap);
		
		return scheduleselectList;
	}

	
}

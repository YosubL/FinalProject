package com.spring.app.yosub.controller;

import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.spring.app.common.Sha256;
import com.spring.app.domain.Calendar_schedule_VO;
import com.spring.app.domain.EmployeesVO;
import com.spring.app.yosub.service.*;
		
	@Controller
	public class IndexController {

	   @Autowired 
	   private YosubService service;
	
	   // ========= ******* 그룹웨어 시작 ******* ========= //  
	   
	   // === 메인페이지 요청 === //
	   // 먼저, com.spring.app.HomeController 에 가서 @Controller 를 주석 처리한다.
	   @GetMapping("/")
	   public ModelAndView home(ModelAndView mav) {
		   mav.setViewName("redirect:/index.gw");
		   return mav;
	   } // end of public ModelAndView home(ModelAndView mav)
		   
	   // === 또는 === //   
	   @GetMapping("/index.gw")
	   public ModelAndView requiredLogin_index(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		      
			   mav = service.index(mav,request);
		   
		   return mav;
	   } // end of public ModelAndView home(ModelAndView mav)
	   
	   // ==== 로그인 폼 페이지 요청 ==== //
	   @GetMapping("/login.gw")
	   public ModelAndView login(ModelAndView mav) {
		   
		   mav = service.login(mav);
		   
		   return mav;
	   } // end of public ModelAndView login(ModelAndView mav)
	   	   
	   // 로그인 처리하기
	   @PostMapping("/loginEnd.gw")
	   public ModelAndView loginEnd(ModelAndView mav, HttpServletRequest request) {
		   
		   String email = request.getParameter("email");
		   String pwd = request.getParameter("pwd");
		   
		   Map<String, String> paraMap = new HashMap<>();
		   
		   paraMap.put("email", email);
		   paraMap.put("pwd", Sha256.encrypt(pwd));
		   
		   mav = service.loginEnd(mav, paraMap, request); 
		   
		   return mav;
	   } // end of public ModelAndView loginEnd(ModelAndView mav, HttpServletRequest request)
	   
	   
	   // 로그아웃 처리하기
	   @GetMapping("/logout.gw")
	   public ModelAndView logout(ModelAndView mav, HttpServletRequest request) {
		   
		   mav = service.logout(mav, request);
		   
		   return mav;
	   } // end ofpublic ModelAndView logout(ModelAndView mav, HttpServletRequest request) 
	   
	   
	   @ResponseBody
	   @GetMapping(value ="scheduleselect.gw", produces="text/plain;charset=UTF-8")
	   public String scheduleselect(HttpServletRequest request) {
		   
		   HttpSession session = request.getSession();
		   EmployeesVO loginuser = (EmployeesVO) session.getAttribute("loginuser"); 
		   //System.out.println("fk_employee_id" + loginuser.getEmployee_id());
		   //System.out.println("fk_department_id" + loginuser.getFk_department_id());
		   //System.out.println("fk_email" + loginuser.getEmail());

		   
		   Map<String, Object> paraMap = new HashMap<>();
		   
		   paraMap.put("fk_employee_id", loginuser.getEmployee_id());
		   paraMap.put("fk_department_id", loginuser.getFk_department_id());
		   paraMap.put("fk_email", loginuser.getEmail());
		   
		   List<Calendar_schedule_VO> scheduleselectList = service.scheduleselect(paraMap);
		   
		   JsonArray jsonArr = new JsonArray(); // []
			if(scheduleselectList != null && scheduleselectList.size() > 0) {
				for(Calendar_schedule_VO schedule : scheduleselectList) {
					JsonObject jsonObj = new JsonObject(); // {}
					jsonObj.addProperty("scheduleno", schedule.getScheduleno());
					jsonObj.addProperty("startdate", schedule.getStartdate());
					jsonObj.addProperty("enddate", schedule.getEnddate());
					jsonObj.addProperty("subject", schedule.getSubject());
					jsonObj.addProperty("content", schedule.getContent());
					jsonObj.addProperty("fk_smcatgono", schedule.getFk_smcatgono());
					jsonObj.addProperty("fk_lgcatgono", schedule.getFk_lgcatgono());
					jsonObj.addProperty("fk_department_id", schedule.getFk_department_id());
					jsonObj.addProperty("fk_employee_id", schedule.getFk_employee_id());
					jsonObj.addProperty("joinuser", schedule.getJoinuser());
					jsonArr.add(jsonObj); 

				}// end of for-------------------------
			}
			return new Gson().toJson(jsonArr);
		   
	   }  
	   
	   
	   
	   
	   
	   
	   
	   
	   
	   
	   
	}
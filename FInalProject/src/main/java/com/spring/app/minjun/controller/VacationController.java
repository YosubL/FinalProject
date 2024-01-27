package com.spring.app.minjun.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.ModelAndViewDefiningException;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.spring.app.domain.*;
import com.spring.app.minjun.service.*;
		
@Controller
public class VacationController {
   
	@Autowired // Type에 따라 알아서 Bean 을 주입해준다.
	private VacationService service;
   
	// ========= ******* 그룹웨어 시작 ******* ========= //  
	// 휴가 메인 페이지 이동
	@RequestMapping("/vacation.gw")
	public ModelAndView requiredLogin_vacation(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
		HttpSession session = request.getSession();
        EmployeesVO loginuser = (EmployeesVO) session.getAttribute("loginuser");
        
        String employee_id = loginuser.getEmployee_id(); // 로그인 한 유저의 employee_id 정보
        
        request.setAttribute("employee_id", employee_id); // 로그인 한 유저의 사원번호
    
        VacationVO vacationInfo = service.vacation_select(employee_id);
        String annual = vacationInfo.getAnnual();
        String childbirth =  vacationInfo.getChildbirth();
        String family_care = vacationInfo.getFamily_care();
        String infertility_treatment = vacationInfo.getInfertility_treatment();
        String marriage = vacationInfo.getMarriage();
        String reserve_forces = vacationInfo.getReserve_forces();
        String reward = vacationInfo.getReward();
        
        request.setAttribute("annual", annual);
        request.setAttribute("childbirth", childbirth);
        request.setAttribute("family_care", family_care);
        request.setAttribute("infertility_treatment", infertility_treatment);
        request.setAttribute("marriage", marriage);
        request.setAttribute("reserve_forces", reserve_forces);
        request.setAttribute("reward", reward);
        
		mav.setViewName("my_time_off/vacation.tiles_MTS");
		return mav;
	}
	
	
	// 연차 신청시 휴가관리 테이블에 insert하기
	@RequestMapping("/annual.gw")
	public ModelAndView annual(ModelAndView mav,
							    HttpServletRequest request,
							    VacationVO vacationvo,
							    Vacation_manageVO vacation_managevo,
							    @RequestParam("vacation_start_date") String vacation_start_date,
					            @RequestParam("vacation_end_date") String vacation_end_date,
					            @RequestParam("daysDiff") String daysDiff,
					            @RequestParam("vacation_reason") String vacation_reason,
					            @RequestParam("vacation_type") String vacation_type
							) {

		// === 휴가 신청에 필요한 로그인 유저의 employee_id 가져오기 [시작] ===
		HttpSession session = request.getSession();
        EmployeesVO loginuser = (EmployeesVO) session.getAttribute("loginuser");
        
        String employee_id = loginuser.getEmployee_id(); // 로그인 한 유저의 employee_id 정보
        
		Map<String, String> paraMap = new HashMap<>();
		
		paraMap.put("employee_id", employee_id);
		paraMap.put("vacation_start_date", vacation_start_date);
		paraMap.put("vacation_end_date", vacation_end_date);
		paraMap.put("daysDiff", daysDiff);
		paraMap.put("vacation_reason", vacation_reason);
		paraMap.put("vacation_type", vacation_type);
		paraMap.put("vacation_manager", loginuser.getManager_id());
		
		// 연차 신청시 휴가관리 테이블에 insert하기
		int n = service.annual_insert(paraMap);
		
		if(n==1) {
            mav.addObject("message", "휴가 신청 완료");
            mav.addObject("loc", request.getContextPath()+"/vacation.gw");
            mav.setViewName("msg");
         }
         else {
            mav.addObject("message", "남은연차가 신청 연차보다 적습니다");
            mav.addObject("loc", request.getContextPath()+"/vacation.gw");
            mav.setViewName("msg");
         }

		return mav;
	}
	
	// 연차 상세 페이지 이동
	@GetMapping("/vacation_detail.gw")
	public ModelAndView requiredLogin_vacation_list(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
		HttpSession session = request.getSession();
        EmployeesVO loginuser = (EmployeesVO) session.getAttribute("loginuser");
		
        String employee_id = loginuser.getEmployee_id(); // 로그인 한 유저의 employee_id 정보
        
        // 특정 사용자의 승인완료된 휴가 가져오기
        List<Vacation_manageVO> myHoldList = service.myHoldList(employee_id);
        
		// 특정 사용자의 승인완료된 휴가 가져오기
        List<Vacation_manageVO> myApprovedList = service.myApprovedList(employee_id);
        
        // 특정 사용자의 반려된 휴가 가져오기
        List<Vacation_manageVO> myReturnList = service.myReturnList(employee_id);
		
        mav.addObject("employee_id", employee_id);
        mav.addObject("myHoldList", myHoldList);
        mav.addObject("myApprovedList", myApprovedList);
        mav.addObject("myReturnList", myReturnList);
		
		mav.setViewName("my_time_off/vacation_detail.tiles_MTS");
		return mav;
	} 
	
	
	// 연차 계획 페이지 이동
	@GetMapping("/vacation_plan.gw")
	public ModelAndView requiredLogin_vacation_plan(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		mav.setViewName("my_time_off/vacation_plan.tiles_MTS");
		return mav;
	} 
	
	
	////////////////////////////[휴가 관리자용 시작]//////////////////////////////
	// 휴가 관련 관리자 전용 페이지 이동 
	@RequestMapping("/vacation_manage.gw")
	public ModelAndView requiredLogin_vacation_manage(HttpServletRequest request, HttpServletResponse response, ModelAndView mav, Vacation_manageVO vacation_managevo) {
		
		HttpSession session = request.getSession();
        EmployeesVO loginuser = (EmployeesVO) session.getAttribute("loginuser");
        
        String employee_id = loginuser.getEmployee_id(); // 로그인한 유저의 사원번호
        
		if(Integer.parseInt(loginuser.getGradelevel()) < 3) { // 로그인한 유저의 gradelevel 이 5 미만인 경우
			
			mav.addObject("message", "관리 권한이 없습니다.");
			mav.addObject("loc", request.getContextPath()+"/vacation.gw");
            mav.setViewName("msg");
        }
        else { // 로그인한 유저의 gradelevel 이 5 이상인 경우, 부서장급 이상
        	
        	// 회원들의 신청된 휴가 중 대기중인 회원 가져오기
            List<Vacation_manageVO> vacList = service.vacList(employee_id);
            
            // 대기중인 휴가 갯수 알아오기
        	String total_count = service.total_count(employee_id);
        	
            // 회원들의 신청된 휴가 중 반려된 회원 가져오기
            List<Vacation_manageVO> vacReturnList = service.vacReturnList(employee_id);
            
            // 회원들의 신청된 휴가 중 승인된 회원 가져오기
            List<Vacation_manageVO> vacApprovedList = service.vacApprovedList(employee_id);
            
        	mav.addObject("total_count", total_count);
            mav.addObject("vacList", vacList);
            mav.addObject("vacReturnList", vacReturnList);
            mav.addObject("vacApprovedList", vacApprovedList);
    		mav.setViewName("my_time_off/vacation_manage.tiles_MTS");
        }
		return mav;
	}
	
	// ==== 휴가 승인 [시작] ==== //
	// 휴가 승인시 휴가관리테이블 업데이트 하기.
	@RequestMapping("vacUpdate.gw")
	public ModelAndView vacUpdate(Vacation_manageVO vvo, HttpServletRequest request, ModelAndView mav) {
		
		// jsp 에서 가져온 값
		String vacation_seq = request.getParameter("vacation_seq"); 			  // 휴가번호
		String vacation_start_date = request.getParameter("vacation_start_date"); // 시작일자
		String vacation_end_date = request.getParameter("vacation_end_date"); 	  // 종료일자
		String fk_employee_id = request.getParameter("fk_employee_id"); 		  // 사원번호
		String vacation_type = request.getParameter("vacation_type"); 	  		  // 휴가종류
		String daysDiff = request.getParameter("daysDiff"); 					  // 날짜차이
		String fk_department_id = request.getParameter("fk_department_id"); 	  // 부서번호
		String name = request.getParameter("name"); 	  						  // 이름
		String email = request.getParameter("email"); 	  						  // 이메일
		
		String[] vacation_seq_arr = vacation_seq.split(",");
		String[] vacation_start_date_arr = vacation_start_date.split(",");
		String[] vacation_end_date_arr = vacation_end_date.split(",");
		String[] fk_employee_id_arr = fk_employee_id.split(",");
		String[] vacation_type_arr = vacation_type.split(",");
		String[] daysDiff_arr = daysDiff.split(",");
		String[] fk_department_id_arr = fk_department_id.split(",");
		String[] name_arr = name.split(",");
		String[] email_arr = email.split(",");
		
		Map<String, String[]> paraMap = new HashMap<>();
		
		paraMap.put("vacation_seq_arr", vacation_seq_arr);
		paraMap.put("vacation_start_date_arr", vacation_start_date_arr);
		paraMap.put("vacation_end_date_arr", vacation_end_date_arr);
		paraMap.put("fk_employee_id_arr", fk_employee_id_arr);
		paraMap.put("vacation_type_arr", vacation_type_arr);
		paraMap.put("daysDiff_arr", daysDiff_arr);
		paraMap.put("fk_department_id_arr", fk_department_id_arr);
		paraMap.put("name_arr", name_arr);
		paraMap.put("email_arr", email_arr);
		 
		try {
			int n = service.vacManage_Update(paraMap);
			
			if(n>0) {
				mav.addObject("message", "결재가 완료되었습니다.");
				mav.addObject("loc", request.getContextPath()+"/vacation_manage.gw");
				mav.setViewName("msg");
			}
			else {
				mav.addObject("message", "남은 연차가 사용 연차보다 적습니다.");
				mav.addObject("loc", request.getContextPath()+"/vacation.gw");
				mav.setViewName("msg");
			}
			
   		} catch (Throwable e) {
   			e.printStackTrace();
   		}
		return mav;
	}
	
	// === 대기중인휴가의 totalPage 알아오기(JSON 으로 처리) === //
	@ResponseBody
	@GetMapping(value="getVacationTotalPage.action")
	public String getVacationTotalPage(HttpServletRequest request) {
		
		HttpSession session = request.getSession();
        EmployeesVO loginuser = (EmployeesVO) session.getAttribute("loginuser");
        
        String employee_id = loginuser.getEmployee_id(); // 로그인한 유저의 사원번호
		
		String vacation_confirm = request.getParameter("vacation_confirm");
		String sizePerPage = request.getParameter("sizePerPage");
		
	   
		Map<String, String> paraMap = new HashMap<>();
	   
		paraMap.put("vacation_confirm", vacation_confirm);
		paraMap.put("sizePerPage", sizePerPage);
		paraMap.put("employee_id", employee_id);
	   
		int totalPage = service.getVactionTotalPage(paraMap); // 대기중인휴가의 totalPage 수 알아오기
	   
		JSONObject jsonObj = new JSONObject(); // {}
		jsonObj.put("totalPage", totalPage);   // {"totalPage":"21"}
		
		return jsonObj.toString();
	}
	// ==== 휴가 승인 [끝] ==== //
	
	
	// ==== 휴가 반려 [시작] ==== //
	// 휴가 반려시 반려테이블에 insert & update 동시에 하기 (트랜젝션 처리해야함)
	@RequestMapping("vacInsert_return.gw")
	public ModelAndView vacInsert_return(HttpServletRequest request, ModelAndView mav) {
		
		String vacation_return_reason = request.getParameter("return_reason"); // 반려사유
		String vacation_seq = request.getParameter("vacation_seq"); // 휴가번호
		String employee_id = request.getParameter("employee_id"); // 휴가신청자 id
		
		HttpSession session = request.getSession();
        EmployeesVO loginuser = (EmployeesVO) session.getAttribute("loginuser");
        
        String loginuser_name = loginuser.getName(); // 관리자 이름
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("vacation_return_reason", vacation_return_reason);
		paraMap.put("vacation_seq", vacation_seq);
		paraMap.put("employee_id", employee_id);
		paraMap.put("loginuser_name", loginuser_name);
		
		try {
			int n = service.vacInsert_return(paraMap);

			mav.addObject("message", "결재가 완료되었습니다.");
			mav.addObject("loc", request.getContextPath()+"/vacation_manage.gw");
			mav.setViewName("msg");
   		} catch (Throwable e) {
   			e.printStackTrace();
   		}
		return mav;
	}
	
	// ==== 휴가 반려 [끝] ==== //
	
	
	////////////////////////////[휴가 관리자용 끝]//////////////////////////////
	
	
	// 휴가 재신청 하기 위한 insert
	@PostMapping("/vac_insert_insert.gw")
	public ModelAndView vac_insert_insert(ModelAndView mav, HttpServletRequest request) {
		
		String vacation_seq = request.getParameter("vacation_seq");
		String vacation_type = request.getParameter("vacation_type");
		String vacation_manager = request.getParameter("manager_id");
		String fk_employee_id = request.getParameter("employee_id");
		String vacation_reason = request.getParameter("frm_vacation_reason");
		String vacation_start_date = request.getParameter("frm_vacation_start_date");
		String vacation_end_date = request.getParameter("frm_vacation_end_date");
		
		Map<String, String> paraMap = new HashMap<>();
		
		paraMap.put("vacation_seq", vacation_seq);
		paraMap.put("vacation_type", vacation_type);
		paraMap.put("vacation_manager", vacation_manager);
		paraMap.put("fk_employee_id", fk_employee_id);
		paraMap.put("vacation_reason", vacation_reason);
		paraMap.put("vacation_start_date", vacation_start_date);
		paraMap.put("vacation_end_date", vacation_end_date);
		
		int n = service.vac_insert_insert(paraMap);
		
		if(n==1) {
			mav.addObject("message", "상신이 완료되었습니다.");
			mav.addObject("loc", request.getContextPath()+"/vacation_detail.gw");
			mav.setViewName("msg");
		}
		else {
			mav.addObject("message", "남은 연차가 사용 연차보다 적습니다.");
			mav.addObject("loc", request.getContextPath()+"/vacation.gw");
			mav.setViewName("msg");
		}
		
		return mav;
	}
	
	
	// 승인 대기중인 휴가 삭제하기
	@PostMapping("/seq_delete.gw")
	public String seq_delete(HttpServletRequest request) {
		
		String vacation_seq = request.getParameter("vacation_seq");
		
		service.seq_delete(vacation_seq);
		
		return "redirect:/vacation_detail.gw";
	}
	
	
	////////////////////////////////////////////////////////////////////////
	// 휴가 통계 페이지 이동
	@GetMapping("/vacation_chart.gw")
	public ModelAndView requiredLogin_vacation_chart(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
		mav.setViewName("my_time_off/vacation_chart.tiles_MTS");
		return mav;
	}
	
	// 차트그리기 (ajax) 월별 휴가사용 수
	@ResponseBody
	@RequestMapping(value="monthlyVacCnt.gw", produces="text/plain;charset=UTF-8")
	public String monthlyVacCnt() {
		
		List<Map<String, String>> monthlyVacCntList = service.monthlyVacCnt();
		
		JsonArray jsonArr = new JsonArray(); // []
		
		for(Map<String, String> map : monthlyVacCntList) {
			JsonObject jsonObj = new JsonObject(); // {}
			jsonObj.addProperty("nowMonth11", map.get("nowMonth11"));
			jsonObj.addProperty("nowMonth10", map.get("nowMonth10"));
			jsonObj.addProperty("nowMonth9", map.get("nowMonth9"));
			jsonObj.addProperty("nowMonth8", map.get("nowMonth8"));
			jsonObj.addProperty("nowMonth7", map.get("nowMonth7"));
			jsonObj.addProperty("nowMonth6", map.get("nowMonth6"));
			jsonObj.addProperty("nowMonth5", map.get("nowMonth5"));
			jsonObj.addProperty("nowMonth4", map.get("nowMonth4"));
			jsonObj.addProperty("nowMonth3", map.get("nowMonth3"));
			jsonObj.addProperty("nowMonth2", map.get("nowMonth2"));
			jsonObj.addProperty("nowMonth1", map.get("nowMonth1")); 
			jsonObj.addProperty("nowMonth", map.get("nowMonth"));
			
			jsonArr.add(jsonObj); 
		} // end of for------------------------
		
		return new Gson().toJson(jsonArr);
	}
	
}
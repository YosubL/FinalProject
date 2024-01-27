package com.spring.app.saehan.controller;

import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.collections4.map.HashedMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.spring.app.common.MyUtil;
import com.spring.app.domain.CelebratePayVO;
import com.spring.app.domain.EmployeesVO;
import com.spring.app.saehan.service.CelebratePaySaehanService;

@Controller
public class CelebratePayController {
	
	
	@Autowired
	private CelebratePaySaehanService service;
	
	
	//복지 포인트 신청
	@RequestMapping(value="/CelebratePay.gw")
	public ModelAndView CelebratePay_application(HttpServletRequest request, ModelAndView mav, CelebratePayVO cvo) {

		HttpSession session = request.getSession();
		EmployeesVO loginuser = (EmployeesVO)session.getAttribute("loginuser");
		
		String method= request.getMethod();

		if("POST".equals(method)){
			
			int n = service.receiptCelebrate(cvo);
			
			if(n != 1) {
				String message = "신청이 취소됐습니다.";
				String loc = "javascript:history.back()";
				
				mav.addObject("message", message);
				mav.addObject("loc", loc);
				return mav;
			}
			
			mav.addObject("cvo", cvo);
			mav.setViewName("redirect:/celebrateList.gw");
			return mav;
		}
		
		mav.addObject("loginuser", loginuser);
		mav.setViewName("CelebratePay/CelebratePay_application.tiles_MTS");
		return mav;
	}
	
	//특정사용자의 복지포인트 신청 대기,승인 완료,반려 목록 가져오기
	@GetMapping(value="/celebrateList.gw")
	public ModelAndView celebrateList(HttpServletRequest request, HttpServletResponse response, ModelAndView mav){
		
		HttpSession session = request.getSession();
        EmployeesVO loginuser = (EmployeesVO) session.getAttribute("loginuser");
        
        String employee_id = loginuser.getEmployee_id(); // 로그인 한 유저의 employee_id 정보
        
        List<CelebratePayVO> CelebratePay_HoldList = service.CelebratePay_HoldList(employee_id);
        List<CelebratePayVO> CelebratePay_completeList = service.CelebratePay_completeList(employee_id);
        List<CelebratePayVO> CelebratePay_rejectList = service.CelebratePay_rejectList(employee_id);

        mav.addObject("employee_id", employee_id);
        mav.addObject("CelebratePay_HoldList", CelebratePay_HoldList);
        mav.addObject("CelebratePay_completeList", CelebratePay_completeList);
        mav.addObject("CelebratePay_rejectList", CelebratePay_rejectList);
        
		mav.setViewName("CelebratePay/CelebratePay_List.tiles_MTS");
		return mav;
		
	}
	

	// 승인 대기중인 복지포인트 신청 한 개 삭제하기
	@PostMapping("/celebrate_delete.gw")
	public String celebrate_seq_delete(HttpServletRequest request) {
			
		String app_no = request.getParameter("app_no");
			
		service.celebrate_delete(app_no);
			
		return "redirect:/celebrateList.gw";
	}


	//관리자 직원관리 - 모든 복지포인트 결제 대기 신청 현황
	@GetMapping(value="/CelebratePayStatus.gw")
	public String CelebrateStatus_list(HttpServletRequest request, CelebratePayVO cvo,
			@RequestParam(defaultValue = "") String deptName,
			@RequestParam(defaultValue = "") String title,
			@RequestParam(defaultValue = "") String gender,
			@RequestParam(defaultValue = "") String app_date,
			@RequestParam(defaultValue = "") String name) {
		
		//부서이름 가져오기
		List<Map<String, String>> deptNameList = service.deptName();
		
		Map<String, String> paraMap = new HashedMap<>();
		   
		paraMap.put("deptName", deptName);
		paraMap.put("title", title);	
		paraMap.put("gender", gender);	
		paraMap.put("app_date",app_date);
		paraMap.put("name",name);
		List<CelebratePayVO> CelebrateStatusList = service.getCelebrateStatus(paraMap);
		 
		String goBackURL = MyUtil.getCurrentURL(request);
		
		request.setAttribute("goBackURL", goBackURL);
		request.setAttribute("deptNameList",deptNameList);
		request.setAttribute("CelebrateStatusList", CelebrateStatusList);
		
		return "CelebratePay/CelebratePay_Status.tiles_MTS";
	}
	
	
	//승인시 복지포인트 테이블 업데이트 하기.
	@RequestMapping("CelebrateStatus_Update.gw")
	public ModelAndView CelebrateStatus_Update(CelebratePayVO cvo, HttpServletRequest request, ModelAndView mav) {
			
		// jsp 에서 가져온 값
		String app_no = request.getParameter("app_no"); 

		String[] app_no_arr = app_no.split(",");
		
		Map<String, String[]> paraMap = new HashMap<>();
		
		paraMap.put("app_no_arr", app_no_arr);

		try {
			int n = service.CelebrateStatus_Update(paraMap);
			
			if(n>0) {
				mav.addObject("message", "결재가 완료되었습니다.");
				mav.addObject("loc", request.getContextPath()+"/CelebratePayStatus.gw");
				mav.setViewName("msg");
			}
			else {
				mav.addObject("message", "결제가 실패했습니다.");
				mav.addObject("loc", request.getContextPath()+"/CelebratePayStatus.gw");
				mav.setViewName("msg");
			}
			
   		} catch (Throwable e) {
   			e.printStackTrace();
   		}
			return mav;
	}
	
	
	//반려시 복지포인트 테이블 업데이트 하기.
	@RequestMapping("CelebrateStatus_reject.gw")
	public ModelAndView CelebrateStatus_reject(CelebratePayVO cvo, HttpServletRequest request, ModelAndView mav) {
			
		// jsp 에서 가져온 값
		String app_no = request.getParameter("app_no"); 
		
		String[] app_no_arr = app_no.split(",");
		Map<String, String[]> paraMap = new HashMap<>();
		
		paraMap.put("app_no_arr", app_no_arr);
		
		try {
			int n = service.CelebrateStatus_reject(paraMap);
			
			if(n>0) {
				mav.addObject("message", "결재가 완료되었습니다.");
				mav.addObject("loc", request.getContextPath()+"/CelebratePayStatus.gw");
				mav.setViewName("msg");
			}
			else {
				mav.addObject("message", "결재가 실패했습니다.");
				mav.addObject("loc", request.getContextPath()+"/CelebratePayStatus.gw");
				mav.setViewName("msg");
			}
			
   		} catch (Throwable e) {
   			e.printStackTrace();
   		}
		return mav;
	}
	
	//관리자 직원관리 - 모든 복지포인트 결제 완료 현황
	@GetMapping(value="/CelebrateComplete.gw")
	public String CelebrateComplete_list(HttpServletRequest request, CelebratePayVO cvo,
			@RequestParam(defaultValue = "") String deptName,
			@RequestParam(defaultValue = "") String title,
			@RequestParam(defaultValue = "") String gender,
			@RequestParam(defaultValue = "") String app_status,
			@RequestParam(defaultValue = "") String app_date,
			@RequestParam(defaultValue = "") String name) {
		
		 Map<String, String> paraMap = new HashedMap<>();
		   
		 paraMap.put("deptName", deptName);
		 paraMap.put("title", title);	
		 paraMap.put("gender", gender);	
		 paraMap.put("app_status", app_status);	
		 paraMap.put("app_date", app_date);
		 paraMap.put("name", name);
		 
		 String goBackURL = MyUtil.getCurrentURL(request);
		
		List<CelebratePayVO> CelebrateCompleteList = service.getCelebrateComplete(paraMap);
		
		List<Map<String, String>> deptNameList = service.deptName();
		
		request.setAttribute("goBackURL", goBackURL);
		request.setAttribute("deptNameList", deptNameList);
		request.setAttribute("CelebrateCompleteList", CelebrateCompleteList);
		return "CelebratePay/CelebratePay_Complete.tiles_MTS";
	}
	
	
	//관리자 직원 관리 - 모든 복지포인트 결제 취소 하기
	@RequestMapping(value="/CelebrateStatus_close.gw")
	public ModelAndView CelebrateStatus_close(HttpServletRequest request, CelebratePayVO cvo, ModelAndView mav) {
		
		// jsp 에서 가져온 값
		String app_no = request.getParameter("app_no"); 
		
		String[] app_no_arr = app_no.split(",");
	
		Map<String, String[]> paraMap = new HashMap<>();
		
		paraMap.put("app_no_arr", app_no_arr);
		
		try {
			int n = service.CelebrateStatus_close(paraMap);
			
			if(n>0) {
				mav.addObject("message", "결재가 취소되었습니다.");
				mav.addObject("loc", request.getContextPath()+"/CelebratePayStatus.gw");
				mav.setViewName("msg");
			}
			else {
				mav.addObject("message", "결재가 취소가 실패 했습니다..");
				mav.addObject("loc", request.getContextPath()+"/CelebratePayStatus.gw");
				mav.setViewName("msg");
			}
			
   		} catch (Throwable e) {
   			e.printStackTrace();
   		}
		return mav;
	}

	
	

	
	
	
	
}

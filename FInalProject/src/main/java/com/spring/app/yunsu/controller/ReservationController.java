package com.spring.app.yunsu.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.spring.app.common.MyUtil;
import com.spring.app.common.Pagination;
import com.spring.app.domain.EmployeesVO;
import com.spring.app.domain.ReservLargeCategoryVO;
import com.spring.app.domain.ReservSmallCategoryVO;
import com.spring.app.domain.ReservationVO;
import com.spring.app.yunsu.service.ReservationService;

import net.nurigo.sdk.NurigoApp;
import net.nurigo.sdk.message.exception.NurigoMessageNotReceivedException;
import net.nurigo.sdk.message.model.Message;
import net.nurigo.sdk.message.service.DefaultMessageService;



@Controller
public class ReservationController {

	@Autowired
	private ReservationService service;
	
	/////////////////////////////////////////////////////////////////////////////////////////////////
	
	// === 자원예약 회의실 예약 페이지 === //
	@RequestMapping(value="/reservation/meetingRoom.gw")
	public ModelAndView meetingRoom(HttpServletRequest request, ModelAndView mav) { 
		
		String lgcatgono = "1";
		
		// 자원 안내 내용 보여주기
		ReservLargeCategoryVO lvo = service.mainLgcategContent(lgcatgono);
		mav.addObject("lvo",lvo);		
		
		String listgobackURL_reserv = MyUtil.getCurrentURL(request);
		mav.addObject("listgobackURL_reserv",listgobackURL_reserv);		
		
		mav.setViewName("reservation/user/meeting_room.tiles_ys");

		return mav;
	}
	
	
	// === 자원예약 기기 예약 페이지 === //
	@RequestMapping(value="/reservation/device.gw")
	public ModelAndView device(HttpServletRequest request, ModelAndView mav) { 

		String lgcatgono = "2";
		
		// 자원 안내 내용 보여주기
		ReservLargeCategoryVO lvo = service.mainLgcategContent(lgcatgono);
		mav.addObject("lvo",lvo);		
		
		String listgobackURL_reserv = MyUtil.getCurrentURL(request);
		mav.addObject("listgobackURL_reserv",listgobackURL_reserv);	
		
		mav.setViewName("reservation/user/device.tiles_ys");

		return mav;
	}

	
	// === 자원예약 차량 예약 페이지 === //
	@RequestMapping(value="/reservation/vehicle.gw")
	public ModelAndView vehicle(HttpServletRequest request, ModelAndView mav) { 
		
		String lgcatgono = "3";
		
		// 자원 안내 내용 보여주기
		ReservLargeCategoryVO lvo = service.mainLgcategContent(lgcatgono);
		mav.addObject("lvo",lvo);		
		
		String listgobackURL_reserv = MyUtil.getCurrentURL(request);
		mav.addObject("listgobackURL_reserv",listgobackURL_reserv);	
		
		mav.setViewName("reservation/user/vehicle.tiles_ys");

		return mav;
	}
	
	
	// === 자원예약 예약 내역 페이지 === //
	@RequestMapping(value="/reservation/confirm.gw")
	public ModelAndView confirm(HttpServletRequest request, ModelAndView mav, Pagination pagination) throws Exception { 
		 
		List<Map<String,String>> reservList = null;
		Map<String, Object> paraMap = new HashMap<String, Object>();
		
		String startdate = request.getParameter("startdate");
		String enddate = request.getParameter("enddate");
	//	String empno = request.getParameter("empno");  
	//	String cpemail = request.getParameter("cpemail");  
		
		// 로그인 정보 가져오기
		HttpSession session = request.getSession();
		EmployeesVO loginuser = (EmployeesVO) session.getAttribute("loginuser");
		String employee_id = loginuser.getEmployee_id();
		String email = loginuser.getEmail();
		//System.out.println(employee_id);
		if(pagination.getSearchWord() == null || "".equals(pagination.getSearchWord()) || pagination.getSearchWord().trim().isEmpty()) {
			pagination.setSearchWord("");
		}
		
		if(startdate==null || "".equals(startdate)) {
			startdate="";
		}
		
		if(enddate==null || "".equals(enddate) || "?searchType=".equals(enddate)) {
			enddate="";
		}
		
		if(pagination.getSearchType() == null || "".equals(pagination.getSearchType()) || 
		   (!"1".equals(pagination.getSearchType()) && !"2".equals(pagination.getSearchType()) && !"3".equals(pagination.getSearchType())) ) {
			pagination.setSearchType("");
		}
		
		if(employee_id.equals("") || employee_id == null) {
			mav.addObject("message", "잘못된 접근입니다.");
			mav.addObject("loc", request.getContextPath()+"/reservation/confirm.gw");
			
			mav.setViewName("msg");
		}

		// 문자로 장난쳤을 경우
		try {
			Integer.parseInt(employee_id);
		} catch (Exception e) {
			mav.addObject("message", "잘못된 접근입니다.");
			mav.addObject("loc", request.getContextPath()+"/reservation/confirm.gw");
			
			mav.setViewName("msg");
		}
		
		paraMap.put("pagination", pagination);
		paraMap.put("startdate", startdate);
		paraMap.put("enddate", enddate);
		paraMap.put("employee_id", employee_id);
		paraMap.put("email", email);
		
		//System.out.println("확인용"+paraMap.get("employee_id"));
		//System.out.println("확인용"+paraMap.get("email"));
		// 예약 내역 전체 개수 구하기
		int listCnt = service.getResrvSearchCnt(paraMap);
	//	System.out.println(listCnt);
		
		// startRno, endRno 구하기
		// 구해 온 최대 글 개수를 파라미터로 넘긴다.
		// 파라맵에 받아온 두개의 startrno와 endrno를 담아주어야 한다
		pagination.setPageInfo(listCnt);
		paraMap.put("pagination", pagination);
		
		// 한 페이지에 표시할 이용자 예약 내역 글 목록
		reservList = service.getResrvList(paraMap);
		mav.addObject("reservList", reservList);
		
		
		
		pagination.setQueryString("&startdate="+startdate+"&enddate="+enddate);
		
		// 페이지바
		mav.addObject("pagebar", pagination.getPagebar(request.getContextPath()+"/reservation/confirm.gw"));
		mav.addObject("paraMap", paraMap);
		
		String listgobackURL_reserv = MyUtil.getCurrentURL(request);
		mav.addObject("listgobackURL_reserv",listgobackURL_reserv);	
		
		mav.setViewName("reservation/user/confirm.tiles_ys");

		return mav;
	}
	
	
	
	// === 자원예약 관리자 예약 내역 페이지 === //
	@RequestMapping(value="/reservation/admin/adminConfirm.gw")
	public ModelAndView adminConfirm(HttpServletRequest request, ModelAndView mav, Pagination pagination) throws Exception { 
		
		List<Map<String,String>> reservList = null;
		Map<String, Object> paraMap = new HashMap<String, Object>();
		
		String startdate = request.getParameter("startdate");
		String enddate = request.getParameter("enddate");
	//	String empno = request.getParameter("empno");  
	//	String cpemail = request.getParameter("cpemail");  
		
		// 로그인 정보 가져오기
		HttpSession session = request.getSession();
		EmployeesVO loginuser = (EmployeesVO) session.getAttribute("loginuser");
		String employee_id = loginuser.getEmployee_id();
		String email = loginuser.getEmail();

		if(pagination.getSearchWord() == null || "".equals(pagination.getSearchWord()) || pagination.getSearchWord().trim().isEmpty()) {
			pagination.setSearchWord("");
		}
		
		if(startdate==null || "".equals(startdate)) {
			startdate="";
		}
		
		if(enddate==null || "".equals(enddate) || "?searchType=".equals(enddate)) {
			enddate="";
		}
		
		if(pagination.getSearchType() == null || "".equals(pagination.getSearchType()) || 
		   (!"1".equals(pagination.getSearchType()) && !"2".equals(pagination.getSearchType()) && !"3".equals(pagination.getSearchType())) ) {
			pagination.setSearchType("");
		}
		
		if(employee_id.equals("") || employee_id == null) {
			mav.addObject("message", "잘못된 접근입니다.");
			mav.addObject("loc", request.getContextPath()+"/reservation/admin/adminConfirm.gw");
			
			mav.setViewName("msg");
		}

		// 문자로 장난쳤을 경우
		try {
			Integer.parseInt(employee_id);
		} catch (Exception e) {
			mav.addObject("message", "잘못된 접근입니다.");
			mav.addObject("loc", request.getContextPath()+"/reservation/admin/adminConfirm.gw");
			
			mav.setViewName("msg");
		}
		
		paraMap.put("pagination", pagination);
		paraMap.put("startdate", startdate);
		paraMap.put("enddate", enddate);
		paraMap.put("employee_id", employee_id);
		paraMap.put("email", email);

		// 예약 내역 전체 개수 구하기
		int listCnt = service.getResrvAdminSearchCnt(paraMap);
		//	System.out.println(listCnt);
		
		// startRno, endRno 구하기
		// 구해 온 최대 글 개수를 파라미터로 넘긴다.
		// 파라맵에 받아온 두개의 startrno와 endrno를 담아주어야 한다
		pagination.setPageInfo(listCnt);
		paraMap.put("pagination", pagination);
		
		// 한 페이지에 표시할 관리자 예약 내역 글 목록
		reservList = service.getResrvAdminList(paraMap);
		mav.addObject("reservList", reservList);
		
		pagination.setQueryString("&startdate="+startdate+"&enddate="+enddate);
		
		// 페이지바
		mav.addObject("pagebar", pagination.getPagebar(request.getContextPath()+"/reservation/admin/adminConfirm.gw"));
		mav.addObject("paraMap", paraMap);
		
		String listgobackURL_reserv = MyUtil.getCurrentURL(request);
		mav.addObject("listgobackURL_reserv",listgobackURL_reserv);		
		
		mav.setViewName("reservation/admin/admin_confirm.tiles_ys");

		return mav;
	} // end of public ModelAndView adminConfirm(HttpServletRequest request, ModelAndView mav, Pagination pagination) throws Exception
	
	
	// === 자원예약 페이지에서 자원항목 불러오기
	@ResponseBody
	@RequestMapping(value="/reservation/reservationTable.gw", produces="text/plain;charset=UTF-8") 
	public String reservationTable(HttpServletRequest request) {
		
		String fk_lgcatgono = request.getParameter("fk_lgcatgono"); // 자원예약 대분류 번호
		
		Map<String,String> paraMap = new HashMap<>();
		paraMap.put("fk_lgcatgono", fk_lgcatgono);
		
		List<ReservSmallCategoryVO> smallCategList = service.selectSmallCategory(paraMap);
		
		
		JSONArray jsArr = new JSONArray();
		if(smallCategList != null) {
			for(ReservSmallCategoryVO rcvo : smallCategList) {
				JSONObject jsObj = new JSONObject();
				jsObj.put("smcatgono", rcvo.getSmcatgono());
				jsObj.put("smcatgoname", rcvo.getSmcatgoname());
				jsObj.put("sc_status", rcvo.getSc_status());
				
				
				jsArr.put(jsObj);
			}
		}
		//System.out.println(jsArr.toString());
		return jsArr.toString();
	} // end of public String reservationTable(HttpServletRequest request) 
	
	
	// === 자원 예약하기 === 
	@RequestMapping(value="/reservation/addReservation.gw", method = {RequestMethod.POST})
	public ModelAndView addReservation(ModelAndView mav, HttpServletRequest request) throws Throwable {
		
		String startdate= request.getParameter("startdate");
	//	System.out.println("확인용 startdate => " + startdate);
	//  확인용 startdate => 20211125140000
		String enddate = request.getParameter("enddate");
		String fk_lgcatgono= request.getParameter("fk_lgcatgono");
		String fk_smcatgono = request.getParameter("fk_smcatgono");
		String realuser = request.getParameter("realuser");
		String employee_id = request.getParameter("employee_id");
		String returnTime = request.getParameter("return_time");
		
		String listgobackURL_reserv = request.getParameter("listgobackURL_reserv");
		listgobackURL_reserv = listgobackURL_reserv.replaceAll("&amp;", "&");
		
		if("".equals(returnTime) || returnTime == null) {
			returnTime = "";
		}
		
		Map<String,String> paraMap = new HashMap<String, String>();
		paraMap.put("startdate", startdate);
		paraMap.put("enddate", enddate);
		paraMap.put("fk_lgcatgono",fk_lgcatgono);
		paraMap.put("fk_smcatgono", fk_smcatgono);
		paraMap.put("realuser", realuser);
		paraMap.put("employee_id", employee_id);
		paraMap.put("returnTime", returnTime);
		
		int n = service.addReservation(paraMap);

		if(n == 0) {
			mav.addObject("message", "이미 존재하는 예약 일자에는 예약이 불가능합니다.");
			mav.addObject("loc", request.getContextPath()+listgobackURL_reserv);

		}
		else {
			mav.addObject("message", "자원 예약을 완료하였습니다. 관리자 승인 이후 이용이 가능합니다.");
			mav.addObject("loc", request.getContextPath()+"/reservation/confirm.gw");
		}
		
		
		mav.setViewName("msg");
		
		return mav;
	} // end of public ModelAndView registerSchedule_end(ModelAndView mav, HttpServletRequest request) throws Throwable
	
	
	// 선택한 날짜에 따른 예약된 시간 가져오기
	@ResponseBody
	@RequestMapping(value="/reservation/reservTime.gw", produces="text/plain;charset=UTF-8")
	public String reservTime(HttpServletRequest request) {
		
		String fk_lgcatgono = request.getParameter("fk_lgcatgono");
		String selectDate = request.getParameter("selectDate");
		
		Map<String,String> paraMap = new HashMap<String, String>();
		paraMap.put("fk_lgcatgono", fk_lgcatgono);
		paraMap.put("selectDate", selectDate);
				
		List<ReservationVO> reservTimeList = service.reservTime(paraMap);
		
		JSONArray jsArr = new JSONArray();
		
		if(reservTimeList != null && reservTimeList.size() > 0) {
			for(ReservationVO rvo : reservTimeList) {
				JSONObject jsObj = new JSONObject();
				jsObj.put("reservationno",rvo.getReservationno());
				jsObj.put("startdate",rvo.getStartdate());
				jsObj.put("enddate", rvo.getEnddate());
				jsObj.put("fk_smcatgono", rvo.getFk_smcatgono());
				jsObj.put("fk_lgcatgono", rvo.getFk_lgcatgono());
				jsObj.put("confirm", rvo.getConfirm());
				jsObj.put("status", rvo.getStatus());
				
				jsArr.put(jsObj);
			}// end of for-------------------------------------
		}
		
		return jsArr.toString();
	} // end of public String reservTime(HttpServletRequest request)
	
	
	// 관리자 예약 내역 확인에서 예약 상태 가져오기
	@ResponseBody
	@RequestMapping(value="/reservation/statusButton.gw", produces="text/plain;charset=UTF-8", method = {RequestMethod.POST})
	public String statusButton(HttpServletRequest request) {
		
		List<ReservationVO> statusList = service.statusButton();
		
		JSONArray jsArr = new JSONArray();
		
		if(statusList != null && statusList.size() > 0) {
			for(ReservationVO rvo : statusList) {
				JSONObject jsObj = new JSONObject();
				jsObj.put("reservationno", rvo.getReservationno());
				jsObj.put("status", rvo.getStatus());
				jsObj.put("confirm", rvo.getConfirm());
				jsObj.put("startdate", rvo.getStartdate());
				jsObj.put("enddate", rvo.getEnddate());
				
				jsArr.put(jsObj);
			}// end of for-------------------------------------
		}
		
		return jsArr.toString();
	} // end of public String reservTime(HttpServletRequest request)
	
	
	// 자원 예약 승인 메소드
	@RequestMapping(value="/reservation/reservConfirm.gw", method = {RequestMethod.POST})
	public ModelAndView reservConfirm(ModelAndView mav, HttpServletRequest request) throws Throwable {
		
		String listgobackURL_reserv = request.getParameter("listgobackURL_reserv");
		listgobackURL_reserv = listgobackURL_reserv.replaceAll("&amp;", "&");
		String reservationno= request.getParameter("reservationno");
		
		Map<String,String> paraMap = new HashMap<String, String>();
		paraMap.put("reservationno", reservationno);

		int n = service.reservConfirm(paraMap);
		
		if(n == 0) {
			mav.addObject("message", "자원 예약 승인을 실패하였습니다. ");
			mav.addObject("loc", request.getContextPath()+"/reservation/admin/adminConfirm.gw");

		}
		else {
			
			Map<String,String> confirmMap = service.reservConfirmSelect(paraMap);
			
			DefaultMessageService messageService =  NurigoApp.INSTANCE.initialize("NCSSMEPKLVHTSH9V", "RD1XKVN6KBGKGPENMOXQ1E03QNQC5D3B", "https://api.coolsms.co.kr");
			// Message 패키지가 중복될 경우 net.nurigo.sdk.message.model.Message로 치환하여 주세요
			Message message = new Message();
			message.setFrom("01029289568");
			message.setTo(confirmMap.get("phone"));
			message.setText(confirmMap.get("name")+" 님의"+confirmMap.get("startdate")+" 부터"+confirmMap.get("enddate")+" 까지"+confirmMap.get("smcatgoname")+" 예약이 승인되었습니다.");

			try {
			  // send 메소드로 ArrayList<Message> 객체를 넣어도 동작합니다!
			  messageService.send(message);
			} catch (NurigoMessageNotReceivedException exception) {
			  // 발송에 실패한 메시지 목록을 확인할 수 있습니다!
			  System.out.println(exception.getFailedMessageList());
			  System.out.println(exception.getMessage());
			} catch (Exception exception) {
			  System.out.println(exception.getMessage());
			}
			
			mav.addObject("message", "자원 예약을 승인하였습니다. ");
			mav.addObject("loc", request.getContextPath()+listgobackURL_reserv);
		}
		
		mav.setViewName("msg");
		
		return mav;
	} // end of public ModelAndView registerSchedule_end(ModelAndView mav, HttpServletRequest request) throws Throwable
	

	// 자원 예약 취소 메소드
	@RequestMapping(value="/reservation/reservCancle.gw", method = {RequestMethod.POST})
	public ModelAndView reservCancle(ModelAndView mav, HttpServletRequest request) throws Throwable {
		
		String reservationno= request.getParameter("reservationno");
		String listgobackURL_reserv = request.getParameter("listgobackURL_reserv");
		listgobackURL_reserv = listgobackURL_reserv.replaceAll("&amp;", "&");
		
		
		HttpSession session = request.getSession();
		EmployeesVO loginuser = (EmployeesVO) session.getAttribute("loginuser");
		String fk_job_id = loginuser.getFk_job_id();
		
		
		
		Map<String,String> paraMap = new HashMap<String, String>();
		paraMap.put("reservationno", reservationno);
		
		int n = 0;
		
		if(!fk_job_id.equals("3")) { // 일반 유저일때 취소
			
		 n = service.reservCancle(paraMap);
		
		}
		else { // 관리자 일때 승인 취소로 바꿔주기
			int n2 = service.reservCancle(paraMap);
			int n1 = service.adminreservCancle(paraMap);
			
			Map<String,String> confirmMap = service.reservConfirmSelect(paraMap);
			
			DefaultMessageService messageService =  NurigoApp.INSTANCE.initialize("NCSSMEPKLVHTSH9V", "RD1XKVN6KBGKGPENMOXQ1E03QNQC5D3B", "https://api.coolsms.co.kr");
			// Message 패키지가 중복될 경우 net.nurigo.sdk.message.model.Message로 치환하여 주세요
			Message message = new Message();
			message.setFrom("01029289568");
			message.setTo(confirmMap.get("phone"));
			message.setText(confirmMap.get("name")+" 님의"+confirmMap.get("startdate")+" 부터"+confirmMap.get("enddate")+" 까지"+confirmMap.get("smcatgoname")+" 예약이 승인 취소되었습니다.");

			try {
			  // send 메소드로 ArrayList<Message> 객체를 넣어도 동작합니다!
			  messageService.send(message);
			} catch (NurigoMessageNotReceivedException exception) {
			  // 발송에 실패한 메시지 목록을 확인할 수 있습니다!
			  System.out.println(exception.getFailedMessageList());
			  System.out.println(exception.getMessage());
			} catch (Exception exception) {
			  System.out.println(exception.getMessage());
			}
			
			n = n1*n2;
			
		}
		
		if(n == 0) {
			mav.addObject("message", "자원 예약 취소를 실패하였습니다. ");
			mav.addObject("loc", request.getContextPath()+"/reservation/admin/adminConfirm.gw");

		}
		else {
			mav.addObject("message", "자원 예약을 취소하였습니다. ");
			mav.addObject("loc", request.getContextPath()+listgobackURL_reserv);
		}
		
		mav.setViewName("msg");
		
		return mav;
	} // end of public public ModelAndView reservCancle(ModelAndView mav, HttpServletRequest request) throws Throwable
	
	
	// 자원 반납 메소드
	@RequestMapping(value="/reservation/reservReturn.gw", method = {RequestMethod.POST})
	public ModelAndView reservReturn(ModelAndView mav, HttpServletRequest request) throws Throwable {
		
		String reservationno= request.getParameter("reservationno");
		String enddate= request.getParameter("hidden_enddate");
		String listgobackURL_reserv = request.getParameter("listgobackURL_reserv");
		listgobackURL_reserv = listgobackURL_reserv.replaceAll("&amp;", "&");
		
		Map<String,String> paraMap = new HashMap<String, String>();
		paraMap.put("reservationno", reservationno);
		paraMap.put("enddate", enddate);

		int n = service.reservReturn(paraMap);

		if(n == 0) {
			mav.addObject("message", "자원 반납을 실패하셨습니다.");
			mav.addObject("loc", request.getContextPath()+"/reservation/admin/adminConfirm.gw");

		}
		else {
			mav.addObject("message", "자원 반납을 완료하였습니다.");
			mav.addObject("loc", request.getContextPath()+listgobackURL_reserv);
		}
		
		mav.setViewName("msg");
		
		return mav;
	} // end of public public ModelAndView reservCancle(ModelAndView mav, HttpServletRequest request) throws Throwable
	

	// 예약 내역 상세보기
	@ResponseBody
	@RequestMapping(value="/reservation/viewReservation.gw", produces="text/plain;charset=UTF-8")
	public String viewReservation(HttpServletRequest request) {
		
		String reservationno = request.getParameter("reservationno");
		
		Map<String,String> paraMap = new HashMap<String, String>();
		paraMap.put("reservationno", reservationno);
		
		Map<String, String> map = service.viewReservation(paraMap);
		
		JSONArray jsArr = new JSONArray();
		
		if(map != null) {
			JSONObject jsObj = new JSONObject();
			jsObj.put("reservationno", map.get("reservationno"));
			jsObj.put("startdate",  map.get("startdate"));
			jsObj.put("enddate",  map.get("enddate"));
			jsObj.put("smcatgoname",  map.get("smcatgoname"));
			jsObj.put("lgcatgoname",  map.get("lgcatgoname"));
			jsObj.put("realuser",  map.get("realuser"));
			jsObj.put("employee_id",  map.get("employee_id"));
			jsObj.put("email",  map.get("email"));
			jsObj.put("name", map.get("name"));
			jsObj.put("status", map.get("status"));
			jsObj.put("confirm", map.get("confirm"));
			
			jsArr.put(jsObj);
		}
		
		return jsArr.toString();
	} // end of public String reservTime(HttpServletRequest request)
	
	
	// === 자원항목 관리 페이지 === //
	@RequestMapping(value="/reservation/admin/managementResource.gw")
	public ModelAndView managementResource(HttpServletRequest request, ModelAndView mav) { 
		
		// 자원 목록
		List<Map<String,String>> resourceList = service.managementResource();
		mav.addObject("resourceList", resourceList);
		
		mav.setViewName("reservation/admin/management_resource.tiles_ys");

		return mav;
	}

	
	// 버튼 클릭 시 자원 항목 리스트 변경 메소드
	@ResponseBody
	@RequestMapping(value="/reservation/admin/resourceFilter.gw", produces="text/plain;charset=UTF-8")
	public String resourceFilter(HttpServletRequest request) {
		
		String fk_lgcatgono = request.getParameter("fk_lgcatgono");
		
		Map<String,String> paraMap = new HashMap<String, String>();
		paraMap.put("fk_lgcatgono", fk_lgcatgono);
		
		List<Map<String,String>> resourceList = service.resourceFilter(paraMap);
		
		JSONArray jsArr = new JSONArray();
		
		if(resourceList != null && resourceList.size() > 0) {
			for(Map<String,String> map : resourceList) {
				JSONObject jsObj = new JSONObject();
				jsObj.put("smcatgono", map.get("smcatgono"));
				jsObj.put("smcatgoname", map.get("smcatgoname"));
				jsObj.put("sc_status", map.get("sc_status"));
				jsObj.put("fk_employee_id", map.get("fk_employee_id"));
				jsObj.put("lgcatgono", map.get("lgcatgono"));
				jsObj.put("lgcatgoname", map.get("lgcatgoname"));
				
				jsArr.put(jsObj);
			}// end of for-------------------------------------
		}
		
		return jsArr.toString();
	} // end of public String reservTime(HttpServletRequest request)
	
	
	// 자원명 수정 메소드
	@RequestMapping(value="/reservation/admin/editSmcatgoname.gw", method = {RequestMethod.POST})
	public ModelAndView editSmcatgoname(ModelAndView mav, HttpServletRequest request) throws Throwable {
		
		String smcatgono= request.getParameter("smcatgono");
		String smcatgoname= request.getParameter("smcatgoname");
		String fk_employee_id = request.getParameter("fk_employee_id");
		
		Map<String,String> paraMap = new HashMap<String, String>();
		paraMap.put("smcatgono", smcatgono);
		paraMap.put("smcatgoname", smcatgoname);
		paraMap.put("fk_employee_id", fk_employee_id);

		int n = service.editSmcatgoname(paraMap);

		if(n == 0) {
			mav.addObject("message", "자원명 수정을 실패하셨습니다.");
			mav.addObject("loc", request.getContextPath()+"/reservation/admin/managementResource.gw");

		}
		else {
			mav.addObject("message", "자원명 수정을 완료하였습니다.");
			mav.addObject("loc", request.getContextPath()+"/reservation/admin/managementResource.gw");
		}
		
		mav.setViewName("msg"); 
		
		return mav;
	} // end of public ModelAndView editSmcatgoname(ModelAndView mav, HttpServletRequest request) throws Throwable 

	
	// 자원 추가 메소드
	@RequestMapping(value="/reservation/admin/addSmcatgo.gw", method = {RequestMethod.POST})
	public ModelAndView addSmcatgo(ModelAndView mav, HttpServletRequest request) throws Throwable {
		
		String fk_lgcatgono= request.getParameter("fk_lgcatgono");
		String smcatgoname= request.getParameter("smcatgoname");
		String fk_employee_id = request.getParameter("fk_employee_id");
		
		Map<String,String> paraMap = new HashMap<String, String>();
		paraMap.put("fk_lgcatgono", fk_lgcatgono);
		paraMap.put("smcatgoname", smcatgoname);
		paraMap.put("fk_employee_id", fk_employee_id);

		int n = service.addSmcatgo(paraMap);

		if(n == 0) {
			mav.addObject("message", "자원 추가를 실패하셨습니다.");
			mav.addObject("loc", request.getContextPath()+"/reservation/admin/managementResource.gw");

		}
		else {
			mav.addObject("message", "자원 추가를 완료하였습니다.");
			mav.addObject("loc", request.getContextPath()+"/reservation/admin/managementResource.gw");
		}
		
		mav.setViewName("msg"); 
		
		return mav;
	} // end of public ModelAndView editSmcatgoname(ModelAndView mav, HttpServletRequest request) throws Throwable 

		
	// 자원 상태 변경 메소드
	@RequestMapping(value="/reservation/admin/changeStatus.gw", method = {RequestMethod.POST})
	public ModelAndView changeStatus(ModelAndView mav, HttpServletRequest request) throws Throwable {
		
		String smcatgono= request.getParameter("smcatgono");
		String sc_status= request.getParameter("sc_status");
		
		// 로그인 정보 가져오기
		HttpSession session = request.getSession();
		EmployeesVO loginuser = (EmployeesVO) session.getAttribute("loginuser");
		String employee_id = loginuser.getEmployee_id();
		
		Map<String,String> paraMap = new HashMap<String, String>();
		paraMap.put("smcatgono", smcatgono);
		paraMap.put("sc_status", sc_status);
		paraMap.put("employee_id", employee_id);

		int n = service.changeStatus(paraMap);

		if(n == 0) {
			mav.addObject("message", "자원 상태 변경을 실패하셨습니다.");
			mav.addObject("loc", request.getContextPath()+"/reservation/admin/managementResource.gw");

		}
		else {
			mav.addObject("message", "자원 상태 변경이 완료되었습니다.");
			mav.addObject("loc", request.getContextPath()+"/reservation/admin/managementResource.gw");
		}
		
		mav.setViewName("msg"); 
		
		return mav;
	} // end of public ModelAndView changeStatus(ModelAndView mav, HttpServletRequest request) throws Throwable 

			
	// 자원 안내 수정 페이지
	@RequestMapping(value="/reservation/admin/editResourceContent.gw")
	public ModelAndView editResourceContent(ModelAndView mav, HttpServletRequest request) throws Throwable {
		
		String lgcatgono= request.getParameter("lgcatgono");
		String listgobackURL_reserv= request.getParameter("listgobackURL_reserv");
		
		Map<String,String> paraMap = new HashMap<String, String>();
		paraMap.put("lgcatgono", lgcatgono);

		try {
			Integer.parseInt(lgcatgono);
			ReservLargeCategoryVO lvo = service.editResourceContent(paraMap);
			
			mav.addObject("lvo", lvo);
			mav.addObject("listgobackURL_reserv", listgobackURL_reserv);
			mav.setViewName("reservation/admin/resource_content.tiles_ys");
				
		} catch (NumberFormatException e) {
			mav.setViewName("redirect:"+listgobackURL_reserv);
		}
		
		return mav;
	} // end of public ModelAndView changeStatus(ModelAndView mav, HttpServletRequest request) throws Throwable 
 
			
	// 자원 안내 수정 최종
	@RequestMapping(value="/reservation/admin/endEditResourceContent.gw", method = {RequestMethod.POST})
	public ModelAndView endEditResourceContent(ModelAndView mav, HttpServletRequest request) throws Throwable {
		
		String lgcategcontent= request.getParameter("lgcategcontent");
		String lgcatgono= request.getParameter("lgcatgono");
		String employee_id= request.getParameter("employee_id");
		String listgobackURL_reserv= request.getParameter("listgobackURL_reserv");
		
		Map<String,String> paraMap = new HashMap<String, String>();
		paraMap.put("lgcategcontent", lgcategcontent);
		paraMap.put("lgcatgono", lgcatgono);
		paraMap.put("employee_id", employee_id);

		int n = service.endEditResourceContent(paraMap);

		if(n == 0) {
			mav.addObject("message", "자원 안내 변경을 실패하셨습니다.");
			mav.addObject("loc", request.getContextPath()+listgobackURL_reserv);

		}
		else {
			mav.addObject("message", "자원 안내 변경이 완료되었습니다.");
			mav.addObject("loc", request.getContextPath()+listgobackURL_reserv);
		}
		
		mav.setViewName("msg"); 
		
		return mav;
	} // end of public ModelAndView changeStatus(ModelAndView mav, HttpServletRequest request) throws Throwable 
	
	
	@GetMapping("/reservationChart.gw")
	public ModelAndView reservationChart(HttpServletRequest request, ModelAndView mav) { 
		
				
		mav.setViewName("reservation/admin/chart.tiles_ys");

		return mav;
	}
	//차트 보여주는 페이지
	@ResponseBody
	@GetMapping("/meetingroomchart.gw")
	public String meetingroomchart(HttpServletRequest request) { 
		
		List<Map<String,String>> list = service.meetingroomchart();
		
		JSONArray jsArr = new JSONArray();
		
			for(Map<String,String> paraMap : list) {
				JSONObject jsObj = new JSONObject();
				jsObj.put("MeetingRoom", paraMap.get("MeetingRoom"));
				jsObj.put("nowMonth6", paraMap.get("nowMonth6"));
				jsObj.put("nowMonth5", paraMap.get("nowMonth5"));
				jsObj.put("nowMonth4", paraMap.get("nowMonth4"));
				jsObj.put("nowMonth3", paraMap.get("nowMonth3"));
				jsObj.put("nowMonth2", paraMap.get("nowMonth2"));
				jsObj.put("nowMonth1", paraMap.get("nowMonth1"));
				jsObj.put("nowMonth", paraMap.get("nowMonth"));
				
				jsArr.put(jsObj);
			}
		

		return jsArr.toString();
	}
	
	
	
	
	
	
	
	
}

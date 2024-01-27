package com.spring.app.minjun.controller;

import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import com.spring.app.common.MyUtil;
import com.spring.app.domain.EmployeesVO;
import com.spring.app.domain.WorkVO;
import com.spring.app.domain.Work_requestVO;
import com.spring.app.minjun.service.*;
		
@Controller
public class WorkController {
   
	@Autowired // Type에 따라 알아서 Bean 을 주입해준다.
	private WorkService service;
	///////////////////////////////////////////////////////////////

	// ======= 근무 페이지 [시작] ======= //
	// 근무 페이지 이동
	@GetMapping("/my_work.gw")
	public ModelAndView requiredLogin_my_work(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
		HttpSession session = request.getSession();
        EmployeesVO loginuser = (EmployeesVO) session.getAttribute("loginuser");
        String employee_id = loginuser.getEmployee_id();
		
        // 특정 사원의 근무내역 가져오기
		List<WorkVO> my_workList = service.my_workList(employee_id);
		
		// 특정 사원의 이번주 누적근무시간 가져오기
		Map<String, String> myWorkRecord = service.myWorkRecord(employee_id);
		
		// 로그인 한 사원의 오늘 출근시간 가져오기
		String myTodayStartTime = service.myTodayStartTime(employee_id);
		
		mav.addObject("myTodayStartTime", myTodayStartTime);
		mav.addObject("myWorkRecord", myWorkRecord);
		mav.addObject("my_workList", my_workList);
		mav.setViewName("my_work_record/my_work.tiles_MTS");
		return mav;
	} 
	
	// 특정 사원의 근무내역 가져오기
	@ResponseBody
	@RequestMapping("/getMyWorkList.gw")
	public String getMyWorkList(HttpServletRequest request) {
		
		String fk_employee_id = request.getParameter("fk_employee_id");
		String thisMonthVal = request.getParameter("thisMonthVal");
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("fk_employee_id", fk_employee_id);
		paraMap.put("thisMonthVal", thisMonthVal);
		
		// 특정 사원의 근무내역 가져오기
		List<WorkVO> workList = service.workList(paraMap); 
		
		JSONArray jsonArr = new JSONArray(); // []
		  
		  if(workList != null) {
		     for(WorkVO vo : workList) {
		    	 JSONObject jsonObj = new JSONObject();	    // {}
		    	 jsonObj.put("work_date", vo.getWork_date()); 	
		    	 jsonObj.put("work_start_time", vo.getWork_start_time()); 
		    	 jsonObj.put("work_end_time", vo.getWork_end_time()); 
		    	 jsonObj.put("timeDiff", vo.getTimeDiff()); 
		    	 
		    	 jsonArr.put(jsonObj);
		    	 					   
		     } // end of for------------------------
		     
		  }
		  
		  return jsonArr.toString();
	} 
	
	// 근무 단에서 출근 버튼 클릭시 근무테이블에 insert 하기
	@PostMapping("/goToWorkInsert.gw")
	public ModelAndView goToWorkInsert(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
        String fk_employee_id = request.getParameter("fk_employee_id");
        String work_date = request.getParameter("work_date");
        String work_start_time = request.getParameter("work_start_time");
        
        Map<String, String> paraMap = new HashMap<>();
        
        paraMap.put("fk_employee_id", fk_employee_id);
        paraMap.put("work_date", work_date);
        paraMap.put("work_start_time", work_start_time);
		
        try {
        	int n = service.goToWorkInsert(paraMap);
    		
    		if(n==1) {
    			mav.addObject("message", "출근이 정상처리되었습니다.");
    			mav.addObject("loc", request.getContextPath()+"/my_work.gw");
    			mav.setViewName("msg");
    		}
    		else {
    			mav.addObject("message", "출근처리가 실패하였습니다.");
    			mav.addObject("loc", request.getContextPath()+"/my_work.gw");
    			mav.setViewName("msg");
    		}
        } catch(Exception e) {
        	mav.addObject("message", "출,퇴근은 하루에 한번만 가능합니다.");
			mav.addObject("loc", request.getContextPath()+"/my_work.gw");
			mav.setViewName("msg");
        }
		return mav;
	}
	
	// Index 단에서 출근 버튼 클릭시 근무테이블에 insert 하기
	@PostMapping("/goToWorkInsertIndex.gw")
	public ModelAndView goToWorkInsertIndex(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
        String fk_employee_id = request.getParameter("fk_employee_id");
        String work_date = request.getParameter("work_date");
        String work_start_time = request.getParameter("work_start_time");
        
        Map<String, String> paraMap = new HashMap<>();
        
        paraMap.put("fk_employee_id", fk_employee_id);
        paraMap.put("work_date", work_date);
        paraMap.put("work_start_time", work_start_time);
		
        try {
        	int n = service.goToWorkInsert(paraMap);
    		
    		if(n==1) {
    			mav.addObject("message", "출근이 정상처리되었습니다.");
    			mav.addObject("loc", request.getContextPath()+"/index.gw");
    			mav.setViewName("msg");
    		}
    		else {
    			mav.addObject("message", "출근처리가 실패하였습니다.");
    			mav.addObject("loc", request.getContextPath()+"/index.gw");
    			mav.setViewName("msg");
    		}
        } catch(Exception e) {
        	mav.addObject("message", "출,퇴근은 하루에 한번만 가능합니다.");
			mav.addObject("loc", request.getContextPath()+"/index.gw");
			mav.setViewName("msg");
        }
		return mav;
	}
	
	
	// 근무단에서 퇴근 버튼 클릭시 근무테이블에 update 하기
	// 연장근무 인 경우
	@PostMapping("/goToWorkUpdateWithExtended.gw")
	public ModelAndView goToWorkUpdateWithExtended(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
		String fk_employee_id = request.getParameter("fk_employee_id");
		String work_date = request.getParameter("work_date");
		String extended_end_time = request.getParameter("extended_end_time");
		
		Map<String, String> paraMap = new HashMap<>();
        
        paraMap.put("fk_employee_id", fk_employee_id);
        paraMap.put("work_date", work_date);
        paraMap.put("extended_end_time", extended_end_time);
		
        // 오늘날짜의 출근시간 얻어오기
        String todayStartTime = service.todayStartTime(paraMap);
        
        // 오늘날짜의 퇴근시간 얻어오기
        String todayEndTime = service.todayEndTime(fk_employee_id);
        
        if(todayStartTime == null) { // 오늘 출근을 하지 않고 퇴근을 눌렀을 시
        	mav.addObject("message", "출근 기록이 없습니다.");
			mav.addObject("loc", request.getContextPath()+"/my_work.gw");
			mav.setViewName("msg");
        }
        else {
            String work_end_time = request.getParameter("work_end_time");
            
            mav.addObject("todayStartTime", todayStartTime);
            
            paraMap.put("todayStartTime", todayStartTime);
            paraMap.put("work_end_time", work_end_time);
           
            if(todayEndTime == null) {
            	// 근무테이블에 퇴근시간 update 하기
                try {
                	int n = service.goToWorkUpdateWithExtended(paraMap);
            		
            		if(n==1) {
            			mav.addObject("message", "퇴근이 정상처리되었습니다.");
            			mav.addObject("loc", request.getContextPath()+"/my_work.gw");
            			mav.setViewName("msg");
            		}
            		else {
            			mav.addObject("message", "퇴근처리가 실패하였습니다.");
            			mav.addObject("loc", request.getContextPath()+"/my_work.gw");
            			mav.setViewName("msg");
            		}
                } catch(Exception e) {
                	e.printStackTrace();
                	mav.addObject("message", "출,퇴근은 하루에 한번만 가능합니다.");
        			mav.addObject("loc", request.getContextPath()+"/my_work.gw");
        			mav.setViewName("msg");
                }
            }
            else {
            	mav.addObject("message", "출,퇴근은 하루에 한번만 가능합니다.");
    			mav.addObject("loc", request.getContextPath()+"/my_work.gw");
    			mav.setViewName("msg");
            }
        }
		return mav;
	}
	
	// Index 단에서 퇴근 버튼 클릭시 근무테이블에 update 하기
	// 연장근무 인 경우
	@PostMapping("/goToWorkUpdateWithExtendedIndex.gw")
	public ModelAndView goToWorkUpdateWithExtendedIndex(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
		String fk_employee_id = request.getParameter("fk_employee_id");
		String work_date = request.getParameter("work_date_ex");
		String extended_end_time = request.getParameter("extended_end_time");
		
		Map<String, String> paraMap = new HashMap<>();
        
        paraMap.put("fk_employee_id", fk_employee_id);
        paraMap.put("work_date", work_date);
        paraMap.put("extended_end_time", extended_end_time);
		
        // 오늘날짜의 출근시간 얻어오기
        String todayStartTime = service.todayStartTime(paraMap);
        
        // 오늘날짜의 퇴근시간 얻어오기
        String todayEndTime = service.todayEndTime(fk_employee_id);
        
        if(todayStartTime == null) { // 오늘 출근을 하지 않고 퇴근을 눌렀을 시
        	mav.addObject("message", "출근 기록이 없습니다.");
			mav.addObject("loc", request.getContextPath()+"/index.gw");
			mav.setViewName("msg");
        }
        else {
            String work_end_time = request.getParameter("work_end_time");
            
            mav.addObject("todayStartTime", todayStartTime);
            
            paraMap.put("todayStartTime", todayStartTime);
            paraMap.put("work_end_time", work_end_time);
           
            if(todayEndTime == null) {
            	// 근무테이블에 퇴근시간 update 하기
                try {
                	int n = service.goToWorkUpdateWithExtended(paraMap);
            		
            		if(n==1) {
            			mav.addObject("message", "퇴근이 정상처리되었습니다.");
            			mav.addObject("loc", request.getContextPath()+"/index.gw");
            			mav.setViewName("msg");
            		}
            		else {
            			mav.addObject("message", "퇴근처리가 실패하였습니다.");
            			mav.addObject("loc", request.getContextPath()+"/index.gw");
            			mav.setViewName("msg");
            		}
                } catch(Exception e) {
                	e.printStackTrace();
                	mav.addObject("message", "출,퇴근은 하루에 한번만 가능합니다.");
        			mav.addObject("loc", request.getContextPath()+"/index.gw");
        			mav.setViewName("msg");
                }
            }
            else {
            	mav.addObject("message", "출,퇴근은 하루에 한번만 가능합니다.");
    			mav.addObject("loc", request.getContextPath()+"/index.gw");
    			mav.setViewName("msg");
            }
        }
		return mav;
	}
	
	
	// 근무 단에서 퇴근 버튼 클릭시 근무테이블에 update 하기
	// 연장근무가 아닌 경우
	@PostMapping("/goToWorkUpdate.gw")
	public ModelAndView goToWorkUpdate(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
		String fk_employee_id = request.getParameter("fk_employee_id");
		String work_date = request.getParameter("work_date");
		
		Map<String, String> paraMap = new HashMap<>();
        
        paraMap.put("fk_employee_id", fk_employee_id);
        paraMap.put("work_date", work_date);
		
        // 오늘날짜의 출근시간 얻어오기
        String todayStartTime = service.todayStartTime(paraMap);
        String work_end_time = request.getParameter("work_end_time");
        
        mav.addObject("todayStartTime", todayStartTime);
        
        paraMap.put("todayStartTime", todayStartTime);
        paraMap.put("work_end_time", work_end_time);
        
        // 오늘날짜의 퇴근시간 얻어오기
        String todayEndTime = service.todayEndTime(fk_employee_id);
        
        if(todayEndTime == null) { // 오늘 퇴근한 기록이 없다면
        	// 근무테이블에 퇴근시간 update 하기
            
        	int n = service.goToWorkUpdate(paraMap);
    		
    		if(n==1) {
    			mav.addObject("message", "퇴근이 정상처리되었습니다.");
    			mav.addObject("loc", request.getContextPath()+"/my_work.gw");
    			mav.setViewName("msg");
    		}
    		else {
    			mav.addObject("message", "퇴근처리가 실패하였습니다.");
    			mav.addObject("loc", request.getContextPath()+"/my_work.gw");
    			mav.setViewName("msg");
    		}
        }
        else { // 오늘 퇴근한 기록이 있다면
        	mav.addObject("message", "출,퇴근은 하루에 한번만 가능합니다.");
			mav.addObject("loc", request.getContextPath()+"/my_work.gw");
			mav.setViewName("msg");
        }
		return mav;
	}
	
	
	// index 단에서 퇴근 버튼 클릭시 근무테이블에 update 하기
	// 연장근무가 아닌 경우
	@PostMapping("/goToWorkUpdateIndex.gw")
	public ModelAndView goToWorkUpdateIndex(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
		String fk_employee_id = request.getParameter("fk_employee_id");
		String work_date = request.getParameter("work_date_ex");
		
		Map<String, String> paraMap = new HashMap<>();
        
        paraMap.put("fk_employee_id", fk_employee_id);
        paraMap.put("work_date", work_date);
		
        // 오늘날짜의 출근시간 얻어오기
        String todayStartTime = service.todayStartTime(paraMap);
        String work_end_time = request.getParameter("work_end_time");
        
        mav.addObject("todayStartTime", todayStartTime);
        
        paraMap.put("todayStartTime", todayStartTime);
        paraMap.put("work_end_time", work_end_time);
        
        // 오늘날짜의 퇴근시간 얻어오기
        String todayEndTime = service.todayEndTime(fk_employee_id);
        
        if(todayEndTime == null) { // 오늘 퇴근한 기록이 없다면
        	// 근무테이블에 퇴근시간 update 하기
            
        	int n = service.goToWorkUpdate(paraMap);
    		
    		if(n==1) {
    			mav.addObject("message", "퇴근이 정상처리되었습니다.");
    			mav.addObject("loc", request.getContextPath()+"/index.gw");
    			mav.setViewName("msg");
    		}
    		else {
    			mav.addObject("message", "퇴근처리가 실패하였습니다.");
    			mav.addObject("loc", request.getContextPath()+"/index.gw");
    			mav.setViewName("msg");
    		}
        }
        else { // 오늘 퇴근한 기록이 있다면
        	mav.addObject("message", "출,퇴근은 하루에 한번만 가능합니다.");
			mav.addObject("loc", request.getContextPath()+"/index.gw");
			mav.setViewName("msg");
        }
		return mav;
	}

	
	// 모달창에서 확인 버튼 클릭시 근무관리테이블에 insert하기
	@PostMapping("/workRequest.gw")
	public ModelAndView workRequest(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		HttpSession session = request.getSession();
        EmployeesVO loginuser = (EmployeesVO) session.getAttribute("loginuser");
        String employee_id = loginuser.getEmployee_id();
        
		String workDate = request.getParameter("workDate");
		String requestStartTime = request.getParameter("requestStartTime");
		String requestEndTime = request.getParameter("requestEndTime");
		String workSelectVal = request.getParameter("workSelectVal");
		String work_place = request.getParameter("work_place");
		String work_reason = request.getParameter("work_reason");
		
		Map<String, String> paraMap = new HashMap<>();
		
		paraMap.put("employee_id", employee_id);
		paraMap.put("workDate", workDate);		
		paraMap.put("requestStartTime", requestStartTime);	
		paraMap.put("requestEndTime", requestEndTime);
		paraMap.put("workSelectVal", workSelectVal);		
		paraMap.put("work_place", work_place);
		paraMap.put("work_reason", work_reason);
		
		// 사용자가 신청한 근무를 근무신청테이블에 insert
		int n = service.workRequestInsert(paraMap); 
		
		if(n==1) {
			mav.addObject("message", "근무신청이 정상처리되었습니다.");
			mav.addObject("loc", request.getContextPath()+"/my_work_manage.gw");
			mav.setViewName("msg");
		}
		else {
			mav.addObject("message", "근무신청이 실패하였습니다.");
			mav.addObject("loc", request.getContextPath()+"/my_work.gw");
			mav.setViewName("msg");
		}
		
		return mav;
	}
 

	// ======= 근무 페이지 [끝] ======= //
	
	
	// ======= 근무 관리 페이지 [시작] ======== //
	// 근무관리페이지 띄우기
	@GetMapping("/my_work_manage.gw")
	public ModelAndView requiredLogin_my_work_manage(HttpServletRequest request, HttpServletResponse response, ModelAndView mav, Work_requestVO work_requestvo) {
		HttpSession session = request.getSession();
        EmployeesVO loginuser = (EmployeesVO) session.getAttribute("loginuser");
        String employee_id = loginuser.getEmployee_id();
        
        // 특정 사용자가 신청한 근무신청 가져오기
		List<Work_requestVO> workRequestList = service.workRequestList(employee_id);
		
		String department_id = loginuser.getFk_department_id(); // 로그인 한 유저의 department_id
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("employee_id", employee_id);
		paraMap.put("department_id", department_id);
		
		// 내 부서원들의 신청한 대기중인 근무신청 가져오기 (관리자용)
		List<Map<String, String>> myDeptRequestList = service.myDeptRequestList(paraMap);
		
		// 내 부서원들의 승인된 근무신청 가져오기 (관리자용)
		List<Map<String, String>> myDeptApprovedList = service.myDeptApprovedList(paraMap);
		
		// 내 부서원들의 반려된 근무신청 가져오기 (관리자용)
		List<Map<String, String>> myDeptReturnList = service.myDeptReturnList(paraMap);
		
		mav.addObject("myDeptRequestList", myDeptRequestList);
		mav.addObject("myDeptApprovedList", myDeptApprovedList);
		mav.addObject("myDeptReturnList", myDeptReturnList);
		mav.addObject("workRequestList", workRequestList);
		mav.setViewName("my_work_record/my_work_manage.tiles_MTS");
		return mav;
	}
	
	// 특정 근무신청 삭제하기
	@PostMapping("/work_request_delete.gw")
	public ModelAndView work_request_delete(HttpServletRequest request, ModelAndView mav) {
		String work_request_seq = request.getParameter("work_request_seq");
		
		int n = service.work_request_delete(work_request_seq);
		
		if(n==1) {
			mav.addObject("message", "근무신청 철회가 정상처리되었습니다.");
			mav.addObject("loc", request.getContextPath()+"/my_work_manage.gw");
			mav.setViewName("msg");
		}
		else {
			mav.addObject("message", "근무신청 철회가 실패하였습니다.");
			mav.addObject("loc", request.getContextPath()+"/my_work_manage.gw");
			mav.setViewName("msg");
		}
		return mav;
	}
	
	// ======= 근무 관리 페이지 [끝] ======== //
	
	
	// ======= 부서 근무 관리 페이지 [시작] ======= //
	@GetMapping("/dept_work_manage.gw")
	public ModelAndView dept_work_manage(ModelAndView mav, HttpServletRequest request) {
		
		HttpSession session = request.getSession();
        EmployeesVO loginuser = (EmployeesVO) session.getAttribute("loginuser");
        String fk_department_id = loginuser.getFk_department_id();
        String employee_id = loginuser.getEmployee_id();
        
        // 자신의 부서번호에 따른 이름, 직급명 가져오기
        List<Map<String, String>> myDeptEmpList = service.myDeptEmp(fk_department_id);
        
        Map<String, String> paraMap = new HashMap<>();
        
        paraMap.put("fk_department_id", fk_department_id);
        paraMap.put("employee_id", employee_id);
        
        // 로그인 한 사원의 부서명 가져오기
        String getMyDeptName = service.getMyDeptName(paraMap);
        
        // select option 에 필요한 department_id 가져오기 
        List<Map<String, String>> getAllDeptIdList = service.getAllDeptIdList();
        
        mav.addObject("getAllDeptIdList", getAllDeptIdList);
		mav.addObject("getMyDeptName", getMyDeptName);
        mav.addObject("myDeptEmpList", myDeptEmpList);
		mav.setViewName("my_work_record/dept_work_manage.tiles_MTS");
		return mav;
	}
	
	// 사원 클릭시 해당 사원의 근태내역 뿌리는 함수 ajax
	@ResponseBody
	@RequestMapping("/empWorkList.gw")
	public String empWorkList(HttpServletRequest request) {
		
		String employee_id = request.getParameter("employee_id");
		String thisMonth = request.getParameter("thisMonth");
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("employee_id", employee_id);
		paraMap.put("thisMonth", thisMonth);
		
		// employee_id 에 해당하는 사원의 근무내역 가져오기
		List<Map<String, String>> empWorkList = service.empWorkList(paraMap);
		
		JSONArray jsonArr = new JSONArray(); // []
		  
		if(empWorkList != null) {
			for(Map<String, String> map : empWorkList) {
	    		JSONObject jsonObj = new JSONObject();	    // {}
	    		jsonObj.put("work_date", map.get("work_date"));
	    		jsonObj.put("work_start_time", map.get("work_start_time")); 
	    		jsonObj.put("work_end_time", map.get("work_end_time")); 
	    		jsonObj.put("extended_end_time", map.get("extended_end_time")); 
	    		jsonObj.put("timeDiff", map.get("timeDiff")); 
	    	 
	    		jsonArr.put(jsonObj);
			} // end of for------------------------
		}
		return jsonArr.toString();
	}
	
	// 해당 부서 직급, 이름 가져오기(Ajax)
	@ResponseBody
	@RequestMapping("/deptSelectList.gw")
	public String deptSelectList(HttpServletRequest request) {
		
		String selectVal = request.getParameter("selectVal");
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("selectVal", selectVal);
		
		// 해당 부서 직급, 이름 가져오기
		List<Map<String, String>> deptSelectList = service.deptSelectList(paraMap);
		
		JSONArray jsonArr = new JSONArray(); // []
		
		if(deptSelectList != null) {
			for(Map<String, String> map : deptSelectList) {
	    		JSONObject jsonObj = new JSONObject();	    // {}
	    		jsonObj.put("name", map.get("name"));
	    		jsonObj.put("job_name", map.get("job_name")); 
	    		jsonObj.put("employee_id", map.get("employee_id")); 
	    		jsonObj.put("work_start_time", map.get("work_start_time")); 
	    	 
	    		jsonArr.put(jsonObj);
			} // end of for------------------------
		}
		return jsonArr.toString();
	}
	
	// select 옵션의 값에 따라 해당 부서명 가져오는 함수(Ajax)
	@ResponseBody
	@RequestMapping("/getSelectDeptName.gw")
	public String getSelectDeptName(HttpServletRequest request) {
		
		String IdSelectVal = request.getParameter("IdSelectVal");
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("IdSelectVal", IdSelectVal);
		
		// 해당 부서명 가져오기
		String getSelectDeptName = service.getSelectDeptName(paraMap);
		
		JSONObject jsonObj = new JSONObject();
		
		jsonObj.put("getSelectDeptName", getSelectDeptName);
		
		return jsonObj.toString();
	}
	
	
	// 근무신청 승인하기
	@PostMapping("/approveWork.gw")
	public ModelAndView approveWork(HttpServletRequest request, ModelAndView mav) {
		String requestApproveSeq = request.getParameter("requestApproveSeq");
		
		int n = service.approveWork(requestApproveSeq);
		
		if(n==1) {
			mav.addObject("message", "근무신청 승인이 정상처리되었습니다.");
			mav.addObject("loc", request.getContextPath()+"/my_work_manage.gw");
			mav.setViewName("msg");
		}
		else {
			mav.addObject("message", "근무신청 승인 처리가 실패하였습니다.");
			mav.addObject("loc", request.getContextPath()+"/my_work_manage.gw");
			mav.setViewName("msg");
		}
		return mav;
	}
	
	
	// 근무신청 반려하기
	@PostMapping("/requestReturn.gw")
	public ModelAndView requestReturn(HttpServletRequest request, ModelAndView mav) {
		String requestApproveSeq = request.getParameter("requestApproveSeq");
		
		int n = service.requestReturn(requestApproveSeq);
		
		if(n==1) {
			mav.addObject("message", "근무신청 반려가 정상처리되었습니다.");
			mav.addObject("loc", request.getContextPath()+"/my_work_manage.gw");
			mav.setViewName("msg");
		}
		else {
			mav.addObject("message", "근무신청 반려 처리가 실패하였습니다.");
			mav.addObject("loc", request.getContextPath()+"/my_work_manage.gw");
			mav.setViewName("msg");
		}
		return mav;
	}
	
	// 오늘 출근, 퇴근 시간 가져오기
	@ResponseBody
	@PostMapping("/getMyWorkTime.gw")
	public String getMyWorkTime(HttpServletRequest request) {
		
		HttpSession session = request.getSession();
        EmployeesVO loginuser = (EmployeesVO) session.getAttribute("loginuser");
        String employee_id = loginuser.getEmployee_id();
		String myWorkDate = request.getParameter("myWorkDate");
        
        Map<String, String> paraMap = new HashMap<>();
        
        paraMap.put("employee_id", employee_id);
        paraMap.put("myWorkDate", myWorkDate);
		
        Map<String, String> workDate = service.getMyWorkTime(paraMap);

    	JSONObject jsonObj = new JSONObject();
    	
        if(workDate != null) {
        	String start = workDate.get("work_start_time");
            String end = workDate.get("work_end_time");
            String timeDiff = workDate.get("timeDiff");
            
            jsonObj.put("work_start_time", start);
            jsonObj.put("work_end_time", end);
            jsonObj.put("timeDiff", timeDiff);
        }
        else {
        	jsonObj.put("work_start_time", "");
            jsonObj.put("work_end_time", "");
            jsonObj.put("timeDiff", "");
        }
        return jsonObj.toString();
	}
	
	// ======= 부서 근무 관리 페이지 [끝] ======= //
	
	
	
	
	
	
	
	
	
}
package com.spring.app.yosub.controller;


import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.collections4.map.HashedMap;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.spring.app.common.MyUtil;
import com.spring.app.domain.EmployeesVO;
import com.spring.app.yosub.service.*;
		
	

	
	@Controller
	@RequestMapping(value="/emp/*")
	public class EmpController {
	   
	   
	   @Autowired // Type에 따라 알아서 Bean 을 주입해준다.
	   private EmpService service;
	   
	   
	   @GetMapping("empList.gw")
	   public String empmanager_employeeInfoView(HttpServletRequest request,
			   									@RequestParam(defaultValue = "") String deptName,
			   									@RequestParam(defaultValue = "") String gradeLV,
			   									@RequestParam(defaultValue = "") String gender,
			   									@RequestParam(defaultValue = "") String employee_id) {
		   
		    
		   //employees 테이블의 근무중 사원 부서명 가져오기
		   List<Map<String, String>> deptNameList = service.deptNameList();

		   ////System.out.println("확인용 : " + deptName);
		   // 확인용 : 개발부, 마케팅부
		   
		   ////System.out.println("확인용 : " + gender);
		   // 확인용 : 남자
		   
		   Map<String, String> paraMap = new HashedMap<>();
		   
		   paraMap.put("deptName", deptName);
		   paraMap.put("gradeLV", gradeLV);	
		   paraMap.put("gender", gender);	
		   
		   List<Map<String, String>> empList =  service.empList(paraMap);
				   
		   request.setAttribute("deptNameList", deptNameList);
		   
			
			String goBackURL = MyUtil.getCurrentURL(request);
		 	// //System.out.println("~~~ 확인용(list.action) goBackURL : " + goBackURL);
		
			request.setAttribute("goBackURL", goBackURL);
					
		   request.setAttribute("empList", empList);
		   
		   
		   return "emp/member/empList.tiles_MTS";   
	   }
	   

	   
	   @ResponseBody
	   @GetMapping(value ="/empOneDetail.gw", produces="text/plain;charset=UTF-8")
	   public String empOneDetail(HttpServletRequest request) {
			
		   String employee_id = request.getParameter("employee_id");
		   ////System.out.println("employee_id" + employee_id);
		   //employee_id9999
		   
		   Map<String, String> empOneDetail = service.oneMemberMap(employee_id);
		   
		   String name = empOneDetail.get("name");
		   ////System.out.println("name" + name);
		   //name이요섭
		   
		   JSONObject jsonObj = new JSONObject();
		   jsonObj.put("empOneDetail", empOneDetail);
		   
		   ////System.out.println("jsonObj.toString()" + jsonObj.toString());
		   
		   return jsonObj.toString();
		   
	   }   

	   
	   
	   @GetMapping("/emp/payment.gw")
	   public String empmanager_payment(HttpServletRequest request,
			   									@RequestParam(defaultValue = "") String deptName,
			   									@RequestParam(defaultValue = "") String gradeLV,
			   									@RequestParam(defaultValue = "") String gender) {
		   
		   
		   //employees 테이블의 근무중 사원 부서명 가져오기
		   List<Map<String, String>> deptNameList = service.deptNameList();
		   
		   ////System.out.println("확인용 : " + deptName);
		   // 확인용 : 개발부, 마케팅부
		   
		   ////System.out.println("확인용 : " + gender);
		   // 확인용 : 남자
		   
		   
		   Map<String, String> paraMap = new HashedMap<>();
		   
		   paraMap.put("deptName", deptName);
		   paraMap.put("gradeLV", gradeLV);	
		   paraMap.put("gender", gender);	
		   
		   
			String str_currentShowPageNo = request.getParameter("currentShowPageNo");
			
	
			 int totalCount = 0;    // 총 회원 수 
			 int sizePerPage = 13;  // 한 페이지당 보여줄 회원 수 
			 int currentShowPageNo = 0; // 현재 보여주는 페이지 번호로서, 초기치로는 1페이지로 설정함. 
			 int totalPage = 0;         // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바)
			 
			 // 총 게시물 건수(totalCount)
			 totalCount = service.getTotalCount(paraMap);
		//	 //System.out.println("~~~~ 확인용 totalCount : " + totalCount); 

			 
			 totalPage = (int) Math.ceil((double)totalCount/sizePerPage); 
			 
			 if(str_currentShowPageNo == null) {
				 currentShowPageNo = 1;
			 }
			 
			 else {
				  
				 try {
					 currentShowPageNo = Integer.parseInt(str_currentShowPageNo); 
					 
					 if(currentShowPageNo < 1 || currentShowPageNo > totalPage) {
						 currentShowPageNo = 1;
					 }
					 
				 } catch(NumberFormatException e) {
					 currentShowPageNo = 1;
				 }
			 }
			 
			 int startRno = ((currentShowPageNo - 1) * sizePerPage) + 1; // 시작 행번호 
			 int endRno = startRno + sizePerPage - 1; // 끝 행번호 
				
			 paraMap.put("startRno", String.valueOf(startRno));
			 paraMap.put("endRno", String.valueOf(endRno));
			 
		  	List<Map<String, String>> empList =  service.empList(paraMap);
	   
		    request.setAttribute("deptNameList", deptNameList);
		    
			int blockSize = 10;
		
			int loop = 1;
			
			
			int pageNo = ((currentShowPageNo - 1)/blockSize) * blockSize + 1;
			// *** !! 공식이다. !! *** //
			
			
			String pageBar = "<ul style='list-style:none;'>";
			String url = "empList.gw";
			
			// === [맨처음][이전] 만들기 === // 
			if(pageNo != 1) {
				pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+url+"?deptName="+deptName+"&gradeLV="+gradeLV+"&gender="+gender+"&currentShowPageNo=1'>[맨처음]</a></li>";
				pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?deptName="+deptName+"&gradeLV="+gradeLV+"&gender="+gender+"&currentShowPageNo="+(pageNo-1)+"'>[이전]</a></li>";
			}
			
			while( !(loop > blockSize || pageNo > totalPage) ) {
				
				if(pageNo == currentShowPageNo) {
					pageBar += "<li style='display:inline-block; width:30px; font-size:12pt; color:red; padding:2px 4px;'>"+pageNo+"</li>";
				}
				else {
					pageBar += "<li style='display:inline-block; width:30px; font-size:12pt;'><a href='"+url+"?deptName="+deptName+"&gradeLV="+gradeLV+"&gender="+gender+"&currentShowPageNo="+pageNo+"'>"+pageNo+"</a></li>"; 
				}
				
				loop++;
				pageNo++;
			}// end of while-------------------------
			
			
			// === [다음][마지막] 만들기 === //
			if(pageNo <= totalPage) {
				pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?deptName="+deptName+"&gradeLV="+gradeLV+"&gender="+gender+"&currentShowPageNo="+pageNo+"'>[다음]</a></li>";
				pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+url+"?deptName="+deptName+"&gradeLV="+gradeLV+"&gender="+gender+"&currentShowPageNo="+totalPage+"'>[마지막]</a></li>";
			}
			
			pageBar += "</ul>";
			
			request.setAttribute("pageBar", pageBar);
			
			String goBackURL = MyUtil.getCurrentURL(request);
		 	// //System.out.println("~~~ 확인용(list.action) goBackURL : " + goBackURL);
		
			request.setAttribute("goBackURL", goBackURL);
			request.setAttribute("empList", empList);

		   
		   return "emp/pay/payList.tiles_MTS";   
	   
	   }
	   
	   
	 	@GetMapping("/department_management.gw") 
	 	public String department_management() {
	 				
	 		return "emp/department/department_manage.tiles_MTS";
	 	}
	 	
	 	
	 	@ResponseBody
	 	@GetMapping("/emp/department_id_max.gw")
		public String department_id_max() {
			int department_id_max = service.department_id_max();
			JsonObject jsonObj = new JsonObject();
			jsonObj.addProperty("department_id_max", department_id_max+100);
			return new Gson().toJson(jsonObj);
		}
	 	
	 	@ResponseBody
		@GetMapping(value="/emp/manager_id.gw" , produces="text/plain;charset=UTF-8")
	 	public String manager_id() {
	 		List<Map<String, String>> manager_id_List = service.manager_id();
			JsonArray jsonArr = new JsonArray(); // []
			if(manager_id_List != null && manager_id_List.size() > 0) {
				for(Map<String, String> map : manager_id_List) {
					JsonObject jsonObj = new JsonObject(); // {}
					jsonObj.addProperty("manager_id", map.get("employee_id"));
					jsonObj.addProperty("name", map.get("name"));
					////System.out.println(map.get("name"));
					jsonArr.add(jsonObj); 
				}// end of for-------------------------
			}
			return new Gson().toJson(jsonArr);
	 		
	 	}
	   
	 	@ResponseBody
		@GetMapping(value="/emp/select_department.gw" , produces="text/plain;charset=UTF-8")
	 	public String select_department() {
	 		List<Map<String, String>> departmentsList = service.select_department(); 
			JsonArray jsonArr = new JsonArray(); // []
			if(departmentsList != null && departmentsList.size() > 0) {
				for(Map<String, String> map : departmentsList) {
					JsonObject jsonObj = new JsonObject(); // {}
					jsonObj.addProperty("department_id", map.get("department_id"));
					jsonObj.addProperty("department_name", map.get("department_name"));
					jsonObj.addProperty("employee_id", map.get("employee_id"));
					jsonObj.addProperty("name", map.get("name"));
					jsonObj.addProperty("phone", map.get("phone"));
					jsonArr.add(jsonObj); 

				}// end of for-------------------------
			}
			return new Gson().toJson(jsonArr);
	 		
	 	}
	 	
	 	@ResponseBody
		@GetMapping(value="/emp/select_team.gw" , produces="text/plain;charset=UTF-8")
	 	public String select_departments() {
	 		List<Map<String, String>> departmentsList = service.select_departments(); 
			JsonArray jsonArr = new JsonArray(); // []
			if(departmentsList != null && departmentsList.size() > 0) {
				for(Map<String, String> map : departmentsList) {
					JsonObject jsonObj = new JsonObject(); // {}
					jsonObj.addProperty("department_name", map.get("department_name"));
					jsonObj.addProperty("team_id", map.get("team_id"));
					jsonObj.addProperty("team_name", map.get("team_name"));
					jsonObj.addProperty("t_manager_id", map.get("t_manager_id"));
					jsonObj.addProperty("t_manager_name", map.get("t_manager_name"));
					jsonObj.addProperty("t_manager_phone", map.get("t_manager_phone"));
					jsonArr.add(jsonObj); 
				}// end of for-------------------------
			}
			return new Gson().toJson(jsonArr);
	 		
	 	}
	   
	 	
	 	 // 신규부서 입력하기 
	 	@ResponseBody
	 	@GetMapping(value="emp/department_add.gw", produces="text/plain;charset=UTF-8") 
	     public String department_add(@RequestParam(defaultValue = "") String department_id,
                                      @RequestParam(defaultValue = "") String department_name,
                                      @RequestParam(defaultValue = "") String manager_id) {
		 	////System.out.println("department_id"+department_id);
		 	////System.out.println("department_name"+department_name);
		 	////System.out.println("manager_id"+manager_id);
		 		
	 		try {
	 			return service.department_add(department_id, department_name, manager_id);
	 		} catch(Throwable e) { // 부서번호 입력시 이미 존재하는 부서번호를 입력하여 department_id 컬럼에 Primary Key 제약에 위배된 경우 
	 			return "{\"n\":0}";
	 		}
	 	}
	 		 	

	 	@ResponseBody
		@GetMapping(value="/emp/T_manager_id.gw" , produces="text/plain;charset=UTF-8")
	 	public String T_manager_id() {
	 		List<Map<String, String>> T_manager_id_List = service.T_manager_id();
			JsonArray jsonArr = new JsonArray(); // []
			if(T_manager_id_List != null && T_manager_id_List.size() > 0) {
				for(Map<String, String> map : T_manager_id_List) {
					JsonObject jsonObj = new JsonObject(); // {}
					jsonObj.addProperty("manager_id", map.get("employee_id"));
					jsonObj.addProperty("name", map.get("name"));
					////System.out.println(map.get("name"));
					jsonArr.add(jsonObj); 
				}// end of for-------------------------
			}
			return new Gson().toJson(jsonArr);
	 	}
	 	
	 	// 부서별 최대 팀값 알아오기
	 	@ResponseBody
	 	@GetMapping(value = "/emp/team_id_max_by_department.gw", produces = "text/plain;charset=UTF-8")
	 	public String team_id_max_by_department(@RequestParam(defaultValue = "") String department_id) {
	 	    
	 		int team_id_max_by_department = service.team_id_max_by_department(department_id);

	 	    // //System.out.println( "team_id_max_by_department" + team_id_max_by_department);
	 	    JsonObject jsonObj = new JsonObject();
	 	    jsonObj.addProperty("team_id_max_by_department", team_id_max_by_department);
			return new Gson().toJson(jsonObj);
	 	}
	 	
	 	
	 	// 부서별 팀 이름 및 번호알아오기
	 	@ResponseBody
	 	@GetMapping(value = "/emp/team_id_select_by_department.gw", produces = "text/plain;charset=UTF-8")
	 	public String team_id_select_by_department(@RequestParam(defaultValue = "") String department_id) {
	 	    
	 		////System.out.println(department_id);
	 		List<Map<String, String>> team_id_select_by_department = service.team_id_select_by_department(department_id);

	 		JsonArray jsonArr = new JsonArray(); // []
			if(team_id_select_by_department != null && team_id_select_by_department.size() > 0) {
				for(Map<String, String> map : team_id_select_by_department) {
					JsonObject jsonObj = new JsonObject(); // {}
					jsonObj.addProperty("team_id", map.get("team_id"));
					jsonObj.addProperty("team_name", map.get("team_name"));
					jsonObj.addProperty("t_manager_id", map.get("t_manager_id"));
					jsonObj.addProperty("name", map.get("name"));
					jsonArr.add(jsonObj); 
				}// end of for-------------------------
			}
			return new Gson().toJson(jsonArr);
	 	}
	 	
	 	
	 	 // 신규부서 입력하기 
	 	@ResponseBody
	 	@GetMapping(value="emp/team_add.gw", produces="text/plain;charset=UTF-8") 
	     public String team_add(@RequestParam(defaultValue = "") String department_id,
                                  @RequestParam(defaultValue = "") String team_id,
                                  @RequestParam(defaultValue = "") String team_name,
                                  @RequestParam(defaultValue = "") String t_manager_id) {
		 	
	 		////System.out.println("department_id"+department_id);
		 	////System.out.println("team_id"+team_id);
		 	////System.out.println("team_name"+team_name);
		 	////System.out.println("t_manager_id"+t_manager_id);
			

		   Map<String, String> paraMap = new HashedMap<>();
		   
		   paraMap.put("department_id", department_id);
		   paraMap.put("team_id", team_id);	
		   paraMap.put("team_name", team_name);	
		   paraMap.put("t_manager_id", t_manager_id);	
		   
		   
		   String team_add = service.team_add(paraMap);
		 	
		   return team_add ;
	 		
	 	}
	 	
	 	// 부서에 따른 부서 내 정보 가져오기
	 	@ResponseBody
	 	@GetMapping(value = "/emp/get_department_info.gw", produces = "text/plain;charset=UTF-8")
	 	public String get_department_info(@RequestParam(defaultValue = "") String department_id) {
	 		// //System.out.println("department_id" + department_id);
	 		
	 		List<Map<String, String>> get_department_info = service.get_department_info(department_id);
			JsonArray jsonArr = new JsonArray(); // []
			if(get_department_info != null && get_department_info.size() > 0) {
				for(Map<String, String> map : get_department_info) {
					JsonObject jsonObj = new JsonObject(); // {}
					jsonObj.addProperty("manager_id", map.get("employee_id"));
					jsonObj.addProperty("name", map.get("name"));
					jsonObj.addProperty("phone", map.get("phone"));
					jsonObj.addProperty("job_name", map.get("job_name"));
					jsonArr.add(jsonObj); 
				}// end of for-------------------------
			}
			return new Gson().toJson(jsonArr);
	 	}
	 	
	 	
	 	@ResponseBody
	 	@GetMapping(value = "/emp/get_team_info.gw", produces = "text/plain;charset=UTF-8")
	 	public String get_team_info(@RequestParam(defaultValue = "") String team_id) {
	 		 //System.out.println("team_id" + team_id);
	 		
	 		List<Map<String, String>> get_team_info = service.get_team_info(team_id);
			JsonArray jsonArr = new JsonArray(); // []
			if(get_team_info != null && get_team_info.size() > 0) {
				for(Map<String, String> map : get_team_info) {
					JsonObject jsonObj = new JsonObject(); // {}
					jsonObj.addProperty("manager_id", map.get("employee_id"));
					jsonObj.addProperty("name", map.get("name"));
					jsonObj.addProperty("phone", map.get("phone"));
					jsonObj.addProperty("job_name", map.get("job_name"));
					jsonArr.add(jsonObj); 
				}// end of for-------------------------
			}
			return new Gson().toJson(jsonArr);
	 	}
	 	
	 	
	 // 부서삭제하기
	 	@ResponseBody
	 	@GetMapping(value = "/emp/department_del.gw", produces = "text/plain;charset=UTF-8")
		public String department_del(String department_id) {
	 		 try {
	             int result = service.department_del(department_id);
	             return "{\"n\":" + result + "}";
	         } catch (Exception e) {
	             return "{\"n\":0}";
	 		}
	 	}
	 	

	 	
		 // 부서삭제하기
		 	@ResponseBody
		 	@GetMapping(value = "/emp/team_del.gw", produces = "text/plain;charset=UTF-8")
			public String team_del(String team_id) {
		 		 try {
		             int result = service.team_del(team_id);
		             return "{\"n\":" + result + "}";
		         } catch (Exception e) {
		             return "{\"n\":0}";
		 		}
		 	}
	 	
	 	
	 	
		 	
		 // 수정페이지 요청
			@GetMapping("/infoEdit.gw")
			public ModelAndView requiredLogin_myinfoEdit(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
				
					String employee_id = request.getParameter("employee_id");
				   ////System.out.println("employee_id" + employee_id);
				   //employee_id9999
				   
				   Map<String, String> empOneDetail = service.oneMemberMap(employee_id);
				   
				   String name = empOneDetail.get("name");
				   ////System.out.println("name" + name);
				   //name이요섭
				   
				   
		        	mav.addObject("empOneDetail", empOneDetail);
		        	mav.setViewName("emp/member/infoEdit.tiles_MTS");
				
				return mav;
			}
			
			
			
			// 부서별 팀 이름 및 번호알아오기
		 	@ResponseBody
		 	@GetMapping(value = "/emp/job_id_select_by_department.gw", produces = "text/plain;charset=UTF-8")
		 	public String job_id_select_by_department(@RequestParam(defaultValue = "") String department_id) {
		 	    
		 		//////System.out.println(department_id);
		 		
		 		List<Map<String, String>> job_id_select_by_department = service.job_id_select_by_department(department_id);

		 		JsonArray jsonArr = new JsonArray(); // []
				if(job_id_select_by_department != null && job_id_select_by_department.size() > 0) {
					for(Map<String, String> map : job_id_select_by_department) {
						JsonObject jsonObj = new JsonObject(); // {}
						jsonObj.addProperty("job_id", map.get("job_id"));
						jsonObj.addProperty("job_name", map.get("job_name"));
						jsonObj.addProperty("fk_team_id", map.get("fk_team_id"));
						jsonObj.addProperty("gradelevel", map.get("gradelevel"));
						jsonArr.add(jsonObj); 
					}// end of for-------------------------
				}
				return new Gson().toJson(jsonArr);
		 	}
			
	 	
		 // 프로필 수정하기 
			@PostMapping("/emp/infoEditEnd.gw")
			public ModelAndView requiredLogin_myinfoEditEnd(HttpServletRequest request, HttpServletResponse response, ModelAndView mav, EmployeesVO evo, MultipartHttpServletRequest mrequest) {
			
				//System.out.println(request.getParameter("fk_department_id"));
				//System.out.println(request.getParameter("fk_team_id"));
				//System.out.println(request.getParameter("fk_job_id"));
				//System.out.println(request.getParameter("employee_id"));

				
				int n = service.infoEditEnd(evo);
					
					//System.out.println("n" + n);
				
				if(n==1) {
					mav.addObject("message","부서발령 성공!!");
					mav.addObject("loc", request.getContextPath()+"/emp/empList.gw");
					mav.setViewName("msg");
				}
				
				return mav;
			}
	 	
	 	
	 	
	 	
	}
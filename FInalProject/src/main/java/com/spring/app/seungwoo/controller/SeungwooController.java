package com.spring.app.seungwoo.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.spring.app.domain.EmployeesVO;
import com.spring.app.domain.JobsVO;
import com.spring.app.domain.TeamVO;
import com.spring.app.seungwoo.service.*;

	@Controller
	public class SeungwooController {
	   
	   
	@Autowired // Type에 따라 알아서 Bean 을 주입해준다.
	private SeungwooService service;
	   
	
	// ========= ******* 그룹웨어 시작 ******* ========= //         
    @GetMapping(value="/workflow_b.gw", produces="text/plain;charset=UTF-8")
    
    public ModelAndView workflow_b(ModelAndView mav) {
	    
    	mav = service.workflow_b(mav);
	   
	    return mav;
    
    }// end of public ModelAndView home(ModelAndView mav)
        
    // === 부서에 해당하는 팀 찾기 === //
    @ResponseBody
    @GetMapping(value="/FinalProject/searchteam.gw", produces="text/plain;charset=UTF-8")
    public String searchteams(HttpServletRequest request) {
 	   
 	    String deptno = request.getParameter("deptno");
 	    
 	    System.out.println("deptno=>"+deptno);
 	    
 	    List<TeamVO> teamList = service.searchteam(deptno);
 	   
 	    JSONArray jsonArr = new JSONArray(); // []
 	   
 	    if(teamList != null) {
 		    for(TeamVO teamvo : teamList) {
 			    JSONObject jsonObj = new JSONObject(); // {};
 			    jsonObj.put("team_id", teamvo.getTeam_id());
 			    jsonObj.put("Fk_department_id", teamvo.getFk_department_id());
 			    jsonObj.put("team_name", teamvo.getTeam_name()); 
 			    jsonObj.put("t_manager_id", teamvo.getT_manager_id()); 
 			    jsonArr.put(jsonObj);
 		    } // end of for -------------------------
 	    }
 	    
 	    return jsonArr.toString();
    }
	
    // ===  팀에 해당하는 직업 찾기 === //	   
    @ResponseBody
    @GetMapping(value="/FinalProject/searchjobs.gw", produces="text/plain;charset=UTF-8")
    public String searchjobs(HttpServletRequest request) {
 	   
 	    String teamno = request.getParameter("teamno");
 	    
 	    System.out.println("teamno=>"+teamno);
 	    
 	    List<JobsVO> jobList = service.searchjob(teamno);
 	    
 	   
 	    JSONArray jsonArr = new JSONArray(); // []
 	   
 	    if(jobList != null) {
 		    for(JobsVO jobvo : jobList) {
 			    JSONObject jsonObj = new JSONObject(); // {};
				jsonObj.put("job_id", jobvo.getJob_id());
 			    jsonObj.put("fk_department_id", jobvo.getFk_department_id());
 			    jsonObj.put("job_name", jobvo.getJob_name());
 			    jsonObj.put("basic_salary", jobvo.getBasic_salary());
 			    jsonObj.put("min_salary", jobvo.getMin_salary());
 			    jsonObj.put("max_salary", jobvo.getMax_salary());
 			    jsonObj.put("gradelevel", jobvo.getGradelevel());
 			    jsonObj.put("fk_team_id", jobvo.getFk_team_id());
 			    jsonArr.put(jsonObj);
 		    } // end of for -------------------------
 	    }
 	    
 	    return jsonArr.toString();
    }
    
    @ResponseBody
    @GetMapping("/FinalProject/emptyjob.gw") 
    public String emptyjob(HttpServletRequest request) {
    
    	String jobno = request.getParameter("jobno");
    	System.out.println(jobno);
    	
    	boolean	flag = false;
    	
    	EmployeesVO empvo = service.emptyjob(jobno);
    	
    	// System.out.println("시발"+empvo.getEmail());
    	
    	if(empvo == null) {
    		flag = true;
    	}
    	else {
    		flag = false;
    	}
    	
    	JSONObject jsonObj = new JSONObject();  // {}
		jsonObj.put("flag", flag);      
    	String json = jsonObj.toString();       
    	
    	System.out.println(json);
    	return jsonObj.toString();
    		
    }	
   
    @ResponseBody
    @PostMapping("/FinalProject/email_uq.gw") 
    public String email_uq(HttpServletRequest request) {
    	
    	String uq_email = request.getParameter("uq_email");
    	System.out.println(uq_email);
    	
    	boolean	flag = false;
    	
    	EmployeesVO empvo = service.email_uq(uq_email);
    	
    	// System.out.println("시발"+empvo.getEmail());
    	
    	if(empvo == null) {
    		
    		flag = false;
    	}
    	else {
    		flag = true;
    	}
    	
    	JSONObject jsonObj = new JSONObject();  // {}
		jsonObj.put("flag", flag);      
    	String json = jsonObj.toString();       
    	
    	System.out.println(json);
    	return jsonObj.toString();
    	
    }
   
    
    @PostMapping("/invitation_email.gw") 
    public ModelAndView invitation_email(ModelAndView mav, HttpServletRequest request, EmployeesVO empvo) {
    	
        // mav = service.workflow_b(mav);
    	// System.out.println("시발"+empvo.getFk_team_id() + empvo.getFk_job_id());
    	
    	String seq = service.searchseq();
    	
    	System.out.println(seq);
    	
    	String job_id =  empvo.getFk_job_id();
    	String team_id = empvo.getFk_team_id();
    	
        Map<String, String> paraMap = new HashMap<>();
        paraMap.put("job_id",job_id);
        paraMap.put("team_id",team_id);
    	
         
        Map<String, String> selectinfomap = service.selectinfo(paraMap);
    	
        if (selectinfomap == null) {
        	mav.addObject("message", "입력해야되는 정보를 모두 조회하지 못했습니다.");
			mav.addObject("loc", request.getContextPath()+"/workflow_b.gw");
			mav.setViewName("msg");
        }
        
        else {
        	
//        	mav.addObject("message", "입력해야되는 정보를 모두 조회했습니다.");
//			mav.addObject("loc", request.getContextPath()+"/workflow_b.gw");
//			mav.setViewName("msg");
        	
        	empvo.setEmployee_id(seq);
        	empvo.setFk_department_id(selectinfomap.get("fk_department_id"));
        	empvo.setFk_job_id(selectinfomap.get("job_id"));
        	empvo.setGradelevel(selectinfomap.get("gradelevel"));
        	empvo.setFk_team_id(selectinfomap.get("team_id"));
        	empvo.setT_manager_id(selectinfomap.get("t_manager_id"));
        	empvo.setSalary(selectinfomap.get("basic_salary"));
        	empvo.setManager_id(selectinfomap.get("manager_id"));
        	
        	// System.out.println("아이우에요" + empvo.getName());
        	
        	// System.out.println("제발나와라"+selectinfomap.get("fk_department_id"));
        	
        	int n = service.insertinfo(empvo);
        	
        	System.out.println("n=>"+n);
        	
        	if(n==1) {
        		
        		
        		
        		if (empvo.getGradelevel().equals("3") || empvo.getGradelevel().equals("5")) {
        			
        			Map<String, String> gradeMap = new HashMap<>(); 
            		gradeMap.put("seq", seq);
            		gradeMap.put("gradelevel", empvo.getGradelevel());
            		gradeMap.put("team_id", empvo.getFk_team_id());
            		gradeMap.put("dept_id", empvo.getFk_department_id());
            		
            	    int n1 = service.t_m_update(gradeMap);
            	    
            	    System.out.println("n1=>"+n1);
        
            	    if(n1==1) {
    					
            	    	int n2 = service.emp_t_m_update(gradeMap);
            	    	System.out.println("n2=>"+n2);
	            	    	
            	    	if(n2 >= 1) {
        	        	    
							/*
							 * mav.addObject("message", "n2 성공"); mav.addObject("loc",
							 * request.getContextPath()+"/workflow_b.gw"); mav.setViewName("msg");
							 */
        					
        					boolean suc = false;
        		        	
        				     
        		        	if(n2 >= 1) { // insert 가 성공했다면
        		        		
        		        	
        		        		
        		        		suc = service.invitationEmail(empvo,selectinfomap);
        		        		
        		        		if(suc==true) {
        		    				mav.addObject("message", "메일 및 문자 발송 성공");
        		    				mav.addObject("loc", request.getContextPath()+"/workflow_b.gw");
        		    				mav.setViewName("msg");
        		    			}
        		        		else {
        		    				mav.addObject("message", "메일 및 문자 발송 실패");
        		    				mav.addObject("loc", request.getContextPath()+"/workflow_b.gw");
        		    				mav.setViewName("msg");
        		    			}

        		       	   	} 
        		        	
        		       	   
        					
        					
            	    	
            	    	
            	    	
            	    	} // end of if(n2==1) -----
            	    	else {
            	    		
                	    	mav.addObject("message", "n2 실패");
            				mav.addObject("loc", request.getContextPath()+"/workflow_b.gw");
            				mav.setViewName("msg");
            	    	} // end of else(n2==1) -----
            	    	
            	    } // if(n1==1) { -----
            	    
            	    else {
            	    	mav.addObject("message", "n1 실패");
     	        	    mav.addObject("loc", request.getContextPath()+"/workflow_b.gw");
     					mav.setViewName("msg");
            	    	
            	    } // else(n1==1) { -----
        		
        		} // if (empvo.getGradelevel().equals("3") || empvo.getGradelevel().equals("5")) -----
        		
        		else {
        			
        			
        			boolean suc = false;
		        	
				     
		        	if(n == 1) { // insert 가 성공했다면
		        		
		        	
		        		
		        		suc = service.invitationEmail(empvo,selectinfomap);
		        		
		        		if(suc==true) {
		    				mav.addObject("message", "메일 및 문자 발송 성공");
		    				mav.addObject("loc", request.getContextPath()+"/workflow_b.gw");
		    				mav.setViewName("msg");
		    			}
		        		else {
		    				mav.addObject("message", "메일 및 문자 발송 실패");
		    				mav.addObject("loc", request.getContextPath()+"/workflow_b.gw");
		    				mav.setViewName("msg");
		    			}

		       	   	} 
        			
        		
        		} // end of else (empvo.getGradelevel().equals("3") || empvo.getGradelevel().equals("5")) -----
    
        	} // end of if (n==1)
        	
        	else {
    	    	mav.addObject("message", "n 실패");
				mav.addObject("loc", request.getContextPath()+"/workflow_b.gw");
				mav.setViewName("msg");
    	    } // end of else (n==1)
        	    
        	    
        	    
        } // end of else ----
        
        
        
        
        
        return mav;
        
    } // public ModelAndView invitation_email(ModelAndView mav, HttpServletRequest request, EmployeessVO empvo) -----   
    
    
    @ResponseBody
    @PostMapping("/FinalProject/unready_del.gw") 
    public String unready_del(HttpServletRequest request) {
    	    	
    	String gradelevel_join = request.getParameter("gradelevel_join");
    	System.out.println(gradelevel_join);
    	String empid_join = request.getParameter("empid_join");
    	System.out.println(empid_join);
    	
    	
    	String[] gradelevel_arr = gradelevel_join.split("\\,");
    	String[] empid_arr = empid_join.split("\\,");
    	
    	// Map<String, Object> paraMap = new HashMap<>();
    	
    	// paraMap.put("gradelevel_arr", gradelevel_arr); 
	    // paraMap.put("empid_arr", empid_arr); 
	    
	    System.out.println(gradelevel_arr);
	    System.out.println(empid_arr);
	    
	    for(int i=0; i<gradelevel_arr.length; i++) {
	    	
	    	System.out.println(empid_arr[i]);
	    	System.out.println(gradelevel_arr[i]);
	    	
	    	if (gradelevel_arr[i].equals("3")||gradelevel_arr[i].equals("5"))  {
	    		
	    		Map<String, String> upMap = new HashMap<>();
	    		String empid = empid_arr[i];
	    		String gradelevel = gradelevel_arr[i];
	    		
	    		upMap.put("empid",empid);
	    		upMap.put("gradelevel",gradelevel);
	    		
	    		System.out.println();
	    		int dept_team = service.dept_team_update(upMap);
	    		System.out.println("굿dept_team"+dept_team);
	    		if(dept_team == 1)  {
	    			
	    			int emp_dept_team = service.emp_dept_team(upMap);
	    			System.out.println("굿emp_dept_team"+emp_dept_team);
	    		}
	    		
	    	}
	    
        }// end of for----------------------
    	
	    Map<String, Object> empidMap = new HashMap<>();
	    empidMap.put("empid_arr",empid_arr);
	    int del = service.last_unreadydel(empidMap);
    	
	    boolean delsuc = false;
	    
	    if(del == gradelevel_arr.length) {
	    	delsuc = true;
    	}
    	else {
    		delsuc = false;
    	}
    	
    	JSONObject jsonObj = new JSONObject();  // {}
		jsonObj.put("delsuc", delsuc);      
    	String json = jsonObj.toString();       
    	
    	System.out.println(json);
    	
    	return jsonObj.toString();
	    
   
    }
    
    
   	/*   	
        	
        	boolean suc = false;
        	
     
        	if(n==1) { // insert 가 성공했다면
        		
        	
        		
        		suc = service.invitationEmail(empvo,selectinfomap);
        		
        		if(suc==true) {
    				mav.addObject("message", "메일 및 문자 발송 성공");
    				mav.addObject("loc", request.getContextPath()+"/workflow_b.gw");
    				mav.setViewName("msg");
    			}
        		else {
    				mav.addObject("message", "메일 및 문자 발송 실패");
    				mav.addObject("loc", request.getContextPath()+"/workflow_b.gw");
    				mav.setViewName("msg");
    			}

       	   	} 
        	
       	   	else { // insert 가 실패했다면
        		mav.addObject("message", "입력해야되는 정보를 모두 입력하지못했습니다.");
    			mav.addObject("loc", request.getContextPath()+"/workflow_b.gw");
    			mav.setViewName("msg");
       	   	}
        	

        } // end of else -----
       
        return mav;
    	
    }
    
        	*/

    
    
	   
	   
	   
	   
	   
	   
	   
	   
	   
	   
	} // public class SeungwooController
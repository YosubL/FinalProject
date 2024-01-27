package com.spring.app.kimkm.controller;

import java.io.File;
import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.spring.app.common.FileManager;
import com.spring.app.common.Sha256;
import com.spring.app.domain.EmployeesVO;
import com.spring.app.kimkm.service.RegisterService;

@Controller
public class RegisterController {

	@Autowired
	private RegisterService service;
	
	@Autowired
	private FileManager fileManager;
	
	// 회원가입 페이지 요청
	@GetMapping("/register.gw")
	public ModelAndView register(ModelAndView mav, HttpServletRequest request) {
		
		String email = request.getParameter("email");
		  
		Map<String, String> register = service.selectRegister(email);

		mav.addObject("register", register);
		mav.setViewName("register/register");
		
		return mav;
	}
	
	
	// 회원가입
	@PostMapping("/registerEnd.gw")
	public ModelAndView registerEnd(ModelAndView mav, EmployeesVO evo, HttpServletRequest request) {
		
		String pwd = Sha256.encrypt(evo.getPwd());
		evo.setPwd(pwd);

		int idx = evo.getEmail().indexOf("@");

		if (idx != -1) {
		    String userid = evo.getEmail().substring(0, idx);
		    evo.setUserid(userid);
		}
		
		evo.setPhoto("사원증기본이미지.png");
		evo.setSignimg("승인.png");
		
		int n = service.add_register(evo);
		
		String employee_id = request.getParameter("employee_id");
		
		int n2 = service.insert_vacation(employee_id);
		
		if(n*n2==1) {
			
			String message = "입사를 축하드립니다. 로그인 후 프로필 수정 부탁드립니다.";
			String loc = request.getContextPath()+"/login.gw";
			
			mav.addObject("message", message);
			mav.addObject("loc", loc);
			
			mav.setViewName("msg");
		}
		
		return mav;
	}

	
	// 프로필 페이지 요청
	@GetMapping("/myinfo.gw")
	public ModelAndView requiredLogin_myinfo(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
		HttpSession session = request.getSession();
		EmployeesVO loginuser = (EmployeesVO) session.getAttribute("loginuser");
		
        if(loginuser != null) {
        	String employee_id = loginuser.getEmployee_id();
		
			Map<String, String> gender_birthday = service.selectGenderBirthday(employee_id);
			
			Map<String, String> dept_team = service.selectDeptTeam(employee_id);
			
			Map<String, String> vacation = service.selectVacation(employee_id);
			
			int idx = dept_team.get("JOB_NAME").indexOf("팀 ");
			
			if (idx != -1) {
			    String JOB_NAME = dept_team.get("JOB_NAME").substring(idx+1);
			    dept_team.put("JOB_NAME", JOB_NAME);
			}
			
			
		 //	System.out.println(dept_team);
			
			mav.addObject("vacation", vacation);
			mav.addObject("dept_team", dept_team);
			mav.addObject("loginuser", loginuser);
			mav.addObject("gender_birthday", gender_birthday);
			mav.setViewName("myinfo/myinfo.tiles_MTS");
			
        }
        
        return mav;
	}
	
	
	// 수정페이지 요청
	@GetMapping("/myinfoEdit.gw")
	public ModelAndView requiredLogin_myinfoEdit(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
		HttpSession session = request.getSession();
		EmployeesVO loginuser = (EmployeesVO) session.getAttribute("loginuser");
		
		if(loginuser != null) {
			
			String employee_id = loginuser.getEmployee_id();
        	
        	Map<String, String> gender_birthday = service.selectGenderBirthday(employee_id);
        	
        	Map<String, String> dept_team = service.selectDeptTeam(employee_id);
        	
        	mav.addObject("loginuser", loginuser);
        	mav.addObject("gender_birthday", gender_birthday);
        	mav.addObject("dept_team", dept_team);
        	mav.setViewName("myinfo/myinfoEdit.tiles_MTS");
        }
		
		return mav;
	}
	
	
	// 프로필 수정하기 
	@PostMapping("/myinfoEditEnd.gw")
	public ModelAndView requiredLogin_myinfoEditEnd(HttpServletRequest request, HttpServletResponse response, ModelAndView mav, EmployeesVO evo, MultipartHttpServletRequest mrequest) {
		
		MultipartFile attach = evo.getAttach();
		
		String photo = request.getParameter("photo");
		
		if(attach != null) {
			
			HttpSession session = mrequest.getSession();
		 //	String root = session.getServletContext().getRealPath("/");
		 //	System.out.println("확인용 webapp 의 절대 경로 : "+ root);
		 //	확인용 webapp 의 절대 경로 : /Users/sub/workspace_spring_framework/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/wtpwebapps/board/
		 //	String path = root + "resources" + File.separator + "empImg";
		 //	System.out.println("확인용 path : "+ path);
		 //	확인용 path : /Users/sub/workspace_spring_framework/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/wtpwebapps/board/resources/files
			
			String root = "C:\\git\\FinalProject\\FInalProject\\src\\main\\webapp\\";
		 //	System.out.println("~~~~ 확인용 webapp 의 절대경로 => " + root);
			String path = root + "resources" + File.separator + "images" + File.separator + "empImg";
		 //	System.out.println(path);
			
			String newFileName = "";
			 
			byte[] bytes = null;

			try {
				bytes = attach.getBytes();

				String originalFilename = attach.getOriginalFilename();
			 //	System.out.println("~~~ 확인용 originalFilename => " + originalFilename);
				// ~~~ 확인용 originalFilename => LG_싸이킹청소기_사용설명서.pdf

			 	newFileName = fileManager.doFileUpload(bytes, originalFilename, path);
			 //	System.out.println("~~~ 확인용 newFileName => " + newFileName);
				// ~~~ 확인용 newFileName => 20231124113719342939728234042.jpg
			 	
			 	if(newFileName == null) {
			 		evo.setPhoto(photo);
			 	}
			 	else {
			 		evo.setPhoto(newFileName);
			 	}
				

			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		System.out.println(evo.getPhoto());
		
		int n = service.myinfoEditEnd(evo);
				
		if(n==1) {
			mav.addObject("message", "프로필 수정 성공!!");
			mav.addObject("loc", request.getContextPath()+"/myinfo.gw");
			mav.setViewName("msg");
		}
		
		return mav;
	}

	
	// 비밀번호 변경 페이지 요청
	@GetMapping("/pwdUpdate.gw")
	public ModelAndView requiredLogin_pwdUpdate(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
		HttpSession session = request.getSession();
		EmployeesVO loginuser = (EmployeesVO) session.getAttribute("loginuser");
		
		mav.addObject("loginuser", loginuser);
		mav.setViewName("register/pwdUpdate");
		
		return mav;
	}
	
	
	//비밀번호 변경시 현재 비밀번호 암호화해 가져오기
	@ResponseBody
	@GetMapping(value="/pwdSha256.gw", produces="text/plain;charset=UTF-8")
	public String pwdSha256(HttpServletRequest request) {
		
		 String current_pwd = request.getParameter("current_pwd");
		 
		 String Sha_pwd = Sha256.encrypt(current_pwd);
		 
		 JSONArray jsonArr = new JSONArray(); // []
		   
		   if(Sha_pwd != null) {
			   JSONObject jsonObj = new JSONObject(); // {}
			   jsonObj.put("current_pwd", Sha_pwd);
			   
			   jsonArr.put(jsonObj);
		   }
		   
		   return jsonArr.toString();
		 
	}
	
	
	// 비밀번호 변경하기
	@PostMapping("/pwdUpdateEnd.gw")
	public ModelAndView requiredLogin_pwdUpdateEnd(HttpServletRequest request, HttpServletResponse response, ModelAndView mav, EmployeesVO evo) {
		
		String email = request.getParameter("email");
		String new_pwd = request.getParameter("pwd");
		
		String pwd = Sha256.encrypt(new_pwd);
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("email", email);
		paraMap.put("pwd", pwd);
		
		evo.setPwd(pwd);
	 //	System.out.println(pwd);
		
		int n = service.pwdUpdateEnd(paraMap);
		
		if(n==1) {
			mav.addObject("message", "비밀번호 변경 성공!!");
			mav.addObject("loc", request.getContextPath()+"/myinfo.gw");
			mav.setViewName("msg");
		}
		
		return mav;
	}
	
}

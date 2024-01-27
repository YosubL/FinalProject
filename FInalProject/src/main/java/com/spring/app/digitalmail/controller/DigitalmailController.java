package com.spring.app.digitalmail.controller;

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.request;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.spring.app.common.MyUtil;
import com.spring.app.common.digitalmail.util.DigitalmailFileManager;
import com.spring.app.common.digitalmail.util.SWUtil;
import com.spring.app.digitalmail.domain.EmailVO;
import com.spring.app.digitalmail.service.DigitalmailService;
import com.spring.app.domain.CommentVO;
import com.spring.app.domain.EmployeesVO;

@Controller
public class DigitalmailController {
	
	@Autowired 
	private DigitalmailService service;
	
	@Autowired
	private DigitalmailFileManager fileManager;
	
    // 메일 홈페이지
    @GetMapping(value="/digitalmail.gw", produces="text/plain;charset=UTF-8")
    public ModelAndView requiredLogin_digitalmail(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {

    	// HttpSession session = request.getSession();
    	// session.setAttribute("readCountPermission", "yes"); 조회수라면 해야되지만 나는 메일이기때문에 무조건 로그인 해야 들어올 수 있다.
    	
    	String searchType = request.getParameter("searchType");
    	String searchWord = request.getParameter("searchWord");
    	String type = request.getParameter("type");
    	String war = "nothing";
    	if(type == null) {
    		type = "null";
    	}
    	//System.out.println("type=>"+type);
    	
    	// //System.out.println("new 프린트"+searchType+searchWord); // 검색바
		
		String str_currentShowPageNo = request.getParameter("currentShowPageNo");
				
		if(searchType == null) {
			searchType = "";
		}
		if(searchWord == null) {
			searchWord = "";
		}
		if(searchWord != null) {
			searchWord = searchWord.trim();
		}
		
		HttpSession session = request.getSession();
		EmployeesVO loginuser = (EmployeesVO)session.getAttribute("loginuser");
		String email = loginuser.getEmail();
		String fk_team_id = loginuser.getFk_team_id();
		String fk_dept_id = loginuser.getFk_department_id();
		// //System.out.println("email=>"+email);
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("searchType", searchType);
		paraMap.put("searchWord", searchWord);
		paraMap.put("type", type);
		paraMap.put("email", email);
		paraMap.put("fk_team_id", fk_team_id);
		paraMap.put("fk_dept_id", fk_dept_id);
		// 먼저, 내가 받은 총 메일 건수(totalCount)를 구해와야 한다.
		// 총 게시물 건수(totalCount)는 검색조건이 있을 때와 없을때로 나뉘어진다. 
		int totalCount = 0;    		// 총 게시물 건수 
		int sizePerPage = 12;  		// 한 페이지당 보여줄 게시물 건수 
		int currentShowPageNo = 0;  // 현재 보여주는 페이지 번호로서, 초기치로는 1페이지로 설정함. 
		int totalPage = 0;          // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바)
		int currentShowPageNodel = 1;
		int currentShowPageNoplus = 1;
		
		totalCount = service.getTotalCount(paraMap);
		
		//System.out.println("totalCount=>"+totalCount);
		
		totalPage = (int) Math.ceil((double)totalCount/sizePerPage); 
    	
		if(str_currentShowPageNo == null) {
			 // 메일 초기에 보여지는 화면
			 currentShowPageNo = 1;
			 currentShowPageNoplus = 2;
			 currentShowPageNodel = 1;
			 mav.addObject("war", war);
		 }
		 else {
			 mav.addObject("war", war);
			 currentShowPageNo = Integer.parseInt(str_currentShowPageNo);
			 currentShowPageNodel = currentShowPageNo-1;
			 currentShowPageNoplus = currentShowPageNo+1;
			 try {
	             currentShowPageNo = Integer.parseInt(str_currentShowPageNo); 
				 if(currentShowPageNo < 1 ) { // 유효성 검사   
					war = "down";
					currentShowPageNo = 1;
					currentShowPageNodel = 1;
					currentShowPageNoplus = 2;
					mav.addObject("war", war);
				 }
				 else if(currentShowPageNo > totalPage) {
					 currentShowPageNo = totalPage;
					 currentShowPageNodel = totalPage-1;
					 currentShowPageNoplus = totalPage;
					 war = "up";
					 mav.addObject("war", war);
				 }
				 
	         } catch(NumberFormatException e) {
				 currentShowPageNo = 1; 
	         }
		 }
		
		 int startRno = ((currentShowPageNo - 1) * sizePerPage) + 1;    // 시작 행번호 
		 int endRno = startRno + sizePerPage - 1; 						// 끝 행번호 	
		 paraMap.put("startRno", String.valueOf(startRno));
		 paraMap.put("endRno", String.valueOf(endRno));
		 
		 //System.out.println("시작=>"+paraMap.get("startRno"));
		 //System.out.println("끝=>"+paraMap.get("endRno"));
		 
		 mav.addObject("type",type);
		 
		 mav= service.digitalmail(mav,paraMap);
		 
		 
		 
		 if("subject".equals(searchType) || 
		    "content".equals(searchType) ||
		    "subject_content".equals(searchType) || 
		    "name".equals(searchType)) {
			
			 mav.addObject("paraMap", paraMap);
		 
		 }
		
		 
		
		 
		// === 페이지바 만들기 (만들거면 해야되는데 굳이...?)  === //
		int blockSize = 10;
		int loop = 1;
		int pageNo = ((currentShowPageNo - 1)/blockSize) * blockSize + 1;
		// === 페이지바 만들기 (만들거면 해야되는데 굳이...?)  === //
		
		//System.out.println("currentShowPageNoplus=>"+currentShowPageNoplus);
		//System.out.println("currentShowPageNodel=>"+currentShowPageNodel);
		
		String url = "/FinalProject/digitalmail.gw";
		String pageBar = "<div class='emailList_settingsRight'>";
		
		pageBar +=	"<div class='icon_set'>";
		pageBar += "<a href='"+url+"?searchType="+searchType+"&type="+type+"&searchWord="+searchWord+"&currentShowPageNo="+(currentShowPageNodel)+"'>";
		pageBar += "<span class='material-icons-outlined icon_img' style='font-size: 24pt;'>chevron_left</span></a>";
		pageBar += "<span class='icon_text'>이전"	+currentShowPageNodel+"/"+totalPage+"</span></div>";
		pageBar +=	"<div class='icon_set'>";
		pageBar += "<a href='"+url+"?searchType="+searchType+"&type="+type+"&searchWord="+searchWord+"&currentShowPageNo="+(currentShowPageNoplus)+"'>";
		pageBar += "<span class='material-icons-outlined icon_img' style='font-size: 24pt;'>chevron_right</span></a>";
		pageBar += "<span class='icon_text'>다음"	+currentShowPageNoplus+"/"+totalPage+"</span></div>";
		pageBar += "</div>";
		
		mav.addObject("pageBar", pageBar);
		
		String goBackURL = MyUtil.getCurrentURL(request);
		mav.addObject("goBackURL", goBackURL); // 검색 결과로 돌아갈 때 사용할것
		
	    return mav;
    
    }
    // 메일 홈페이지 끝
    
    // === 이메일 키워드 입력시 자동글 완성하기  === //
 	@ResponseBody
 	@GetMapping(value="/emailwordSearchShow.gw", produces="text/plain;charset=UTF-8")
 	public String WordSearchShow(HttpServletRequest request) {
 		
 		String searchType = request.getParameter("searchType");
 		String searchWord = request.getParameter("searchWord");
 		String myEmail = request.getParameter("myEmail");
 		//System.out.println("searchType=>"+searchType);
 		//System.out.println("searchType=>"+searchWord);
 		
 	    //System.out.println("myEmail=>"+myEmail);
 		
 		Map<String, String> paraMap = new HashMap<>();
 		paraMap.put("searchType", searchType);
 		paraMap.put("searchWord", searchWord);
 		paraMap.put("myEmail", myEmail);
 		
 		List<String> wordList = service.emailWordSearchShow(paraMap);
 		
 		JSONArray jsonArr = new JSONArray(); // [] 
 		
 		if(wordList != null) {
 			for(String word : wordList) {
 				JSONObject jsonObj = new JSONObject(); // {} 
 				jsonObj.put("word", word);
 				
 				jsonArr.put(jsonObj); // [{},{},{}]
 			}// end of for------------
 		}
 		
 		return jsonArr.toString();
 	}
 	// === 이메일 키워드 입력시 자동글 완성하기  === //
 	
 	// === 이메일 쓰기 페이지 이동  === //
    @GetMapping(value="/digitalmailwrite.gw", produces="text/plain;charset=UTF-8")
    public ModelAndView requiredLogin_digitalmailwrite(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
    	
    	String sender = request.getParameter("sender");
    	String send_email_seq = request.getParameter("send_email_seq");
    	//String content = request.getParameter("content");
    	
    	String senderEmail = null;
    	//String subject = request.getParameter("subject");
    	
    	////System.out.println("sender + send_email_seq" + sender + send_email_seq);
    	
    	
    	if(sender == null) {
    		mav.addObject("senderEmail","null");
    		mav.addObject("content","null");
    		mav.addObject("subject","null");
    		mav = service.digitalmailwrite(mav);
    	}
    	else {
    		Map<String, String> paraMap = new HashMap<>();
    		paraMap = service.getsenderEmail(sender,send_email_seq);
    		mav.addObject("senderEmail",paraMap.get("senderEmail"));
    		mav.addObject("content",paraMap.get("email_content"));
    		mav.addObject("subject",paraMap.get("email_subject"));
    		mav = service.digitalmailwrite(mav);
    	}
    	
    	
    	
	    
    	return mav;
	    
    }// end of public ModelAndView home(ModelAndView mav)
    
    
    @ResponseBody
    @PostMapping(value="/addMail.gw", produces="text/plain;charset=UTF-8")
    public String addMail(MultipartHttpServletRequest mrequest) {
    	List<MultipartFile> fileList = mrequest.getFiles("fileList");
    	String send_emailstop_seq = mrequest.getParameter("send_emailstop_seq");
    	//System.out.println("send_emailstop_seq=>"+send_emailstop_seq);
    	
		StringBuilder originalFilenameB =new StringBuilder();
		StringBuilder newFileNameB =new StringBuilder();
		StringBuilder fileSizeB =new StringBuilder();
		
		String originalFilename ="";
		String newFileName ="";
		String fileSize ="";
		
		JSONObject jsonObj = new JSONObject();
		int lastsuc =0;
    	
		boolean fileUploadCK = true;
		// 파일 저장
		if( !fileList.isEmpty() ) {
			for(MultipartFile file : fileList) {
				
				HttpSession session = mrequest.getSession();
				// String root = session.getServletContext().getRealPath("/");
				String root = "C:\\git\\FinalProject\\FInalProject\\src\\main\\webapp";
				// //System.out.println("~~~~ 확인용 webapp 의 절대경로 => " + root);
				String path = root+"\\resources\\file\\email"+ File.separator;
				//System.out.println("~~~~ 확인용 path => " + path);		
				
				byte[] bytes = null;
				// 첨부파일의 내용물을 담는 것	
				
				try {
					bytes = file.getBytes();
					// 첨부파일의 내용물을 읽어오는 것
					String ogfilename = file.getOriginalFilename();
					originalFilenameB.append(ogfilename+",");
					newFileNameB.append(fileManager.doFileUpload(bytes, ogfilename, path)+",");					
					fileSizeB.append(String.valueOf(file.getSize())+","); // 첨부파일의 크기(단위는 byte임)
				} catch (Exception e) {
					fileUploadCK = false;
					e.printStackTrace();
				}
			}// end of for
			
			originalFilename = originalFilenameB.toString();
			newFileName = newFileNameB.toString();
			fileSize = fileSizeB.toString();
			
			//System.out.println("originalFilename=>"+originalFilename+"newFileName=>"+newFileName+"fileSize=>"+fileSize);
			
			originalFilename = 	SWUtil.removeComma(originalFilename);
			newFileName = 	SWUtil.removeComma(newFileName);
			fileSize = 	SWUtil.removeComma(fileSize);
			
			//System.out.println("originalFilename=>"+originalFilename+"newFileName=>"+newFileName+"fileSize=>"+fileSize);
		
		}// 파일 업로드 끝
    	
		//System.out.println("업로드 완료");
		
		if(fileUploadCK) {// 업로드 잘 됐으면 메일 보내기 실행
			
			Map<String, Object> paraMap = new HashMap<>();
			HttpSession session = mrequest.getSession();

			EmployeesVO loginuser = (EmployeesVO)session.getAttribute("loginuser");
			 
			String fk_sender_email = loginuser.getEmail();
			
			paraMap.put("fk_sender_email",fk_sender_email);
			paraMap.put("receieve_Email",mrequest.getParameter("receieve_Email"));
			
			// 참조메일
			if(mrequest.getParameter("receieveplus_Email") != null) {
				String receieveplus_Email = mrequest.getParameter("receieveplus_Email");
				paraMap.put("receieveplus_Email",receieveplus_Email);
			}
			else {
				paraMap.put("receieveplus_Email","");
			}
			
			// 숨김 참조 메일
			if(mrequest.getParameter("receievehidden_Email") != null) {
				String receievehidden_Email = mrequest.getParameter("receievehidden_Email");
				paraMap.put("receievehidden_Email",receievehidden_Email);
			}
			else {
				paraMap.put("receievehidden_Email","");
			}
			
			paraMap.put("subject",mrequest.getParameter("subject"));
			paraMap.put("contents", SWUtil.secureCode(mrequest.getParameter("contents")));
			
			// 예약 여부
			if(mrequest.getParameter("send_time") != "" && mrequest.getParameter("send_time") != null) {
				paraMap.put("send_time",mrequest.getParameter("send_time"));
			}
			else {
				paraMap.put("send_time","");
			}
			// 예약 여부
			
			paraMap.put("impt",mrequest.getParameter("impt"));
			
			// 개인 메일 여부
			paraMap.put("individualval",mrequest.getParameter("individualval"));
						
			// 카테고리 설정 여부
			if(mrequest.getParameter("categoryno") != null) {
				String categoryno = mrequest.getParameter("categoryno");
				paraMap.put("categoryno",categoryno);
			}
			else {
				paraMap.put("categoryno","");
			}
			
			paraMap.put("originalFilename",originalFilename);
			//System.out.println("originalFilename"+paraMap.get("originalFilename"));
			paraMap.put("newFileName",newFileName);
			//System.out.println("newFileName"+paraMap.get("newFileName"));
			paraMap.put("fileSize",mrequest.getParameter("fileSize"));
			//System.out.println("fileSize"+paraMap.get("fileSize"));
			//System.out.println("파일사이즈 어떻게 뜨냐? =>"+paraMap.get("fileSize"));
			
			if(mrequest.getParameter("password") != null) {
				String email_pwd = mrequest.getParameter("password");
				paraMap.put("email_pwd",email_pwd);
			}
			else {
				paraMap.put("email_pwd","");
			}
			
			paraMap.put("send_emailstop_seq",send_emailstop_seq);
			
			lastsuc = service.emailsucadd(paraMap);
			
			
			//System.out.println("emailsucadd=>"+lastsuc);
		}
		else {// 업로드중 문제 발생

			lastsuc=-1;
		}
		
		/*
		String impt = mrequest.getParameter("impt");
    	String contents = mrequest.getParameter("contents");
    	String subject = mrequest.getParameter("subject");
    	String receieve_Email = mrequest.getParameter("receieve_Email");
    	String receieveplus_Email = mrequest.getParameter("receieveplus_Email");
    	String receievehidden_Email = mrequest.getParameter("receievehidden_Email");
    	String date = mrequest.getParameter("date");
    	String rehour = mrequest.getParameter("rehour");
    	String remi = mrequest.getParameter("remi");
    	String send_time = mrequest.getParameter("send_time");
    	String password = mrequest.getParameter("password");
    	String individualval = mrequest.getParameter("individualval");
    	String categoryno = mrequest.getParameter("categoryno");
    	fileSize = mrequest.getParameter("fileSize");
    	
    	//System.out.println("categoryno=>"+categoryno+"individualval=>"+individualval+"impt=>"+impt+"receieve_Email=>"+receieve_Email+"receieveplus_Email=>"+receieveplus_Email+"receievehidden_Email=>"+receievehidden_Email);
    	
	
		 //System.out.println("fileList=>"+fileList+"contents=>"+contents+"subject=>"+
		 subject+"receieveEmailList=>"+receieve_Email + "date=>" + date + "rehour=>" +
		 rehour + "remi=>" + remi + "send_time=>" + send_time + "password =>"+
		 password + "fileSize=>" + fileSize);
		*/
    	
    	jsonObj.put("lastsuc", lastsuc);

		return jsonObj.toString(); 

    }
    
    
    
    // 임시저장 메일
    @ResponseBody
    @PostMapping(value="/addMailStop.gw", produces="text/plain;charset=UTF-8")
    public String addMailStop(HttpServletRequest request) {
    	
    	int addStop = 0;
    	
    	JSONObject jsonObj = new JSONObject();
    	
    	Map<String, Object> paraMap = new HashMap<>();
    	HttpSession session = request.getSession();
    	
    	EmployeesVO loginuser = (EmployeesVO)session.getAttribute("loginuser");
    	String fk_sender_email = loginuser.getEmail();
    	
    	paraMap.put("fk_sender_email",fk_sender_email);
    	paraMap.put("receieve_Email",request.getParameter("receieve_Email"));
    	
    	// 참조메일
    	if(request.getParameter("receieveplus_Email") != null) {
    		String receieveplus_Email = request.getParameter("receieveplus_Email");
    		paraMap.put("receieveplus_Email",receieveplus_Email);
    	}
    	else {
    		paraMap.put("receieveplus_Email","");
    	}
			
    	// 숨김 참조 메일
    	if(request.getParameter("receievehidden_Email") != null) {
    		String receievehidden_Email = request.getParameter("receievehidden_Email");
    		paraMap.put("receievehidden_Email",receievehidden_Email);
    	}
    	else {
    		paraMap.put("receievehidden_Email","");
    	}
			
		paraMap.put("subject",request.getParameter("subject"));
		paraMap.put("contents", SWUtil.secureCode(request.getParameter("contents")));
		
		paraMap.put("impt",request.getParameter("impt"));
		
		// 개인 메일 여부
		paraMap.put("individualval",request.getParameter("individualval"));
		
		// 카테고리 설정 여부
		if(request.getParameter("categoryno") != null) {
			String categoryno = request.getParameter("categoryno");
			paraMap.put("categoryno",categoryno);
		}
		else {
			paraMap.put("categoryno","");
		}
		
		addStop = service.emailaddstop(paraMap);
			
			
		//System.out.println("addStop=>"+addStop);
		    	
    	jsonObj.put("addStop", addStop);

		return jsonObj.toString(); 

    }
    
    // 임시저장 메일 업데이트
    @ResponseBody
    @PostMapping(value="/addMailupdate.gw", produces="text/plain;charset=UTF-8")
    public String addMailupdate(HttpServletRequest request) {
    	String upsend_emailstop_seq = request.getParameter("upsend_emailstop_seq");
    	//System.out.println("upsend_emailstop_seq=>"+upsend_emailstop_seq);
    	
    	int addupdate = 0;
    	
    	JSONObject jsonObj = new JSONObject();
    	
    	Map<String, Object> paraMap = new HashMap<>();
    	HttpSession session = request.getSession();
    	
    	EmployeesVO loginuser = (EmployeesVO)session.getAttribute("loginuser");
    	String fk_sender_email = loginuser.getEmail();
    	
    	paraMap.put("fk_sender_email",fk_sender_email);
    	paraMap.put("receieve_Email",request.getParameter("receieve_Email"));
    	
    	// 참조메일
    	if(request.getParameter("receieveplus_Email") != null) {
    		String receieveplus_Email = request.getParameter("receieveplus_Email");
    		paraMap.put("receieveplus_Email",receieveplus_Email);
    	}
    	else {
    		paraMap.put("receieveplus_Email","");
    	}
			
    	// 숨김 참조 메일
    	if(request.getParameter("receievehidden_Email") != null) {
    		String receievehidden_Email = request.getParameter("receievehidden_Email");
    		paraMap.put("receievehidden_Email",receievehidden_Email);
    	}
    	else {
    		paraMap.put("receievehidden_Email","");
    	}
			
		paraMap.put("subject",request.getParameter("subject"));
		paraMap.put("contents", SWUtil.secureCode(request.getParameter("contents")));
		
		paraMap.put("impt",request.getParameter("impt"));
		
		// 개인 메일 여부
		paraMap.put("individualval",request.getParameter("individualval"));
		
		// 카테고리 설정 여부
		if(request.getParameter("categoryno") != null) {
			String categoryno = request.getParameter("categoryno");
			paraMap.put("categoryno",categoryno);
		}
		else {
			paraMap.put("categoryno","");
		}
		
		paraMap.put("upsend_emailstop_seq",upsend_emailstop_seq);
		
		//System.out.println("upsend_emailstop_seq=>"+paraMap.get("upsend_emailstop_seq"));
		
		
		addupdate = service.emailaddupdate(paraMap);
		
		//System.out.println("addupdate=>"+addupdate);
		
    	jsonObj.put("addupdate", addupdate);

		return jsonObj.toString(); 

    }
    
    
    
    

		
    // 비밀번호가 있을경우 알아오기
	@ResponseBody
	@PostMapping(value="/getEmailPwd.gw", produces="text/plain;charset=UTF-8")
	public String getEmailPwd(HttpServletRequest request) {
		
		JSONObject jsonObj = new JSONObject();
		String send_email_seq = request.getParameter("send_email_seq");
		// //System.out.println("send_email_seq=>"+send_email_seq);
		String pwd = service.getEmailPwd(send_email_seq);
		System.out.println("pwd=>"+pwd);
		
		jsonObj.put("pwd",pwd);
		
		return jsonObj.toString();
		
	}
    
    // 이메일 한개 보는 페이지
    @GetMapping(value="/digitalmailview.gw", produces="text/plain;charset=UTF-8")
    public ModelAndView requiredLogin_digitalmailview(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
    	
    	String send_email_seq = request.getParameter("send_email_seq");
    	String type = request.getParameter("type");
    	
    	System.out.println("type=>"+type);
    	
    	HttpSession session = request.getSession();
		
    	
    	EmployeesVO loginuser = (EmployeesVO)session.getAttribute("loginuser");
    	// //System.out.println(loginuser.getEmail());
		Map<String, String> paraMap = new HashMap<>();
		
		paraMap.put("send_email_seq", send_email_seq);
		paraMap.put("type", type);
		paraMap.put("MyEmail", loginuser.getEmail());
    			
    	mav = service.digitalmailview(mav,paraMap);
    	
	    return mav;
    
    }// end of public ModelAndView home(ModelAndView mav)
    
    // 파일 다운로드
	@RequestMapping(value="/email_downloadfile.gw")
	public void downloadfile(HttpServletRequest request, HttpServletResponse response) {
		
		String send_email_seq = request.getParameter("send_email_seq");
		//System.out.println(send_email_seq);
		int idx = Integer.parseInt(request.getParameter("index"));
		//System.out.println(send_email_seq+idx);
		// 첨부파일이 있는 글번호 
		/*
		     첨부파일이 있는 글번호를 가지고
		   tbl_board 테이블에서 filename 컬럼의 값과 orgfilename 컬럼의 값을 가져와야 한다.
		   filename 컬럼의 값은 202210281630581204316300601400.jpg 와 같은 것이고
		   orgfilename 컬럼의 값은  berkelekle심플라운드01.jpg 와 같은 것이다.    
		*/
		

		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("send_email_seq", send_email_seq);
		HttpSession session = request.getSession();
		// EmployeesVO loginuser = (EmployeesVO)session.getAttribute("loginuser");
		
		
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = null;
		// out 은 웹브라우저에 기술하는 대상체라고 생각하자.
				
		try {
		     Integer.parseInt(send_email_seq);
		     
		     // 이메일 번호 체번
		     EmailVO emailVO = service.SelectEmail(paraMap);
		
		     if(emailVO == null || (emailVO != null && emailVO.getFilename() == null ) ) {
		    	 out = response.getWriter();
				 // out 은 웹브라우저에 기술하는 대상체라고 생각하자.
					
				 out.println("<script type='text/javascript'>alert('존재하지 않는 글번호 이거나 첨부파일 없으므로 파일다운로드가 불가합니다.'); history.back();</script>"); 
				 
				 return; // 종료
		     }
		     else {
		    	 // 정상적으로 다운로드를 할 경우 
		    	 String orgFilename = emailVO.getFilename_split().get(idx);
		    	 
		    	 //System.out.println("orgFilename+>"+orgFilename);
		    	 
			     String fileName  = emailVO.getOrgfilename_split().get(idx);
			     
			     //System.out.println("fileName+>"+fileName);
			     
				 // String path = "C:\\NCS\\workspace_spring_framework\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\GW\\resources\\emailfiles";
				 String path = "C:\\git\\FinalProject\\FInalProject\\src\\main\\webapp\\resources\\file\\email";
				 
				 //System.out.println("path=>"+path);
				 
				 // **** file 다운로드 하기 **** //
				 boolean flag = false;  // file 다운로드 성공, 실패를 알려주는 용도
				 flag = fileManager.doFileDownload(fileName, orgFilename, path, response);
				 // file 다운로드 성공시 flag 는 true,
				 // file 다운로드 실패시 flag 는 false 를 가진다.
				 
				 if(!flag) {
					 // 다운로드가 실패할 경우 메시지를 띄워준다.
					 out = response.getWriter();
					 // out 은 웹브라우저에 기술하는 대상체라고 생각하자.
						
					 out.println("<script type='text/javascript'>alert('파일다운로드가 실패되었습니다.'); history.back();</script>"); 
				 }
		     }
		     
		} catch(NumberFormatException | IOException e) {
			try {
				out = response.getWriter();
				// out 은 웹브라우저에 기술하는 대상체라고 생각하자.
				
				out.println("<script type='text/javascript'>alert('파일다운로드가 불가합니다.'); history.back();</script>");
			} catch (IOException e1) {
				e1.printStackTrace();
			}
			
		}
		
	}
	
	
    // 임시메일 홈페이지
    @GetMapping(value="/emailaddstoplist.gw", produces="text/plain;charset=UTF-8")
    public ModelAndView requiredLogin_emailaddstoplist(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {

    	// HttpSession session = request.getSession();
    	// session.setAttribute("readCountPermission", "yes"); 조회수라면 해야되지만 나는 메일이기때문에 무조건 로그인 해야 들어올 수 있다.
    	
		String str_currentShowPageNo = request.getParameter("currentShowPageNo");
		
		HttpSession session = request.getSession();
		EmployeesVO loginuser = (EmployeesVO)session.getAttribute("loginuser");
		String email = loginuser.getEmail();
		
		// //System.out.println("email=>"+email);
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("email", email);
	
		int addstopCount = 0;    		// 총 게시물 건수 
		int sizePerPage = 12;  		// 한 페이지당 보여줄 게시물 건수 
		int currentShowPageNo = 0;  // 현재 보여주는 페이지 번호로서, 초기치로는 1페이지로 설정함. 
		int currentShowPageNoplus = 1;  // 현재 보여주는 페이지 번호로서, 초기치로는 1페이지로 설정함. 
		int currentShowPageNodel = 1;  // 현재 보여주는 페이지 번호로서, 초기치로는 1페이지로 설정함. 
		int totalPage = 0;          // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바)
    	
		addstopCount = service.addstopCount(paraMap);
		
		//System.out.println("totalCount=>"+addstopCount);
		
		totalPage = (int) Math.ceil((double)addstopCount/sizePerPage); 
    	
		if(str_currentShowPageNo == null) {
			 // 메일 초기에 보여지는 화면
			 currentShowPageNo = 1;
		 }
		 else {
	         
			 try {
	             currentShowPageNo = Integer.parseInt(str_currentShowPageNo); 
				 if(currentShowPageNo < 1 || currentShowPageNo > totalPage) { // 유효성 검사   
					currentShowPageNo = 1;
				 }
	         } catch(NumberFormatException e) {
				 currentShowPageNo = 1; 
	         }
		 }
		
		 int startRno = ((currentShowPageNo - 1) * sizePerPage) + 1;    // 시작 행번호 
		 int endRno = startRno + sizePerPage - 1; 						// 끝 행번호 	
		 paraMap.put("startRno", String.valueOf(startRno));
		 paraMap.put("endRno", String.valueOf(endRno));
		 
		 //System.out.println("시작=>"+paraMap.get("startRno"));
		 //System.out.println("끝=>"+paraMap.get("endRno"));
		 
		 mav= service.addstopView(mav,paraMap);
		 
		 mav.addObject("paraMap", paraMap);
		 		
		// === 페이지바 만들기 (만들거면 해야되는데 굳이...?)  === //
		int blockSize = 10;
		int loop = 1;
		int pageNo = ((currentShowPageNo - 1)/blockSize) * blockSize + 1;
		// === 페이지바 만들기 (만들거면 해야되는데 굳이...?)  === //
		
		str_currentShowPageNo = request.getParameter("currentShowPageNo");
		
		if(str_currentShowPageNo == null) {
			 // 메일 초기에 보여지는 화면
			 currentShowPageNo = 1;
		}
		else {
			currentShowPageNo = Integer.parseInt(str_currentShowPageNo);
			
			currentShowPageNodel = Integer.parseInt(str_currentShowPageNo);
			currentShowPageNoplus = Integer.parseInt(str_currentShowPageNo);
		}

		
		String url = "/FinalProject/emailaddstoplist.gw";
		
		String pageBar = "<div class='emailList_settingsRight'>";
		
		pageBar +=	"<div class='icon_set'>";
		pageBar += "<a href='"+url+"?currentShowPageNo="+(currentShowPageNodel)+"'>";
		pageBar += "<span class='material-icons-outlined icon_img' style='font-size: 24pt;'>chevron_left</span></a>";
		pageBar += "<span class='icon_text'>이전</span></div>";
		pageBar +=	"<div class='icon_set'>";
		pageBar += "<a href='"+url+"?currentShowPageNo="+(currentShowPageNoplus)+"'>";
		pageBar += "<span class='material-icons-outlined icon_img' style='font-size: 24pt;'>chevron_right</span></a>";
		pageBar += "<span class='icon_text'>다음</span></div>";
		pageBar += "</div>";
		
		mav.addObject("pageBar", pageBar);
		
		String goBackURL = MyUtil.getCurrentURL(request);
		
		mav.addObject("goBackURL", goBackURL); // 검색 결과로 돌아갈 때 사용할것
		
	    return mav;
    
    }
    // 메일 홈페이지 끝
    
    // 이메일  임시메일 쓰기
    @GetMapping(value="/digitalmailstopwrite.gw", produces="text/plain;charset=UTF-8")
    public ModelAndView requiredLogin_digitalmailstopwrite(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
    	
    	String send_emailstop_seq = request.getParameter("send_emailstop_seq");
    	HttpSession session = request.getSession();
		
    	EmployeesVO loginuser = (EmployeesVO)session.getAttribute("loginuser");
    	
    	// //System.out.println(loginuser.getEmail());
		Map<String, String> paraMap = new HashMap<>();
		
		paraMap.put("send_emailstop_seq", send_emailstop_seq);
		paraMap.put("split_Email", loginuser.getEmail());
    			
    	mav = service.digitalmailstopwrite(mav,paraMap);
    	
	    return mav;
    
    }// end of public ModelAndView home(ModelAndView mav)
    
	// receipt_favorites update 하기
	@ResponseBody
	@PostMapping(value="/receipt_favorites_update.gw", produces="text/plain;charset=UTF-8")
	public String receipt_favorites_update(HttpServletRequest request) {
		
		String type = request.getParameter("type");
		System.out.println("type=>"+type);
		
		String receipt_mail_seq = request.getParameter("receipt_mail_seq");
		System.out.println("receipt_mail_seq=>"+receipt_mail_seq);
		
		String receipt_favorites = "";
		int n = 0;
		String receipt_favorites_update = "";
		
		if(type.equals("fk_sender_email")) {
			receipt_favorites = service.select_send_favorites(receipt_mail_seq);
			Map<String, String> paraMap = new HashMap<>();
			paraMap.put("receipt_mail_seq", receipt_mail_seq);
			paraMap.put("receipt_favorites", receipt_favorites);
			////System.out.println(paraMap);
			
			n = service.send_favorites_update(paraMap);
			System.out.println("n=>"+n);
			if(n==1) {
				receipt_favorites_update = service.select_send_favorites(receipt_mail_seq);
			}
		}
		else {
			receipt_favorites = service.select_receipt_favorites(receipt_mail_seq);	
			Map<String, String> paraMap = new HashMap<>();
			
			paraMap.put("receipt_mail_seq", receipt_mail_seq);
			paraMap.put("receipt_favorites", receipt_favorites);
			////System.out.println(paraMap);
			
			n = service.receipt_favorites_update(paraMap);
			
			if(n==1) {
				receipt_favorites_update = service.select_receipt_favorites(receipt_mail_seq);
			}
		}
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("receipt_favorites", receipt_favorites_update);
		
		return jsonObj.toString();
	}
	
	
	// receipt_favorites update 하기
	@ResponseBody
	@PostMapping(value="/email_receipt_read_count_update.gw", produces="text/plain;charset=UTF-8")
	public String email_receipt_read_count_update(HttpServletRequest request) {
		
		String receipt_mail_seq = request.getParameter("receipt_mail_seq");
		
		int n = service.email_receipt_read_count_update(receipt_mail_seq);
		
		String email_receipt_read_count = service.select_email_receipt_read_count(receipt_mail_seq);
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("email_receipt_read_count", email_receipt_read_count);
		
		return jsonObj.toString();
	}
	
	
	// receipt_favorites update 하기
	@ResponseBody
	@PostMapping(value="/receipt_important_update.gw", produces="text/plain;charset=UTF-8")
	public String receipt_important_update(HttpServletRequest request) {
		
		String receipt_mail_seq = request.getParameter("receipt_mail_seq");
		String type = request.getParameter("type");
		System.out.println("type=>"+type);
		System.out.println("receipt_mail_seq=>"+receipt_mail_seq);
		String receipt_important = "";
		int n = 0;
		String receipt_important_update = "";
		
		if(type.equals("fk_sender_email")) {
			receipt_important = service.select_send_important(receipt_mail_seq);
			Map<String, String> paraMap = new HashMap<>();
			
			paraMap.put("receipt_mail_seq", receipt_mail_seq);
			paraMap.put("receipt_important", receipt_important);
			////System.out.println(paraMap);
			
			n = service.send_important_update(paraMap);
			System.out.println("n=>"+n);
			if(n==1) {
				receipt_important_update = service.select_send_important(receipt_mail_seq);
				System.out.println("이거 뜨나?");
				
			}
		}
		else {
			
			receipt_important = service.select_receipt_important(receipt_mail_seq);
			
			Map<String, String> paraMap = new HashMap<>();
			
			paraMap.put("receipt_mail_seq", receipt_mail_seq);
			paraMap.put("receipt_important", receipt_important);
			////System.out.println(paraMap);
			
			n = service.receipt_important_update(paraMap);
			
			receipt_important_update = service.select_receipt_important(receipt_mail_seq);
			
			
		}
		
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("receipt_important", receipt_important_update);
		
		return jsonObj.toString();
	}
    
	@ResponseBody
	@PostMapping(value="/email_del.gw", produces="text/plain;charset=UTF-8")
	public String email_del(HttpServletRequest request) {
		
		String receipt_mail_seq_join = request.getParameter("receipt_mail_seq_join");
    	String deltable = request.getParameter("deltype");
    	//System.out.println("deltable=>"+deltable);
    	String seqtype = "";
    	String delname = "";
    	int cnt = 0;
    	if("fk_sender_email".equals(deltable)) {
    		deltable = "tbl_email";
    		seqtype = "send_email_seq";
    		delname = "sender_delete";
    	}
    	else if("del".equals(deltable)){
    		deltable = "tbl_receipt_email";
    		seqtype = "receipt_mail_seq";
    		delname = "receipt_delete";
    		cnt  = 1;
    	}
    	else if("senddel".equals(deltable)){
    		deltable = "tbl_email";
    		seqtype = "send_email_seq";
    		delname = "sender_delete";
    		cnt  = 1;
    	}
    	else if("plus".equals(deltable)){
    		deltable = "tbl_receipt_email";
    		seqtype = "receipt_mail_seq";
    		delname = "receipt_delete";
    		cnt  = -1;
    	}
    	else if("senddelplus".equals(deltable)){
    		deltable = "tbl_email";
    		seqtype = "send_email_seq";
    		delname = "sender_delete";
    		cnt  = -1;
    	}
    	else {
    		
    		deltable = "tbl_receipt_email";
    		seqtype = "receipt_mail_seq";
    		delname = "receipt_delete";
    	}
		//System.out.println(receipt_mail_seq_join);
		//System.out.println(deltable+seqtype+delname);
		
    	String[] receipt_mail_seq_arr = receipt_mail_seq_join.split("\\,");
    	
    	Map<String, Object> receipt_mailMap = new HashMap<>();
    	
    	receipt_mailMap.put("deltable", deltable);
    	receipt_mailMap.put("seqtype", seqtype);
    	receipt_mailMap.put("receipt_mail_seq_arr",receipt_mail_seq_arr);
    	receipt_mailMap.put("delname",delname);
    	receipt_mailMap.put("cnt",cnt);
    	
    	int del = service.email_del(receipt_mailMap);
		
	    boolean delsuc = false;
	    
	    if(del == receipt_mail_seq_arr.length) {
	    	delsuc = true;
    	}
    	else {
    		delsuc = false;
    	}
    	
	    JSONObject jsonObj = new JSONObject();  // {}
		jsonObj.put("delsuc", delsuc);      
    	String json = jsonObj.toString();       
    	
    	//System.out.println(json);
    	
    	return jsonObj.toString();
		
	}
	
	// receipt_favorites update 하기
	@ResponseBody
	@PostMapping(value="/emailstop_del.gw", produces="text/plain;charset=UTF-8")
	public String emailstop_del(HttpServletRequest request) {
		
		String receipt_mail_seq_join = request.getParameter("send_emailstop_seq");
    	//System.out.println(receipt_mail_seq_join);
		
    	String[] receipt_mail_seq_arr = receipt_mail_seq_join.split("\\,");
    	
    	Map<String, Object> receipt_mailMap = new HashMap<>();
    	receipt_mailMap.put("receipt_mail_seq_arr",receipt_mail_seq_arr);
	    int del = service.emailstop_del(receipt_mailMap);
		
	    boolean delsuc = false;
	    
	    if(del == receipt_mail_seq_arr.length) {
	    	delsuc = true;
    	}
    	else {
    		delsuc = false;
    	}
    	
	    JSONObject jsonObj = new JSONObject();  // {}
		jsonObj.put("delsuc", delsuc);      
    	String json = jsonObj.toString();       
    	
    	//System.out.println(json);
    	
    	return jsonObj.toString();
		
	}
	
	// receipt_favorites update 하기
	@ResponseBody
	@PostMapping(value="/total_email_receipt_read_count_update.gw", produces="text/plain;charset=UTF-8")
	public String total_email_receipt_read_count_update(HttpServletRequest request) {
		
		String receipt_mail_seq_join = request.getParameter("receipt_mail_seq_join");
    	//System.out.println(receipt_mail_seq_join);
    	String readcnt = request.getParameter("readcnt");
    	String[] receipt_mail_seq_arr = receipt_mail_seq_join.split("\\,");
    	
    	Map<String, Object> receipt_mailMap = new HashMap<>();
    	receipt_mailMap.put("receipt_mail_seq_arr",receipt_mail_seq_arr);
    	receipt_mailMap.put("readcnt",readcnt);
	    int readCountcnt = service.total_email_receipt_read_count_update(receipt_mailMap);
		
	    boolean readcntsuc = false;
	    
	    if(readCountcnt == receipt_mail_seq_arr.length) {
	    	readcntsuc = true;
    	}
    	else {
    		readcntsuc = false;
    	}
    	
	    JSONObject jsonObj = new JSONObject();  // {}
		jsonObj.put("readCountcnt", readCountcnt);      
    	String json = jsonObj.toString();       
    	
    	//System.out.println(json);
    	
    	return jsonObj.toString();
		
	}
	
	
	@ResponseBody
	@PostMapping(value="/onedel.gw", produces="text/plain;charset=UTF-8")
	public String onedel(HttpServletRequest request) {
		
		String receipt_mail_seq = request.getParameter("receipt_mail_seq");
		
		String type = request.getParameter("type");
		
		Map<String, String> paraMap = new HashMap<>();
		int n = 0;
		if(type.equals("fk_sender_email")) {
			 n = service.onesenddel(receipt_mail_seq);
		}
		else {
			 n = service.onedel(receipt_mail_seq);
		}
		
		
		//System.out.println("onedel n =>"+n);
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("n", n);
		
		return jsonObj.toString();
	}
	
	@ResponseBody
	@PostMapping(value="/timedel.gw", produces="text/plain;charset=UTF-8")
	public String timedel(HttpServletRequest request) {
		
		String send_email_seq = request.getParameter("send_email_seq");
		String orgfilename = request.getParameter("orgfilename");
		
		Map<String, String> paraMap = new HashMap<>();
		
		int n = service.timedel(send_email_seq);
		int timedel = 0;
		
		if(orgfilename == "") {
			// System.out.println("널입니다.");
			orgfilename = "";
			timedel = service.timedelete(send_email_seq);
		}
		else {
			String root = "C:\\git\\FinalProject\\FInalProject\\src\\main\\webapp";
			String path = root+"\\resources\\file\\email"+File.separator;
			paraMap.put("path", path); // 삭제해야할 파일이 저장된 경로
			paraMap.put("fileName", orgfilename); // 삭제해야할 파일명
			timedel = service.HaveFiletimedelete(send_email_seq,paraMap);
		}
		
		System.out.println("orgfilename"+orgfilename);
		
		//System.out.println("onedel n =>"+n);
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("n", timedel);
		
		return jsonObj.toString();
	}
	
	// ==== #184. Spring scheduler (스프링스케줄러02)를 사용하여 어노테이션을 특정 URL 사이트로 연결하기 ==== -->
	@GetMapping(value="/Alarmdel.gw")
	public ModelAndView Alarmdel(ModelAndView mav, HttpServletRequest request) {

		String message = "알람뜨나?";
		String loc = request.getContextPath() + "/index.gw";

		mav.addObject("message", message);
		mav.addObject("loc", loc);

		mav.setViewName("msg");

		return mav;
	}
	

	
	

	
	
 	
}

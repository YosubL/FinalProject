package com.spring.app.saehan.controller;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.spring.app.domain.CommentVO;
import com.spring.app.common.FileManager;
import com.spring.app.common.MyUtil;
import com.spring.app.domain.BoardFileVO;
import com.spring.app.domain.BoardVO;
import com.spring.app.saehan.service.SaehanService;
import com.spring.app.domain.EmployeesVO;
import com.spring.app.domain.FreeBoard_likesVO;
import com.spring.app.domain.NoticeboardFileVO;
import com.spring.app.domain.NoticeboardVO;

@Controller
public class FreeBoardController {

	@Autowired
	private SaehanService service;

	@Autowired
	private FileManager fileManager;

	// ========== 글 리스트 페이지 만들기 시작 =============
	@GetMapping("/freeboard.gw")
	public ModelAndView mainboard(ModelAndView mav, HttpServletRequest request) {
		
		List<BoardVO> boardList = null;

		HttpSession session = request.getSession();
		session.setAttribute("readCountPermission", "yes");
		String searchType = request.getParameter("searchType");
		String searchWord = request.getParameter("searchWord");
		String str_currentShowPageNo = request.getParameter("currentShowPageNo");

		if (searchType == null) {
			searchType = "";
		}

		if (searchWord == null) {
			searchWord = "";
		}

		if (searchWord != null) {
			searchWord = searchWord.trim();
		}

		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("searchType", searchType);
		paraMap.put("searchWord", searchWord);
		
		int totalCount = 0; // 총 게시물 건수
		int sizePerPage = 10; // 한 페이지당 보여줄 게시물 건수
		int currentShowPageNo = 0; // 현재 보여주는 페이지 번호로서, 초기치로는 1페이지로 설정함.
		int totalPage = 0; // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바)

		// 총 게시물 건수(totalCount) 가져오기
		totalCount = service.getTotalCount(paraMap);

		totalPage = (int) Math.ceil((double) totalCount / sizePerPage);

		if (str_currentShowPageNo == null) {
			currentShowPageNo = 1;
		}

		else {
			try {
				currentShowPageNo = Integer.parseInt(str_currentShowPageNo);
				if (currentShowPageNo < 1 || currentShowPageNo > totalPage) {
					currentShowPageNo = 1;
				}
			}catch (NumberFormatException e) {
				currentShowPageNo = 1;
			}
		} // end of else{------------------------

		int startRno = ((currentShowPageNo - 1) * sizePerPage) + 1; // 시작 행번호
		int endRno = startRno + sizePerPage - 1; // 끝 행번호

		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));

		boardList = service.boardListSearch_withPaging(paraMap);
		// 페이징 처리한 글목록 가져오기(검색이 있든지, 검색이 없든지 모두 다 포함 한 것)

		mav.addObject("boardList", boardList);
		
		if ("subject".equals(searchType) || "content".equals(searchType) || "subject_content".equals(searchType)
			|| "name".equals(searchType)) {
		
			mav.addObject("paraMap", paraMap);
		}

		// ===== 페이지바 만들기 ===== //
		int blockSize = 10;
		int loop = 1;
		int pageNo = ((currentShowPageNo - 1) / blockSize) * blockSize + 1;

		String pageBar = "<ul style='list-style:none;'>";
		String url = "freeboard.gw";

		// === [맨처음][이전] 만들기 === //
		if (pageNo != 1) {
			pageBar += "<li style='display:inline-block; width:70px; font-size:12pt; color:black;'><a href='" + url + "?searchType="
					+ searchType + "&searchWord=" + searchWord + "&currentShowPageNo=1'>[맨처음]</a></li>";
			pageBar += "<li style='display:inline-block; width:50px; font-size:12pt; color:black;'><a href='" + url + "?searchType="
					+ searchType + "&searchWord=" + searchWord + "&currentShowPageNo=" + (pageNo - 1)
					+ "'>[이전]</a></li>";
		}

		while (!(loop > blockSize || pageNo > totalPage)) {

			if (pageNo == currentShowPageNo) {
				pageBar += "<li style='display:inline-block; width:30px; font-size:12pt; border:solid 1px gray; color:black; padding:2px 4px;'>"
						+ pageNo + "</li>";
			}

			else {
				pageBar += "<li style='display:inline-block; width:30px; font-size:12pt; color:black;'><a href='" + url
						+ "?searchType=" + searchType + "&searchWord=" + searchWord + "&currentShowPageNo=" + pageNo
						+ "'>" + pageNo + "</a></li>";
			}

			loop++;
			pageNo++;

		} // end of while-------------------------

		// ===== [다음][마지막] 만들기 ===== //
		if (pageNo <= totalPage) {
			pageBar += "<li style='display:inline-block; width:50px; font-size:12pt; color:black;'><a href='" + url + "?searchType="
					+ searchType + "&searchWord=" + searchWord + "&currentShowPageNo=" + pageNo + "'>[다음]</a></li>";
			pageBar += "<li style='display:inline-block; width:70px; font-size:12pt; color:black;'><a href='" + url + "?searchType="
					+ searchType + "&searchWord=" + searchWord + "&currentShowPageNo=" + totalPage + "'>[마지막]</a></li>";
		}

		pageBar += "</ul>";

		mav.addObject("pageBar", pageBar);

		// === 특정 글제목을 클릭한 뒤 상세내용을 본 이후 사용자가 "검색된결과목록보기" 버튼을 클릭했을때 현재 페이지 주소를 뷰단으로 넘겨준다.
		String goBackURL = MyUtil.getCurrentURL(request);

		mav.addObject("goBackURL", goBackURL);
		mav.setViewName("mshboard/freeboard.tiles_MTS");

		return mav;

	} // end of public ModelAndView mainboard(ModelAndView mav,HttpServletRequest request) {-----------

	// ========== 글 리스트 페이지 만들기 끝 =============

	// ===== 검색어 입력시 자동글 완성하기 시작 ===== //
	@ResponseBody
	@GetMapping(value = "/wordSearchShow.gw", produces = "text/plain;charset=UTF-8")
	public String wordSearchShow(HttpServletRequest request) {

		String searchType = request.getParameter("searchType");
		String searchWord = request.getParameter("searchWord");

		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("searchType", searchType);
		paraMap.put("searchWord", searchWord);

		List<String> wordList = service.wordSearchShow(paraMap);

		JSONArray jsonArr = new JSONArray(); // []

		if (wordList != null) {
			for (String word : wordList) {
				JSONObject jsonObj = new JSONObject(); // {}
				jsonObj.put("word", word);
				jsonArr.put(jsonObj); // [{},{},{}]
			} // end of for------------
		}

		return jsonArr.toString();
	}//end of public String wordSearchShow(HttpServletRequest request) {-------------------------
	// ===== 검색어 입력시 자동글 완성하기 끝 ===== //

	// ===== 글쓰기 페이지 요청 시작 ===== ///
	@GetMapping("/add.gw")
	public ModelAndView requiredLogin_add(HttpServletRequest request, HttpServletResponse response, ModelAndView mav,BoardVO boardvo) {

		// === 답변글쓰기가 추가된 경우 시작 === //
		String subject = "[답변] " + request.getParameter("subject");
		String groupno = request.getParameter("groupno");
		String fk_seq = request.getParameter("fk_seq");
		String depthno = request.getParameter("depthno");
		
		if (fk_seq == null) {
			fk_seq = "";
		}

		mav.addObject("subject", subject);
		mav.addObject("groupno", groupno);
		mav.addObject("fk_seq", fk_seq);
		mav.addObject("depthno", depthno);
		// === 답변글쓰기가 추가된 경우 끝 === //

		mav.setViewName("mshboard/add.tiles_MTS");

		return mav;
	}// end of public ModelAndView requiredLogin_add(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) { ------------
	// ===== 글쓰기 페이지 요청 끝 ===== //

	// ====== 게시판 글쓰기 완료 요청 ======= //
	
	
	//파일 없는 자유게시판 글쓰기
	@ResponseBody
	@PostMapping(value = "/nofile_add.gw" , produces = "text/plain;charset=UTF-8")
	public String nofile_addEnd(Map<String, String> paraMap, BoardVO boardvo) {
		int n = 0;

		try {
			n = service.add_nofile(boardvo);
		} catch (Throwable e) {
			e.printStackTrace();
		}
		
		JSONObject jsonObj = new JSONObject(); // {}
		jsonObj.put("n", n);

		return jsonObj.toString();

	}//end of public String nofile_addEnd(Map<String, String> paraMap, BoardVO boardvo) {----------

	//파일 있는 자유게시판 글쓰기
	@ResponseBody
	@PostMapping("/addEnd.gw")
	public String addEnd(Map<String, Object> paraMap, BoardVO boardvo, MultipartHttpServletRequest mrequest, HttpServletRequest request) throws Exception {
	    String recipient = mrequest.getParameter("fk_email");
	    String subject = mrequest.getParameter("subject");
	    String content = mrequest.getParameter("content");
	    String seq = request.getParameter("seq");

	    HttpSession session = mrequest.getSession();
	    EmployeesVO loginuser = (EmployeesVO) session.getAttribute("loginuser");
	    
	    boardvo.setFk_email(loginuser.getEmail());        
	    boardvo.setName(loginuser.getName());

	    paraMap.put("boardvo", boardvo);
	    
	    List<BoardFileVO> fileList = new ArrayList<>();

	    if (mrequest.getFiles("file_arr") != null) {
	        String root = session.getServletContext().getRealPath("/");
	        String path = root + "resources" + File.separator + "Filename";
	        
	        if (!new File(path).exists()) {
	            new File(path).mkdirs();
	        }

	        for (MultipartFile mtfile : mrequest.getFiles("file_arr")) {
	            String filename = "";
	            String originalFilename = "";
	            byte[] bytes = null;
	            long filesize = 0;

	            try {
	                bytes = mtfile.getBytes();
	                originalFilename = mtfile.getOriginalFilename();
	                String fileExtension = originalFilename.substring(originalFilename.lastIndexOf("."));

	                // UUID를 사용하여 유니크한 파일 이름 생성
	                String newFileName = UUID.randomUUID().toString() + fileExtension;

	                // 파일 업로드
	                File attachFile = new File(path + File.separator + newFileName);
	                mtfile.transferTo(attachFile);

	                // 첨부파일 객체 생성
	                BoardFileVO nvo = new BoardFileVO();
	                nvo.setFileName(newFileName);
	                nvo.setOrgFilename(originalFilename);
	                filesize = mtfile.getSize();
	                nvo.setFileSize(String.valueOf(mtfile.getSize()));
	                
	                // 첨부파일 리스트에 추가
	                fileList.add(nvo);
 
	            } catch (Exception e) {
	                e.printStackTrace();
	            }
	        }//end of for (MultipartFile mtfile : mrequest.getFiles("file_arr")) {------------
	   
	    }//end of if (mrequest.getFiles("file_arr") != null) {------------------

	    paraMap.put("fileList", fileList);

	    boolean result = service.addEnd(paraMap);

	    JSONObject jsonObj = new JSONObject();
	    jsonObj.put("result", result);
	    return jsonObj.toString();
	}// end of public ModelAndView addEnd(Map<String, String> paraMap, ModelAndView mav, BoardVO boardvo, MultipartHttpServletRequest mrequest) { ----------

	
	// ====== 게시판 글쓰기 완료 요청 끝======= //

	// ====== 스마트에디터. 드래그앤드롭을 사용한 다중사진 파일 업로드 시작 ====== //
	// 스마트에디터, 드래그앤드롭을 사용한 다중사진 파일 업로드
	@RequestMapping(value="/image/multiplePhotoUpload.gw")
    public void multiplePhotoUpload(HttpServletRequest request, HttpServletResponse response) {    
	      // WAS의 webapp의 절대경로
	      HttpSession session = request.getSession();
	      String root = session.getServletContext().getRealPath("/");
	      String path = root + "resources"+File.separator+"board_photo_upload";
	      
	      File dir = new File(path);
	      
	      if(!dir.exists()) {
	         dir.mkdirs();
	      }
	      
	      try {
	         String filename = request.getHeader("file-name"); // 파일명(문자열) - 일반 원본파일명
	            
	         InputStream is = request.getInputStream(); // is는 네이버 스마트 에디터를 사용하여 사진첨부하기 된 이미지 파일임.
	            
	         String newFilename = fileManager.doFileUpload(is, filename, path);
	            
	         int width = fileManager.getImageWidth(path+File.separator+newFilename);
	            
	         if(width > 600) {
	            width = 600;
	         }
	             
	         String ctxPath = request.getContextPath(); //  /board
	         
	         String strURL = "";
	         strURL += "&bNewLine=true&sFileName="+newFilename; 
	         strURL += "&sWidth="+width;
	         strURL += "&sFileURL="+ctxPath+"/resources/board_photo_upload/"+newFilename;
	         
	         // === 웹브라우저 상에 사진 이미지를 쓰기 === //
	         PrintWriter out = response.getWriter();
	         out.print(strURL);
	            
	      } catch(Exception e) {
	         e.printStackTrace();
	      }
	      
	   }//end of public void multiplePhotoUpload(HttpServletRequest request, HttpServletResponse response) { -------
	// ====== 스마트에디터. 드래그앤드롭을 사용한 다중사진 파일 업로드 끝====== //

	// ===== 글을 수정하는 페이지 요청 시작 ===== //
	@GetMapping("/edit.gw")
	public ModelAndView requiredLogin_edit(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		// 글 수정해야 할 글번호 가져오기
		String seq = request.getParameter("seq");
		String message = "";
		try {
			Integer.parseInt(seq);
			// 글 수정해야할 글1개 내용가져오기
			Map<String, String> paraMap = new HashMap<>();
			paraMap.put("seq", seq);
			BoardVO boardvo = service.getView_no_increase_readCount(paraMap);
			// 글조회수(readCount) 증가 없이 단순히 글 1개만 조회해주는 것이다.

			if (boardvo == null) {
				message = "글 수정이 불가합니다";
			}

			else {
				HttpSession session = request.getSession();
				EmployeesVO loginuser = (EmployeesVO) session.getAttribute("loginuser");

				if (!loginuser.getEmail().equals(boardvo.getFk_email())) {
					message = "다른 사용자의 글은 수정이 불가합니다";
				}

				else {
					// 자신의 글을 수정할 경우
					mav.addObject("boardvo", boardvo);
					mav.setViewName("mshboard/edit.tiles_MTS");

					return mav;
				}
			}
		} catch (NumberFormatException e) {
			message = "글 수정이 불가합니다";
		}
		String loc = "javascript:history.back()";

		mav.addObject("message", message);
		mav.addObject("loc", loc);
		mav.setViewName("msg");

		return mav;
	}// end of public ModelAndView requiredLogin_edit(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {------
		//// ===== 글을 수정하는 페이지 요청 끝 ===== //
	
	
	// ajax로 첨부파일 가져오기
	@ResponseBody
	@RequestMapping(value = "/getBoardFiles.gw", produces = "text/plain;charset=UTF-8")
	public String getFiles(HttpServletRequest request, @RequestParam("seq") String seq) {

		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("seq", seq); // 글번호
			
		// 첨부파일 조회
		List<BoardFileVO> fileList = service.getView_files(seq);
			
		JSONArray jsonArr = new JSONArray(fileList);
			
		return String.valueOf(jsonArr);
	}
	
	
	// 자유게사판 글 수정하기 요청
	@ResponseBody
	@PostMapping(value ="editEnd.gw", produces = "text/plain;charset=UTF-8")
	public String editPost(MultipartHttpServletRequest mrequest, BoardVO boardvo) {
		
		Map<String, Object> paraMap = new HashMap<>();
		Map<String, String> paraMap2 = new HashMap<>();
		
		paraMap.put("boardvo", boardvo);
		paraMap2.put("fk_seq", boardvo.getSeq());

		HttpSession session = mrequest.getSession();
		
		// service로 넘길 파일정보가 담긴 리스트
		List<BoardFileVO> fileList = new ArrayList<>();

	    if (mrequest.getFiles("file_arr") != null) {
	        String root = session.getServletContext().getRealPath("/");
	        String path = root + "resources" + File.separator + "Filename";
	        
	        if (!new File(path).exists()) {
	            new File(path).mkdirs();
	        }

	        for (MultipartFile mtfile : mrequest.getFiles("file_arr")) {
	            String filename = "";
	            String originalFilename = "";
	            byte[] bytes = null;
	            long filesize = 0;

	            try {
	                bytes = mtfile.getBytes();
	                originalFilename = mtfile.getOriginalFilename();
	                String fileExtension = originalFilename.substring(originalFilename.lastIndexOf("."));

	                // UUID를 사용하여 유니크한 파일 이름 생성
	                String newFileName = UUID.randomUUID().toString() + fileExtension;

	                // 파일 업로드
	                File attachFile = new File(path + File.separator + newFileName);
	                mtfile.transferTo(attachFile);

	                // 첨부파일 객체 생성
	                BoardFileVO nvo = new BoardFileVO();
	                nvo.setFileName(newFileName);
	                nvo.setOrgFilename(originalFilename);
	                filesize = mtfile.getSize();
	                nvo.setFileSize(String.valueOf(mtfile.getSize()));
	                
	                // 첨부파일 리스트에 추가
	                fileList.add(nvo);

	            } catch (Exception e) {
	                e.printStackTrace();
	            }
	        }//end of for (MultipartFile mtfile : mrequest.getFiles("file_arr")) {---------------
	    }//end of if (mrequest.getFiles("file_arr") != null) {----------------

	    paraMap.put("fileList", fileList);

	    boolean result = service.freeboard_edit(paraMap);

	    String attachfile = service.freeboard_update_attachfile(boardvo.getSeq()); 	
		  
	    int a = 0;
		int b = 0;
	    
		if (attachfile.equals("0")) {
			 a = service.getfreeboard_filename_clear(paraMap2);
		}
		else {
			 b = service.getfreeboard_filename_add(paraMap2);
		}
	    
	    JSONObject jsonObj = new JSONObject();
	    jsonObj.put("result", result);
	    return jsonObj.toString();
			
	}
	

	//글 수정다음에 띄어줘야할 페이지
	@GetMapping("/editAfter_view.gw")
	public ModelAndView editAfter_view(ModelAndView mav, BoardVO boardvo, HttpServletRequest request) {
		
		String seq = "";
		String goBackURL = "";
		String searchType = "";
		String searchWord = "";

		Map<String, ?> inputFlashMap = RequestContextUtils.getInputFlashMap(request);
		// redirect 되어서 넘어온 데이터가 있는지 꺼내어 와본다.

		if (inputFlashMap != null) {

			@SuppressWarnings("unchecked") // 경고 표시를 하지 말라는 뜻이다.
			Map<String, String> redirect_map = (Map<String, String>) inputFlashMap.get("redirect_map");
			seq = redirect_map.get("seq");
			searchType = redirect_map.get("searchType");

			try {
				searchWord = URLDecoder.decode(redirect_map.get("searchWord"), "UTF-8"); // 한글데이터가 포함되어 있으면 반드시 한글로
																							// 복구주어야 한다.
				goBackURL = URLDecoder.decode(redirect_map.get("goBackURL"), "UTF-8"); // 한글데이터가 포함되어 있으면 반드시 한글로 복구주어야
																						// 한다.
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}

			if (goBackURL != null && goBackURL.contains(" ")) {
				goBackURL = goBackURL.replaceAll(" ", "&");
			}
		}

		else {
			seq = request.getParameter("seq");
			goBackURL = request.getParameter("goBackURL");

			if (goBackURL != null && goBackURL.contains(" ")) {
				goBackURL = goBackURL.replaceAll(" ", "&");
			}

			// === 검색으로 조회된 글을 볼 때 view.jsp 에서 이전글제목 및 다음글제목 클릭시 사용하기 위한 것임. 시작 ===
			searchType = request.getParameter("searchType");
			
			searchWord = request.getParameter("searchWord");

			if (searchType == null) {
				searchType = "";
			}

			if (searchWord == null) {
				searchWord = "";
			}
			// === 검색으로 조회된 글을 볼 때 view.jsp 에서 이전글제목 및 다음글제목 클릭시 사용하기 위한 것임. 끝 ===
		}

		mav.addObject("goBackURL", goBackURL);

		try {
			Integer.parseInt(seq);
			HttpSession session = request.getSession();
			EmployeesVO loginuser = (EmployeesVO) session.getAttribute("loginuser");
			String login_Employee_id = null;

			if (loginuser != null) {
				login_Employee_id = loginuser.getEmployee_id();
			}

			Map<String, String> paraMap = new HashMap<>();

			paraMap.put("seq", seq);
			paraMap.put("login_Employee_id", login_Employee_id);

			paraMap.put("searchType", searchType);
			paraMap.put("searchWord", searchWord);

			// 글목록에서 특정 글제목을 클릭하여 본 상태에서 웹브라우저에서 새로고침(F5)을 클릭한 경우이다.
			boardvo = service.getView_no_increase_readCount(paraMap);
			List<BoardFileVO> fileList = service.getView_files(seq);
			
			mav.addObject("fileList", fileList);
			mav.addObject("boardvo", boardvo);
			mav.addObject("paraMap", paraMap);

		} catch (NumberFormatException e) {
			// 이전글제목 또는 다음글제목을 클릭하여 본 상태에서
			// 웹브라우저에서 새로고침(F5)을 클릭한 경우이다.
			mav.setViewName("redirect:/freeboard.gw");
			return mav;
		}

		mav.setViewName("mshboard/view.tiles_MTS");
		return mav;
	}//end of public ModelAndView editAfter_notice_view(ModelAndView mav, NoticeboardVO boardvo, HttpServletRequest request) {
	
	
	// 자유게시판 (글 수정) 기존에 첨부된 파일 삭제
	@ResponseBody
	@PostMapping(value = "/deleteFile.gw", produces = "text/plain;charset=UTF-8")
	public String deleteFile(HttpServletRequest request, @RequestParam("fileno") String fileno) {
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("fileno", fileno); // 삭제하려는 파일번호
		
		HttpSession session = request.getSession();
		
		String root = session.getServletContext().getRealPath("/");				
		String path = root + "resources" + File.separator + "filename";
		
		// 파일 테이블에서 파일삭제
		boolean result = service.deleteFile(fileno, path);
		
		JSONObject json = new JSONObject();
		json.put("result", result);
		return String.valueOf(json);
	}	
	// ========== 글을 수정하는 페이지에서 첨부파일 삭제 끝 =============//
	
	
	// ===== 글을 삭제하는 페이지 시작===== //
	@GetMapping("/del.gw")
	public ModelAndView requiredLogin_del(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {

		// 삭제해야 할 글번호 가져오기
		String seq = request.getParameter("seq");
		String fileno = request.getParameter("fileno");
		String message = "";
		List<BoardFileVO> fileList = null;
		try {
			Integer.parseInt(seq);
			
			Map<String, String> paraMap = new HashMap<>();
			paraMap.put("seq", seq);

			BoardVO boardvo = service.getView_no_increase_readCount(paraMap);
			fileList= service.getView_files(seq);
			// 글조회수(readCount) 증가 없이 단순히 글 1개만 조회해주는 것이다.
			
			if (boardvo == null) {
				message = "글 삭제가 불가합니다";
			} 
			else {
				HttpSession session = request.getSession();
				EmployeesVO loginuser = (EmployeesVO) session.getAttribute("loginuser");

				mav.addObject("fileList", fileList);
				mav.addObject("boardvo", boardvo);
				mav.setViewName("mshboard/del.tiles_MTS");

				return mav;
			}
		} catch (NumberFormatException e) {
			message = "글 삭제가 불가합니다!!!";
		} 

		String loc = "javascript:history.back()";
		mav.addObject("message", message);
		mav.addObject("loc", loc);

		mav.setViewName("msg");

		return mav;
	}// end of public ModelAndView requiredLogin_del(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {---
	// ===== 글을 삭제하는 페이지 요청하기 끝 ===== //

	// ====== 글을 삭제하는 페이지 완료하기 시작====== //
	@PostMapping("/delEnd.gw")
	public ModelAndView delEnd(ModelAndView mav, HttpServletRequest request) {

		String seq = request.getParameter("seq");
		String fileno = request.getParameter("fileno");
		
		Integer.parseInt(seq);
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("seq", seq);
		
		// === 파일첨부가 된 글이라면 글 삭제시 먼저 첨부파일을 삭제해주어야 한다. 시작 === //
		paraMap.put("searchType", "");
		paraMap.put("searchWord", "");

		BoardVO boardvo = service.getView(paraMap);
		List<BoardFileVO> fileList = service.getView_files(seq);
		List<FreeBoard_likesVO> freeboard_likesvo = service.getView_likes(seq);
		
		int n = 0;
		int n2 = 0;
		int n3 = 0;
		int n4 = 0;

		HttpSession session = request.getSession();
		String root = session.getServletContext().getRealPath("/");
		String path = root + "resources" + File.separator + "filename";

	    for (BoardFileVO fileVO : fileList) {
	        String fileName1 = fileVO.getFileName();
	        String fileno1 = fileVO.getFileno();
	        paraMap.put("path", path); // 삭제해야할 파일이 저장된 경로
	        paraMap.put("fileName", fileName1); // 삭제해야할 파일명
	        paraMap.put("fileno", fileno1);
	        n = service.del_attach(paraMap);
	    }
	    
	    for (FreeBoard_likesVO likeVO : freeboard_likesvo) {
	        String like_no = likeVO.getLike_no(); 
	        paraMap.put("like_no", like_no);
	        n2 = service.del_likes(paraMap);
	    }

	    if (n == 1 || n2 == 1) {
	        n4 = service.del(paraMap);
	    }
	
	    // 파일이 첨부되지 않은 경우에도 n3에 값을 대입한다.
	    n3 = service.del(paraMap);
	    // === 파일첨부가 된 글이라면 글 삭제시 먼저 첨부파일을 삭제해주어야 한다. 끝 === //

		if (n3 == 1 || n4 == 1) {
		    mav.addObject("message", "글 삭제 성공!!");
		    mav.addObject("loc", request.getContextPath() + "/freeboard.gw");
		    mav.setViewName("msg");
		}

		return mav;
	}// end of public ModelAndView delEnd(ModelAndView mav, HttpServletRequest request) {------
	// ====== 글을 삭제하는 페이지 완료하기 끝===== //

	// ====== 글1개를 보여주는 페이지 요청하기 시작 ====== //
	@RequestMapping("/view.gw") 
	public @ResponseBody ModelAndView view(ModelAndView mav, HttpServletRequest request) {
		String seq = "";
		String goBackURL = "";
		String searchType = "";
		String searchWord = "";

		Map<String, ?> inputFlashMap = RequestContextUtils.getInputFlashMap(request);

		if (inputFlashMap != null) {

			@SuppressWarnings("unchecked") // 경고 표시를 하지 말라는 뜻이다.
			Map<String, String> redirect_map = (Map<String, String>) inputFlashMap.get("redirect_map");
			seq = redirect_map.get("seq");
			searchType = redirect_map.get("searchType");

			try {
				searchWord = URLDecoder.decode(redirect_map.get("searchWord"), "UTF-8"); 
				goBackURL = URLDecoder.decode(redirect_map.get("goBackURL"), "UTF-8"); 
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}

			if (goBackURL != null && goBackURL.contains(" ")) {
				goBackURL = goBackURL.replaceAll(" ", "&");
			}
		}

		else {
			seq = request.getParameter("seq");
			goBackURL = request.getParameter("goBackURL");

			if (goBackURL != null && goBackURL.contains(" ")) {
				goBackURL = goBackURL.replaceAll(" ", "&");
			}

			// === 검색으로 조회된 글을 볼 때 view.jsp 에서 이전글제목 및 다음글제목 클릭시 사용하기 위한 것임. 시작 ===
			searchType = request.getParameter("searchType");
			searchWord = request.getParameter("searchWord");

			if (searchType == null) {
				searchType = "";
			}

			if (searchWord == null) {
				searchWord = "";
			}
			// === 검색으로 조회된 글을 볼 때 view.jsp 에서 이전글제목 및 다음글제목 클릭시 사용하기 위한 것임. 끝 ===
		}

		mav.addObject("goBackURL", goBackURL);

		try {
			Integer.parseInt(seq);
			HttpSession session = request.getSession();
			EmployeesVO loginuser = (EmployeesVO) session.getAttribute("loginuser");
			String login_email = null;

			if (loginuser != null) {
				login_email = loginuser.getEmail();
			}

			Map<String, String> paraMap = new HashMap<>();	
			paraMap.put("seq", seq);
			paraMap.put("login_email", login_email);
			
			paraMap.put("searchType", searchType);
			paraMap.put("searchWord", searchWord);

			BoardVO boardvo = null;
			List<BoardFileVO> fileList = null;
			List<FreeBoard_likesVO> likesvo = null;
			int liketotalCount = 0;
			
			if ("yes".equals((String) session.getAttribute("readCountPermission"))) {
				// 글목록보기인 /freeboard.gw 페이지를 클릭한 다음에 특정글을 조회해온 경우이다.
				
				boardvo = service.getView(paraMap);
				fileList = service.getView_files(seq);
				likesvo = service.getView_likes(seq);
				liketotalCount = service.getliketotalCount(seq);
				session.removeAttribute("readCountPermission");
			}

			else {
				boardvo = service.getView_no_increase_readCount(paraMap);
				fileList = service.getView_files(seq);
				likesvo = service.getView_likes(seq);
				liketotalCount = service.getliketotalCount(seq);
			}
			mav.addObject("liketotalCount",liketotalCount);
			mav.addObject("likesvo",likesvo);
			mav.addObject("boardvo", boardvo);
			mav.addObject("paraMap", paraMap);
			mav.addObject("fileList", fileList);
			
		} catch (NumberFormatException e) {

			mav.setViewName("redirect:/freeboard.gw");
			return mav;
		}

		mav.setViewName("mshboard/view.tiles_MTS");
		return mav;
	}// end of public ModelAndView view(ModelAndView mav, HttpServletRequest request) {-------------

	// ====== 글1개를 보여주는 페이지 요청하기 끝 ====== //

	// ====== 글1개를 보여주는 페이지 요청하기 시작 ====== //
	@PostMapping("/view_2.gw")
	public ModelAndView view_2(ModelAndView mav, HttpServletRequest request, RedirectAttributes redirectAttr) {

		String seq = request.getParameter("seq");
		String goBackURL = request.getParameter("goBackURL");
		goBackURL = goBackURL.replaceAll("&", " ");

		String searchType = request.getParameter("searchType");
		String searchWord = request.getParameter("searchWord");

		HttpSession session = request.getSession();
		session.setAttribute("readCountPermission", "yes");

		try {
			searchWord = URLEncoder.encode(searchWord, "UTF-8");
			goBackURL = URLEncoder.encode(goBackURL, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}

		// ==== GET 방식이 아닌 POST 방식처럼 데이터를 넘기려면 RedirectAttributes 를 사용하면 된다. 시작 ==== //
		Map<String, String> redirect_map = new HashMap<>();
		redirect_map.put("seq", seq);
		redirect_map.put("goBackURL", goBackURL);
		redirect_map.put("searchType", searchType);
		redirect_map.put("searchWord", searchWord);

		redirectAttr.addFlashAttribute("redirect_map", redirect_map);

		mav.setViewName("redirect:/view.gw");
		// ==== GET 방식이 아닌 POST 방식처럼 데이터를 넘기려면 RedirectAttributes 를 사용하면 된다. 끝 ==== //

		return mav;

	}// end of public ModelAndView view_2(ModelAndView mav, HttpServletRequest request, RedirectAttributes redirectAttr) {-----
		// ====== 글1개를 보여주는 페이지 요청하기 끝 ====== //
	
	// ====== 첨부파일 다운로드 받기 시작 ======= //
	@GetMapping(value = "/download.gw")
	public void requiredLogin_download(HttpServletRequest request, HttpServletResponse response) {

		String fileno = request.getParameter("fileno");
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("fileno", fileno);
		paraMap.put("searchType", "");
		paraMap.put("searchWord", "");

		response.setContentType("text/html; charset=UTF-8");
		
		PrintWriter out = null;
		BoardFileVO filevo = null;
		try {
			Integer.parseInt(fileno);
			filevo = service.getEach_view_files(fileno);
		
			if (filevo == null || (filevo != null &&  filevo.getFileName() == null)) {
				out = response.getWriter();
				out.println("<script type='text/javascript'>alert('존재하지 않는 글번호 이거나 첨부파일이 없으므로 파일다운로드가 불가합니다.'); history.back();</script>");
				return;
			} 
			else { // 정상적으로 다운로드를 할 경우
				String fileName = filevo.getFileName();
				String orgFilename = filevo.getOrgFilename();
				HttpSession session = request.getSession();
				String root = session.getServletContext().getRealPath("/");
				String path = root + "resources" + File.separator + "Filename";

				// ***** file 다운로드 하기 ***** //
				boolean flag = false; 
				flag = fileManager.doFileDownload(fileName, orgFilename, path, response);
				// file 다운로드 성공시 flag 는 true, 실패시 flag 는 false 를 가진다.
				if (!flag) {
					out = response.getWriter();
					out.println("<script type='text/javascript'>alert('파일다운로드가 실패되었습니다.'); history.back();</script>");
				}
			}

		}catch (NumberFormatException | IOException e) {
			e.printStackTrace();
			try {
				out = response.getWriter();
				out.println("<script type='text/javascript'>alert('파일다운로드가 불가합니다.'); history.back();</script>");
			}catch (IOException e2) {
				e2.printStackTrace();
			}
		}

	}// end of public void requiredLogin_download(HttpServletRequest request, HttpServletResponse response) {--------------
		// ====== 첨부파일 다운로드 받기 끝 ======= //

	// ====== 원게시물에 딸린 댓글들을 조회해오기(Ajax 로 처리) 시작 ====== //
	@ResponseBody
	@GetMapping(value = "/readComment.gw", produces = "text/plain;charset=UTF-8")
	public String readComment(HttpServletRequest request) {

		String parentSeq = request.getParameter("parentSeq");
		List<CommentVO> commentList = service.getCommentList(parentSeq);

		JSONArray jsonArr = new JSONArray();

		if (commentList != null) {
			for (CommentVO cmtvo : commentList) {
				JSONObject jsonObj = new JSONObject();
				jsonObj.put("name", cmtvo.getName());
				jsonObj.put("content", cmtvo.getContent());
				jsonObj.put("regdate", cmtvo.getRegDate());

				jsonArr.put(jsonObj);
			} // end of for------------
		} // end of if-------------

		return jsonArr.toString();
	}// public String readComment(HttpServletRequest request) {-------------------
	// ====== 원게시물에 딸린 댓글들을 조회해오기(Ajax 로 처리) 끝 ====== //

	// ====== 댓글쓰기(Ajax 로 처리) 시작 =======//
	@ResponseBody
	@PostMapping(value = "/addComment.gw", produces = "text/plain;charset=UTF-8")
	public String addComment(CommentVO commentvo) {
		// 댓글쓰기에 첨부파일이 없는 경우
		int n = 0;
		try {
			n = service.addComment(commentvo);
		} catch (Throwable e) {
			e.printStackTrace();
		}

		JSONObject jsonObj = new JSONObject(); // {}
		jsonObj.put("n", n);
		jsonObj.put("name", commentvo.getName());

		return jsonObj.toString();
	} // end of public String addComment(CommentVO commentvo) {----------
	// ====== 댓글쓰기(Ajax 로 처리) 끝=======//

	// ====== 댓글쓰기에 첨부파일이 있는 경우 시작======//
	@ResponseBody
	@PostMapping(value = "/addComment_withAttach.gw", produces = "text/plain;charset=UTF-8")
	public String addComment_withAttach(CommentVO commentvo, MultipartHttpServletRequest mrequest) {
		// =========== !!! 첨부파일 업로드 시작 !!! ============ //
		MultipartFile attach = commentvo.getAttach();

		if (!attach.isEmpty()) {
			HttpSession session = mrequest.getSession();
			String root = session.getServletContext().getRealPath("/");
			String path = root + "resources" + File.separator + "files";
			String newFileName = "";

			byte[] bytes = null;

			long FileSize = 0;

			try {
				bytes = attach.getBytes();

				String originalFilename = attach.getOriginalFilename();
				newFileName = fileManager.doFileUpload(bytes, originalFilename, path);

				commentvo.setFileName(newFileName);
				commentvo.setOrgFilename(originalFilename);

				FileSize = attach.getSize();
				commentvo.setFileSize(String.valueOf(FileSize));

			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		// =========== !!! 첨부파일 업로드 끝 !!! ============ //
		int n = 0;
		try {
			n = service.addComment(commentvo);
			// 댓글쓰기(insert) 및 원게시물(tbl_board 테이블)에 댓글의 개수 증가(update 1씩 증가)하기
		} catch (Throwable e) {
			e.printStackTrace();
		}

		JSONObject jsonObj = new JSONObject();
		jsonObj.put("n", n);
		jsonObj.put("name", commentvo.getName());

		return jsonObj.toString();
	}// end of public String addComment_withAttach(CommentVO commentvo, MultipartHttpServletRequest mrequest) {------
		// ====== 댓글쓰기에 첨부파일이 있는 경우 끝 ======//

	// ====== 파일첨부가 있는 댓글쓰기에서 파일 다운로드 받기 시작====== //
	@GetMapping(value = "/downloadComment.gw")
	public void requiredLogin_downloadComment(HttpServletRequest request, HttpServletResponse response) {

		String seq = request.getParameter("seq");
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = null;

		try {
			Integer.parseInt(seq);
			CommentVO commentvo = service.getCommentOne(seq);

			if (commentvo == null || (commentvo != null && commentvo.getFileName() == null)) {
				out = response.getWriter();
				out.println("<script type='text/javascript'>alert('존재하지 않는 댓글번호 이거나 첨부파일이 없으므로 파일다운로드가 불가합니다.'); history.back();</script>");
				return;
			} 
			else {// 정상적으로 다운로드를 할 경우

				String fileName = commentvo.getFileName();

				String orgFilename = commentvo.getOrgFilename();

				HttpSession session = request.getSession();
				String root = session.getServletContext().getRealPath("/");
				String path = root + "resources" + File.separator + "files";

				// ***** file 다운로드 하기 ***** //
				boolean flag = false;
				flag = fileManager.doFileDownload(fileName, orgFilename, path, response);
				// file 다운로드 성공시 flag 는 true, file 다운로드 실패시 flag 는 false 를 가진다.

				if (!flag) {
					// 다운로드가 실패한 경우 메시지를 띄워준다.
					out = response.getWriter();
					out.println("<script type='text/javascript'>alert('파일다운로드가 실패되었습니다.'); history.back();</script>");
				}
			}

		} catch (NumberFormatException | IOException e) {
			try {
				out = response.getWriter();
				out.println("<script type='text/javascript'>alert('파일다운로드가 불가합니다.'); history.back();</script>");
			} catch (IOException e2) {
				e2.printStackTrace();
			}
		}

	}// end of public void requiredLogin_downloadComment(HttpServletRequest request, HttpServletResponse response) {--------
	// ====== 파일첨부가 있는 댓글쓰기에서 파일 다운로드 받기 끝====== //
	
	// ====== 댓글을 수정하기 시작====== //
	@ResponseBody
	@PostMapping(value = "/reviewUpdate.gw", produces = "text/plain;charset=UTF-8")
	public String reviewUpdate(HttpServletRequest request) {
		// 글 수정해야 할 글번호 가져오기
		String seq = request.getParameter("seq");
		String content = request.getParameter("content");

		// 글 수정해야할 글1개 내용가져오기
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("seq", seq);
		paraMap.put("content", content);

		CommentVO commentvo = service.getComment_One(paraMap);
		// 단순히 댓글 1개만 조회해주는 것이다.

		int n = service.getupdate_review(paraMap, commentvo);
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("n", n);
		String json = jsonObj.toString();
		return jsonObj.toString();
	}// end of public String reviewUpdate(HttpServletRequest request) {--------------
		// ====== 댓글을 수정하기 끝====== //

	// ===== 첨부 파일 있는 댓글을 삭제하기 시작 ===== ///
	@ResponseBody
	@PostMapping(value = "/comment_Del.gw", produces = "text/plain;charset=UTF-8")
	public String comment_Del(ModelAndView mav, HttpServletRequest request) {
		String seq = request.getParameter("seq");

		Map<String, String> paraMap = new HashMap<>();

		paraMap.put("seq", seq);

		int n;
		CommentVO commentvo = service.getView_comment(paraMap);

		String fileName = commentvo.getFileName();

		if (fileName != null && !"".equals(fileName)) {
			HttpSession session = request.getSession();
			String root = session.getServletContext().getRealPath("/");
			String path = root + "resources" + File.separator + "files";
			paraMap.put("path", path); // 삭제해야할 파일이 저장된 경로
			paraMap.put("fileName", fileName); // 삭제해야할 파일명
		}

		n = service.del_comment(paraMap, commentvo);

		boolean success = false;

		if (n == 1) {
			mav.addObject("message", "댓글 삭제 성공!!");
			mav.addObject("loc", request.getContextPath() + "/freeboard.gw");
			mav.setViewName("msg");
			success = true;
		} else {
			success = false;
		}

		JSONObject jsonObj = new JSONObject();
		jsonObj.put("success", success);
		String json = jsonObj.toString();

		return jsonObj.toString();
	}// end of public String comment_Del(ModelAndView mav, HttpServletRequest request) {-----
	// ===== 첨부 파일 있는 댓글을 삭제하기 끝 ===== ///

	// ===== 첨부 파일 없는 댓글을 삭제하기 시작 ===== ///
	@ResponseBody
	@PostMapping(value = "/comment_Del_nofile.gw", produces = "text/plain;charset=UTF-8")
	public String comment_Del_nofile(ModelAndView mav, HttpServletRequest request, CommentVO commentvo) {
		
		String seq = request.getParameter("seq");
		Map<String, String> paraMap = new HashMap<>();

		paraMap.put("seq", seq);
		commentvo = service.getView_comment(paraMap);

		int n = service.del_comment_nofile(paraMap, commentvo);

		boolean success_nofile = false;

		if (n == 1) {
			mav.addObject("message", "댓글 삭제 성공!!");
			mav.addObject("loc", request.getContextPath() + "/freeboard.gw");
			mav.setViewName("msg");
			success_nofile = true;
		} else {
			success_nofile = false;
		}

		JSONObject jsonObj = new JSONObject();
		jsonObj.put("success_nofile", success_nofile);
		String json = jsonObj.toString();

		return jsonObj.toString();

	}// end of public String comment_Del_nofile(ModelAndView mav, HttpServletRequest request, CommentVO commentvo) {
	// ===== 첨부 파일 없는 댓글을 삭제하기 끝 ===== ///

	// ===== 원게시물에 딸린 댓글들을 페이징 처리해서 조회해오기(Ajax 로 처리) 시작===== //
	@ResponseBody
	@GetMapping(value = "/commentList.gw", produces = "text/plain;charset=UTF-8")
	public String commentList(HttpServletRequest request) {
		String parentSeq = request.getParameter("parentSeq");
		String currentShowPageNo = request.getParameter("currentShowPageNo");

		if (currentShowPageNo == null) {
			currentShowPageNo = "1";
		}

		int sizePerPage = 5; // 한 페이지당 5개의 댓글을 보여줄 것임.
		int startRno = ((Integer.parseInt(currentShowPageNo) - 1) * sizePerPage) + 1; // 시작 행번호
		int endRno = startRno + sizePerPage - 1; // 끝 행번호

		Map<String, String> paraMap = new HashMap<>();

		paraMap.put("parentSeq", parentSeq);
		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));

		List<CommentVO> commentList = service.getCommentList_Paging(paraMap);
		JSONArray jsonArr = new JSONArray();

		if (commentList != null) {
			for (CommentVO cmtvo : commentList) {
				JSONObject jsonObj = new JSONObject();
				jsonObj.put("name", cmtvo.getName());
				jsonObj.put("content", cmtvo.getContent());
				jsonObj.put("regdate", cmtvo.getRegDate());
				jsonObj.put("fk_email", cmtvo.getFk_email());
				// ==== 댓글읽어오기에 있어서 첨부파일 기능을 넣은 경우 시작 ==== //
				jsonObj.put("seq", cmtvo.getSeq());
				jsonObj.put("fileName", cmtvo.getFileName());
				jsonObj.put("orgFilename", cmtvo.getOrgFilename());
				jsonObj.put("fileSize", cmtvo.getFileSize());
				// ==== 댓글읽어오기에 있어서 첨부파일 기능을 넣은 경우 끝 ==== //
				jsonArr.put(jsonObj);

			} // end of for-----------------------------------
		}
		return jsonArr.toString();
	}// end of public String commentList(HttpServletRequest request) { -------------
	// ===== 원게시물에 딸린 댓글들을 페이징 처리해서 조회해오기(Ajax 로 처리) 끝 ===== //

	// === 원게시물에 딸린 댓글의 totalPage 수 알아오기(JSON 으로 처리) 시작 === //
	@ResponseBody
	@GetMapping(value = "/getCommentTotalPage.gw")
	public String CommentTotalPage(HttpServletRequest request) {

		String parentSeq = request.getParameter("parentSeq");
		String sizePerPage = request.getParameter("sizePerPage");

		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("parentSeq", parentSeq);
		paraMap.put("sizePerPage", sizePerPage);

		// 원글 글번호(parentSeq)에 해당하는 댓글의 totalPage 수 알아오기
		int totalPage = service.getCommentTotalPage(paraMap);

		JSONObject jsonObj = new JSONObject();
		jsonObj.put("totalPage", totalPage);

		return jsonObj.toString();
	} // end of public String CommentTotalPage(HttpServletRequest request) {------------
	// === 원게시물에 딸린 댓글의 totalPage 수 알아오기(JSON 으로 처리) 끝 === //
	
	//자유게시판 좋아요 추가하기 
	@ResponseBody
	@PostMapping("/like_add.gw")
	public String like_add(FreeBoard_likesVO freeBoard_likesvo,HttpServletRequest request) {
	    int success = 0;
	    
	    String fk_seq = request.getParameter("seq");
	    String fk_email = request.getParameter("fk_email");
	    String name = request.getParameter("name");
	    
	    freeBoard_likesvo.setFk_email(fk_email);
	    freeBoard_likesvo.setFk_seq(fk_seq);
	    freeBoard_likesvo.setName(name);

	    try {
	        success = service.getlike_add(freeBoard_likesvo);
	    } catch (Throwable e) {
	        e.printStackTrace();
	    }

	    JSONObject jsonObj = new JSONObject();
	    jsonObj.put("success", success > 0);

	    return jsonObj.toString();
	}
	
	//자유게시판 좋아요한 유저의 좋아요 취소하기 
	@ResponseBody
	@PostMapping("/like_del.gw")
	public String like_del(HttpServletRequest request) {
	    int success = 0;
	    String fk_email = request.getParameter("fk_email");

	    try {
	        success = service.getlike_del(fk_email);
	    } catch (Throwable e) {
	        e.printStackTrace();
	    }

	    JSONObject jsonObj = new JSONObject();
	    jsonObj.put("success", success > 0);

	    return jsonObj.toString();
	}

		
	
}

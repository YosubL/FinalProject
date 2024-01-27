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

import com.spring.app.common.FileManager;
import com.spring.app.common.MyUtil;
import com.spring.app.domain.EmployeesVO;
import com.spring.app.domain.NoticeboardFileVO;
import com.spring.app.domain.NoticeboardVO;
import com.spring.app.saehan.service.NoticeSaehanService;

@Controller
public class NoticeBoardController {
	
	@Autowired
	private NoticeSaehanService service;

	@Autowired
	private FileManager fileManager;
	
	//////////////////////////////////공지사항 다시시작//////////////////////////////////////////////
	
	// ========== 공지사항 리스트 페이지 만들기 시작 =============
	@GetMapping("/noticeboard.gw")
	public ModelAndView noticeboard(ModelAndView mav, HttpServletRequest request) {

		List<NoticeboardVO> boardList = null;

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

		// 공지사항의 총 게시물 건수(totalCount) 가져오기
		totalCount = service.getNoticeTotalCount(paraMap);

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
			} catch (NumberFormatException e) {
				currentShowPageNo = 1;
			}
		} // end of else{------------------------

		int startRno = ((currentShowPageNo - 1) * sizePerPage) + 1; // 시작 행번호
		int endRno = startRno + sizePerPage - 1; // 끝 행번호

		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));

		boardList = service.noticeListSearch_withPaging(paraMap);
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
		String url = "noticeboard.gw";

		// === [맨처음][이전] 만들기 === //
		if (pageNo != 1) {
			pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a style='color:black;' href='" + url + "?searchType="
					+ searchType + "&searchWord=" + searchWord + "&currentShowPageNo=1'>[맨처음]</a></li>";
			pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a style='color:black;' href='" + url + "?searchType="
					+ searchType + "&searchWord=" + searchWord + "&currentShowPageNo=" + (pageNo - 1)
					+ "'>[이전]</a></li>";
		}

		while (!(loop > blockSize || pageNo > totalPage)) {

			if (pageNo == currentShowPageNo) {
				pageBar += "<li style='display:inline-block; width:30px; font-size:12pt; border:solid 1px gray; color:black; padding:2px 4px;'>"
						+ pageNo + "</li>";
			}

			else {
				pageBar += "<li style='display:inline-block; width:30px; font-size:12pt;'><a style='color:black;' href='" + url
						+ "?searchType=" + searchType + "&searchWord=" + searchWord + "&currentShowPageNo=" + pageNo
						+ "'>" + pageNo + "</a></li>";
			}

			loop++;
			pageNo++;

		} // end of while-------------------------

		// ===== [다음][마지막] 만들기 ===== //
		if (pageNo <= totalPage) {
			pageBar += "<li class='icon_text' style='display:inline-block; width:50px; font-size:8pt;'><a class='material-icons-outlined icon_img' style='font-size: 12pt; color:black;' href='" + url + "?searchType="
					+ searchType + "&searchWord=" + searchWord + "&currentShowPageNo=" + pageNo + "'>[다음]</a></li>";
			pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a style='color:black;' href='" + url + "?searchType="
					+ searchType + "&searchWord=" + searchWord + "&currentShowPageNo=" + totalPage + "'>[마지막]</a></li>";
		}

		pageBar += "</ul>";

		mav.addObject("pageBar", pageBar);

		// === 특정 글제목을 클릭한 뒤 상세내용을 본 이후 사용자가 "검색된결과목록보기" 버튼을 클릭했을때 현재 페이지 주소를 뷰단으로 넘겨준다.
		String goBackURL = MyUtil.getCurrentURL(request);

		mav.addObject("goBackURL", goBackURL);
		mav.setViewName("mshboard/noticeboard.tiles_MTS");

		return mav;

	} // end of public ModelAndView mainboard(ModelAndView mav,HttpServletRequest request) {-----------

	// ========== 공지사항 리스트 페이지 만들기 끝 =============
	
	// ===== 검색어 입력시 자동글 완성하기 시작 ===== //
	@ResponseBody
	@GetMapping(value = "/notice_wordSearchShow.gw", produces = "text/plain;charset=UTF-8")
	public String notice_wordSearchShow(HttpServletRequest request) {

		String searchType = request.getParameter("searchType");
		String searchWord = request.getParameter("searchWord");

		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("searchType", searchType);
		paraMap.put("searchWord", searchWord);

		List<String> wordList = service.notice_wordSearchShow(paraMap);

		JSONArray jsonArr = new JSONArray(); // []

		if (wordList != null) {
			for (String word : wordList) {
				JSONObject jsonObj = new JSONObject(); // {}
				jsonObj.put("word", word);
				jsonArr.put(jsonObj); // [{},{},{}]
			} // end of for------------
		}

		return jsonArr.toString();
	}
	// ===== 검색어 입력시 자동글 완성하기 끝 ===== //
	
	
	// ===== 공지사항 쓰기 페이지 요청 시작 ===== ///
	@GetMapping("/noticeadd.gw")
	public ModelAndView notice_add(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		mav.setViewName("mshboard/noticeadd.tiles_MTS");
		return mav;
	}// end of public ModelAndView notice_add(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) { ------------
	// ===== 공지사항 쓰기 페이지 요청 끝 ===== //
	
	// ====== 게시판 글쓰기 완료 요청 ======= //
	@ResponseBody
	@PostMapping("/notice_addEnd.gw")
	public String notice_addEnd(Map<String, Object> paraMap, NoticeboardVO boardvo, MultipartHttpServletRequest mrequest, HttpServletRequest request) throws Exception {
		
		String recipient = mrequest.getParameter("fk_emp_id");
	    String subject = mrequest.getParameter("subject");
	    String content = mrequest.getParameter("content");
	    String seq = request.getParameter("seq");

	    HttpSession session = mrequest.getSession();
	    EmployeesVO loginuser = (EmployeesVO) session.getAttribute("loginuser");
	    
	    boardvo.setFk_emp_id(loginuser.getEmployee_id());        
	    boardvo.setName(loginuser.getName());

	    paraMap.put("boardvo", boardvo);
	    
	    List<NoticeboardFileVO> fileList = new ArrayList<>();

	    if (mrequest.getFiles("file_arr") != null) {
	        String root = session.getServletContext().getRealPath("/");
	        String path = root + "resources" + File.separator + "Filename";
	        
	        if (!new File(path).exists()) {
	            new File(path).mkdirs();
	        }

	        for (MultipartFile mtfile : mrequest.getFiles("file_arr")) {

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
	                NoticeboardFileVO nvo = new NoticeboardFileVO();
	                nvo.setFileName(newFileName);
	                nvo.setOrgFilename(originalFilename);
	                filesize = mtfile.getSize();
	                nvo.setFileSize(String.valueOf(mtfile.getSize()));
	                
	                // 첨부파일 리스트에 추가
	                fileList.add(nvo);

	            } catch (Exception e) {
	                e.printStackTrace();
	            }
	        }//end of for (MultipartFile mtfile : mrequest.getFiles("file_arr")) {-----------------
	    }//end of  if (mrequest.getFiles("file_arr") != null) {----------------------------

	    paraMap.put("fileList", fileList);

	    boolean result = service.notice_addEnd(paraMap);
	    JSONObject jsonObj = new JSONObject();
	    jsonObj.put("result", result);
	    return jsonObj.toString();
	} // end of public ModelAndView addEnd(Map<String, String> paraMap, ModelAndView mav, BoardVO boardvo, MultipartHttpServletRequest mrequest) { ----------
	// ====== 게시판 글쓰기 완료 요청 끝======= //
	
	//첨부파일 없는 공지사항 글쓰기
	@ResponseBody
	@PostMapping(value = "/nofile_notice_add.gw" , produces = "text/plain;charset=UTF-8")
	public String nofile_notice_add(Map<String, String> paraMap, NoticeboardVO boardvo) {
		int n = 0;

		try {
			n = service.nofile_notice_add(boardvo);
		} catch (Throwable e) {
			e.printStackTrace();
		}
		
		JSONObject jsonObj = new JSONObject(); // {}
		jsonObj.put("n", n);

		return jsonObj.toString();

	}
	
	
	
	// ====== 공지사항 1개를 보여주는 페이지 요청하기 시작 ====== //
	@RequestMapping("/notice_view.gw") // ==== 특정글을 조회한 후 "검색된결과목록보기" 버튼을 클릭했을 때 돌아갈 페이지를 만들기 위함.
	public ModelAndView notice_view(ModelAndView mav, HttpServletRequest request) {
		
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

			NoticeboardVO boardvo = null;
			List<NoticeboardFileVO> fileList = null;
			
			if ("yes".equals((String) session.getAttribute("readCountPermission"))) {
				boardvo = service.getNoticeView(paraMap);
				// 글조회수 증가와 함께 글1개를 조회를 해주는 것
				fileList = service.getView_notice_files(seq);
				session.removeAttribute("readCountPermission");
			}
			
			else {
				boardvo = service.getnotice_View_no_increase_readCount(paraMap);
			}
			
			mav.addObject("fileList", fileList);
			mav.addObject("boardvo", boardvo);
			mav.addObject("paraMap", paraMap);

		} catch (NumberFormatException e) {
			mav.setViewName("redirect:/noticeboard.gw");
			return mav;
		}

		mav.setViewName("mshboard/notice_view.tiles_MTS");
		return mav;
	}// end of public ModelAndView view(ModelAndView mav, HttpServletRequest request) {-------------

	// ====== 글1개를 보여주는 페이지 요청하기 끝 ====== //

	// ====== 공지사항 1개를 보여주는 페이지 요청하기 시작 ====== //
	@RequestMapping("/notice_view_2.gw")
	public ModelAndView notice_view_2(ModelAndView mav, HttpServletRequest request, RedirectAttributes redirectAttr) {

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

		mav.setViewName("redirect:/notice_view.gw");
		// ==== GET 방식이 아닌 POST 방식처럼 데이터를 넘기려면 RedirectAttributes 를 사용하면 된다. 끝 ==== //

		return mav;

	}// end of public ModelAndView notice_view_2(ModelAndView mav, HttpServletRequest request, RedirectAttributes redirectAttr) {-----
	// ====== 공지사항 1개를 보여주는 페이지 요청하기 끝 ====== //

	// ====== 첨부파일 다운로드 받기 시작 ======= //
	@GetMapping(value = "/notice_download.gw")
	public void notice_download(HttpServletRequest request, HttpServletResponse response) {

		String fileno = request.getParameter("fileno");
		// 첨부파일이 있는 글번호
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("fileno", fileno);
		paraMap.put("searchType", "");
		paraMap.put("searchWord", "");

		response.setContentType("text/html; charset=UTF-8");
		
		PrintWriter out = null;
		NoticeboardFileVO filevo = null;
		try {
			Integer.parseInt(fileno);
			filevo = service.getNotice_Each_view_files(fileno);
		
			if (filevo == null || (filevo != null &&  filevo.getFileName() == null)) {
				out = response.getWriter();
				out.println("<script type='text/javascript'>alert('존재하지 않는 글번호 이거나 첨부파일이 없으므로 파일다운로드가 불가합니다.'); history.back();</script>");
				return;
			} else { // 정상적으로 다운로드를 할 경우
				String fileName = filevo.getFileName();
				String orgFilename = filevo.getOrgFilename();
				HttpSession session = request.getSession();
				String root = session.getServletContext().getRealPath("/");
				String path = root + "resources" + File.separator + "Filename";

				// ***** file 다운로드 하기 ***** //
				boolean flag = false; 
				flag = fileManager.doFileDownload(fileName, orgFilename, path, response);
				if (!flag) {
					out = response.getWriter();
					out.println("<script type='text/javascript'>alert('파일다운로드가 실패되었습니다.'); history.back();</script>");
				}
			}

		} catch (NumberFormatException | IOException e) {
				e.printStackTrace();
			try {
				out = response.getWriter();
				out.println("<script type='text/javascript'>alert('파일다운로드가 불가합니다.'); history.back();</script>");
			} catch (IOException e2) {
				e2.printStackTrace();
			}
		}

	}// end of public void requiredLogin_download(HttpServletRequest request, HttpServletResponse response) {--------------
	// ====== 첨부파일 다운로드 받기 끝 ======= //
	
	
	// ===== 글을 삭제하는 페이지 시작===== //
	@GetMapping("/notice_del.gw")
	public ModelAndView notice_del1(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {

		// 삭제해야 할 글번호 가져오기
		String seq = request.getParameter("seq");
		String fileno = request.getParameter("fileno");
		String message = "";
		List<NoticeboardFileVO> fileList = null;
		try {
			Integer.parseInt(seq);
			
			Map<String, String> paraMap = new HashMap<>();
			paraMap.put("seq", seq);
			
			
			NoticeboardVO boardvo = service.getnotice_View_no_increase_readCount(paraMap);
			fileList= service.getView_notice_files(seq);
			
			if (boardvo == null) {
				message = "글 삭제가 불가합니다";
			} else {
				HttpSession session = request.getSession();
				EmployeesVO loginuser = (EmployeesVO) session.getAttribute("loginuser");

				mav.addObject("fileList", fileList);
				mav.addObject("boardvo", boardvo);
				mav.setViewName("mshboard/notice_del.tiles_MTS");

				return mav;
			} // end of try {----------------
		} catch (NumberFormatException e) {
			message = "글 삭제가 불가합니다!!!";
		} // end of else{-------------

		String loc = "javascript:history.back()";
		mav.addObject("message", message);
		mav.addObject("loc", loc);

		mav.setViewName("msg");

		return mav;
	}// end of public ModelAndView requiredLogin_del(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {---
		// ===== 글을 삭제하는 페이지 요청하기 끝 ===== //

	// ====== 글을 삭제하는 페이지 완료하기 시작====== //
	@PostMapping("/notice_delEnd.gw")
	public ModelAndView notice_delEnd(ModelAndView mav, HttpServletRequest request) {

		String seq = request.getParameter("seq");

		
		Integer.parseInt(seq);
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("seq", seq);
		
		// === 파일첨부가 된 글이라면 글 삭제시 먼저 첨부파일을 삭제해주어야 한다. 시작 === //
		paraMap.put("searchType", "");
		paraMap.put("searchWord", "");
		
		NoticeboardVO boardvo = service.getNoticeView(paraMap);
		List<NoticeboardFileVO> fileList = service.getView_notice_files(seq);

		String fileName = boardvo.getAttachfile();

		int n = 0;
		int n2 = 0;
		int n3 = 0;

	    HttpSession session = request.getSession();
	    String root = session.getServletContext().getRealPath("/");
	    String path = root + "resources" + File.separator + "filename";

	    for (NoticeboardFileVO fileVO : fileList) {
	        String fileName1 = fileVO.getFileName();
	        String fileno1 = fileVO.getFileno();
	        paraMap.put("path", path); // 삭제해야할 파일이 저장된 경로
	        paraMap.put("fileName", fileName1); // 삭제해야할 파일명
	        paraMap.put("fileno", fileno1);
	        n = service.notice_del_attach(paraMap);
	    }

	    if (n == 1) {
	        n2 = service.notice_del(paraMap);
	    }
	
	    // 파일이 첨부되지 않은 경우에도 n3에 값을 대입한다.
	    n3 = service.notice_del(paraMap);
	
	// === 파일첨부가 된 글이라면 글 삭제시 먼저 첨부파일을 삭제해주어야 한다. 끝 === //

		if (n3 == 1 || n2 == 1) {
		    mav.addObject("message", "글 삭제 성공!!");
		    mav.addObject("loc", request.getContextPath() + "/noticeboard.gw");
		    mav.setViewName("msg");
		}
			return mav;
		}// end of public ModelAndView delEnd(ModelAndView mav, HttpServletRequest request) {------
		// ====== 글을 삭제하는 페이지 완료하기 끝===== //
	
		// ===== 글을 수정하는 페이지 요청 시작 ===== //
		@GetMapping("/notice_edit.gw")
		public ModelAndView notice_edit(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
			// 글 수정해야 할 글번호 가져오기
			String seq = request.getParameter("seq");
			String message = "";
			try {
				Integer.parseInt(seq);
				// 글 수정해야할 글1개 내용가져오기
				Map<String, String> paraMap = new HashMap<>();
				paraMap.put("seq", seq);
				NoticeboardVO boardvo = service.getnotice_View_no_increase_readCount(paraMap);
				// 글조회수(readCount) 증가 없이 단순히 글 1개만 조회해주는 것이다.

				if (boardvo == null) {
					message = "글 수정이 불가합니다";
				}

				else {
					HttpSession session = request.getSession();
					EmployeesVO loginuser = (EmployeesVO) session.getAttribute("loginuser");

					if (!loginuser.getEmployee_id().equals(boardvo.getFk_emp_id())) {
						message = "다른 사용자의 글은 수정이 불가합니다";
					}

					else {
						// 자신의 글을 수정할 경우
						mav.addObject("boardvo", boardvo);
						mav.setViewName("mshboard/notice_edit.tiles_MTS");

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
		@RequestMapping(value = "/getNotice_BoardFiles.gw", produces = "text/plain;charset=UTF-8")
		public String getNoticeFiles(HttpServletRequest request, @RequestParam("seq") String seq) {

			Map<String, String> paraMap = new HashMap<>();
			paraMap.put("seq", seq); // 글번호
			
			// 첨부파일 조회
			List<NoticeboardFileVO> fileList = service.getView_notice_files(seq);
				
			JSONArray jsonArr = new JSONArray(fileList);
				
			return String.valueOf(jsonArr);
		}
		
		
		//공지사항 글 수정하기 요청완료
		@ResponseBody
		@PostMapping(value ="notice_editEnd.gw", produces = "text/plain;charset=UTF-8")
		public String notice_editEnd(HttpServletRequest request, MultipartHttpServletRequest mrequest,NoticeboardVO boardvo) {
			
			Map<String, Object> paraMap = new HashMap<>();
			Map<String, String> paraMap2 = new HashMap<>();
			String fk_seq = request.getParameter("fk_seq");	
			
			paraMap.put("boardvo", boardvo);
			paraMap2.put("fk_seq", boardvo.getSeq());
			
			HttpSession session = mrequest.getSession();
			
			// service로 넘길 파일정보가 담긴 리스트
			List<NoticeboardFileVO> fileList = new ArrayList<>();

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
		                NoticeboardFileVO nvo = new NoticeboardFileVO();
		                nvo.setFileName(newFileName);
		                nvo.setOrgFilename(originalFilename);
		                filesize = mtfile.getSize();
		                nvo.setFileSize(String.valueOf(mtfile.getSize()));
		                
		                // 첨부파일 리스트에 추가
		                fileList.add(nvo);

		            } catch (Exception e) {
		                e.printStackTrace();
		            }
		        }
		    }

		    paraMap.put("fileList", fileList);
		    
		    boolean result = service.notice_board_edit(paraMap);
		      
		    String attachfile = service.noticeboard_update_attachfile(boardvo.getSeq()); 	
		  
		    int a = 0;
			int b = 0;
		    
			if (attachfile.equals("0")) {
				 a = service.getnoticeboard_filename_clear(paraMap2);
			}
			else {

				 b = service.getnoticeboard_filename_add(paraMap2);
			}

		    JSONObject jsonObj = new JSONObject();
		    jsonObj.put("result", result);
		    return jsonObj.toString();
				
		}
		
	
		//글 수정다음에 띄어줘야할 페이지
		@GetMapping("/notice_editAfter_view.gw")
		public ModelAndView notice_editAfter_view(ModelAndView mav, HttpServletRequest request) {
			
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

				NoticeboardVO boardvo = null;
				List<NoticeboardFileVO> fileList = null;
				
				// 글목록에서 특정 글제목을 클릭하여 본 상태에서 웹브라우저에서 새로고침(F5)을 클릭한 경우이다.
				boardvo = service.getNoticeView(paraMap);
				fileList = service.getView_notice_files(seq);
				
				mav.addObject("fileList", fileList);
				mav.addObject("boardvo", boardvo);
				mav.addObject("paraMap", paraMap);

			} catch (NumberFormatException e) {
				mav.setViewName("redirect:/Noticeboard.gw");
				return mav;
			}

			mav.setViewName("mshboard/notice_view.tiles_MTS");
			return mav;
		}//end of public ModelAndView editAfter_notice_view(ModelAndView mav, NoticeboardVO boardvo, HttpServletRequest request) {
		
		
		// (공지사항 글 수정) 기존에 첨부된 파일 삭제
		@ResponseBody
		@PostMapping(value = "/notice_deleteFile.gw", produces = "text/plain;charset=UTF-8")
		public String notice_deleteFile(HttpServletRequest request, @RequestParam("fileno") String fileno) {
			
			String fk_seq = request.getParameter("fk_seq");
			
			Map<String, String> paraMap = new HashMap<>();
			paraMap.put("fileno", fileno); // 삭제하려는 파일번호
			paraMap.put("fk_seq", fk_seq);
			HttpSession session = request.getSession();
			
			String root = session.getServletContext().getRealPath("/");				
			String path = root + "resources" + File.separator + "filename";
			
			// 파일 테이블에서 파일삭제
			boolean result = service.notice_delete_file(fileno, path);
			
			String attachfile = service.noticeboard_update_attachfile(fk_seq);
			
			
			int a = 0;
			
			if (attachfile.equals("0")) {
				 a = service.getnoticeboard_filename_clear(paraMap);
			}
		
			JSONObject json = new JSONObject();
			json.put("result", result);
			json.put("a", a);
			return String.valueOf(json);
		}	

	// ========== 글을 수정하는 페이지에서 첨부파일 삭제 끝 =============//
	
	
	
}

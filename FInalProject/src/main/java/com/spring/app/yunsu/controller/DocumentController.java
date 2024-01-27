package com.spring.app.yunsu.controller;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

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
import com.spring.app.common.Pagination;
import com.spring.app.domain.DocumentVO;
import com.spring.app.domain.EmployeesVO;
import com.spring.app.yunsu.service.DocumentService;


@Controller
public class DocumentController {
	
	@Autowired
	private DocumentService service;
	
	@Autowired
	private FileManager fileManager;
	
	// === 문서 시작 페이지 ===
	@GetMapping("/document.gw")
	public ModelAndView requiredLogin_showDocument(HttpServletRequest request, HttpServletResponse response, ModelAndView mav, Pagination pagination) { 
		
		List<Map<String,String>> documentList = null;
		Map<String, Object> paraMap = new HashMap<String, Object>();
		
		
		if(pagination.getSearchWord() == null || "".equals(pagination.getSearchWord()) || pagination.getSearchWord().trim().isEmpty()) {
			pagination.setSearchWord("");
		}
		
		pagination.setSearchType("");
		//System.out.println("a=>"+pagination.getStartRno());
		//System.out.println("b=>"+pagination.getEndRno());
		paraMap.put("pagination", pagination);
		
		// 문서 갯수 가져오기
		int listCnt = service.getDocuSearchCnt(paraMap);
		//System.out.println(listCnt);
		// startRno, endRno 구하기
		// 구해 온 최대 글 개수를 파라미터로 넘긴다.
		// 파라맵에 받아온 두개의 startrno와 endrno를 담아주어야 한다
		pagination.setPageInfo(listCnt);
		paraMap.put("pagination", pagination);
		
		// 한 페이지에 표시할 이용자 예약 내역 글 목록
		documentList = service.getDocumentList(paraMap);
		//System.out.println(documentList);
		
		mav.addObject("documentList", documentList);
		
		pagination.setQueryString("");
		//System.out.println(pagination.getPagebar(request.getContextPath()+"/document.gw"));
		mav.addObject("pagebar", pagination.getPagebar(request.getContextPath()+"/document.gw"));
		
		
		mav.addObject("paraMap", paraMap);
		
		mav.setViewName("document/documentPage.tiles_MTS");
		
		return mav;
	}
	
	@PostMapping("/documentDown.gw")
	public ModelAndView requiredLogin_documentDown(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) { 
		
		String employee_id = request.getParameter("employee_id");
		String purpose = request.getParameter("purpose");
		String category = request.getParameter("category");
		String document_name = request.getParameter("document_name");
		// 사원정보 가져오기
		Map<String, String> paraMap = service.documentDown(employee_id);
		paraMap.put("document_name", document_name);
		paraMap.put("purpose", purpose);
		paraMap.put("category", category);
		
		//문서 다운 기록 남기기
		int n = service.documentInsert(paraMap);
		
		
		
		mav.addObject("paraMap", paraMap);
		mav.setViewName("document/document.tiles_MTS2");
		
		return mav;
	}
	
	
	@PostMapping("/registerDocument.gw")
	public ModelAndView registerDocument(ModelAndView mav,DocumentVO documentvo, MultipartHttpServletRequest mrequest) {
		
		String ctxPath = mrequest.getContextPath();
		
		MultipartFile attach = documentvo.getAttach();
		
		if(attach != null) {
			// attach(첨부파일)가 비어 있지 않으면(즉, 첨부파일이 있는 경우라면)
			/*
          1. 사용자가 보낸 첨부파일을 WAS(톰캣)의 특정 폴더에 저장해주어야 한다. 
          >>> 파일이 업로드 되어질 특정 경로(폴더)지정해주기
                       우리는 WAS의 webapp/resources/files 라는 폴더로 지정해준다.
                       조심할 것은  Package Explorer 에서  files 라는 폴더를 만드는 것이 아니다.       
         */
		 // WAS 의 webapp 의 절대경로를 알아와야 한다.
			HttpSession session = mrequest.getSession();
			String root = session.getServletContext().getRealPath("/");
			
			//System.out.println("~~~ 확인용 webapp 의 절대경로 =>" + root);
		//~~~ 확인용 webapp 의 절대경로 =>C:\NCS\workspace_spring_framework\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\board\
			
		String path = root+"resources"+File.separator+"document";
/* 		File.separator 는 운영체제에서 사용하는 폴더와 파일의 구분자이다.
                  운영체제가 Windows 이라면 File.separator 는  "\" 이고,
                  운영체제가 UNIX, Linux, 매킨토시(맥) 이라면  File.separator 는 "/" 이다. 
*/	
		// path 가 첨부파일이 저장될 WAS(톰캣)의 폴더가 된다.
		//System.out.println("~~~ 확인용 path => " +path);
		//~~~ 확인용 path => C:\NCS\workspace_spring_framework\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\board\resources\files
		
		/*
		 	2. 파일첨부를 위한 변수의 설정 및 값을 초기화 한 후 파일 올리기
		*/
		String newFileName = "";
		// WAS(톰캣)의 디스크에 저장될 파일명
		
		byte[] bytes = null;
		// 첨부파일의 내용물을 담는 것
		
		long fileSize = 0;
		// 첨부파일의 크기
		
		try {
			bytes = attach.getBytes();
			// 첨부파일의 내용물을 읽어오는 것
			
			String originalFilename = attach.getOriginalFilename();
			// attach.getOriginalFilename() 이 첨부파일명의 파일명(예: 강아지.png) 이다.
			
			//System.out.println("~~~ 확인용 originalFilename => " + originalFilename);
			//~~~ 확인용 originalFilename => LG_싸이킹청소기_사용설명서.pdf
			
			newFileName = fileManager.doFileUpload(bytes, originalFilename, path);
			// 첨부되어진 파일을 업로드 하는 것이다.
			
			//System.out.println("~~~ 확인용 newFileName" + newFileName);
			//~~~ 확인용 newFileName202311241135483380607484034000.pdf
			
			/*
			  boardvo 에 fileName 값과 orgFilename 값과 fileSize 값을 넣어주기
			*/
			documentvo.setFileName(newFileName);
			// WAS(톰캣)에 저장된 파일명
			
			documentvo.setOrgFilename(originalFilename);
			// 게시판 페이지에서 첨부된 파일(LG싸이킹.png)을 보여줄 때 사용.
            // 또한 사용자가 파일을 다운로드 할때 사용되어지는 파일명으로 사용.
			fileSize = attach.getSize(); // 첨부파일의 크기(단위는 byte임)
			
			documentvo.setFileSize(String.valueOf(fileSize)); 
			
		  } catch (Exception e) {
			  e.printStackTrace();
			  
		}
		
		}
		
		int n = 0;
		
		n = service.insertDocument(documentvo);
		
		if(n==1) {
			
			  String message = "문서 업로드를 성공 하였습니다.";
		      String loc = ctxPath+"/document.gw";
		      
		      mav.addObject("message", message);
		      mav.addObject("loc", loc);
		      
		      mav.setViewName("msg");
		}
		else {
			  String message = "문서 업로드를 실패 하였습니다.";
		      String loc = ctxPath+"/document.gw";
		      
		      mav.addObject("message", message);
		      mav.addObject("loc", loc);
		      
		      mav.setViewName("msg");
		}
		
		return mav;
	}
	
	
	@ResponseBody
	@PostMapping("/deleteDocument.gw")
	public String deleteDocument(HttpServletRequest request) {
		
		String seq = request.getParameter("seq");
		
		// 삭제할 문서 이름 가져오기
		String fileName = service.deleteDocumentSelect(seq);
		
		HttpSession session = request.getSession();
		String root = session.getServletContext().getRealPath("/");
		
		String path = root+"resources"+File.separator+"document";
		
		Map<String,String> paraMap = new HashMap<>();
		
		paraMap.put("fileName",fileName);
		paraMap.put("seq",seq);
		paraMap.put("path",path);
		
		int n=0;
		try {
			
			 n = service.deleteDocument(paraMap);
		
		} catch (Throwable e) {
			e.printStackTrace();
		}
		
		
		JSONObject jsonObj = new JSONObject(); // {}
		jsonObj.put("n", n); // {"n":1}  {"n":0}
		
		return jsonObj.toString();
	}
	
	@GetMapping("/documentDown.gw")
	public void requiredLogin_documentDown(HttpServletRequest request, HttpServletResponse response) {
		
		String seq = request.getParameter("seq");
		 
		HttpSession session = request.getSession();
		EmployeesVO loginuser = (EmployeesVO) session.getAttribute("loginuser"); 
		
		String employee_id = loginuser.getEmployee_id();
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("seq", seq);
		
		
		// *** 웹브라우저에 출력하기 시작 *** //
	      // HttpServletResponse response 객체는 전송되어져온 데이터를 조작해서 결과물을 나타내고자 할때 쓰인다.
	      response.setContentType("text/html; charset=UTF-8");
	      
	      PrintWriter out = null;
	      // out 은 웹브라우저에 기술하는 대상체라고 생각하자.
		
		
		try {
			
	        DocumentVO documentvo = service.viewDocument(paraMap);
			
			String fileName = documentvo.getFileName();
				// 202311241248243384963525659600.pdf 이것이 바로 WAS(톰캣) 디스크에 저장된 파일명이다.
				
			String orgFilename = documentvo.getOrgFilename();
				// LG_싸이킹청소기_사용설명서.pdf 다운로드시 보여줄 파일명
				
				// 첨부파일이 저장되어 있는  WAS(톰캣) 디스크 경로명을 알아와야만 다운로드를 해줄 수 있다.
				// 이 경로는 우리가 파일첨부를 위해서 /addEnd.action 에서 설정해두었던 경로와 똑같아야 한다.
				
				String root = session.getServletContext().getRealPath("/");
				
				//System.out.println("~~~ 확인용 webapp 의 절대경로 =>" + root);
			//~~~ 확인용 webapp 의 절대경로 =>C:\NCS\workspace_spring_framework\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\board\
				
			String path = root+"resources"+File.separator+"document";
	/* 		File.separator 는 운영체제에서 사용하는 폴더와 파일의 구분자이다.
	                  운영체제가 Windows 이라면 File.separator 는  "\" 이고,
	                  운영체제가 UNIX, Linux, 매킨토시(맥) 이라면  File.separator 는 "/" 이다. 
	*/	
			// path 가 첨부파일이 저장될 WAS(톰캣)의 폴더가 된다.
			//System.out.println("~~~ 확인용 path => " +path);
			//~~~ 확인용 path => C:\NCS\workspace_spring_framework\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\board\resources\files
			
			// ***** file 다운로드 하기 ***** //
			boolean flag = false; // file 다운로드 성공, 실패인지 여부를 알려주는 용도
			flag = fileManager.doFileDownload(fileName, orgFilename, path, response);
			// file 다운로드 성공시  flag 는 true,
			// file 다운로드 실패시  flag 는 false 를 가진다.
			
			paraMap.put("employee_id", employee_id);
			paraMap.put("orgFilename", orgFilename);
			
			if(flag) {
				int n = service.insertDownLoadrecord(paraMap);
			}
			
			if(!flag) {
				// 다운로드가 실패한 경우 메시지를 띄워준다.
				out = response.getWriter();
				// out 은 웹브라우저에 기술하는 대상체라고 생각하자.
				
				out.println("<script type='text/javascript'>alert('파일 다운로드가 실패 되었습니다.'); history.back();</script>");
				return;
			}
			
		}catch(NumberFormatException | IOException e) {
			try {
				// 다운로드가 실패한 경우 메시지를 띄워준다.
				out = response.getWriter();
				// out 은 웹브라우저에 기술하는 대상체라고 생각하자.
				
				out.println("<script type='text/javascript'>alert('파일 다운로드가 불가합니다.'); history.back();</script>");
				return;
				
				}catch(IOException e2) {
					e2.printStackTrace();
				}
		}
		
		
	}
	
	@PostMapping("/updateDocument.gw")
	public ModelAndView updateDocument(ModelAndView mav,DocumentVO documentvo, MultipartHttpServletRequest mrequest) {
		
		String del_fileName = service.selectUpdateDeleteFile(documentvo);
		
		MultipartFile attach = documentvo.getAttach();
		
		if(attach != null) {
			// attach(첨부파일)가 비어 있지 않으면(즉, 첨부파일이 있는 경우라면)
			/*
          1. 사용자가 보낸 첨부파일을 WAS(톰캣)의 특정 폴더에 저장해주어야 한다. 
          >>> 파일이 업로드 되어질 특정 경로(폴더)지정해주기
                       우리는 WAS의 webapp/resources/files 라는 폴더로 지정해준다.
                       조심할 것은  Package Explorer 에서  files 라는 폴더를 만드는 것이 아니다.       
         */
		 // WAS 의 webapp 의 절대경로를 알아와야 한다.
			HttpSession session = mrequest.getSession();
			String root = session.getServletContext().getRealPath("/");
			
			//System.out.println("~~~ 확인용 webapp 의 절대경로 =>" + root);
		//~~~ 확인용 webapp 의 절대경로 =>C:\NCS\workspace_spring_framework\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\board\
			
		String path = root+"resources"+File.separator+"document";
/* 		File.separator 는 운영체제에서 사용하는 폴더와 파일의 구분자이다.
                  운영체제가 Windows 이라면 File.separator 는  "\" 이고,
                  운영체제가 UNIX, Linux, 매킨토시(맥) 이라면  File.separator 는 "/" 이다. 
*/	
		// path 가 첨부파일이 저장될 WAS(톰캣)의 폴더가 된다.
		//System.out.println("~~~ 확인용 path => " +path);
		//~~~ 확인용 path => C:\NCS\workspace_spring_framework\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\board\resources\files
		
		/*
		 	2. 파일첨부를 위한 변수의 설정 및 값을 초기화 한 후 파일 올리기
		*/
		String newFileName = "";
		// WAS(톰캣)의 디스크에 저장될 파일명
		
		byte[] bytes = null;
		// 첨부파일의 내용물을 담는 것
		
		long fileSize = 0;
		// 첨부파일의 크기
		
		try {
			bytes = attach.getBytes();
			// 첨부파일의 내용물을 읽어오는 것
			
			String originalFilename = attach.getOriginalFilename();
			// attach.getOriginalFilename() 이 첨부파일명의 파일명(예: 강아지.png) 이다.
			
			//System.out.println("~~~ 확인용 originalFilename => " + originalFilename);
			//~~~ 확인용 originalFilename => LG_싸이킹청소기_사용설명서.pdf
			
			newFileName = fileManager.doFileUpload(bytes, originalFilename, path);
			// 첨부되어진 파일을 업로드 하는 것이다.
			
			//System.out.println("~~~ 확인용 newFileName" + newFileName);
			//~~~ 확인용 newFileName202311241135483380607484034000.pdf
			
			/*
			  boardvo 에 fileName 값과 orgFilename 값과 fileSize 값을 넣어주기
			*/
			documentvo.setFileName(newFileName);
			// WAS(톰캣)에 저장된 파일명
			
			documentvo.setOrgFilename(originalFilename);
			// 게시판 페이지에서 첨부된 파일(LG싸이킹.png)을 보여줄 때 사용.
            // 또한 사용자가 파일을 다운로드 할때 사용되어지는 파일명으로 사용.
			fileSize = attach.getSize(); // 첨부파일의 크기(단위는 byte임)
			
			documentvo.setFileSize(String.valueOf(fileSize)); 
			
		  } catch (Exception e) {
			  e.printStackTrace();
		  }
		
		}
		String ctxPath = mrequest.getContextPath();
		int n = service.updateDocument(documentvo);
			
		if(n==1) {
			
			HttpSession session = mrequest.getSession();
			String root = session.getServletContext().getRealPath("/");
			
			String path = root+"resources"+File.separator+"document";
			
			// 원래 있던 파일 삭제
			try {
				fileManager.doFileDelete(del_fileName, path);
			} catch (Exception e) {
				e.printStackTrace();
				
				  String message = "파일은 업로드 했지만 원래 있던 파일은 삭제하지 못했습니다.";
			      String loc = ctxPath+"/document.gw";
			      
			      mav.addObject("message", message);
			      mav.addObject("loc", loc);
			      
			      mav.setViewName("msg");
			      return mav;
			}
			  String message = "파일 수정을 완벽히 성공했습니다.";
		      String loc = ctxPath+"/document.gw";
		      
		      mav.addObject("message", message);
		      mav.addObject("loc", loc);
		      
		      mav.setViewName("msg");
		}
		else {
			  String message = "테이블을 수정 하지 못했습니다.";
		      String loc = ctxPath+"/document.gw";
		      
		      mav.addObject("message", message);
		      mav.addObject("loc", loc);
		      
		      mav.setViewName("msg");
		}
		
		
		return mav;
	}
	
	
	
	
	
}

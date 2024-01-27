package com.spring.app.saehan.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.spring.app.common.AES256;
import com.spring.app.common.FileManager;
import com.spring.app.domain.BoardFileVO;
import com.spring.app.domain.NoticeboardFileVO;
import com.spring.app.domain.NoticeboardVO;
import com.spring.app.saehan.model.NoticeSaehanDAO;
import com.spring.app.saehan.model.SaehanDAO;

@Repository
@Service
public class NoticeSaehanService_imple implements NoticeSaehanService{
	
    @Autowired
 	private AES256 aES256;
 	
 	@Autowired  
	private FileManager fileManager;
	
	@Autowired 
	private NoticeSaehanDAO dao;
	
	
	//공지사항의 총 게시물 건수(totalCount) 구하기 - 검색이 있을 때와 검색이 없을때 로 나뉜다.
	@Override
	public int getNoticeTotalCount(Map<String, String> paraMap) {
		int n = dao.getNoticeTotalCount(paraMap);
		return n;
	}

	// 페이징 처리한 공지사항 목록 가져오기(검색이 있든지, 검색이 없든지 모두 다 포함 한 것)  
	@Override
	public List<NoticeboardVO> noticeListSearch_withPaging(Map<String, String> paraMap) {
		List<NoticeboardVO> NoticeboardList = dao.noticeListSearch_withPaging(paraMap);
		return NoticeboardList;
	}
	
	
	// 공지사항 검색어 입력시 자동글 완성하기 
	@Override
	public List<String> notice_wordSearchShow(Map<String, String> paraMap) {
		List<String> wordList = dao.notice_wordSearchShow(paraMap);
		return wordList;
	}
	
	//첨부파일이 있는 공지사항 글쓰기
	@SuppressWarnings("unchecked")
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})
	public boolean notice_addEnd(Map<String, Object> paraMap) {
		
		boolean result = false;		
		NoticeboardVO boardvo = (NoticeboardVO)paraMap.get("boardvo");

		// 글 작성하기
		int n1 = dao.notice_add(boardvo); 
		result = (n1 == 1)? true: false;
				
		// 글 작성 실패 시 리턴
		if (!result)
			return false;
		
		// 글번호 알아오기
		String seq = dao.getNoitceBoardSeq();
		 		
		// 첨부 파일 리스트
		List<NoticeboardFileVO> fileList = (List<NoticeboardFileVO>) paraMap.get("fileList");
		
		// 첨부파일이 있다면
		if (fileList != null && fileList.size() > 0) {
			for (NoticeboardFileVO nfvo : fileList) {
				nfvo.setFk_seq(seq); // 글번호 set
			}
			
			// 첨부 파일 insert
			int n2 = dao.notice_insertFiles(fileList);
			
			result = (n2 == fileList.size())? true : false;
			
			// 첨부 파일 테이블 insert가 실패했으면 리턴
			if (!result)
				return false;
		}
		
		 return result;
	}//end of public boolean notice_addEnd(Map<String, Object> paraMap) {----------------
	
	//첨부파일이 없는 공지사항 글쓰기
	@Override
	public int nofile_notice_add(NoticeboardVO noticeboardvo) {
		int n = dao.nofile_notice_add(noticeboardvo);
		return n;
	}

	//공지사항 글을 읽었을 때 조회수가 1 늘게끔 만들기
	@Override
	public NoticeboardVO getNoticeView(Map<String, String> paraMap) {
		NoticeboardVO noticeboardvo = dao.getNoticeView(paraMap); // 공지사항 1개 조회하기
		String login_Employee_id = paraMap.get("login_Employee_id");
				
			if(login_Employee_id != null &&
				noticeboardvo != null &&
			   !login_Employee_id.equals(noticeboardvo.getFk_emp_id()) ) {
				// 글조회수 증가는 로그인을 한 상태에서 다른 사람의 글을 읽을때만 증가하도록 한다. 
				int n = dao.notice_increase_readCount(noticeboardvo.getSeq()); // 글조회수 1증가 하기 
					if(n==1) {
						noticeboardvo.setRead_Count(String.valueOf(Integer.parseInt(noticeboardvo.getRead_Count())+1) );
					}
			}
		return noticeboardvo;
	}
	
	//공지사항 첨부파일 목록 가져오기 
	@Override
	public List<NoticeboardFileVO> getView_notice_files(String seq) {
		return dao.getView_notice_files(seq);
	}
	
	//공지사항 글을 읽었을 때 조회수가 안 늘게끔 만들기
	@Override
	public NoticeboardVO getnotice_View_no_increase_readCount(Map<String, String> paraMap) {
		NoticeboardVO noticeboardvo = dao.getNoticeView(paraMap); // 글1개 조회하기
		return noticeboardvo;
	}
	
	//공지사항 첨부파일 삭제하기 
	@Override
	public int notice_del_attach(Map<String, String> paraMap) {
		int n = dao.notice_del_attach(paraMap); 
		
		
		//파일첨부가 된 글이라면 글 삭제시 먼저 첨부파일을 삭제해주어야 한다. 시작  //
		if(n==1) {
			String path = paraMap.get("path");
			String fileName = paraMap.get("fileName");
			
			if(fileName != null && !"".equals(fileName) ) {
				try {
					fileManager.doFileDelete(fileName, path);
				}catch(Exception e) {
					e.printStackTrace();
				}
			}
		}
		// === 파일첨부가 된 글이라면 글 삭제시 먼저 첨부파일을 삭제해주어야 한다. 끝  === // 
		
		return n;
	}//end of public int notice_del_attach(Map<String, String> paraMap) {----------------
	
	// 공지사항 1개를 삭제하기
	@Override
	public int notice_del(Map<String, String> paraMap) {
			
		int n = dao.notice_del(paraMap);
			
		//파일첨부가 된 글이라면 글 삭제시 먼저 첨부파일을 삭제해주어야 한다. 시작  //
		if(n==1) {
			String path = paraMap.get("path");
			String file_Name = paraMap.get("file_Name");
				
			if(file_Name != null && !"".equals(file_Name) ) {
				try {
					fileManager.doFileDelete(file_Name, path);
				}catch(Exception e) {
					e.printStackTrace();
				}
			}
		}
		// === 파일첨부가 된 글이라면 글 삭제시 먼저 첨부파일을 삭제해주어야 한다. 끝  === // 		
		return n;
	}
	
	
	

	//공지사항 글 삭제하기
	@Override
	public int notice_nofile_del(Map<String, String> paraMap) {
		int n = dao.notice_nofile_del(paraMap);
		return n;
	}

	//공지사항에 있는 첨부파일 하나 불러오기
	@Override
	public NoticeboardFileVO getNotice_Each_view_files(String fileno) {
		return dao.getNotice_Each_view_files(fileno);
	}

	
	//공지사항 게시판 글 수정하기
	@SuppressWarnings("unchecked")
	@Override
	public boolean notice_board_edit(Map<String, Object> paraMap) {
		int n = 0;
		boolean result = false;
		
		NoticeboardVO noticeboardvo = (NoticeboardVO)paraMap.get("boardvo");
		
		// 글 수정하기
		n = dao.Noticeboard_edit(noticeboardvo);
		
		result = (n == 1)? true: false;
		
		// 글 작성 실패 시 리턴
		if (!result)
			return false;
		
		// 첨부 파일 리스트
		List<NoticeboardFileVO> fileList = (List<NoticeboardFileVO>) paraMap.get("fileList");
		
		// 첨부파일이 있다면
		if (fileList != null && fileList.size() > 0) {
			for (NoticeboardFileVO nvo : fileList) {
				nvo.setFk_seq(noticeboardvo.getSeq()); // 글번호 set
			}
			
			// 첨부 파일 update
			n = dao.notice_insertFiles(fileList);
			result = (n == fileList.size())? true : false;
			
			// 첨부 파일 테이블 update가 실패했으면 리턴
			if (!result)
				return result;
		}
		
		 return result;
	 }


	//공지사항 첨부파일 삭제하기
	@Override
	public boolean notice_delete_file(String fileno, String path) {
		// 파일번호로 파일 정보 조회
		NoticeboardFileVO nvo = dao.getNotice_Each_view_files(fileno);
		
		// 테이블에서 파일 삭제
		int n = dao.notice_delete_file(fileno);
		
		if (n==1) {
			// 서버에서 파일 삭제
			try {
				fileManager.doFileDelete(nvo.getFileName(), path);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		return (n==1)? true: false;
	}
		
	// 공지사항 첨부 파일 유무 검정
	@Override
	public String noticeboard_update_attachfile(String fk_seq) {
		String attachfile = dao.noticeboard_update_attachfile(fk_seq);
		return attachfile;
	}
	

	//공지사항 글 파일유무를 0으로 만들기
	@Override
	public int getnoticeboard_filename_clear(Map<String, String> paraMap) {
		int n = dao.getnoticeboard_filename_clear(paraMap);
		return n;
	}

	//공지사항 글 파일유무를 1로 만들기
	@Override
	public int getnoticeboard_filename_add(Map<String, String> paraMap) {
		int n = dao.getnoticeboard_filename_add(paraMap);
		return n;
	}

}

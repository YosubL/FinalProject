package com.spring.app.saehan.service;

import java.util.List;
import java.util.Map;

import com.spring.app.domain.NoticeboardFileVO;
import com.spring.app.domain.NoticeboardVO;

public interface NoticeSaehanService {
	
	///공지사항/////
	
	//공지사항의 총 게시물 수 가져오기
	int getNoticeTotalCount(Map<String, String> paraMap);

	// 페이징 처리한 공지사항 가져오기(검색이 있든지, 검색이 없든지 모두 다 포함 한 것) 
	List<NoticeboardVO> noticeListSearch_withPaging(Map<String, String> paraMap);
	
	//공지사항 검색어 입력시 자동글 완성하기 
	List<String> notice_wordSearchShow(Map<String, String> paraMap);
	
	//공지사항 글쓰기(파일첨부가 있는 공지사항 글쓰기) 
	boolean notice_addEnd(Map<String, Object> paraMap);
	
	//공지사항 글쓰기(파일첨부가 없는 공지사항 글쓰기) 
	int nofile_notice_add(NoticeboardVO boardvo);
	
	//공지사항 조회수 증가와 함께 공지사항 1개를 조회를 해주는 것 
	NoticeboardVO getNoticeView(Map<String, String> paraMap);
	
	//공지사항 첨부파일 목록 가져오기 
	List<NoticeboardFileVO> getView_notice_files(String seq);
	
	//공지사항 조회수 증가 없이 공지사항 1개를 조회를 해주는 것 
	NoticeboardVO getnotice_View_no_increase_readCount(Map<String, String> paraMap);

	//공지사항 첨부파일 삭제하기
	int notice_del_attach(Map<String, String> paraMap);
	
	//공지사항 글 1개 삭제하기
	int notice_del(Map<String, String> paraMap);

	//공지사항 글인데 첨부파일 없는거 삭제하기
	int notice_nofile_del(Map<String, String> paraMap);

	//공지사항에서 파일 하나만 가져오기
	NoticeboardFileVO getNotice_Each_view_files(String fileno);

	//공지사항 수정하기
	boolean notice_board_edit(Map<String, Object> paraMap);

	//공지사항 수정에서 각각의 첨부파일 삭제하기
	boolean notice_delete_file(String fileno, String path);
	
	// 공지사항 파일 유무 검정
	String noticeboard_update_attachfile(String fk_seq);

	//공지사항 글 파일유무를 0으로 만들기
	int getnoticeboard_filename_clear(Map<String, String> paraMap);

	//공지사항 글 파일유무를 1로 만들기
	int getnoticeboard_filename_add(Map<String, String> paraMap);

}

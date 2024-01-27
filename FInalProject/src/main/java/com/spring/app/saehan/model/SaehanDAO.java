package com.spring.app.saehan.model;

import java.util.List;
import java.util.Map;

import org.springframework.web.servlet.ModelAndView;

import com.spring.app.domain.CommentVO;
import com.spring.app.domain.EmployeesVO;
import com.spring.app.domain.FreeBoard_likesVO;
import com.spring.app.domain.BoardFileVO;
import com.spring.app.domain.BoardVO;

public interface SaehanDAO {

	// 총 게시물 건수(totalCount) 구하기 - 검색이 있을 때와 검색이 없을때 로 나뉜다.
	int getTotalCount(Map<String, String> paraMap);

	// 페이징 처리한 글목록 가져오기(검색이 있든지, 검색이 없든지 모두 다 포함 한 것)  
	List<BoardVO> boardListSearch_withPaging(Map<String, String> paraMap);

	// 검색어 입력시 자동글 완성하기
	List<String> wordSearchShow(Map<String, String> paraMap);

	//답글쓰기에 필요한 값 가져오기
	int getGroupnoMax();
	
	// 글쓰기(파일첨부가 없는 글쓰기)
	int add_nofile(BoardVO boardvo);
	
	// 글쓰기(파일첨부가 있는 글쓰기)
	int addEnd(BoardVO boardvo);
	
	//글 조회수 증가는 없고 단순히 글 1개만 조회를 해주는 것
	BoardVO getView(Map<String, String> paraMap);
	
	//글의 조회수 1 증가 하기 
	int increase_readCount(String seq);
	
	// 1개글 삭제하기 
	int del(Map<String, String> paraMap);
	
	// 원글 글번호(parentSeq)에 해당하는 댓글의 totalPage 수 알아오기
	int getCommentTotalPage(Map<String, String> paraMap);

	// 원게시물에 딸린 댓글들을 페이징 처리해서 조회해오기
	List<CommentVO> getCommentList_Paging(Map<String, String> paraMap);

	// 댓글쓰기(transaction 처리)
	int addComment(CommentVO commentvo);

	// 댓글을 쓰면 tbl_freeboard 테이블에 commentCount 컬럼이 1증가(update)
	int updateCommentCount(String parentSeq);
	
	// 파일첨부가 되어진 댓글 1개에서 서버에 업로드되어진 파일명과 오리지널파일명을 조회해주는 것  
	CommentVO selectOne(String string, String seq);

	//원게시물에 딸린 댓글들을 조회해오기
	List<CommentVO> getCommentList(String parentSeq);

	//원래 적혀있던 댓글 내용 불러오기
	CommentVO getComment_One(Map<String, String> paraMap);
	
	//파일첨부가 되어진 댓글 1개에서 서버에 업로드되어진 파일명과 오리지널파일명을 조회해주는 것  
	CommentVO getView_comment(Map<String, String> paraMap);

	//댓글을 수정하기 
	int getupdate_review(String string, Map<String, String> paraMap);
	
	//첨부파일이 있는 댓글삭제 하기
	int del_comment(Map<String, String> paraMap);

	//첨부파일이 없는 댓글삭제 하기
	int del_comment_nofile(Map<String, String> paraMap);

	// tbl_freeboard 테이블에 commentCount 컬럼이 1 감소(update) 
	int minusCommentCount(String parentSeq);
	
	//파일의 글번호 알아오기
	String getfreeBoardSeq();
	
	//자유게시판 파일 첨부하기
	int insertFiles(List<BoardFileVO> fileList);

	//파일 조회하기
	List<BoardFileVO> getView_files(String seq);

	//자유게시판 파일 하나 가져오기
	BoardFileVO getEach_view_files(String fileno);
	
	//자유게시판 첨부파일 삭제하기
	int del_attach(Map<String, String> paraMap);
	
	// 자유게시판 글 수정하기
	int freeboard_edit(BoardVO boardvo);
	
	//자유게시판 수정에서 파일 삭제하기
	int deleteFile(String fileno);

	//파일 삭제하면 글테이블의 filename 유무 0으로 만들기  (1은 파일 존재 , 0은 파일존재 하지 않음)
	int getfreeboard_filename_clear(Map<String, String> paraMap);

	//파일 삭제하면 글테이블의 filename 유무 1으로 만들기  (1은 파일 존재 , 0은 파일존재 하지 않음)
	int getfreeboard_filename_add(Map<String, String> paraMap);

	// 자유게시판 첨부 파일 유무 확인 
	String freeboard_update_attachfile(String fk_seq);


	//자유게시판 좋아요 더하기
	int getlike_add(FreeBoard_likesVO freeBoard_likesvo);
	
	//좋아요한 유저 검색하기 
	List<FreeBoard_likesVO> getView_likes(String seq);
	
	//좋아요한 갯수 가져오기
	int getliketotalCount(String seq);

	//자유게시판 글 삭제하면서 좋아요 전부 취소하기
	int del_likes(Map<String, String> paraMap);

	//자유게시판 좋아요한 유저의 좋아요 취소하기
	int getlike_del(String fk_email);

	


	
	
}

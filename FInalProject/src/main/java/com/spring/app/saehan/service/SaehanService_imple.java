package com.spring.app.saehan.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.spring.app.domain.CommentVO;
import com.spring.app.domain.FreeBoard_likesVO;
import com.spring.app.common.AES256;
import com.spring.app.common.FileManager;
import com.spring.app.domain.BoardFileVO;
import com.spring.app.domain.BoardVO;
import com.spring.app.saehan.model.SaehanDAO;


@Repository
@Service
public class SaehanService_imple implements SaehanService{

	
    @Autowired
 	private AES256 aES256;
 	
 	@Autowired  
	private FileManager fileManager;
	
	@Autowired 
	private SaehanDAO dao;
	
 
	// 총 게시물 건수(totalCount) 구하기 - 검색이 있을 때와 검색이 없을때 로 나뉜다.
	@Override
	public int getTotalCount(Map<String, String> paraMap) {
		int n = dao.getTotalCount(paraMap);
		return n;
	}

	// 페이징 처리한 글목록 가져오기(검색이 있든지, 검색이 없든지 모두 다 포함 한 것)  
	@Override
	public List<BoardVO> boardListSearch_withPaging(Map<String, String> paraMap) {
		List<BoardVO> boardList = dao.boardListSearch_withPaging(paraMap);
		
		return boardList;
	}

	// 검색어 입력시 자동글 완성하기 
	@Override
	public List<String> wordSearchShow(Map<String, String> paraMap) {
		List<String> wordList = dao.wordSearchShow(paraMap);
		return wordList;
	}
	
	//자유게시판 글쓰기(파일첨부가 없는 글쓰기) 
	@Override
	public int add_nofile(BoardVO boardvo) {
	// === 원글쓰기인지, 답변글쓰기인지 구분하기 시작 === //
		if("".equals(boardvo.getFk_seq())) {
			// 원글쓰기인 경우
			int groupno = dao.getGroupnoMax()+1;
			boardvo.setGroupno(String.valueOf(groupno));
		}	
	// === 원글쓰기인지, 답변글쓰기인지 구분하기 끝 === //
		int n = dao.add_nofile(boardvo);
		return n;
	}
	
	//자유게시판 글 쓰기  (파일첨부가 있는 글쓰기)
	@SuppressWarnings("unchecked")
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})
	public boolean addEnd(Map<String, Object> paraMap){
		
		boolean result = false;		
		BoardVO boardvo = (BoardVO)paraMap.get("boardvo");
		
		if("".equals(boardvo.getFk_seq())) {
			// 원글쓰기인경우
			// groupno 컬럼의 값은 groupno 컬럼의 최대값(max)+1 로 해야한다.
			int groupno = dao.getGroupnoMax() + 1;
			
			boardvo.setGroupno(String.valueOf(groupno));
		}
		
		// 글 작성하기
		int n1 = dao.addEnd(boardvo);
		
		result = (n1 == 1)? true: false;
				
		// 글 작성 실패 시 리턴
		if (!result)
			return false;
		
		// 글번호 알아오기
		String seq = dao.getfreeBoardSeq();
		 		
		// 첨부 파일 리스트
		List<BoardFileVO> fileList = (List<BoardFileVO>) paraMap.get("fileList");
		
		// 첨부파일이 있다면
		if (fileList != null && fileList.size() > 0) {
			for (BoardFileVO nfvo : fileList) {
				nfvo.setFk_seq(seq); // 글번호 set
			}
			
			// 첨부 파일 insert
			int n2 = dao.insertFiles(fileList);
			
			result = (n2 == fileList.size())? true : false;
			
			// 첨부 파일 테이블 insert가 실패했으면 리턴
			if (!result)
				return false;
		}
		
		 return result;
	}//end of public boolean addEnd(Map<String, Object> paraMap){------------------
	
	
	
	
	// 글조회수 증가는 없고 단순히 글1개만 조회를 해주는 것
	@Override
	public BoardVO getView_no_increase_readCount(Map<String, String> paraMap) {
		BoardVO boardvo = dao.getView(paraMap); // 글1개 조회하기
		return boardvo;
	}
	
	//글조회수 증가와 함께 글1개를 조회를 해주는 것 
	//(먼저, 로그인을 한 상태에서 다른 사람의 글을 조회할 경우에는 글조회수 컬럼의 값을 1증가 해야 한다.)
	@Override
	public BoardVO getView(Map<String, String> paraMap) {				
		BoardVO boardvo = dao.getView(paraMap); // 글1개 조회하기
		String login_email = paraMap.get("login_email");
				
			if(login_email != null &&
			   boardvo != null &&
			   !login_email.equals(boardvo.getFk_email()) ) {
				// 글조회수 증가는 로그인을 한 상태에서 다른 사람의 글을 읽을때만 증가하도록 한다. 
				int n = dao.increase_readCount(boardvo.getSeq()); // 글조회수 1증가 하기 
					if(n==1) {
						boardvo.setReadCount(String.valueOf(Integer.parseInt(boardvo.getReadCount())+1) );
					}
			}
		return boardvo;
	}
	
	// 첨부파일 목록 조회(글 상세 조회)
	@Override
	public List<BoardFileVO> getView_files(String seq) {
		return dao.getView_files(seq);
	}
	
	// 자유게시판 글 수정하기
	@SuppressWarnings("unchecked")
	@Override
	public boolean freeboard_edit(Map<String, Object> paraMap) {
		int n = 0;
		boolean result = false;
		
		BoardVO boardvo= (BoardVO)paraMap.get("boardvo");
		
		// 글 수정하기
		n = dao.freeboard_edit(boardvo);
		
		result = (n == 1)? true: false;
		
		// 글 작성 실패 시 리턴
		if (!result)
			return false;
		
		// 첨부 파일 리스트
		List<BoardFileVO> fileList = (List<BoardFileVO>) paraMap.get("fileList");
		
		// 첨부파일이 있다면
		if (fileList != null && fileList.size() > 0) {
			for (BoardFileVO nvo : fileList) {
				nvo.setFk_seq(boardvo.getSeq()); // 글번호 set
			}
			
			// 첨부 파일 update
			n = dao.insertFiles(fileList);
			result = (n == fileList.size())? true : false;
			
			// 첨부 파일 테이블 update가 실패했으면 리턴
			if (!result)
				return result;
		}
		
		 return result;
	}//end of public boolean freeboard_edit(Map<String, Object> paraMap) {--------------
	

	//자유게시판 첨부파일 유무
	@Override
	public String freeboard_update_attachfile(String fk_seq) {
		String attachfile = dao.freeboard_update_attachfile(fk_seq);
		return attachfile;
	}
	
	//자유게시판 첨부파일을 하나 가져와서 수정에서 삭제	
		@Override
		public boolean deleteFile(String fileno, String path) {
			// 파일번호로 파일 정보 조회
			BoardFileVO nvo = dao.getEach_view_files(fileno);
			
			// 테이블에서 파일 삭제
			int n = dao.deleteFile(fileno);
			
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
	//파일 삭제하면 글테이블의 filename 유무 0으로 만들기  (1은 파일 존재 , 0은 파일존재 하지 않음)
	@Override
	public int getfreeboard_filename_clear(Map<String, String> paraMap) {
		int n = dao.getfreeboard_filename_clear(paraMap);
		return n;
	}

	//파일 삭제하면 글테이블의 filename 유무 1로 만들기  (1은 파일 존재 , 0은 파일존재 하지 않음)
	@Override
	public int getfreeboard_filename_add(Map<String, String> paraMap) {
		int n = dao.getfreeboard_filename_add(paraMap);
		return n;
	}
	
	//자유게시판 글에 있는 첨부파일 모두 삭제해주기
	@Override
	public int del_attach(Map<String, String> paraMap) {
		int n = dao.del_attach(paraMap); 
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
	}
	
	// 글 1개를 삭제하기
	@Override
	public int del(Map<String, String> paraMap) {
		int n = dao.del(paraMap);
		return n;
	}
	
	//하나의 파일이름을 불러오기
	@Override
	public BoardFileVO getEach_view_files(String fileno) {
		return dao.getEach_view_files(fileno);
	}
	
	//원게시물에 딸린 댓글들을 조회해오기
	@Override
	public List<CommentVO> getCommentList(String parentSeq) {
		List<CommentVO> commentList = dao.getCommentList(parentSeq);
		return commentList;
	}
	
	// 댓글쓰기(transaction 처리)
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})
	public int addComment(CommentVO commentvo) {
		int n1=0,n2=0;
		n1 = dao.addComment(commentvo); // 댓글쓰기(tbl_comment 테이블에 insert)
			
		if(n1 == 1) { 
			n2 = dao.updateCommentCount(commentvo.getParentSeq()); // tbl_board 테이블에 commentCount 컬럼이 1증가(update) 
		}
		return n2;
	}
	
	// 파일첨부가 되어진 댓글 1개에서 서버에 업로드되어진 파일명과 오리지널파일명을 조회해주는 것  
	@Override
	public CommentVO getCommentOne(String seq) {
		CommentVO commentvo = dao.selectOne("saehan.getCommentOne", seq);
		return commentvo;
	}
	
	// 댓글 수정하기
	@Override
	public int getupdate_review(Map<String, String> paraMap, CommentVO commentvo) {
		int n = dao.getupdate_review("saehan.getupdate_review", paraMap);
		return n;
	}
	
	//댓글 파일이름 조회하기
	@Override
	public CommentVO getView_comment(Map<String, String> paraMap) {
		CommentVO commentvo = dao.getView_comment(paraMap); 
		return commentvo;
	}
	
	//첨부 파일 없는 댓글 삭제하기
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})
	public int del_comment_nofile(Map<String, String> paraMap, CommentVO commentvo) {
		int n1=0,n2=0;
			
		n1 = dao.del_comment_nofile(paraMap); // 댓글쓰기(tbl_free_comment 테이블에 insert)
			
		if(n1 == 1) { 
			n2 = dao.minusCommentCount(commentvo.getParentSeq()); // tbl_freeboard 테이블에 commentCount 컬럼이 1증가(update) 
		}
		return n2;
	}
	
	
	//첨부 파일있는 댓글 삭제하기
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})
	public int del_comment(Map<String, String> paraMap, CommentVO commentvo) {
		int n1=0 , n2=0;
		n1 = dao.del_comment(paraMap);
			
		// ===== 파일첨부가 된 글이라면 글 삭제시 먼저 첨부파일을 삭제해주어야 한다. 시작  ===== //
		if(n1==1) {
			String path = paraMap.get("path");
			String fileName = paraMap.get("fileName");
			n2 = dao.minusCommentCount(commentvo.getParentSeq());
			if( fileName != null && !"".equals(fileName) ) {
				try {
					fileManager.doFileDelete(fileName, path);
				}catch(Exception e) {
					e.printStackTrace();
				}
			}
		}
		// === 파일첨부가 된 글이라면 글 삭제시 먼저 첨부파일을 삭제해주어야 한다. 끝  === // 	
		return n2;
	}
	

	// 원게시물에 딸린 댓글들을 페이징 처리해서 조회해오기
	@Override
	public List<CommentVO> getCommentList_Paging(Map<String, String> paraMap) {
		List<CommentVO> commentList = dao.getCommentList_Paging(paraMap);
		return commentList;
	}
	
	 // 원글 글번호(parentSeq)에 해당하는 댓글의 totalPage 수 알아오기
	@Override
	public int getCommentTotalPage(Map<String, String> paraMap) {
		int totalPage = dao.getCommentTotalPage(paraMap);
		return totalPage;
	}
	
	//원래 적혀있던 댓글 내용 불러오기
	@Override
	public CommentVO getComment_One(Map<String, String> paraMap) {
		CommentVO commentvo = dao.getComment_One(paraMap); 
		return commentvo;
	}
	
	//자유게시판 좋아요 더하기
	@Override
	public int getlike_add(FreeBoard_likesVO freeBoard_likesvo) {
		int n = dao.getlike_add(freeBoard_likesvo);
		return n;
	}
	
	//좋아요한 유저 검색하기 
	@Override
	public List<FreeBoard_likesVO> getView_likes(String seq) {
		return dao.getView_likes(seq);
	}
	
	//게시물에 있는 좋아요 갯수 구하기
	@Override
	public int getliketotalCount(String seq) {
		int n = dao.getliketotalCount(seq);
		return n;
	}

	//자유게시판 글 삭제하면서 좋아요 전부 취소하기
	@Override
	public int del_likes(Map<String, String> paraMap) {
		int n = dao.del_likes(paraMap);
		return n;
	}
	
	//좋아요한 유저의 좋아요 취소하기 
	@Override
	public int getlike_del(String fk_email) {
		int n = dao.getlike_del(fk_email);
		return n;
	}



}
	



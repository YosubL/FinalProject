package com.spring.app.saehan.model;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.spring.app.domain.NoticeboardFileVO;
import com.spring.app.domain.NoticeboardVO;

@Repository
public class NoticeSaehanDAO_imple implements NoticeSaehanDAO{
	
	@Resource
	private SqlSessionTemplate sqlsession;
	
	//공지사항의 총 게시물 건수(totalCount) 구하기 - 검색이 있을 때와 검색이 없을때 로 나뉜다.
	@Override
	public int getNoticeTotalCount(Map<String, String> paraMap) {
		int n = sqlsession.selectOne("saehan.getNoticeTotalCount", paraMap);
		return n;
	}

	
	//페이징 처리한 공지사항 목록 가져오기(검색이 있든지, 검색이 없든지 모두 다 포함 한 것)  
	@Override
	public List<NoticeboardVO> noticeListSearch_withPaging(Map<String, String> paraMap) {
		List<NoticeboardVO> NoticeboardList = sqlsession.selectList("saehan.noticeListSearch_withPaging", paraMap);
		return NoticeboardList;
	}
	
	//공지사항 검색어 입력시 자동글 완성하기 
	@Override
	public List<String> notice_wordSearchShow(Map<String, String> paraMap) {
		List<String> wordList = sqlsession.selectList("saehan.notice_wordSearchShow", paraMap);
		return wordList;
	}
	

	//첨부파일 있는 공지사항 쓰기
	@Override
	public int notice_add(NoticeboardVO noticeboardvo) {
		int n = sqlsession.insert("saehan.notice_add", noticeboardvo);
		return n;
	}
	
    //공지사항 글 1개 조회하기 
	@Override
	public NoticeboardVO getNoticeView(Map<String, String> paraMap) {
		NoticeboardVO noticeboardvo = sqlsession.selectOne("saehan.getNotice_View", paraMap);
		return noticeboardvo;
	}

	//공지사항 글 조회수 1 증가하기
	@Override
	public int notice_increase_readCount(String seq) {
		int n = sqlsession.update("saehan.notice_increase_readCount", seq);
  		return n;
	}

	//공지사항 글 1개 삭제하기
	@Override
	public int notice_del(Map<String, String> paraMap) {
		int n = sqlsession.delete("saehan.notice_del", paraMap);
		return n;
	}

	//공지사항에 있는 첨부파일 삭제하기
	@Override
	public int notice_delete_file(String fileno) {
		int n = sqlsession.delete("saehan.notice_delete_file", fileno);
		return n;
	}


	// 공지사항 글번호 알아오기
	@Override
	public String getNoitceBoardSeq() {
		String seq = sqlsession.selectOne("saehan.getNoitceboardSeq");
		return seq;
	}
	
	
	//공지사항 첨부파일 추가하기
	@Override
	public int notice_insertFiles(List<NoticeboardFileVO> fileList) {
		int n = sqlsession.insert("saehan.notice_insertFiles", fileList);
		return n;
	}

		
	//공지사항 첨부파일 없는 거 글 쓰기
	@Override
	public int nofile_notice_add(NoticeboardVO noticeboardvo) {
		int n = sqlsession.insert("saehan.notice_add_noFile", noticeboardvo);
		return n;
	}

	
	//공지사항 첨부파일 목록 조회하기
	@Override
	public List<NoticeboardFileVO> getView_notice_files(String seq) {
		return sqlsession.selectList("saehan.getView_notice_files", seq);
	}

	//공지사항 첨부파일 삭제하기
	@Override
	public int notice_del_attach(Map<String, String> paraMap) {
		int n = sqlsession.delete("saehan.notice_del_attach", paraMap);
		return n;
	}

	//공지사항 글인데 첨부파일 없는거 삭제하기
	@Override
	public int notice_nofile_del(Map<String, String> paraMap) {
		int n = sqlsession.delete("saehan.notice_nofile_del", paraMap);
		return n;
	}

	//파일번호 공지사항에서 첨부파일 하나만 가져오기
	@Override
	public NoticeboardFileVO getNotice_Each_view_files(String fileno) {
		return sqlsession.selectOne("saehan.getNotice_Each_view_files", fileno);
	}
	
	
	//공지사항 글 수정하기
	@Override
	public int Noticeboard_edit(NoticeboardVO noticeboardvo) {
		return sqlsession.update("saehan.noticeboard_edit", noticeboardvo);
	}

	
	// 공지사항 파일 유무 검정
	@Override
	public String noticeboard_update_attachfile(String fk_seq) {
		String attachfile = sqlsession.selectOne("saehan.noticeboard_update_attachfile", fk_seq);
		return attachfile;
	}

	//공지사항 글 파일유무를 0으로 만들기
	@Override
	public int getnoticeboard_filename_clear(Map<String, String> paraMap) {
		int n = sqlsession.update("saehan.noticeboard_filename_clear", paraMap);
		return n;
	}

	//공지사항 글 파일유무를 1로 만들기
	@Override
	public int getnoticeboard_filename_add(Map<String, String> paraMap) {
		int n = sqlsession.update("saehan.noticeboard_filename_add", paraMap);
		return n;
	}
	
}

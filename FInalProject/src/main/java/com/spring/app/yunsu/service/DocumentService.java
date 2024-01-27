package com.spring.app.yunsu.service;

import java.util.List;
import java.util.Map;

import com.spring.app.domain.DocumentVO;

public interface DocumentService {
	
	// 회원 정보가져오기
	Map<String, String> documentDown(String employee_id);
	
	//문서 다운 기록 남기기
	int documentInsert(Map<String, String> paraMap);
	
	// 문서 테이블에 문서 정보 넣기
	int insertDocument(DocumentVO documentvo);
	
	
	//삭제할 문서 서버  파일이름 가져오기
	String deleteDocumentSelect(String seq);
	
	// 문서 삭제 하기
	int deleteDocument(Map<String, String> paraMap) throws Throwable;
	
	//다운받을 문서 조회하기
	DocumentVO viewDocument(Map<String, String> paraMap);
	
	// 다운기록 넣기
	int insertDownLoadrecord(Map<String, String> paraMap);
	
	//수정을 위해 삭제할 파일명 가져오기
	String selectUpdateDeleteFile(DocumentVO documentvo);
	
	// 문서 업데이트
	int updateDocument(DocumentVO documentvo);
	
	// 문서 갯수 가져오기
	int getDocuSearchCnt(Map<String, Object> paraMap);
	
	// 문서 페이지 내역 가져오기
	List<Map<String, String>> getDocumentList(Map<String, Object> paraMap);
	
	
	
	
	
	
	

}

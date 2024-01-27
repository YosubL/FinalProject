package com.spring.app.yunsu.model;


import java.util.List;
import java.util.Map;

import com.spring.app.domain.DocumentVO;

public interface DocumentDAO {
	
	// 회원정보 가져오기
	Map<String, String> documentDown(String employee_id);
	
	//문서 다운로드 정보 넣기
	int documentInsert(Map<String, String> paraMap);
	
	//문서 정보 넣기
	int insertDocument(DocumentVO documentvo);
	
	
	
	// 삭제할 파일 이름 가져오기
	String deleteDocumentSelect(String seq);
	
	// 문서 삭제하기
	int deleteDocument(Map<String, String> paraMap);
	
	// 다운 받을 문서 조회하기
	DocumentVO viewDocument(Map<String, String> paraMap);
	
	// 다운 기록 넣기
	int insertDownLoadrecord(Map<String, String> paraMap);
	
	//수정을 위해 삭제할 파일명 가져오기
	String selectUpdateDeleteFile(DocumentVO documentvo);
	
	//문서 테이블 업로드
	int updateDocument(DocumentVO documentvo);
	
	//문서 갯수 가져오기
	int getDocuSearchCnt(Map<String, Object> paraMap);
	
	//문서 내역 가져오기
	List<Map<String, String>> getDocumentList(Map<String, Object> paraMap);
	
	

}

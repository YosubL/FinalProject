package com.spring.app.yunsu.service;


import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.spring.app.common.FileManager;
import com.spring.app.domain.DocumentVO;
import com.spring.app.yunsu.model.DocumentDAO;


@Service
public class DocumentService_imple implements DocumentService {
	
	@Autowired
	private DocumentDAO dao;
	@Autowired
	private FileManager fileManager;
	
	// 회원정보 가져오기
	@Override
	public Map<String, String> documentDown(String employee_id) {
		Map<String, String> paraMap = dao.documentDown(employee_id);
		return paraMap;
	}
	
	// 문서 다운로드 정보 넣기
	@Override
	public int documentInsert(Map<String, String> paraMap) {
		int n = dao.documentInsert(paraMap);
		return n;
	}
	
	// 문서 정보 넣기
	@Override
	public int insertDocument(DocumentVO documentvo) {
		int n = dao.insertDocument(documentvo);
		return n;
	}
	
	
	// 삭제할 문서 파일 이름 가져오기
	@Override
	public String deleteDocumentSelect(String seq) {
		String fileName = dao.deleteDocumentSelect(seq);
		return fileName;
	}
	
	//문서 삭제하기 트랜잭션
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})
	public int deleteDocument(Map<String, String> paraMap) throws Throwable  {
		int n1=0;
		int n2=0;
		
		n1 = dao.deleteDocument(paraMap);
		
		String path = paraMap.get("path");
		String fileName = paraMap.get("fileName");
		
		n2 = fileManager.doFileDeleteYS(fileName, path);

		return n1*n2;
	}
	
	// 다운받을 문서 조회하기
	@Override
	public DocumentVO viewDocument(Map<String, String> paraMap) {
		DocumentVO documentvo = dao.viewDocument(paraMap);
		return documentvo;
	}
	
	// 다운 기록 넣기
	@Override
	public int insertDownLoadrecord(Map<String, String> paraMap) {
		int n = dao.insertDownLoadrecord(paraMap);
		return n;
	}
	
	//수정을 위해 삭제할 파일명 가져오기
	@Override
	public String selectUpdateDeleteFile(DocumentVO documentvo) {
		String fileName = dao.selectUpdateDeleteFile(documentvo);
		return fileName;
	}
	
	// 문서 테이블 업로드 하기
	@Override
	public int updateDocument(DocumentVO documentvo) {
		
		int n = dao.updateDocument(documentvo);
		
		return n;
		
	}
	
	//문서 갯수 가져오기
	@Override
	public int getDocuSearchCnt(Map<String, Object> paraMap) {
		int n = dao.getDocuSearchCnt(paraMap);
		return n;
	}
	
	// 문서 페이지 내역 가져오기
	@Override
	public List<Map<String, String>> getDocumentList(Map<String, Object> paraMap) {
		List<Map<String, String>> documentList = dao.getDocumentList(paraMap);
		return documentList;
	}
	
	

	
	
	
}

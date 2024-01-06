package com.spring.app.digitalmail.model;

import java.util.List;
import java.util.Map;

import com.spring.app.digitalmail.domain.EmailVO;


public interface DigitalmailDAO {
	
	// 내가 받은 총 메일 갯수
	int getTotalCount(Map<String, String> paraMap);
	// 페이징 처리된 내가 받은 총 메일 보기
	List<EmailVO> SelectMyEmail_withPaging(Map<String, String> paraMap);
	// 이메일 키워드 입력시 자동글 완성하기 //
	List<String> emailWordSearchShow(Map<String, String> paraMap);
	// 메일 쓰기 뷰단에서 이메일 자동 완성하기
	List<String> getEmailList();

}
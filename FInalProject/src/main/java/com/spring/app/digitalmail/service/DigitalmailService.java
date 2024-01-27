package com.spring.app.digitalmail.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.servlet.ModelAndView;

import com.spring.app.digitalmail.domain.EmailVO;

public interface DigitalmailService {
	
	// 내가 받은 총 메일 갯수
	int getTotalCount(Map<String, String> paraMap);
	// 전자메일 뷰단
	ModelAndView digitalmail(ModelAndView mav, Map<String, String> paraMap);
	// 이메일 키워드 입력시 자동글 완성하기 //
	List<String> emailWordSearchShow(Map<String, String> paraMap);
	// === 이메일 쓰기 페이지 이동  === //
	ModelAndView digitalmailwrite(ModelAndView mav);
	// 파일 업로드 완료 후 메일 쓰기
	int emailsucadd(Map<String, Object> paraMap);
	// 이메일 임시저장
	int emailaddstop(Map<String, Object> paraMap);
	// 이메일 한개 보는 페이지
	ModelAndView digitalmailview(ModelAndView mav, Map<String, String> paraMap);
	// 비밀번호가 있을경우 알아오기
	String getEmailPwd(String send_email_seq);
	// 이메일 번호 체번
	EmailVO SelectEmail(Map<String, String> paraMap);
	
	// 임시저장된 리스트 갯수 채번
	int addstopCount(Map<String, String> paraMap);
	// 임시메일 뷰단
	ModelAndView addstopView(ModelAndView mav, Map<String, String> paraMap);
	
	// 임시메일 쓰기
	ModelAndView digitalmailstopwrite(ModelAndView mav, Map<String, String> paraMap);
	
	// 임시메일 업데이트
	int emailaddupdate(Map<String, Object> paraMap);
	
	// receipt_favorites update하기
	int receipt_favorites_update(Map<String, String> paraMap);

	// receipt_favorites 값 가져오기
	String select_receipt_favorites(String receipt_mail_seq);
	
	// email_receipt_read_count update 하기
	int email_receipt_read_count_update(String receipt_mail_seq);

	// email_receipt_read_count 값 가져오기
	String select_email_receipt_read_count(String receipt_mail_seq);

	// receipt_important 값 가져오기
	String select_receipt_important(String receipt_mail_seq);

	// receipt_important update 하기
	int receipt_important_update(Map<String, String> paraMap);
	
	// 답장하기 이메일 가져오기
	Map<String, String> getsenderEmail(String sender , String send_email_seq);
	// 이메일 삭제하기
	int email_del(Map<String, Object> receipt_mailMap);
	int emailstop_del(Map<String, Object> receipt_mailMap);
	
	// 이메일 읽음 안읽음 처리
	int total_email_receipt_read_count_update(Map<String, Object> receipt_mailMap);
	// 이메일 한개 지우기
	int onedel(String receipt_mail_seq);
	// 좋아요 설정
	String select_send_favorites(String receipt_mail_seq);
	// 보낸사람 즐겨찾기
	int send_favorites_update(Map<String, String> paraMap);
	// 보낸사람 중요도
	String select_send_important(String receipt_mail_seq);
	
	int send_important_update(Map<String, String> paraMap);
	
	int onesenddel(String receipt_mail_seq);
	
	int timedel(String send_email_seq);
	
	int timedelete(String send_email_seq);
	
	int HaveFiletimedelete(String send_email_seq, Map<String, String> paraMap);
	
	void Alarmdel();

}

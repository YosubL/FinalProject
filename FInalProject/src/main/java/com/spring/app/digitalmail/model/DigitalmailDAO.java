package com.spring.app.digitalmail.model;

import java.util.List;
import java.util.Map;

import com.spring.app.digitalmail.domain.EmailStopVO;
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
	// 이메일 시퀀스 체번
	String getEmailseq();
	// 중심 이메일 입력
	int emailsucadd(Map<String, Object> paraMap);
	// 이메일 임시저장
	int emailaddStop(Map<String, Object> paraMap);
	// 임시저장 시퀀스 채번
	String getEmailStopseq();
	// 개별 메일함에 넣어주기
	int emailspilt(Map<String, Object> paraMap);
	// 이메일 한개 보는 페이지
	EmailVO SelectEmail(Map<String, String> paraMap);
	// 비밀번호가 있을경우 알아오기
	String getEmailPwd(String send_email_seq);
	// 임시저장된 리스트 갯수 채번
	int addstopCount(Map<String, String> paraMap);
	// 페이징 처리된 내가 받은 총 메일 보기
	List<EmailStopVO> SelectMyStopEmail_withPaging(Map<String, String> paraMap);
	// 이메일  임시메일 쓰기
	EmailStopVO SelectstopEmail(Map<String, String> paraMap);
	
	// 임시저장 받은사람 메소드
	List<String> getrecipientEmailList(String recipient);
	
	List<String> getreferenceEmailList(String reference);
	
	List<String> gethidden_referenceEmailList(String hidden_reference);
	
	// 임시 이메일 삭제
	int stopemaildel(Map<String, Object> paraMap);
	// 임시 이메일 업데이트
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
	
	// 답장 이메일 가져오기
	String getsenderEmail(String sender);
	
	// 제목 컨텐츠 가져오기
	EmailVO getSubjectandcontent(String send_email_seq);
	
	// 이메일 지우기
	int email_del(Map<String, Object> receipt_mailMap);
	// 이메일 읽음 안읽음 처리
	int total_email_receipt_read_count_update(Map<String, Object> receipt_mailMap);
	// 받은 이메일 번호 , 즐찾여부 알아오기
	EmailVO getseqfav(Map<String, String> paraMap);
	
	int onedel(String receipt_mail_seq);
	
	int emailstop_del(Map<String, Object> receipt_mailMap);
	// 토탈 cnt up
	int email_totalcnt_update(Map<String, String> paraMap);
	// 보낸사람 즐겨찾기
	String select_send_favorites(String receipt_mail_seq);
	// 보낸사람 즐겨찾기 업데이트
	int send_favorites_update(Map<String, String> paraMap);
	
	String select_send_important(String receipt_mail_seq);
	
	int send_important_update(Map<String, String> paraMap);
	
	EmailVO SelectSendEmail(Map<String, String> paraMap);
	
	int onesenddel(String receipt_mail_seq);
	
	int timedel(String send_email_seq);
	
	int timedelete(String send_email_seq);
	
	List<EmailVO> senderdelcheck();
	
	String reallcheck(String seq);
	String redelcheck(String seq);

	
	
	

}

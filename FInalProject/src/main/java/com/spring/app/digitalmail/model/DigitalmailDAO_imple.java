package com.spring.app.digitalmail.model;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.spring.app.digitalmail.domain.EmailStopVO;
import com.spring.app.digitalmail.domain.EmailVO;

//==== Repository(DAO) 선언 ====
//@Component
@Repository
public class DigitalmailDAO_imple implements DigitalmailDAO {
	
	@Resource
	private SqlSessionTemplate sqlsession;
	
	// 내가 받은 총 메일 갯수
	@Override
	public int getTotalCount(Map<String, String> paraMap) {
		int cnt = sqlsession.selectOne("digitalmail.getTotalCount", paraMap);
		return cnt;
	}

	// 페이징 처리된 내가 받은 총 메일 보기
	@Override 
	public List<EmailVO> SelectMyEmail_withPaging(Map<String, String> paraMap) {
		List<EmailVO> emailVOList = sqlsession.selectList("digitalmail.SelectMyEmail_withPaging",paraMap);
		return emailVOList;
	}

	// 이메일 키워드 입력시 자동글 완성하기 //
	@Override
	public List<String> emailWordSearchShow(Map<String, String> paraMap) {
		List<String> wordList = sqlsession.selectList("digitalmail.emailWordSearchShow", paraMap);
		return wordList;
	}
	// 메일 쓰기 뷰단에서 이메일 자동 완성하기
	@Override
	public List<String> getEmailList() {
		List<String> EmailList = sqlsession.selectList("digitalmail.getEmailList");
		return EmailList;
	}
	// 이메일 시퀀스 체번
	@Override
	public String getEmailseq() {
		String email_seq = sqlsession.selectOne("digitalmail.getEmailseq");			
		return email_seq;
	}
	// 임시저장 시퀀스 채번
	@Override
	public String getEmailStopseq() {
		String send_emailSTOP_seq = sqlsession.selectOne("digitalmail.getEmailStopseq");			
		return send_emailSTOP_seq;
	}
	// 중심 이메일 입력
	@Override
	public int emailsucadd(Map<String, Object> paraMap) {
		int n = sqlsession.insert("digitalmail.emailsucadd",paraMap);
		return n;
	}
	@Override
	public int emailaddStop(Map<String, Object> paraMap) {
		int addStop = sqlsession.insert("digitalmail.emailaddStop",paraMap);
		return addStop;
	}

	// 개별 메일함에 넣어주기
	@Override
	public int emailspilt(Map<String, Object> paraMap) {
		
		List<String> receieveEmailList = new ArrayList<String>();
		List<String> receieveplusEmailList = new ArrayList<String>();
		List<String> receievehiddenEmailList = new ArrayList<String>();
		
		int n = 0;
		
		String fk_recipient_email = (String)paraMap.get("receieve_Email");
		if(!fk_recipient_email.trim().isEmpty()) {
			receieveEmailList = new ArrayList<String>(Arrays.asList(fk_recipient_email.split(","))); 
		}
		
		for(String email: receieveEmailList) {
			paraMap.put("emailType", "fk_recipient_email");
			paraMap.put("email_split", email);
			
			System.out.println("이메일타입"+paraMap.get("emailType"));
			System.out.println("시퀀스"+paraMap.get("email_seq"));
			System.out.println("보낸사람"+paraMap.get("fk_sender_email"));
			System.out.println("받은사람"+paraMap.get("email_split"));
			System.out.println("중요도"+paraMap.get("impt"));
			
			n = sqlsession.insert("digitalmail.addEmailsplit",paraMap);
			System.out.println("성공=>>n"+n);
		}
		
		int k = 0;
		String fk_reference_email = (String)paraMap.get("receieveplus_Email");
		if(!fk_reference_email.trim().isEmpty()) {
			receieveplusEmailList = new ArrayList<String>(Arrays.asList(fk_reference_email.split(","))); 
		}
		
		for(String email: receieveplusEmailList) {
			paraMap.put("emailType", "fk_reference_email");
			paraMap.put("email_split", email);
			System.out.println("이메일타입"+paraMap.get("emailType"));
			k = sqlsession.insert("digitalmail.addEmailsplit",paraMap);
			System.out.println("성공=>>k"+k);
		}
		
		int y = 0;
		String fk_hidden_reference_email = (String)paraMap.get("receievehidden_Email");
		
		if(!fk_hidden_reference_email.trim().isEmpty()) {
			receievehiddenEmailList = new ArrayList<String>(Arrays.asList(fk_hidden_reference_email.split(","))); 
		}
		for(String email: receievehiddenEmailList) {
			paraMap.put("emailType", "fk_hidden_reference_email");
			paraMap.put("email_split", email);
			System.out.println("이메일타입"+paraMap.get("emailType"));
			y = sqlsession.insert("digitalmail.addEmailsplit",paraMap);
			System.out.println("성공=>>y"+y);
		}
		
		int lastsuc = n;
		
		System.out.println("lastsuc=>"+lastsuc);
		
		return lastsuc;
	}
	
	// 이메일 한개 보는 페이지
	@Override
	public EmailVO SelectEmail(Map<String, String> paraMap) {
		EmailVO emailVO = sqlsession.selectOne("digitalmail.SelectEmail",paraMap);
		return emailVO;
	}
	
	// 비밀번호가 있을경우 알아오기
	@Override
	public String getEmailPwd(String send_email_seq) {
		String pwd = sqlsession.selectOne("digitalmail.getEmailPwd",send_email_seq);
		return pwd;
	}
	
	// 임시저장된 리스트 갯수 채번
	@Override
	public int addstopCount(Map<String, String> paraMap) {
		int cnt = sqlsession.selectOne("digitalmail.addstopCount", paraMap);
		return cnt;
	}
	
	// 페이징 처리된 내가 받은 총 메일 보기
	@Override
	public List<EmailStopVO> SelectMyStopEmail_withPaging(Map<String, String> paraMap) {
		List<EmailStopVO> emailstopList = sqlsession.selectList("digitalmail.SelectMyStopEmail_withPaging",paraMap);
		return emailstopList;
	}
	
	// 이메일  임시메일 쓰기
	@Override
	public EmailStopVO SelectstopEmail(Map<String, String> paraMap) {
		EmailStopVO emailstopVo = sqlsession.selectOne("digitalmail.SelectstopEmail",paraMap);
		return emailstopVo;
	}

	@Override
	public List<String> getrecipientEmailList(String recipient) {
		
		String[] recipient_arr = recipient.split("\\,");
		
		System.out.println("recipientList=>"+recipient);
	    Map<String, Object> recipientListMap = new HashMap<>();
	    recipientListMap.put("recipient_arr",recipient_arr);
	    
	    System.out.println(recipientListMap.get("recipient_arr"));
	    
		List<String> recipientEmailList = sqlsession.selectList("digitalmail.recipientEmailList",recipientListMap);
		return recipientEmailList;
	}

	@Override
	public List<String> getreferenceEmailList(String reference) {
		String[] reference_arr = reference.split("\\,");
		Map<String, Object> referenceListMap = new HashMap<>();
		referenceListMap.put("reference_arr",reference_arr);
		List<String> referenceEmailList = sqlsession.selectList("digitalmail.referenceEmailList",referenceListMap);
		return referenceEmailList;
	}

	@Override
	public List<String> gethidden_referenceEmailList(String hidden_reference) {
		String[] hidden_reference_arr = hidden_reference.split("\\,");
		Map<String, Object> hidden_referenceListMap = new HashMap<>();
		hidden_referenceListMap.put("hidden_reference_arr",hidden_reference_arr);
		List<String> hidden_referenceEmailList = sqlsession.selectList("digitalmail.hidden_referenceEmailList",hidden_referenceListMap);
		return hidden_referenceEmailList;
	}
	// 임시 이메일 삭제
	@Override
	public int stopemaildel(Map<String, Object> paraMap) {
		int stopemaildel = sqlsession.delete("digitalmail.stopemaildel",paraMap);	
		return stopemaildel;
	}

	@Override
	public int emailaddupdate(Map<String, Object> paraMap) {
		int addupdate = sqlsession.update("digitalmail.emailaddupdate",paraMap);
		return addupdate;
	}	
	
	// receipt_favorites update하기
	@Override
	public int receipt_favorites_update(Map<String, String> paraMap) {
		int n = sqlsession.update("digitalmail.receipt_favorites_update", paraMap);
		return n;
	}

	
	// receipt_favorites 값 가져오기
	@Override
	public String select_receipt_favorites(String receipt_mail_seq) {
		String receipt_favorites = sqlsession.selectOne("digitalmail.select_receipt_favorites", receipt_mail_seq);
		return receipt_favorites;
	}


	// email_receipt_read_count update 하기
	@Override
	public int email_receipt_read_count_update(String receipt_mail_seq) {
		int n = sqlsession.update("digitalmail.email_receipt_read_count_update", receipt_mail_seq);
		return n;
	}

	
	// email_receipt_read_count 값 가져오기
	@Override
	public String select_email_receipt_read_count(String receipt_mail_seq) {
		String email_receipt_read_count = sqlsession.selectOne("digitalmail.select_email_receipt_read_count", receipt_mail_seq);
		return email_receipt_read_count;
	}

	// receipt_important 값 가져오기
	@Override
	public String select_receipt_important(String receipt_mail_seq) {
		String receipt_important = sqlsession.selectOne("digitalmail.select_receipt_important", receipt_mail_seq);
		return receipt_important;
	}

	// receipt_important update 하기
	@Override
	public int receipt_important_update(Map<String, String> paraMap) {
		int n = sqlsession.update("digitalmail.receipt_important_update", paraMap);
		return n;
	}
	
	// 답장 이메일 가져오기
	@Override
	public String getsenderEmail(String sender) {
		String senderEmail = sqlsession.selectOne("digitalmail.getsenderEmail", sender);
		System.out.println("senderEmail=>"+senderEmail);
		return senderEmail;
	
	}
	
	
	@Override
	public EmailVO getSubjectandcontent(String send_email_seq) {
		EmailVO emailvo = sqlsession.selectOne("digitalmail.getSubjectandcontent",send_email_seq);
		return emailvo;
	}
	
	// 이메일 삭제하기
	@Override
	public int email_del(Map<String, Object> receipt_mailMap) {
		int del = sqlsession.update("digitalmail.email_del", receipt_mailMap);
		return del;
	}
	// 이메일 읽음 안읽음 처리
	@Override
	public int total_email_receipt_read_count_update(Map<String, Object> receipt_mailMap) {
		int readcnt = sqlsession.update("digitalmail.total_email_receipt_read_count_update", receipt_mailMap);
		return readcnt;
	}
	
	// 받은 이메일 번호 , 즐찾여부 알아오기
	@Override
	public EmailVO getseqfav(Map<String, String> paraMap) {
		EmailVO emailVO2 = sqlsession.selectOne("digitalmail.getseqfav",paraMap);
		return emailVO2;
	}

	@Override
	public int onedel(String receipt_mail_seq) {
		int n = sqlsession.update("digitalmail.onedel", receipt_mail_seq);
		return n;
	}

	@Override
	public int emailstop_del(Map<String, Object> receipt_mailMap) {
		int del = sqlsession.delete("digitalmail.emailstop_del", receipt_mailMap);
		return del;
	}

	@Override
	public int email_totalcnt_update(Map<String, String> paraMap) {
		int n = sqlsession.update("digitalmail.email_totalcnt_update", paraMap);
		return n;
	}

	@Override
	public String select_send_favorites(String receipt_mail_seq) {
		String receipt_favorites = sqlsession.selectOne("digitalmail.select_send_favorites", receipt_mail_seq);
		return receipt_favorites;
	}
	
	
	@Override
	public int send_favorites_update(Map<String, String> paraMap) {
		int n = sqlsession.update("digitalmail.send_favorites_update", paraMap);
		return n;
	}

	@Override
	public String select_send_important(String receipt_mail_seq) {
		String receipt_important = sqlsession.selectOne("digitalmail.select_send_important", receipt_mail_seq);
		return receipt_important;
	}
	
	@Override
	public int send_important_update(Map<String, String> paraMap) {
		int n = sqlsession.update("digitalmail.send_important_update", paraMap);
		return n;
	}
	
	
	@Override
	public EmailVO SelectSendEmail(Map<String, String> paraMap) {
		EmailVO emailVO = sqlsession.selectOne("digitalmail.SelectSendEmail",paraMap);
		return emailVO;
	}

	@Override
	public int onesenddel(String receipt_mail_seq) {
		int n = sqlsession.update("digitalmail.onesenddel", receipt_mail_seq);
		return n;
	}

	@Override
	public int timedel(String send_email_seq) {
		int n = sqlsession.delete("digitalmail.timedel", send_email_seq);
		return n;
	}

	@Override
	public int timedelete(String send_email_seq) {
		int n = sqlsession.delete("digitalmail.timedelete", send_email_seq);
		return n;
	}
	
	// 
	@Override
	public List<EmailVO> senderdelcheck() {
		List<EmailVO> EmailVOList = sqlsession.selectList("digitalmail.senderdelcheck");
		return EmailVOList;
	}

	@Override
	public String reallcheck(String seq) {
		String alllen = sqlsession.selectOne("digitalmail.reallcheck",seq);
		return alllen;
	}

	@Override
	public String redelcheck(String seq) {
		String dellen = sqlsession.selectOne("digitalmail.redelcheck",seq);
		return dellen;
	}


	
	


}

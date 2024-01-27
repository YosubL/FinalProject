package com.spring.app.digitalmail.domain;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class EmailVO {
// tbl_email //
	String send_email_seq; 						// 이메일 번호
	String fk_sender_email; 					// 보낸새람 E메일
	String fk_recipient_email;  				// 받는사람 E메일
	String fk_reference_email;  				// 참조받는사람 E메일
	String fk_hidden_reference_email;   		// 참조받는사람 E메일
	String email_subject;  						// E메일 제목
	String email_contents;  					// E메일 내용
	String send_time;  							// E메일 전송시간
	String sender_delete;  						// E메일 보낸사람 삭제 여부
	String sender_favorites;  					// E메일 보낸사람 즐겨찾기 여부
	String sender_important;  					// E메일 보낸사람 중요도 여부
	String category;  							// 이메일 카테고리
	String individual;  						// 이메일 개인별 출력 여부
	String email_total_read_count;  			// 이메일 총 조회수
	String filename;							// 저장된 파일명
	String orgfilename;							// 원본 파일명
	String filesize;							// 파일 사이즈
	String mail_pwd;							// 메일 비밀번호
// tbl_email //
	//join
// tbl_receipt_email//
	String receipt_mail_seq; 						// 각자 받은 메일 번호
	String fk_send_email_seq; 				// 이메일 번호
	//String fk_sender_email;				// 보낸사람 이메일
	//String fk_recipient_email;			// 받은사람 각자 이메일
	//String fk_reference_email;			// 참조받은사람 각자 이메일
	//String fk_hidden_reference_email; 	// 숨김참조받은사람 각자 이메일
	String receipt_delete;					// 받은사람 삭제 여부
	String receipt_favorites;				// 받은사람 즐겨 찾기 여부
	String receipt_important;				// 받은사람 중요도 체크
	String email_receipt_read_count;		// 받은사람 읽음처리
// tbl_receipt_email//
	//join
	String name;					// 받은사람 삭제 여부
	String job_name;				// 받은사람 즐겨 찾기 여부
	
	
	
	// tbl_email //
	public String getSend_email_seq() {
		return send_email_seq;
	}
	public void setSend_email_seq(String send_email_seq) {
		this.send_email_seq = send_email_seq;
	}
	public String getFk_sender_email() {
		return fk_sender_email;
	}
	public void setFk_sender_email(String fk_sender_email) {
		this.fk_sender_email = fk_sender_email;
	}
	public String getFk_recipient_email() {
		return fk_recipient_email;
	}
	public void setFk_recipient_email(String fk_recipient_email) {
		this.fk_recipient_email = fk_recipient_email;
	}
	public String getFk_reference_email() {
		return fk_reference_email;
	}
	public void setFk_reference_email(String fk_reference_email) {
		this.fk_reference_email = fk_reference_email;
	}
	public String getFk_hidden_reference_email() {
		return fk_hidden_reference_email;
	}
	public void setFk_hidden_reference_email(String fk_hidden_reference_email) {
		this.fk_hidden_reference_email = fk_hidden_reference_email;
	}
	public String getEmail_subject() {
		return email_subject;
	}
	public void setEmail_subject(String email_subject) {
		this.email_subject = email_subject;
	}
	public String getEmail_contents() {
		return email_contents;
	}
	public void setEmail_contents(String email_contents) {
		this.email_contents = email_contents;
	}
	public String getSend_time() {
		return send_time;
	}
	public void setSend_time(String send_time) {
		this.send_time = send_time;
	}
	public String getSender_delete() {
		return sender_delete;
	}
	public void setSender_delete(String sender_delete) {
		this.sender_delete = sender_delete;
	}
	public String getSender_favorites() {
		return sender_favorites;
	}
	public void setSender_favorites(String sender_favorites) {
		this.sender_favorites = sender_favorites;
	}
	public String getSender_important() {
		return sender_important;
	}
	public void setSender_important(String sender_important) {
		this.sender_important = sender_important;
	}
	public String getCategory() {
		return category;
	}
	public void setCategory(String category) {
		this.category = category;
	}
	public String getIndividual() {
		return individual;
	}
	public void setIndividual(String individual) {
		this.individual = individual;
	}
	public String getEmail_total_read_count() {
		return email_total_read_count;
	}
	public void setEmail_total_read_count(String email_total_read_count) {
		this.email_total_read_count = email_total_read_count;
	}
	public String getFilename() {
		return filename;
	}
	public void setFilename(String filename) {
		this.filename = filename;
	}
	public String getOrgfilename() {
		return orgfilename;
	}
	public void setOrgfilename(String orgfilename) {
		this.orgfilename = orgfilename;
	}
	public String getFilesize() {
		return filesize;
	}
	public void setFilesize(String filesize) {
		this.filesize = filesize;
	}
	public String getMail_pwd() {
		return mail_pwd;
	}
	public void setMail_pwd(String mail_pwd) {
		this.mail_pwd = mail_pwd;
	}
	
	// tbl_email //
	
	// join
	
	// tbl_receipt_email//
	public String getReceipt_mail_seq() {
		return receipt_mail_seq;
	}
	public void setReceipt_mail_seq(String receipt_mail_seq) {
		this.receipt_mail_seq = receipt_mail_seq;
	}
	public String getFk_send_email_seq() {
		return fk_send_email_seq;
	}
	public void setFk_send_email_seq(String fk_send_email_seq) {
		this.fk_send_email_seq = fk_send_email_seq;
	}
	public String getReceipt_delete() {
		return receipt_delete;
	}
	public void setReceipt_delete(String receipt_delete) {
		this.receipt_delete = receipt_delete;
	}
	public String getReceipt_favorites() {
		return receipt_favorites;
	}
	public void setReceipt_favorites(String receipt_favorites) {
		this.receipt_favorites = receipt_favorites;
	}
	public String getReceipt_important() {
		return receipt_important;
	}
	public void setReceipt_important(String receipt_important) {
		this.receipt_important = receipt_important;
	}
	public String getEmail_receipt_read_count() {
		return email_receipt_read_count;
	}
	public void setEmail_receipt_read_count(String email_receipt_read_count) {
		this.email_receipt_read_count = email_receipt_read_count;
	}
	// tbl_receipt_email//
	
	// join
	
	// tbl_jobs
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getJob_name() {
		return job_name;
	}
	public void setJob_name(String job_name) {
		this.job_name = job_name;
	}
	
	// VO 메소드
	
	// , 제거
	public List<String> commaSplit(String str){
		List<String> resultList = new ArrayList<String>();
		
		if(!str.trim().isEmpty()) {
			resultList = new ArrayList<String>(Arrays.asList(str.split(","))); 
		}
		
		return resultList;
	}
	
	// E메일 , 제거
	public List<String> getFk_recipient_email_split	() {

		List<String> resultList = commaSplit(fk_recipient_email);
		
		return resultList;
	}
	
	// 참조 E메일 , 제거
	public List<String> getFk_reference_email_split	() {

		List<String> resultList = commaSplit(fk_reference_email);
		
		return resultList;
	}
	
	// 히든 참조 E메일 , 제거
	public List<String> getFk_hidden_reference_email_split() {

		List<String> resultList = commaSplit(fk_hidden_reference_email);
		
		return resultList;
	}
	
	// 저장된 파일 이름 , 제거
	public List<String> getFilename_split() {

		List<String> resultList = commaSplit(filename);
		
		return resultList;
	}
	
	// 원본 파일 이름  , 제거
	public List<String> getOrgfilename_split() {

		List<String> resultList = commaSplit(orgfilename);
		
		return resultList;
	}
	
	// 파일 크기 , 제거
	public List<String> getFilesize_split() {

		List<String> resultList = commaSplit(filesize);
		
		return resultList;
	}
	
	// 이메일 같은지 여부 ?아마? 안씀
	public int getUserindex(String email) {
		
		List<String> resultList = commaSplit(fk_recipient_email);
		
		int n = 0;
		for(int i=0; i<resultList.size() ;i++) {
			if(email == resultList.get(i)) {
				n = i;
				break;
			}
		}
		return n;
	}
	

}

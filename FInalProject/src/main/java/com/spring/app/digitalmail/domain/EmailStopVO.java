package com.spring.app.digitalmail.domain;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class EmailStopVO {
	
	// tbl_email //
	String send_emailstop_seq; 					// 이메일 번호
	String fk_sender_email; 					// 보낸새람 E메일
	String fk_recipient_email;  				// 받는사람 E메일
	String fk_reference_email;  				// 참조받는사람 E메일
	String fk_hidden_reference_email;   		// 참조받는사람 E메일
	String email_subject;  						// E메일 제목
	String email_contents;  					// E메일 내용
	String important;  							// E메일 전송시간
	String category;  							// E메일 보낸사람 삭제 여부
	String individual;  						// E메일 보낸사람 즐겨찾기 여부
	String stoptime;
	// VO 메소드
	
	
	
	
	public String getSend_emailstop_seq() {
		return send_emailstop_seq;
	}

	public String getStoptime() {
		return stoptime;
	}

	public void setStoptime(String stoptime) {
		this.stoptime = stoptime;
	}

	public void setSend_emailstop_seq(String send_emailstop_seq) {
		this.send_emailstop_seq = send_emailstop_seq;
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

	public String getImportant() {
		return important;
	}

	public void setImportant(String important) {
		this.important = important;
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

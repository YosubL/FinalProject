package com.spring.app.domain;

public class FreeBoard_likesVO {
	
	private String like_no;         
	private String fk_seq;    
	private String fk_email;    
	private String name;
	
	
	
	public String getLike_no() {
		return like_no;
	}
	public void setLike_no(String like_no) {
		this.like_no = like_no;
	}
	public String getFk_seq() {
		return fk_seq;
	}
	public void setFk_seq(String fk_seq) {
		this.fk_seq = fk_seq;
	}

	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	} 
	
	public String getFk_email() {
		return fk_email;
	}
	public void setFk_email(String fk_email) {
		this.fk_email = fk_email;
	}
	public FreeBoard_likesVO() {}
	
	public FreeBoard_likesVO(String like_no, String fk_seq, String fk_email, String name) {
		super();
		this.like_no = like_no;
		this.fk_seq = fk_seq;
		this.fk_email = fk_email;
		this.name = name;
	}
	
	

	
	
	
	
	
	
}

package com.spring.app.domain;

import org.springframework.web.multipart.MultipartFile;

public class NoticeboardVO {
	
	private String seq;          // 글번호 
	private String fk_emp_id;     // 관리자ID
	private String name;         // 글쓴이 
	private String subject;      // 글제목
	private String content;      // 글내용 
	private String pw;           // 글암호
	private String read_Count;    // 글조회수
	private String reg_Date;      // 글쓴시간
	private String status;       // 글삭제여부   1:사용가능한 글,  0:삭제된글 
	private String previousseq;      // 이전글번호
	private String previoussubject;  // 이전글제목
	private String nextseq;          // 다음글번호
	private String nextsubject;      // 다음글제목	
	private String attachfile;  
	private String rno;
	private MultipartFile attach;  
	private String department_name; //부서번호
	
	public String getAttachfile() {
		return attachfile;
	}
	public void setAttachfile(String attachfile) {
		this.attachfile = attachfile;
	}

	public String getDepartment_name() {
		return department_name;
	}
	public void setDepartment_name(String department_name) {
		this.department_name = department_name;
	}

	public String getSeq() {
		return seq;
	}
	public void setSeq(String seq) {
		this.seq = seq;
	}
	public String getFk_emp_id() {
		return fk_emp_id;
	}
	public void setFk_emp_id(String fk_emp_id) {
		this.fk_emp_id = fk_emp_id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getSubject() {
		return subject;
	}
	public void setSubject(String subject) {
		this.subject = subject;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getPw() {
		return pw;
	}
	public void setPw(String pw) {
		this.pw = pw;
	}
	public String getRead_Count() {
		return read_Count;
	}
	public void setRead_Count(String read_Count) {
		this.read_Count = read_Count;
	}
	public String getReg_Date() {
		return reg_Date;
	}
	public void setReg_Date(String reg_Date) {
		this.reg_Date = reg_Date;
	}

	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getPreviousseq() {
		return previousseq;
	}
	public void setPreviousseq(String previousseq) {
		this.previousseq = previousseq;
	}
	public String getPrevioussubject() {
		return previoussubject;
	}
	public void setPrevioussubject(String previoussubject) {
		this.previoussubject = previoussubject;
	}
	public String getNextseq() {
		return nextseq;
	}
	public void setNextseq(String nextseq) {
		this.nextseq = nextseq;
	}
	public String getNextsubject() {
		return nextsubject;
	}
	public void setNextsubject(String nextsubject) {
		this.nextsubject = nextsubject;
	}
	
	public MultipartFile getAttach() {
		return attach;
	}
	public void setAttach(MultipartFile attach) {
		this.attach = attach;
	}
	
	public String getRno() {
		return rno;
	}
	public void setRno(String rno) {
		this.rno = rno;
	}
	
	public NoticeboardVO() {}
	
	public NoticeboardVO(String seq, String fk_emp_id, String name, String subject, String content, String pw,
			String read_Count, String reg_Date, String status, String previousseq, String previoussubject,
			String nextseq, String nextsubject, String attachfile, String department_name, MultipartFile attach, String rno) {
		super();
		this.seq = seq;
		this.fk_emp_id = fk_emp_id;
		this.name = name;
		this.subject = subject;
		this.content = content;
		this.pw = pw;
		this.read_Count = read_Count;
		this.reg_Date = reg_Date;
		this.status = status;
		this.previousseq = previousseq;
		this.previoussubject = previoussubject;
		this.nextseq = nextseq;
		this.nextsubject = nextsubject;
		this.attachfile = attachfile;
		this.department_name = department_name;
		this.attach = attach;
		this.rno = rno;
	}
	
	
	
	
	
}

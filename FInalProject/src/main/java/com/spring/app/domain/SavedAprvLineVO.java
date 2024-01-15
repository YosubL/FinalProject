package com.spring.app.domain;

public class SavedAprvLineVO {

	private int aprv_line_no;        
	private String aprv_line_name;
	private String fk_empno;    
	private String fk_approval_empno1;     
	private String fk_approval_empno2;      
	
	public int getAprv_line_no() {
		return aprv_line_no;
	}
	public void setAprv_line_no(int aprv_line_no) {
		this.aprv_line_no = aprv_line_no;
	}
	public String getAprv_line_name() {
		return aprv_line_name;
	}
	public void setAprv_line_name(String aprv_line_name) {
		this.aprv_line_name = aprv_line_name;
	}
	public String getFk_empno() {
		return fk_empno;
	}
	public void setFk_empno(String fk_empno) {
		this.fk_empno = fk_empno;
	}
	public String getFk_approval_empno1() {
		return fk_approval_empno1;
	}
	public void setFk_approval_empno1(String fk_approval_empno1) {
		this.fk_approval_empno1 = fk_approval_empno1;
	}
	public String getFk_approval_empno2() {
		return fk_approval_empno2;
	}
	public void setFk_approval_empno2(String fk_approval_empno2) {
		this.fk_approval_empno2 = fk_approval_empno2;
	}
	
}

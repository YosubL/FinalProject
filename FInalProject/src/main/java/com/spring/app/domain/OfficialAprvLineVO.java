package com.spring.app.domain;

public class OfficialAprvLineVO {
	private int official_aprv_line_no; // 공통결재라인 번호(기본키)
	private int fk_draft_type_no; // 기안종류 번호(외래키)
	private int fk_approval_empno1; // 첫번째 결재자 사원번호(외래키)
	private int fk_approval_empno2; // 두번째 결재자 사원번호(외래키)      
	private int fk_approval_empno3; // 세번째 결재자 사원번호(외래키)
	private int fk_approval_empno4; // 네번째 결재자 사원번호(외래키)
	
	public int getOfficial_aprv_line_no() {
		return official_aprv_line_no;
	}
	public void setOfficial_aprv_line_no(int official_aprv_line_no) {
		this.official_aprv_line_no = official_aprv_line_no;
	}
	public int getFk_draft_type_no() {
		return fk_draft_type_no;
	}
	public void setFk_draft_type_no(int fk_draft_type_no) {
		this.fk_draft_type_no = fk_draft_type_no;
	}
	public int getFk_approval_empno1() {
		return fk_approval_empno1;
	}
	public void setFk_approval_empno1(int fk_approval_empno1) {
		this.fk_approval_empno1 = fk_approval_empno1;
	}
	public int getFk_approval_empno2() {
		return fk_approval_empno2;
	}
	public void setFk_approval_empno2(int fk_approval_empno2) {
		this.fk_approval_empno2 = fk_approval_empno2;
	}
	public int getFk_approval_empno3() {
		return fk_approval_empno3;
	}
	public void setFk_approval_empno3(int fk_approval_empno3) {
		this.fk_approval_empno3 = fk_approval_empno3;
	}
	public int getFk_approval_empno4() {
		return fk_approval_empno4;
	}
	public void setFk_approval_empno4(int fk_approval_empno4) {
		this.fk_approval_empno4 = fk_approval_empno4;
	}
}

package com.spring.app.domain;

public class Vacation_manageVO {
	
	private String vacation_seq;   		// 번호 시퀀스
	private String fk_employee_id;		// 사원번호
	private String vacation_reason;     // 사유       	
	private String vacation_start_date;	// 휴가 시작 일자
	private String vacation_end_date;	// 휴가 종료 일자
	private String vacation_reg_date; 	// 휴가 신청 일자
	private String vacation_confirm; 	// 결재 상태 / 1 = 승인대기 / 2 = 승인 / 3 = 반려
	private String vacation_type; 		// 신청 휴가 종류
								  		// 1=연차, 2=가족돌봄, 3=예비군, 4=난임치료, 5=출산, 6=결혼, 7=포상
	private String vacation_manager; 	// 결재 담당자 / gradelevel 5 이상
	
	private String vacation_manager_name; // 결재 담당자 이름
	
	////////////////////////////////////////////
	private	String name; // JOIN 을 위해 tbl_employees 의 name 생성
	private	String email; // JOIN 을 위해 tbl_employees 의 email 생성
	
	private String total_count; // 대기중인 문서의 갯수를 알아오는 용도
	
	private String fk_department_id;    // 부서번호
	
	private String vacation_return_date; 	// JOIN 을 위해 tbl_vacation_manage_return 테이블의 의 반려일자 생성
	private String vacation_return_reason; 	// JOIN 을 위해 tbl_vacation_manage_return 테이블의 의 반려사유 생성
	////////////////////////////////////////////
	
	public String getVacation_seq() {
		return vacation_seq;
	} 

	public void setVacation_seq(String vacation_seq) {
		this.vacation_seq = vacation_seq;
	}

	public String getFk_employee_id() {
		return fk_employee_id;
	}

	public void setFk_employee_id(String fk_employee_id) {
		this.fk_employee_id = fk_employee_id;
	}

	public String getVacation_reason() {
		return vacation_reason;
	}

	public void setVacation_reason(String vacation_reason) {
		this.vacation_reason = vacation_reason;
	}

	public String getVacation_start_date() {
		return vacation_start_date;
	}

	public void setVacation_start_date(String vacation_start_date) {
		this.vacation_start_date = vacation_start_date;
	}

	public String getVacation_end_date() {
		return vacation_end_date;
	}

	public void setVacation_end_date(String vacation_end_date) {
		this.vacation_end_date = vacation_end_date;
	}

	public String getVacation_confirm() {
		return vacation_confirm;
	}

	public void setVacation_confirm(String vacation_confirm) {
		this.vacation_confirm = vacation_confirm;
	}

	public String getVacation_type() {
		return vacation_type;
	}

	public void setVacation_type(String vacation_type) {
		this.vacation_type = vacation_type;
	}

	public String getVacation_manager() {
		return vacation_manager;
	}

	public void setVacation_manager(String vacation_manager) {
		this.vacation_manager = vacation_manager;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getTotal_count() {
		return total_count;
	}

	public void setTotal_count(String total_count) {
		this.total_count = total_count;
	}

	public String getVacation_reg_date() {
		return vacation_reg_date;
	}

	public void setVacation_reg_date(String vacation_reg_date) {
		this.vacation_reg_date = vacation_reg_date;
	}

	public String getVacation_return_date() {
		return vacation_return_date;
	}

	public void setVacation_return_date(String vacation_return_date) {
		this.vacation_return_date = vacation_return_date;
	}

	public String getVacation_return_reason() {
		return vacation_return_reason;
	}

	public void setVacation_return_reason(String vacation_return_reason) {
		this.vacation_return_reason = vacation_return_reason;
	}

	public String getVacation_manager_name() {
		return vacation_manager_name;
	}

	public void setVacation_manager_name(String vacation_manager_name) {
		this.vacation_manager_name = vacation_manager_name;
	}

	public String getFk_department_id() {
		return fk_department_id;
	}

	public void setFk_department_id(String fk_department_id) {
		this.fk_department_id = fk_department_id;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}
	
	
	
	
	

	
	
	
	

}

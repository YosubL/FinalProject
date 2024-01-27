package com.spring.app.domain;

public class CelebratePayVO {
	
	private String app_no;
	private String fk_employee_id;
	private String app_date;
	private String app_pay;
	private String celebrate_type;
	private String app_status;
	private String department;
	private String name;
	private String department_name; //부서번호
	private String gender;
	private String title;
	private String deptName;
	
	
	public String getDeptName() {
		return deptName;
	}
	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	public String getDepartment_name() {
		return department_name;
	}
	public void setDepartment_name(String department_name) {
		this.department_name = department_name;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getDepartment() {
		return department;
	}
	public void setDepartment(String department) {
		this.department = department;
	}
	public String getApp_no() {
		return app_no;
	}
	public void setApp_no(String app_no) {
		this.app_no = app_no;
	}
	public String getFk_employee_id() {
		return fk_employee_id;
	}
	public void setFk_employee_id(String fk_employee_id) {
		this.fk_employee_id = fk_employee_id;
	}
	public String getApp_date() {
		return app_date;
	}
	public void setApp_date(String app_date) {
		this.app_date = app_date;
	}
	public String getApp_pay() {
		return app_pay;
	}
	public void setApp_pay(String app_pay) {
		this.app_pay = app_pay;
	}
	public String getCelebrate_type() {
		return celebrate_type;
	}
	public void setCelebrate_type(String celebrate_type) {
		this.celebrate_type = celebrate_type;
	}
	public String getApp_status() {
		return app_status;
	}
	public void setApp_status(String app_status) {
		this.app_status = app_status;
	}
	
	
	public CelebratePayVO() {}
	
	public CelebratePayVO(String app_no, String fk_employee_id, String app_date, String app_pay, String celebrate_type,
			String app_status,String department_name ,String name,String gender,String title, String deptName ) {
		super();
		this.app_no = app_no;
		this.fk_employee_id = fk_employee_id;
		this.app_date = app_date;
		this.app_pay = app_pay;
		this.celebrate_type = celebrate_type;
		this.app_status = app_status;
		this.department_name = department_name;
		this.name = name;
		this.gender = gender;
		this.title = title;
		this.deptName = deptName;
	}
	
	
	

}

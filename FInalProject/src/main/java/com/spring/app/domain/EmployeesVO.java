package com.spring.app.domain;

import org.springframework.web.multipart.MultipartFile;

public class EmployeesVO {

	private String employee_id;      // 사원번호
	private String name; 		  // 사원명
	private String pwd;    	  	  // 비밀번호
	private String email; 		  // 이메일
	private String phone;    	  // 핸드폰
	private String postcode; 	  // 우편번호
	private String address;       // 주소
	private String detailaddress; // 상세주소
	private String extraaddress;  // 참고항목
	private String jubun;       	  // 주민번호
	private String hire_date;     // 입사일자
	private String salary;  		  // 월급
	private String commission_pct;   // 수당
	private String fk_department_id; // 부서번호
	private String fk_team_id;    	  // 부서번호
	private String manager_id;    	  // 부서장번호
	private String t_manager_id;     // 부서장번호
	private String fk_job_id;        // 직급번호
	private String status;      	  // 근무현황   1: 퇴근 / 2:근무중 / 3:출장
	private String register_status;  // 가입현황   0 : 가입대기 / 1 : 가입완료
	private String idle;        	  // 휴면여부      0 : 일하는중  /  1 : 휴직 / 2: 퇴사 
	private String gradelevel;   	  // 사원등급  1: 사원 / 3:팀장 / 5: 부서장 / 10: 사장? 총관리자?
	private String photo;         // 사원 사진
	private String bank_name;     // 은행명
	private String bank_code;     // 계좌번호
	private String userid;        // 아이디
	private String signimg;			// 사인 이미지
	
	private String grade;			// 직책(join용)
	private String department_name;			// 부서명(join용)
	
	
	private MultipartFile attach;
	

	public String getEmployee_id() {
		return employee_id;
	}

	public void setEmployee_id(String employee_id) {
		this.employee_id = employee_id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPwd() {
		return pwd;
	}

	public void setPwd(String pwd) {
		this.pwd = pwd;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getPostcode() {
		return postcode;
	}

	public void setPostcode(String postcode) {
		this.postcode = postcode;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getDetailaddress() {
		return detailaddress;
	}

	public void setDetailaddress(String detailaddress) {
		this.detailaddress = detailaddress;
	}

	public String getExtraaddress() {
		return extraaddress;
	}

	public void setExtraaddress(String extraaddress) {
		this.extraaddress = extraaddress;
	}

	public String getJubun() {
		return jubun;
	}

	public void setJubun(String jubun) {
		this.jubun = jubun;
	}

	public String getHire_date() {
		return hire_date;
	}

	public void setHire_date(String hire_date) {
		this.hire_date = hire_date;
	}

	public String getSalary() {
		return salary;
	}

	public void setSalary(String salary) {
		this.salary = salary;
	}

	public String getCommission_pct() {
		return commission_pct;
	}

	public void setCommission_pct(String commission_pct) {
		this.commission_pct = commission_pct;
	}

	public String getFk_department_id() {
		return fk_department_id;
	}

	public void setFk_department_id(String fk_department_id) {
		this.fk_department_id = fk_department_id;
	}

	public String getFk_team_id() {
		return fk_team_id;
	}

	public void setFk_team_id(String fk_team_id) {
		this.fk_team_id = fk_team_id;
	}

	public String getManager_id() {
		return manager_id;
	}

	public void setManager_id(String manager_id) {
		this.manager_id = manager_id;
	}

	public String getT_manager_id() {
		return t_manager_id;
	}

	public void setT_manager_id(String t_manager_id) {
		this.t_manager_id = t_manager_id;
	}

	public String getFk_job_id() {
		return fk_job_id;
	}

	public void setFk_job_id(String fk_job_id) {
		this.fk_job_id = fk_job_id;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getRegister_status() {
		return register_status;
	}

	public void setRegister_status(String register_status) {
		this.register_status = register_status;
	}

	public String getIdle() {
		return idle;
	}

	public void setIdle(String idle) {
		this.idle = idle;
	}

	public String getGradelevel() {
		return gradelevel;
	}

	public void setGradelevel(String gradelevel) {
		this.gradelevel = gradelevel;
	}

	public String getPhoto() {
		return photo;
	}

	public void setPhoto(String photo) {
		this.photo = photo;
	}

	public String getBank_name() {
		return bank_name;
	}

	public void setBank_name(String bank_name) {
		this.bank_name = bank_name;
	}

	public String getBank_code() {
		return bank_code;
	}

	public void setBank_code(String bank_code) {
		this.bank_code = bank_code;
	}

	public String getUserid() {
		return userid;
	}

	public void setUserid(String userid) {
		this.userid = userid;
	}

	public MultipartFile getAttach() {
		return attach;
	}

	public void setAttach(MultipartFile attach) {
		this.attach = attach;
	}

	public String getSignimg() {
		return signimg;
	}

	public void setSignimg(String signimg) {
		this.signimg = signimg;
	}

	public String getGrade() {
		return grade;
	}

	public void setGrade(String grade) {
		this.grade = grade;
	}

	public String getDepartment_name() {
		return department_name;
	}

	public void setDepartment_name(String department_name) {
		this.department_name = department_name;
	}
	
	
	
	

	
}

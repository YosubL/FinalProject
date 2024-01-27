package com.spring.app.domain;

public class JobsVO {

	
	private String job_id;
	private String job_name;
	private String fk_department_id;
	private String gradelevel;
	private String basic_salary;
	private String min_salary;
	private String max_salary;
	private String fk_team_id;
	
	public String getJob_id() {
		return job_id;
	}
	public void setJob_id(String job_id) {
		this.job_id = job_id;
	}
	public String getJob_name() {
		return job_name;
	}
	public void setJob_name(String job_name) {
		this.job_name = job_name;
	}
	public String getFk_department_id() {
		return fk_department_id;
	}
	public void setFk_department_id(String fk_department_id) {
		this.fk_department_id = fk_department_id;
	}
	public String getGradelevel() {
		return gradelevel;
	}
	public void setGradelevel(String gradelevel) {
		this.gradelevel = gradelevel;
	}
	public String getBasic_salary() {
		return basic_salary;
	}
	public void setBasic_salary(String basic_salary) {
		this.basic_salary = basic_salary;
	}
	public String getMin_salary() {
		return min_salary;
	}
	public void setMin_salary(String min_salary) {
		this.min_salary = min_salary;
	}
	public String getMax_salary() {
		return max_salary;
	}
	public void setMax_salary(String max_salary) {
		this.max_salary = max_salary;
	}
	public String getFk_team_id() {
		return fk_team_id;
	}
	public void setFk_team_id(String fk_team_id) {
		this.fk_team_id = fk_team_id;
	}
	

	
	
}

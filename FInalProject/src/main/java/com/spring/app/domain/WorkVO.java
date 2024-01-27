package com.spring.app.domain;

// === 휴가 관련 VO 생성 === // 

public class WorkVO {
	
	private String fk_employee_id;    // 사원번호
	private String work_date;         // 근무일자
	private String work_start_time;	  // 근무시작시간
	private String work_end_time;	  // 근무종료시간
	private String extended_end_time; // 연장근무종료시간
	
	private String timeDiff;		  // 퇴근-출근 시간의 값
	
	private String thisMonthVal;	  // 해당 월
	
	public String getFk_employee_id() {
		return fk_employee_id;
	}
	public void setFk_employee_id(String fk_employee_id) {
		this.fk_employee_id = fk_employee_id;
	}
	
	public String getWork_date() {
		return work_date;
	}
	public void setWork_date(String work_date) {
		this.work_date = work_date;
	}
	
	public String getWork_start_time() {
		return work_start_time;
	}
	public void setWork_start_time(String work_start_time) {
		this.work_start_time = work_start_time;
	}
	
	public String getWork_end_time() {
		return work_end_time;
	}
	public void setWork_end_time(String work_end_time) {
		this.work_end_time = work_end_time;
	}
	public String getExtended_end_time() {
		return extended_end_time;
	}
	public void setExtended_end_time(String extended_end_time) {
		this.extended_end_time = extended_end_time;
	}
	
	public String getTimeDiff() {
		return timeDiff;
	}
	public void setTimeDiff(String timeDiff) {
		this.timeDiff = timeDiff;
	}
	
	public String getThisMonthVal() {
		return thisMonthVal;
	}
	public void setThisMonthVal(String thisMonthVal) {
		this.thisMonthVal = thisMonthVal;
	}
	
	
}

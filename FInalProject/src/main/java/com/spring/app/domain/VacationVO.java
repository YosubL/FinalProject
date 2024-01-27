package com.spring.app.domain;

// === 휴가 관련 VO 생성 === // 

public class VacationVO {
	
	private String fk_employee_id;     		// 사원번호
	private String annual;              	// 연차
	private String family_care;				// 가족돌봄
	private String reserve_forces;			// 예비군
	private String infertility_treatment;	// 난임치료
	private String childbirth;				// 출생
	private String marriage;				// 결혼
	private String reward;					// 포상
	private String fk_vacation_type;		// 휴가종류

	public String getFk_employee_id() {
		return fk_employee_id;
	}

	public void setFk_employee_id(String fk_employee_id) {
		this.fk_employee_id = fk_employee_id;
	}

	public String getAnnual() {
		return annual;
	}

	public void setAnnual(String annual) {
		this.annual = annual;
	}

	public String getFamily_care() {
		return family_care;
	}

	public void setFamily_care(String family_care) {
		this.family_care = family_care;
	}

	public String getReserve_forces() {
		return reserve_forces;
	}

	public void setReserve_forces(String reserve_forces) {
		this.reserve_forces = reserve_forces;
	}

	public String getInfertility_treatment() {
		return infertility_treatment;
	}

	public void setInfertility_treatment(String infertility_treatment) {
		this.infertility_treatment = infertility_treatment;
	}

	public String getChildbirth() {
		return childbirth;
	}

	public void setChildbirth(String childbirth) {
		this.childbirth = childbirth;
	}

	public String getMarriage() {
		return marriage;
	}

	public void setMarriage(String marriage) {
		this.marriage = marriage;
	}

	public String getReward() {
		return reward;
	}

	public void setReward(String reward) {
		this.reward = reward;
	}

	public String getFk_vacation_type() {
		return fk_vacation_type;
	}

	public void setFk_vacation_type(String fk_vacation_type) {
		this.fk_vacation_type = fk_vacation_type;
	}
	
}

package com.spring.app.kimkm.model;

import java.util.Map;

import com.spring.app.domain.EmployeesVO;

public interface RegisterDAO {

	// 회원가입
	int add_register(EmployeesVO evo);
	
	// 회원가입시 휴가 테이블 insert 하기
	int insert_vacation(String employee_id);
	
	// 내 정보 수정하기
	int myinfoEditEnd(EmployeesVO evo);

	// 성별 생년월일 알아오기
	Map<String, String> selectGenderBirthday(String employee_id);

	// 부서이름 팀명 알아오기
	Map<String, String> selectDeptTeam(String employee_id);
	
	// 남은 휴가일수 알아오기
	Map<String, String> selectVacation(String employee_id);

	// 회원가입시 기본 정보 읽어오기
	Map<String, String> selectRegister(String email);

	// 비밀번호 변경하기
	int pwdUpdateEnd(Map<String, String> paraMap);

}

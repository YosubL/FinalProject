package com.spring.app.kimkm.model;

import java.util.List;
import java.util.Map;

import com.spring.app.domain.EmployeesVO;

public interface KimkmDAO {

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

	// 회원가입시 기본 정보 읽어오기
	Map<String, String> selectRegister(String email);

	// 비밀번호 변경하기
	int pwdUpdateEnd(Map<String, String> paraMap);

	// 급여계산 하기
	Map<String, String> selectSalary(String employee_id);

	// 급여테이블 조회하기
	List<Map<String, String>> monthSal(String employee_id);

	// 급여명세서 테이블 가져오기
	Map<String, String> salaryStatement(Map<String, String> paraMap);

	// salay 테이블에서 Excel 담을 값 가져오기
	List<Map<String, String>> salaryList(Map<String, Object> paraMap);

	// 조직도 리스트 가져오기
	List<Map<String, String>> employeeList();

	



	
	
}
package com.spring.app.yosub.service;

import java.util.List;
import java.util.Map;

import com.spring.app.domain.EmployeesVO;

public interface EmpService {

    //employees 테이블의 근무중 사원 부서번호 가져오기
	List<Map<String, String>> deptNameList();
	//employees 테이블의 근무중 사원 간략 정보 가져오기
	List<Map<String, String>> empList(Map<String, String> paraMap);
	//employees 테이블의 사원 총인원 가져오기
	int getTotalCount(Map<String, String> paraMap);
	//employees 테이블의 사원 정보 가져오기
	Map<String, String> oneMemberMap(String employee_id);

	//department 부서번호 최대값 가져오기
	int department_id_max();
	//department 부서명 가져오기
	List<Map<String, String>> manager_id();
	//department 부서정보 조회하기
	List<Map<String, String>> select_department();
	//department 부서정보 조회하기
	List<Map<String, String>> select_departments();
	//department 부서생성하기
	String department_add(String department_id, String department_name, String manager_id) throws Throwable;

	// 팀 번호 최대값 가져오기
	int team_id_max();
	// 팀 메니저 가능자 구하기
	List<Map<String, String>> T_manager_id();
	// 부서에 따른 최대 팀값 구하기
	int team_id_max_by_department(String department_id);
	// 부서에 따른 팀값 구하기
	List<Map<String, String>> team_id_select_by_department(String department_id);
	// 팀 생성하기
	String team_add(Map<String, String> paraMap);

	// 해당 부서의 정보 조회하기
	List<Map<String, String>> get_department_info(String department_id);
	// 해당 팀의 정보 조회하기	
	List<Map<String, String>> get_team_info(String team_id);
	// 부서 삭제하기
	int department_del(String department_id);
	// 팀 삭제하기
	int team_del(String team_id);
	// 해당 부서의 직책정보 조회하기
	List<Map<String, String>> job_id_select_by_department(String department_id);
	// 회원정보 업데이트
	int infoEditEnd(EmployeesVO evo);
	
	
	
	


	
	
}

package com.spring.app.kimkm.model;

import java.util.List;
import java.util.Map;

public interface SalaryDAO {

	// 급여테이블 조회하기
	List<Map<String, String>> monthSal(String employee_id);

	// 급여명세서 테이블 가져오기
	Map<String, String> salaryStatement(Map<String, String> paraMap);

	// salay 테이블에서 Excel 담을 값 가져오기
	List<Map<String, String>> salaryList(Map<String, Object> paraMap);

	// 월급 테이블 insert 하기위한 값 가져오기
	List<Map<String, String>> emp_salary_List(String lastMonth);
	
	// 월급 테이블 insert 하기
	int insert_PayslipTemplate(List<Map<String, String>> emp_salary_List);

	// 공지사항 글쓰기를 위한 급여명세서 발급자 정보 select 하기
	Map<String, String> select_human_resources_manager(String manager);

	// 공지사항 insert 하기
	int insert_notice_board(Map<String, String> manager_name_empId);
	
}

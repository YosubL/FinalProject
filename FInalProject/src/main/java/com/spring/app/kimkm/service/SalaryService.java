package com.spring.app.kimkm.service;

import java.util.List;
import java.util.Map;

import org.springframework.ui.Model;

public interface SalaryService {

	// 급여테이블 조회하기
	List<Map<String, String>> monthSal(String employee_id);

	// 급여명세서 테이블 가져오기
	Map<String, String> salaryStatement(Map<String, String> paraMap);
	
	// salary 테이블에서 조건에 만족하는 급여들을 가져와서 Excel 파일로 만들기 
	void salary_to_Excel(Map<String, Object> paraMap, Model model);
	
	// === Spring Scheduler(스프링 스케줄러)를 사용한 tbl_salary 테이블 insert 와 공지사항 insert === //
	void PayslipTemplate() throws Exception;

	
}

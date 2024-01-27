package com.spring.app.kimkm.model;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

//==== #32. Repository(DAO) 선언 ====
//@Component
@Repository
public class SalaryDAO_imple implements SalaryDAO {

	@Resource
	private SqlSessionTemplate sqlsession;

	// 급여 조회하기
	@Override
	public List<Map<String, String>> monthSal(String employee_id) {
		List<Map<String, String>> monthSalList = sqlsession.selectList("kimkm.monthSal", employee_id);
		return monthSalList;
	}

	// 급여명세서 가져오기
	@Override
	public Map<String, String> salaryStatement(Map<String, String> paraMap) {
		Map<String, String> salaryStatement = sqlsession.selectOne("kimkm.salaryStatement", paraMap);
		return salaryStatement;
	}

	// salay 테이블에서 Excel 담을 값 가져오기
	@Override
	public List<Map<String, String>> salaryList(Map<String, Object> paraMap) {
		List<Map<String, String>> salaryList = sqlsession.selectList("kimkm.salaryList", paraMap);
		return salaryList;
	}
	
	// 월급 테이블 insert 하기위한 값 가져오기
	@Override
	public List<Map<String, String>> emp_salary_List(String lastMonth) {
		List<Map<String, String>> emp_salary_List = sqlsession.selectList("kimkm.emp_salary_List", lastMonth);
		return emp_salary_List;
	}

	// 월급 테이블 insert 하기
	@Override
	public int insert_PayslipTemplate(List<Map<String, String>> emp_salary_List) {
		int n = sqlsession.insert("kimkm.insert_PayslipTemplate", emp_salary_List);
		return n;
	}
	
	// 공지사항 글쓰기를 위한 급여명세서 발급자 정보 select 하기
	@Override
	public Map<String, String> select_human_resources_manager(String manager) {
		Map<String, String> manager_name_empId = sqlsession.selectOne("kimkm.select_human_resources_manager", manager);
		return manager_name_empId;
	}
	
	// 공지사항 insert 하기
	@Override
	public int insert_notice_board(Map<String, String> manager_name_empId) {
		int n = sqlsession.insert("kimkm.insert_notice_board", manager_name_empId);
		return n;
	}
	
	
	
}

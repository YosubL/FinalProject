package com.spring.app.kimkm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import com.spring.app.domain.DepartmentVO;
import com.spring.app.kimkm.model.OrganizationChartDAO;

// ==== #31. Service 선언 ====
// 트랜잭션 처리를 담당하는 곳, 업무를 처리하는 곳, 비지니스(Business)단 
// @Component
@Service
public class OrganizationChartService_imple implements OrganizationChartService {

	@Autowired
	private OrganizationChartDAO dao;

	// 조직도 select option을 위한 department테이블  select하기
	@Override
	public List<Map<String,String>> selectdept(DepartmentVO deptvo) {
		List<Map<String,String>> deptList = dao.selectdept(deptvo);
		return deptList;
	}

	// 조직도 리스트 가져오기
	@Override
	public List<Map<String, String>> employeeList() {
		List<Map<String, String>> employeeList = dao.employeeList();
		return employeeList;
	}

	
	
}

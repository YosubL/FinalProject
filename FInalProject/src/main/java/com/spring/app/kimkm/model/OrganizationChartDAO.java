package com.spring.app.kimkm.model;

import java.util.List;
import java.util.Map;

import com.spring.app.domain.DepartmentVO;

public interface OrganizationChartDAO {
	
	// 조직도 select option을 위한 department테이블  select하기
	List<Map<String,String>> selectdept(DepartmentVO deptvo);
	
	// 조직도 리스트 가져오기
	List<Map<String, String>> employeeList();
	
}

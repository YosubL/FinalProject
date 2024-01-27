package com.spring.app.kimkm.model;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.spring.app.domain.DepartmentVO;

//==== #32. Repository(DAO) 선언 ====
//@Component
@Repository
public class OrganizationChartDAO_imple implements OrganizationChartDAO {

	@Resource
	private SqlSessionTemplate sqlsession;

	// 조직도 select option을 위한 department테이블  select하기
	@Override
	public List<Map<String,String>> selectdept(DepartmentVO deptvo) {
		List<Map<String,String>> deptList = sqlsession.selectList("kimkm.selectdept", deptvo);
		return deptList;
	}

	// 조직도 리스트 가져오기
	@Override
	public List<Map<String, String>> employeeList() {
		List<Map<String, String>> employeeList = sqlsession.selectList("kimkm.employeeList");
		return employeeList;
	}
	
}

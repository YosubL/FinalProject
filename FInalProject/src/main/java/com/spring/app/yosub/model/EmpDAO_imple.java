package com.spring.app.yosub.model;


import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.spring.app.domain.EmployeesVO;

//==== #32. Repository(DAO) 선언 ====
//@Component
@Repository
public class EmpDAO_imple implements EmpDAO {


//	@Resource
//	private SqlSessionTemplate sqlsession_hr;

	// 또는
	@Autowired
	@Qualifier("sqlsession") // import 할때 org.springframework.beans.factory.annotation.Qualifier; 로 하는 거 확인
	private SqlSessionTemplate sql; // bean 에 sqlsession_hr 을 주입하라는 뜻이다

	@Override
	public List<Map<String, String>> deptNameList() {
		
		List<Map<String, String>> deptNameList = sql.selectList("yosub.deptNameList");
		
		return deptNameList;
	}

	@Override
	public List<Map<String, String>> empList(Map<String, String> paraMap) {

		List<Map<String, String>> empList = sql.selectList("yosub.empList", paraMap);
		
		return empList;
	}

	@Override
	public int getTotalCount(Map<String, String> paraMap) {
		int n = sql.selectOne("yosub.getTotalCount", paraMap);
		return n;
	}


	@Override
	public Map<String, String> oneMemberMap(String employee_id) {

		Map<String, String> oneMemberMap = sql.selectOne("yosub.oneMember", employee_id);
		
		return oneMemberMap;
	}

	@Override
	public List<Map<String, String>> manager_id() {

		List<Map<String, String>> manager_id_List = sql.selectList("yosub.manager_id");
		
		return manager_id_List;
	}

	@Override
	public int department_id_max() {
		
		int department_id_max = sql.selectOne("yosub.department_id_max");
		
		return department_id_max;
	}

	@Override
	public List<Map<String, String>> select_departments() {
		
		List<Map<String, String>> departments_List = sql.selectList("yosub.select_departments");
		
		return departments_List;
	}

	@Override
	public int department_add(Map<String, String> paraMap) {

		int n = sql.update("yosub.department_add", paraMap);
		
		int m = sql.update("yosub.team_add", paraMap);

		int o = sql.update("yosub.insertJob1", paraMap);
		
		int p = sql.update("yosub.insertJob2", paraMap);
		
		int q = sql.update("yosub.insertJob3", paraMap);
		
		return n * m * o * p * q;
	}

	@Override
	public int update_employees_department_id(Map<String, String> paraMap) {
		
		String job_id = sql.selectOne("yosub.employees_department_job", paraMap);
		
		paraMap.put("job_id", job_id);
		
		int n =0;
		
		if(job_id != "") {
		
		 n = sql.update("yosub.update_employees_department_id", paraMap);
		}
		return n;
	}

	@Override
	public List<Map<String, String>> select_department() {
		
		List<Map<String, String>> departments_List = sql.selectList("yosub.select_department");
		
		return departments_List;
	}

	@Override
	public int team_id_max() {
		
		int team_id_max = sql.selectOne("yosub.team_id_max");
		
		return team_id_max;
	}

	@Override
	public List<Map<String, String>> t_manager_id() {

		List<Map<String, String>> t_manager_id_List = sql.selectList("yosub.t_manager_id");
		
		return t_manager_id_List;
	}

	

	@Override
	public int team_id_max_by_department(String department_id) {
		
		int team_id_max_by_department = sql.selectOne("yosub.team_id_max_by_department",department_id);
		
		return team_id_max_by_department;
	}

	@Override
	public int team_add(Map<String, String> paraMap) {
		
		int m = sql.update("yosub.add_team", paraMap);
		
		int p = sql.update("yosub.insertteamJob2", paraMap);
		
		int q = sql.update("yosub.insertteamJob3", paraMap);
		
		return m * p * q ;
		
	}

	@Override
	public int update_employees_team_id(Map<String, String> paraMap) {
		
		String job_id = sql.selectOne("yosub.employees_team_job", paraMap);
		
		paraMap.put("job_id", job_id);
		
		int n =0;
		
		if(job_id != "") {
		n = sql.update("yosub.update_employees_team_id", paraMap);
		}
		return n;
	}
	
	
	
	@Override
	public List<Map<String, String>> get_department_info(String department_id) {
		
		List<Map<String, String>> get_department_info = sql.selectList("yosub.get_department_info", department_id);
		
		return get_department_info;
	}

	@Override
	public List<Map<String, String>> get_team_info(String team_id) {
		
		List<Map<String, String>> get_team_info = sql.selectList("yosub.get_team_info", team_id);
		
		return get_team_info;
	}

	@Override
	public int department_del(String department_id) {
		int n = sql.delete("yosub.department_del",department_id);
		return n;
	}

	@Override
	public List<Map<String, String>> team_id_select_by_department(String department_id) {
		
			List<Map<String, String>> team_id_select_by_department = sql.selectList("yosub.team_id_select_by_department", department_id);
		
		return team_id_select_by_department;
	}

	@Override
	public int team_del(String team_id) {
		int n = sql.delete("yosub.team_del",team_id);
		return n;
	}

	@Override
	public List<Map<String, String>> job_id_select_by_department(String department_id) {
	
			List<Map<String, String>> job_id_select_by_department = sql.selectList("yosub.job_id_select_by_department", department_id);
		
		return job_id_select_by_department;
	}

	@Override
	public int infoEditEnd(EmployeesVO evo) {
		
			int n = sql.update("yosub.infoEditEnd", evo);
			
		return n;
	}
}

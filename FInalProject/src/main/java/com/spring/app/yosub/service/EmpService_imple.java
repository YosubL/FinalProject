package com.spring.app.yosub.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.spring.app.domain.EmployeesVO;
import com.spring.app.yosub.model.EmpDAO;

// ==== #31. Service 선언 ====
// 트랜잭션 처리를 담당하는 곳, 업무를 처리하는 곳, 비지니스(Business)단 
// @Component
@Service
public class EmpService_imple implements EmpService {

	@Autowired
	private EmpDAO dao;

	
   //employees 테이블의 근무중 사원 부서번호 가져오기
	@Override
	public List<Map<String, String>> deptNameList() {

		List<Map<String, String>> deptNameList =dao.deptNameList();
		
		return deptNameList;
	}


	@Override
	public List<Map<String, String>> empList(Map<String, String> paraMap) {
	
		List<Map<String, String>> empList = dao.empList(paraMap);
	
		return empList;
	}


	@Override
	public int getTotalCount(Map<String, String> paraMap) {
			int n = dao.getTotalCount(paraMap);
		return n;
	}


	@Override
	public Map<String, String> oneMemberMap(String employee_id) {
		Map<String, String> oneMember = dao.oneMemberMap(employee_id);
		return oneMember;
	}


	@Override
	public List<Map<String, String>> manager_id() {
		 List<Map<String, String>> manager_id_List = dao.manager_id();
		return manager_id_List;
	}


	@Override
	public int department_id_max() {
		int department_id_max = dao.department_id_max();
		return department_id_max;
	}


	@Override
	public List<Map<String, String>> select_department() {
		List<Map<String, String>> departments_List= dao.select_department();
		return departments_List;
	}
	@Override
	public List<Map<String, String>> select_departments() {
		List<Map<String, String>> departments_List= dao.select_departments();
		return departments_List;
	}


	// 신규부서 입력하기
		@Override
		@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})
		public String department_add (String department_id, String department_name, String manager_id) throws Throwable {   
			Map<String, String> paraMap = new HashMap<>();
			paraMap.put("department_id", department_id);
			paraMap.put("department_name", department_name);
			paraMap.put("manager_id", manager_id);
			
			
			int n=0, m=0;
			n = dao.department_add(paraMap);
			if(!"".equals(manager_id) && n==1) { // 부서장번호를 입력하고서 신규번호가 등록이 정상적으로 되어진 경우 
				m = dao.update_employees_department_id(paraMap); // 해당사원의 부서번호를 신규부서번호로 변경하기
				n = n*m;
			}
			
			JsonObject jsonObj = new JsonObject(); // {}
			jsonObj.addProperty("n", n); // {"n":1} 
			
			return new Gson().toJson(jsonObj);
		}


		@Override
		public int team_id_max() {

			int team_id_max = dao.team_id_max();
			
			return team_id_max;
			
		}


		@Override
		public List<Map<String, String>> T_manager_id() {
			
			List<Map<String, String>> t_manager_id_List = dao.t_manager_id();
			
			return t_manager_id_List;
		}


		@Override
		public int team_id_max_by_department(String department_id) {

			int team_id_max_by_department = dao.team_id_max_by_department(department_id);
			
			return team_id_max_by_department;
		}


		@Override
		public List<Map<String, String>> get_department_info(String department_id) {
			
			List<Map<String, String>> get_department_info = dao.get_department_info(department_id);
			
			return get_department_info;
		}


		@Override
		@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})
		public String team_add(Map<String, String> paraMap) {
			
			int n=0, m=0;
			n = dao.team_add(paraMap);
			if(!"".equals(paraMap.get("t_manager_id")) && n==1) { // 팀장장번호를 입력하고서 신규번호가 등록이 정상적으로 되어진 경우 
				m = dao.update_employees_team_id(paraMap); // 해당사원의 팀번호를 신규부서번호로 변경하기
				n = n*m;
			}
			
			JsonObject jsonObj = new JsonObject(); // {}
			jsonObj.addProperty("n", n); // {"n":1} 
			
			return new Gson().toJson(jsonObj);
		}
		

		@Override
		public List<Map<String, String>> get_team_info(String team_id) {
			
			List<Map<String, String>> get_team_info = dao.get_team_info(team_id);
			
			return get_team_info;
		}


		@Override
		public int department_del(String department_id) {
			int	n = dao.department_del(department_id);
			return 	n;
		}


		@Override
		public List<Map<String, String>> team_id_select_by_department(String department_id) {
				
				List<Map<String, String>> team_id_select_by_department = dao.team_id_select_by_department(department_id);
			
			return team_id_select_by_department;
		}


		@Override
		public int team_del(String team_id) {
			int	n = dao.team_del(team_id);
			return 	n;
		}


		@Override
		public List<Map<String, String>> job_id_select_by_department(String department_id) {
				
			List<Map<String, String>> job_id_select_by_department = dao.job_id_select_by_department(department_id);
			
			return job_id_select_by_department;
		}

		
		// 내 정보 수정하기
		@Override
		public int infoEditEnd(EmployeesVO evo) {
			int n = dao.infoEditEnd(evo);
			return n;
		}


	
	
	
}

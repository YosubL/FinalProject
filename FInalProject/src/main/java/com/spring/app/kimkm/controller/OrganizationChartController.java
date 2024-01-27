package com.spring.app.kimkm.controller;

import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.spring.app.domain.DepartmentVO;
import com.spring.app.kimkm.service.OrganizationChartService;

@Controller
public class OrganizationChartController {

	@Autowired
	private OrganizationChartService service;
	
	
	// 조직도 페이지 요청하기
	@GetMapping("/chart.gw")
	public String requiredLogin_empmanager_chart(HttpServletRequest request, HttpServletResponse response, DepartmentVO deptvo) {
		
		List<Map<String,String>> deptList = service.selectdept(deptvo);
		
		request.setAttribute("deptList", deptList);
		
		return "emp/orgchart.tiles_MTS";
	}
	
	
	// 조직도  부서아이디, 부서명 가져오기
	@ResponseBody
	@GetMapping(value="/chart/deptList.gw", produces="text/plain;charset=UTF-8")
	public String deptList(DepartmentVO deptvo) {
		
		List<Map<String,String>> deptList = service.selectdept(deptvo);
		
		JsonArray jsonArr = new JsonArray(); // []
		
		for(Map<String, String> map : deptList) {
			
			JsonObject jsonObj = new JsonObject();
			
			jsonObj.addProperty("department_id", map.get("department_id"));
			jsonObj.addProperty("department_name", map.get("department_name"));
			
			jsonArr.add(jsonObj);
		}// end of for
		
		return new Gson().toJson(jsonArr);
		
	}
	
	// 회사 조직도 
	@ResponseBody
	@GetMapping(value="/chart/company.gw", produces="text/plain;charset=UTF-8")
	public String company() {
		
		List<Map<String, String>> employeeList =  service.employeeList();
		
		JsonArray jsonArr = new JsonArray(); // []
		
		for(Map<String, String> map : employeeList) {
			JsonObject jsonObj = new JsonObject();
			
			String job_name = map.get("job_name");
			if (job_name != null && job_name.length() >= 4) {
			    if (job_name.substring(job_name.length() - 3).equals("부서장")) {
			    	jsonObj.addProperty("job_name", job_name.substring(0, job_name.length() - 4) + "부");
			    }
			    else if(job_name.substring(job_name.length() - 2).equals("팀장")) {
			    	jsonObj.addProperty("job_name", job_name.substring(0, job_name.length() - 3));
			    }
			    else {
			    	jsonObj.addProperty("job_name", job_name);
			    }
			}
			else {
				jsonObj.addProperty("job_name", job_name);
			}
			jsonObj.addProperty("employee_id", map.get("employee_id"));
			jsonObj.addProperty("manager_id", map.get("manager_id"));
			jsonObj.addProperty("t_manager_id", map.get("t_manager_id"));
			
			jsonArr.add(jsonObj);
		}// end of for
		
		return new Gson().toJson(jsonArr);
	}
	
	// 사장 부서장 조직도 
	@ResponseBody
	@GetMapping(value="/chart/executive.gw", produces="text/plain;charset=UTF-8")
	public String executive() {
		
		List<Map<String, String>> employeeList =  service.employeeList();
		
		JsonArray jsonArr = new JsonArray(); // []
		
		for(Map<String, String> map : employeeList) {
			
			JsonObject jsonObj = new JsonObject();
			jsonObj.addProperty("name", map.get("name"));
			jsonObj.addProperty("job_name", map.get("job_name"));
			jsonObj.addProperty("photo", map.get("photo"));
			jsonObj.addProperty("employee_id", map.get("employee_id"));
			jsonObj.addProperty("manager_id", map.get("manager_id"));
			jsonObj.addProperty("t_manager_id", map.get("t_manager_id"));
			
			jsonArr.add(jsonObj);
		}// end of for
		
		return new Gson().toJson(jsonArr);
	}
	
	
	// 부서별 조직도
	@ResponseBody
	@GetMapping(value="/chart/dept.gw", produces="text/plain;charset=UTF-8")
	public String dept() {
		
		List<Map<String, String>> employeeList =  service.employeeList();
		
		JsonArray jsonArr = new JsonArray(); // []
		
		for(Map<String, String> map : employeeList) {
			
			JsonObject jsonObj = new JsonObject();
			
			jsonObj.addProperty("name", map.get("name"));
			jsonObj.addProperty("job_name", map.get("job_name"));
			jsonObj.addProperty("photo", map.get("photo"));
			jsonObj.addProperty("department_id", map.get("department_id"));
			jsonObj.addProperty("employee_id", map.get("employee_id"));
			jsonObj.addProperty("manager_id", map.get("manager_id"));
			jsonObj.addProperty("t_manager_id", map.get("t_manager_id"));
			
			jsonArr.add(jsonObj);
			
			
		}// end of for
		
	//	System.out.println(jsonArr);
		
		return new Gson().toJson(jsonArr);
	}

}

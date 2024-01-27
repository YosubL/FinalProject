package com.spring.app.kimkm.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import com.spring.app.domain.EmployeesVO;
import com.spring.app.kimkm.model.RegisterDAO;

// ==== #31. Service 선언 ====
// 트랜잭션 처리를 담당하는 곳, 업무를 처리하는 곳, 비지니스(Business)단 
// @Component
@Service
public class RegisterService_imple implements RegisterService {

	@Autowired
	private RegisterDAO dao;
	
	// 회원가입
	@Override
	public int add_register(EmployeesVO evo) {
		int n = dao.add_register(evo);
		return n;
	}
	
	// 회원가입시 휴가 테이블 insert 하기
	@Override
	public int insert_vacation(String employee_id) {
		int n = dao.insert_vacation(employee_id);
		return n;
	}
	
	// 내 정보 수정하기
	@Override
	public int myinfoEditEnd(EmployeesVO evo) {
		int n = dao.myinfoEditEnd(evo);
		return n;
	}

	
	// 성별 생년월일 알아오기
	@Override
	public Map<String, String> selectGenderBirthday(String employee_id) {
		Map<String, String> gender_birthday = dao.selectGenderBirthday(employee_id);
		return gender_birthday;
	}

	
	// 부서이름 팀명 알아오기
	@Override
	public Map<String, String> selectDeptTeam(String employee_id) {
		Map<String, String> dept_team = dao.selectDeptTeam(employee_id);
		return dept_team;
	}
	
	
	// 남은 휴가일수 알아오기
	@Override
	public Map<String, String> selectVacation(String employee_id) {
		Map<String, String> vacation = dao.selectVacation(employee_id);
		return vacation;
	}

	
	// 회원가입시 기본 정보 읽어오기
	@Override
	public Map<String, String> selectRegister(String email) {
		Map<String, String> register = dao.selectRegister(email);
		return register;
	}

	// 비밀번호 변경하기
	@Override
	public int pwdUpdateEnd(Map<String, String> paraMap) {
		int n = dao.pwdUpdateEnd(paraMap);
		return n;
	}

}

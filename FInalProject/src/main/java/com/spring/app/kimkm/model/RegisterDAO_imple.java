package com.spring.app.kimkm.model;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.spring.app.domain.DepartmentVO;
import com.spring.app.domain.EmployeesVO;

//==== #32. Repository(DAO) 선언 ====
//@Component
@Repository
public class RegisterDAO_imple implements RegisterDAO {

	@Resource
	private SqlSessionTemplate sqlsession;

	// 회원가입
	@Override
	public int add_register(EmployeesVO evo) {
		int n = sqlsession.update("kimkm.add_register", evo);
		return n;
	}
	
	// 회원가입시 휴가 테이블 insert 하기
	@Override
	public int insert_vacation(String employee_id) {
		int n = sqlsession.insert("kimkm.insert_vacation", employee_id);
		return n;
	}
	
	// 내 정보 수정하기
	@Override
	public int myinfoEditEnd(EmployeesVO evo) {
		int n = sqlsession.update("kimkm.myinfoEditEnd", evo);
		return n;
	}

	
	// 성별 알아오기
	@Override
	public Map<String, String> selectGenderBirthday(String employee_id) {
		Map<String, String> gender_birthday = sqlsession.selectOne("kimkm.selectGenderBirthday", employee_id);
		return gender_birthday;
	}

	
	// 부서이름 팀명 알아오기
	@Override
	public Map<String, String> selectDeptTeam(String employee_id) {
		Map<String, String> dept_team = sqlsession.selectOne("kimkm.selectDeptTeam", employee_id);
		return dept_team;
	}
	
	// 남은 휴가일수 알아오기
	@Override
	public Map<String, String> selectVacation(String employee_id) {
		Map<String, String> vacation = sqlsession.selectOne("kimkm.selectVacation", employee_id);
		return vacation;
	}

	
	// 회원가입시 기본 정보 읽어오기
	@Override
	public Map<String, String> selectRegister(String email) {
		Map<String, String> register = sqlsession.selectOne("kimkm.selectRegister",email);
		return register;
	}

	// 비밀번호 변경하기
	@Override
	public int pwdUpdateEnd(Map<String, String> paraMap) {
		int n = sqlsession.update("kimkm.pwdUpdateEnd", paraMap);
		return n;
	}

}

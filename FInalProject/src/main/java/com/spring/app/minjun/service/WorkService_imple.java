package com.spring.app.minjun.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.app.domain.*;
import com.spring.app.minjun.model.*;

@Service
public class WorkService_imple implements WorkService {
	
 	@Autowired  // Type에 따라 알아서 Bean 을 주입해준다.
	private WorkDAO dao;

	// 특정 사원의 근무내역 가져오기
	@Override
	public List<WorkVO> my_workList(String employee_id) {
		List<WorkVO> my_workList = dao.my_workList(employee_id);
		return my_workList;
	}

	// 출근 버튼 클릭시 근태테이블에 insert 하기
	@Override
	public int goToWorkInsert(Map<String, String> paraMap) {
		int n = dao.goToWorkInsert(paraMap);
		return n;
	}

	// 퇴근 버튼 클릭시 근무테이블에 update 하기
	@Override
	public int leaveWork(Map<String, String> paraMap) {
		int n = dao.leaveWork(paraMap);
		return n;
	}

	// 특정 사원의 근무신청내역 가져오기
	@Override
	public List<WorkVO> workList(Map<String, String> paraMap) {
		List<WorkVO> workList = dao.workList(paraMap);
		return workList;
	}

	// 사용자가 신청한 근무를 근무신청테이블에 insert
	@Override
	public int workRequestInsert(Map<String, String> paraMap) {
		int n = dao.workRequestInsert(paraMap);
		return n;
	}

	// 특정 사용자가 신청한 대기중인 근무신청 가져오기
	@Override
	public List<Work_requestVO> workRequestList(String employee_id) {
		List<Work_requestVO> workRequestList = dao.workRequestList(employee_id);
		return workRequestList;
	}

	// 특정 근무신청 삭제하기
	@Override
	public int work_request_delete(String work_request_seq) {
		int n = dao.work_request_delete(work_request_seq);
		return n;
	}

	// 오늘날짜의 출근시간 얻어오기
	@Override
	public String todayStartTime(Map<String, String> paraMap) {
		String todayStartTime = dao.todayStartTime(paraMap);
		return todayStartTime;
	}

	// 근무테이블에 퇴근시간 update 하기 / 연장근무인 경우
	@Override
	public int goToWorkUpdateWithExtended(Map<String, String> paraMap) {
		int n = dao.goToWorkUpdateWithExtended(paraMap);
		return n;
	}
	
	// 근무테이블에 퇴근시간 update 하기
	@Override
	public int goToWorkUpdate(Map<String, String> paraMap) {
		int n = dao.goToWorkUpdate(paraMap);
		return n;
	}

	// 자신의 부서번호에 따른 이름, 직급명 가져오기
	@Override
	public List<Map<String, String>> myDeptEmp(String fk_department_id) {
		List<Map<String, String>> myDeptEmp = dao.myDeptEmp(fk_department_id);
		return myDeptEmp;
	}

	// employee_id 에 따른 근무내역 가져오기
	@Override
	public List<Map<String, String>> empWorkList(Map<String, String> paraMap) {
		List<Map<String, String>> empWorkList = dao.empWorkList(paraMap);
		return empWorkList;
	}

	// 로그인 한 사원의 부서명 가져오기
	@Override
	public String getMyDeptName(Map<String, String> paraMap) {
		String getMyDeptName = dao.getMyDeptName(paraMap);
		return getMyDeptName;
	}

	// select option 에 필요한 department_id 가져오기 
	@Override
	public List<Map<String, String>> getAllDeptIdList() {
		List<Map<String, String>> getAllDeptIdList = dao.getAllDeptIdList();
		return getAllDeptIdList;
	}

	// 해당 부서 직급, 이름 가져오기
	@Override
	public List<Map<String, String>> deptSelectList(Map<String, String> paraMap) {
		List<Map<String, String>> deptSelectList = dao.deptSelectList(paraMap);
		return deptSelectList;
	}

	// 해당 부서명 가져오기
	@Override
	public String getSelectDeptName(Map<String, String> paraMap) {
		String getSelectDeptName = dao.getSelectDeptName(paraMap);
		return getSelectDeptName;
	}

	// 내 부서원들의 신청한 근무신청 가져오기 (관리자용)
	@Override
	public List<Map<String, String>> myDeptRequestList(Map<String, String> paraMap) {
		List<Map<String, String>> myDeptRequestList = dao.myDeptRequestList(paraMap);
		return myDeptRequestList;
	}
	
	// 내 부서원들의 승인된 근무신청 가져오기 (관리자용)
	@Override
	public List<Map<String, String>> myDeptApprovedList(Map<String, String> paraMap) {
		List<Map<String, String>> myDeptApprovedList = dao.myDeptApprovedList(paraMap);
		return myDeptApprovedList;
	}
	
	// 내 부서원들의 반려된 근무신청 가져오기 (관리자용)
	@Override
	public List<Map<String, String>> myDeptReturnList(Map<String, String> paraMap) {
		List<Map<String, String>> myDeptReturnList = dao.myDeptReturnList(paraMap);
		return myDeptReturnList;
	}

	// 특정 사원의 이번주 누적근무시간 가져오기
	@Override
	public Map<String, String> myWorkRecord(String employee_id) {
		Map<String, String> myWorkRecord = dao.myWorkRecord(employee_id);
		return myWorkRecord;
	}

	// 근무신청 승인하기
	@Override
	public int approveWork(String requestApproveSeq) {
		int n = dao.approveWork(requestApproveSeq);
		return n;
	}

	// 근무신청 반려하기
	@Override
	public int requestReturn(String requestApproveSeq) {
		int n = dao.requestReturn(requestApproveSeq);
		return n;
	}

	// 로그인 한 사원의 오늘 출근시간 가져오기
	@Override
	public String myTodayStartTime(String employee_id) {
		String myTodayStartTime = dao.myTodayStartTime(employee_id);
		return myTodayStartTime;
	}

	// 오늘날짜의 퇴근시간 얻어오기
	@Override
	public String todayEndTime(String fk_employee_id) {
		String todayEndTime = dao.todayEndTime(fk_employee_id);
		return todayEndTime;
	}

	// 출근한 날짜를 가져와 출근한 시간 가져오기 
	@Override
	public Map<String, String> getMyWorkTime(Map<String, String> paraMap) {
		Map<String, String> getMyWorkTime = dao.getMyWorkTime(paraMap);
		return getMyWorkTime;
	}

}

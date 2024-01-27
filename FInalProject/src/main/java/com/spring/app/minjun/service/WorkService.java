package com.spring.app.minjun.service;

import java.util.*;

import com.spring.app.domain.WorkVO;
import com.spring.app.domain.Work_requestVO;

public interface WorkService {

	// 특정 사원의 근무내역 가져오기
	List<WorkVO> my_workList(String employee_id);

	// 출근 버튼 클릭시 근태테이블에 insert 하기
	int goToWorkInsert(Map<String, String> paraMap);

	// 퇴근 버튼 클릭시 근무테이블에 update 하기(ajax로 해봄)
	int leaveWork(Map<String, String> paraMap);

	// 특정 사원의 근무내역 가져오기
	List<WorkVO> workList(Map<String, String> paraMap);
	
	////////////////////////////////////////////////
	// 사용자가 신청한 근무를 근무신청테이블에 insert
	int workRequestInsert(Map<String, String> paraMap);

	// 특정 사용자가 신청한 근무신청 가져오기
	List<Work_requestVO> workRequestList(String employee_id);

	// 특정 근무신청 삭제하기
	int work_request_delete(String work_request_seq);

	// 오늘날짜의 출근시간 얻어오기
	String todayStartTime(Map<String, String> paraMap);

	// 근무테이블에 퇴근시간 update 하기 / 연장근무인 경우
	int goToWorkUpdateWithExtended(Map<String, String> paraMap);
	// 근무테이블에 퇴근시간 update 하기
	int goToWorkUpdate(Map<String, String> paraMap);

	// 내 부서원들의 신청한 대기중인 근무신청 가져오기 (관리자용)
	List<Map<String, String>> myDeptRequestList(Map<String, String> paraMap);

	// 내 부서원들의 승인된 근무신청 가져오기 (관리자용)
	List<Map<String, String>> myDeptApprovedList(Map<String, String> paraMap);

	// 내 부서원들의 반려된 근무신청 가져오기 (관리자용)
	List<Map<String, String>> myDeptReturnList(Map<String, String> paraMap);
	
	///////////////////////////////////////////////////
	// 자신의 부서번호에 따른 이름, 직급명 가져오기
	List<Map<String, String>> myDeptEmp(String fk_department_id);

	// employee_id 에 따른 근무내역 가져오기
	List<Map<String, String>> empWorkList(Map<String, String> paraMap);

	// 로그인 한 사원의 부서명 가져오기
	String getMyDeptName(Map<String, String> paraMap);

	// select option 에 필요한 department_id 가져오기 
	List<Map<String, String>> getAllDeptIdList();

	// 해당 부서 직급, 이름 가져오기
	List<Map<String, String>> deptSelectList(Map<String, String> paraMap);

	// 해당 부서명 가져오기
	String getSelectDeptName(Map<String, String> paraMap);

	// 특정 사원의 이번주 누적근무시간 가져오기
	Map<String, String> myWorkRecord(String employee_id);

	// 근무신청 승인하기
	int approveWork(String requestApproveSeq);
	
	// 근무신청 반려하기
	int requestReturn(String requestApproveSeq);

	// 로그인 한 사원의 오늘 출근시간 가져오기
	String myTodayStartTime(String employee_id);

	// 오늘날짜의 퇴근시간 얻어오기
	String todayEndTime(String fk_employee_id);

	// 출근한 날짜를 가져와 출근한 시간 가져오기 
	Map<String, String> getMyWorkTime(Map<String, String> paraMap);

}

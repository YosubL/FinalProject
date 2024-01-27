package com.spring.app.minjun.service;

import java.util.*;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.servlet.ModelAndView;

import com.spring.app.domain.VacationVO;
import com.spring.app.domain.Vacation_manageVO;


public interface VacationService {

	/////////////////////////////////////////////////////////
	
	// 메인 페이지
	ModelAndView index(ModelAndView mav);

	// 연차 신청시 휴가관리 테이블에 insert하기
	int annual_insert(Map<String, String> paraMap);

	// 특정 회원의 휴가 정보 가져오기
	VacationVO vacation_select(String employee_id);
	
	// 특정 사용자의 반려된 휴가 가져오기
	List<Vacation_manageVO> myReturnList(String employee_id);
	
	// 대기중인 휴가 갯수 알아오기
	String total_count(String employee_id);
	
	// 회원들의 신청된 휴가 중 대기중인 회원 가져오기
	List<Vacation_manageVO> vacList(String employee_id);
	
	// 회원들의 신청된 휴가 중 반려된 회원 가져오기
	List<Vacation_manageVO> vacReturnList(String employee_id);
	 
	// 회원들의 신청된 휴가 중 승인된 회원 가져오기
	List<Vacation_manageVO> vacApprovedList(String employee_id);

	// 휴가 결재시 휴가관리테이블 업데이트 하기
	int vacManage_Update(Map<String, String[]> paraMap) throws Throwable;

	// 특정 사용자의 승인완료된 휴가 가져오기
	List<Vacation_manageVO> myApprovedList(String employee_id);

	// 특정 회원의 신청한 휴가 중 대기중인 휴가 정보 가져오기
	Map<String, String> vacHoldList_one(String vacation_seq);

	// 휴가 반려시 반려테이블에 insert 하기
	int vacInsert_return(Map<String, String> paraMap) throws Throwable;

	// 휴가 재신청 하기 위한 insert
	int vac_insert_insert(Map<String, String> paraMap);

	// 특정 사용자의 승인완료된 휴가 가져오기
	List<Vacation_manageVO> myHoldList(String employee_id);

	// 대기중인 휴가 총 건수 알아오기
	int totalCount(String employee_id);

	// 대기중인휴가의 totalPage 수 알아오기
	int getVactionTotalPage(Map<String, String> paraMap);

	// 승인 대기중인 휴가 삭제하기
	void seq_delete(String vacation_seq);

	// 차트그리기 (ajax) 월별 휴가사용 수
	List<Map<String, String>> monthlyVacCnt();

}

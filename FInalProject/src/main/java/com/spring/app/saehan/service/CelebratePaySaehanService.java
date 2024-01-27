package com.spring.app.saehan.service;

import java.util.List;
import java.util.Map;

import com.spring.app.common.Pagination;
import com.spring.app.domain.CelebratePayVO;
import com.spring.app.domain.DepartmentVO;

public interface CelebratePaySaehanService {

	//복지포인트 신청
	int receiptCelebrate(CelebratePayVO cvo); 
			
	//특정 사용자의 복지포인트 신청 대기 목록 가져오기
	List<CelebratePayVO> CelebratePay_HoldList(String employee_id);
			
	//특정 사용자의 복지포인트 신청 승인 완료 목록 가져오기
	List<CelebratePayVO> CelebratePay_completeList(String employee_id);
			
	//특정 사용자의 반려된 복지포인트 목록 가져오기
	List<CelebratePayVO> CelebratePay_rejectList(String employee_id);
		
	//승인 대기중인 복지포인트 신청 한 개 삭제하기
	void celebrate_delete(String app_no);

	//부서이름 가져오기
	List<Map<String, String>> deptName();

	//관리자 직원관리 - 모든 복지포인트 결제 대기 신청 현황
	List<CelebratePayVO> getCelebrateStatus(Map<String, String> paraMap);
		
	//승인시 복지포인트 테이블 업데이트 하기.
	int CelebrateStatus_Update(Map<String, String[]> paraMap); 

	//반려시 복지포인트 테이블 업데이트 하기.
	int CelebrateStatus_reject(Map<String, String[]> paraMap);

	//관리자 직원관리 - 모든 복지포인트 결제 완료 현황
	List<CelebratePayVO> getCelebrateComplete(Map<String, String> paraMap);
		
	//관리자 직원 관리 - 모든 복지포인트 결제 취소 하기
	int CelebrateStatus_close(Map<String, String[]> paraMap);




	
}

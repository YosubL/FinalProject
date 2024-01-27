package com.spring.app.saehan.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.spring.app.domain.CelebratePayVO;
import com.spring.app.saehan.model.CelebratePaySaehanDAO;


@Repository
@Service
public class CelebratePaySaehanService_imple implements CelebratePaySaehanService{

	@Autowired 
	private CelebratePaySaehanDAO dao;
	
	//복지포인트 신청
	@Override
	public int receiptCelebrate(CelebratePayVO cvo) {
		int n = dao.receiptCelebrate(cvo);
		return n;
	}

	//특정 사용자의 복지포인트 신청 대기 목록 가져오기
	@Override
	public List<CelebratePayVO> CelebratePay_HoldList(String employee_id) {
		List<CelebratePayVO>CelebratePay_HoldList = dao.CelebratePay_HoldList(employee_id);
		return CelebratePay_HoldList;
	}
	
	//특정 사용자의 복지포인트 신청 승인 완료 목록 가져오기
	@Override
	public List<CelebratePayVO> CelebratePay_completeList(String employee_id) {
		List<CelebratePayVO>CelebratePay_completeList = dao.CelebratePay_completeList(employee_id);
		return CelebratePay_completeList;
	}
	
	//특정 사용자의 반려된 복지포인트 목록 가져오기
	@Override
	public List<CelebratePayVO> CelebratePay_rejectList(String employee_id) {
		List<CelebratePayVO>CelebratePay_rejectList = dao.CelebratePay_rejectList(employee_id);
		return CelebratePay_rejectList;
	}
	
	//승인 대기중인 복지포인트 신청 한 개 삭제하기
	@Override
	public void celebrate_delete(String app_no) {
		dao.celebrate_delete(app_no);
	}

	//부서이름 가져오기
	@Override
	public List<Map<String, String>> deptName() {
		List<Map<String, String>> deptNameList = dao.deptName();
		return deptNameList;
	}

	
	//관리자 직원관리 - 모든 복지포인트 결제 대기 신청 현황
	@Override
	public List<CelebratePayVO> getCelebrateStatus(Map<String, String> paraMap) {
		List<CelebratePayVO> CelebrateStatusList = dao.getCelebrateStatus(paraMap);
		return CelebrateStatusList;
	}

	
	//승인시 복지포인트 테이블 업데이트 하기.
	@Override
	public int CelebrateStatus_Update(Map<String, String[]> paraMap) {
		int n1=0;
		
		String[] clbList = paraMap.get("app_no_arr");
		
		for(int i=0; i<clbList.length; i++) {
			
			String app_no = paraMap.get("app_no_arr")[i];
			n1 = dao.CelebrateStatus_Update2(app_no); // 휴가 관리 테이블에서 vacation_confirm 컬럼을 2로 업데이트
			
		}

		return n1;
	}


	//반려시 복지포인트 테이블 업데이트 하기.
	@Override
	public int CelebrateStatus_reject(Map<String, String[]> paraMap) {
		int n1=0;
		
		String[] clbList = paraMap.get("app_no_arr");
		
		for(int i=0; i<clbList.length; i++) {
			
			String app_no = paraMap.get("app_no_arr")[i];
			n1 = dao.CelebrateStatus_reject(app_no); // 휴가 관리 테이블에서 vacation_confirm 컬럼을 2로 업데이트
			
		}
		return n1;
	}

	//관리자 직원관리 - 모든 복지포인트 결제 완료 현황
	@Override
	public List<CelebratePayVO> getCelebrateComplete(Map<String, String> paraMap) {
		List<CelebratePayVO> CelebrateCompleteList = dao.getCelebrateComplete(paraMap);
		return CelebrateCompleteList;
	}
	
	//관리자 직원 관리 - 모든 복지포인트 결제 취소 하기
	@Override
	public int CelebrateStatus_close(Map<String, String[]> paraMap) {
		int n1=0;
		
		String[] clbList = paraMap.get("app_no_arr");
		
		for(int i=0; i<clbList.length; i++) {
			
			String app_no = paraMap.get("app_no_arr")[i];
			n1 = dao.CelebrateStatus_close(app_no);
			
		}
		return n1;
	}

	
	
	



	
	


	

}

package com.spring.app.saehan.model;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.spring.app.common.Pagination;
import com.spring.app.domain.CelebratePayVO;
import com.spring.app.domain.DepartmentVO;
import com.spring.app.domain.NoticeboardVO;

@Repository
public class CelebratePaySaehanDAO_imple implements CelebratePaySaehanDAO{

	@Resource
	private SqlSessionTemplate sqlsession;

	//복지포인트 신청하기
	@Override
	public int receiptCelebrate(CelebratePayVO cvo) {
		int n = sqlsession.insert("saehan.receiptCelebrate", cvo);
		return n;
	}

	//특정사용자의 복지포인트 신청 대기 목록 가져오기
	@Override
	public List<CelebratePayVO> CelebratePay_HoldList(String employee_id) {
		List<CelebratePayVO> CelebratePay_HoldList = sqlsession.selectList("saehan.CelebratePay_HoldList", employee_id);
		return CelebratePay_HoldList;
	}
	
	//특정사용자의 복지포인트 신청 승인 완료 목록 가져오기
	@Override
	public List<CelebratePayVO> CelebratePay_completeList(String employee_id) {
		List<CelebratePayVO> CelebratePay_completeList = sqlsession.selectList("saehan.CelebratePay_completeList", employee_id);
		return CelebratePay_completeList;
	}
	
	//특정 사용자의 반려된 복지포인트 목록 가져오기
	@Override
	public List<CelebratePayVO> CelebratePay_rejectList(String employee_id) {
		List<CelebratePayVO> CelebratePay_rejectList = sqlsession.selectList("saehan.CelebratePay_rejectList", employee_id);
		return CelebratePay_rejectList;
	}
	
	// 승인 대기중인 복지포인트 신청 한 개 삭제하기
	@Override
	public void celebrate_delete(String app_no) {
		sqlsession.delete("saehan.celebrate_delete", app_no);
	}
	
	//부서 이름 가져오기
	@Override
	public List<Map<String, String>> deptName() {
		List<Map<String, String>> deptNameList = sqlsession.selectList("saehan.deptName");
		return deptNameList;
	}
	
	//관리자 직원관리 - 모든 복지포인트 결제 대기 신청 현황
	@Override
	public List<CelebratePayVO> getCelebrateStatus(Map<String, String> paraMap) {
		List<CelebratePayVO> CelebrateStatusList =sqlsession.selectList("saehan.CelebrateStatus",paraMap);
		return CelebrateStatusList;
	}

	//승인시 복지포인트 테이블 업데이트 하기.
	@Override
	public int CelebrateStatus_Update2(String app_no) {
		int n = sqlsession.update("saehan.CelebrateStatus_Update",app_no);
		return n;
	}
	
	//반려시 복지포인트 테이블 업데이트 하기.
	@Override
	public int CelebrateStatus_reject(String app_no) {
		int n = sqlsession.update("saehan.CelebrateStatus_reject",app_no);
		return n;
	}
	
	//관리자 직원관리 - 모든 복지포인트 결제 완료 현황
	@Override
	public List<CelebratePayVO> getCelebrateComplete(Map<String, String> paraMap) {
		List<CelebratePayVO> CelebrateCompleteList =sqlsession.selectList("saehan.getCelebrateComplete",paraMap);
		return CelebrateCompleteList;
	}

	
	//관리자 직원 관리 - 모든 복지포인트 결제 취소 하기
	@Override
	public int CelebrateStatus_close(String app_no) {
		int n = sqlsession.update("saehan.CelebrateStatus_close",app_no);
		return n;
	}
	

	
	




}

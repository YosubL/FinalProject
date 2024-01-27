package com.spring.app.yunsu.model;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.spring.app.domain.ReservLargeCategoryVO;
import com.spring.app.domain.ReservSmallCategoryVO;
import com.spring.app.domain.ReservationVO;

@Repository
public class ReservationDAO_imple implements ReservationDAO {

	@Resource
	private SqlSessionTemplate sqlsession;

	/////////////////////////////////////////////////////////////////////////////
	
	// 자원 항목 불러오기
	@Override
	public List<ReservSmallCategoryVO> selectSmallCategory(Map<String, String> paraMap) {
		List<ReservSmallCategoryVO> smallCategList = sqlsession.selectList("yunsu.selectSmallCategory2", paraMap);
		return smallCategList;
	}

	
	// === 자원 예약하기 === 
	@Override
	public int addReservation(Map<String, String> paraMap) {
		int n = sqlsession.insert("yunsu.addReservation", paraMap);
		return n;
	}

	
	// 선택한 날짜에 따른 예약된 시간 가져오기
	@Override
	public List<ReservationVO> reservTime(Map<String, String> paraMap) {
		List<ReservationVO> reservTimeList = sqlsession.selectList("yunsu.reservTime", paraMap);
		return reservTimeList;
	}

	
	// 예약일자에 예약이 존재하는지 여부 확인
	@Override
	public int existReservation(Map<String, String> paraMap) {
		int m = sqlsession.selectOne("yunsu.existReservation", paraMap);
		return m;
	}

	
	// 예약 내역 전체 개수 구하기
	@Override
	public int getResrvAdminSearchCnt(Map<String, Object> paraMap) {
		int n = sqlsession.selectOne("yunsu.getResrvAdminSearchCnt", paraMap);
		return n;
	}


	// 한 페이지에 표시할 관리자 예약 내역 글 목록
	@Override
	public List<Map<String, String>> getResrvAdminList(Map<String, Object> paraMap) {
		List<Map<String,String>> reservList = sqlsession.selectList("yunsu.getResrvAdminList", paraMap);
		return reservList;
	}

	
	// 관리자 예약 내역 확인에서 예약 상태 가져오기
	@Override
	public List<ReservationVO> statusButton() {
		List<ReservationVO> statusList = sqlsession.selectList("yunsu.statusButton");
		return statusList;
	}


	// 자원 예약 승인 메소드
	@Override
	public int reservConfirm(Map<String, String> paraMap) {
		int n = sqlsession.update("yunsu.reservConfirm", paraMap);
		return n;
	}


	// 자원 예약 취소 메소드
	@Override
	public int reservCancle(Map<String, String> paraMap) {
		int n = sqlsession.update("yunsu.reservCancle", paraMap);
		return n;
	}


	// 자원 반납 메소드
	@Override
	public int reservReturn(Map<String, String> paraMap) {
		int n = sqlsession.update("yunsu.reservReturn", paraMap);
		return n;
	}


	// 예약 내역 상세보기
	@Override
	public Map<String, String> viewReservation(Map<String, String> paraMap) {
		Map<String, String> map = sqlsession.selectOne("yunsu.viewReservation", paraMap);
		return map;
	}


	// 이용자 예약 내역 전체 개수 구하기
	@Override
	public int getResrvSearchCnt(Map<String, Object> paraMap) {
		int n = sqlsession.selectOne("yunsu.getResrvSearchCnt", paraMap);
		return n;
	}

	
	// 한 페이지에 표시할 이용자 예약 내역 글 목록
	@Override
	public List<Map<String, String>> getResrvList(Map<String, Object> paraMap) {
		List<Map<String,String>> reservList = sqlsession.selectList("yunsu.getResrvList", paraMap);
		return reservList;
	}


	// 자원 목록
	@Override
	public List<Map<String, String>> managementResource() {
		List<Map<String,String>> resourceList = sqlsession.selectList("yunsu.managementResource");
		return resourceList;
	}


	// 자원명 수정 메소드
	@Override
	public int editSmcatgoname(Map<String, String> paraMap) {
		int n = sqlsession.update("yunsu.editSmcatgoname", paraMap);
		return n;
	}


	// 자원 추가 메소드
	@Override
	public int addSmcatgo(Map<String, String> paraMap) {
		int n = sqlsession.insert("yunsu.addSmcatgo", paraMap);
		return n;
	}


	// 자원 상태 변경 메소드
	@Override
	public int changeStatus(Map<String, String> paraMap) {
		int n = sqlsession.insert("yunsu.changeStatus", paraMap);
		return n;
	}


	// 버튼 클릭 시 자원 항목 리스트 변경 메소드
	@Override
	public List<Map<String, String>> resourceFilter(Map<String, String> paraMap) {
		List<Map<String,String>> resourceList = sqlsession.selectList("yunsu.resourceFilter", paraMap);
		return resourceList;
	}


	// 예약 안내 페이지 수정
	@Override
	public ReservLargeCategoryVO editResourceContent(Map<String, String> paraMap) {
		ReservLargeCategoryVO lvo = sqlsession.selectOne("yunsu.editResourceContent", paraMap);
		return lvo;
	}


	// 자원 안내 수정 최종
	@Override
	public int endEditResourceContent(Map<String, String> paraMap) {
		int n = sqlsession.update("yunsu.endEditResourceContent", paraMap);
		return n;
	}


	// 자원 안내 내용 보여주기
	@Override
	public ReservLargeCategoryVO mainLgcategContent(String lgcatgono) {
		ReservLargeCategoryVO lvo = sqlsession.selectOne("yunsu.mainLgcategContent", lgcatgono);
		return lvo;
	}

	
	// 자원예약 승인한 회원 정보 가져오기
	@Override
	public Map<String, String> reservConfirmSelect(Map<String, String> paraMap) {
		Map<String,String> confirmMap = sqlsession.selectOne("yunsu.reservConfirmSelect", paraMap);
		return confirmMap;
	}

	
	// 관리자 일때 승인 취소로 바꿔주기
	@Override
	public int adminreservCancle(Map<String, String> paraMap) {
		int n = sqlsession.update("yunsu.adminreservCancle", paraMap);
		return n;
	}


	@Override
	public List<Map<String, String>> meetingroomchart() {
		List<Map<String, String>> list = sqlsession.selectList("yunsu.meetingroomchart");
		return list;
	}

	
	
	
	
	
	
	
	
	
	
	
	
	
}

package com.spring.app.yosub.model;


import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.mybatis.spring.SqlSessionTemplate;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import com.spring.app.digitalmail.domain.EmailVO;
import com.spring.app.domain.Calendar_schedule_VO;
import com.spring.app.domain.DraftVO;
import com.spring.app.domain.EmployeesVO;

//==== #32. Repository(DAO) 선언 ====
//@Component
@Repository
public class YosubDAO_imple implements YosubDAO {

	@Resource
	private SqlSessionTemplate sqlsession;
	
	
	// ==== 로그인 처리하기 ==== //
	@Override
	public EmployeesVO getLoginMember(Map<String, String> paraMap) {
		
		EmployeesVO loginuser = sqlsession.selectOne("yosub.getLoginMember", paraMap);
		return loginuser;
	}

	// tbl_member 테이블의 idle 컬럼의 값을 1로 변경하기
	@Override
	public int updateIdle(String email) {
		int n = sqlsession.update("yosub.updateIdle", email);
		return n;
	}

	@Override
	public int getRequestedDraftCnt(Map<String, Object> paraMap) {
	
		int n = sqlsession.selectOne("yosub.getRequestedDraftCnt", paraMap);
		
		return n;
	
	}

	@Override
	public List<Calendar_schedule_VO> scheduleselect(Map<String, Object> paraMap) {

		List<Calendar_schedule_VO> scheduleselectList = sqlsession.selectList("yosub.scheduleselect", paraMap);
		
		return scheduleselectList;
	}


	@Override
	public List<EmailVO> SelectMyEmail_withPaging(Map<String, Object> paraMap) {
		
		List<EmailVO> emailVOList = sqlsession.selectList("yosub.SelectMyEmail_withPaging",paraMap);
		
		return emailVOList;
	}

	@Override
	public List<DraftVO> getMyDraftProcessing(String empno) {
		return sqlsession.selectList("approval.getMyDraftProcessing", empno);
	}

	@Override
	public List<DraftVO> getMyDraftProcessed(String empno) {
		return sqlsession.selectList("approval.getMyDraftProcessed", empno);
	}



	
	
	
	
	
}

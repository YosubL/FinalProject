package com.spring.app.jinyoung.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.spring.app.domain.ApprovalVO;
import com.spring.app.domain.BiztripReportVO;
import com.spring.app.domain.DraftFileVO;
import com.spring.app.domain.DraftVO;
import com.spring.app.domain.ExpenseListVO;
import com.spring.app.jinyoung.model.ApprovalDAO;
import com.spring.app.domain.OfficialAprvLineVO;
import com.spring.app.domain.SavedAprvLineVO;
import com.spring.app.common.FileManager;
import com.spring.app.domain.EmployeesVO;

@Service
public class ApprovalService_imple implements ApprovalService {

	private ApprovalDAO dao;
	private FileManager fileManager;
	
    @Autowired
    public ApprovalService_imple(ApprovalDAO dao, FileManager fileManager) {
        this.dao = dao;
        this.fileManager = fileManager;
    }
	
    // 팀 문서함 게시글 수 조회
	@Override
	public int getTeamDraftCnt(Map<String, Object> paraMap) {
		return dao.getTeamDraftCnt(paraMap);
	}

	// 팀 문서함 목록 조회
	@Override
	public List<DraftVO> getTeamDraftList(Map<String, Object> paraMap) {
		return dao.getTeamDraftList(paraMap);
	}

	// 상신함 게시글 수 조회
	@Override
	public int getSentDraftCnt(Map<String, Object> paraMap) {
		return dao.getSentDraftCnt(paraMap);
	}

	// 상신함 목록 조회
	@Override
	public List<DraftVO> getSentDraftList(Map<String, Object> paraMap) {
		return dao.getSentDraftList(paraMap);
	}

	// 결재함 게시글 수 조회
	@Override
	public int getProcessedDraftCnt(Map<String, Object> paraMap) {
		return dao.getProcessedDraftCnt(paraMap);
	}
	
	// 결재함 목록 조회
	@Override
	public List<DraftVO> getProcessedDraftList(Map<String, Object> paraMap) {
		return dao.getProcessedDraftList(paraMap);
	}
	
	// 임시저장함 게시글 수 조회
	@Override
	public int getSavedDraftCnt(Map<String, Object> paraMap) {
		return dao.getSavedDraftCnt(paraMap);
	}
	
	// 임시저장함 목록 조회
	@Override
	public List<DraftVO> getSavedDraftList(Map<String, Object> paraMap) {
		return dao.getSavedDraftList(paraMap);
	}

	// 임시저장함 게시글 삭제
	@Override
	public int deleteDraftList(String[] deleteArr) {
		return dao.deleteDraftList(deleteArr);
	}

	// 진행중 문서 5개 가져오기
	@Override
	public List<DraftVO> getMyDraftProcessing(String empno) {
		return dao.getMyDraftProcessing(empno);
	}
	
	// 결재완료 문서 5개 가져오기
	@Override
	public List<DraftVO> getMyDraftProcessed(String empno) {
		return dao.getMyDraftProcessed(empno);
	}

	// 결재 대기 문서의 문서번호들 조회
	@Override
	public List<String> getRequestedDraftNo(Map<String, Object> paraMap) {
		return dao.getRequestedDraftNo(paraMap);
	}
	
	// 결재대기문서 전체 글 개수 조회
	@Override
	public int getRequestedDraftCnt(Map<String, Object> paraMap) {
		return dao.getRequestedDraftCnt(paraMap);
	}

	// 결재대기문서 페이징처리한 리스트 조회
	@Override
	public List<DraftVO> getRequestedDraftList(Map<String, Object> paraMap) {
		return dao.getRequestedDraftList(paraMap);
	}
	
	// 결재 예정 문서의 문서번호들 조회
	@Override
	public List<Object> getUpcomingDraftNo(Map<String, Object> paraMap) {
		return dao.getUpcomingDraftNo(paraMap);
	}
	
	// 결재 예정 문서 전체 글 개수 조회
	@Override
	public int getUpcomingDraftCnt(Map<String, Object> paraMap) {
		return dao.getUpcomingDraftCnt(paraMap);
	}

	// 결재 예정 문서 페이징처리한 리스트 조회
	@Override
	public List<DraftVO> getUpcomingDraftList(Map<String, Object> paraMap) {
		return dao.getUpcomingDraftList(paraMap);
	}

	// 사원 목록 가져오기
	@Override
	public List<Map<String, String>> getEmpList(Map<String, Object> paraMap) {
		return dao.getEmpList(paraMap);
	}
	
	// 부서 목록 가져오기
	@Override
	public List<Map<String, String>> getDeptList(Map<String, Object> paraMap) {
		return dao.getDeptList(paraMap);
	}

	// 부서 목록 가져오기
	@Override
	public List<Map<String, String>> getTeamList(Map<String, Object> paraMap) {
		return dao.getTeamList(paraMap);
	}

	// 환경설정 - 결재라인 저장
	@Override
	public int saveApprovalLine(SavedAprvLineVO sapVO) {
		return dao.saveApprovalLine(sapVO);
	}

	// 환경설정-결재라인 수정
	@Override
	public int editApprovalLine(SavedAprvLineVO sapVO) {
		return dao.editApprovalLine(sapVO);
	}
	
	// 환경설정-결재라인 삭제
	@Override
	public int delApprovalLine(SavedAprvLineVO sapVO) {
		return dao.delApprovalLine(sapVO);
	}

	// 저장된 결재라인 불러오기
	@Override
	public List<SavedAprvLineVO> getSavedAprvLine(Map<String, String> paraMap) {
		return dao.getSavedAprvLine(paraMap);
	}

	// 저장된 결재라인 결재자 정보 가져오기
	@Override
	public List<EmployeesVO> getSavedAprvEmpInfo(List<String> empnoList) {
		return dao.getSavedAprvEmpInfo(empnoList);
	}

	// 저장된 결재라인 한개 불러오기
	@Override
	public List<EmployeesVO> getOneAprvLine(String aprv_line_no) {
		return dao.getOneAprvLine(aprv_line_no);
	}

	// 업무기안 작성하기(트랜잭션)
	@Override
	@SuppressWarnings("unchecked")
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})
	public boolean addDraft(Map<String, Object> paraMap) {
		
		int n = 0;
		boolean result = false;
		
		// 임시저장 번호가 있을 경우
		String temp_draft_no = (String) paraMap.get("temp_draft_no");
		if (temp_draft_no != null && !"".equals(temp_draft_no)) {
			// 임시저장 문서 삭제
			n = dao.deleteTempDraft(temp_draft_no);
			
			if (n != 1)
				return result;
		}

		// 기안문서 번호 생성
		String draft_no = getDraftNo();

		DraftVO dvo = (DraftVO)paraMap.get("dvo");
		dvo.setDraft_no(draft_no); // 생성된 기안번호 set
		
		// 기안 테이블 insert
		n = dao.addDraft(dvo);
		result = (n == 1)? true : false;

		// 기안 테이블 insert가 실패했으면 리턴
		if (!result)
			return result;
		
		// 결재 정보 리스트
		List<ApprovalVO> apvoList = (List<ApprovalVO>) paraMap.get("apvoList");
		
		for (ApprovalVO apvo : apvoList) {
			apvo.setFk_draft_no(draft_no); // 기안번호 set하기
		}
		
		// 결재 테이블 insert
		n = dao.addApproval(apvoList);
		result = (n == apvoList.size())? true : false;
		
		// 결재테이블 insert가 실패했으면 리턴
		if (!result)
			return result;
		
		// 첨부 파일 리스트
		List<DraftFileVO> fileList = (List<DraftFileVO>) paraMap.get("fileList");
		
		// 첨부파일이 있다면
		if (fileList != null && fileList.size() > 0) {
			for (DraftFileVO dfvo : fileList) {
				dfvo.setFk_draft_no(draft_no); // 기안번호 set하기
			}
			
			// 첨부 파일 insert
			n = dao.addFiles(fileList);
			result = (n == fileList.size())? true : false;
			
			// 첨부 파일 테이블 insert가 실패했으면 리턴
			if (!result)
				return result;
		}
		
		// 지출내역 리스트
		List<ExpenseListVO> evoList = (List<ExpenseListVO>) paraMap.get("evoList");
		
		// 지출내역이  있다면
		if (evoList != null && evoList.size() > 0) {
			for (ExpenseListVO evo : evoList) {
				evo.setFk_draft_no(draft_no); // 기안번호 set하기
			}
			
			// 지출내역 insert
			n = dao.addExpenseList(evoList);
			result = (n == evoList.size())? true : false;
			
			// 지출내역 테이블 insert가 실패했으면 리턴
			if (!result)
				return result;
		}
		
		// 출장보고서라면
		BiztripReportVO brvo = (BiztripReportVO)paraMap.get("brvo");
		if (dvo.getFk_draft_type_no() == 3) {
			brvo.setFk_draft_no(draft_no); // 기안번호 set하기
			
			// 출장보고 insert
			n = dao.addBiztripReport(brvo);
			result = (n == 1)? true : false;
			
			// 출장보고 테이블 insert가 실패했으면 리턴
			if (!result)
				return result;
		}
		
		return result;
	}

	// 기안문서번호 생성하기
	private String getDraftNo() {
		Calendar currentDate = Calendar.getInstance(); // 현재날짜와 시간
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
		String currentTime = dateFormat.format(currentDate.getTime());
		
		// 시퀀스 번호 얻어오기
		int seq = dao.getDraftNo();
		
		// 기안문서번호 생성 (날짜-시퀀스번호)
		String draft_no = currentTime + "-" + seq;
		return draft_no;
	}
	
	// 업무기안 임시저장하기(트랜잭션)
	@SuppressWarnings("unchecked")
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})
	public String saveTempDraft(Map<String, Object> paraMap) {

		int n = 0;
		boolean result = false;
		
		DraftVO dvo = (DraftVO)paraMap.get("dvo");
		String temp_draft_no = dvo.getDraft_no();
		
		// 기존에 임시저장되었던 글이 아니라면
		if (temp_draft_no == null || "".equals(temp_draft_no)) {

			// 임시저장 번호 시퀀스 가져오기
			temp_draft_no = dao.getTempDraftNo();
			dvo.setDraft_no(temp_draft_no);
		}
		
		// 기안 문서 임시저장
		n = dao.addTempDraft(dvo);
		result = (n == 1)? true : false;
		
		// 결재 정보 리스트
		List<ApprovalVO> apvoList = (List<ApprovalVO>) paraMap.get("apvoList");

		// 결재 정보가 있다면
		if (result && apvoList != null) {
			for (ApprovalVO apvo : apvoList)
				apvo.setFk_draft_no(temp_draft_no); // 기안번호 set하기
			
			// 기존에 저장된 결재정보 조회
			List<ApprovalVO> preApvoList = dao.getTempApprovalInfo(dvo);
			if (preApvoList != null && preApvoList.size() > 0) {
				// 기존 결재정보 삭제
				n = dao.deleteAprvList(temp_draft_no);
				
				result = (n == preApvoList.size())? true : false;
			}
			
			if (result) {
				// 결재 테이블 insert
				n = dao.addTempApproval(apvoList);
				result = (n == apvoList.size())? true : false;
			}
		}
		
		// 지출내역 리스트
		List<ExpenseListVO> evoList = (List<ExpenseListVO>) paraMap.get("evoList");
		
		// 지출내역이  있다면
		if (result && evoList != null) {
			for (ExpenseListVO evo : evoList) {
				evo.setFk_draft_no(temp_draft_no); // 임시기안번호 set하기
			}
			
			// 기존에 저장된 지출내역 조회
			List<ExpenseListVO> preEvoList = dao.getTempExpenseListInfo(dvo);
			if (preEvoList != null && preEvoList.size() > 0) {
				// 기존 지출내역 삭제
				n = dao.deleteEvoList(temp_draft_no);
				
				result = (n == preEvoList.size())? true : false;
			}
			
			// 지출내역 insert
			n = dao.addTempExpenseList(evoList);
			result = (n == evoList.size())? true : false;
		}
		
		// 출장보고서라면
		BiztripReportVO brvo = (BiztripReportVO)paraMap.get("brvo");
		if (result && dvo.getFk_draft_type_no() == 3) {
			brvo.setFk_draft_no(temp_draft_no); // 임시기안번호 set하기
			
			// 출장보고 insert
			n = dao.addTempBiztripReport(brvo);
			result = (n == 1)? true : false;
		}
		
		return (result)? temp_draft_no: null;
	}
	
	// 30일 지난 임시저장 글 삭제하기
	@Override
	@Scheduled(cron="0 0 0 * * *")
	public void autoDeleteSavedDraft() {
		dao.autoDeleteSavedDraft();
	}

	// 기안문서 상세 조회
	@Override
	public Map<String, Object> getDraftDetail(DraftVO dvo) {
				
		Map<String, Object> draftMap = new HashMap<String, Object>();
		
		// draft에서 select
		dvo = dao.getDraftInfo(dvo);
		
		// 에디터로 작성한 내용은 태그를 되돌린다.
		draftMap.put("dvo", dvo);
		
		// approval에서 select
		List<ApprovalVO> avoList = dao.getApprovalInfo(dvo);
		draftMap.put("avoList", avoList);
		
		// 내부 결재자 리스트
		List<ApprovalVO> internalList = new ArrayList<ApprovalVO>();
		
		// 외부 결재자 리스트
		List<ApprovalVO> externalList = new ArrayList<ApprovalVO>();
		
		for(ApprovalVO avo : avoList) {
			if (avo.getOutside() == 0) {
				internalList.add(avo);
			}
			else {
				externalList.add(avo);
			}
		}
		draftMap.put("internalList", internalList);
		draftMap.put("externalList", externalList);
		
		// file에서 select
		List<DraftFileVO> dfvoList = dao.getDraftFileInfo(dvo);
		draftMap.put("dfvoList", dfvoList);
		
		// 지출결의서라면
		if (dvo.getFk_draft_type_no() == 2) {
			List<ExpenseListVO> evoList = dao.getExpenseListInfo(dvo);
			draftMap.put("evoList", evoList);
		}
		
		// 출장보고서라면
		if (dvo.getFk_draft_type_no() == 3) {
			BiztripReportVO brvo = dao.getBiztripReportInfo(dvo);
			draftMap.put("brvo", brvo);
		}
		
		return draftMap;
	}
	
	// 기안문서 조회
	@Override
	public DraftVO getDraftInfo(DraftVO dvo) {
		return dao.getDraftInfo(dvo);
	}

	// 결재단계 사원번호 조회
	@Override
	public String checkApproval(ApprovalVO avo) {
		return dao.checkApproval(avo);
	}
	
	// 자신의 다음 결재단계 조회
	@Override
	public int checkApprovalProxy(ApprovalVO avo) {
		return dao.checkApprovalProxy(avo);
	}

	// 결재 처리하기
	@Override
	public boolean updateApproval(ApprovalVO avo) {
		Map<String, Object> approvalMap = new HashMap<String, Object>();
		approvalMap.put("avo", avo); // IN 파라미터
		approvalMap.put("o_updateCnt", 0); // OUT 파라미터
		
		int n = dao.updateApproval(approvalMap);
		
		return n > 0? true: false; 
	}

	// JOIN 을 통해 가져올 로그인한 유저의 정보
	@Override
	public EmployeesVO getLoginuser(String empno) {
		return dao.getLoginuser(empno);
	}
	
	// 기안종류번호로 공통결재라인(수신처) 가져오기
	@Override
	public List<EmployeesVO> getRecipientList(String type_no) {
		return dao.getRecipientList(type_no);
	}
	
	// 관리자메뉴-공통결재라인 번호로 결재라인 조회하기
	@Override
	public List<EmployeesVO> getOneOfficialAprvLine(String official_aprv_line_no) {
		return dao.getOneOfficialAprvLine(official_aprv_line_no);
	}

	// 첨부파일 1개 조회
	@Override
	public DraftFileVO getOneAttachedFile(String draft_file_no) {
		return dao.getOneAttachedFile(draft_file_no);
	}

	// 모든 첨부파일 조회
	@Override
	public List<DraftFileVO> getAllAttachedFile(String draft_no) {
		return dao.getAllAttachedFile(draft_no);
	}

	// 공통결재라인 목록 불러오기
	@Override
	public List<Map<String, String>> getOfficialAprvList() {
		return dao.getOfficialAprvList();
	}

	// 공통결재라인 없는 양식 목록 불러오기
	@Override
	public List<Map<String, String>> getNoOfficialAprvList() {
		return dao.getNoOfficialAprvList();
	}
	
	// 관리자메뉴-공통결재라인 삭제하기
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})
	public boolean delOfficialAprvLine(Map<String, String> paraMap) {
		
		String official_aprv_line_no = paraMap.get("official_aprv_line_no"); 
		String draft_type_no = paraMap.get("draft_type_no"); 
		
		// 결재라인 삭제
		int n = dao.delOfficialAprvLine(official_aprv_line_no);
		
		if (n != 1)
			return false;
		
		// 공통결재라인 사용 안함으로 바꾸기
		n = dao.setNoUseOfficialAprvLine(draft_type_no);
		
		return (n==1)? true: false;
	}

	// 공통결재라인 여부 사용으로 변경하기
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})
	public int setUseOfficialLine(String draft_type_no) {
		int n = dao.setUseOfficialLine(draft_type_no);
				
		if (n == 1) {

			int official_aprv_line_no = dao.getNewOfficialLineNo();
			
			// 공통결재선 기본값으로 추가하기
			OfficialAprvLineVO oapVO = new OfficialAprvLineVO();
			oapVO.setOfficial_aprv_line_no(official_aprv_line_no);
			oapVO.setFk_draft_type_no(Integer.parseInt(draft_type_no));
			oapVO.setFk_approval_empno1("10000");
			
			n = dao.saveOfficialApprovalLine(oapVO);
		}
		
		return (n == 1)? 1: 0;
	}

	// 관리자메뉴-공통결재라인 저장
	@Override
	public int saveOfficialApprovalLine(OfficialAprvLineVO oapVO) {
		return dao.saveOfficialApprovalLine(oapVO);
	}
	
	// 환경설정-서명이미지 수정
	@Override
	public int updateSignature(Map<String, String> paraMap) {
		return dao.updateSignature(paraMap);
	}

	// 임시저장 문서 조회
	@Override
	public Map<String, Object> getTempDraftDetail(DraftVO dvo) {
				
		Map<String, Object> draftMap = new HashMap<String, Object>();
		
		// temp_draft에서 select
		dvo = dao.getTempDraftInfo(dvo);
		
		draftMap.put("dvo", dvo);
		
		// approval에서 select
		List<ApprovalVO> avoList = dao.getTempApprovalInfo(dvo);
		draftMap.put("avoList", avoList);
		
		// 결재자 정보가 저장되어 있다면
		if (avoList.size() > 0) {
			// 내부 결재자 리스트
			List<ApprovalVO> internalList = new ArrayList<ApprovalVO>();
			
			// 외부 결재자 리스트
			List<ApprovalVO> externalList = new ArrayList<ApprovalVO>();
			
			for(ApprovalVO avo : avoList) {
				if (avo.getOutside() == 0) {
					internalList.add(avo);
				}
				else {
					externalList.add(avo);
				}
			}
			draftMap.put("internalList", internalList);
			draftMap.put("externalList", externalList);
		}
		
		// 지출결의서라면
		if (dvo.getFk_draft_type_no() == 2) {
			List<ExpenseListVO> evoList = dao.getTempExpenseListInfo(dvo);
			draftMap.put("evoList", evoList);
		}
		
		// 출장보고서라면
		if (dvo.getFk_draft_type_no() == 3) {
			BiztripReportVO brvo = dao.getTempBiztripReportInfo(dvo);
			draftMap.put("brvo", brvo);
		}
		
		return draftMap;
	}

	// 기안 상신취소하기
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})
	public boolean cancelDraft(DraftVO dvo) {
		
		// 상신 취소 가능한 상태인지 조회
		List<ApprovalVO> avoList = dao.getApprovalInfo(dvo);
		for(ApprovalVO avo : avoList) {
			if (avo.getApproval_status() != 0)
				return false;
		}
		
		int n = 0;
		
		// 임시저장 번호 시퀀스 가져오기
		String temp_draft_no = dao.getTempDraftNo();
		
		Map<String, Object> paraMap = new HashMap<>();
		paraMap.put("temp_draft_no", temp_draft_no);
		paraMap.put("dvo", dvo);
		
		// draft -> temp_draft 테이블로 옮기기
		n = dao.moveDraft(paraMap);
		
		if (n!=1)
			return false;
		
		// approval -> temp_approval로 옮기기
		n = dao.moveApproval(paraMap);
		
		if (n != avoList.size())
			return false;
		
		// 지출결의서라면
		if (dvo.getFk_draft_type_no() == 2) {
			
			List<ExpenseListVO> evoList = dao.getExpenseListInfo(dvo);
			
			// expense_list -> temp_expense_list로 옮기기
			n = dao.moveExpenseList(paraMap);
			
			if (n != evoList.size())
				return false;
		}
		
		// 출장보고서라면
		if (dvo.getFk_draft_type_no() == 3) {
			// biztrip_report -> temp_biztrip_report로 옮기기
			n = dao.moveBiztripList(paraMap);
			
			if (n!=1)
				return false;
		}
		
		// 원본 기안 삭제하기
		n = dao.deleteOneDraft(dvo.getDraft_no());
		return (n==1)? true: false;
	}

	// 첨부파일 삭제하기
	@Override
	public boolean deleteFiles(Map<String, Object> paraMap) {
		
		DraftVO dvo = (DraftVO) paraMap.get("dvo");
		
		// 첨부파일 목록 조회하기
		List<DraftFileVO> dfvoList = getAllAttachedFile(dvo.getDraft_no());
		
		int n = 0;
		// 첨부파일이 있다면
		if (dfvoList != null && dfvoList.size() > 0) {
			// 테이블에서 파일 삭제
			n = dao.deleteFiles(dfvoList);
			
			// 테이블에서 파일 삭제가 제대로 이루어지지 않았다면
			if (n != dfvoList.size()) {
				return false;
			} 
			else {
				// 서버에서 파일 삭제
				for(DraftFileVO file : dfvoList)  {
					try {
						fileManager.doFileDelete(file.getFilename(), (String)paraMap.get("filePath"));
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				return true;
			}
		} 
		// 첨부파일이 없다면
		else {
			return true;
		}
	}

	

}
	
package com.spring.app.domain;

import org.springframework.web.multipart.MultipartFile;

public class DocumentVO {
	
	private String seq;
	private String fk_employee_id;
	private String documentSubject;
	private MultipartFile attach;
	
	private String fileName; 		
	private String orgFilename; 	
	private String fileSize;
	
	
	
	public String getSeq() {
		return seq;
	}
	public void setSeq(String seq) {
		this.seq = seq;
	}
	public MultipartFile getAttach() {
		return attach;
	}
	public void setAttach(MultipartFile attach) {
		this.attach = attach;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public String getOrgFilename() {
		return orgFilename;
	}
	public void setOrgFilename(String orgFilename) {
		this.orgFilename = orgFilename;
	}
	public String getFileSize() {
		return fileSize;
	}
	public void setFileSize(String fileSize) {
		this.fileSize = fileSize;
	}
	public String getFk_employee_id() {
		return fk_employee_id;
	}
	public void setFk_employee_id(String fk_employee_id) {
		this.fk_employee_id = fk_employee_id;
	}
	public String getDocumentSubject() {
		return documentSubject;
	}
	public void setDocumentSubject(String documentSubject) {
		this.documentSubject = documentSubject;
	} 		
	
	
}

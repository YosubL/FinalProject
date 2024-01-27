package com.spring.app.domain;

import org.springframework.web.multipart.MultipartFile;

public class BoardFileVO {
		
	private String fileno;            // 글번호
	private String fk_seq;       // 사용자ID   
	private String fileName;    // WAS(톰캣)에 저장될 파일명(20230101.png) 
	private String orgFilename; // 진짜 파일명(강아지.png)  // 사용자가 파일을 업로드 하거나 파일을 다운로드 할때 사용되어지는 파일명  
	private String fileSize;    // 파일크기 
	
	
	////////////////////////////////////////////////////////////////////////////////////
	private MultipartFile multipartFile;

	public MultipartFile getMultipartFile() {
	       return multipartFile;
	 }

	public void setMultipartFile(MultipartFile multipartFile) {
	        this.multipartFile = multipartFile;
	}

	private MultipartFile attach;


	public BoardFileVO() {
		
	}
	
	public BoardFileVO(String fileno, String fk_seq, String fileName, String orgFilename, String fileSize,
			MultipartFile attach) {
		super();
		this.fileno = fileno;
		this.fk_seq = fk_seq;
		this.fileName = fileName;
		this.orgFilename = orgFilename;
		this.fileSize = fileSize;
		this.attach = attach;
	}


	public String getFileno() {
		return fileno;
	}


	public void setFileno(String fileno) {
		this.fileno = fileno;
	}


	public String getFk_seq() {
		return fk_seq;
	}


	public void setFk_seq(String fk_seq) {
		this.fk_seq = fk_seq;
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


	public MultipartFile getAttach() {
		return attach;
	}


	public void setAttach(MultipartFile attach) {
		this.attach = attach;
	}
	
 	////////////////////////////////////////////////////////////////////////////////////
	
	
	
	
	
}

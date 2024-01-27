package com.spring.app.common;

import java.util.Properties;

import javax.mail.*;
import javax.mail.internet.*;

public class GoogleMail {

	public void send_certification_code(String recipient, String certification_code) throws Exception { 
		
		// 1. 정보를 담기 위한 객체
    	Properties prop = new Properties(); 
    	
    	
    	// 2. SMTP(Simple Mail Transfer Protocoal) 서버의 계정 설정
   	    //    Google Gmail 과 연결할 경우 Gmail 의 email 주소를 지정 
    	prop.put("mail.smtp.user", "leeyosub9412@gmail.com"); 
    			
		
    	// 3. SMTP 서버 정보 설정
    	//    Google Gmail 인 경우  smtp.gmail.com
    	prop.put("mail.smtp.host", "smtp.gmail.com");
         	
    	
    	prop.put("mail.smtp.port", "465");
    	prop.put("mail.smtp.starttls.enable", "true");
    	prop.put("mail.smtp.auth", "true");
    	prop.put("mail.smtp.debug", "true");
    	prop.put("mail.smtp.socketFactory.port", "465");
    	prop.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
    	prop.put("mail.smtp.socketFactory.fallback", "false");
    	
    	prop.put("mail.smtp.ssl.enable", "true");
    	prop.put("mail.smtp.ssl.trust", "smtp.gmail.com");
    	prop.put("mail.smtp.ssl.protocols", "TLSv1.2"); // MAC 에서도 이메일 보내기 가능하도록 한것임. 또한 만약에 SMTP 서버를 google 대신 naver 를 사용하려면 이것을 해주어야 함.

    	
    	
    	Authenticator smtpAuth = new MySMTPAuthenticator();
    	Session ses = Session.getInstance(prop, smtpAuth);
    		
    	// 메일을 전송할 때 상세한 상황을 콘솔에 출력한다.
    	ses.setDebug(true);
    	        
    	// 메일의 내용을 담기 위한 객체생성
    	MimeMessage msg = new MimeMessage(ses);

    	// 제목 설정
    	String subject = "그룹웨어 회원님의 회원가입을 위한 메일 발송";
    	msg.setSubject(subject);
    	        
    	// 보내는 사람의 메일주소
    	String sender = "leeyosub9412@gmail.com";
    	Address fromAddr = new InternetAddress(sender);
    	msg.setFrom(fromAddr);
    	        
    	// 받는 사람의 메일주소
    	Address toAddr = new InternetAddress(recipient);
    	msg.addRecipient(Message.RecipientType.TO, toAddr);
    	        
    	// 메시지 본문의 내용과 형식, 캐릭터 셋 설정
    	msg.setContent("발송된 인증코드 : <span style='font-size:14pt;'>"+certification_code+"</span>", "text/html;charset=UTF-8");
    	        
    	// 메일 발송하기
    	Transport.send(msg);
    	
	}// end of public void send_certification_code(String recipient, String certification_code) throws Exception--------

	public void sendmail_OrderFinish(String mail_name, String mail_department, String mail_email, String emailContents, String email, String emailContents2) throws Exception{

//		System.out.println("mail_name" + mail_name);
//		System.out.println("mail_department" + mail_department);
//		System.out.println("mail_email" + mail_email);
//		System.out.println("emailContents" + emailContents);
//		System.out.println("email" + email);
//		System.out.println("emailContents2" + emailContents2);
		
		
		
        // 1. 정보를 담기 위한 객체
        Properties prop = new Properties(); 
        
        // 2. SMTP 서버의 계정 설정
        //    Google Gmail 과 연결할 경우 Gmail 의 email 주소를 지정 
        prop.put("mail.smtp.user", "leeyosub9412@gmail.com");
            
        // 3. SMTP 서버 정보 설정
        //    Google Gmail 인 경우  smtp.gmail.com
        prop.put("mail.smtp.host", "smtp.gmail.com");
             
        
        prop.put("mail.smtp.port", "465");
        prop.put("mail.smtp.starttls.enable", "true");
        prop.put("mail.smtp.auth", "true");
        prop.put("mail.smtp.debug", "true");
        prop.put("mail.smtp.socketFactory.port", "465");
        prop.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        prop.put("mail.smtp.socketFactory.fallback", "false");
        
        prop.put("mail.smtp.ssl.enable", "true");
        prop.put("mail.smtp.ssl.trust", "smtp.gmail.com");
    	prop.put("mail.smtp.ssl.protocols", "TLSv1.2"); // MAC 에서도 이메일 보내기 가능하도록 한것임. 또한 만약에 SMTP 서버를 google 대신 naver 를 사용하려면 이것을 해주어야 함.
                  
        Authenticator smtpAuth = new MySMTPAuthenticator();
        Session ses = Session.getInstance(prop, smtpAuth); 
           
        // 메일을 전송할 때 상세한 상황을 콘솔에 출력한다.
        ses.setDebug(true);
                
        // 메일의 내용을 담기 위한 객체생성
        MimeMessage msg = new MimeMessage(ses);

        // 제목 설정
        String subject = "입사를 환영합니다. " +mail_name+ " 님  " + mail_department + " 에서 초대를 보냈어요! ";
        msg.setSubject(subject);
                
        // 보내는 사람의 메일주소
        String sender = "leeyosub9412@gmail.com";
        Address fromAddr = new InternetAddress(sender);
        msg.setFrom(fromAddr);
                
        // 받는 사람의 메일주소
        Address toAddr = new InternetAddress(email);
        msg.addRecipient(Message.RecipientType.TO, toAddr);
                
        // 메시지 본문의 내용과 형식, 캐릭터 셋 설정
        msg.setContent("<div>" + emailContents2 + "</div>", "text/html;charset=UTF-8");
                
        // 메일 발송하기
        Transport.send(msg);
        
     }// end of sendmail_OrderFinish(String recipient, String emailContents)----------------------- 
	
}





package com.spring.app.kimkm.service;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
// import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.spring.app.kimkm.model.SalaryDAO;

// ==== #31. Service 선언 ====
// 트랜잭션 처리를 담당하는 곳, 업무를 처리하는 곳, 비지니스(Business)단 
// @Component
@Service
public class SalaryService_imple implements SalaryService {

   @Autowired
   private SalaryDAO dao;
   
   // 급여테이블 조회하기
   @Override
   public List<Map<String, String>> monthSal(String employee_id) {
      List<Map<String, String>> monthSalList = dao.monthSal(employee_id);
      return monthSalList;
   }

   // 급여명세서 테이블 가져오기
   @Override
   public Map<String, String> salaryStatement(Map<String, String> paraMap) {
      Map<String, String> salaryStatement = dao.salaryStatement(paraMap);
      return salaryStatement;
   }

   // salary 테이블에서 조건에 만족하는 급여들을 가져와서 Excel 파일로 만들기 
   @Override
   public void salary_to_Excel(Map<String, Object> paraMap, Model model) {
      
      // === 조회결과물인 empList 를 가지고 엑셀 시트 생성하기 ===
      // 시트를 생성하고, 행을 생성하고, 셀을 생성하고, 셀안에 내용을 넣어주면 된다.
      SXSSFWorkbook workbook = new SXSSFWorkbook();
      
      // 시트생성
      SXSSFSheet sheet = workbook.createSheet("급여대장");
      
      // 시트 열 너비 설정
      sheet.setColumnWidth(0, 3000);
      sheet.setColumnWidth(1, 3000);
      sheet.setColumnWidth(2, 4000);
      sheet.setColumnWidth(3, 3000);
      sheet.setColumnWidth(4, 3000);
      sheet.setColumnWidth(5, 3000);
      sheet.setColumnWidth(6, 3000);
      sheet.setColumnWidth(7, 3000);
      sheet.setColumnWidth(8, 6000);
      sheet.setColumnWidth(9, 3000);
      sheet.setColumnWidth(10, 3000);
      sheet.setColumnWidth(11, 3000);
      sheet.setColumnWidth(12, 3000);
      sheet.setColumnWidth(13, 3000);
      sheet.setColumnWidth(14, 3000);
      sheet.setColumnWidth(15, 3000);
      
      // 행의 위치를 나타내는 변수 
      int rowLocation = 0;
      
      ////////////////////////////////////////////////////////////////////////////////////////
      // CellStyle 정렬하기(Alignment)
      // CellStyle 객체를 생성하여 Alignment 세팅하는 메소드를 호출해서 인자값을 넣어준다.
      // 아래는 HorizontalAlignment(가로)와 VerticalAlignment(세로)를 모두 가운데 정렬 시켰다.
      CellStyle mergeRowStyle = workbook.createCellStyle();
      mergeRowStyle.setAlignment(HorizontalAlignment.CENTER);
      mergeRowStyle.setVerticalAlignment(VerticalAlignment.CENTER);
                                      // import org.apache.poi.ss.usermodel.VerticalAlignment 으로 해야함.
      
      CellStyle mergeRowStyle2 = workbook.createCellStyle();
      mergeRowStyle2.setAlignment(HorizontalAlignment.CENTER);
      mergeRowStyle2.setVerticalAlignment(VerticalAlignment.CENTER);
      
      CellStyle headerStyle = workbook.createCellStyle();
      headerStyle.setAlignment(HorizontalAlignment.CENTER);
      headerStyle.setVerticalAlignment(VerticalAlignment.CENTER);
      
      CellStyle headerStyle2 = workbook.createCellStyle();
      headerStyle2.setAlignment(HorizontalAlignment.CENTER);
      headerStyle2.setVerticalAlignment(VerticalAlignment.CENTER);
      
      CellStyle headerStyle3 = workbook.createCellStyle();
      headerStyle3.setAlignment(HorizontalAlignment.CENTER);
      headerStyle3.setVerticalAlignment(VerticalAlignment.CENTER);
      
      
      // CellStyle 배경색(ForegroundColor)만들기
        // setFillForegroundColor 메소드에 IndexedColors Enum인자를 사용한다.
        // setFillPattern은 해당 색을 어떤 패턴으로 입힐지를 정한다.
      mergeRowStyle.setFillForegroundColor(IndexedColors.WHITE.getIndex());  // IndexedColors.DARK_BLUE.getIndex() 는 색상(남색)의 인덱스값을 리턴시켜준다. 
      mergeRowStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
      
      headerStyle.setFillForegroundColor(IndexedColors.LIGHT_YELLOW.getIndex()); // IndexedColors.LIGHT_YELLOW.getIndex() 는 연한노랑의 인덱스값을 리턴시켜준다. 
      headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
      
      headerStyle2.setFillForegroundColor(IndexedColors.LIGHT_YELLOW.getIndex()); // IndexedColors.LIGHT_YELLOW.getIndex() 는 연한노랑의 인덱스값을 리턴시켜준다. 
      headerStyle2.setFillPattern(FillPatternType.SOLID_FOREGROUND);
      
      headerStyle3.setFillForegroundColor(IndexedColors.LIGHT_YELLOW.getIndex()); // IndexedColors.LIGHT_YELLOW.getIndex() 는 연한노랑의 인덱스값을 리턴시켜준다. 
      headerStyle3.setFillPattern(FillPatternType.SOLID_FOREGROUND);
      
      
      // CellStyle 천단위 쉼표, 금액
        CellStyle moneyStyle = workbook.createCellStyle();
        moneyStyle.setDataFormat(HSSFDataFormat.getBuiltinFormat("#,###"));
        
      
      // Cell 폰트(Font) 설정하기
        // 폰트 적용을 위해 POI 라이브러리의 Font 객체를 생성해준다.
        // 해당 객체의 세터를 사용해 폰트를 설정해준다. 대표적으로 글씨체, 크기, 색상, 굵기만 설정한다.
        // 이후 CellStyle의 setFont 메소드를 사용해 인자로 폰트를 넣어준다.
      Font mergeRowFont = workbook.createFont(); // import org.apache.poi.ss.usermodel.Font; 으로 한다.
      mergeRowFont.setFontName("나눔고딕");
      mergeRowFont.setFontHeight((short)500);
      mergeRowFont.setBold(true);
      
      mergeRowStyle.setFont(mergeRowFont);
      
      
      // CellStyle 테두리 Border
        // 테두리는 각 셀마다 상하좌우 모두 설정해준다.
        // setBorderTop, Bottom, Left, Right 메소드와 인자로 POI라이브러리의 BorderStyle 인자를 넣어서 적용한다.
      headerStyle.setBorderTop(BorderStyle.THICK);
      headerStyle.setBorderBottom(BorderStyle.THICK);
      headerStyle.setBorderLeft(BorderStyle.THIN);
      headerStyle.setBorderRight(BorderStyle.THIN);
      
      headerStyle2.setBorderTop(BorderStyle.THICK);
      headerStyle2.setBorderBottom(BorderStyle.THIN);
      headerStyle2.setBorderLeft(BorderStyle.THIN);
      headerStyle2.setBorderRight(BorderStyle.THIN);
      
      
      headerStyle3.setBorderTop(BorderStyle.THIN);
      headerStyle3.setBorderBottom(BorderStyle.THICK);
      headerStyle3.setBorderLeft(BorderStyle.THIN);
      headerStyle3.setBorderRight(BorderStyle.THIN);
      
      
      
      // Cell Merge 셀 병합시키기
        /* 셀병합은 시트의 addMergeRegion 메소드에 CellRangeAddress 객체를 인자로 하여 병합시킨다.
           CellRangeAddress 생성자의 인자로(시작 행, 끝 행, 시작 열, 끝 열) 순서대로 넣어서 병합시킬 범위를 정한다. 배열처럼 시작은 0부터이다.  
        */
        // 병합할 행 만들기
      Row mergeRow = sheet.createRow(rowLocation);  // 엑셀에서 행의 시작은 0 부터 시작한다. 
      
      // 병합할 행에 "우리회사 사원정보" 로 셀을 만들어 셀에 스타일을 주기
      for(int i=0; i<16; i++) {
         Cell cell = mergeRow.createCell(i);
         cell.setCellStyle(mergeRowStyle);
         cell.setCellValue("급여대장");
      }// end of for-------------------------
      
      // 셀 병합하기
      sheet.addMergedRegion(new CellRangeAddress(rowLocation, rowLocation, 0, 15)); // 시작 행, 끝 행, 시작 열, 끝 열 
        ////////////////////////////////////////////////////////////////////////////////////////////////
      
      // 헤더 행 생성
        Row headerRow = sheet.createRow(++rowLocation); // 엑셀에서 행의 시작은 0 부터 시작한다.
                                                        // ++rowLocation는 전위연산자임. 
        
        
        Cell cell = headerRow.createCell(1);
        cell.setCellStyle(mergeRowStyle2);
      cell.setCellValue("회사명  : Groupware");
      
      cell = headerRow.createCell(2);
      cell.setCellStyle(mergeRowStyle2);
      cell.setCellValue("(주)대한민국");
      
        Row headerRow2 = sheet.createRow(++rowLocation);
        Row headerRow3 = sheet.createRow(++rowLocation);
        
        int start_no = 0;
        int end_no=8;
        for (int i = start_no; i <= end_no; i++) {
            sheet.addMergedRegion(new CellRangeAddress(2, 3, i, i));

            // 첫 번째 행의 헤더 셀 생성
            Cell headerCell = sheet.getRow(2).createCell(i);
            headerCell.setCellValue(getHeaderLabel(i));
            headerCell.setCellStyle(headerStyle);

            // 두 번째 행의 헤더 셀 생성
            headerCell = sheet.getRow(3).createCell(i);
            headerCell.setCellStyle(headerStyle);
        }

        // 스타일을 적용할 행 인덱스 배열
        int[] styledRows = {2, 3};

        // 모든 행에 동일한 스타일 적용
        for (int rowIndex : styledRows) {
            Row row = sheet.getRow(rowIndex);
            if (row == null) {
                row = sheet.createRow(rowIndex);
            }
            for (int i = 0; i <= end_no; i++) {
                Cell cell2 = row.getCell(i, Row.MissingCellPolicy.CREATE_NULL_AS_BLANK);
                cell2.setCellStyle(headerStyle);
            }
        }
        
        Cell headerCell = headerRow2.createCell(0); // 엑셀에서 열의 시작은 0 부터 시작한다.
        headerCell.setCellValue("월");
        headerCell.setCellStyle(headerStyle);
        
        headerCell = headerRow2.createCell(1);
        headerCell.setCellValue("성명");
        headerCell.setCellStyle(headerStyle);
        
        headerCell = headerRow2.createCell(2);
        headerCell.setCellValue("직책");
        headerCell.setCellStyle(headerStyle);
        
        headerCell = headerRow2.createCell(3);
        headerCell.setCellValue("기본급");
        headerCell.setCellStyle(headerStyle);
        
        headerCell = headerRow2.createCell(4);
        headerCell.setCellValue("직책수당");
        headerCell.setCellStyle(headerStyle);
        
        headerCell = headerRow2.createCell(5);
        headerCell.setCellValue("추가근무수당");
        headerCell.setCellStyle(headerStyle);
        
        headerCell = headerRow2.createCell(6);
        headerCell.setCellValue("휴가비");
        headerCell.setCellStyle(headerStyle);
        
        headerCell = headerRow2.createCell(7);
        headerCell.setCellValue("상여금");
        headerCell.setCellStyle(headerStyle);
        
        headerCell = headerRow2.createCell(8);
        headerCell.setCellValue("4대보험 해당급여 합계");
        headerCell.setCellStyle(headerStyle);
        
      headerCell = headerRow2.createCell(9);
      headerCell.setCellStyle(headerStyle2);
      headerCell.setCellValue("비과세");
       
        headerCell = headerRow3.createCell(9);
        headerCell.setCellValue("식대");
        headerCell.setCellStyle(headerStyle3);
        
        sheet.addMergedRegion(new CellRangeAddress(2, 2, 10, 14));
        
        for (int i = 10; i <= 14; i++) {
            Cell headerCell1 = headerRow2.createCell(i);
            headerCell1.setCellStyle(headerStyle2);
            headerCell1.setCellValue("4대보험(근로자제공)");
        }
        
        headerCell = headerRow3.createCell(10);
        headerCell.setCellValue("국민연금");
        headerCell.setCellStyle(headerStyle3);
        
        headerCell = headerRow3.createCell(11);
        headerCell.setCellValue("장기요양");
        headerCell.setCellStyle(headerStyle3);
        
        headerCell = headerRow3.createCell(12);
        headerCell.setCellValue("건강보험");
        headerCell.setCellStyle(headerStyle3);
        
        headerCell = headerRow3.createCell(13);
        headerCell.setCellValue("고용보험");
        headerCell.setCellStyle(headerStyle3);
        
        headerCell = headerRow3.createCell(14);
        headerCell.setCellValue("공제합계");
        headerCell.setCellStyle(headerStyle3);
        
        sheet.addMergedRegion(new CellRangeAddress(2, 3, 15, 15));
        

        headerCell = sheet.getRow(2).createCell(15);
        headerCell.setCellValue("실 지급액"); // 18은 예시로 사용한 값, 필요에 따라 변경
        headerCell.setCellStyle(headerStyle);
        headerCell = headerRow3.createCell(15);
        headerCell = sheet.getRow(3).createCell(15);
        headerCell.setCellStyle(headerStyle);
        
        
        
        // ==== HR사원정보 내용에 해당하는 행 및 셀 생성하기 ==== //
        CellStyle y_bodyStyle = workbook.createCellStyle();
        y_bodyStyle.setFillForegroundColor(IndexedColors.LIGHT_YELLOW.getIndex()); // IndexedColors.LIGHT_YELLOW.getIndex() 는 연한노랑의 인덱스값을 리턴시켜준다. 
        y_bodyStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        
        CellStyle p_bodyStyle = workbook.createCellStyle();
        p_bodyStyle.setFillForegroundColor(IndexedColors.PINK1.getIndex()); // IndexedColors.LIGHT_YELLOW.getIndex() 는 연한노랑의 인덱스값을 리턴시켜준다. 
        p_bodyStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        
        CellStyle b_bodyStyle = workbook.createCellStyle();
        b_bodyStyle.setBorderTop(BorderStyle.THIN);
        b_bodyStyle.setBorderBottom(BorderStyle.THIN);
        b_bodyStyle.setBorderLeft(BorderStyle.THIN);
        b_bodyStyle.setBorderRight(BorderStyle.THIN);
        b_bodyStyle.setDataFormat(HSSFDataFormat.getBuiltinFormat("#,##0"));
        
        y_bodyStyle.setBorderTop(BorderStyle.THIN);
        y_bodyStyle.setBorderBottom(BorderStyle.THIN);
        y_bodyStyle.setBorderLeft(BorderStyle.THIN);
        y_bodyStyle.setBorderRight(BorderStyle.THIN);
        y_bodyStyle.setDataFormat(HSSFDataFormat.getBuiltinFormat("#,##0"));
        
        p_bodyStyle.setBorderTop(BorderStyle.THIN);
        p_bodyStyle.setBorderBottom(BorderStyle.THIN);
        p_bodyStyle.setBorderLeft(BorderStyle.THIN);
        p_bodyStyle.setBorderRight(BorderStyle.THIN);
        p_bodyStyle.setDataFormat(HSSFDataFormat.getBuiltinFormat("#,##0"));
      
      
        Row bodyRow = null;
        Cell bodyCell = null;
        
        List<Map<String, String>> salaryList = dao.salaryList(paraMap);
        
        for(int i=0; i<salaryList.size(); i++) {
           
           Map<String, String> salaryMap = salaryList.get(i);
           
        //   //System.out.println(salaryMap);
           // 행생성
           bodyRow = sheet.createRow(i + (rowLocation+1));
           
           // 데이터 년월표시
           bodyCell = bodyRow.createCell(0);
           bodyCell.setCellValue(salaryMap.get("year_month"));
           bodyCell.setCellStyle(y_bodyStyle);
           
           // 데이터 사원이름 표시
           bodyCell = bodyRow.createCell(1);
           bodyCell.setCellValue(salaryMap.get("name")); 
           bodyCell.setCellStyle(b_bodyStyle);
           
           // 데이터 사원직급 표시
           bodyCell = bodyRow.createCell(2);
           bodyCell.setCellValue(salaryMap.get("job_name")); 
           bodyCell.setCellStyle(b_bodyStyle);
           
           // 데이터 기본금 표시
           bodyCell = bodyRow.createCell(3);
           bodyCell.setCellValue(Integer.parseInt(salaryMap.get("salary")));
           bodyCell.setCellStyle(moneyStyle);
           bodyCell.setCellStyle(b_bodyStyle);
           
           // 데이터 직책수당 표시
           bodyCell = bodyRow.createCell(4);
           bodyCell.setCellValue(Integer.parseInt(salaryMap.get("position_allowance")));
           bodyCell.setCellStyle(b_bodyStyle);
           
           // 데이터 추가근무수당 표시
           bodyCell = bodyRow.createCell(5);
           bodyCell.setCellValue(Integer.parseInt(salaryMap.get("extra_work_allowance")));
           bodyCell.setCellStyle(b_bodyStyle);
           
           // 데이터 휴가비 표시
           bodyCell = bodyRow.createCell(6);
           bodyCell.setCellValue(Integer.parseInt(salaryMap.get("vacation_bonus")));
           bodyCell.setCellStyle(b_bodyStyle);
           
           // 데이터 상여금 표시
           bodyCell = bodyRow.createCell(7);
           bodyCell.setCellValue(Integer.parseInt(salaryMap.get("bonus")));
           bodyCell.setCellStyle(b_bodyStyle);
           
           // 데이터 4대보험 급여합계 표시
           bodyCell = bodyRow.createCell(8);
           bodyCell.setCellValue(Integer.parseInt(salaryMap.get("p_sum")));
           bodyCell.setCellStyle(y_bodyStyle);
           
           // 데이터 식대 표시
           bodyCell = bodyRow.createCell(9);
           bodyCell.setCellValue(Integer.parseInt(salaryMap.get("meal_allowance")));
           bodyCell.setCellStyle(b_bodyStyle);
           
           
           // 데이터 국민연금 표시
           bodyCell = bodyRow.createCell(10);
           bodyCell.setCellValue(Integer.parseInt(salaryMap.get("national_pension"))); 
           bodyCell.setCellStyle(moneyStyle);
           bodyCell.setCellStyle(b_bodyStyle);
           
           // 데이터 장기요양 표시
           bodyCell = bodyRow.createCell(11);
           bodyCell.setCellValue(Integer.parseInt(salaryMap.get("long_term_care_pee")));
           bodyCell.setCellStyle(moneyStyle); // 천단위 쉼표, 금액
           bodyCell.setCellStyle(b_bodyStyle);
           
           // 데이터 건강보험 표시
           bodyCell = bodyRow.createCell(12);
           bodyCell.setCellValue(Integer.parseInt(salaryMap.get("health_insurance"))); 
           bodyCell.setCellStyle(moneyStyle);
           bodyCell.setCellStyle(b_bodyStyle);
           
           // 데이터 고용보험 표시
           bodyCell = bodyRow.createCell(13);
           bodyCell.setCellValue(Integer.parseInt(salaryMap.get("employment_insurance")));
           bodyCell.setCellStyle(moneyStyle);
           bodyCell.setCellStyle(b_bodyStyle);
           
           // 데이터 공제합계 표시
           bodyCell = bodyRow.createCell(14);
           bodyCell.setCellValue(Integer.parseInt(salaryMap.get("m_sum")));
           bodyCell.setCellStyle(moneyStyle);
           bodyCell.setCellStyle(b_bodyStyle);
           
           // 데이터 실 지급액 표시
           bodyCell = bodyRow.createCell(15);
           bodyCell.setCellValue(Double.parseDouble(salaryMap.get("total")));
           bodyCell.setCellStyle(moneyStyle);
           bodyCell.setCellStyle(p_bodyStyle);
        }// end of for------------------------------
        
        model.addAttribute("locale", Locale.KOREA);
        model.addAttribute("workbook", workbook);
        model.addAttribute("workbookName", "HR사원정보");
      
   }

   private static String getHeaderLabel(int columnIndex) {
        // 여기에서 각 열에 해당하는 헤더 레이블을 반환할 로직을 작성
        // 예를 들어, columnIndex가 0이면 "월", 1이면 "성명" 등을 반환할 수 있음
        return "Header" + columnIndex;
    }
   
   // === Spring Scheduler(스프링 스케줄러)를 사용한 tbl_salary 테이블 insert 와 공지사항 insert === //
   // 매월 16일 12시에 insert 해준다.
   @Override
    @Scheduled(cron="0 0 12 16 * *")
   public void PayslipTemplate() throws Exception {
      
      Calendar currentDate = Calendar.getInstance(); // 현재날짜와 시간을 얻어온다.
      currentDate.add(Calendar.MONTH, -1);
      SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM");
      String lastMonth = dateFormat.format(currentDate.getTime());
      
      //System.out.println(lastMonth);
      List<Map<String, String>> emp_salary_List = dao.emp_salary_List(lastMonth);
      //System.out.println(emp_salary_List);
      int n = dao.insert_PayslipTemplate(emp_salary_List);
      
      String manager = "인사 부서장";
      
      Map<String, String> manager_name_empId = dao.select_human_resources_manager(manager);
      
      String subject = "급여 명세서가 발급 되었습니다."; 
      String content = "급여 명세서가 발급 되었습니다. 급여탭에서 본인의 급여명세서를 확인하세요"; 
      String pw = "1234";
      
      manager_name_empId.put("SUBJECT", subject); 
      manager_name_empId.put("CONTENT", content); 
      manager_name_empId.put("PW", pw);
      
      if(n >0) { 
         int n2 = dao.insert_notice_board(manager_name_empId); 
      }
   }
   
   
}
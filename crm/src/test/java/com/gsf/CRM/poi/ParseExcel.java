package com.gsf.CRM.poi;

import com.gsf.CRM.commons.utils.HSSFUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import java.io.FileInputStream;
import java.io.IOException;

public class ParseExcel {
      public static void main(String[] args) throws IOException {

            FileInputStream fis = new FileInputStream("E:\\activityList.xls");
            //拿到指定Excel文件的一个HSSFWorkbook
            HSSFWorkbook wb = new HSSFWorkbook(fis);
            //通过wb拿到这个Excel文件的第一个sheet
            HSSFSheet sheet = wb.getSheetAt(0);

            HSSFRow row = null;
            HSSFCell cell = null;
            for(int i = 0 ; i <= sheet.getLastRowNum() ; i++){
                   row = sheet.getRow(i);

                   for(int j = 0 ; j < row.getLastCellNum() ; j++){
                          cell = row.getCell(j);

                         System.out.print(HSSFUtils.getCellValueForStr(cell) + " ");

                   }
                  System.out.println();
            }

      }


}

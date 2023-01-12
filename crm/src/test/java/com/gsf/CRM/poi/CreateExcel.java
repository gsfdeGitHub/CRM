package com.gsf.CRM.poi;

import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.ss.usermodel.HorizontalAlignment;

import java.io.FileOutputStream;
import java.io.IOException;

public class CreateExcel {
      public static void main(String[] args) throws IOException {
            //使用HSSFWorkbook生成一个文件
            HSSFWorkbook wb = new HSSFWorkbook();
            //使用wb创建一个表
            HSSFSheet sheet = wb.createSheet("studentList");
            //使用sheet创建一行
            HSSFRow row = sheet.createRow(0);
            //使用row创建三列
            HSSFCell cell = row.createCell(0);
            cell.setCellValue("学号");
            cell = row.createCell(1);
            cell.setCellValue("姓名");
            cell = row.createCell(2);
            cell.setCellValue("年龄");

            //创建一个HSSFCellStyle样式对象
            HSSFCellStyle cellStyle = wb.createCellStyle();
            cellStyle.setAlignment(HorizontalAlignment.CENTER);

            for(int i = 1 ; i <= 10 ; i++){
                  row = sheet.createRow(i);

                  cell = row.createCell(0);
                  cell.setCellValue(100+i);
                  cell = row.createCell(1);
                  cell.setCellValue("name" + i);
                  cell = row.createCell(2);
                  cell.setCellStyle(cellStyle);
                  cell.setCellValue(20 + i);
            }

            //调用工具函数生成Excel文件
            FileOutputStream fos = new FileOutputStream("E:\\studentList.xls");
            wb.write(fos);

            //关闭资源
            fos.close();
            wb.close();
      }
}

package com.gsf.CRM.commons.utils;

import org.apache.poi.hssf.usermodel.HSSFCell;

/**
 * 关于Excel文件操作的工具类
 */
public class HSSFUtils {
      public static String getCellValueForStr(HSSFCell cell){
            String retStr = "";

            if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING){
                  retStr = cell.getStringCellValue();
            }else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
                  retStr = cell.getNumericCellValue() + "";
            }else if(cell.getCellType() == HSSFCell.CELL_TYPE_BOOLEAN){
                  retStr = cell.getBooleanCellValue() + "";
            }else if(cell.getCellType() == HSSFCell.CELL_TYPE_FORMULA){
                  retStr = cell.getCellFormula() + "";
            }else{
                  retStr = "";
            }

            return retStr;
      }
}

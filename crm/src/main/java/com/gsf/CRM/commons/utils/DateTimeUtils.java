package com.gsf.CRM.commons.utils;

import java.text.SimpleDateFormat;
import java.util.Date;

public class DateTimeUtils {
      /**
       * 将日期格式化的代码进行封装
       * 转换成yyyy-MM-dd HH:mm:ss形式
       * @param date   这个形参接收调用处传过来的Date类型的参数
       * @return  将转化的字符串类型的日期返回
       */
      public static String formatDateTime(Date date){
            SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String nowTime = sf.format(date);
            return nowTime;
      }

      /**
       * 将日期格式化的代码进行封装
       * 转换成yyyy-MM-dd形式
       * @param date   这个形参接收调用处传过来的Date类型的参数
       * @return  将转化的字符串类型的日期返回
       */
      public static String formatDate(Date date){
            SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
            String nowTime = sf.format(date);
            return nowTime;
      }

      /**
       * 将日期格式化的代码进行封装
       * 转换成HH:mm:ss形式
       * @param date   这个形参接收调用处传过来的Date类型的参数
       * @return  将转化的字符串类型的日期返回
       */
      public static String formatTime(Date date){
            SimpleDateFormat sf = new SimpleDateFormat("HH:mm:ss");
            String nowTime = sf.format(date);
            return nowTime;
      }
}

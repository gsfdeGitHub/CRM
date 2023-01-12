package com.gsf.CRM.commons.utils;

import java.util.UUID;

public class UUIDUtils {
      /**
       * 获取UUID生成的32位字符串
       * @return
       */
      public static String getUUID(){
            return UUID.randomUUID().toString().replaceAll("-","");
      }
}

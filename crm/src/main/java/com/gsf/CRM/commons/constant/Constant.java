package com.gsf.CRM.commons.constant;


public class Constant {

      /**
       *  登录成功是LOGIN_SUCCESS = "1"
       *  登录失败是LOGIN_FAIL = "1"
       */
      public static final String PROCESSING_SUCCESS = "1";
      public static final String PROCESSING_FAIL = "0";

      /**
       * 这个常量存储的是UserController中得到的User对象存储在session作用域中的key
       */
      public static final String SESSION_USER = "sessionUser";

      /**
       * 备注的修改标记，" 0 "表示没有修改过，" 1 "表示修改过
       */
      public static final String REMARK_EDIT_FLAG_NO_EDIT = "0";
      public static final String REMARK_EDIT_FLAG_EDIT = "1";

}

package com.gsf.CRM.commons.pojo;

/**
 * 这个类是返回用户登录时的响应信息
 * code存储的是用户的登录状态，1是允许登录，0是不允许登录
 * message存储的是用户点击登录按钮后返回的信息，提示是否登录成功，登录失败的原因等等
 * retDate存储的是其他有用的信息
 */
public class ReturnObject {

      private String code;
      private String message;
      private Object retData;

      @Override
      public String toString() {
            return "ReturnObject{" +
                    "code='" + code + '\'' +
                    ", message='" + message + '\'' +
                    ", retData=" + retData +
                    '}';
      }

      public String getCode() {
            return code;
      }

      public void setCode(String code) {
            this.code = code;
      }

      public String getMessage() {
            return message;
      }

      public void setMessage(String message) {
            this.message = message;
      }

      public Object getRetData() {
            return retData;
      }

      public void setRetData(Object retData) {
            this.retData = retData;
      }

      public ReturnObject(String code, String message, Object retData) {
            this.code = code;
            this.message = message;
            this.retData = retData;
      }

      public ReturnObject() {
      }
}

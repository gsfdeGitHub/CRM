package com.gsf.CRM.commons.utils;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;


public class LoginCookieUtils {
      /**
       * 在用户勾选记住密码的时候，服务器向浏览器写Cookie的操作
       * @param cookieName    Cookie的name
       * @param cookieValue     Cookie的value
       * @param maxAge        Cookie的最大存活时长
       * @param response      当前的HttpServletResponse对象
       */
      public static void AddCookie(String cookieName, String cookieValue, int maxAge, HttpServletResponse response){
            Cookie cookie = new Cookie(cookieName,cookieValue);
            cookie.setMaxAge(maxAge);
            response.addCookie(cookie);
      }
}

package com.gsf.CRM.settings.web.interceptor;

import com.gsf.CRM.commons.constant.Constant;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class LoginInterceptor implements HandlerInterceptor {
      @Override
      public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object o) throws Exception {
            //判断用户是否登录了。如果已经登录了，放行；如果没有登录，跳转到登录页面

            /*System.out.println(111);*/

            //从Session中取出的user对象为空，表示没有登录
            if(request.getSession().getAttribute(Constant.SESSION_USER)==null){
                  //跳转到登录页面
                  response.sendRedirect("/crm/");
                  return false;
            }
            return true;
      }

      @Override
      public void postHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, ModelAndView modelAndView) throws Exception {

      }

      @Override
      public void afterCompletion(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, Exception e) throws Exception {

      }
}

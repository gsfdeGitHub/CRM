package com.gsf.CRM.settings.web.Controller;

import com.gsf.CRM.commons.constant.Constant;
import com.gsf.CRM.commons.pojo.ReturnObject;
import com.gsf.CRM.commons.utils.DateTimeUtils;
import com.gsf.CRM.commons.utils.LoginCookieUtils;
import com.gsf.CRM.settings.pojo.User;
import com.gsf.CRM.settings.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller("userController")
public class UserController {

      //在控制层一定会有业务逻辑层的对象
      @Resource(name = "userServiceImpl")
      private UserService userService;

      @RequestMapping("/settings/qx/user/toLogin.do")
      public String toLogin(){
            return "forward:/WEB-INF/pages/settings/qx/user/login.jsp";
      }

      @RequestMapping(value = "/settings/qx/user/login.do")
      @ResponseBody     //返回的实体类自动转换成json字符串
      public Object login(String loginAct, String loginPwd, String isRemPwd, HttpServletRequest request, HttpSession session, HttpServletResponse response){
            //将用户输入的用户名和密码存到map集合中，方便数据在层之间传递，最后在mapper层取出来与数据库中的数据
            //进行对比
            Map<String,Object> map = new HashMap<>();
            map.put("loginAct",loginAct);
            map.put("loginPwd",loginPwd);


            //new一个包含返回信息的实体类对象
            ReturnObject retObj = new ReturnObject();

            //得到业务逻辑层返回的user对象
            User user = userService.queryUserByLoginActAndLoginPwd(map);

            if(user == null){
                  //用户名或者密码不正确，登陆失败
                  retObj.setCode(Constant.PROCESSING_FAIL);
                  retObj.setMessage("用户名或者密码不正确，登陆失败");
            }else {
                  //用户名和密码正确，继续进行下一步操作
                  //判断账号是否过期
                  //使用DateTimeUtils工具类获取当前时间的字符串
                  if(user.getExpireTime().compareTo(DateTimeUtils.formatDateTime(new Date())) < 1){
                        /*System.out.println(user.getExpireTime());
                        System.out.println(user.getExpireTime().compareTo(DateTimeUtils.formatDateTime(new Date())));*/
                        //账户已经过期，无法登录
                        retObj.setCode(Constant.PROCESSING_FAIL);
                        retObj.setMessage("账户已经过期，无法登录");
                  }else if(user.getLockState().equals(Constant.PROCESSING_FAIL)){
                        //账户的登录LockState值是0，无法登录
                        retObj.setCode(Constant.PROCESSING_FAIL);
                        retObj.setMessage("账户已被锁定，无法登录");
                  }else if(!user.getAllowIps().contains(request.getRemoteAddr())) {
                        //登录时的ip地址不在允许范围内，无法登录
                        retObj.setCode(Constant.PROCESSING_FAIL);
                        retObj.setMessage("IP受限，无法登录");
                  }else {
                        //登录成功
                        retObj.setCode(Constant.PROCESSING_SUCCESS);

                        //登录成功后将User对象存储到Session中，供 JSP使用
                        //但是，这里的key部分是常量，在项目的推进过程中，可能会有更多的地方使用这个Session里面的
                        //user对象，所以这里的"sessionUser"要被封装起来，不然后期维护成本太高
                        session.setAttribute(Constant.SESSION_USER,user);

                        //判断用户是否勾选了"记住密码"，勾选了就像浏览器发送Cookie，没有就将浏览器上的Cookie删除
                        if(isRemPwd.equals("true")){
                              //这个Cookie存放的是用户的账号
                              LoginCookieUtils.AddCookie("loginAct",loginAct,10*24*60*60,response);
                              //这个Cookie存放的是用户的密码
                              LoginCookieUtils.AddCookie("loginPwd",loginPwd,10*24*60*60,response);
                        }else{
                              //一旦用户某次登录没有勾选"记住密码"，就将浏览器上存储了账号和密码的Cookie删除

                              //使用工具类LoginCookieUtils删除存储的账号的Cookie
                              LoginCookieUtils.AddCookie("loginAct","1",0,response);
                              //使用工具类LoginCookieUtils删除存储的密码的Cookie
                              LoginCookieUtils.AddCookie("loginPwd","1",0,response);
                        }
                  }
            }
            return retObj;
      }

      //安全退出的控制器
      @RequestMapping(value = "/settings/qx/user/logout.do")
      public String logout(HttpServletResponse response,HttpSession session){
            //一旦用户点击了 "安全退出" 按钮，后端删除Cookie和Session

            //使用工具类LoginCookieUtils删除存储的账号的Cookie
            LoginCookieUtils.AddCookie("loginAct","1",0,response);
            //使用工具类LoginCookieUtils删除存储的密码的Cookie
            LoginCookieUtils.AddCookie("loginPwd","1",0,response);

            //删除Session
            //手动删除session
            session.invalidate();

            //跳转到首页
            /*使用重定向跳转到项目首页，然后就会执行IndexController中的toIndex方法，这个方法再使用请求转发
               跳转到登录页面*/
            return "redirect:/";
      }
}

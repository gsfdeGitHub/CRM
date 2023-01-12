package com.gsf.CRM.workbench.web.Controller;

import com.gsf.CRM.commons.constant.Constant;
import com.gsf.CRM.commons.pojo.ReturnObject;
import com.gsf.CRM.commons.utils.DateTimeUtils;
import com.gsf.CRM.commons.utils.UUIDUtils;
import com.gsf.CRM.settings.pojo.User;
import com.gsf.CRM.workbench.pojo.ActivityRemark;
import com.gsf.CRM.workbench.service.ActivityRemarkService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller("activityRemarkController")
public class ActivityRemarkController {
      //调用业务逻辑层
      @Resource(name = "activityRemarkServiceImpl")
      private ActivityRemarkService activityRemarkService;

      /**
       * 保存创建的市场活动备注
       * @param remark        接收用户从前端传过来的数据
       * @param session        取出session中存储的当前用户的信息
       * @return        返回一个json字符串，其中包含了响应结果标记、提示信息和当前市场活动对象
       */
      @RequestMapping(value = "/workbench/activity/saveCreateActivityRemark.do")
      @ResponseBody
      public Object saveCreateActivityRemark(ActivityRemark remark, HttpSession session) {
            User user = (User) session.getAttribute(Constant.SESSION_USER);
            //封装参数
            remark.setId(UUIDUtils.getUUID());
            remark.setCreateTime(DateTimeUtils.formatDateTime(new Date()));
            remark.setCreateBy(user.getId());
            remark.setEditFlag(Constant.REMARK_EDIT_FLAG_NO_EDIT);

            ReturnObject returnObject = new ReturnObject();
            try {
                  //调用service层方法，保存创建的市场活动备注
                  int ret = activityRemarkService.saveActivityRemark(remark);

                  if (ret > 0) {
                        returnObject.setCode(Constant.PROCESSING_SUCCESS);
                        returnObject.setRetData(remark);
                  } else {
                        returnObject.setCode(Constant.PROCESSING_FAIL);
                        returnObject.setMessage("系统忙，请稍后重试....");
                  }
            } catch (Exception e) {
                  e.printStackTrace();
                  returnObject.setCode(Constant.PROCESSING_FAIL);
                  returnObject.setMessage("系统忙，请稍后重试....");
            }

            return returnObject;
      }

      /**
       * 删除市场活动备注的方法
       * @param id      用户选取的那个备注的id值
       * @return  返回一个json
       */
      @RequestMapping(value = "/workbench/activity/removeActivityRemark.do")
      @ResponseBody
      public Object removeActivityRemark(String id){
            //创建一个返回到前端的对象
            ReturnObject retObj = new ReturnObject();

            //调用业务逻辑层的方法删除市场活动备注
            try {
                  int count = activityRemarkService.removeActivityRemarkById(id);
                  if (count == 1){
                        retObj.setCode(Constant.PROCESSING_SUCCESS);
                  }else {
                        retObj.setCode(Constant.PROCESSING_FAIL);
                        retObj.setMessage("服务器繁忙，请稍后再试！");
                  }
            } catch (Exception e) {
                  e.printStackTrace();
                  retObj.setCode(Constant.PROCESSING_FAIL);
                  retObj.setMessage("服务器繁忙，请稍后再试！");
            }
            return retObj;
      }

      /**
       * 修改市场活动备注
       * @param remark  前端传过来的noteContent和id还有其他参数封装起来
       * @return        返回JSON
       */
      @RequestMapping(value = "/workbench/activity/updateActivityRemark.do")
      @ResponseBody
      public Object updateActivityRemark(ActivityRemark remark,HttpSession session){
            //创建ReturnObject返回给前端
            ReturnObject retObj = new ReturnObject();

            //从session中取出当前用户
            User user = (User) session.getAttribute(Constant.SESSION_USER);

            //封装参数
            remark.setEditTime(DateTimeUtils.formatDateTime(new Date()));
            remark.setEditBy(user.getId());
            remark.setEditFlag(Constant.REMARK_EDIT_FLAG_EDIT);

            try {
                  int count = activityRemarkService.modifyActivityRemarkById(remark);
                  if(count == 1){
                        retObj.setCode(Constant.PROCESSING_SUCCESS);
                        retObj.setRetData(remark);
                  }else {
                        retObj.setCode(Constant.PROCESSING_FAIL);
                        retObj.setMessage("服务器繁忙，请稍后再试！");
                  }
            } catch (Exception e) {
                  e.printStackTrace();
                  retObj.setCode(Constant.PROCESSING_FAIL);
                  retObj.setMessage("服务器繁忙，请稍后再试！");
            }

            return retObj;
      }
}

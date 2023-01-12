package com.gsf.CRM.workbench.web.Controller;

import com.gsf.CRM.commons.constant.Constant;
import com.gsf.CRM.commons.pojo.ReturnObject;
import com.gsf.CRM.commons.utils.DateTimeUtils;
import com.gsf.CRM.commons.utils.UUIDUtils;
import com.gsf.CRM.settings.pojo.User;
import com.gsf.CRM.workbench.pojo.Activity;
import com.gsf.CRM.workbench.pojo.ClueRemark;
import com.gsf.CRM.workbench.service.ActivityService;
import com.gsf.CRM.workbench.service.ClueRemarkService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller("clueRemarkController")
public class ClueRemarkController {
      //控制层要有业务逻辑层的对象
      @Resource(name = "clueRemarkServiceImpl")
      private ClueRemarkService clueRemarkService;

      @Resource(name = "activityServiceImpl")
      private ActivityService activityService;

      /**
       * 增加线索的备注
       * @param clueRemark    控制器封装的备注实体类
       * @param session       httpSession对象
       * @return        返回json
       */
      @RequestMapping(value = "/workbench/clue/insertClueRemark.do")
      @ResponseBody
      public Object insertClueRemark(ClueRemark clueRemark, HttpSession session){
            //从session中取出当前用户信息
            User user = (User) session.getAttribute(Constant.SESSION_USER);

            //创建返回的响应信息
            ReturnObject retObj = new ReturnObject();

            //封装参数
            clueRemark.setId(UUIDUtils.getUUID());
            clueRemark.setCreateBy(user.getId());
            clueRemark.setCreateTime(DateTimeUtils.formatDateTime(new Date()));
            clueRemark.setEditFlag(Constant.REMARK_EDIT_FLAG_NO_EDIT);

            //调用业务逻辑层的方法
            try {
                  int count = clueRemarkService.saveCreateClueRemark(clueRemark);
                  if(count == 1){
                        retObj.setCode(Constant.PROCESSING_SUCCESS);
                        retObj.setRetData(clueRemark);
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
       * 根据线索备注id删除备注
       * @param id      前端传过来的线索备注id
       * @return  返回JSON
       */
      @RequestMapping(value = "/workbench/clue/deleteClueRemark.do")
      @ResponseBody
      public Object deleteClueRemark(String id){
            //创建一个返回的对象
            ReturnObject retObj = new ReturnObject();

            //调用service层的方法
            try {
                  int count = clueRemarkService.removeClueRemarkById(id);
                  if(count == 1){
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
       * 修改线索备注
       * @param clueRemark    将参数封装成实体类
       * @param session       从session中取出当前用户信息
       * @return        返回json
       */
      @RequestMapping(value = "/workbench/clue/updateClueRemark.do")
      @ResponseBody
      public Object updateClueRemark(ClueRemark clueRemark,HttpSession session){
            //创建一个返回的实体类对象
            ReturnObject retObj = new ReturnObject();

            //取出session中存储的当前用户的信息
            User user = (User) session.getAttribute(Constant.SESSION_USER);

            //id和noteContent已经封装好了，接下里封装剩下的参数
            clueRemark.setEditBy(user.getId());
            clueRemark.setEditTime(DateTimeUtils.formatDateTime(new Date()));
            clueRemark.setEditFlag(Constant.REMARK_EDIT_FLAG_EDIT);

            //调用service层方法，修改线索备注
            try {
                  int count = clueRemarkService.modifyClueRemark(clueRemark);
                  if(count == 1){
                        retObj.setCode(Constant.PROCESSING_SUCCESS);
                        retObj.setRetData(clueRemark);
                  }else{
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

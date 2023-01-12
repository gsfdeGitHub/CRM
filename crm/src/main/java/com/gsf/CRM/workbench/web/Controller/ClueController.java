package com.gsf.CRM.workbench.web.Controller;

import com.gsf.CRM.commons.constant.Constant;
import com.gsf.CRM.commons.pojo.ReturnObject;
import com.gsf.CRM.commons.utils.DateTimeUtils;
import com.gsf.CRM.commons.utils.UUIDUtils;
import com.gsf.CRM.settings.pojo.DicValue;
import com.gsf.CRM.settings.pojo.User;
import com.gsf.CRM.settings.service.DicValueService;
import com.gsf.CRM.settings.service.UserService;
import com.gsf.CRM.workbench.pojo.Activity;
import com.gsf.CRM.workbench.pojo.Clue;
import com.gsf.CRM.workbench.pojo.ClueActivityRelation;
import com.gsf.CRM.workbench.pojo.ClueRemark;
import com.gsf.CRM.workbench.service.ActivityService;
import com.gsf.CRM.workbench.service.ClueActivityRelationService;
import com.gsf.CRM.workbench.service.ClueRemarkService;
import com.gsf.CRM.workbench.service.ClueService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller("clueController")
public class ClueController {
      //控制层要有业务逻辑层的对象
      @Resource(name = "clueServiceImpl")
      private ClueService clueService;

      @Resource(name = "userServiceImpl")
      private UserService userService;

      @Resource(name = "dicValueServiceImpl")
      private DicValueService dicValueService;

      @Resource(name = "clueRemarkServiceImpl")
      private ClueRemarkService clueRemarkService;

      @Resource(name = "activityServiceImpl")
      private ActivityService activityService;

      @Resource(name = "clueActivityRelationServiceImpl")
      private ClueActivityRelationService clueActivityRelationService;

      /**
       * 跳转到线索主页面
       * @return  返回一个路径
       */
      @RequestMapping(value = "/workbench/clue/index.do")
      public String index(HttpServletRequest request){
            //调用userService中查询所有的用户的方法
            List<User> userList = userService.queryAllUsers();
            //调用DicValueService中查询所有的称呼的方法
            List<DicValue> appellationList = dicValueService.queryDicValueByTypeCode("appellation");
            //调用DicValueService中查询所有的线索状态的方法
            List<DicValue> clueStateList = dicValueService.queryDicValueByTypeCode("clueState");
            //调用DicValueService中查询所有的线索来源的方法
            List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");

            //将查询出来的数据存储在request域中
            request.setAttribute("userList",userList);
            request.setAttribute("appellationList",appellationList);
            request.setAttribute("clueStateList",clueStateList);
            request.setAttribute("sourceList",sourceList);

            //请求转发到线索首页面
            return "forward:/WEB-INF/pages/workbench/clue/index.jsp";
      }

      /**
       *根据条件查询线索
       * @param fullName      线索的人名
       * @param company       线索的公司
       * @param phone             线索的公司座机
       * @param source        线索的来源
       * @param owner         线索的所有者
       * @param mPhone        线索的手机号码
       * @param state         线索的状态
       * @param pageNo        用户查看的页码
       * @param pageSize         用户选择每页显示多少条记录
       * @return        返回一个map，里面存储了查询结果
       */
      @RequestMapping(value = "/workbench/clue/queryClueByConditionForPage.do")
      @ResponseBody
      public Object queryClueByConditionForPage(String fullName,String company,String phone,String source,
                                                String owner,String mPhone,String state,Integer pageNo,Integer pageSize){
            //获取前端提交的条件
            Map<String,Object> map  = new HashMap<>();
            map.put("fullName",fullName);
            map.put("company",company);
            map.put("phone",phone);
            map.put("source",source);
            map.put("owner",owner);
            map.put("mPhone",mPhone);
            map.put("state",state);
            map.put("beginNo",(pageNo - 1)*pageSize);
            map.put("pageSize",pageSize);

            //调用service层的方法
            List<Clue> clueList = clueService.queryClueByConditionForPage(map);
            int totalRows = clueService.queryClueCountByConditionForPage(map);
            //返回一个map
            Map<String,Object> retMap = new HashMap<>();
            retMap.put("clueList",clueList);
            retMap.put("totalRows",totalRows);

            return retMap;
      }

      /**
       * 创建线索
       * @param clue    将前端传过来的和我们在控制器中生成的参数一起封装到clue中
       * @return        返回json字符串
       */
      @RequestMapping(value = "/workbench/clue/createClue.do")
      @ResponseBody
      public Object createClue(Clue clue, HttpSession session){
            //创建一个返回给前端的对象
            ReturnObject retObj = new ReturnObject();

            //从session中取出当前用户的信息
            User user = (User) session.getAttribute(Constant.SESSION_USER);

            //将id，createBy，createTime在这里生成
            clue.setId(UUIDUtils.getUUID());
            clue.setCreateBy(user.getId());
            clue.setCreateTime(DateTimeUtils.formatDateTime(new Date()));

            //调用Service层的方法将封装好的clue对象传递给下一层
            try {
                  int count = clueService.saveCreateClue(clue);
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
       * 删除线索
       * @param id      前端传过来的id数组
       * @return        返回json
       */
      @RequestMapping(value = "/workbench/clue/removeClue.do")
      @ResponseBody
      public Object removeClue(String[] id){
            ReturnObject retObj = new ReturnObject();

            //调用service层方法
            try {
                  int count = clueService.removeClueById(id);
                  if(count > 0){
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
       * 点击修改线索按钮，根据id查询线索
       * @param id    前端过来的id值
       * @return      返回一个Clue实体类对象
       */
      @RequestMapping(value = "/workbench/clue/queryClueById.do")
      @ResponseBody
      public Object queryClueById(String id){
            //调用Service层的方法
            Clue clue = clueService.queryClueById(id);
            return clue;
      }

      /**
       * 根据id修改线索
       * @param clue  控制层将前端传递过来的数据进行了封装
       * @return      返回受影响的记录条数
       */
      @RequestMapping(value = "/workbench/clue/refreshClue.do")
      @ResponseBody
      public Object refreshClue(Clue clue,HttpSession session){
            ReturnObject retObj = new ReturnObject();

            //从session中取出用户数据插入到clue对象的editBy属性中
            User user = (User) session.getAttribute(Constant.SESSION_USER);

            //将editBy和editTime两个属性都封装起来，其他的前端传过来
            clue.setEditBy(user.getId());
            clue.setEditTime(DateTimeUtils.formatDateTime(new Date()));

            try {
                  int count = clueService.refreshClueById(clue);
                  if(count == 1){
                        retObj.setCode(Constant.PROCESSING_SUCCESS);
                        retObj.setRetData(clue);
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
       * 跳转到线索明细页面的方法
       * @param id      前端传过来的线索的id
       * @return        返回跳转的路径
       */
      @RequestMapping(value = "/workbench/clue/toDetail.do")
      public String toDetail(String id,HttpServletRequest request){
            //调用ClueService层方法查询线索的详细信息
            Clue clue = clueService.queryClueForDetailById(id);

            //调用ClueRemarkService层方法查询线索的备注
            List<ClueRemark> clueRemarkList = clueRemarkService.queryClueRemarkForDetailByClueId(id);

            //调用ActivityService层方法查询线索关联的市场活动
            List<Activity> activityList = activityService.queryActivityForDetailByClueId(id);

            //将查询结果存储在request域中
            request.setAttribute("clue",clue);
            request.setAttribute("clueRemarkList",clueRemarkList);
            request.setAttribute("activityList",activityList);

            //跳转到线索明细页面
            return "forward:/WEB-INF/pages/workbench/clue/detail.jsp";
      }

      /**
       * 线索关联市场活动模态窗口查找市场活动
       * @param activityName        用户输入的市场活动名字
       * @param clueId        这个线索的id
       * @return        返回json
       */
      @RequestMapping(value = "/workbench/clue/queryActivityForDetailByNameAndClueId.do")
      @ResponseBody
      public Object queryActivityForDetailByNameAndClueId(String activityName,String clueId){
            //封装参数
            Map<String,Object> map = new HashMap<>();
            map.put("activityName",activityName);
            map.put("clueId",clueId);

            //调用service层方法
            List<Activity> activityList = activityService.queryActivityForDetailByNameAndClueId(map);

            return activityList;
      }

      /**
       * 用户发送当前线索想要关联的市场活动后，进行关联关系，再查询出已经关联的市场活动，用于在前端拼串
       * @param clueId        用户选择的想要进行关联关系的线索id
       * @param activityId    用户选择的想要进行关联关系的市场活动id
       * @return        返回json
       */
      @RequestMapping(value = "/workbench/clue/increaseClueActivityRelation.do")
      @ResponseBody
      public Object increaseClueActivityRelation(String clueId,String activityId){
            //创建一个返回的json
            ReturnObject retObj = new ReturnObject();

            //封装参数
            ClueActivityRelation clueActivityRelation = new ClueActivityRelation();
            clueActivityRelation.setId(UUIDUtils.getUUID());
            clueActivityRelation.setClueId(clueId);
            clueActivityRelation.setActivityId(activityId);

            //调用service层方法，插入线索市场活动联系
            try {
                  int count = clueActivityRelationService.saveClueActivityRelation(clueActivityRelation);
                  List<Activity> activityList = activityService.queryActivityForDetailByClueId(clueId);
                  if(count == 1){
                        retObj.setCode(Constant.PROCESSING_SUCCESS);
                        retObj.setRetData(activityList);
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

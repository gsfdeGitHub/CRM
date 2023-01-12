package com.gsf.CRM.workbench.service;

import com.gsf.CRM.workbench.pojo.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityService {
      /**
       * 创建活动的方法
       * @param activity
       * @return
       */
      int saveCreateActivity(Activity activity);

      /**
       * 分页查询所有符合要求的数据，封装在一个Map集合中
       * @param map   封装前端提交的数据
       * @return     将封装了符合要求的活动全部封装到List集合中返回给前端
       */
      List<Activity> queryActivityByConditionForPage(Map<String,Object> map);

      /**
       * 查询符合要求的数据的条数
       * @param map   封装前端提交的要求
       * @return  返回数据的条数
       */
      int selectCountOfActivityByCondition(Map<String,Object> map);

      /**
       * 根据市场活动id删除对应的市场活动
       * @param ids   前端传过来的id封装成一个数组
       * @return  返回受影响的记录条数
       */
      int deleteActivityByIds(String[] ids);

      /**
       * 修改市场活动的功能，根据市场活动的id查询市场活动
       * @param id      市场活动的id
       * @return        返回这个市场活动的id 对应的那个市场活动
       */
      Activity selectActivityById(String id);

      /**
       * 根据activity实体类对象中的id值修改对应的市场活动
       * @param activity  前端传过来的市场活动信息封装在一个实体类中
       * @return  返回修改的记录条数
       */
      int saveEditActivity(Activity activity);

      /**
       * 查询所有的市场活动
       * @return  返回一个存储了全部市场活动的List集合
       */
      List<Activity> queryAllActivity();

      /**
       * 通过市场活动的id查询市场活动
       * @param id    前端传过来的多个id封装在数组中
       * @return  返回一个List集合
       */
      List<Activity> queryActivityByIds(String[] id);

      /**
       * 批量插入市场活动
       * @param activityList  Controller层将若干条市场活动封装到list集合中
       * @return  返回受影响的记录条数
       */
      int importActivity(List<Activity> activityList);

      /**
       * 查看市场活动明细的功能，中的根据市场活动id查询市场活动所有细节的方法
       * @param id    市场活动的id
       * @return  返回一个市场活动对象
       */
      Activity queryActivityForDetail(String id);

      /**
       * 根据线索id，将tbl_clue_activity_relation和tbl_activity连接
       * @param clueId    前端传过来的线索id
       * @return  返回一个List，存储了市场活动
       */
      List<Activity> queryActivityForDetailByClueId(String clueId);

      /**
       * 根据市场活动名字模糊查询市场活动，除去clueId关联的市场活动
       * @return      返回市场活动的List集合
       */
      List<Activity> queryActivityForDetailByNameAndClueId(Map<String,Object> map);
}

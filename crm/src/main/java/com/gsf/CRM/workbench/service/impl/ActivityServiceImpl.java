package com.gsf.CRM.workbench.service.impl;

import com.gsf.CRM.workbench.mapper.ActivityMapper;
import com.gsf.CRM.workbench.pojo.Activity;
import com.gsf.CRM.workbench.service.ActivityService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service("activityServiceImpl")
public class ActivityServiceImpl implements ActivityService {

      //在业务逻辑层中一定会有数据访问层的对象
      @Resource(name = "activityMapper")
      private ActivityMapper activityMapper;

      //创建活动的方法
      @Override
      public int saveCreateActivity(Activity activity) {

            //模拟创建市场活动时的因为某些原因导致的异常
            /*System.out.println(111);

            String s = null;
            s.toString();*/

            return activityMapper.insertActivity(activity);
      }

      //分页查询市场活动的方法
      @Override
      public List<Activity> queryActivityByConditionForPage(Map<String, Object> map) {


            List<Activity> activityList = activityMapper.selectActivityByConditionForPage(map);
            return activityList;
      }

      //查询符合条件的市场活动的记录条数
      @Override
      public int selectCountOfActivityByCondition(Map<String, Object> map) {
            return activityMapper.selectCountOfActivityByCondition(map);
      }

      //根据市场活动id删除对应的市场活动
      @Override
      public int deleteActivityByIds(String[] ids) {
            return activityMapper.deleteActivityByIds(ids);
      }

      //修改市场活动的功能，根据市场活动的id查询市场活动
      @Override
      public Activity selectActivityById(String id) {
            return activityMapper.selectActivityById(id);
      }

      //根据activity实体类对象中的id值修改对应的市场活动
      @Override
      public int saveEditActivity(Activity activity) {
            return activityMapper.updateActivity(activity);
      }

      //查询所有的市场活动
      @Override
      public List<Activity> queryAllActivity() {
            return activityMapper.selectAllActivity();
      }

      //根据id查询市场活动
      @Override
      public List<Activity> queryActivityByIds(String[] id) {
            return activityMapper.selectActivityByIds(id);
      }

      //根据用户上传的Excel文件，批量插入市场活动
      @Override
      public int importActivity(List<Activity> activityList) {
            return activityMapper.insertImportActivity(activityList);
      }

      //查询市场活动明细的功能中的，根据id查询市场活动
      @Override
      public Activity queryActivityForDetail(String id) {
            return activityMapper.selectActivityForDetail(id);
      }

      @Override
      public List<Activity> queryActivityForDetailByClueId(String clueId) {
            return activityMapper.selectActivityForDetailByClueId(clueId);
      }

      @Override
      public List<Activity> queryActivityForDetailByNameAndClueId(Map<String, Object> map) {
            return activityMapper.selectActivityForDetailByNameAndClueId(map);
      }
}

package com.gsf.CRM.workbench.service.impl;

import com.gsf.CRM.workbench.mapper.ActivityRemarkMapper;
import com.gsf.CRM.workbench.pojo.ActivityRemark;
import com.gsf.CRM.workbench.service.ActivityRemarkService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service("activityRemarkServiceImpl")
public class ActivityRemarkServiceImpl implements ActivityRemarkService {

      @Resource(name = "activityRemarkMapper")
      private ActivityRemarkMapper activityRemarkMapper;

      @Override
      public List<ActivityRemark> queryActivityRemarkForDetailByActivityId(String activityId) {
            return activityRemarkMapper.selectActivityRemarkForDetailByActivityId(activityId);
      }

      @Override
      public int saveActivityRemark(ActivityRemark remark) {
            return activityRemarkMapper.insertActivityRemark(remark);
      }

      @Override
      public int removeActivityRemarkById(String id) {
            return activityRemarkMapper.deleteActivityRemarkById(id);
      }

      @Override
      public int modifyActivityRemarkById(ActivityRemark remark) {
            return activityRemarkMapper.updateActivityRemarkById(remark);
      }
}

package com.gsf.CRM.workbench.service;

import com.gsf.CRM.workbench.pojo.ActivityRemark;

import java.util.List;

public interface ActivityRemarkService {
      /**
       * 查询市场活动明细功能中，查询市场活动id对应的所有备注信息
       * @param id    市场活动的id
       * @return      查询出的多条备注信息封装到List集合中
       */
      List<ActivityRemark> queryActivityRemarkForDetailByActivityId(String activityId);

      /**
       * 添加市场活动中，插入市场活动备注的方法
       * @param remark    控制层封装好的ActivityRemark实体类
       * @return      返回受影响的记录条数
       */
      int saveActivityRemark(ActivityRemark remark);

      /**
       * 删除市场活动备注
       * @param id    用户选择删除哪个备注，就把哪个备注的id传给后端
       * @return  返回受影响的记录条数
       */
      int removeActivityRemarkById(String id);

      /**
       * 修改市场活动备注
       * @param remark    Controller封装的ActivityRemark对象
       * @return    返回受影响的记录条数
       */
      int modifyActivityRemarkById(ActivityRemark remark);
}

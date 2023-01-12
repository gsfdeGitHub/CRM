package com.gsf.CRM.workbench.service;

import com.gsf.CRM.workbench.pojo.ClueActivityRelation;

public interface ClueActivityRelationService {
      /**
       * 增加线索市场活动关联
       * @param clueActivityRelation      控制层封装的实体类
       * @return      返回受影响的记录条数
       */
      int saveClueActivityRelation(ClueActivityRelation clueActivityRelation);
}

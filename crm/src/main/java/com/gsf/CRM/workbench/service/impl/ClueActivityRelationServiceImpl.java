package com.gsf.CRM.workbench.service.impl;

import com.gsf.CRM.workbench.mapper.ClueActivityRelationMapper;
import com.gsf.CRM.workbench.pojo.ClueActivityRelation;
import com.gsf.CRM.workbench.service.ClueActivityRelationService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service("clueActivityRelationServiceImpl")
public class ClueActivityRelationServiceImpl implements ClueActivityRelationService {
      //业务逻辑层要有数据访问层的对象
      @Resource(name = "clueActivityRelationMapper")
      private ClueActivityRelationMapper clueActivityRelationMapper;

      @Override
      public int saveClueActivityRelation(ClueActivityRelation clueActivityRelation) {
            return clueActivityRelationMapper.insertClueActivityRelation(clueActivityRelation);
      }
}

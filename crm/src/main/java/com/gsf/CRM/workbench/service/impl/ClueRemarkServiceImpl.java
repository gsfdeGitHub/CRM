package com.gsf.CRM.workbench.service.impl;

import com.gsf.CRM.workbench.mapper.ClueRemarkMapper;
import com.gsf.CRM.workbench.pojo.ClueRemark;
import com.gsf.CRM.workbench.service.ClueRemarkService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service("clueRemarkServiceImpl")
public class ClueRemarkServiceImpl implements ClueRemarkService{
      //数据访问层的对象
      @Resource(name = "clueRemarkMapper")
      private ClueRemarkMapper clueRemarkMapper;

      @Override
      public List<ClueRemark> queryClueRemarkForDetailByClueId(String clueId) {
            return clueRemarkMapper.selectClueRemarkForDetailByClueId(clueId);
      }

      @Override
      public int saveCreateClueRemark(ClueRemark clueRemark) {
            return clueRemarkMapper.insertCreateClueRemark(clueRemark);
      }

      @Override
      public int removeClueRemarkById(String id) {
            return clueRemarkMapper.deleteClueRemarkById(id);
      }

      @Override
      public int modifyClueRemark(ClueRemark clueRemark) {
            return clueRemarkMapper.updateClueRemark(clueRemark);
      }
}

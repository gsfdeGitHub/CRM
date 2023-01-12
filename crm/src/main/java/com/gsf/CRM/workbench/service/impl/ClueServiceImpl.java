package com.gsf.CRM.workbench.service.impl;

import com.gsf.CRM.workbench.mapper.ClueMapper;
import com.gsf.CRM.workbench.pojo.Clue;
import com.gsf.CRM.workbench.service.ClueService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service("clueServiceImpl")
public class ClueServiceImpl implements ClueService {
      //业务逻辑层有数据访问层的对象
      @Resource(name = "clueMapper")
      private ClueMapper clueMapper;

      @Override
      public List<Clue> queryClueByConditionForPage(Map<String, Object> map) {
            return clueMapper.selectClueByConditionForPage(map);
      }

      @Override
      public int queryClueCountByConditionForPage(Map<String, Object> map) {
            return clueMapper.selectClueCountByConditionForPage(map);
      }

      @Override
      public int saveCreateClue(Clue clue) {
            return clueMapper.insertCreateClue(clue);
      }

      @Override
      public int removeClueById(String[] id) {
            return clueMapper.deleteClueById(id);
      }

      @Override
      public Clue queryClueById(String id) {
            return clueMapper.selectClueById(id);
      }

      @Override
      public int refreshClueById(Clue clue) {
            return clueMapper.updateClueById(clue);
      }

      @Override
      public Clue queryClueForDetailById(String id) {
            return clueMapper.selectClueForDetailById(id);
      }
}

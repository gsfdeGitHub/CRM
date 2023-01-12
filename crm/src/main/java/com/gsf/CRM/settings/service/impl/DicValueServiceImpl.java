package com.gsf.CRM.settings.service.impl;

import com.gsf.CRM.settings.mapper.DicValueMapper;
import com.gsf.CRM.settings.pojo.DicValue;
import com.gsf.CRM.settings.service.DicValueService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service("dicValueServiceImpl")
public class DicValueServiceImpl implements DicValueService {
      //数据访问层的对象
      @Resource(name ="dicValueMapper")
      private DicValueMapper dicValueMapper;

      @Override
      public List<DicValue> queryDicValueByTypeCode(String typeCode) {
            return dicValueMapper.selectDicValueByTypeCode(typeCode);
      }
}

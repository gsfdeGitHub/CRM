package com.gsf.CRM.settings.service;

import com.gsf.CRM.settings.pojo.DicValue;

import java.util.List;

public interface DicValueService {
      /**
       * 根据typeCode查询这个typeCode下的所有值
       * @param typeCode  控制层传过来的数据字典类型
       * @return  返回这个typeCode下的所有值
       */
      List<DicValue> queryDicValueByTypeCode(String typeCode);
}

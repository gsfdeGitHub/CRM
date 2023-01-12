package com.gsf.CRM.workbench.service;

import com.gsf.CRM.workbench.pojo.ClueRemark;

import java.util.List;

public interface ClueRemarkService {
      /**
       * 根据clueId查询这个线索下所有的备注
       * @param clueId    前端穿传过来的线索的id
       * @return      返回线索备注的实体类对象
       */
      List<ClueRemark> queryClueRemarkForDetailByClueId(String clueId);

      /**
       * 增加线索备注
       * @param clueRemark    控制器封装的线索备注的实体类对象
       * @return      返回受影响的记录条数
       */
      int saveCreateClueRemark(ClueRemark clueRemark);

      /**
       * 根据线索备注id删除线索备注
       * @param id       前端传过来的线索备注id
       * @return      返回受影响的记录条数
       */
      int removeClueRemarkById(String id);

      /**
       * 修改线索备注
       * @param clueRemark    控制层封装的ClueRemark实体类
       * @return      返回受影响的记录条数
       */
      int modifyClueRemark(ClueRemark clueRemark);
}

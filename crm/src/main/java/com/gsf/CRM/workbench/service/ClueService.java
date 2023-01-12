package com.gsf.CRM.workbench.service;

import com.gsf.CRM.workbench.pojo.Clue;

import java.util.List;
import java.util.Map;

public interface ClueService {

      /**
       * 根据查询条件查询线索
       * @param map   控制层封装的查询条件
       * @return  返回存储了线索的List集合
       */
      List<Clue> queryClueByConditionForPage(Map<String,Object> map);

      /**
       * 根据条件查询线索记录条数
       * @param map   控制层封装的查询条件
       * @return  返回存储了线索的List集合
       */
      int queryClueCountByConditionForPage(Map<String,Object> map);

      /**
       * 插入一条线索
       * @param clue  控制层封装好的clue实体类
       * @return  返回受影响的记录条数
       */
      int saveCreateClue(Clue clue);

      /**
       * 根据id删除线索
       * @param id    控制层封装的一个存储String类型的id 的数组
       * @return  返回受影响的记录条数
       */
      int removeClueById(String[] id);

      /**
       * 点击修改线索按钮，根据id查询线索
       * @param id    前端过来的id值
       * @return      返回一个Clue实体类对象
       */
      Clue queryClueById(String id);

      /**
       * 根据id修改线索
       * @param clue  控制层将前端传递过来的数据进行了封装
       * @return      返回受影响的记录条数
       */
      int refreshClueById(Clue clue);

      /**
       * 跳转明细页面，查询线索的信息
       * @param id    用户选择的那个线索的id
       * @return      返回线索对象
       */
      Clue queryClueForDetailById(String id);
}

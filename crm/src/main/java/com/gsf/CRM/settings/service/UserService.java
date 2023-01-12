package com.gsf.CRM.settings.service;

import com.gsf.CRM.settings.pojo.User;

import java.util.List;
import java.util.Map;

public interface UserService {
      User queryUserByLoginActAndLoginPwd(Map<String,Object> map);

      //查询所有的User返回一个List集合
      List<User> queryAllUsers();
}

package com.gsf.CRM.settings.service.impl;

import com.gsf.CRM.settings.mapper.UserMapper;
import com.gsf.CRM.settings.pojo.User;
import com.gsf.CRM.settings.service.UserService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service("userServiceImpl")
public class UserServiceImpl implements UserService {

      //在业务逻辑层中一定会有数据访问层的对象
      @Resource(name = "userMapper")
      private UserMapper userMapper;

      @Override
      public User queryUserByLoginActAndLoginPwd(Map<String,Object> map) {
            //返回mapper层查询到的user
            return userMapper.selectUserByLoginActAndLoginPwd(map);
      }

      @Override
      public List<User> queryAllUsers() {
            //返回mapper层查询到的List集合
            return userMapper.selectAllUsers();
      }
}

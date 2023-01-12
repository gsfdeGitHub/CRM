package com.gsf.CRM.web.Controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller("indexController")
public class IndexController {
      @RequestMapping(value = "/")
      public String toIndex(){
            return "forward:/WEB-INF/pages/index.jsp";
      }
}

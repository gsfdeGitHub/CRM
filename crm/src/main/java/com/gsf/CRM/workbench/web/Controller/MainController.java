package com.gsf.CRM.workbench.web.Controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller("mainController")
public class MainController {
      @RequestMapping("/workbench/main/index.do")
      public String toIndex(){
            //System.out.println(111);
            return "forward:/WEB-INF/pages/workbench/main/index.jsp";
      }
}

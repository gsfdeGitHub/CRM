package com.gsf.CRM.workbench.web.Controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller("workBenchController")
public class WorkBenchController {
      @RequestMapping(value = "/workbench/index.do")
      public String toAppIndex(){
            //System.out.println(111);
            return "forward:/WEB-INF/pages/workbench/index.jsp";
      }
}

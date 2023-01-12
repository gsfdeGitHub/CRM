package com.gsf.CRM.List;

import java.util.ArrayList;
import java.util.List;

public class ListTest {
      public static void main(String[] args) {
            List list = new ArrayList<>();
            list.add("zhangsan");
            list.add("lisi");
            list.add("wangwu");

            for(int i = 0 ; i < list.size() ; i++){
                  System.out.println(list.get(i));
            }
      }
}

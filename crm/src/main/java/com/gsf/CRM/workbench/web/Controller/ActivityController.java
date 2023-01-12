package com.gsf.CRM.workbench.web.Controller;

import com.gsf.CRM.commons.constant.Constant;
import com.gsf.CRM.commons.pojo.ReturnObject;
import com.gsf.CRM.commons.utils.DateTimeUtils;
import com.gsf.CRM.commons.utils.HSSFUtils;
import com.gsf.CRM.commons.utils.UUIDUtils;
import com.gsf.CRM.settings.pojo.User;
import com.gsf.CRM.settings.service.UserService;
import com.gsf.CRM.workbench.pojo.Activity;
import com.gsf.CRM.workbench.pojo.ActivityRemark;
import com.gsf.CRM.workbench.service.ActivityRemarkService;
import com.gsf.CRM.workbench.service.ActivityService;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.util.*;

@Controller("activityController")
public class ActivityController {

      //在控制层一定有业务逻辑层的对象
      @Resource(name = "userServiceImpl")
      private UserService userService;

      @Resource(name = "activityServiceImpl")
      private ActivityService activityService;

      @Resource(name = "activityRemarkServiceImpl")
      private ActivityRemarkService activityRemarkService;


      /**
       * 这是跳转到市场活动页面的方法
       * @param request       http的request对象
       * @return        请求转发到市场活动的主页面
       */
      @RequestMapping(value = "/workbench/activity/index.do")
      public String Index(HttpServletRequest request){
            //调用UserServiceImplement中的方法查询所有的User
            List<User> users = userService.queryAllUsers();
            request.setAttribute("usersList",users);
            return "forward:/WEB-INF/pages/workbench/activity/index.jsp";
      }


      /**
       * 这是保存市场活动的控制层方法
       * @param activity      这个实体类activity封装了市场活动的参数
       * @param session      当前会话session，里面存储了当前用户所有信息
       * @return        返回一个实体类RetObj，这个实体类因为@ResponseBody会自动转换成json格式的数据
       */
      @RequestMapping(value = "/workbench/activity/saveCreateActivity.do")
      @ResponseBody           //返回的实体类对象自动封装成json字符串
      //前端传过来的参数在接收的同时自动封装成实体类
      public Object saveCreateActivity(Activity activity, HttpSession session){
            //在当前session中存储有当前登录用户的信息
            User user = (User)session.getAttribute(Constant.SESSION_USER);

            activity.setId(UUIDUtils.getUUID());
            activity.setCreateTime(DateTimeUtils.formatDateTime(new Date()));
            activity.setCreateBy(user.getId());

            ReturnObject RetObj = new ReturnObject();

            try {
                  //返回受影响的记录条数
                  int count = activityService.saveCreateActivity(activity);

                  if(count > 0){
                        RetObj.setCode(Constant.PROCESSING_SUCCESS);
                  }else {
                        RetObj.setCode(Constant.PROCESSING_FAIL);
                        RetObj.setMessage("系统繁忙，请稍后再试......");
                  }
            } catch (Exception e) {
                  e.printStackTrace();

                  RetObj.setCode(Constant.PROCESSING_FAIL);
                  RetObj.setMessage("系统繁忙，请稍后再试......");
            }

            return RetObj;
      }

      /**
       * 分页查询的方法
       * @param name    查询条件：市场活动的名字
       * @param owner   查询条件：市场活动的所有者
       * @param startDate     查询条件：市场活动的开始时间
       * @param endDate       查询条件：市场活动的结束时间
       * @param pageNo        查询条件：用户想要查询的页码
       * @param pageSize       查询条件：用户想要的pageSize
       * @return        将查询到的市场活动封装到list中再和totalRows一起封装到map中
       */
      @RequestMapping(value = {"/workbench/activity/queryActivityByConditionForPage.do"})
      @ResponseBody
      public Object queryActivityByConditionForPage(String name,String owner,String startDate,String endDate,
                                                                              Integer pageNo,Integer pageSize){
            //获取前端提交的数据，封装数据
            Map<String,Object> map=new HashMap<>();
            map.put("name",name);
            map.put("owner",owner);
            map.put("startDate",startDate);
            map.put("endDate",endDate);
            map.put("beginNo",(pageNo-1)*pageSize);
            map.put("pageSize",pageSize);

            //调用业务逻辑层的方法
            List<Activity> activityList = activityService.queryActivityByConditionForPage(map);
            int totalRows = activityService.selectCountOfActivityByCondition(map);

            //将响应结果封装在一个map中，返回一个json格式的字符串
            Map<String,Object> retMap = new HashMap<>();
            retMap.put("activityList",activityList);
            retMap.put("totalRows",totalRows);

            //返回这个map集合，SpringMVC会自动转换成json
            return retMap;
      }

      /**
       * 根据id删除市场活动的方法
       * @param id  前端复选框的value里面传过来的id
       * @return  返回ReturnObject对象
       */
      @RequestMapping(value = "/workbench/activity/deleteActivityByIds.do")
      @ResponseBody
      public Object deleteActivityByIds(String [] id){

            //创建一个封装响应信息的实体类，将来返回的时候会转换成json对象
            ReturnObject retObj = new ReturnObject();

            try {
                  int count = activityService.deleteActivityByIds(id);
                  if(count == 0){
                        retObj.setCode(Constant.PROCESSING_FAIL);
                        retObj.setMessage("服务器繁忙，请稍后再试！");
                  }else {
                        retObj.setCode(Constant.PROCESSING_SUCCESS);
                  }
            } catch (Exception e) {
                  e.printStackTrace();
                  retObj.setMessage("服务器繁忙，请稍后再试！");
            }

            return retObj;
      }

      /**
       * 根据市场活动的id查询市场活动
       * @param id  前端传过来的要修改的市场活动的id
       * @return  返回这个要修改的市场活动的所有信息
       */
      @RequestMapping(value = "/workbench/activity/selectActivityById.do")
      @ResponseBody
      public Activity selectActivityById(String id){
            Activity activity = activityService.selectActivityById(id);
            return activity;
      }

      /**
       * 根据activity实体类中封装的市场活动的id去修改对应的市场活动
       * @param activity      前端传过来的需要修改的市场活动的信息全部都要封装在这个实体类中
       * @return        将是否修改成功和相应信息返回给ajax
       */
      @RequestMapping(value = "/workbench/activity/saveEditActivity.do")
      @ResponseBody
      public Object saveEditActivity(Activity activity,HttpSession session){

            //创建一个返回给前端的对象
            ReturnObject retObj = new ReturnObject();

            //将edit_time和edit_by两个字段赋值
            activity.setEditTime(DateTimeUtils.formatDateTime(new Date()));
            User sessionUser = (User) session.getAttribute(Constant.SESSION_USER);
            String editBy = sessionUser.getId();
            activity.setEditBy(editBy);

            //调用业务逻辑层的方法，返回修改的条数
            try {
                  int count = activityService.saveEditActivity(activity);
                  if(count == 1){
                        retObj.setCode(Constant.PROCESSING_SUCCESS);
                  }else {
                        retObj.setCode(Constant.PROCESSING_FAIL);
                        retObj.setMessage("服务器繁忙，请稍后再试！");
                  }
            } catch (Exception e) {
                  e.printStackTrace();
                  retObj.setCode(Constant.PROCESSING_FAIL);
                  retObj.setMessage("服务器繁忙，请稍后再试！");
            }

            return retObj;
      }

      /**
       * 这个只是文件下载的测试方法，跟业务没有关系，没有地方放才放这里的
       * @param response      HttpServletResponse
       * @throws IOException  将使用IO的异常抛出去，使代紧凑
       */
      @RequestMapping(value = "/workbench/activity/FileDownload.do")
      public void FileDownload(HttpServletResponse response) throws IOException {
            //1、设置响应的类型
            response.setContentType("application/octet-stream;charset=UTF-8");
            //从Tomcat服务器获取输出流
            ServletOutputStream out = response.getOutputStream();

            //
            response.addHeader("Content-Disposition","attachment;filename=studentList.xls");

            //创建文件输入流
            FileInputStream fis = new FileInputStream("E:\\studentList.xls");
            byte[] bytes = new byte[256];
            int len = 0;

            while ((len = fis.read(bytes)) != -1){
                        out.write(bytes,0,len);
            }

            fis.close();
            out.flush();

      }

      /**
       * 将市场活动批量导出的方法
       * @param response      HttpServletResponse对象
       * @throws IOException  使用IO读写Excel文件的时候将异常抛出去
       */
      @RequestMapping(value = "/workbench/activity/exportAllActivity.do")
      public void exportAllActivity(HttpServletResponse response) throws IOException {
            List<Activity> activityList = activityService.queryAllActivity();

            //创建一个Excel文件
            HSSFWorkbook wb = new HSSFWorkbook();
            //创建一张sheet
            HSSFSheet sheet = wb.createSheet("studentList");
            //创建一行
            HSSFRow row = sheet.createRow(0);
            //创建11列，对应数据库表中的11个字段
            HSSFCell cell = row.createCell(0);
            cell.setCellValue("ID");
            cell = row.createCell(1);
            cell.setCellValue("所有者");
            cell = row.createCell(2);
            cell.setCellValue("名字");
            cell = row.createCell(3);
            cell.setCellValue("开始日期");
            cell = row.createCell(4);
            cell.setCellValue("结束日期");
            cell = row.createCell(5);
            cell.setCellValue("成本");
            cell = row.createCell(6);
            cell.setCellValue("描述");
            cell = row.createCell(7);
            cell.setCellValue("创建时间");
            cell = row.createCell(8);
            cell.setCellValue("创建者");
            cell = row.createCell(9);
            cell.setCellValue("修改时间");
            cell = row.createCell(10);
            cell.setCellValue("修改者");

            Activity activity =null;
            //遍历activityList中的数据，每查出来一条市场活动，都将其放到Excel文件的一行中
            if(activityList.size() != 0 && activityList != null){
                  for(int i = 0 ; i < activityList.size() ; i++){
                        //每遍历一次，从activityList中取出一条记录
                        activity = activityList.get(i);
                        //每遍历一次，创建一行
                        row = sheet.createRow(i + 1);

                        cell = row.createCell(0);
                        cell.setCellValue(activity.getId());
                        cell = row.createCell(1);
                        cell.setCellValue(activity.getOwner());
                        cell = row.createCell(2);
                        cell.setCellValue(activity.getName());
                        cell = row.createCell(3);
                        cell.setCellValue(activity.getStartDate());
                        cell = row.createCell(4);
                        cell.setCellValue(activity.getEndDate());
                        cell = row.createCell(5);
                        cell.setCellValue(activity.getCost());
                        cell = row.createCell(6);
                        cell.setCellValue(activity.getDescription());
                        cell = row.createCell(7);
                        cell.setCellValue(activity.getCreateTime());
                        cell = row.createCell(8);
                        cell.setCellValue(activity.getCreateBy());
                        cell = row.createCell(9);
                        cell.setCellValue(activity.getEditTime());
                        cell = row.createCell(10);
                        cell.setCellValue(activity.getEditBy());

                  }
            }

            /*//根据wb生成Excel文件
            FileOutputStream fos = new FileOutputStream("E:\\activityList.xls");
            wb.write(fos);

            //关闭资源
            fos.close();
            wb.close();*/

            /*
            将文件下载到浏览器
             */

            response.setContentType("application/octet-stream;charset=UTF-8");
            //从Tomcat中借一个字节输出流
            ServletOutputStream out = response.getOutputStream();

            //设置响应头的信息
            response.addHeader("Content-Disposition","attachment;filename=activityList.xls");

            /*//使用文件输入流将硬盘上的Excel文件输入到内存中
            FileInputStream fis = new FileInputStream("E:\\activityList.xls");
            byte[] bytes = new byte[256];
            int len = 0;
            while ((len = fis.read(bytes)) != -1){
                  out.write(bytes,0,len);
            }

            //资源关闭
            fis.close();*/

            wb.write(out);
            wb.close();
            out.flush();
      }

      /**
       * 根据前端用户选择的市场活动id查询对应的市场活动存储到list集合中
       * @param id      前端用户传过来的id存在数组中
       * @param response      HttpServletResponse对象
       * @throws IOException      将IO异常抛出去
       */
      @RequestMapping(value = "/workbench/activity/exportSelectActivity.do")
      public void exportSelectActivity(String[] id,HttpServletResponse response) throws IOException {
            List<Activity> activityList = activityService.queryActivityByIds(id);

            //创建一个HSSFWorkbook对象
            HSSFWorkbook wb = new HSSFWorkbook();
            //创建一个HSSFSheet对象
            HSSFSheet sheet = wb.createSheet("ActivityPage");
            //创建第一行，作为表头
            HSSFRow row = sheet.createRow(0);
            //创建第11个列，放表头信息
            HSSFCell cell = row.createCell(0);
            cell.setCellValue("ID");
            cell = row.createCell(1);
            cell.setCellValue("所有者");
            cell = row.createCell(2);
            cell.setCellValue("名字");
            cell = row.createCell(3);
            cell.setCellValue("开始日期");
            cell = row.createCell(4);
            cell.setCellValue("结束日期");
            cell = row.createCell(5);
            cell.setCellValue("成本");
            cell = row.createCell(6);
            cell.setCellValue("描述");
            cell = row.createCell(7);
            cell.setCellValue("创建时间");
            cell = row.createCell(8);
            cell.setCellValue("创建者");
            cell = row.createCell(9);
            cell.setCellValue("修改时间");
            cell = row.createCell(10);
            cell.setCellValue("修改者");


            //在for循环外面创建一个Activity对象
            Activity activity = null;
            //创建后面的行，存储市场活动数据
            if(activityList != null && activityList.size() != 0){
                  for(int i = 0 ; i < activityList.size() ; i ++){
                        activity = activityList.get(i);
                        row = sheet.createRow(i + 1);

                        cell = row.createCell(0);
                        cell.setCellValue(activity.getId());
                        cell = row.createCell(1);
                        cell.setCellValue(activity.getOwner());
                        cell = row.createCell(2);
                        cell.setCellValue(activity.getName());
                        cell = row.createCell(3);
                        cell.setCellValue(activity.getStartDate());
                        cell = row.createCell(4);
                        cell.setCellValue(activity.getEndDate());
                        cell = row.createCell(5);
                        cell.setCellValue(activity.getCost());
                        cell = row.createCell(6);
                        cell.setCellValue(activity.getDescription());
                        cell = row.createCell(7);
                        cell.setCellValue(activity.getCreateTime());
                        cell = row.createCell(8);
                        cell.setCellValue(activity.getCreateBy());
                        cell = row.createCell(9);
                        cell.setCellValue(activity.getEditTime());
                        cell = row.createCell(10);
                        cell.setCellValue(activity.getEditBy());
                  }
            }

            //设置响应类型
            response.setContentType("application/octet-stream;charset=UTF-8");
            //从Tomcat中借来一个字节输出流对象
            ServletOutputStream out = response.getOutputStream();

            //设置响应头的类型
            response.addHeader("Content-Disposition","attachment;filename=activityList.xls");

            wb.write(out);
            wb.close();
            out.flush();
      }

      /**
       * 将浏览器上传的文件下载的服务器的方法，跟业务无关
       * 使用MultipartFile参数需要在SpringMVC的配置文件中配置一个类
       * @param userName      前端传过来的userName参数
       * @param myFile        前端传过来的文件
       * @return        返回一个json字符串
       */
      @RequestMapping("/workbench/activity/fileUpload.do")
      @ResponseBody
      public Object fileUpload(String userName, MultipartFile myFile) throws IOException {
            //将伴随而来的userName输出到控制台
            System.out.println("userName=" + userName);

            //MultipartFile参数有一个方法将myFile里面的数据导出到文件中，myFile.transferTo(File file)
            String originalFilename = myFile.getOriginalFilename();
            //服务器得先下载这个文件，然后将这个文件在插入数据库中
            File file = new File("E:\\aaa\\" + originalFilename);
            myFile.transferTo(file);

            //返回响应信息
            ReturnObject retObj = new ReturnObject();
            retObj.setCode(Constant.PROCESSING_SUCCESS);
            retObj.setMessage("上传成功");

            return retObj;
      }

      /**
       * 根据用户上传的Excel文件，将文件中的市场活动取出来插入到数据库中
       * @param activityFile        用来接收用户传过来的Excel文件
       * @return        返回json字符串
       */
      @RequestMapping(value = "/workbench/activity/ImportExcelActivity.do")
      @ResponseBody
      public Object ImportExcelActivity(MultipartFile activityFile,HttpSession session){
            //创建响应结果，将来会转换成字符串
            ReturnObject retObj = new ReturnObject();
            //从session中取出user对象
            User user = (User) session.getAttribute(Constant.SESSION_USER);

            try {
                  //将用户上传的Excel文件下载到服务器本地的这个位置
                  //activityFile.transferTo(new File("E:\\aaa\\" + activityFile.getOriginalFilename()));

                  //将已经下载到服务器本地的Excel文件中的数据放在wb对象中
                  //FileInputStream fis = new FileInputStream("E:\\aaa\\" + activityFile.getOriginalFilename());

                  //使用activityFile对象直接获取一个文件字节输入流，将处于内存中的activityFile中的文件输入到流对象中
                  InputStream fis = activityFile.getInputStream();

                  //再将上面获得的文件字节输入流作为参数传递到下面
                  HSSFWorkbook wb = new HSSFWorkbook(fis);

                  //解析wb对象中的Excel文件
                  HSSFSheet sheet = wb.getSheetAt(0);

                  HSSFRow row = null;
                  HSSFCell cell = null;
                  Activity activity = null;
                  //创建一个存储市场活动的List
                  List<Activity> activityList = new ArrayList<>();

                  for(int i = 1 ; i <= sheet.getLastRowNum() ; i++){       //通过循环将sheet中的每一行都遍历出来
                        row = sheet.getRow(i);       //得到一行
                        activity = new Activity();

                        /*用户上传的Excel文件中没有id这一列，所以在每循环出一行的时候，程序员就给这个市场活动
                              设置一个id*/
                        activity.setId(UUIDUtils.getUUID());
                              /*用户上传的Excel文件中没有owner这一列，所以我们将这个设计成谁导入的这个Excel文件
                              就将owner设置成谁*/
                        activity.setOwner(user.getId());
                              /*用户上传的Excel文件中没有createBy这一列，所以我们将这个设计成谁导入的这个Excel文件
                              就将createBy设置成谁*/
                        activity.setCreateBy(user.getId());
                        /*用户上传的Excel文件中没有createTime这一列，所以我们将这个设计成系统当前时间*/
                        activity.setCreateTime(DateTimeUtils.formatDateTime(new Date()));

                        for(int j = 0 ; j < sheet.getLastRowNum() ; j++){     //循环row中的每一列
                              cell = row.getCell(j);         //得到一列

                              String cellValueForStr = HSSFUtils.getCellValueForStr(cell);
                              if(j == 0){
                                    activity.setName(cellValueForStr);
                              }else if(j == 1){
                                    activity.setStartDate(cellValueForStr);
                              }else if(j == 2){
                                    activity.setEndDate(cellValueForStr);
                              }else if(j == 3){
                                    activity.setCost(cellValueForStr);
                              }else if(j == 4){
                                    activity.setDescription(cellValueForStr);
                              }
                        }

                        //一行遍历完之后，代表这一行的数据已经存储到activity对象中了
                        activityList.add(activity);

                  }
                  //调用service层方法
                  int count = activityService.importActivity(activityList);
                  if(count >= 0){
                        retObj.setCode(Constant.PROCESSING_SUCCESS);
                        retObj.setMessage("成功导入" + count + "条市场活动！");
                  }else {
                        retObj.setCode(Constant.PROCESSING_FAIL);
                        retObj.setMessage("服务器繁忙，请稍后再试！");
                  }
            } catch (IOException e) {
                  e.printStackTrace();
                  retObj.setCode(Constant.PROCESSING_FAIL);
                  retObj.setMessage("服务器繁忙，请稍后再试！");
            }

            return retObj;
      }

      /**
       * 导入市场活动的模板下载
       */
      @RequestMapping(value = "/workbench/activity/importExcelTemplate.do")
      public void importExcelTemplate(HttpServletResponse response,HttpServletRequest request){
            response.setContentType("application/octet-stream;charset=UTF-8");

            response.addHeader("Content-Disposition","attachment;filename=Template.xls");

            try {
                  ServletOutputStream out = response.getOutputStream();

                  FileInputStream fis = new FileInputStream("E:\\Java\\CRM客户管理系统\\MyCRM\\ImportTemplate\\Template.xls");
                  byte[] bytes = new byte[256];
                  int len = 0;
                  while ((len = fis.read(bytes)) != -1){
                        out.write(bytes , 0 , len);
                  }

                  fis.close();
                  out.flush();
            } catch (IOException e) {
                  e.printStackTrace();
                  request.setAttribute("message","服务器繁忙，请稍后再试！");
            }
      }

      /**
       * 实现点击市场活动超链接跳转到市场活动明细页面
       * @return  返回市场活动明细页面的资源路径
       */
      @RequestMapping(value = "/workbench/activity/detailActivity.do")
      public String detailActivity(String id,HttpServletRequest request){
            //调用activityService的queryActivityForDetail(String id)方法，查询市场活动的细节
            Activity activity = activityService.queryActivityForDetail(id);

            //调用activityRemarkService的queryActivityRemarkForDetailByActivityId(String activityId)方法
            //得到这个市场活动下的所有备注
            List<ActivityRemark> activityRemarkList = activityRemarkService.queryActivityRemarkForDetailByActivityId(id);

            //将查询到的市场活动和这个市场活动的所有备注存储到request作用域中
            request.setAttribute("activity",activity);
            request.setAttribute("activityRemarkList",activityRemarkList);

            //请求转发到市场活动明细页面
            return "forward:/WEB-INF/pages/workbench/activity/detail.jsp";
      }
}

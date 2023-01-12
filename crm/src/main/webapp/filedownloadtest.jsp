<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String BasePath = request.getScheme()+ "://"
            +request.getServerName()+":"+
            request.getServerPort()+
            request.getContextPath()+"/";
%>
<html>
<head>
    <base href="<%=BasePath%>" />
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <title>Title</title>
</head>
<body>
    <script type="text/javascript">
        $(function (){
            //给"下载"按钮添加鼠标单击事件
            $("#fileDownLoadBtn").click(function (){
                //发送同步请求，下载文件只能发送同步请求
                //发送同步请求的三种方式：1、超链接     2、form表单    3、地址栏
                window.location.href = "workbench/activity/FileDownload.do";
            })
        })
    </script>

    <input type="button" value="下载" id="fileDownLoadBtn">
</body>
</html>

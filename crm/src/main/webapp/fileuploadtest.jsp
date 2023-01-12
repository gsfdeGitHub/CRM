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
    <title>Title</title>
</head>
<body>
    <form action="workbench/activity/fileUpload.do" method="post" enctype="multipart/form-data">
        <input type="file" name="myFile">
        <input type="text" name="userName">
        <input type="submit" value="提交">
    </form>
</body>
</html>

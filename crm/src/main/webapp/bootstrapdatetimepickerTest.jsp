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

    <%--引入jQuery--%>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <%--引入bootstrap框架--%>
    <link rel="stylesheet" href="jquery/bootstrap_3.3.0/css/bootstrap.min.css">
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <%--引入开发包--%>
    <link rel="stylesheet" href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css">
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <title>Title</title>

    <script type="text/javascript">
        $(function (){
            $("#myDate").datetimepicker({
                language : 'zh-CN',         //指定语言
                format : 'yyyy-mm-dd',
                minView : "month",
                initialDate : new Date(),
                autoclose : true,
                todayBtn : true,
                clearBtn : true
            });
        });
    </script>
</head>
<body>

    <input type="text" id="myDate" readonly="readonly">

</body>
</html>

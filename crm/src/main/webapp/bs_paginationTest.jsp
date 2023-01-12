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
    <!--  JQUERY -->
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>

    <!--  BOOTSTRAP -->
    <link rel="stylesheet" type="text/css" href="jquery/bootstrap_3.3.0/css/bootstrap.min.css">
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <!--  PAGINATION plugin -->
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>
    <title>bs_pagination插件的使用</title>
</head>
<body>
    <script type="text/javascript">
        $(function (){
            $("#pag_div").bs_pagination({
                totalPages:100,  //总页码数
                currentPage:1,      //当前页码数
                rowsPerPage:10,     //每页显示的记录条数
                totalRows:1000,     //总记录条数
                visiblePageLinks: 5,    //每一组最多显示的卡片数
                showGoToPage: true,     //是否开启跳转到某一页的功能
                showRowsPerPage: true,      //是否显示每页显示多少条数据的功能
                showRowsInfo: true,     //是否显示记录的信息
                onChangePage:function (event,pageObj){

                }
            })
        })
    </script>
    <div id="pag_div"></div>


</body>
</html>

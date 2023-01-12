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
	<meta charset="UTF-8">
	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

	<%--编写js代码--%>
	<script type="text/javascript">
		$(function (){

			//给整个浏览器窗口添加键盘按下事件
			$(window).keydown(function (event){
				if(event.keyCode == 13){
					$("#loginBtn").click();			//click()方法不传参数表示在指定位置模拟一次鼠标单击事件
				}
			})

			$("#loginBtn").click(function (){

				//如果遇到网速慢的情况，在这里提示用户，后台正在验证
				/*$("#msg").text("正在验证登录，请稍后......")*/

				/*alert(111)*/
				//收集参数
				//获取用户输入的用户名的值
				var loginAct = $.trim($("#loginAct").val());
				//获取用户输入的密码的值
				var loginPwd = $.trim($("#loginPwd").val());
				//获取前台是否记住密码
				var isRemPwd = $("#isRemPwd").prop("checked");

				/*alert(loginAct);
                alert(loginPwd);*/

				//如果密码或者用户名为空，不要发送请求，直接在浏览器处理
				if(loginAct == "" || loginPwd == ""){
					/*alert("用户名不能为空！");*/
					$("#msg").text("用户名或密码不能为空！");
					return;
				}
				/*if(loginPwd == ""){
                    /!*alert("密码不能为空！");*!/
                    $("#msg").text("密码不能为空！");
                    return;
                }*/

				//密码和用户名不为空，发送ajax请求
				$.ajax({
					url:'settings/qx/user/login.do',
					type:'post',
					data:{
						"loginAct":loginAct,
						"loginPwd":loginPwd,
						"isRemPwd":isRemPwd
					},
					dataType:'json',
					success:function (data){
						if(data.code == "1"){
							//表示后端经过处理后能够让这个账号登录
							//在地址栏发送请求进行页面的跳转，但是跳转的页面在WEB-INF目录下，所以只能通过controller进行转发
							window.location.href="workbench/index.do"
							$("#msg").text("登陆成功");
						}else{
							$("#msg").text(data.message);
						}
					},
					beforeSend:function (){
						$("#msg").text("正在验证登录，请稍后......");
						return true;
					}
				})
			})
		})

	</script>

</head>
<body>
	<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;gsf</span></div>
	</div>

	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<form action="workbench/index.html" class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input class="form-control" id="loginAct" type="text" value="${cookie.loginAct.value}" placeholder="用户名">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input class="form-control" id="loginPwd" type="password" value="${cookie.loginPwd.value}" placeholder="密码">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
						<label>
							<c:if test="${not empty cookie.loginAct and not empty cookie.loginPwd}">
								<input type="checkbox" id="isRemPwd" checked>
							</c:if>
							<c:if test="${empty cookie.loginAct or empty cookie.loginPwd}">
								<input type="checkbox" id="isRemPwd">
							</c:if>
							记住密码
						</label>
						&nbsp;&nbsp;
						<span id="msg"></span>
					</div>
					<button type="button" id="loginBtn" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>
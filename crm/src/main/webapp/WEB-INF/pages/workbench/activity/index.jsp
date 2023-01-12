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
	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<!--  PAGINATION plugin -->
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>

	<script type="text/javascript">

		$(function(){

			//给 "清空" 按钮添加鼠标单击事件
			$("#resetFrom").click(function (){
				//点击之后清空创建市场活动的表单
				$("#createActivityForm").get(0).reset();
			});

			//给 "创建" 按钮添加鼠标单击事件
			$("#createActivityBtn").click(function (){
				//在"创建市场活动"模态窗口弹出之前，执行我们所需的js代码

				/*每次弹出模态窗口之前都清空表单
                $("#createActivityForm").get(0).reset();*/

				//js代码控制"创建市场活动"模态窗口的弹出
				$("#createActivityModal").modal("show");
			})

			//给 "保存" 按钮添加鼠标单击事件
			$("#saveCreateActivityBtn").click(function (){
				//收集参数
				var owner = $("#create-marketActivityOwner").val();
				var name = $.trim($("#create-marketActivityName").val());
				var startDate = $("#create-startDate").val();
				var endDate = $("#create-endDate").val();
				var cost = $.trim($("#create-cost").val());
				var description = $("#create-description").val();

				//进行表单验证，不符合需求的输入全部不允许发送请求
				if(owner == ""){
					alert("所有者不能为空");
					return;
				}
				if(name == ""){
					alert("活动名称不能为空");
					return;
				}
				if(startDate != "" && endDate != ""){
					if(startDate > endDate){
						alert("结束日期不能比开始日期小")
						return;
					}
				}
				var regExp = /^(([1-9]\d*)|0)$/;
				if(!regExp.test(cost)){
					alert("成本只能为非负整数")
					return;
				}

				//表单验证通过之后，发送ajax请求
				$.ajax({
					url : 'workbench/activity/saveCreateActivity.do',
					data : {
						"owner" : owner,
						"name" : name,
						"startDate" : startDate,
						"endDate" : endDate,
						"cost" : cost,
						"description" : description
					},
					type : 'post',
					dataType : 'json',
					// 以下回调函数是接收后端响应之后做出的处理，data形参是后端ActivityController控制器返回的
					// JSON格式的字符串
					success : function (data){
						if(data.code == "1"){		//创建成功
							//清空模态窗口，关闭模态窗口
							$("#createActivityForm").get(0).reset();
							$("#createActivityModal").modal("hide");
							//刷新市场活动列，显示第一页数据，保持每页显示条数不变（保留）
							queryActivityByConditionForPage(1,$("#pag_div").bs_pagination('getOption','rowsPerPage'));

						}else {							//创建失败
							//提示信息创建失败
							alert(data.message);
							//模态窗口不关闭
							$("#createActivityModal").modal("show");		//这行代码可以不写，模态窗口本来就没关
						}
					}
				});
			})

			//当容器加载完毕之后，给 "开始日期" 和 "结束时间" 输入框添加方法，点击它能够弹出日历
			$(".myDate").datetimepicker({
				language : 'zh-CN',         //指定语言
				format : 'yyyy-mm-dd',		//指定日期的格式
				minView : "month",			//指定能选择时间的最小度量
				initialDate : new Date(),	//默认时间是系统当前时间
				autoclose : true,			//选完了是否自动关闭
				todayBtn : true,			//是否显示 "今天" 按钮
				clearBtn : true				//是否显示 "Clear" 按钮
			});

			//市场活动主页面加载完毕，查询所有数据的总条数，并将第一页数据显示在浏览器上
			queryActivityByConditionForPage(1,10);

			//给 "查询" 按钮添加鼠标监听事件
			$("#selectActivityBtn").click(function (){
				queryActivityByConditionForPage(1,$("#pag_div").bs_pagination('getOption','rowsPerPage'));
			});

			//给市场活动的全选框添加鼠标单击事件
			$("#checkAll").click(function (){

				/*if(this.checked == true){
					$("#tBody input[type='checkbox']").prop("checked",true);
				}else {
					$("#tBody input[type='checkbox']").prop("checked",false);
				}*/

				$("#tBody input[type='checkbox']").prop("checked",this.checked);
			})

			//给全选框下面的全部复选框加上鼠标点击事件
			/*$("#tBody input[type='checkbox']").click(function (){
				//拿到这个复选框的jQuery数组的长度和选中了的jQuery数组的长度进行对比
				if($("#tBody input[type='checkbox']").size() == $("#tBody input[type='checkbox']:checked").size()){
					$("#checkAll").prop("checked",true)
				}else{
					$("#checkAll").prop("checked",false)
				}
			})*/
			//给全选框下面的全部复选框加上鼠标点击事件
			$("#tBody").on("click","input[type='checkbox']",function (){
				//拿到这个复选框的jQuery数组的长度和选中了的jQuery数组的长度进行对比
				if($("#tBody input[type='checkbox']").size() == $("#tBody input[type='checkbox']:checked").size()){
					$("#checkAll").prop("checked",true)
				}else{
					$("#checkAll").prop("checked",false)
				}
			})

			//给"删除"按钮添加单击事件
			$("#deleteActivityBtn").click(function (){
				//收集参数
				var checkIds = $("#tBody input[type='checkbox']:checked")
				if(checkIds.size() == 0){
					alert("请选择要删除的市场活动！")
					return
				}

				if(window.confirm("确定删除市场活动吗？")){
					var ids = ""
					$.each(checkIds,function (){
						ids+="id="+this.value+"&"
					})
					ids = ids.substr(0,ids.length-1)

					//发送ajax请求
					$.ajax({
						url : "workbench/activity/deleteActivityByIds.do",
						data : ids,
						type : "post",
						dataType : "json",
						success : function (data){
							if(data.code == 1){
								//删除成功之后,刷新市场活动列表,显示第一页数据,保持每页显示条数不变
								queryActivityByConditionForPage(1,$("#pag_div").bs_pagination('getOption','rowsPerPage'))
							}else {
								alert(data.message)
							}
						}
					})
				}
			})

			//给 "修改" 按钮添加鼠标单击事件
			$("#updateActivityBtn").click(function (){

				//获取参数
				var checkId = $("#tBody input[type='checkbox']:checked");

				//表单验证
				if(checkId.size() == 0){
					alert("请选择您要修改的市场活动！")
					return;
				}
				if(checkId.size() > 1){
					alert("只能选择一个市场活动进行修改！")
					return;
				}

				//将checkId这个jQuery对象的数组遍历取出复选框对应的id
				var id = checkId.val();

				//发送ajax请求
				$.ajax({
					url : "workbench/activity/selectActivityById.do",
					data : {
						"id" : id
					},
					type : "post",
					dataType : "json",
					success : function (data){
						//把市场活动的信息替换成查询到的信息
						$("#edit_id").val(data.id)
						$("#edit-marketActivityOwner").val(data.owner)
						$("#edit-marketActivityName").val(data.name)
						$("#edit-startTime").val(data.startDate)
						$("#edit-endTime").val(data.endDate)
						$("#edit-cost").val(data.cost)
						$("#edit-description").val(data.description)

						//弹出 "修改" 市场活动的模态窗口
						$("#editActivityModal").modal("show")
					}
				})
			})

			//对 "更新" 按钮绑定鼠标单击事件
			$("#editActivityBtn").click(function (){
				//收集参数
				var id = $("#edit_id").val();
				var owner = $("#edit-marketActivityOwner").val();
				var name = $.trim($("#edit-marketActivityName").val());
				var startDate = $("#edit-startTime").val();
				var endDate = $("#edit-endTime").val();
				var cost = $.trim($("#edit-cost").val());
				var description = $.trim($("#edit-description").val());

				//表单验证
				if(name == ""){
					alert("活动名称不能为空！")
					return
				}
				if(startDate != "" && endDate != ""){
					if(startDate > endDate){
						alert("开始日期不能大于结束日期")
						return;
					}
				}
				var reg = /^(([1-9]\d*)|0)$/;
				if(!reg.test(cost)){
					alert("成本只能为非负整数！")
					return;
				}

				//发送ajax请求
				$.ajax({
					url : "workbench/activity/saveEditActivity.do",
					data : {
						"id" : id,
						"owner" : owner,
						"name" : name,
						"startDate" : startDate,
						"endDate" : endDate,
						"cost" : cost,
						"description" : description
					},
					type : "post",
					dataType : "json",
					success : function (data){
						if(data.code == "1"){
							alert("修改成功！")
							$("#editActivityModal").modal("hide")
							queryActivityByConditionForPage(
									$("#pag_div").bs_pagination('getOption','currentPage'),
									$("#pag_div").bs_pagination('getOption','rowsPerPage')
							)
						}else{
							alert(data.message)
						}
					}
				})
			})

			//给 "批量导出" 按钮添加鼠标单击事件
			$("#exportActivityAllBtn").click(function (){
				window.location.href = "workbench/activity/exportAllActivity.do";
			})

			//给 "选择导出" 按钮添加鼠标单击事件
			$("#exportActivityXzBtn").click(function (){
				//收集参数
				var checked = $("#tBody input[type='checkbox']:checked")

				//表单验证
				if(checked.length == 0){
					alert("请选择您要导出的市场活动！")
					return
				}

				//拼接一个存储了若干个id的字符串
				var id = "?";
				$.each(checked ,function (){
					id+="id="+this.value+"&"
				})
				id = id.substr(0,id.length - 1)

				window.location.href = "workbench/activity/exportSelectActivity.do" + id;

				queryActivityByConditionForPage(
						$("#pag_div").bs_pagination('getOption','currentPage'),
						$("#pag_div").bs_pagination('getOption','rowsPerPage')
				)
			})

			//给 "导入" 按钮添加鼠标单击事件
			$("#importActivityBtn").click(function (){
				//获取用户导入的文件名
				var activityFileName = $("#activityFile").val();
				var suffix = activityFileName.substr(activityFileName.lastIndexOf(".")).toLocaleLowerCase();

				//表单验证
				if(suffix != ".xls"){
					alert("请导入.xls文件")
					return
				}

				//获取用户上传的文件本身
				var activityFile = $("#activityFile").get(0).files[0];
				//判断文件大小是否超过5M
				if(activityFile.size > 1024*1024*5){
					alert("文件大小不能超过5M")
					return
				}

				//使用FormData接口向后端传递二进制数据Excel文件
				var formData = new FormData();
				formData.append("activityFile",activityFile);

				//发送ajax请求
				$.ajax({
					url : "workbench/activity/ImportExcelActivity.do",
					data : formData,
					//设置ajax向后台发送请求之前，是否把参数都统一转换成字符串，默认是ture，true---是;false---不是
					processData : false,
					//设置ajax向后台发送请求之前，是否把所有的参数都按照urlencoded编码。默认是true，true---是;false---不是
					contentType : false,
					type : "post",
					dataType : "json",
					success : function (data){
						if(data.code == "1"){
							//导入成功,提示成功导入记录条数,关闭模态窗口,刷新市场活动列表,显示第一页数据,保持每页显示条数不变
							alert(data.message)
							$("#importActivityModal").modal("hide")
							queryActivityByConditionForPage(1,$("#pag_div").bs_pagination('getOption','rowsPerPage'))
						}else{
							//导入失败,提示信息,模态窗口不关闭,列表也不刷新
							alert(data.message)
							$("#importActivityModal").modal("show")
						}
					}
				})
			})

			//给 "下载导入文件模板" 添加鼠标单击事件
			$("#downloadTemplateBtn").click(function (){
				window.location.href = "workbench/activity/importExcelTemplate.do";
			})


		});		//这是当jsp页面加载完毕后执行的js方法的末尾

		// 将查询功能的js代码封装
		function queryActivityByConditionForPage (pageNo,pageSize){
			//收集参数
			var name = $("#activityNameID").val();
			var owner = $("#activityOwnerID").val();
			var startDate = $("#startTimeID").val();
			var endDate = $("#endTimeID").val();
			//var pageNo = 1;
			//var pageSize = 10;

			//发送异步请求
			$.ajax({
				url: 'workbench/activity/queryActivityByConditionForPage.do',
				data: {
					"name" : name,
					"owner" : owner,
					"startDate" : startDate,
					"endDate" : endDate,
					"pageNo" : pageNo,
					"pageSize" : pageSize
				},
				type: 'post',
				dataType: 'json',
				success : function (data){
					//在显示记录条数的地方，将后端传过来的数据写入
					//$("#totalRowsB").text(data.totalRows);
					//显示市场活动的列表
					var htmlStr="";
					$.each(data.activityList,function (index,obj) {
						htmlStr+="<tr class=\"active\">";
						htmlStr+="<td><input type=\"checkbox\" value=\""+obj.id+"\"/></td>";
						htmlStr+="<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/activity/detailActivity.do?id="+obj.id+"'\">"+obj.name+"</a></td>";
						htmlStr+="<td>"+obj.owner+"</td>";
						htmlStr+="<td>"+obj.startDate+"</td>";
						htmlStr+="<td>"+obj.endDate+"</td>";
						htmlStr+="</tr>";
					});
					$("#tBody").html(htmlStr);

					//每次拼完列表，都将全选框的选中状态设置为false没有选中
					$("#checkAll").prop("checked",false);

					//totalPages总页数，在这里计算出页数，供后面bs_pagination插件使用
					var totalPages = 1;
					if(data.totalRows%pageSize == 0){
						totalPages = data.totalRows/pageSize;
					}else{
						totalPages = parseInt(data.totalRows/pageSize) + 1;
					}

					//给翻页等功能的div添加工具方法，使这个div能够显示那些翻页功能
					$("#pag_div").bs_pagination({
						totalPages: totalPages,  //总页码数
						currentPage:pageNo,      //当前页码数
						rowsPerPage:pageSize,     //每页显示的记录条数
						totalRows:data.totalRows,     //总记录条数
						visiblePageLinks: 5,    //每一组最多显示的卡片数
						showGoToPage: true,     //是否开启跳转到某一页的功能
						showRowsPerPage: true,      //是否显示每页显示多少条数据的功能
						showRowsInfo: true,     //是否显示记录的信息
						onChangePage:function (event,pageObj){
							queryActivityByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage);
						}
					})
				}
			});
		}
	</script>
</head>
<body>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">

					<form id="createActivityForm" class="form-horizontal" role="form">

						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">
									<c:forEach items="${usersList}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-marketActivityName" class="col-sm-2 control-label">活动名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-marketActivityName">
							</div>
						</div>

						<div class="form-group">
							<label for="create-startDate" class="col-sm-2 control-label" >开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control myDate" id="create-startDate" readonly="readonly">
							</div>
							<label for="create-endDate" class="col-sm-2 control-label" >结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control myDate" id="create-endDate"  readonly="readonly">
							</div>
						</div>
						<div class="form-group">

							<label for="create-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-cost">
							</div>
						</div>
						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>

					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" id="resetFrom" class="btn btn-default" >清空</button>
					<button type="button" class="btn btn-primary" id="saveCreateActivityBtn">保存</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">

					<form class="form-horizontal" role="form">

						<input type="hidden" id="edit_id">
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">
									<c:forEach items="${usersList}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-marketActivityName">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control myDate" id="edit-startTime" readonly>
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control myDate" id="edit-endTime" readonly>
							</div>
						</div>

						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>

					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="editActivityBtn" >更新</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 导入市场活动的模态窗口 -->
	<div class="modal fade" id="importActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
				</div>
				<div class="modal-body" style="height: 350px;">
					<div style="position: relative;top: 20px; left: 50px;">
						请选择要上传的文件：<small style="color: gray;">[仅支持.xls]</small>
					</div>
					<div style="position: relative;top: 40px; left: 50px;">
						<input type="file" id="activityFile">
					</div><br>
					<div style="position: relative;top: 40px; left: 50px;">
						<input type="button" id="downloadTemplateBtn" value="下载导入文件模板">
					</div>
					<div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
						<h3>重要提示</h3>
						<ul>
							<li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
							<li>给定文件的第一行将视为字段名。</li>
							<li>请确认您的文件大小不超过5MB。</li>
							<li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
							<li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
							<li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
							<li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
						</ul>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
				</div>
			</div>
		</div>
	</div>


	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">

			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

					<div class="form-group">
						<div class="input-group">
							<div class="input-group-addon">名称</div>
							<input class="form-control" type="text" id="activityNameID">
						</div>
					</div>

					<div class="form-group">
						<div class="input-group">
							<div class="input-group-addon">所有者</div>
							<input class="form-control" type="text" id="activityOwnerID">
						</div>
					</div>


					<div class="form-group">
						<div class="input-group">
							<div class="input-group-addon">开始日期</div>
							<input class="form-control myDate" type="text" id="startTimeID" readonly/>
						</div>
					</div>
					<div class="form-group">
						<div class="input-group">
							<div class="input-group-addon">结束日期</div>
							<input class="form-control myDate" type="text" id="endTimeID" readonly>
						</div>
					</div>

					<button type="button" class="btn btn-default" id="selectActivityBtn">查询</button>

				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
					<button type="button" class="btn btn-primary" id="createActivityBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
					<button type="button" class="btn btn-default" id="updateActivityBtn" ><span class="glyphicon glyphicon-pencil"></span> 修改</button>
					<button type="button" class="btn btn-danger" id="deleteActivityBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
						<button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal" ><span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）</button>
					<button id="exportActivityAllBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）</button>
					<button id="exportActivityXzBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）</button>
				</div>
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
					<tr style="color: #B3B3B3;">
						<td><input type="checkbox" id="checkAll"/></td>
						<td>名称</td>
						<td>所有者</td>
						<td>开始日期</td>
						<td>结束日期</td>
					</tr>
					</thead>
					<tbody id="tBody">
					<%--<tr class="active">
                        <td><input type="checkbox" /></td>
                        <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>
                        <td>zhangsan</td>
                        <td>2020-10-10</td>
                        <td>2020-10-20</td>
                    </tr>
                    <tr class="active">
                        <td><input type="checkbox" /></td>
                        <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>
                        <td>zhangsan</td>
                        <td>2020-10-10</td>
                        <td>2020-10-20</td>
                    </tr>--%>
					</tbody>
				</table>

				<%--显示翻页等这些功能的div--%>
				<div id="pag_div"></div>
			</div>

			<%--<div style="height: 50px; position: relative;top: 30px;">
				<div>
					<button type="button" class="btn btn-default" style="cursor: default;">共<b id="totalRowsB">50</b>条记录</button>
				</div>
				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">
					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>
					<div class="btn-group">
						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
							10
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu" role="menu">
							<li><a href="#">20</a></li>
							<li><a href="#">30</a></li>
						</ul>
					</div>
					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
				</div>
				<div style="position: relative;top: -88px; left: 285px;">
					<nav>
						<ul class="pagination">
							<li class="disabled"><a href="#">首页</a></li>
							<li class="disabled"><a href="#">上一页</a></li>
							<li class="active"><a href="#">1</a></li>
							<li><a href="#">2</a></li>
							<li><a href="#">3</a></li>
							<li><a href="#">4</a></li>
							<li><a href="#">5</a></li>
							<li><a href="#">下一页</a></li>
							<li class="disabled"><a href="#">末页</a></li>
						</ul>
					</nav>
				</div>
			</div>--%>

		</div>

	</div>
</body>
</html>
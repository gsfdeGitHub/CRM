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

<%--引入datetimepicker开发包--%>
<link rel="stylesheet" href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css">
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript">

	$(function(){

		//线索页面加载完毕之后，调用分页查询的方法
		queryClueByConditionForPage(1,10);

		//给"查询"按钮添加鼠标单击事件
		$("#condition-select").click(function (){
			queryClueByConditionForPage(1,$("#page_div").bs_pagination("getOption","rowsPerPage"))
		})

		//给"创建"按钮添加鼠标单击事件
		$("#createClueBtn").click(function (){
			$("#createClueModal").modal("show")
		})

		//给"保存"按钮添加鼠标单击事件
		$("#save-clue").click(function (){
			//收集参数
			var owner = $("#create-clueOwner option:selected").val();
			var company = $.trim($("#create-company").val());
			var appellation = $("#create-call option:selected").val();
			var fullname = $.trim($("#create-surname").val());
			var job = $.trim($("#create-job").val());
			var email = $.trim($("#create-email").val());
			var phone = $.trim($("#create-phone").val());
			var website = $.trim($("#create-website").val());
			var mphone = $.trim($("#create-mphone").val());
			var state = $("#create-status option:selected").val();
			var source = $("#create-source option:selected").val();
			var description = $.trim($("#create-describe").val());
			var contact_summary = $.trim($("#create-contactSummary").val());
			var next_contact_time = $.trim($("#create-nextContactTime").val());
			var address = $.trim($("#create-address").val());

			//表单验证
			if(company == ''){
				alert("公司名不能为空！")
				return;
			}
			if(fullname == ''){
				alert("姓名不能为空！")
				return;
			}
			var regExpEmail = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/
			if(!regExpEmail.test(email)){
				alert("请出入正确的邮箱！")
				 return;
			}
			var regExpWeb = /^(?=^.{3,255}$)[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(\.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+$/
			if(!regExpWeb.test(website)){
				alert("请输入正确的网址！")
				return;
			}
			var regExpMPhone = /^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/
			if(!regExpMPhone.test(mphone)){
				alert("请输入正确的手机号码！")
				return;
			}

			//发送ajax请求
			$.ajax({
				url : "workbench/clue/createClue.do",
				data : {
					"owner"  : owner,
					"company"  : company,
					"appellation"  : appellation,
					"fullname"  : fullname,
					"job"  : job,
					"email"  : email,
					"phone"  : phone,
					"website"  : website,
					"mphone"  : mphone,
					"state"  : state,
					"source"  : source,
					"description"  : description,
					"contactSummary"  : contact_summary,
					"nextContactTime"  : next_contact_time,
					"address"  : address
				},
				dataType: "json",
				type: "post",
				success : function (data){
					//关闭模态窗口，刷新线索列表，显示第一页数据，保持每页显示条数不变
					if(data.code == "1"){
						$("#createClueModal").modal("hide")
						queryClueByConditionForPage(1,$("#page_div").bs_pagination("getOption","rowsPerPage"))
						//重置创建线索的表单
						$("#createClueId")[0].reset();
					}else {
						//提示信息，模态窗口不关闭，列表也不刷新。
						alert(data.message)
						$("#createClueModal").modal("show")
					}
				}
			})
		})

		//给创建线索的模态窗口中的下次联系时间加上bootstrap-datetimepicker插件
		$("#create-nextContactTime").datetimepicker({
			language : 'zh-CN',         //指定语言
			format : 'yyyy-mm-dd',		//指定日期的格式
			minView : "month",			//指定能选择时间的最小度量
			initialDate : new Date(),	//默认时间是系统当前时间
			autoclose : true,			//选完了是否自动关闭
			todayBtn : true,			//是否显示 "今天" 按钮
			clearBtn : true,				//是否显示 "Clear" 按钮
			pickerPosition:'top-right'
		})

		//给修改线索的模态窗口中的下次联系时间加上bootstrap-datetimepicker插件
		$("#edit-nextContactTime").datetimepicker({
			language : 'zh-CN',         //指定语言
			format : 'yyyy-mm-dd',		//指定日期的格式
			minView : "month",			//指定能选择时间的最小度量
			initialDate : new Date(),	//默认时间是系统当前时间
			autoclose : true,			//选完了是否自动关闭
			todayBtn : true,			//是否显示 "今天" 按钮
			clearBtn : true,				//是否显示 "Clear" 按钮
			pickerPosition:'top-right'
		})

		//给全选框添加鼠标单击事件
		$("#selectAllBox").click(function (){
			$("#tBody input[type='checkbox']").prop("checked",this.checked)
		})

		//给复选框和全选框做验证
		$("#tBody").on("click"," input[type='checkbox']",function (){
			if($("#tBody input[type='checkbox']").size() == $("#tBody input[type='checkbox']:checked").size()){
				$("#selectAllBox").prop("checked",true)
			}else {
				$("#selectAllBox").prop("checked",false)
			}
		})

		//给"删除"按钮添加鼠标单击事件
		$("#deleteClueBtn").click(function (){
			//收集参数
			var checked = $("#tBody input[type='checkbox']:checked");
			//表单验证
			if(checked.size() == 0){
				alert("请选择您要删除的线索！")
				return
			}

			if(window.confirm("确认删除线索吗？")){
				var id = ""
				$.each(checked,function (index,obj){
					id += "id="+ obj.value + "&"
				})
				id = id.substr(0,id.length -1)

				//发送ajax请求
				$.ajax({
					url : "workbench/clue/removeClue.do",
					data : id,
					dataType: "json",
					type : "post",
					success : function (data){
						if(data.code == "1"){
							queryClueByConditionForPage(1,$("#page_div").bs_pagination("getOption","rowsPerPage"))
						}else{
							alert(data.message)
						}
					}
				})
			}
		})

		//给"修改"按钮添加鼠标单击事件
		$("#editClueBtn").click(function (){
			//收集参数
			var checked = $("#tBody input[type='checkbox']:checked")
			if(checked.size() == 0){
				alert("请选择要修改的线索！")
				return;
			}
			if(checked.size() > 1){
				alert("只能选择一个线索！")
				return;
			}

			//获取用户选择的那个线索的id值
			var id = checked.val();

			$.ajax({
				url : "workbench/clue/queryClueById.do",
				data : {
					"id" : id
				},
				dataType : "json",
				type : "post",
				success : function (data){
					$("#edit-id").val(data.id)		//将对应的线索的id放在隐藏域中，将来发送给后端的就是这个
					$("#edit-clueOwner").val(data.owner)
					$("#edit-company").val(data.company)
					$("#edit-call").val(data.appellation)
					$("#edit-surname").val(data.fullname)
					$("#edit-job").val(data.job)
					$("#edit-email").val(data.email)
					$("#edit-phone").val(data.phone)
					$("#edit-website").val(data.website)
					$("#edit-mphone").val(data.mphone)
					$("#edit-status").val(data.state)
					$("#edit-source").val(data.source)
					$("#edit-describe").val(data.description)
					$("#edit-contactSummary").val(data.contactSummary)
					$("#edit-nextContactTime").val(data.nextContactTime)
					$("#edit-address").val(data.address)

					//弹出模态窗口
					$("#editClueModal").modal("show")
				}
			})
		})

		//给"更新"按钮添加鼠标单击事件
		$("#updateClueBtn").click(function (){
			//收集参数
			var id = $("#edit-id").val();
			var owner = $("#edit-clueOwner").val();
			var company = $.trim($("#edit-company").val());
			var appellation = $("#edit-call").val();
			var fullname = $.trim($("#edit-surname").val());
			var job = $.trim($("#edit-job").val());
			var email = $.trim($("#edit-email").val());
			var phone = $.trim($("#edit-phone").val());
			var website = $.trim($("#edit-website").val());
			var mphone = $.trim($("#edit-mphone").val());
			var state = $("#edit-status").val();
			var source = $("#edit-source").val();
			var description = $.trim($("#edit-describe").val());
			var contactSummary = $.trim($("#edit-contactSummary").val());
			var nextContactTime = $("#edit-nextContactTime").val();
			var address = $.trim($("#edit-address").val());

			//表单验证
			if(company == ''){
				alert("公司不能为空！")
				return
			}
			if(fullname == ''){
				alert("姓名不能为空")
			}
			var regExpEmail = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/
			if(!regExpEmail.test(email)){
				alert("请输入正确的邮箱！")
				return;
			}
			var regExpWeb = /^(?=^.{3,255}$)[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(\.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+$/
			if(!regExpWeb.test(website)){
				alert("请输入正确的网址！")
				return;
			}
			var regExpMPhone = /^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/
			if(!regExpMPhone.test(mphone)){
				alert("请输入正确的手机号码！")
				return;
			}

			//发送ajax请求
			$.ajax({
				url : "workbench/clue/refreshClue.do",
				data: {
					"id" : id,
					"fullname" : fullname,
					"appellation" : appellation,
					"owner" : owner,
					"company" : company,
					"job" : job,
					"email" : email,
					"phone" : phone,
					"website" : website,
					"mphone" : mphone,
					"state" : state,
					"source" : source,
					"description" : description,
					"contactSummary" : contactSummary,
					"nextContactTime" : nextContactTime,
					"address" : address
				},
				dataType : "json",
				type : "post",
				success : function (data){
					if(data.code == "1"){
						alert("修改成功")
						$("#editClueModal").modal("hide")
						queryClueByConditionForPage(
								$("#page_div").bs_pagination("getOption","currentPage"),
								$("#page_div").bs_pagination("getOption","rowsPerPage"))
					}else {
						alert(data.message)
						$("#editClueModal").modal("show")
					}
				}
			})
		})

		//给创建Clue的"清空"按钮添加鼠标单击事件
		$("#resetCreateClueBtn").click(function (){
			$("#createClueId").get(0).reset()
		})

	});			//这是入口函数的末尾

	//将查找线索的方法封装起来
	function queryClueByConditionForPage(pageNo,pageSize){
		//收集参数
		var fullName = $("#condition-fullName").val();
		var company = $("#condition-company").val();
		var phone = $("#condition-phone").val();
		var source = $("#condition-source option:selected").val();
		var owner = $("#condition-owner").val();
		var mPhone = $("#condition-mPhone").val();
		var state = $("#condition-state option:selected").val();

		//发送ajax异步请求
		$.ajax({
			url:"workbench/clue/queryClueByConditionForPage.do",
			data:{
				"fullName" : fullName,
				"company" : company,
				"phone" : phone,
				"source" : source,
				"owner" : owner,
				"mPhone" : mPhone,
				"state" : state,
				"pageNo" : pageNo,
				"pageSize" : pageSize
			},
			dataType : "json",
			type : "post",
			success : function (data) {
				var htmlStr = ""
				$.each(data.clueList,function (index,obj){
					htmlStr += "<tr class=\"active\">"
					htmlStr += "<td><input type=\"checkbox\" value=\""+obj.id+"\" /></td>"
					htmlStr += "<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/clue/toDetail.do?id="+obj.id+"'\">"+obj.fullname + obj.appellation+"</a></td>"
					htmlStr += "<td>"+obj.company+"</td>"
					htmlStr += "<td>"+obj.phone+"</td>"
					htmlStr += "<td>"+obj.mphone+"</td>"
					htmlStr += "<td>"+obj.source+"</td>"
					htmlStr += "<td>"+obj.owner+"</td>"
					htmlStr += "<td>"+obj.state+"</td>"
					htmlStr += "</tr>"
				})
				$("#tBody").html(htmlStr)

				//每次拼完列表，都将全选框设置为没有选中
				$("#selectAllBox").prop("checked",false)

				//根据后端返回的totalRows计算总页数
				var totalPages = 0;
				if(data.totalRows % pageSize == 0){
					totalPages = data.totalRows/pageSize;
				}else{
					var number = parseInt(data.totalRows/pageSize);
					totalPages = number + 1
				}

				//给翻页等功能的div添加工具方法，使这个div能够显示那些翻页功能
				$("#page_div").bs_pagination({
					totalPages : totalPages,
					currentPage : pageNo,
					rowsPerPage : pageSize,
					totalRows : data.totalRows,
					visiblePageLinks : 5,
					showGoToPage : true,
					showRowsPerPage : true,
					showRowsInfo : true,
					onChangePage : function (event, pageObj) {
						queryClueByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage)
					}
				})
			}
		})
	}
	
</script>
</head>
<body>

	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form id="createClueId" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-clueOwner">
								  <c:forEach items="${userList}" var="user">
									  <option value="${user.id}">${user.name}</option>
								  </c:forEach>
								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-call">
									<option></option>
									<c:forEach items="${appellationList}" var="appellation">
										<option value="${appellation.id}">${appellation.value}</option>
									</c:forEach>
								  <%--<option></option>
								  <option>先生</option>
								  <option>夫人</option>
								  <option>女士</option>
								  <option>博士</option>
								  <option>教授</option>--%>
								</select>
							</div>
							<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-surname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-status">
									<option></option>
									<c:forEach items="${clueStateList}" var="state">
										<option value="${state.id}">${state.value}</option>
									</c:forEach>
								  <%--<option></option>
								  <option>试图联系</option>
								  <option>将来联系</option>
								  <option>已联系</option>
								  <option>虚假线索</option>
								  <option>丢失线索</option>
								  <option>未联系</option>
								  <option>需要条件</option>--%>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
									<option></option>
									<c:forEach items="${sourceList}" var="source">
										<option value="${source.id}">${source.value}</option>
									</c:forEach>
								  <%--<option></option>
								  <option>广告</option>
								  <option>推销电话</option>
								  <option>员工介绍</option>
								  <option>外部介绍</option>
								  <option>在线商场</option>
								  <option>合作伙伴</option>
								  <option>公开媒介</option>
								  <option>销售邮件</option>
								  <option>合作伙伴研讨会</option>
								  <option>内部研讨会</option>
								  <option>交易会</option>
								  <option>web下载</option>
								  <option>web调研</option>
								  <option>聊天</option>--%>
								</select>
							</div>
						</div>
						

						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">线索描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="create-nextContactTime" readonly>
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<input type="button" value="清空" class="btn btn-default" id="resetCreateClueBtn">
					<button type="button" class="btn btn-primary" id="save-clue">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-id">
						<div class="form-group">
							<label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueOwner">
									<c:forEach items="${userList}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-call">
									<option></option>
									<c:forEach items="${appellationList}" var="appellation">
										<option value="${appellation.id}">${appellation.value}</option>
									</c:forEach>
								  <%--<option></option>
								  <option selected>先生</option>
								  <option>夫人</option>
								  <option>女士</option>
								  <option>博士</option>
								  <option>教授</option>--%>
								</select>
							</div>
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-surname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone">
							</div>
							<label for="edit-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-status">
									<option></option>
									<c:forEach items="${clueStateList}" var="state">
										<option value="${state.id}">${state.value}</option>
									</c:forEach>
								  <%--<option></option>
								  <option>试图联系</option>
								  <option>将来联系</option>
								  <option selected>已联系</option>
								  <option>虚假线索</option>
								  <option>丢失线索</option>
								  <option>未联系</option>
								  <option>需要条件</option>--%>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
									<option></option>
									<c:forEach items="${sourceList}" var="source">
										<option value="${source.id}">${source.value}</option>
									</c:forEach>
								  <%--<option></option>
								  <option selected>广告</option>
								  <option>推销电话</option>
								  <option>员工介绍</option>
								  <option>外部介绍</option>
								  <option>在线商场</option>
								  <option>合作伙伴</option>
								  <option>公开媒介</option>
								  <option>销售邮件</option>
								  <option>合作伙伴研讨会</option>
								  <option>内部研讨会</option>
								  <option>交易会</option>
								  <option>web下载</option>
								  <option>web调研</option>
								  <option>聊天</option>--%>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-nextContactTime" readonly>
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateClueBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>线索列表</h3>
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
				      <input class="form-control" type="text" id="condition-fullName">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input class="form-control" type="text" id="condition-company">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" type="text" id="condition-phone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select class="form-control" id="condition-source">
						  <option></option>
						  <c:forEach items="${sourceList}" var="source">
							  <option value="${source.id}">${source.value}</option>
						  </c:forEach>
					  	  <%--<option></option>
					  	  <option>广告</option>
						  <option>推销电话</option>
						  <option>员工介绍</option>
						  <option>外部介绍</option>
						  <option>在线商场</option>
						  <option>合作伙伴</option>
						  <option>公开媒介</option>
						  <option>销售邮件</option>
						  <option>合作伙伴研讨会</option>
						  <option>内部研讨会</option>
						  <option>交易会</option>
						  <option>web下载</option>
						  <option>web调研</option>
						  <option>聊天</option>--%>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="condition-owner">
				    </div>
				  </div>
				  
				  
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input class="form-control" type="text" id="condition-mPhone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select class="form-control" id="condition-state">
						  <option></option>
						  <c:forEach items="${clueStateList}" var="state">
							  <option value="${state.id}">${state.value}</option>
						  </c:forEach>
						  <%--<option></option>
						<option>试图联系</option>
					  	<option>将来联系</option>
					  	<option>已联系</option>
					  	<option>虚假线索</option>
					  	<option>丢失线索</option>
					  	<option>未联系</option>
					  	<option>需要条件</option>--%>
					  </select>
				    </div>
				  </div>

				  <button type="button" class="btn btn-default" id="condition-select">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createClueBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editClueBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteClueBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="selectAllBox"/></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="tBody">
                        <%--<tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='';">李四先生</a></td>
                            <td>动力节点</td>
                            <td>010-84846003</td>
                            <td>12345678901</td>
                            <td>广告</td>
                            <td>zhangsan</td>
                            <td>已联系</td>
                        </tr>--%>
					</tbody>
				</table>

				<%--将来显示分页插件的div--%>
				<div id="page_div"></div>
			</div>
			
			<%--<div style="height: 50px; position: relative;top: 60px;">
				<div>
					<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>
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
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

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		
		/*$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});*/
		$("#remarkListDiv").on("mouseover",".remarkDiv",function (){
			$(this).children("div").children("div").show();
		})
		
		/*$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});*/
		$("#remarkListDiv").on("mouseout",".remarkDiv",function (){
			$(this).children("div").children("div").hide();
		})

		/*$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});*/
		$("#remarkListDiv").on("mouseover",".myHref",function (){
			$(this).children("span").css("color","red");
		})
		
		/*$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});*/
		$("#remarkListDiv").on("mouseout",".myHref",function (){
			$(this).children("span").css("color","#E6E6E6");
		})

        //给创建线索备注的"保存"按钮添加鼠标单击事件
        $("#saveClueRemarkBtn").click(function (){
            //收集参数
            var clueId = '${clue.id}'
            var noteContent = $.trim($("#remark").val());

            //表单验证
             if(noteContent == ''){
                 alert("备注信息不能为空！")
                 return
             }

             //发送ajax请求
            $.ajax({
                url : "workbench/clue/insertClueRemark.do",
                data : {
                    "clueId" : clueId,
                    "noteContent" : noteContent
                },
                dataType : "json",
                type : "post",
                success : function (data){
                    if(data.code == "1"){
                        var htmlStr = "";
                        htmlStr+="<div id=\"div_"+data.retData.id+"\" class=\"remarkDiv\" style=\"height: 60px;\">"
                        htmlStr+="<img title=\"${sessionScope.sessionUser.name}\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">"
				        htmlStr+="<div style=\"position: relative; top: -40px; left: 40px;\">"
					    htmlStr+="<h5>"+data.retData.noteContent+"</h5>"
					    htmlStr+="<font color=\"gray\">线索</font> <font color=\"gray\">-</font> <b>${clue.fullname}${clue.appellation}-${clue.company}</b> <small style=\"color: gray;\"> "+data.retData.createTime+" 由${sessionScope.sessionUser.name}创建</small>"
					    htmlStr+="<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">"
						htmlStr+="<a class=\"myHref\" name=\"editA\" remarkId=\""+data.retData.id+"\" <%--href="javascript:void(0);"--%>><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>"
						htmlStr+="&nbsp;&nbsp;&nbsp;&nbsp;"
						htmlStr+="<a class=\"myHref\" name=\"deleteA\" remarkId=\""+data.retData.id+"\" <%--href="javascript:void(0);"--%>><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>"
					    htmlStr+="</div>"
				        htmlStr+="</div>"
			            htmlStr+="</div>"

                        $("#remarkTitalDiv").after(htmlStr)

                        //清空textarea中的内容
                        $("#remark").val("")

                    }else {
                        alert(data.message)
                    }
                }
            })
        })

		//给删除图标添加鼠标单击事件
		$("#remarkListDiv").on("click"," a[name='deleteA']",function (){
			//获取这个图标的remarkId属性值
			var id = $(this).attr("remarkId");

			//发送ajax请求
			$.ajax({
				url : "workbench/clue/deleteClueRemark.do",
				data : {
					"id" : id
				},
				dataType: "json",
				type: "post",
				success : function (data){
					if(data.code == "1"){
						$("#div_"+id).remove()
					}else {
						alert(data.message)
					}
				}
			})
		})

		//给修改图标添加鼠标单击事件
		$("#remarkListDiv").on("click"," a[name='editA']",function (){
			//收集参数
			var id = $(this).attr("remarkId");
			var noteContent = $("#div_"+id+" h5").text();

			//弹出修改线索备注的模态窗口
			$("#editRemarkModal").modal("show")

			//将收集的参数赋值给模态窗口
			$("#edit-Id").val(id)
			$("#edit-noteContent").val(noteContent)
		})

		//给"更新"按钮添加鼠标单击事件
		$("#updateRemarkBtn").click(function (){
			//收集参数
			var id = $("#edit-Id").val();
			var noteContent = $.trim($("#edit-noteContent").val());

			if(noteContent == ""){
				alert("修改的备注内容不能为空！")
				return
			}

			//收集这个线索原本的备注内容
			var initialNoteContent = $("#div_"+id+" h5").text();
			if(initialNoteContent == noteContent){
				alert("请修改线索备注！")
				return;
			}

			//发送ajax请求
			$.ajax({
				url : "workbench/clue/updateClueRemark.do",
				data : {
					"id" : id,
					"noteContent" : noteContent
				},
				dataType : "json",
				type : "post",
				success : function (data){
					if(data.code == "1"){
						//关闭模态窗口
						$("#editRemarkModal").modal("hide")

						//修改数据
						$("#div_"+id+" h5").text(data.retData.noteContent)
						$("#div_"+id+" small").text(" "+data.retData.editTime + " 由${sessionScope.sessionUser.name}修改")
					}else {
						alert(data.message)
						$("#editRemarkModal").modal("show")
					}
				}
			})
		})

		//给"关联市场活动"按钮添加鼠标单击事件
		$("#bundActivityBtn").click(function (){
			//初始化工作
			$("#tBody").html("")
			//显示模态窗口
			$("#bundModal").modal("show")
		})

		//给搜索市场活动的输入框添加键盘按下事件
		$("#selectActivityText").keydown(function (event){
			if(event.keyCode == 13){
				//收集参数
				var clueId = '${clue.id}'
				var activityName =  $.trim(this.value)

				//发送ajax请求
				$.ajax({
					url : "workbench/clue/queryActivityForDetailByNameAndClueId.do",
					data : {
						"activityName": activityName,
						"clueId" : clueId
					},
					dataType: "json",
					type : "post",
					success : function (data){
						var htmlStr = ""
						$.each(data,function (index,obj){
							htmlStr +="<tr>"
							htmlStr +="<td><input value='"+obj.id+"' type=\"checkbox\"/></td>"
							htmlStr +="<td>"+obj.name+"</td>"
							htmlStr +="<td>"+obj.startDate+"</td>"
							htmlStr +="<td>"+obj.endDate+"</td>"
							htmlStr +="<td>"+obj.owner+"</td>"
							htmlStr +="</tr>"

							$("#tBody").html(htmlStr)
						})
					}
				})
			}
		})

		//给关联市场活动的模态窗口中的全选框添加鼠标单击事件
		$("#AllSelect").click(function (){
			$("#tBody input[type='checkbox']").prop("checked",this.checked)
		})

		//给关联市场活动的模态窗口中除了全选框之外的复选框加上鼠标单击事件
		$("#tBody").on("click"," input[type='checkbox']",function (){
			if($("#tBody input[type='checkbox']").size() == $("#tBody input[type='checkbox']:checked").size()){
				$("#AllSelect").prop("checked",true)
			}else {
				$("#AllSelect").prop("checked",false)
			}
		})

		//给"关联"按钮添加鼠标单击事件
		$("#associatedClueActivity").click(function (){
			//收集参数
			var clueId = '${clue.id}'
			var activityId = $("#tBody input:checked").val();

			//发送ajax请求
			$.ajax({
				url : "workbench/clue/increaseClueActivityRelation.do",
				data : {
					"clueId" : clueId,
					"activityId" : activityId
				},
				dataType : "json",
				type : "post",
				success : function (data){
					if(data.code == "1"){
						//关闭模态窗口，刷新已经关联过的市场活动列表
						$("#bundModal").modal("hide")

						var htmlStr = ""
						$.each(data.retData,function (index,obj){
							htmlStr+="<tr>"
							htmlStr+="<td>"+obj.name+"</td>"
							htmlStr+="<td>"+obj.startDate+"</td>"
							htmlStr+="<td>"+obj.endDate+"</td>"
							htmlStr+="<td>"+obj.owner+"</td>"
							htmlStr+="<td><a href=\"javascript:void(0);\"  style=\"text-decoration: none;\"><span class=\"glyphicon glyphicon-remove\"></span>解除关联</a></td>"
							htmlStr+="</tr>"

							$("#associatedActivitytBody").html(htmlStr)
						})
					}else {
						//提示信息，模态窗口不关闭，已经关联过的市场活动列表也不刷新
						$("#bundModal").modal("show")
					}
				}
			})
		})

	});         //这是入口函数的末尾
	
</script>

</head>
<body>

	<!--修改线索备注的模态窗口-->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%--备注的id--%>
		<div class="modal-dialog" role="document" style="width: 40%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改备注</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-Id">
						<div class="form-group">
							<label for="edit-noteContent" class="col-sm-2 control-label">内容</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-noteContent"></textarea>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 关联市场活动的模态窗口 -->
	<div class="modal fade" id="bundModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form" onsubmit="return false;">
						  <div class="form-group has-feedback">
							  <input id="selectActivityText" type="text" class="form-control" style="width: 400px;" placeholder="请输入市场活动名称，支持模糊查询，按回车键查询">
							  <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input id="AllSelect" type="checkbox"/></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="tBody">
							<%--<tr>
								<td><input type="checkbox"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="checkbox"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>--%>
						</tbody>
					</table>

					<%--显示分页查询市场活动的div--%>
					<div id="page_div"></div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="associatedClueActivity">关联</button>
				</div>
			</div>
		</div>
	</div>


	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${clue.fullname}${clue.appellation} <small>${clue.company}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" onclick="window.location.href='convert.html';"><span class="glyphicon glyphicon-retweet"></span> 转换</button>
			
		</div>
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.fullname}${clue.appellation} </b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.owner}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.company}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.job}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">线索状态</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.state}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${clue.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${clue.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 100px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                    ${clue.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div  id="remarkListDiv" style="position: relative; top: 40px; left: 40px;">
		<div class="page-header" id="remarkTitalDiv">
			<h4>备注</h4>
		</div>

		<c:forEach items="${clueRemarkList}" var="remark">
			<div id="div_${remark.id}" class="remarkDiv" style="height: 60px;">
				<img title="${remark.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;" >
					<h5>${remark.noteContent}</h5>
					<font color="gray">线索</font> <font color="gray">-</font> <b>${clue.fullname}${clue.appellation}-${clue.company}</b> <small style="color: gray;"> ${remark.editFlag=="0" ? remark.createTime:remark.editTime} 由${remark.editFlag=="0"?remark.createBy:remark.editBy}${remark.editFlag=="0"?"创建":"修改"}</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
						<a class="myHref" name="editA" remarkId="${remark.id}" <%--href="javascript:void(0);"--%>><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a class="myHref" name="deleteA" remarkId="${remark.id}" <%--href="javascript:void(0);"--%>><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
					</div>
				</div>
			</div>
		</c:forEach>
		<!-- 备注1 -->
		<%--<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>--%>
		
		<!-- 备注2 -->
		<%--<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>呵呵！</h5>
				<font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>--%>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button id="saveClueRemarkBtn" type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="associatedActivitytBody">
						<c:forEach items="${activityList}" var="activity">
							<tr>
								<td>${activity.name}</td>
								<td>${activity.startDate}</td>
								<td>${activity.endDate}</td>
								<td>${activity.owner}</td>
								<td><a href="javascript:void(0);" activityId="${activity.id}"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
							</tr>
						</c:forEach>
						<%--<tr>
							<td>发传单</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>zhangsan</td>
							<td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>
						<tr>
							<td>发传单</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>zhangsan</td>
							<td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>--%>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" id="bundActivityBtn" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>
	
	
	<div style="height: 200px;"></div>
</body>
</html>
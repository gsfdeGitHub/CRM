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
		$("#remarkDivList").on("mouseover",".remarkDiv",function (){
			$(this).children("div").children("div").show();
		})

		/*$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});*/
		$("#remarkDivList").on("mouseout",".remarkDiv",function (){
			$(this).children("div").children("div").hide();
		})

		/*$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});*/
		$("#remarkDivList").on("mouseover",".myHref",function (){
			$(this).children("span").css("color","red");
		})

		/*$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});*/
		$("#remarkDivList").on("mouseout",".myHref",function (){
			$(this).children("span").css("color","#E6E6E6");
		})

        //给 "保存" 按钮添加鼠标单击事件
        $("#saveCreateActivityRemarkBtn").click(function (){
            //收集参数
            var noteContent = $.trim($("#remark").val());   //用户自己输入的内容都要去除前后空白
            var activityId = '${activity.id}';

            //进行表单验证
            if(noteContent == ''){
                alert("请输入备注信息")
                return
            }


            //发送ajax请求
            $.ajax({
                url : "workbench/activity/saveCreateActivityRemark.do",
                dataType : "json",
                type : "post",
                data : {
                    "activityId" : activityId,
                    "noteContent" : noteContent
                },
                success : function (data){
                    if(data.code == "1"){
                        //清空输入框
                        $("#remark").val("")

                        //刷新备注列表
                        var htmlStr = ""

						htmlStr+="<div id=\"div_"+data.retData.id+"\" class=\"remarkDiv\" style=\"height: 60px;\">";
						htmlStr+='<img title="${sessionScope.sessionUser.name}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">'
						htmlStr+='<div style="position: relative; top: -40px; left: 40px;">'
						htmlStr+="<h5>"+data.retData.noteContent+"</h5>"
                    	htmlStr+='<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;"> '+data.retData.createTime+' 由${sessionScope.sessionUser.name}创建</small>'
						htmlStr+='<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">'
                        htmlStr+='<a class="myHref" name="editA" remarkId="'+data.retData.id+' " <!----><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>'
						htmlStr+='&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'
                        htmlStr+='<a class="myHref" name="deleteA" remarkId="'+data.retData.id+'" <!----><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>'
						htmlStr+='</div>'
                		htmlStr+='</div>'
						htmlStr+='</div>'

                        //将上面拼好的字符串追加显示在输入备注内容的div前面
                        $("#remarkTitleDiv").after(htmlStr)


                    }else{
                        //添加失败,提示信息,输入框不清空,列表也不刷新
                        alert(data.message)
                    }
                }
            })
        })

		//给所有"删除"市场活动备注的图标添加鼠标单击事件
		$("#remarkDivList").on("click"," a[name='deleteA']",function (){
			//收集参数
			var id = $(this).attr("remarkId");

			//发送ajax请求
			$.ajax({
				url: "workbench/activity/removeActivityRemark.do",
				data: {
					"id" : id
				},
				type: "post",
				dataType: "json",
				success : function (data){
					//删除成功之后,刷新备注列表
					if(data.code == "1"){
						$("#div_"+id).remove();
					}else {
						alert(data.message)
					}
				}
			})
		})

        //给所有的"修改"市场活动备注的图标添加鼠标单击事件
        $("#remarkDivList").on("click","a[name='editA']",function (){
            //获取此时前端备注的noteContent和id
            var id = $(this).attr("remarkId");
            //var noteContent = $("#h5_"+id).text();
			var noteContent = $("#div_"+id +" h5").text();

            //弹出修改备注的模态窗口
            $("#editRemarkModal").modal("show");

            //给模态窗口的隐藏域赋id值
            $("#edit-Id").val(id);
            //给模态窗口的textarea赋noteContent值
            $("#edit-noteContent").val(noteContent);

        })

		//给修改市场活动的"更新"按钮添加鼠标单击事件
		$("#updateRemarkBtn").click(function (){
			//获取模态窗口中的id值和noteContent值
			var id = $("#edit-Id").val();
			var noteContent = $.trim($("#edit-noteContent").val());


			//表单验证，备注内容不能为空
			if(noteContent == ""){
				alert("请输入备注信息！")
				return
			}

			//获取这条备注原本的内容
			var initialNoteContent = $("#div_"+id +" h5").text();
			//将这条备注原本的内容和用户新输入的内容进行对比，相同的话阻止其向后端发送请求
			if(initialNoteContent == noteContent){
				alert("请修改备注内容！")
				return;
			}

			//发送ajax请求
			$.ajax({
				url:"workbench/activity/updateActivityRemark.do",
				data:{
					"id" : id,
					"noteContent" : noteContent
				},
				dataType:"json",
				type:"post",
				success : function (data){
					//修改成功之后,关闭模态窗口,刷新备注列表
					if(data.code == "1"){
						$("#editRemarkModal").modal("hide")
						//修改noteContent
						$("#div_"+id + " h5").text(data.retData.noteContent)
						//把之前的时间改成这次的修改时间
						$("#div_" +id + " small").text(" "+data.retData.editTime + " 由${sessionScope.sessionUser.name}修改");
					}else {
						//修改失败,提示信息,模态窗口不关闭,列表也不刷新
						alert(data.message)
						$("#editRemarkModal").modal("show")
					}
				}
			})
		})


	});         //这是js入口函数的末尾
	
</script>

</head>
<body>
	
	<!--修改市场活动备注的模态窗口-->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%--备注的id--%>
		<input type="hidden" id="remarkId">
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

    

	<!--返回按钮-->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!--大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
            <h3>市场活动-${activity.name} <small> ${activity.startDate} ~ ${activity.endDate} </small></h3>
		</div>
		
    </div>
	
	<br/>
	<br/>
	<br/>

	<!--详细信息-->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">开始日期</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.startDate}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.endDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">成本</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.cost}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${activity.description}
				</b>
            </div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!--备注-->
	<div style="position: relative; top: 30px; left: 40px;" id="remarkDivList">
		<div class="page-header" id="remarkTitleDiv">
            <h4>备注</h4>
		</div>
		
		<!--备注1-->
		<%--使用jstl标签库对activityRemarkList进行循环--%>
		<c:forEach items="${activityRemarkList}" var="remark">
			<div id="div_${remark.id}" class="remarkDiv" style="height: 60px;">
				<img title="${remark.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;">
					<h5>${remark.noteContent}</h5>
                    <font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;"> ${remark.editFlag == '1'?remark.editTime:remark.createTime} 由${remark.editFlag=='1'?remark.editBy:remark.createBy}${remark.editFlag == '1'?'修改':'创建'}</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                        <a class="myHref" name="editA" remarkId="${remark.id}" ><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
                        <a class="myHref" name="deleteA" remarkId="${remark.id}" ><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
					</div>
                </div>
			</div>
		</c:forEach>

		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary" id="saveCreateActivityRemarkBtn">保存</button>
				</p>
			</form>
		</div>
	</div>
	<div style="height: 200px;"></div>
</body>
</html>
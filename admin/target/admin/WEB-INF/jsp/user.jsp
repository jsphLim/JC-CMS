<%@ page language="java" contentType="text/html;charset=utf-8" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>

<!doctype html>
<html lang="zh">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="description" content="暨创后台管理系统">
    <meta name="keywords" content="暨创后台管理系统">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <meta name="format-detection" content="telephone=no">
    <title>暨创后台管理系统</title>
    <link rel="icon" href="favicon.ico" type="image/x-icon">
    <link rel="stylesheet" type="text/css" href="css/common.css"/>
    <link rel="stylesheet" type="text/css" href="css/slide.css"/>
    <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css"/>
    <link rel="stylesheet" type="text/css" href="css/flat-ui.min.css"/>
    <script type="text/javascript" src="js/jquery.min.js"></script>
    <script type="text/javascript" src="js/bootstrap.min.js"></script>
    <script type="text/javascript" src="js/slide.js"></script>
    <script type="text/javascript" src="js/jquery.validate.min.js"></script>
    <script type="text/javascript" src="js/messages_zh.min.js"></script>
    <script type="text/javascript" src="js/md5.js"></script>
</head>

<style type="text/css">
    .error {
        font-weight: bold;
        padding-left: 16px;
        color: #FFC0CB;
    }
</style>

<body>

<div id="wrap">

    <!--左侧菜单栏-->
    <jsp:include page="nav.jsp"></jsp:include>

    <!--右侧内容栏-->
    <div id="rightContent">
        <!--修改密码模块-->
        <div role="tabpanel" class="tab-pane active" id="user">
            <div class="check-div">
                如果忘记密码，请联系 1656704949@qq.com
            </div>
            <div style="background-color: #fff; text-align: right;width: 600px;padding: 50px 0;margin: 50px auto;">
                <form class="form-horizontal" id="updateForm">
                    <div class="form-group">
                        <label for="oldPwd" class="col-xs-4 control-label">原密码：</label>
                        <div class="col-xs-5">
                            <input type="password" name="oldPwd" id="oldPwd" class="form-control input-sm duiqi"
                                   placeholder="" style="margin-top: 7px;">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="newPwd" class="col-xs-4 control-label">新密码：</label>
                        <div class="col-xs-5">
                            <input type="password" name="newPwd" id="newPwd" class="form-control input-sm duiqi"
                                   placeholder="" style="margin-top: 7px;">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="repeatPwd" class="col-xs-4 control-label">重复密码：</label>
                        <div class="col-xs-5">
                            <input type="password" name="repeatPwd" id="repeatPwd" class="form-control input-sm duiqi"
                                   placeholder="" style="margin-top: 7px;">
                        </div>
                    </div>
                    <div class="form-group text-right">
                        <div class="col-xs-offset-4 col-xs-5">
                            <button type="reset" class="btn btn-xs btn-white">取 消</button>
                            <button type="button" class="btn btn-xs btn-green" id="updateBtn">修 改</button>
                            <span id="tip"> </span>
                        </div>
                    </div>
                </form>
            </div>
        </div><!--修改密码模块-->
    </div><!--右侧内容栏-->

</div>

<script type="text/javascript">
    $(function () {
        $("#user-menu").addClass("meun-item-active");

        $("#updateBtn").click(function () {
                if ($("#updateForm").valid()) {
                    // 异步提交
                    $.ajax({
                        url: "user/update",
                        type: "POST",
                        data: {
                            "oldPwd": hex_md5($("#oldPwd").val()),
                            "newPwd": hex_md5($("#newPwd").val())
                        },
                        beforeSend: function () {
                            $("#tip").html('<span style="color:blue">正在修改...</span>');
                        },
                        success: function (res) {
                            if (res) {
                                alert("修改成功");
                            } else {
                                alert("密码错误");
                            }
                        },
                        error: function (XMLHttpRequest, textStatus, errorThrown) {
                            alert("服务器出错：" + XMLHttpRequest.status);
                        },
                        complete: function (XMLHttpRequest, textStatus) {
                            // 重置输入
                            $(':input', '#updateForm')
                                .not(':button, :submit, :reset, :hidden').val('')
                                .removeAttr('checked').removeAttr('selected');
                            $("#tip").html('<span id="tip"> </span>');
                            // 清空提示
                            validator.resetForm();
                        }
                    });
                }
            });

        // 验证表单
        var validator = $("#updateForm").validate(
            {
                rules: {
                    oldPwd: {
                        required: true,
                        rangelength: [6, 16]
                    },
                    newPwd: {
                        required: true,
                        rangelength: [6, 16]
                    },
                    repeatPwd: {
                        required: true,
                        equalTo: "#newPwd"
                    }
                },
                messages: {
                    oldPwd: {
                        required: "×",
                        rangelength: "长度范围[6-16]"
                    },
                    newPwd: {
                        required: "×",
                        rangelength: "长度范围[6-16]"
                    },
                    repeatPwd: {
                        required: "×",
                        equalTo: "密码不一致"
                    }
                },
                success: function (label) {
                    label.text("√"); // 正确时候输出
                },
                errorPlacement: function (error, element) {
                    // Append error within linked label
                    $(element)
                        .closest("form")
                        .find("label[for='" + element.attr("id") + "']")
                        .append(error);
                }
            });
    });
</script>

</body>
</html>
<%@ page language="java" contentType="text/html;charset=utf-8" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>

<!doctype html>
<html lang="zh">
<head>
    <base href="<%=basePath%>">
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="description" content="暨创后台管理系统">
    <meta name="keywords" content="暨创后台管理系统">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <meta name="format-detection" content="telephone=no">
    <title>暨创后台管理系统</title>
    <link rel="icon" href="favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/login.css">
    <script type="text/javascript" src="js/jquery.min.js"></script>
    <script type="text/javascript" src="js/bootstrap.min.js"></script>
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

<!-- begin -->
<div id="login">
    <div class="wrapper">
        <h1 style="text-align:center; padding-top:50px;"><span class="label label-danger">暨创后台管理系统</span></h1>

        <div class="login">
            <form class="container loginform" id="loginForm">
                <div id="owl-login">
                    <div class="hand"></div>
                    <div class="hand hand-r"></div>
                    <div class="arms">
                        <div class="arm"></div>
                        <div class="arm arm-r"></div>
                    </div>
                </div>
                <div class="pad">
                    <div class="control-group">
                        <div class="controls">
                            <label for="account" class="control-label glyphicon glyphicon-user"></label>
                            <input type="text" name="account" id="account" placeholder="Account" tabindex="1"
                                   autofocus="autofocus" class="form-control">
                        </div>
                    </div>
                    <div class="control-group">
                        <div class="controls">
                            <label for="password" class="control-label glyphicon glyphicon-lock"></label>
                            <input type="password" name="password" id="password" placeholder="Password" tabindex="2"
                                   class="form-control">
                        </div>
                    </div>
                    <!--captcha-->
                    <div class="control-group">
                        <div class="controls">
                            <label for="captcha" class="control-label glyphicon glyphicon-check"></label>
                            <input type="text" name="captcha" id="captcha" placeholder="Captcha" tabindex="3"
                                   class="form-control"/>
                        </div>
                    </div>
                    <div style="text-align:center;">
                        <img style="width:90px; height:30px;" src="validate/validate.jsp" id="captchaImage">
                    </div>
                </div>
                <div class="form-actions">
                    <button type="button" tabindex="4" class="btn btn-primary" id="loginBtn">Login</button>
                    <span id="tip"> </span>
                </div>
            </form>
        </div>
    </div>
</div>
<!-- end -->

<script type="text/javascript">
    $(function () {
        // 猫头鹰
        $('#login #password').focus(function () {
            $('#owl-login').addClass('password');
        }).blur(function () {
            $('#owl-login').removeClass('password');
        });

        $("#loginBtn").click(function () {
                if ($("#loginForm").valid()) {
                    // 异步提交
                    $.ajax({
                        url: "login",
                        type: "POST",
                        data: {
                            "account": $("#account").val(),
                            "password": hex_md5($("#password").val())
                        },
                        beforeSend: function () {
                            $("#tip").html('<span style="color:blue">正在登录...</span>');
                        },
                        success: function (res) {
                            if (res) {
                                window.location.href = "user";
                            } else {
                                alert("密码错误");
                            }
                        },
                        error: function (XMLHttpRequest, textStatus, errorThrown) {
                            alert("服务器出错：" + XMLHttpRequest.status);
                        },
                        complete: function (XMLHttpRequest, textStatus) {
                            // 重置输入
                            $(':input', '#loginForm')
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
        var validator = $("#loginForm").validate(
            {
                rules: {
                    account: {
                        required: true,
                        rangelength: [6, 16]
                    },
                    password: {
                        required: true,
                        rangelength: [6, 16]
                    },
                    captcha: {
                        required: true,
                        rangelength: [4, 4],
                        remote: {
                            url: "validate",
                            type: "POST",
                            dataType: "json",
                            data: {
                                captcha: function () {
                                    return $("#captcha").val()
                                }
                            }
                        }
                    }
                },
                messages: {
                    account: {
                        required: "×",
                        rangelength: "×"
                    },
                    password: {
                        required: "×",
                        rangelength: "×"
                    },
                    captcha: {
                        required: "×",
                        rangelength: "×",
                        remote: "×"
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

        // 更换验证码
        $('#captchaImage').click(function () {
            $(this).attr("src", "validate/validate.jsp?" + Math.floor(Math.random() * 100));
        });
    });
</script>

</body>
</html>
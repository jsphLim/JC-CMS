<%@ page language="java" contentType="text/html;charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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
    <link rel="stylesheet" type="text/css" href="css/common.css"/>
    <link rel="stylesheet" type="text/css" href="css/slide.css"/>
    <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css"/>
    <link rel="stylesheet" type="text/css" href="css/flat-ui.min.css"/>
    <link rel="stylesheet" type="text/css" href="css/pagination.css"/>
    <script type="text/javascript" src="js/jquery.min.js"></script>
    <script type="text/javascript" src="js/bootstrap.min.js"></script>
    <script type="text/javascript" src="js/slide.js"></script>
    <script type="text/javascript" src="js/jquery.validate.min.js"></script>
    <script type="text/javascript" src="js/messages_zh.min.js"></script>
    <script type="text/javascript" src="js/pagination.js"></script>
</head>

<style type="text/css">
    .error {
        font-weight: bold;
        padding-left: 16px;
        color: #FFC0CB;
    }
</style>

<script type="text/javascript">
    // 记录修改的ID
    var updateId = -1;
    // 记录删除的ID
    var deleteId = -1;

    function updateClick(id) {
        updateId = id;
        // 请求文章
        $.ajax({
            url: "article/get",
            type: "POST",
            dataType: "json",
            data: {
                "id": id
            },
            success: function (res) {
                if (res) {
                    $("#title2").val(res.title);
                    $("#content2").val(res.content);
                    $("#url2").val(res.url);
                    $("#image2").val(res.image);
                }
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                alert("服务器出错：" + XMLHttpRequest.status);
                $("#updateModal").modal('hide');
            }
        });
    }

    function updateImageClick(id) {
        updateId = id;
    }

    function deleteClick(id) {
        deleteId = id;
    }

    $(function () {
        $("#pagination").pagination(${page.totalCount}, {
            callback: pageCallback,
            prev_text: '<<<',
            next_text: '>>>',
            ellipse_text: '...',
            current_page: ${page.pageIndex}, // 当前选中的页面
            items_per_page: ${page.pageSize}, // 每页显示的条目数
            num_display_entries: 4, // 连续分页主体部分显示的分页条目数
            num_edge_entries: 1 // 两侧显示的首尾分页的条目数
        });

        function pageCallback(index, jq) {
            // 防止首页循环回调
            if (index == ${page.pageIndex}) return;
            // TODO
            var url = "article?type=lb&page=" + index + "&asc=${page.asc}&keyword=${page.keyword}";
            window.location.href = url;
        }

        // 弹出框
        $("[data-toggle='tooltip']").tooltip();
    });
</script>

<body>

<div id="wrap">

    <!--左侧菜单栏-->
    <jsp:include page="nav.jsp"></jsp:include>

    <!--右侧内容栏-->
    <div id="rightContent">
        <!--文章管理模块-->
        <div role="tabpanel" class="tab-pane" id="zxzx">
            <!--顶部导航-->
            <div class="check-div form-inline">
                <div class="col-xs-3">
                    <button class="btn btn-yellow btn-xs" data-toggle="modal" data-target="#addModal">添加文章</button>
                </div>
                <div class="col-lg-4 col-xs-5">
                    <input type="text" class="form-control input-sm" placeholder="输入关键字搜索" id="keyword">
                    <button class="btn btn-default btn-xs" id="searchBtn">查 询</button>
                </div>
                <div class="col-lg-3 col-lg-offset-1 col-xs-3"
                     style="padding-right: 40px;text-align: right;float: right;">
                    <div class="btn-group">
                        <button class="btn btn-default btn-xs" data-toggle="dropdown">排序方式<span class="caret"></span>
                        </button>
                        <ul class="dropdown-menu" role="menu">
                            <li>
                                <!-- TODO -->
                                <a href="article?type=lb&page=0&asc=false&keyword=${page.keyword}">ID 降序</a></li>
                            <li>
                                <!-- TODO -->
                                <a href="article?type=lb&page=0&asc=true&keyword=${page.keyword}">ID 升序</a></li>
                        </ul>
                    </div>
                </div>
            </div>

            <!--文章列表-->
            <div class="data-div">
                <div class="row tableHeader">
                    <div class="col-xs-1">ID</div>
                    <div class="col-xs-4">标题</div>
                    <div class="col-xs-1">简介</div>
                    <div class="col-xs-3">链接</div>
                    <div class="col-xs-1">封面</div>
                    <div class="col-xs-2">操作</div>
                </div>
                <div class="tablebody">
                    <c:forEach var="entry" items="${page.list}" begin="0" end="${fn:length(page.list)}"
                               varStatus="status">
                        <div class="row">
                            <div class="col-xs-1">${entry.id}</div>
                            <div class="col-xs-4">
                                <a class="linkCcc" title="${entry.title}" data-container="body" data-toggle="tooltip"
                                   data-placement="top">
                                    <c:choose>
                                        <c:when test="${fn:length(entry.title) < 36}">${entry.title}</c:when>
                                        <c:otherwise>${fn:substring(entry.title, 0, 36)}...</c:otherwise>
                                    </c:choose>
                                </a></div>
                            <div class="col-xs-1">
                                <a class="linkCcc" title="${entry.content}" data-container="body" data-toggle="tooltip"
                                   data-placement="left">查看
                                </a>
                            </div>
                            <div class="col-xs-3">
                                <a class="linkCcc" href="${entry.url}">
                                    <c:choose>
                                        <c:when test="${fn:length(entry.url) < 36}">${entry.url}</c:when>
                                        <c:otherwise>${fn:substring(entry.url, 0, 36)}...</c:otherwise>
                                    </c:choose>
                                </a>
                            </div>
                            <div class="col-xs-1">
                                <a href="${entry.image}"><img width="50" height="50" src="${entry.image}"/></a>
                            </div>
                            <div class="col-xs-2">
                                <button class="btn btn-success btn-xs" data-toggle="modal" data-target="#updateModal"
                                        onclick="updateClick('${entry.id}')">
                                    修改资料
                                </button>
                                <button class="btn btn-success btn-xs" data-toggle="modal"
                                        data-target="#updateImageModal" onclick="updateImageClick('${entry.id}')">
                                    修改封面
                                </button>
                                <button class="btn btn-danger btn-xs" data-toggle="modal" data-target="#deleteModal"
                                        onclick="deleteClick('${entry.id}')">删 除
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!--底部分页-->
            <footer class="footer">
                <div id="pagination"></div>
            </footer>

            <!--添加文章窗口-->
            <div class="modal fade" id="addModal" role="dialog" aria-labelledby="addModalLabel">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                                    aria-hidden="true">&times;</span></button>
                            <h4 class="modal-title" id="addModalLabel">添加文章</h4>
                        </div>
                        <div class="modal-body">
                            <div class="container-fluid">
                                <form class="form-horizontal" id="addForm">
                                    <div class="form-group">
                                        <label for="title" class="col-xs-3 control-label">标题：</label>
                                        <div class="col-xs-9">
                                            <input type="text" name="title" id="title"
                                                   class="form-control input-sm duiqi">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="content" class="col-xs-3 control-label">简介：</label>
                                        <div class="col-xs-9">
                                            <textarea rows="5" name="content" id="content"
                                                      class="form-control input-sm duiqi" name="desc"></textarea>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="url" class="col-xs-3 control-label">链接：</label>
                                        <div class="col-xs-9">
                                            <input type="text" name="url" id="url" class="form-control input-sm duiqi">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="image" class="col-xs-3 control-label">封面：</label>
                                        <div class="col-xs-9">
                                            <!--upload-->
                                            <input type="file" name="image" id="image" accept="image/*">(jpg, png, bmp)
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-xs btn-default" data-dismiss="modal">取 消</button>
                            <button type="button" class="btn btn-xs btn-success" id="addBtn">保 存</button>
                            <span id="addTip"> </span>
                        </div>
                    </div>
                    <!-- /.modal-content -->
                </div>
                <!-- /.modal-dialog -->
            </div>
            <!-- /.modal -->

            <!--修改文章窗口-->
            <div class="modal fade" id="updateModal" role="dialog" aria-labelledby="updateModalLabel">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                                    aria-hidden="true">&times;</span></button>
                            <h4 class="modal-title" id="updateModalLabel">修改文章</h4>
                        </div>
                        <div class="modal-body">
                            <div class="container-fluid">
                                <form class="form-horizontal" id="updateForm">
                                    <div class="form-group">
                                        <label for="title2" class="col-xs-3 control-label">标题：</label>
                                        <div class="col-xs-9">
                                            <input name="title2" id="title2" type="text"
                                                   class="form-control input-sm duiqi">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="content2" class="col-xs-3 control-label">简介：</label>
                                        <div class="col-xs-9">
                                            <textarea rows="5" name="content2" id="content2"
                                                      class="form-control input-sm duiqi"
                                                      name="desc"></textarea>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="url2" class="col-xs-3 control-label">链接：</label>
                                        <div class="col-xs-9">
                                            <input name="url2" id="url2" type="text"
                                                   class="form-control input-sm duiqi">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="image2" class="col-xs-3 control-label">封面：</label>
                                        <div class="col-xs-9">
                                            <input name="image2" id="image2" type="text"
                                                   class="form-control input-sm duiqi" disabled>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-xs btn-default" data-dismiss="modal">取 消</button>
                            <button type="button" class="btn btn-xs btn-success" id="updateBtn">修 改</button>
                            <span id="updateTip"> </span>
                        </div>
                    </div>
                    <!-- /.modal-content -->
                </div>
                <!-- /.modal-dialog -->
            </div>
            <!-- /.modal -->

            <!--修改文章窗口-->
            <div class="modal fade" id="updateImageModal" role="dialog" aria-labelledby="updateImageModalLabel">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                                    aria-hidden="true">&times;</span></button>
                            <h4 class="modal-title" id="updateImageModalLabel">修改封面</h4>
                        </div>
                        <div class="modal-body">
                            <div class="container-fluid">
                                <form class="form-horizontal" id="updateImageForm">
                                    <div class="form-group">
                                        <label for="image3" class="col-xs-3 control-label">封面：</label>
                                        <div class="col-xs-9">
                                            <!--upload-->
                                            <input type="file" name="image3" id="image3" accept="image/*">(jpg, png,
                                            bmp)
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-xs btn-default" data-dismiss="modal">取 消</button>
                            <button type="button" class="btn btn-xs btn-success" id="updateImageBtn">修 改</button>
                            <span id="updateImageTip"> </span>
                        </div>
                    </div>
                    <!-- /.modal-content -->
                </div>
                <!-- /.modal-dialog -->
            </div>
            <!-- /.modal -->

            <!--删除文章窗口-->
            <div class="modal fade" id="deleteModal" role="dialog" aria-labelledby="deleteModalLabel">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                                    aria-hidden="true">&times;</span></button>
                            <h4 class="modal-title" id="deleteModalLabel">提示</h4>
                        </div>
                        <div class="modal-body">
                            <div class="container-fluid">
                                确定要删除该地区？删除后不可恢复！
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-xs btn-default" data-dismiss="modal">取 消</button>
                            <button type="button" class="btn btn-xs btn-danger" id="deleteBtn">删 除</button>
                            <span id="deleteTip"> </span>
                        </div>
                    </div>
                    <!-- /.modal-content -->
                </div>
                <!-- /.modal-dialog -->
            </div>
            <!-- /.modal -->
        </div>
    </div><!--文章管理模块-->
</div><!--右侧内容栏-->

</div>

<script type="text/javascript">
    $(function () {
        // TODO
        $("#lb-menu").addClass("meun-item-active");

        $("#searchBtn").click(function () {
            // TODO
            var url = "article?type=lb&page=0&asc=${page.asc}&keyword=" + $("#keyword").val();
            window.location.href = url;
        });

        $("#deleteBtn").click(function () {
            $.ajax({
                url: "article/delete",
                type: "POST",
                data: {
                    "id": deleteId
                },
                beforeSend: function () {
                    $("#deleteTip").html('<span style="color:blue">正在删除...</span>');
                },
                success: function (res) {
                    if (res) {
                        alert("删除成功");
                        window.location.reload();
                    } else {
                        alert("删除失败");
                        $("#deleteModal").modal('hide');
                        $("#deleteTip").html('<span id="deleteTip"> </span>');
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    alert("服务器出错：" + XMLHttpRequest.status);
                    $("#deleteModal").modal('hide');
                }
            });
        });

        ////////////////////////////////////////

        // 添加文章
        $("#addBtn").click(function () {
            if ($("#addForm").valid()) {
                var form = new FormData(document.getElementById("addForm"));
                // TODO
                form.append("type", "lb"); // 最新资讯
                // 异步提交
                $.ajax({
                    url: "article/add",
                    type: "POST",
                    data: form,
                    processData: false, // 必须设置为false
                    contentType: false, // 必须设置为false
                    beforeSend: function () {
                        $("#addTip").html('<span style="color:blue">正在添加...</span>');
                    },
                    success: function (res) {
                        if (res) {
                            alert("添加成功");
                            window.location.reload();
                        } else {
                            alert("添加失败");
                            $("#addModal").modal('hide');
                        }
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        alert("服务器出错：" + XMLHttpRequest.status);
                        $("#addModal").modal('hide');
                    }
                });
            }
        });

        // 验证表单
        var validator = $("#addForm").validate(
            {
                rules: {
                    title: {
                        required: true,
                        rangelength: [1, 100]
                    },
                    content: {
                        required: true,
                        rangelength: [1, 255]
                    },
                    url: {
                        required: true,
                        url: true
                    },
                    image: {
                        required: true
                    }
                },
                messages: {
                    title: {
                        required: "×",
                        rangelength: "字数范围[1-100]"
                    },
                    content: {
                        required: "×",
                        rangelength: "字数范围[1-255]"
                    },
                    url: {
                        required: "×",
                        url: "请输入正确的链接"
                    },
                    image: {
                        required: "×"
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

        // 模态框
        $('#addModal').on(
            'hide.bs.modal', function () {
                // 重置输入
                $(':input', '#addForm')
                    .not(':button, :submit, :reset, :hidden').val('')
                    .removeAttr('checked').removeAttr('selected');
                $("#addTip").html('<span id="addTip"> </span>');
                // 清空提示
                validator.resetForm();
            });

        ////////////////////////////////////////

        // 修改文章
        $("#updateBtn").click(function () {
            if ($("#updateForm").valid()) {
                $.ajax({
                    url: "article/update",
                    type: "POST",
                    data: {
                        "id": updateId,
                        "title": $("#title2").val(),
                        "content": $("#content2").val(),
                        "url": $("#url2").val(),
                        "type": "lb" // TODO
                    },
                    beforeSend: function () {
                        $("#updateTip").html('<span style="color:blue">正在修改...</span>');
                    },
                    success: function (res) {
                        if (res) {
                            alert("修改成功");
                            window.location.reload();
                        } else {
                            alert("修改失败");
                            $("#updateModal").modal('hide');
                        }
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        alert("服务器出错：" + XMLHttpRequest.status);
                        $("#updateModal").modal('hide');
                    }
                });
            }
        });

        // 验证表单2
        var validator2 = $("#updateForm").validate(
            {
                rules: {
                    title2: {
                        required: true,
                        rangelength: [1, 100]
                    },
                    content2: {
                        required: true,
                        rangelength: [1, 255]
                    },
                    url2: {
                        required: true,
                        url: true
                    }
                },
                messages: {
                    title2: {
                        required: "×",
                        rangelength: "字数范围[1-100]"
                    },
                    content2: {
                        required: "×",
                        rangelength: "字数范围[1-255]"
                    },
                    url2: {
                        required: "×",
                        url: "请输入正确的链接"
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

        // 模态框2
        $('#updateModal').on(
            'hide.bs.modal', function () {
                // 重置输入
                $(':input', '#updateForm')
                    .not(':button, :submit, :reset, :hidden').val('')
                    .removeAttr('checked').removeAttr('selected');
                $("#updateTip").html('<span id="updateTip"> </span>');
                // 清空提示
                validator2.resetForm();
            });

        ////////////////////////////////////////

        // 修改图片
        $("#updateImageBtn").click(function () {
            if ($("#updateImageForm").valid()) {
                var form = new FormData(document.getElementById("updateImageForm"));
                form.append("id", updateId);
                $.ajax({
                    url: "article/updateImage",
                    type: "POST",
                    data: form,
                    processData: false, // 必须设置为false
                    contentType: false, // 必须设置为false
                    beforeSend: function () {
                        $("#updateImageTip").html('<span style="color:blue">正在修改...</span>');
                    },
                    success: function (res) {
                        if (res) {
                            alert("修改成功");
                            window.location.reload();
                        } else {
                            alert("修改失败");
                            $("#updateImageModal").modal('hide');
                        }
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        alert("服务器出错：" + XMLHttpRequest.status);
                        $("#updateImageModal").modal('hide');
                    }
                });
            }
        });

        // 验证表单3
        var validator3 = $("#updateImageForm").validate(
            {
                rules: {
                    image3: {
                        required: true,
                    }
                },
                messages: {
                    image3: {
                        required: "×"
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

        // 模态框3
        $('#updateImageModal').on(
            'hide.bs.modal', function () {
                // 重置输入
                $(':input', '#updateImageForm')
                    .not(':button, :submit, :reset, :hidden').val('')
                    .removeAttr('checked').removeAttr('selected');
                $("#updateImageTip").html('<span id="updateImageTip"> </span>');
                // 清空提示
                validator3.resetForm();
            });
    })
</script>

</body>
</html>
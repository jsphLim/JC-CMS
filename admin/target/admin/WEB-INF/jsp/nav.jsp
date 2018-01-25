<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>

<!--左侧菜单栏-->
<div class="leftMeun" id="leftMeun">
    <div id="logoDiv">
        <p id="logoP"><img id="logo" alt="暨创 JICHUANG" src="images/logo.png"></p>
    </div>

    <div id="personInfor">
        <p id="userName">欢迎您 admin</p>
        <p><span>${user.account}&nbsp;&nbsp;&nbsp;<a href="logout">注销</a></span></p>
    </div>

    <div class="meun-title"><span class="glyphicon glyphicon-user"></span>&nbsp;&nbsp;&nbsp;账号管理</div>
    <!--<div class="meun-item meun-item-active">-->
    <div class="meun-item" id="user-menu">
        <a class="col-xs-offset-2" href="user">
            <span class="glyphicon glyphicon-pencil"></span>&nbsp;&nbsp;&nbsp;修改密码
        </a>
    </div>

    <div class="meun-title"><span class="glyphicon glyphicon-file"></span>&nbsp;&nbsp;&nbsp;文章管理</div>
    <div class="meun-item" id="lb-menu">
        <a class="meun-item col-xs-offset-2" href="article?type=lb">
            <span class="glyphicon glyphicon glyphicon-th-large"></span>&nbsp;&nbsp;&nbsp;轮播
        </a>
    </div>
    <div class="meun-item" id="st-menu">
        <a class="meun-item col-xs-offset-2" href="article?type=st">
            <span class="glyphicon glyphicon glyphicon-th"></span>&nbsp;&nbsp;&nbsp;三图
        </a>
    </div>
    <div class="meun-item" id="zxzx-menu">
        <a class="meun-item col-xs-offset-2" href="article?type=zxzx">
            <span class="glyphicon glyphicon-fire"></span>&nbsp;&nbsp;&nbsp;最新资讯
        </a>
    </div>
    <div class="meun-item" id="mtbd-menu">
        <a class="meun-item col-xs-offset-2" href="article?type=mtbd">
            <span class="glyphicon glyphicon-fire"></span>&nbsp;&nbsp;&nbsp;媒体报道
        </a>
    </div>
    <div class="meun-item" id="xmdt-menu">
        <a class="meun-item col-xs-offset-2" href="article?type=xmdt">
            <span class="glyphicon glyphicon-fire"></span>&nbsp;&nbsp;&nbsp;项目动态
        </a>
    </div>

    <footer style="position: absolute;bottom: 0;">
        <p>&copy; JICHUANG 2018</p>
    </footer>
</div>

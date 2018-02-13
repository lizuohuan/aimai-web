<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/top.css">

<div class="navigation-top">
    <div class="container">
        <div class="col-xs-2">
            <a href="<%=request.getContextPath()%>/page/index">
                <img id="companyLogo" class="navigation-logo" src="">
            </a>
        </div>
        <div class="col-xs-3">
            <ul class="layui-nav">
                <li class="layui-nav-item" url="page/index"><a href="<%=request.getContextPath()%>/page/index">首页</a></li>
                <li class="layui-nav-item" url="page/course/courseIndex"><a href="<%=request.getContextPath()%>/page/course/courseIndex?notTrade=1">培训</a></li>
                <li class="layui-nav-item" url="page/about/aboutUs"><a href="<%=request.getContextPath()%>/page/about/aboutUs">关于我们</a></li>
            </ul>
        </div>
        <div class="col-xs-4">
            <div class="search-bar">
                <input id="searchParams" class="search-input" type="text" placeholder="搜索课程">
                <button type="button" class="search-btn" onclick="searchParams()">搜索</button>
            </div>
        </div>
        <div class="col-xs-3 logo-login-bar" ng-cloak>
            <div class="logo-neea"></div>
            <a ng-show="userInfo == null" href="<%=request.getContextPath()%>/page/login" class="blue-border-button login-btn">登录</a>
            <a ng-show="userInfo == null" href="<%=request.getContextPath()%>/page/registerPhone" class="blue-border-button reg-btn">注册</a>

            <div class="topbar-info" ng-show="userInfo != null">
                <a class="top-user-name" ng-show="userInfo.roleId == 2" href="<%=request.getContextPath()%>/page/person/dataCount">
                    <span ng-bind="userInfo.showName"></span>
                    <i class="fa fa-chevron-down"></i>
                </a>
                <a class="top-user-name" ng-show="userInfo.roleId == 3 || userInfo.roleId == 5" href="<%=request.getContextPath()%>/page/person/myCourseCompany">
                    <span ng-bind="userInfo.showName"></span>
                    <i class="fa fa-chevron-down"></i>
                </a>
                <a class="top-user-name" ng-show="userInfo.roleId == 4" href="<%=request.getContextPath()%>/page/person/myCourse">
                    <span ng-bind="userInfo.showName"></span>
                    <i class="fa fa-chevron-down"></i>
                </a>
                <ul class="user-menu">
                    <li>
                        <a ng-show="userInfo.roleId == 2" href="<%=request.getContextPath()%>/page/person/dataCount">个人中心</a>
                        <a ng-show="userInfo.roleId == 3 || userInfo.roleId == 5" href="<%=request.getContextPath()%>/page/person/myCourseCompany">个人中心</a>
                        <a ng-show="userInfo.roleId == 4" href="<%=request.getContextPath()%>/page/person/myCourse">个人中心</a>
                    </li>
                    <li><a href="javascript: loginOut()">退出登录</a></li>
                </ul>
            </div>
        </div>
    </div>
</div>

<script>
    function loginOut() {
        config.ajaxRequestData(false, "user/logout", null, function () {
            sessionStorage.removeItem("aiMaiUser");
            window.location.href = config.ip + "page/index";
        });
    }

    function searchParams () {
        sessionStorage.setItem("searchParams", $(".search-input").val());
        location.href = config.ip + "page/course/courseIndex?notTrade=1";
    }
</script>
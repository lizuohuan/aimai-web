<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>统计数据</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/person/dataCountCompany.css">

</head>
<body ng-app="aiMaiApp" ng-controller="controller" ng-cloak>
    <%@include file="../common/top.jsp" %>
    <div class="ai-content">
        <div class="row">
            <div class="col-xs-12">
                <div class="container">
                    <div class="row">
                        <div class="col-xs-12">
                            <!-- left -->
                            <%@include file="menu.jsp" %>
                            <!-- right -->
                            <div class="float-left content-right">
                                <div class="sub-page-search-bar">
                                    <div class="title-hint">
                                        数据统计
                                    </div>
                                    <div class="schedule">
                                        <a href="javascript: window.history.back()">数据统计</a>
                                        <span>&gt;</span>
                                        <a class="schedule-active">查看信息</a>
                                    </div>
                                </div>

                                <div class="company-list">
                                    <form class="layui-form">
                                        <div class="layui-form-item">
                                            <label class="layui-form-label">姓名</label>
                                            <div class="layui-input-inline">
                                                <div class="layui-input">{{userDetail.showName}}</div>
                                            </div>
                                        </div>
                                        <div class="layui-form-item">
                                            <label class="layui-form-label">身份证</label>
                                            <div class="layui-input-inline">
                                                <div class="layui-input">{{userDetail.pid}}</div>
                                            </div>
                                        </div>
                                        <div class="layui-form-item">
                                            <label class="layui-form-label">行业</label>
                                            <div class="layui-input-inline">
                                                <div class="layui-input">{{userDetail.tradeName}}</div>
                                            </div>
                                        </div>
                                        <div class="layui-form-item">
                                            <label class="layui-form-label">联系方式</label>
                                            <div class="layui-input-inline">
                                                <div class="layui-input">{{userDetail.phone}}</div>
                                            </div>
                                        </div>
                                        <div class="layui-form-item">
                                            <label class="layui-form-label">地区</label>
                                            <div class="layui-input-inline">
                                                <div class="layui-input">{{userDetail.city.mergerName}}</div>
                                            </div>
                                        </div>
                                        <div class="layui-form-item">
                                            <label class="layui-form-label">公司名</label>
                                            <div class="layui-input-inline">
                                                <div class="layui-input">{{userDetail.companyName}}</div>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%@include file="../common/bottom.jsp" %>
    <%@include file="../common/js.jsp" %>

    <script>
        $("body").append(config.showShade("正在加载,请稍等..."));

        var webApp = angular.module('aiMaiApp', []);
        webApp.controller("controller", function($scope, $timeout) {
            $scope.userInfo = config.aiMaiUser();
            $scope.ipImg = config.ipImg;

            config.ajaxRequestData(false, "record/info", {id : config.getUrlParam("userId")}, function (result) {
                $scope.userDetail = result.data;
            });

            config.hideShade();

        });

    </script>
</body>
</html>

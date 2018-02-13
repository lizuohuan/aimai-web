<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>支付结果</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/course/paymentResult.css">
</head>
<body ng-app="aiMaiApp" ng-controller="controller" ng-cloak>
<%@include file="../common/top.jsp" %>
<div class="ai-content">

    <div class="result-bar" ng-show="isSucceed == 1">
        <i class="result-icon-succeed"></i>
        <div class="result-title">支付成功</div>
        <div class="result-hint">您可以在我的课程里面观看课程</div>
        <div class="result-btn-bar">
            <a href="<%=request.getContextPath()%>/page/index" class="min-blue-button">返回首页</a>
            <a href="<%=request.getContextPath()%>/page/person/myCourse" class="min-gray-button">去我的课程</a>
        </div>
    </div>

    <div class="result-bar" ng-show="isSucceed != 1">
        <i class="result-icon-error"></i>
        <div class="result-title">支付失败</div>
        <div class="result-hint">订单已提交,您可以在我的订单里面重新支付</div>
        <div class="result-btn-bar">
            <a href="<%=request.getContextPath()%>/page/index" class="min-blue-button">返回首页</a>
            <a href="<%=request.getContextPath()%>/page/person/myOrder" class="min-gray-button">重新支付</a>
        </div>
    </div>
</div>

<%@include file="../common/bottom.jsp" %>
<%@include file="../common/js.jsp" %>

<script>
    $("body").append(config.showShade("正在加载,请稍等..."));

    var webApp = angular.module('aiMaiApp', []);
    webApp.controller("controller", function($scope) {
        $scope.userInfo = config.aiMaiUser();
        $scope.ipImg = config.ipImg;
        $scope.isSucceed = sessionStorage.getItem("isSucceed") == null ? config.getUrlParam("isSucceed") : sessionStorage.getItem("isSucceed");

        config.hideShade();

    });
</script>
</body>
</html>

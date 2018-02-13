<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>平台</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/about.css"/>
</head>
<body ng-app="aiMaiApp" ng-controller="controller" ng-cloak>
<%@include file="../common/top.jsp" %>
<div class="ai-content">

    <div class="container aboutUs clearfix">
        <div class="menu">
            <ul class="shadow">
                <li><a href="<%=request.getContextPath()%>/page/about/aboutUs">关于我们</a></li>
                <li><a href="<%=request.getContextPath()%>/page/about/honor">资质</a></li>
                <li><a href="javascript:void(0)" class="act">平台</a></li>
                <li><a href="<%=request.getContextPath()%>/page/about/polling">安巡</a></li>
                <li><a href="<%=request.getContextPath()%>/page/about/suggest">意见反馈</a></li>
            </ul>
        </div>
        <div class="content">
            <div class="shadow honor">
                <h2 class="aboutTitle">平台<small class="upper">/terrace</small></h2>
                <div style="margin:45px 0;line-height: 1.5em;">
                    <div ng-bind-html="content | trustHtml"></div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@include file="../common/bottom.jsp" %>
<%@include file="../common/js.jsp" %>
<script>

    var webApp = angular.module('aiMaiApp', []);
    webApp.controller("controller", function($scope) {
        $scope.userInfo = config.aiMaiUser();
        $scope.ipImg = config.ipImg;
        $scope.content = null;
        config.ajaxRequestData(false, "content/info", {id : 3}, function (result) {
            $scope.content = result.data.content;
        });
    });
    //富文本过滤器
    webApp.filter('trustHtml', ['$sce',function($sce) {
        return function(val) {
            return $sce.trustAsHtml(val);
        };
    }]);

</script>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>关于我们</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/about.css"/>
</head>
<body ng-app="aiMaiApp" ng-controller="controller" ng-cloak>
<%@include file="../common/top.jsp" %>
<div class="ai-content">

    <div class="container aboutUs clearfix">
        <div class="menu">
            <ul class="shadow">
                <li><a href="javascript:void(0)" class="act">关于我们</a></li>
                <li><a href="<%=request.getContextPath()%>/page/about/honor">资质</a></li>
                <li><a href="<%=request.getContextPath()%>/page/about/terrace">平台</a></li>
                <li><a href="<%=request.getContextPath()%>/page/about/polling">安巡</a></li>
                <li><a href="<%=request.getContextPath()%>/page/about/suggest">意见反馈</a></li>
            </ul>
        </div>
        <div class="content">
            <div class="shadow">
                <h2 class="aboutTitle">企业简介<small class="upper">/company profile</small></h2>
                <p style="margin:25px 0;"><img src="<%=request.getContextPath()%>/resources/img/since.jpg" alt="since2016" /></p>
                <h3 style="font-size: 24px;color:#666;">
                    {{company.name}}
                    <%--<p class="upper" style="font-size: 14px;margin-top:10px;">sichuan security tech co.,ltd.</p>--%>
                </h3>
                <div style="margin:45px 0;line-height: 1.5em;">
                    <div ng-bind-html="content.content | trustHtml"></div>
                </div>
            </div>
            <div class="shadow">
                <h2 class="aboutTitle" style="margin-bottom: 30px;">联系方式</h2>
                <ul class="contactUl">
                    <li><span><img src="<%=request.getContextPath()%>/resources/img/tel.png" alt="tel" /></span>服务热线：{{company.mobile}}</li>
                    <li><span><img src="<%=request.getContextPath()%>/resources/img/mail.png" alt="email" /></span>公司邮箱：{{company.email}}</li>
                    <li><span><img src="<%=request.getContextPath()%>/resources/img/fax.png" alt="fax" /></span>公司传真：{{company.fax}}</li>
                    <li><span><img src="<%=request.getContextPath()%>/resources/img/link.png" alt="link" /></span>公司网址：{{company.url}}</li>
                    <li><span><img src="<%=request.getContextPath()%>/resources/img/addr.png" alt="address" /></span>公司地址：{{company.address}}</li>
                </ul>
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
        $scope.company = null;

        config.ajaxRequestData(false, "content/info", {id : 1}, function (result) {
            $scope.content = result.data;
        });

        config.ajaxRequestData(false, "company/info", {}, function (result) {
            $scope.company = result.data;
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

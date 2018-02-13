<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>意见反馈</title>
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
                <li><a href="<%=request.getContextPath()%>/page/about/terrace">平台</a></li>
                <li><a href="<%=request.getContextPath()%>/page/about/polling">安巡</a></li>
                <li><a href="javascript:void(0)" class="act">意见反馈</a></li>
            </ul>
        </div>
        <div class="content">
            <div class="shadow">
                <h3 style="font-size: 24px;">有了您的建议，我们将做得更好！</h3>
                <div class="clearfix suggest">
                    <div class="skey">内容</div>
                    <div class="rightBox">
                        <div>
                            <textarea ng-model="content" placeholder="请输入您的宝贵意见" ng-trim></textarea>
                        </div>
                        <button class="blue-button" ng-click="submitData()">提交</button>
                    </div>
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
        $scope.submitData = function () {
            if($scope.content == null || $scope.content == ""){
                layer.msg("不能为空.");
                return false;
            }
            if (config.aiMaiUser() == null) {
                var index = layer.confirm('未登录，是否跳转登录页面？', {
                    btn: ['确定','取消']
                    ,closeBtn: 0
                    ,anim: 1
                    ,title: "温馨提示"
                }, function(){
                    location.href = config.ip + "page/login";
                    sessionStorage.setItem("url", window.location.href);
                    layer.close(index);
                }, function(){

                });
            }
            else {
                config.ajaxRequestData(false, "suggest/submitSuggest", {content : $scope.content}, function () {
                    $scope.content = "";
                    layer.msg("感谢您的意见.");
                });
            }
        }
    });

</script>
</body>
</html>

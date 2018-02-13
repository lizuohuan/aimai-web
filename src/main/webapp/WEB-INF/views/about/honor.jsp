<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>资质</title>
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
                <li><a href="javascript:void(0)" class="act">资质</a></li>
                <li><a href="<%=request.getContextPath()%>/page/about/terrace">平台</a></li>
                <li><a href="<%=request.getContextPath()%>/page/about/polling">安巡</a></li>
                <li><a href="<%=request.getContextPath()%>/page/about/suggest">意见反馈</a></li>
            </ul>
        </div>
        <div class="content">
            <div class="shadow honor">
                <h2 class="aboutTitle">荣誉资质<small class="upper">/honor</small></h2>
                <ul class="clearfix" id="photoImg">
                    <li ng-repeat="con in content">
                        <img src="{{ipImg}}{{con.imgUrl}}" layer-src="{{ipImg}}{{con.imgUrl}}" alt="{{con.imgName}}" style="cursor: pointer;"/>
                        <p>{{con.imgName}}</p>
                    </li>
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
        config.ajaxRequestData(false, "content/info", {id : 2}, function (result) {
            $scope.content = JSON.parse(result.data.content);
        });
    });

    $(function () {
        $('#photoImg img').on("click",function(){
            layer.photos({
                photos: '#photoImg',
                shadeClose: true,
                closeBtn: 2,
                anim: 5 //0-6的选择，指定弹出图片动画类型，默认随机
            });
        })
    })

</script>
</body>
</html>

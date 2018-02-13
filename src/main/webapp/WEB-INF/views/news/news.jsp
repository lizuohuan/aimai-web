<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>新闻列表</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/news/news.css"/>
</head>
<body ng-app="aiMaiApp" ng-controller="controller" ng-cloak>
<%@include file="../common/top.jsp" %>
<div class="ai-content">
    <!--新闻 news-->
    <div class="news">
        <div class="container">
            <div class="position">
                <span><a href="<%=request.getContextPath()%>/page/index">首页</a></span><span>></span><span><a href="#">新闻列表</a></span>
            </div>
            <ul class="newsMain clearfix">
                <li ng-repeat="news in newsList">
                    <a href="javascript:void(0)" ng-click="newsDetail(news)" class="block">
                        <div class="news-cover" style="background: url('{{ipImg}}{{news.image}}')"></div>
                    </a>
                    <div>
                        <h4>{{news.title}}</h4>
                        <p><a>{{news.digest}}</a></p>
                        <span>{{news.createTime | date : 'yyyy-MM-dd HH:mm:ss'}}</span>
                    </div>
                </li>
            </ul>
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
        $scope.newsList = null;
        $scope.isFirst = false;
        $scope.getDataList = function (pageNO, pageSize) {
            $scope.parameter = {
                pageNO : pageNO,
                pageSize : pageSize
            }
            config.ajaxRequestData(false, "news/queryNewsList", $scope.parameter, function (result) {
                if (!$scope.isFirst) {
                    $scope.newsList = result.data.dataList;
                    $scope.isFirst = true;
                }
                else {
                    $timeout(function () {
                        $scope.newsList = result.data.dataList;
                    });
                }
            });
        }
        //默认调用
        $scope.getDataList(1, 10);

        $scope.newsDetail = function (news) {
            if (news.isLink == 0) {
                window.open(config.ip + "page/news/newsDetail?newsId=" + news.id);
            }
            else {
                window.open(news.linkUrl);
            }
        }

        config.hideShade();

    });

</script>
</body>
</html>

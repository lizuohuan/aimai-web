<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>我的消息</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/person/myNews.css">
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
                                    我的消息
                                    <span>(共{{totalPage}}条)</span>
                                </div>
                            </div>
                            <div class="newsList">
                                <div class="news-item" ng-repeat="news in newsList">
                                    <a ng-show="news.isLink == 1" href="{{news.linkUrl}}" target="_blank">
                                        <div class="news-title">
                                            {{news.title}}
                                            <span class="news-time">{{news.createTime | date : 'yyyy-MM-dd HH:mm:ss'}}</span>
                                        </div>
                                        <div class="news-context">
                                            {{news.digest}}
                                        </div>
                                    </a>
                                    <div ng-show="news.isLink == 0 || news.isLink == null">
                                        <div class="news-title">
                                            {{news.title}}
                                            <span class="news-time">{{news.createTime | date : 'yyyy-MM-dd HH:mm:ss'}}</span>
                                        </div>
                                        <div class="news-context">
                                            {{news.digest}}
                                        </div>
                                    </div>
                                </div>

                                <div class="pagination-bar row">
                                    <div class="col-xs-12">
                                        <div id="pagination"></div>
                                    </div>
                                </div>
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
        $scope.isFirst = false; //是否加载过第一次了
        $scope.newsList = null;
        $scope.totalPage = 0;


        layui.use(['laypage', 'layer'], function() {
            var laypage = layui.laypage,form = layui.form();

            $scope.changePage = function (totalPage) {
                config.log("总条数：" + totalPage);
                config.log("总页数：" + Math.ceil(totalPage / 10));
                laypage({
                    cont: 'pagination'
                    ,pages: Math.ceil(totalPage / 30)
                    ,first: "首页"
                    ,last: "末页"
                    ,prev: '<em><</em>'
                    ,next: '<em>></em>',
                    jump: function(obj, first){
                        if(!first){
                            $scope.getDataList(obj.curr, 30);
                        }
                    }
                });
                form.render();
            }

            $scope.getDataList = function (pageNO, pageSize) {
                $scope.parameter = {
                    pageNO : pageNO,
                    pageSize : pageSize
                }
                config.ajaxRequestData(false, "systemInfo/geySystemInfo", $scope.parameter, function (result) {
                    if (!$scope.isFirst) {
                        $scope.newsList = result.data.dataList;
                        $scope.totalPage = result.data.count;
                        $scope.changePage(result.data.count);
                    }
                    else {
                        $timeout(function () {
                            $scope.newsList = result.data.dataList;
                        });
                    }
                });
            }
            //默认调用
            $scope.getDataList(1, 30);

        });

        config.hideShade();

    });

</script>
</body>
</html>

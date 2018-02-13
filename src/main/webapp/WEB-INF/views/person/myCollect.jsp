<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>我的收藏</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/person/myCollect.css">
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
                            <div class="layui-tab layui-tab-brief">
                                <ul class="layui-tab-title">
                                    <li class="layui-this">课程</li>
                                    <li>考题</li>
                                    <li>资讯</li>
                                </ul>
                                <div class="layui-tab-content">
                                    <!-- 课程 -->
                                    <div class="layui-tab-item layui-show">
                                        <div class="row course-list">
                                            <div class="not-data" ng-show="collectList == null || collectList.length == 0">暂无课程</div>
                                            <div class="col-xs-3 course-item" ng-repeat="collect in collectList">
                                                <div ng-click="courseDetail(collect.id)" class="course-cover" style="background: url('{{ipImg}}{{collect.cover}}')"></div>
                                                <div class="course-title">
                                                    {{collect.curriculumName}}
                                                </div>
                                                <div class="course-label">
                                                    <span class="">{{collect.year | date : 'yyyy'}}年</span>
                                                    <span class="">|</span>
                                                    <span class="">{{collect.stageName}}</span>
                                                </div>
                                                <div class="course-btn">
                                                    <i class="icon-video"></i>
                                                    <span class="video-num">{{collect.videoNum}}</span>
                                                    <span class="course-font">个视频课</span>
                                                    <button class="info-btn" ng-click="cancelCollect(collect.id, 1, $event)">取消收藏</button>
                                                </div>
                                            </div>

                                        </div>
                                    </div>

                                    <!-- 考题 -->
                                    <div class="layui-tab-item">
                                        <div class="not-data" ng-show="collectList == null || collectList.length == 0">暂无考题</div>
                                        <div class="row" ng-repeat="examination in collectList">
                                            <div class="col-xs-10">
                                                <span class="topic-title">{{$index + 1}}、{{examination.title}}（）</span>
                                                <p class="topic-answer" ng-repeat="item in examination.examinationItemsList">
                                                    <span ng-show="$index == 0">A</span>
                                                    <span ng-show="$index == 1">B</span>
                                                    <span ng-show="$index == 2">C</span>
                                                    <span ng-show="$index == 3">D</span>
                                                    <span ng-show="$index == 4">E</span>
                                                    <span ng-show="$index == 5">F</span>
                                                    <span ng-show="$index == 6">G</span>
                                                    <span ng-show="$index == 7">H</span>
                                                    <span ng-show="$index == 8">I</span>
                                                    <span ng-show="$index == 9">J</span>
                                                    <span ng-show="$index == 10">K</span>
                                                    、{{item.itemTitle}}
                                                </p>
                                                <div class="answer-bar">
                                                    <p class="analysis">
                                                        <span class="blue-badge">答案</span>
                                                        <span class="answer" ng-repeat="item in examination.examinationItemsList" ng-show="item.isCorrect == 1">
                                                            <span ng-show="$index == 0">A</span>
                                                            <span ng-show="$index == 1">B</span>
                                                            <span ng-show="$index == 2">C</span>
                                                            <span ng-show="$index == 3">D</span>
                                                            <span ng-show="$index == 4">E</span>
                                                            <span ng-show="$index == 5">F</span>
                                                            <span ng-show="$index == 6">G</span>
                                                            <span ng-show="$index == 7">H</span>
                                                            <span ng-show="$index == 8">I</span>
                                                            <span ng-show="$index == 9">J</span>
                                                            <span ng-show="$index == 10">K</span>
                                                        </span>
                                                    </p>
                                                    <p class="analysis">
                                                        <span class="gray-badge">考点</span>
                                                        <span class="analysis-context">{{examination.emphasis}}</span>
                                                    </p>
                                                    <p class="analysis">
                                                        <span class="gray-badge">解析</span>
                                                        <span class="analysis-context">{{examination.examinationKey}}</span>
                                                    </p>
                                                </div>
                                            </div>
                                            <div class="col-xs-2 cancel-collect">
                                                <button class="info-btn" ng-click="cancelCollect(examination.id, 2, $event)">取消收藏</button>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- 资讯 -->
                                    <div class="layui-tab-item">
                                        <div class="row course-list">
                                            <div class="not-data" ng-show="collectList == null || collectList.length == 0">暂无资讯</div>
                                            <div class="col-xs-3 course-item" ng-repeat="collect in collectList">
                                                <div ng-click="newsDetail(collect.id)" class="course-cover news-cover" style="background: url('{{ipImg}}{{collect.image}}')"></div>
                                                <div class="course-title">
                                                    {{collect.title}}
                                                </div>
                                                <div>
                                                    <button class="info-btn" ng-click="cancelCollect(collect.id, 0, $event)">取消收藏</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>


                            <div class="pagination-bar">
                                <div id="pagination"></div>
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
        $scope.type = null;
        $scope.collectList = null;
        $scope.isFirst = false;

        layui.use(['laypage', 'layer'], function() {
            var laypage = layui.laypage,form = layui.form();
            $scope.changePage = function (totalPage) {
                config.log("总条数：" + totalPage);
                config.log("总页数：" + Math.ceil(totalPage / 10));
                laypage({
                    cont: 'pagination'
                    ,pages: Math.ceil(totalPage / 10)
                    ,first: false
                    ,last: false
                    ,prev: '<em><</em>'
                    ,next: '<em>></em>',
                    jump: function(obj, first){
                        //config.log(obj);
                        if(!first){
                            $scope.getDataList(obj.curr, 10, $scope.type);
                        }
                    }
                });
                form.render();
            }
        });

        $scope.getDataList = function (pageNO, pageSize, type) {
            $scope.parameter = {
                pageNO : pageNO,
                pageSize : pageSize,
                type : type
            }
            config.ajaxRequestData(false, "collect/queryCollect", $scope.parameter, function (result) {
                if (!$scope.isFirst) {
                    $scope.collectList = result.data.dataList;
                    $scope.isFirst = true;
                    $scope.changePage(result.data.count);
                }
                else {
                    $timeout(function () {
                        $scope.collectList = result.data.dataList;
                    });
                }
            });
        }
        //默认调用
        $scope.getDataList(1, 10, 1);

        $(".layui-tab-title li").click(function () {
            if ($(this).index() == 0) $scope.type = 1;
            if ($(this).index() == 1) $scope.type = 2;
            if ($(this).index() == 2) $scope.type = 0;
            $scope.getDataList(1, 10, $scope.type);
        });

        //取消收藏
        $scope.cancelCollect = function (collectId, type, event) {
            var $obj = event.target;
            $scope.parameter = {
                targetId : collectId,
                type : type
            }
            config.ajaxRequestData(false, "collect/delete ", $scope.parameter, function (result) {
                $($obj).parent().parent().hide("slow");
                layer.msg("取消成功.");
            });
        }

        //新闻详情
        $scope.newsDetail = function (newsId) {
            sessionStorage.setItem("newsId", newsId);
            window.open(config.ip + "page/news/newsDetail");
        }

        //课程购买详情
        $scope.courseDetail = function (curriculumId) {
            sessionStorage.setItem("curriculumId", curriculumId);
            window.open(config.ip + "page/course/courseDetail");
        }

        config.hideShade();

    });

</script>
</body>
</html>

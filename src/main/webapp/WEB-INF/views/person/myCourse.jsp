<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>我的课程</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/person/myCourse.css">
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
                                    <li class="layui-this">已购课程</li>
                                    <li>未购课程</li>
                                </ul>
                            </div>

                            <%--<div class="sub-page-search-bar">
                                <div class="title-hint">
                                    购买的课程
                                </div>
                            </div>--%>

                            <div class="courseList">
                                <div class="not-data" ng-show="courseList== null || courseList.length == 0">暂无数据</div>
                                <div class="course-item" ng-repeat="course in courseList" ng-click="courseDetail(course.id, course.orderId, course.studyStatus)">
                                    <div class="course-cover" style="background: url('{{ipImg}}{{course.cover}}')"></div>
                                    <div class="course-info">
                                        <div class="course-title">
                                            {{course.curriculumName}}
                                        </div>
                                        <div class="course-label">
                                            <span class="year-label">{{course.year | date : 'yyyy'}}年</span>
                                            <span class="erect"></span>
                                            <span class="type-label">{{course.stageName}}</span>
                                        </div>
                                        <div class="course-number">
                                            <span class="num">{{course.examinationNum}}习题</span>
                                            <span class="num">{{course.videoNum}}个视频课</span>
                                            <span class="num">{{course.pptNum}}个讲义</span>
                                        </div>
                                        <div class="study-progress" ng-if="isPayment == 0">
                                            <span ng-style="course.progressWidth"></span>
                                        </div>
                                        <div class="time-bar" ng-if="isPayment == 0">
                                            <div class="time-div">
                                                <i class="icon-study"></i>
                                                <span class="icon-font">已学习<span>{{course.finishSecondsTime}}</span></span>
                                            </div>
                                            <div class="time-div">
                                                <i class="icon-add"></i>
                                                <span class="icon-font">共<span>{{course.videoSecondsTime}}</span></span>
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
        $scope.courseList = null; //课程类别
        $scope.isPayment = 0; //是否查询购买课程

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
        });

        $scope.getDataList = function (pageNO, pageSize) {
            $scope.parameter = {
                pageNO : pageNO,
                pageSize : pageSize
            }
            if ($scope.isPayment == 0) {
                config.ajaxRequestData(false, "curriculum/queryCurriculumStudy", $scope.parameter, function (result) {
                    if (!$scope.isFirst) {
                        $timeout(function () {
                            $scope.courseList = result.data.dataList == null ? [] : result.data.dataList;
                            for (var i = 0; i < $scope.courseList.length; i++) {
                                var course = $scope.courseList[i];
                                course.finishSeconds = course.finishSeconds == null ? 0 : course.finishSeconds;
                                course.videoSeconds = course.videoSeconds == null ? 0 : course.videoSeconds;
                                course.finishSecondsTime = config.getFormat(course.finishSeconds);
                                course.videoSecondsTime = config.getFormat(course.videoSeconds);
                                course.progressWidth = {
                                    "width" : course.finishSeconds / course.videoSeconds * 100 + '%',
                                };
                            }
                        });
                        $scope.isFirst = true;
                        $scope.changePage(result.data.count);
                    }
                    else {
                        $timeout(function () {
                            $scope.courseList = result.data.dataList == null ? [] : result.data.dataList;
                            for (var i = 0; i < $scope.courseList.length; i++) {
                                var course = $scope.courseList[i];
                                course.finishSeconds = course.finishSeconds == null ? 0 : course.finishSeconds;
                                course.videoSeconds = course.videoSeconds == null ? 0 : course.videoSeconds;
                                course.finishSecondsTime = config.getFormat(course.finishSeconds);
                                course.videoSecondsTime = config.getFormat(course.videoSeconds);
                            }
                        });
                    }
                });
            }
            else {
                config.ajaxRequestData(false, "curriculum/queryCurriculumStudy", $scope.parameter, function (result) {
                    if (!$scope.isFirst) {
                        $timeout(function () {
                            $scope.courseList = result.data.dataList == null ? [] : result.data.dataList;
                            for (var i = 0; i < $scope.courseList.length; i++) {
                                var course = $scope.courseList[i];
                                course.finishSeconds = course.finishSeconds == null ? 0 : course.finishSeconds;
                                course.videoSeconds = course.videoSeconds == null ? 0 : course.videoSeconds;
                                course.finishSecondsTime = config.getFormat(course.finishSeconds);
                                course.videoSecondsTime = config.getFormat(course.videoSeconds);
                                course.progressWidth = {
                                    "width" : course.finishSeconds / course.videoSeconds * 100 + '%',
                                };
                            }
                        });
                        $scope.isFirst = true;
                        $scope.changePage(result.data.count);
                    }
                    else {
                        $timeout(function () {
                            $scope.courseList = result.data.dataList == null ? [] : result.data.dataList;
                            for (var i = 0; i < $scope.courseList.length; i++) {
                                var course = $scope.courseList[i];
                                course.finishSeconds = course.finishSeconds == null ? 0 : course.finishSeconds;
                                course.videoSeconds = course.videoSeconds == null ? 0 : course.videoSeconds;
                                course.finishSecondsTime = config.getFormat(course.finishSeconds);
                                course.videoSecondsTime = config.getFormat(course.videoSeconds);
                            }
                        });
                    }
                });
            }

        }

        //默认调用
        $scope.getDataList(1, 30);

        //筛选条件
        $(".layui-tab-title li").click(function () {
            if ($(this).index() == 0) $scope.isPayment = 0;
            if ($(this).index() == 1) $scope.isPayment = 1;
            $scope.isFirst = false;
            $scope.getDataList(1, 30);
        });

        //播放
        $scope.courseDetail = function (curriculumId, orderId, studyStatus) {
            if (studyStatus == 0 || studyStatus == 2) {
                layer.msg("当前课程已被终止");
                return false;
            }
            sessionStorage.setItem("curriculumId", curriculumId);
            sessionStorage.setItem("orderId", orderId);
            sessionStorage.setItem("isAudition", 0); //不是免费
            if ($scope.userInfo.roleId == 4) {
                location.href = config.ip + "page/course/courseWatch";
            }
            else {
                location.href = config.ip + "page/course/courseDetail";
            }
        }

        config.hideShade();

    });

</script>
</body>
</html>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>我的考题</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/person/myExam.css">
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
                                    <li ng-class="{true:'layui-this', false: ''}[examType == 0 || examType == null]">练习题</li>
                                    <li>错题库</li>
                                    <li ng-class="{true:'layui-this', false: ''}[examType == 1]">模拟题</li>
                                    <li>正式考试</li>
                                </ul>
                                <div class="layui-tab-content">
                                    <!-- 练习题 -->
                                    <div ng-class="{true:'layui-tab-item layui-show', false: 'layui-tab-item'}[examType == 0 || examType == null]">
                                        <div class="count-num-bar">
                                            <div class="row">
                                                <div class="col-xs-6" style="text-align: left">
                                                    已练习<span ng-bind="statisticsExamination.countNum"></span>题
                                                </div>
                                                <div class="col-xs-6" style="text-align: right">
                                                    正确率<span ng-bind="statisticsExamination.correctPercent * 100 | number : 1"></span>%
                                                </div>
                                            </div>
                                        </div>
                                        <div class="max-not-data" ng-show="exerciseList.length == 0">暂无课程</div>
                                        <div class="course-list" ng-repeat="course in exerciseList">
                                            <!-- 标题目录 -->
                                            <div class="row lookUp">
                                                <div class="col-xs-1">
                                                    <div class="fold">
                                                        <span></span>
                                                        <i class="icon-add"></i>
                                                    </div>
                                                </div>
                                                <div class="col-xs-11">
                                                    <div class="course-title" ng-bind="course.curriculumName">
                                                    </div>
                                                    <div class="course-label">
                                                        <span class="year-label">{{course.year | date : 'yyyy'}}年</span>
                                                        <span class="erect"></span>
                                                        <span class="type-label" ng-bind="course.stageName"></span>
                                                    </div>
                                                    <div class="exam-progress-bar parent-bar">
                                                        <span ng-show="course.examinationTotalNum == null || course.examinationTotalNum == 0" style="width: 1%" class="exam-progress"></span>
                                                        <span ng-show="course.examinationTotalNum != null && course.examinationTotalNum != 0" class="exam-progress"></span>
                                                        <span class="exam-num-parent">
                                                            <span ng-show="course.examinationTotalNum == null || course.examinationTotalNum == 0" style="left: 1%;" class="exam-num">{{course.examinationTotalNum}}题</span>
                                                            <span ng-show="course.examinationTotalNum != null && course.examinationTotalNum != 0" class="exam-num">{{course.examinationTotalNum}}题</span>
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- 子目录 -->
                                            <div class="catalogue-list">
                                                <div class="row catalogue-item" ng-repeat="wares in course.courseWares">
                                                    <div class="col-xs-1">
                                                        <div class="plan">
                                                            <span></span>
                                                            <i class="icon-all"></i>
                                                        </div>
                                                    </div>
                                                    <div class="col-xs-9">
                                                        <div class="catalogue-title">{{wares.courseWareName}}</div>
                                                        <div class="exam-progress-bar">
                                                            <span ng-show="wares.examinationTotalNum != null && wares.examinationTotalNum != 0" class="exam-progress"
                                                                  style="width: {{wares.examinationNum / wares.examinationTotalNum * 50 == 0 ? '1%' : wares.examinationNum / wares.examinationTotalNum * 50 + '%'}}"></span>
                                                            <span ng-show="wares.examinationTotalNum == null || wares.examinationTotalNum == 0" class="exam-progress" style="width: 1%;"></span>
                                                            <span class="exam-num-parent">
                                                                <span ng-show="wares.examinationTotalNum == null || wares.examinationTotalNum == 0" class="exam-num"
                                                                      style="left: 1%">{{wares.examinationNum == null ? 0 : wares.examinationNum}}题</span>
                                                                <span ng-show="wares.examinationTotalNum != null && wares.examinationTotalNum != 0" class="exam-num"
                                                                      style="left: {{wares.examinationNum / wares.examinationTotalNum * 50 == 0 ? '1%' : wares.examinationNum / wares.examinationTotalNum * 50 + '%'}}">{{wares.examinationNum == null ? 0 : wares.examinationNum}}题</span>
                                                            </span>
                                                        </div>
                                                    </div>
                                                    <div class="col-xs-2 doExercise-div">
                                                        <a class="min-blue-button doExercise" ng-click="examination(course, wares.id, 0, wares.isExamination)">
                                                            马上做题
                                                            <i class="icon-do-exam"></i>
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- 错题库 -->
                                    <div class="layui-tab-item">
                                        <div class="count-num-bar">
                                            <div class="row">
                                                <div class="col-xs-6" style="border: none"></div>
                                                <div class="col-xs-6" style="text-align: right">
                                                    共<span>{{statisticsExamination.errorNum}}</span>题
                                                </div>
                                            </div>
                                        </div>
                                        <div class="max-not-data" ng-show="errorList.length == 0">暂无课程</div>
                                        <div class="course-list" ng-repeat="course in errorList">
                                            <!-- 标题目录 -->
                                            <div class="row lookUp">
                                                <div class="col-xs-1">
                                                    <div class="fold">
                                                        <span></span>
                                                        <i class="icon-add"></i>
                                                    </div>
                                                </div>
                                                <div class="col-xs-11">
                                                    <div class="course-title">
                                                        {{course.curriculumName}}
                                                    </div>
                                                    <div class="course-label">
                                                        <span class="year-label">{{course.year | date : 'yyyy'}}年</span>
                                                        <span class="erect"></span>
                                                        <span class="type-label">{{course.stageName}}</span>
                                                    </div>
                                                    <div class="exam-progress-bar parent-bar">
                                                        <span ng-show="course.examinationTotalNum == null || course.examinationTotalNum == 0" style="width: 1%" class="exam-progress"></span>
                                                        <span ng-show="course.examinationTotalNum != null && course.examinationTotalNum != 0" class="exam-progress"></span>
                                                        <span class="exam-num-parent">
                                                            <span ng-show="course.examinationTotalNum == null || course.examinationTotalNum == 0" style="left: 1%;" class="exam-num">{{course.examinationTotalNum}}题</span>
                                                            <span ng-show="course.examinationTotalNum != null && course.examinationTotalNum != 0" class="exam-num">{{course.examinationTotalNum}}题</span>
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- 子目录 -->
                                            <div class="catalogue-list">
                                                <div class="row catalogue-item" ng-repeat="wares in course.courseWares">
                                                    <div class="col-xs-1">
                                                        <div class="plan">
                                                            <span></span>
                                                            <i class="icon-all"></i>
                                                        </div>
                                                    </div>
                                                    <div class="col-xs-9">
                                                        <div class="catalogue-title">{{wares.courseWareName}}</div>
                                                        <div class="exam-progress-bar">
                                                            <span ng-show="wares.examinationTotalNum != null && wares.examinationTotalNum != 0" class="exam-progress"
                                                                  style="width: {{wares.examinationNum / wares.examinationTotalNum * 50 == 0 ? '1%' : wares.examinationNum / wares.examinationTotalNum * 50 + '%'}}"></span>
                                                            <span ng-show="wares.examinationTotalNum == null || wares.examinationTotalNum == 0" class="exam-progress" style="width: 1%;"></span>
                                                            <span class="exam-num-parent">
                                                                <span ng-show="wares.examinationTotalNum == null || wares.examinationTotalNum == 0" class="exam-num"
                                                                      style="left: 1%">{{wares.examinationNum == null ? 0 : wares.examinationNum}}题</span>
                                                                <span ng-show="wares.examinationTotalNum != null && wares.examinationTotalNum != 0" class="exam-num"
                                                                      style="left: {{wares.examinationNum / wares.examinationTotalNum * 50 == 0 ? '1%' : wares.examinationNum / wares.examinationTotalNum * 50 + '%'}}">{{wares.examinationNum == null ? 0 : wares.examinationNum}}题</span>
                                                            </span>
                                                        </div>
                                                    </div>
                                                    <div class="col-xs-2 doExercise-div">
                                                        <a class="min-blue-button doExercise" ng-click="findErrorExam(course, wares.id, wares.courseWareName)">
                                                            查看错题
                                                            <i class="icon-do-exam"></i>
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- 模拟题 -->
                                    <div ng-class="{true:'layui-tab-item layui-show', false: 'layui-tab-item'}[examType == 1]">
                                        <div class="count-num-bar">
                                            <div class="row">
                                                <div class="col-xs-6" style="text-align: left">
                                                    已模拟<span ng-bind="statisticsExamination.simulationCountNum"></span>题
                                                </div>
                                                <div class="col-xs-6" style="text-align: right">
                                                    正确率<span ng-bind="statisticsExamination.simulationCorrectPercent * 100 | number : 1"></span>%
                                                </div>
                                            </div>
                                        </div>
                                        <div class="max-not-data" ng-show="simulateList.length == 0">暂无课程</div>
                                        <div class="course-list" ng-repeat="course in simulateList">
                                            <div class="row simulation">
                                                <div class="col-xs-12">
                                                    <div class="course-title">
                                                        {{course.curriculumName}}
                                                        <span ng-show="examinationNum > 0" class="state-label state-not-pass">已模拟</span>
                                                        <a ng-show="examinationNum == null || examinationNum == 0" class="min-blue-button simulation-btn" ng-click="examination(course, wares.id, 1, null)">
                                                            开始模拟
                                                            <i class="icon-do-exam"></i>
                                                        </a>
                                                    </div>
                                                    <div class="course-label">
                                                        <span class="year-label">{{course.year | date : 'yyyy'}}年</span>
                                                        <span class="erect"></span>
                                                        <span class="type-label">{{course.stageName}}</span>
                                                    </div>
                                                    <div class="exam-progress-bar parent-bar">
                                                        <span ng-show="course.examinationTotalNum == null || course.examinationTotalNum == 0" style="width: 1%" class="exam-progress"></span>
                                                        <span ng-show="course.examinationTotalNum != null && course.examinationTotalNum != 0" class="exam-progress"></span>
                                                        <span class="exam-num-parent">
                                                            <span ng-show="course.examinationTotalNum == null || course.examinationTotalNum == 0" style="left: 1%;" class="exam-num">{{course.examinationTotalNum}}题</span>
                                                            <span ng-show="course.examinationTotalNum != null && course.examinationTotalNum != 0" class="exam-num">{{course.examinationTotalNum}}题</span>
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- 正式考试 -->
                                    <div class="layui-tab-item">
                                        <div class="count-num-bar">
                                            <div class="row">
                                                <div class="col-xs-6" style="text-align: left">
                                                    已通过<span ng-bind="statisticsExamination.passNum"></span>
                                                </div>
                                                <div class="col-xs-6" style="text-align: right">
                                                    未通过<span ng-bind="statisticsExamination.nonPassNum"></span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="max-not-data" ng-show="examList.length == 0">暂无课程</div>
                                        <div class="course-list" ng-repeat="course in examList">
                                            <div class="row simulation">
                                                <div class="col-xs-12">
                                                    <div class="course-title">
                                                        {{course.curriculumName}}
                                                        <span ng-show="course.isPass == 1" class="state-label state-pass">已通过</span>
                                                        <span ng-show="course.examNum == 3 && (course.isPass == 0 || course.isPass == null)" class="state-label state-not-pass">3次未通过</span>
                                                        <span ng-show="course.examNum == 1 && (course.isPass == 0 || course.isPass == null)" class="state-label state-not-pass">未通过</span>
                                                        <a ng-show="(course.isPass == 0 || course.isPass == null) && (course.examNum == null || course.examNum == 0)" class="min-blue-button simulation-btn" ng-click="examination(course, wares.id, 2, null)">
                                                            开始考试
                                                            <i class="icon-do-exam"></i>
                                                        </a>
                                                        <a ng-show="(course.isPass == 0 || course.isPass == null) && course.examNum != null && course.examNum != 0" class="min-blue-button simulation-btn" ng-click="examination(course, wares.id, 2, null)">
                                                            重新考核
                                                            <i class="icon-do-exam"></i>
                                                        </a>
                                                    </div>
                                                    <div class="course-label">
                                                        <span class="year-label">{{course.year | date : 'yyyy'}}年</span>
                                                        <span class="erect"></span>
                                                        <span class="type-label">{{course.stageName}}</span>
                                                    </div>
                                                    <div class="exam-progress-bar parent-bar">
                                                        <span ng-show="course.examinationTotalNum == null || course.examinationTotalNum == 0" style="width: 1%" class="exam-progress"></span>
                                                        <span ng-show="course.examinationTotalNum != null && course.examinationTotalNum != 0" class="exam-progress"></span>
                                                        <span class="exam-num-parent">
                                                            <span ng-show="course.examinationTotalNum == null || course.examinationTotalNum == 0" style="left: 1%;" class="exam-num">{{course.examinationTotalNum}}题</span>
                                                            <span ng-show="course.examinationTotalNum != null && course.examinationTotalNum != 0" class="exam-num">{{course.examinationTotalNum}}题</span>
                                                        </span>
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
            </div>
        </div>
    </div>
</div>

<%@include file="../common/bottom.jsp" %>
<%@include file="../common/js.jsp" %>

<script>
    $("body").append(config.showShade("正在加载,请稍等..."));
    config.reload();
    var webApp = angular.module('aiMaiApp', []);
    webApp.controller("controller", function($scope, $timeout) {
        $scope.userInfo = config.aiMaiUser();
        $scope.ipImg = config.ipImg;
        $scope.examType = sessionStorage.getItem("examType");
        $scope.exerciseList = null; //练习
        $scope.simulateList = null; //模拟
        $scope.examList = null; //考试
        $scope.errorList = null; //错题
        $scope.statisticsExamination = null; //统计考题

        $scope.getDataList = function (type) {
            $scope.parameter = {
                pageNO : 1,
                pageSize : 1000,
                type : type
            }
            config.ajaxRequestData(false, "curriculum/listForPC", $scope.parameter, function (result) {
                switch (type){
                    case 0:
                        $scope.exerciseList = result.data;
                        for (var i = 0; i < $scope.exerciseList.length; i++) {
                            var obj = $scope.exerciseList[i];
                            for (var j = 0; j < obj.courseWares.length; j++) {
                                var courseWares = obj.courseWares[j];
                                obj.examinationTotalNum += courseWares.examinationTotalNum;
                            }
                        }
                        break;
                    case 1: $scope.simulateList = result.data; break;
                    case 2: $scope.examList = result.data; break;
                    case 3:
                        $scope.errorList = result.data;
                        for (var i = 0; i < $scope.errorList.length; i++) {
                            var obj = $scope.errorList[i];
                            for (var j = 0; j < obj.courseWares.length; j++) {
                                var courseWares = obj.courseWares[j];
                                obj.examinationTotalNum += courseWares.examinationTotalNum;
                            }
                        }
                        break;
                }
            });
        }
        //0：练习题  1：模拟题 2：考试题 3：错题库 其他参数无效 参数类型
        $scope.getDataList(0);
        $scope.getDataList(1);
        $scope.getDataList(2);
        $scope.getDataList(3);

        //获取考试统计
        config.ajaxRequestData(false, "curriculum/statisticsCurriculum", $scope.parameter, function (result) {
            $scope.statisticsExamination = result.data;
        });

        //做题页面
        $scope.examination = function (course, courseWareId, type, isExamination) {
            if (type == 0) {
                if (isExamination == 0) {
                    layer.msg("还未学习暂不能练习.");
                    return false;
                }
            }
            else if (type == 1 || type == 2) {
                if (course.isExamination == 0) {
                    layer.msg("还未学习暂不能考试.");
                    return false;
                }
            }
            if (course.examinationTotalNum == 0 || course.examinationTotalNum == null) {
                layer.msg("没有考试题.");
                return false;
            }
            $scope.jsonId = {
                curriculumId : course.id,
                courseWareId : courseWareId,
                orderId : course.orderId,
                useTime : course.useTime,
                curriculumName : course.curriculumName,
                type : type
            }
            config.log($scope.jsonId);
            sessionStorage.removeItem("countDown");//清空时间
            sessionStorage.setItem("courseIds",JSON.stringify($scope.jsonId));
            sessionStorage.setItem("paperId", course.paperId);
            window.open(config.ip + "page/person/exam");
        }

        //查看错题
        $scope.findErrorExam = function (course, courseWareId, courseWareName) {
            if (course.examinationTotalNum == 0 || course.examinationTotalNum == null) {
                layer.msg("没有错题.");
                return false;
            }
            $scope.jsonId = {
                curriculumName : course.curriculumName,
                courseWareId : courseWareId,
                courseWareName : courseWareName,
                orderId : course.orderId,
                pageNO : 1,
                pageSize : 1000
            }
            sessionStorage.setItem("errorCourseIds",JSON.stringify($scope.jsonId));
            window.open(config.ip + "page/person/errorExam");
        }


        //设置点击展开、关闭
        $(function () {
            $(".fold .icon-add").each(function (index) {
                var $i = $(this);
                $i.click(function () {
                    $i.parent().addClass("fold-active");
                    $(".catalogue-list").eq(index).slideToggle("slow", function () {
                        if ($(this).is(":hidden")) {
                            $i.parent().removeClass("fold-active");
                        }
                    });
                });
            });
        });

        config.hideShade();
    });

</script>
</body>
</html>

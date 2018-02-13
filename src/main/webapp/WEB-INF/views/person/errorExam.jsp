<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>错题库</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/person/exam.css">
</head>
<body ng-app="aiMaiApp" ng-controller="controller" ng-cloak>

<%@include file="../common/top.jsp" %>
<div class="ai-content">

    <div class="container">

        <div class="location-bar">
            <a href="<%=request.getContextPath()%>/page/person/myExam">我的考题</a>
            <i class="fa fa-chevron-right"></i>
            <%--<a href="javascript:history.back()">上个位置</a>
            <i class="fa fa-chevron-right"></i>--%>
            <span>当前位置</span>
        </div>

        <div class="exam-bar">
            <div class="course-title">
                <h2>{{errorCourseIds.curriculumName}}</h2>
                <div class="row time-bar">
                    <div class="col-xs-12">
                        <span class="totalTime">{{errorCourseIds.courseWareName}}</span>
                    </div>
                </div>
            </div>
            <div class="exam-item" ng-repeat="examination in paper">
                <span ng-show="examination.type == 0" class="topic-type">单选题</span>
                <span ng-show="examination.type == 1" class="topic-type">多选题</span>
                <span ng-show="examination.type == 2" class="topic-type">判断题</span>
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
        $scope.errorCourseIds = JSON.parse(sessionStorage.getItem("errorCourseIds"));
        $scope.paper = null; //试卷

        config.ajaxRequestData(false, "examination/queryErrorExamination", $scope.errorCourseIds, function (result) {
            $scope.paper = result.data;
        });

        config.hideShade();

    });

</script>
</body>
</html>

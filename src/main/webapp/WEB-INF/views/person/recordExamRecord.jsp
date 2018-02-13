<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>统计数据</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/person/dataCountCompany.css">
    <style>
        .company-table tr th:first-child{padding-left: 0}
    </style>
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
                                        数据统计
                                    </div>
                                    <div class="schedule">
                                        <a href="javascript: window.history.back()">数据统计</a>
                                        <span>&gt;</span>
                                        <a class="schedule-active">考试记录列表</a>
                                    </div>
                                </div>

                                <div class="company-list">
                                    <table class="company-table">
                                        <thead>
                                        <tr>
                                            <th class="center">考试名称</th>
                                            <th class="center">考试时间</th>
                                            <th class="center">用时</th>
                                            <th class="center">课程名</th>
                                            <th class="center">此次考试得分</th>
                                            <th class="center">及格分数</th>
                                            <th class="center">是否通过</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                            <tr ng-repeat="data in paperRecordList">
                                                <td class="center">{{data.paperTitle}}</td>
                                                <td class="center">{{data.createTime | date : 'yyyy-MM-dd hh:mm:ss'}}</td>
                                                <td class="center">{{data.seconds == null ? "--" : data.seconds}}</td>
                                                <td class="center">{{data.curriculumName}}</td>
                                                <td class="center">{{data.resultScore}}</td>
                                                <td class="center">{{data.passScore}}</td>
                                                <td class="center">
                                                    <span ng-if="data.resultScore >= data.passScore" class='orange-badge'>通过</span>
                                                    <span ng-if="data.resultScore < data.passScore" class='gray-badge'>未通过</span>
                                                </td>
                                            </tr>
                                        </tbody>
                                        <tfoot>
                                            <tr ng-show="paperRecordList.length == 0 || paperRecordList == null">
                                                <td class="not-data" colspan="99">暂无数据</td>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </div>

                                <div class="page-bar row">
                                    <div class="col-xs-4">
                                    </div>
                                    <div class="col-xs-8">
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
            $scope.paperRecordList = null;
            $scope.totalPage = 0;

            layui.use(['laypage', 'layer'], function(){
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
                            //config.log(obj);
                            if(!first){
                                $scope.getDataList(obj.curr, 30);
                            }
                        }
                    });
                    form.render();
                }
            });

            //获取用户列表
            $scope.getDataList = function (pageNO, pageSize) {
                $scope.parameter = {
                    pageNO : pageNO,
                    pageSize : pageSize,
                    userId : config.getUrlParam("userId")
                }
                config.ajaxRequestData(false, "record/paperRecordList", $scope.parameter, function (result) {
                    if (!$scope.isFirst) {
                        $scope.totalPage = result.data.count;
                        $scope.paperRecordList = result.data.dataList;
                        $scope.isFirst = true;
                        $scope.changePage(result.data.count);
                    }
                    else {
                        $timeout(function () {
                            $scope.totalPage = result.data.count;
                            $scope.paperRecordList = result.data.dataList;
                        });
                    }
                });
            }
            //默认调用
            $scope.getDataList(1, 30);

            config.hideShade();

        });

    </script>
</body>
</html>

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
                                        <a href="<%=request.getContextPath()%>/page/person/recordCompany">数据统计</a>
                                        <span>&gt;</span>
                                        <a href="javascript: window.history.back()">学习情况列表</a>
                                        <span>&gt;</span>
                                        <a class="schedule-active">课件列表</a>
                                    </div>
                                </div>

                                <div class="company-list">
                                    <table class="company-table">
                                        <thead>
                                        <tr>
                                            <th class="center">课件名称</th>
                                            <th class="center">学习进度</th>
                                            <th class="center">学习开始时间</th>
                                            <th class="center">操作</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                            <tr ng-repeat="data in coursewareList">
                                                <td class="center">{{data.courseWareName}}</td>
                                                <td class="center">{{data.expendSeconds / data.hdSeconds * 100}}%</td>
                                                <td class="center">{{data.studyStartTime | date : 'yyyy-MM-dd hh:mm:ss'}}</td>
                                                <td class="center">
                                                    <button class="info-btn" ng-click="faceList(data.id)">人脸验证列表</button>
                                                </td>
                                            </tr>
                                        </tbody>
                                        <tfoot>
                                            <tr ng-show="coursewareList.length == 0 || coursewareList == null">
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
            $scope.coursewareList = null;
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
                config.ajaxRequestData(false, "record/listForWebUser", $scope.parameter, function (result) {
                    if (!$scope.isFirst) {
                        $scope.totalPage = result.data.count;
                        $scope.coursewareList = result.data.dataList;
                        $scope.isFirst = true;
                        $scope.changePage(result.data.count);
                    }
                    else {
                        $timeout(function () {
                            $scope.totalPage = result.data.count;
                            $scope.coursewareList = result.data.dataList;
                        });
                    }
                });
            }
            //默认调用
            $scope.getDataList(1, 30);

            //课件列表
            $scope.faceList = function (coursewareId) {
                location.href = config.ip + "page/person/recordFace?coursewareId=" + coursewareId + "&userId=" + config.getUrlParam("userId");
            }

            config.hideShade();

        });

    </script>
</body>
</html>

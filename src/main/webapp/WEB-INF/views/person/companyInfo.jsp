<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>公司详情</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/person/companyInfo.css">
</head>
<body ng-app="aiMaiApp" ng-controller="controller" ng-cloak>

<%@include file="../common/top.jsp" %>
<div class="ai-content">

    <div class="container">
        <div class="company-bg">
            <div class="row">
                <div class="col-xs-6 head-bar">
                    <div>
                        <img ng-show="company.avatar == null" src="<%=request.getContextPath()%>/resources/img/default-head.png">
                        <img ng-show="company.avatar != null" src="{{ipImg}}{{company.avatar}}">
                        <p class="company-name">{{company.showName}}</p>
                        <p class="company-hint">{{company.city.mergerName}}</p>
                    </div>
                </div>
                <div class="col-xs-6 place-number">
                    <div class="row">
                        <div class="col-xs-4">
                            <div class="number-font">{{company.joinNum}}位</div>
                            <div class="number-font">参培人员</div>
                        </div>
                        <div class="col-xs-4">
                            <div class="number-font">{{company.safeNum}}位</div>
                            <div class="number-font">安全人员</div>
                        </div>
                        <div class="col-xs-4">
                            <div class="number-font">{{company.joinNum - company.safeNum}}位</div>
                            <div class="number-font">未通过人员</div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="tab-cut">
                <div class="row">
                    <div class="col-xs-6">
                        <span class="tab-title company-active" ng-click="showContent(1, $event)">
                            基本信息
                        </span>
                    </div>
                    <div class="col-xs-6">
                        <span class="border-right"></span>
                        <span class="tab-title" ng-click="showContent(2, $event)">
                            购买的课程
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <div class="content">
            <div id="basicInfo">
                <div class="row company-info">
                    <div class="col-xs-1">营业执照编号</div>
                    <div class="col-xs-11">{{company.pid}}</div>
                </div>
                <div class="row company-info">
                    <div class="col-xs-1">行业</div>
                    <div class="col-xs-11">{{company.tradeName}}</div>
                </div>
                <div class="row company-info">
                    <div class="col-xs-1">地址</div>
                    <div class="col-xs-11">{{company.city.mergerName}}</div>
                </div>
                <div class="row company-info">
                    <div class="col-xs-1">营业执照证</div>
                    <div class="col-xs-11">
                        <img src="{{ipImg}}{{company.licenseFile}}">
                    </div>
                </div>
            </div>

            <div id="courseInfo">
                <div ng-show="curriculumList.length == 0 || curriculumList == null" class="not-data">暂无数据</div>
                <div class="row course-list" ng-repeat="curriculum in curriculumList">
                    <div class="col-xs-3">
                        <div class="course-cover" style="background: url('{{ipImg}}{{curriculum.cover}}')"></div>
                    </div>
                    <div class="col-xs-9">
                        <div class="course-info">
                            <div class="row course-title-bar">
                                <div class="col-xs-9 course-title">
                                    {{curriculum.curriculumName}}
                                </div>
                                <div class="col-xs-3">
                                    <div class="col-xs-6">
                                        <i class="icon-video"></i>
                                        <span class="icon-font">{{curriculum.videoNum}}个视频课</span>
                                    </div>
                                    <div class="col-xs-6">
                                        <i class="icon-time"></i>
                                        <span class="icon-font">{{curriculum.hdSeconds}}分钟</span>
                                    </div>
                                </div>
                            </div>

                            <div class="course-tab">
                                <ul class="course-tab-title">
                                    <li class="course-this">观看人员({{curriculum.watchUsers.length}})</li>
                                    <li>安全人员({{curriculum.safeUsers.length}})</li>
                                </ul>
                                <div class="row course-tab-content">
                                    <div class="course-tab-item course-tab-show">
                                        <div ng-show="curriculum.watchUsers == null || curriculum.watchUsers.length == 0" class="min-not-data">暂无数据</div>
                                        <div class="col-xs-10 user-hidden" ng-show="curriculum.watchUsers.length > 0">
                                            <div class="user-list" ng-repeat="user in curriculum.watchUsers">
                                                <div ng-show="user.avatar != null" class="user-head" style="background: url('{{ipImg}}{{user.avatar}}')"></div>
                                                <div ng-show="user.avatar == null" class="user-head" style="background: url('<%=request.getContextPath()%>/resources/img/default-head.png')"></div>
                                                <div class="name">{{user.showName}}</div>
                                            </div>
                                            <div class="col-xs-12 pack-up" ng-show="curriculum.watchUsers.length > 10">
                                                <button class="min-blue-button" ng-click="packUp($event)">收起</button>
                                            </div>
                                        </div>
                                        <div class="col-xs-2">
                                            <div class="find-more">
                                                <button ng-show="curriculum.watchUsers.length > 10" class="min-blue-button more-btn" ng-click="more($event)">查看更多</button>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="course-tab-item">
                                        <div ng-show="curriculum.safeUsers == null || curriculum.safeUsers.length == 0" class="min-not-data">暂无数据</div>
                                        <div class="col-xs-10 user-hidden" ng-show="curriculum.safeUsers.length > 0">
                                            <div class="user-list" ng-repeat="user in curriculum.safeUsers">
                                                <div ng-show="user.avatar != null" class="user-head" style="background: url('{{ipImg}}{{user.avatar}}')"></div>
                                                <div ng-show="user.avatar == null" class="user-head" style="background: url('<%=request.getContextPath()%>/resources/img/default-head.png')"></div>
                                                <div class="name">{{user.showName}}</div>
                                            </div>
                                            <div class="col-xs-12 pack-up" ng-show="curriculum.safeUsers.length > 10">
                                                <button class="min-blue-button" ng-click="packUp($event)">收起</button>
                                            </div>
                                        </div>
                                        <div class="col-xs-2">
                                            <div class="find-more">
                                                <button ng-show="curriculum.safeUsers.length > 10" class="min-blue-button more-btn" ng-click="more($event)">查看更多</button>
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
    var webApp = angular.module('aiMaiApp', []);
    webApp.controller("controller", function($scope) {
        $scope.userInfo = config.aiMaiUser();
        $scope.ipImg = config.ipImg;

        $scope.companyId = sessionStorage.getItem("companyId");
        $scope.company = null;
        $scope.curriculumList = null;

        config.ajaxRequestData(false, "user/queryCompanyDetail", {companyId : $scope.companyId}, function (result) {
            $scope.company = result.data;
        });

        $scope.getCurriculumList = function (pageNO, pageSize) {
            $scope.parameter = {
                pageNO : pageNO,
                pageSize : pageSize,
                companyId : $scope.companyId
            }
            config.ajaxRequestData(false, "curriculum/queryCurriculumByCompany", $scope.parameter, function (result) {
                $scope.curriculumList = result.data;
                for (var i = 0; i < $scope.curriculumList.length; i++) {
                    $scope.curriculumList[i].lowSeconds = config.getFormat($scope.curriculumList[i].lowSeconds);
                }
            });
        }
        $scope.getCurriculumList(1, 10);

        //选择菜单
        $scope.showContent = function (type,$event) {
            $(".tab-title").removeClass("company-active");
            $($event.target).addClass("company-active");
            if (type == 1) {$("#basicInfo").show();$("#courseInfo").hide();}
            if (type == 2) {$("#courseInfo").show();$("#basicInfo").hide();}
        }

        //查看更多
        $scope.more = function ($event) {

            $(".course-tab-content").removeClass("course-tab-more");
            $(".course-tab").removeClass("course-this-index");
            $(".pack-up").slideUp();
            $(".more-list").slideUp();
            $(".more-btn").fadeIn();

            var $obj = $($event.target).parent().parent().parent();
            $($obj).parent().addClass("course-tab-more");
            $($obj).parent().parent().addClass("course-this-index");
            $($obj).find(".more-btn").fadeOut();
            $($obj).find(".more-list").slideDown();
            $($obj).find(".pack-up").slideDown();
            $($obj).find(".user-hidden").removeClass("user-hidden");

        }

        //收起
        $scope.packUp = function ($event) {
            var $obj = $($event.target).parent().parent().parent();
            $($obj).find(".col-xs-10").addClass("user-hidden");
            $($obj).find(".pack-up").hide("slow");
            $($obj).find(".more-list").hide("slow");
            setTimeout(function () {
                $($obj).parent().removeClass("course-tab-more");
                $($obj).parent().parent().removeClass("course-this-index");
            },300);
            $($obj).find(".more-btn").fadeIn();
        }

        //给tab选项卡绑定点击事件，然而显示相应的content
        $(function () {
            $(".course-tab-title li").click(function () {
                $(this).parent().find("li").removeClass("course-this");
                $(this).addClass("course-this");
                $(this).parent().parent().find(".course-tab-item").hide();
                $(this).parent().parent().find(".course-tab-item").eq($(this).index()).show();
            });
        })

        config.hideShade();
    });

</script>
</body>
</html>

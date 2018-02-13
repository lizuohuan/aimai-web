<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>统计数据</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/person/dataCount.css">
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
                                    <div class="sub-search-bar">
                                        <i class="search-icon"></i>
                                        <input id="search" type="text" class="sub-search-input" placeholder="搜索公司">
                                    </div>
                                </div>
                                <div class="screen-bar">
                                    <form class="layui-form" id="formData">
                                        <div class="layui-form-item">
                                            <label class="layui-form-label">筛选：</label>
                                            <div class="layui-input-inline">
                                                <select id="year" lay-filter="year" lay-search>
                                                    <option value="">请选择年</option>
                                                </select>
                                            </div>
                                            <div class="layui-input-inline">
                                                <div class="screen-course">
                                                    <a><span id="courseActive">所有</span><i class="fa fa-sort-desc"></i></a>
                                                    <div class="screen-tab-content screen-course-content">
                                                        <div class="course-item course-item-active" value="">所有</div>
                                                        <div class="course-item" value="2">全员培训</div>
                                                        <div class="course-item" value="1">三项培训</div>
                                                    </div>
                                                </div>
                                            </div>
                                            <%--<div class="layui-input-inline">
                                                <div class="screen-address">
                                                    <a onclick="openAddress()">所在地<i class="fa fa-sort-desc"></i></a>
                                                </div>
                                            </div>--%>
                                        </div>
                                    </form>
                                </div>
                            </div>

                            <div class="count-list" ng-cloak>
                                <div class="row">
                                    <div class="col-xs-3">
                                        <div class="name">企业</div>
                                        <div class="number-bar">
                                            <span class="number" ng-bind="dataInfo.companyNum"></span>
                                            <span class="unit">个</span>
                                        </div>
                                    </div>
                                    <div class="col-xs-3">
                                        <div class="name">安全人数</div>
                                        <div class="number-bar">
                                            <span class="number" ng-bind="dataInfo.safeNum"></span>
                                            <span class="unit">位</span>
                                        </div>
                                    </div>
                                    <div class="col-xs-3">
                                        <div class="name">全员培训认证通过人员</div>
                                        <div class="number-bar">
                                            <span class="number" ng-bind="dataInfo.allSafeNum"></span>
                                            <span class="unit">位</span>
                                        </div>
                                    </div>
                                    <div class="col-xs-3">
                                        <div class="name">三项培训认证通过人员</div>
                                        <div class="number-bar">
                                            <span class="number" ng-bind="dataInfo.threeSafeNum"></span>
                                            <span class="unit">位</span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-xs-12 export-bar">
                                <button class="min-blue-button" ng-click="export()">导出公司列表</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="whiteMask"></div>
<div class="modal-this" id="addressModal">
    <div class="modal-title">
        选择地址
        <span class="modal-close-btn" id="closeBtn">关闭</span>
        <span class="modal-ok-btn" ng-click="confirmAddress()">确定</span>
    </div>
    <div class="modal-context">
        <div class="select-address">
            <ul class="address-tab">
                <li class="address-active" id="provinceName">请选择</li>
                <li id="cityName" class="not-click"></li>
                <li id="countyName" class="not-click"></li>
            </ul>
            <div class="address-tab-content">
                <div class="address-tab-item address-tab-item-show">
                    <ul class="address-list" id="province">
                        <li ng-click="selectProvince(address, $event)" ng-repeat="address in addressList">{{address.shortName}}</li>
                    </ul>
                </div>
                <div class="address-tab-item">
                    <ul class="address-list" id="city">
                        <li ng-click="selectCity(city, $event)" ng-repeat="city in addressCity">{{city.shortName}}</li>
                    </ul>
                </div>
                <div class="address-tab-item">
                    <ul class="address-list" id="county">
                        <li ng-click="selectCounty(county, $event)" ng-repeat="county in addressCounty">{{county.shortName}}</li>
                    </ul>
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
        $scope.dataInfo = null;

        $scope.addressList = null; //存放省
        $scope.addressCity = null; //存放市
        $scope.addressCounty = null; //存放区
        $scope.cityId = null; //存放选中地址ID
        $scope.selectAddress = $scope.userInfo == null ? null : $scope.userInfo.city.mergerName; //已选择地址
        $scope.levelType = 0; //存放地址等级
        $scope.tempAddress = null; //临时存放已选地址
        $scope.searchParams = null; //存放搜索内容
        $scope.stageId = null; //存放类型ID
        $scope.year = null; //存放年

        config.ajaxRequestData(false, "city/getCities", {}, function (result) {
            $scope.addressList = result.data;
        });

        //选择省
        $scope.selectProvince = function (address, event) {
            $scope.cityId = address.id;
            $scope.tempAddress = address.mergerName;
            $scope.levelType = 1;
            var obj = event.target; //获取当前对象
            $("#province li").removeClass("address-list-active");
            $(obj).addClass("address-list-active");
            $scope.addressCity = address.cityList;
            $("#provinceName").html(address.name);
            $("#cityName").html(address.shortName);
            //重置县
            $scope.addressCounty = null;
            $("#countyName").html("");
            $("#countyName").addClass("not-click");

            $(".address-tab li").removeClass("address-active");
            $(".address-tab li").eq(1).addClass("address-active").removeClass("not-click");
            $(".address-tab-content").find(".address-tab-item").removeClass("address-tab-item-show");
            $(".address-tab-content").find(".address-tab-item").eq(1).addClass("address-tab-item-show");

        }

        //选择市
        $scope.selectCity = function (address, event) {
            $scope.cityId = address.id;
            $scope.tempAddress = address.mergerName;
            $scope.levelType = 2;
            var obj = event.target; //获取当前对象
            $("#city li").removeClass("address-list-active");
            $(obj).addClass("address-list-active");
            $scope.addressCounty = address.cityList;
            $("#countyName").html(address.shortName);

            $(".address-tab li").removeClass("address-active");
            $(".address-tab li").eq(2).addClass("address-active").removeClass("not-click");
            $(".address-tab-content").find(".address-tab-item").removeClass("address-tab-item-show");
            $(".address-tab-content").find(".address-tab-item").eq(2).addClass("address-tab-item-show");
        }

        //选择县
        $scope.selectCounty = function (address, event) {
            var obj = event.target; //获取当前对象
            $("#county li").removeClass("address-list-active");
            $(obj).addClass("address-list-active");
            $scope.levelType = 3;
            $scope.cityId = address.id;
            $scope.selectAddress = address.mergerName;
            $scope.getStatistics($scope.year, $scope.stageId, $scope.cityId, 3, $scope.searchParams);
            closeAddress();
        }

        //获取统计信息
        $scope.getStatistics = function (yearTimeStamp, stageId, cityId, levelType, searchParams) {
            $scope.parameter = {
                yearTimeStamp : yearTimeStamp,
                stageId : stageId,
                cityId : cityId,
                levelType : levelType,
                searchParams : searchParams
            }
            config.log($scope.parameter);
            config.ajaxRequestData(false, "user/webStatistics", $scope.parameter, function (result) {
                $timeout(function () {
                    $scope.dataInfo = result.data;
                });
            });
        }

        $scope.getStatistics(new Date().getTime(), $scope.stageId, $scope.cityId, 1, null);

        //给搜索框绑定改变事件
        $('#search').bind('input propertychange', function() {
            $scope.searchParams = $("#search").val();
            config.log($scope.searchParams);
            $scope.getStatistics($scope.year, $scope.stageId, $scope.cityId, $scope.levelType, $scope.searchParams);
        });

        //点击地址弹窗确定按钮
        $scope.confirmAddress = function () {
            $scope.selectAddress = $scope.tempAddress;
            $scope.getStatistics($scope.year, $scope.stageId, $scope.cityId, $scope.levelType, $scope.searchParams);
            closeAddress();
        }

        //导出
        $scope.export = function () {
            $scope.year = $scope.year == null ? new Date().getTime() : $scope.year;
            $scope.levelType = $scope.cityId == null ? 3 : $scope.levelType;
            $scope.cityId = $scope.cityId == null ? $scope.userInfo.cityId : $scope.cityId;
            $scope.searchParams = $scope.searchParams == null ? "" : $scope.searchParams;
            $scope.stageId = $scope.stageId == null ? 0 : $scope.stageId;
            config.log($scope.year);
            config.log($scope.stageId);
            config.log($scope.cityId);
            config.log($scope.levelType);
            config.log($scope.searchParams);
            window.location.href = config.ip + "/user/exportExcel?yearTimeStamp="
                    + $scope.year
                    + "&stageId=" + $scope.stageId
                    + "&cityId=" + $scope.cityId
                    + "&levelType=" + $scope.levelType
                    + "&searchParams=" + $scope.searchParams
            ;
        }

        layui.use(['form'], function() {
            var form = layui.form();

            //搜索条件--初始化时间
            var html = "";
            var html2 = "";
            for (var i = 30; i > 1; i--) {
                var myDate = new Date();
                html += "<option value=\"" + (myDate.getFullYear() - i) + "\">" + (myDate.getFullYear() - i) + "</option>";
            }
            for (var i = 0; i < 20; i++) {
                var myDate = new Date();
                if (myDate.getFullYear() == myDate.getFullYear() + i) {
                    html2 += "<option selected value=\"" + (myDate.getFullYear() + i) + "\">" + (myDate.getFullYear() + i) + "</option>";
                }else {
                    html2 += "<option value=\"" + (myDate.getFullYear() + i) + "\">" + (myDate.getFullYear() + i) + "</option>";
                }
            }
            $("#year").html(html);
            $("#year").append(html2);
            form.render();

            form.on('select(year)', function(data) {
                $scope.year = config.getTimeStamp(data.value);
                $scope.getStatistics($scope.year, $scope.stageId, $scope.cityId, $scope.levelType, $scope.searchParams);
            });

        });

        //类型切换
        $(function () {
            $(".course-item").click(function () {
                $(".course-item").removeClass("course-item-active");
                $(this).addClass("course-item-active");
                $("#courseActive").html($(this).html());
                $scope.stageId = $(this).attr("value") == "" ? null : Number($(this).attr("value"));
                $scope.getStatistics($scope.year, $scope.stageId, $scope.cityId, $scope.levelType, $scope.searchParams);
            });
        });

        config.hideShade();
    });

    //地址选项卡切换
    $(function () {
        $(".address-tab li").click(function () {
            if ($(this).attr("class").indexOf("not-click") != -1) {
                return false;
            }
            $(this).parent().find("li").removeClass("address-active");
            $(this).addClass("address-active");
            $(this).parent().parent().find(".address-tab-item").removeClass("address-tab-item-show");
            $(this).parent().parent().find(".address-tab-item").eq($(this).index()).addClass("address-tab-item-show");
        });

        $("#closeBtn").bind("click", closeAddress);
    })

    //打开地址弹窗
    function openAddress () {
        $(".whiteMask").fadeIn();
        $("#addressModal").slideDown(200);
    }
    //打关闭地址弹窗
    function closeAddress () {
        $(".whiteMask").fadeOut();
        $("#addressModal").slideUp(200);
    }

</script>
</body>
</html>


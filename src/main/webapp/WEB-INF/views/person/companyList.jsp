<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>公司列表</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/person/companyList.css">
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
                                    公司列表
                                    <span>(共{{totalPage}}个公司、{{webStatistics.safeNum}}位安全人员)</span>
                                    <div class="sub-search-bar">
                                        <i class="search-icon"></i>
                                        <input id="search" type="text" class="sub-search-input" placeholder="搜索公司">
                                    </div>
                                </div>
                                <div class="site">
                                    <span class="site-hint">当前位置 :</span>
                                    <span id="selectAddress">{{selectAddress}}</span>
                                    <i class="fa fa-chevron-right"></i>
                                    <span class="cut-btn" id="cutAddressBtn">切换地址</span>
                                </div>
                            </div>

                            <div class="company-list">
                                <table class="company-table">
                                    <thead>
                                    <tr>
                                        <th>公司</th>
                                        <th>行业</th>
                                        <th>安全人数</th>
                                        <th>操作</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                        <tr ng-repeat="company in companyList">
                                            <td>
                                                <div class="table-head">
                                                    <img ng-show="company.avatar == null" src="<%=request.getContextPath()%>/resources/img/default-head.png">
                                                    <img ng-show="company.avatar != null" src="{{ipImg}}{{company.avatar}}">
                                                    <p class="company-name">{{company.showName}}</p>
                                                    <p class="company-hint">{{company.city.mergerName}}</p>
                                                </div>
                                            </td>
                                            <td>{{company.tradeName == null ? "--" : company.tradeName}}</td>
                                            <td>{{company.safeNum == null ? 0 : company.safeNum}}人</td>
                                            <td>
                                                <button class="info-btn" ng-click="companyInfo(company.id)">查看详情</button>
                                            </td>
                                        </tr>
                                    </tbody>
                                    <tfoot>
                                        <tr ng-show="companyList.length == 0 || companyList == null">
                                            <td class="not-data" colspan="99">暂无数据</td>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>

                            <div class="page-bar row">
                                <%--<div class="col-xs-2">
                                    <button class="min-blue-button export-btn" ng-click="export()">导出公司列表</button>
                                </div>--%>
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
            $scope.addressList = null;
            $scope.addressCity = null;
            $scope.addressCounty = null;
            $scope.cityId = null; //存放选中地址ID
            $scope.selectAddress = $scope.userInfo == null ? null : $scope.userInfo.city.mergerName; //已选择地址
            $scope.levelType = 0; //存放地址等级
            $scope.tempAddress = null; //临时存放已选地址
            $scope.searchParams = null; //存放搜索内容
            $scope.totalPage = 0; //存放总条
            $scope.companyList = null; //存放公司列表
            $scope.isFirst = false; //是否加载过第一次了
            $scope.webStatistics = null;

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

                $scope.cityId = address.id;
                $scope.selectAddress = address.mergerName;
                $scope.getCompanyList(1, 10, 3, $scope.cityId, $scope.searchParams);
                closeAddress();
            }

            //点击地址弹窗确定按钮
            $scope.confirmAddress = function () {
                $scope.selectAddress = $scope.tempAddress;
                $scope.getCompanyList(1, 10, $scope.levelType, $scope.cityId, $scope.searchParams);
                closeAddress();
            }

            //给搜索框绑定改变事件
            $('#search').bind('input propertychange', function() {
                $scope.searchParams = $("#search").val();
                config.log($scope.searchParams);
                $scope.getCompanyList(1, 10, $scope.levelType, $scope.cityId, $scope.searchParams);
            });

            //导出
            $scope.export = function () {

            }

            layui.use(['laypage', 'layer'], function(){
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
                                $scope.getCompanyList(obj.curr, 10, $scope.levelType, $scope.cityId, $scope.searchParams);
                            }
                        }
                    });
                    form.render();
                }
            });

            //获取公司列表
            $scope.getCompanyList = function (pageNO, pageSize, levelType, cityId, searchParams) {
                $scope.parameter = {
                    pageNO : pageNO,
                    pageSize : pageSize,
                    levelType : levelType,
                    cityId : cityId,
                    searchParams : searchParams
                }
                config.ajaxRequestData(false, "user/queryCompanyList", $scope.parameter, function (result) {
                    if (!$scope.isFirst) {
                        $scope.totalPage = result.data.count;
                        $scope.companyList = result.data.dataList;
                        $scope.isFirst = true;
                        $scope.changePage(result.data.count);
                    }
                    else {
                        $timeout(function () {
                            $scope.totalPage = result.data.count;
                            $scope.companyList = result.data.dataList;
                        });
                    }
                    //$scope.changePage(result.data.count);
                });
                $scope.parameter = {
                    cityId : cityId,
                    levelType : levelType,
                    searchParams : searchParams
                }
                config.ajaxRequestData(false, "user/webStatistics", $scope.parameter, function (result) {
                    $scope.webStatistics = result.data;
                });
            }
            //默认调用
            $scope.getCompanyList(1, 10, 1, null);

            //详情
            $scope.companyInfo = function (companyId) {
                sessionStorage.setItem("companyId", companyId);
                window.open(config.ip + "page/person/companyInfo");
            }

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

            $("#cutAddressBtn").bind("click", openAddress);
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

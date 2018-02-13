<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>我的订单</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/person/myOrder.css">
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
                                    <li class="layui-this">全部订单</li>
                                    <li>待付款</li>
                                    <li>已完成</li>
                                </ul>
                            </div>

                            <div class="table-list">
                                <table class="my-table">
                                    <thead>
                                    <tr>
                                        <th>订单内容</th>
                                        <th width="100px">支付金额</th>
                                        <th width="100px">数量</th>
                                        <th width="100px">状态</th>
                                        <th width="100px">操作</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                        <tr ng-repeat="order in orderList">
                                            <td>
                                                <div class="course">
                                                    <div ng-if="order.payStatus == null || order.payStatus == 0" class="course-cover" style="background: url('{{ipImg}}{{order.cover}}');cursor: default;"></div>
                                                    <div ng-if="order.payStatus == 1" ng-click="courseDetail(order.curriculumId)" class="course-cover" style="background: url('{{ipImg}}{{order.cover}}')"></div>
                                                    <div class="course-title">{{order.curriculumName}}</div>
                                                    <div class="course-label">
                                                        <span class="">{{order.year | date : 'yyyy'}}年</span>
                                                        <span class="">|</span>
                                                        <span class="">{{order.stageName}}</span>
                                                    </div>
                                                </div>
                                            </td>
                                            <td><span class="money">￥{{order.price}}</span></td>
                                            <td><span class="num">{{order.number}}</span></td>
                                            <td>
                                                <span ng-show="order.payStatus == null || order.payStatus == 0" class="not-payment">未付款</span>
                                                <span ng-show="order.payStatus == 1" class="payment">已完成</span>
                                            </td>
                                            <td>
                                                <button ng-show="order.payStatus == null || order.payStatus == 0" class="info-btn" ng-click="payment(order.id, $event)">去付款</button>
                                                <br>
                                                <button ng-show="order.payStatus == null || order.payStatus == 0" class="gray-btn" ng-click="deleteOrder(order.id, $event)">删除订单</button>
                                            </td>
                                        </tr>
                                    </tbody>
                                    <tfoot>
                                        <tr ng-show="orderList.length == 0 || orderList == null">
                                            <td class="not-data" colspan="99">暂无数据</td>
                                        </tr>
                                    </tfoot>
                                </table>
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


<div class="popover-shade"></div>
<div class="modal-this allotModal" id="payModal">
    <div class="modal-title">
        选择支付方式
        <span class="modal-close-btn" ng-click="closePayModal()">关闭</span>
    </div>
    <div class="modal-context">
        <div class="row" id="payWay">
            <div class="col-xs-6 text-align-center">
                <div class="wechat-icon" ng-click="wechatPayment()"></div>
                <div class="payment-font">微信</div>
            </div>
            <div class="col-xs-6 text-align-center">
                <div class="alipay-icon" ng-click="aliPayment()"></div>
                <div class="payment-font">支付宝</div>
            </div>
        </div>
        <div id="qrcode" class="qrcode"></div>
        <div class="qrcode-hint">微信扫描二维码支付</div>
    </div>
</div>

<!-- 支付宝支付提交 -->
<form method="post" id="payForm" action="<%=request.getContextPath()%>/aliPay/pcSign">
    <input type="hidden" name="orderId" value="{{orderId}}">
</form>

<%@include file="../common/bottom.jsp" %>
<%@include file="../common/js.jsp" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/jquery.qrcode.min.js"></script>

<script>
    $("body").append(config.showShade("正在加载,请稍等..."));

    var webApp = angular.module('aiMaiApp', []);
    webApp.controller("controller", function($scope, $timeout) {
        $scope.userInfo = config.aiMaiUser();
        $scope.ipImg = config.ipImg;
        $scope.payStatus = null;
        $scope.orderList = null;
        $scope.isFirst = false;
        $scope.orderId = null; //存放支付订单ID

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
                        config.log(obj);
                        config.log(first);
                        if(!first){
                            $scope.getDataList(obj.curr, 30, $scope.payStatus);
                        }
                    }
                });
                form.render();
            }
        });

        $scope.getDataList = function (pageNO, pageSize, payStatus) {
            $scope.parameter = {
                pageNO : pageNO,
                pageSize : pageSize,
                payStatus : payStatus
            }
            config.ajaxRequestData(false, "order/queryOrder", $scope.parameter, function (result) {
                if (!$scope.isFirst) {
                    $scope.orderList = result.data.dataList;
                    $scope.isFirst = true;
                    $scope.changePage(result.data.count);
                }
                else {
                    $timeout(function () {
                        $scope.orderList = result.data.dataList;
                    });
                }
                //$scope.changePage(result.data.count);
            });
        }
        //默认调用
        $scope.getDataList(1, 30, $scope.payStatus);

        $(".layui-tab-title li").click(function () {
            if ($(this).index() == 0) $scope.payStatus = null;
            if ($(this).index() == 1) $scope.payStatus = 0;
            if ($(this).index() == 2) $scope.payStatus = 1;
            $scope.getDataList(1, 30, $scope.payStatus);
        });

        //付款
        $scope.payment = function (orderId, event) {
            $scope.openPayModal();
            $timeout(function () {
                $scope.orderId = orderId;
            });
        }

        //微信支付
        $scope.wechatPayment = function () {
            config.ajaxRequestData(false, "wxPay/sign", {orderId: $scope.orderId}, function (result) {
                $scope.timingClosure();
                $("#payWay").hide();
                $(".qrcode-hint").show();
                $("#qrcode").show();
                var qrcode = new QRCode(document.getElementById("qrcode"), {
                    width : 120,
                    height : 120
                });
                qrcode.makeCode(result.data.code_url);
                $scope.interval = setInterval($scope.getPayStatus, 2000);
            });
        }

        //支付宝支付
        $scope.aliPayment = function () {
            if ($scope.orderId == 0) {
                layer.msg("支付失败.");
                return false;
            }
            $("#payForm").submit();
        }

        //获取支付状态
        $scope.getPayStatus = function () {
            config.ajaxRequestData(false, "wxPay/checkOrder", {orderId: $scope.orderId}, function (result) {
                if (result.data == 1) { //表示支付了
                    location.reload();
                }
            });
        }

        //定时关闭二维码
        $scope.timingClosure = function () {
            setTimeout(function () {
                $scope.closePayModal();
                $("#payWay").show();
                $(".qrcode-hint").hide();
                $("#qrcode").hide();
                clearInterval($scope.interval);
            }, 50000);
        }

        //删除订单
        $scope.deleteOrder = function (orderId, event) {
            var index = layer.confirm('确认删除该订单？', {
                btn: ['确定','取消']
                ,closeBtn: 0
                ,anim: 1
                ,title: "温馨提示"
            }, function(){
                config.ajaxRequestData(false, "order/delOrder", {orderId : orderId}, function () {
                    $(event.target).parent().parent().fadeOut("slow");
                    $scope.getDataList(1, 30, $scope.payStatus);
                 });
                layer.close(index);
            }, function(){

            });
        }

        //课程购买详情
        $scope.courseDetail = function (curriculumId) {
            //sessionStorage.setItem("curriculumId", curriculumId);
            if ($scope.userInfo.roleId == 4) {
                location.href = config.ip + "page/person/myCourse";
            }
            else {
                location.href = config.ip + "page/person/myCourseCompany";
            }
        }

        //打开弹窗
        $scope.openPayModal = function () {
            $(".popover-shade").fadeIn();
            $("#payModal").slideDown(200);
        }
        //关闭弹窗
        $scope.closePayModal = function () {
            $(".popover-shade").fadeOut();
            $("#payModal").slideUp(200);
            $("#payWay").show();
            $(".qrcode-hint").hide();
            $("#qrcode").hide();
            clearInterval($scope.interval);
        }

        config.hideShade();

    });


</script>
</body>
</html>

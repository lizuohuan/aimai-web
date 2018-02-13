<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>查找课程</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/index.css"/>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/course/course.css"/>
    <style>
        .ctabBox>div.act{
            height: 160px;
        }
    </style>
</head>
<body ng-app="aiMaiApp" ng-controller="controller" ng-cloak>
<%@include file="../common/top.jsp" %>
<div class="ai-content">
    <div class="container">
        <div class="position">
            <span><a href="<%=request.getContextPath()%>/page/index">首页</a></span><span>></span><span><a href="#">课程</a></span><span>></span><span>课程查找</span>
        </div>
    </div>
    <div class="topSellect container">
        <div class="category clearfix">
            <span class="sKey">类别：</span>
            <ul class="sValue clearfix courseType">
                <li class="act" typeId="2"><a href="javascript:void(0)">全员培训</a></li>
                <li typeId="1"><a href="javascript:void(0)">三项培训</a></li>
            </ul>
        </div>
        <div class="industry clearfix">
            <span class="sKey">行业：</span>
            <ul class="sValue clearfix tradeType">
                <li tradeId="0"><a href="javascript:void(0)">全部</a></li>
                <li ng-repeat="trade in tradeList" tradeId="{{trade.id}}" ng-class="{true: 'act',false: ''}[trade.id == tradeId]"><a href="javascript:void(0)">{{trade.tradeName}}</a></li>
            </ul>
        </div>
    </div>
    <!-- 课程列表 -->
    <div class="courseList courseIndex">
        <div class="container max-not-data" ng-show="curriculumList == null || curriculumList.length == 0">暂无课程</div>
        <div class="container" ng-repeat="curriculum in curriculumList">
            <div class="courseBox clearfix ovh">
                <div class="courseFace">
                    <a href="javascript:void(0)" ng-click="courseDetail(curriculum.id)">
                        <i class="course-cover" style="background: url('{{ipImg}}{{curriculum.cover}}')"></i>
                    </a>
                </div>
                <div class="courseInfo">
                    <div class="mainName rel">
                        <h4>{{curriculum.curriculumName}}</h4>
                        <p><a>{{curriculum.videoNum}}</a>个视频课</p>
                        <div class="buyNow">
                            <span class="courseMoney">￥{{curriculum.price | number : 2}}</span>
                            <button ng-if="curriculum.price <= 0 && userInfo.roleId != 2" ng-click="purchase(curriculum.id, curriculum.price)" class="buyBtn">免费购买</button>
                            <button ng-if="curriculum.price > 0 && userInfo.roleId != 2" ng-click="purchase(curriculum.id, curriculum.price)" class="buyBtn">立即购买</button>
                        </div>
                    </div>
                    <div class="ctab clearfix">
                        <div>
                            <i class="icon-inro"></i><span>介绍</span>
                        </div>
                        <div>
                            <i class="icon-list"></i><span>目录</span>
                        </div>
                        <div ng-click="clickEvaluate(curriculum.id, $event, 0)">
                            <i class="icon-comment" ng-click="clickEvaluate(curriculum.id, $event, 1)"></i>
                            <span ng-click="clickEvaluate(curriculum.id, $event, 1)">评论</span>
                        </div>
                    </div>
                    <div class="ctabBox rel">
                        <div class="courseIntro">
                            <h5>课程介绍</h5>
                            <div ng-bind-html="curriculum.curriculumDescribe | trustHtml"></div>
                            <p style="margin-bottom: 15px;">
                                <h5>讲师名称</h5>
                                <div ng-bind-html="curriculum.teacherName | trustHtml"></div>
                            </p>
                            <p style="margin-bottom: 15px;">
                                <h5>讲师介绍</h5>
                                <div ng-bind-html="curriculum.teacherIntroduce | trustHtml"></div>
                            </p>
                            <p>
                                <h5>适用人群</h5>
                                <div ng-bind-html="curriculum.applyPerson | trustHtml"></div>
                            </p>
                        </div>
                        <div class="courseMenu">
                            <ul>
                                <li ng-repeat="course in curriculum.courseWares">
                                    <a ng-repeat="video in course.videos">
                                        {{course.courseWareName}}：{{video.name}}
                                        <span>{{video.lowDefinitionSeconds}}</span>
                                    </a>
                                </li>
                            </ul>
                            <div class="min-not-data" ng-show="curriculum.courseWares == null || curriculum.courseWares.length == 0">暂无目录</div>
                        </div>
                        <div class="courseComment">

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 点击加载更多 -->
    <div class="container loading-course" ng-show="curriculumList.length > 0">
        <button class="min-blue-button" id="clickMore">加载更多</button>
        <div class="loader" id="loader">
            <div class="loader-inner ball-clip-rotate-multiple">
                <div></div>
                <div></div>
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

<!-- 数量弹窗 -->
<div class="modal-this numberModal" id="numberModal">
    <div class="modal-title">
        请输入购买数量
        <span class="modal-close-btn" ng-click="closeNumberModal()">关闭</span>
        <span class="modal-ok-btn" ng-click="confirmNumber()">确定</span>
    </div>
    <div class="modal-context">
        <div class="number-context">
            <input class="number-btn" type="image" src="<%=request.getContextPath()%>/resources/img/minus-number.png" ng-click="minusNum()">
            <input type="text" ng-model="number" placeholder="请输入您需要购买的数量" class="number" onkeyup="(this.v=function(){this.value=this.value.replace(/[^0-9-]+/,'');}).call(this)" onblur="this.v();" maxlength="5">
            <input class="number-btn" type="image" src="<%=request.getContextPath()%>/resources/img/add-number.png" ng-click="plusNum()">
        </div>
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
        $scope.tradeList = null; //行业列表
        $scope.curriculumList = null; //课程列表
        $scope.isFirst = false; //是否加载过第一次了
        $scope.curriculumTypeId = null; //阶段ID
        if (config.getUrlParam("notTrade") == 1) {sessionStorage.removeItem("tradeId")}
        $scope.tradeId = sessionStorage.getItem("tradeId"); //行业ID
        $scope.orderId = 0; //存放下单订单ID
        $scope.curriculumId = 0;
        $scope.price = 0;
        $scope.interval = null; //定时器ID
        $scope.timeout = null; //定时器ID
        $scope.searchParams = sessionStorage.getItem("searchParams");
        $("#searchParams").val($scope.searchParams);
        $scope.pageSize = 20;
        $scope.addSize = 20;

        //获取行业
        config.ajaxRequestData(false, "trade/queryTrade", {}, function (result) {
            $scope.tradeList = result.data;
        });

        //课程列表
        $scope.getDataList = function (pageNO, pageSize, tradeId, curriculumTypeId, searchParams) {
            $scope.parameter = {
                pageNO : pageNO,
                pageSize : pageSize,
                tradeId : tradeId,
                curriculumTypeId : curriculumTypeId,
                searchParams : searchParams
            }
            config.ajaxRequestData(false, "curriculum/queryCurriculumByType", $scope.parameter, function (result) {
                if (!$scope.isFirst) {
                    $scope.curriculumList = result.data.dataList;
                    if ($scope.curriculumList != null) {
                        for (var k = 0; k < $scope.curriculumList.length; k++) {
                            var obj = $scope.curriculumList[k];
                            for (var i = 0; i < obj.courseWares.length; i++) {
                                var courseWares = obj.courseWares[i];
                                for (var j = 0; j < courseWares.videos.length; j++) {
                                    var video = courseWares.videos[j];
                                    video.highDefinitionSeconds = config.getFormatTime(video.highDefinitionSeconds);
                                    video.lowDefinitionSeconds = config.getFormatTime(video.lowDefinitionSeconds);
                                }
                            }
                        }
                    }
                    $scope.isFirst = true;
                }
                else {
                    $timeout(function () {
                        $scope.curriculumList = result.data.dataList;
                        if ($scope.curriculumList != null) {
                            for (var k = 0; k < $scope.curriculumList.length; k++) {
                                var obj = $scope.curriculumList[k];
                                for (var i = 0; i < obj.courseWares.length; i++) {
                                    var courseWares = obj.courseWares[i];
                                    for (var j = 0; j < courseWares.videos.length; j++) {
                                        var video = courseWares.videos[j];
                                        video.highDefinitionSeconds = config.getFormatTime(video.highDefinitionSeconds);
                                        video.lowDefinitionSeconds = config.getFormatTime(video.lowDefinitionSeconds);
                                        $("#loader").hide();
                                        $("#clickMore").show();
                                    }
                                }
                            }
                        }
                        if ($scope.pageSize > result.data.count) {
                            $scope.pageSize = $scope.pageSize - $scope.addSize;
                            $(".loading-course").html("没有更多课程了.");
                        }
                    });
                }
            });
        }

        $scope.getDataList(1, $scope.pageSize, $scope.tradeId, null, $scope.searchParams);

        //详情
        $scope.courseDetail = function (curriculumId) {
            config.ajaxRequestData(false, "curriculum/isBuy", {curriculumId : curriculumId}, function (result) {
                if (result.data == 0) {
                    sessionStorage.setItem("curriculumId", curriculumId);
                    window.open(config.ip + "page/course/courseDetail");
                }
                else if (result.data == -1) {
                    if ($scope.userInfo.roleId == 4) {
                        layer.alert('您已经购买过该课程，可以直接观看', {
                            title: "温馨提示",
                            skin: 'layui-layer-molv' //样式类名
                            ,closeBtn: 0
                            ,anim: 3 //动画类型
                        }, function(){
                            location.href = config.ip + "page/person/myCourse";
                        });
                    }
                    else {
                        window.open(config.ip + "page/course/courseDetail");
                    }
                }
                else if (result.data == -2) {
                    layer.alert('该课程订单已存在，请直接付款', {
                        title: "温馨提示",
                        skin: 'layui-layer-molv' //样式类名
                        ,closeBtn: 0
                        ,anim: 3 //动画类型
                    }, function(){
                        location.href = config.ip + "page/person/myOrder";
                    });
                }
            });
        }

        $scope.number = 0;
        //减
        $scope.minusNum = function () {
            if (Number($scope.number) <= 0) {
                $scope.number = 0;
            }
            else {
                $scope.number = Number($scope.number) - 1;
            }
        }
        //加
        $scope.plusNum = function () {
            $scope.number = Number($scope.number) + 1;
        }
        //购买
        $scope.purchase = function (curriculumId, price) {
            $scope.curriculumId = curriculumId;
            $scope.price = price;
            if ($scope.userInfo == null) {
                location.href = config.ip + "page/login";
                return false;
            }
            if ($scope.orderId != 0) {
                $scope.openPayModal();
                return false;
            }
            config.ajaxRequestData(false, "curriculum/isBuy", {curriculumId : curriculumId}, function (result) {
                if (result.data == 0) {
                    if ($scope.userInfo.roleId == 3 || $scope.userInfo.roleId == 5) {
                        $scope.number = 0;
                        $scope.openNumberModal();
                    }
                    else {
                        //创建订单
                        var parameter = {
                            curriculumId : $scope.curriculumId,
                            number : 1
                        }
                        config.ajaxRequestData(false, "order/addOrder", parameter, function (result) {
                            if (price <= 0) {
                                if ($scope.userInfo.roleId == 4) {
                                    location.href = config.ip + "page/person/myCourse";
                                }
                                else {
                                    location.href = config.ip + "page/person/myCourseCompany";
                                }
                            }
                            else {
                                $scope.openPayModal();
                                $timeout(function () {
                                    $scope.orderId = result.data;
                                });
                            }
                        });
                    }
                }
                else if (result.data == -1) {
                    if ($scope.userInfo.roleId == 4) {
                        layer.alert('您已经购买过该课程，可以直接观看', {
                            title: "温馨提示",
                            skin: 'layui-layer-molv' //样式类名
                            ,closeBtn: 0
                            ,anim: 3 //动画类型
                        }, function(){
                            location.href = config.ip + "page/person/myCourse";
                        });
                    }
                    else {
                        $scope.number = 0;
                        $scope.openNumberModal();
                    }
                }
                else if (result.data == -2) {
                    layer.alert('该课程订单已存在，请直接付款', {
                        title: "温馨提示",
                        skin: 'layui-layer-molv' //样式类名
                        ,closeBtn: 0
                        ,anim: 3 //动画类型
                    }, function(){
                        location.href = config.ip + "page/person/myOrder";
                    });
                }
            });
        }

        //数量弹窗点击确认
        $scope.confirmNumber = function () {
            if ($scope.number == 0 || $scope.number == "") {
                layer.msg("请输入购买数量.");
                return false;
            }
            else if (!config.isNumber.test($scope.number)) {
                layer.msg("请输入一个整数.");
                return false;
            }
            else {
                //创建订单
                var parameter = {
                    curriculumId : $scope.curriculumId,
                    number : $scope.number
                }
                config.ajaxRequestData(false, "order/addOrder", parameter, function (result) {
                    if ($scope.price <= 0) {
                        if ($scope.userInfo.roleId == 4) {
                            location.href = config.ip + "page/person/myCourse";
                        }
                        else {
                            location.href = config.ip + "page/person/myCourseCompany";
                        }
                    }
                    else {
                        $scope.closeNumberModal();
                        $scope.openPayModal();
                        $timeout(function () {
                            $scope.orderId = result.data;
                        });
                    }
                });
            }
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
                    sessionStorage.setItem("isSucceed", 1);
                    location.href = config.ip + "page/course/paymentResult"
                }
            });
        }


        //定时关闭二维码
        $scope.timingClosure = function () {
            $scope.timeout = setTimeout(function () {
                $scope.closePayModal();
                $("#payWay").show();
                $(".qrcode-hint").hide();
                $("#qrcode").html("");
            }, 50000);
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
            $("#qrcode").html("");
            clearInterval($scope.interval);
            clearTimeout($scope.timeout);
        }

        //打开弹窗
        $scope.openNumberModal = function () {
            $(".popover-shade").fadeIn();
            $("#numberModal").slideDown(200);
        }
        //关闭弹窗
        $scope.closeNumberModal = function () {
            $(".popover-shade").fadeOut();
            $("#numberModal").slideUp(200);
        }

        //评论列表
        $scope.queryEvaluate = function (pageNO, pageSize, curriculumId, element) {
            $scope.parameter = {
                pageNO: pageNO,
                pageSize: pageSize,
                curriculumId : curriculumId
            }
            config.ajaxRequestData(false, "evaluate/queryEvaluate", $scope.parameter, function (result) {
                var html = "<ul>";
                for (var i = 0; i < result.data.length; i++) {
                    var obj = result.data[i];
                    obj.avatar = obj.avatar == null ? config.ip + "resources/img/default-head.png" : config.ipImg + obj.avatar;
                    var dateTime = config.getCountTime(obj.createTime, obj.timeStamp);
                    var userName = obj.userName;
                    var startName = "";
                    var endName = "";
                    if (userName.length > 2) {
                        startName = userName.substring(0, 1);
                        endName = userName.substring(userName.length - 1, userName.length);
                    }
                    else {
                        startName = userName.substring(0, 1);
                    }
                    userName = startName + "*" + endName;
                    html += '<li ng-repeat="evaluate in evaluateList">' +
                            '   <div class="user">' +
                            '       <i style="background: url(' + obj.avatar + ')"></i>' +
                            '       <span>' + userName + '</span>' +
                            '   </div>' +
                            '   <div class="userComment">' +
                            '       <span>' + dateTime + '</span>' +
                            '       <p>' + obj.content + '</p>' +
                            '    </div>' +
                            '</li>';
                }
                html += "</ul>";
                if (result.data == null || result.data.length == 0) {
                    html = '<div class="min-not-data">暂无评论</div>';
                }
                $(element).html(html);
            });
        }

        //单击获取评论
        $scope.clickEvaluate = function (curriculumId, event, type) {
            var $obj = event.target;
            if ($($obj).attr("isClick") != 1){
                var obj = null;
                if (type == 0) {
                    obj = $($obj).parent().parent().find(".courseComment");
                }
                else {
                    obj = $($obj).parent().parent().parent().find(".courseComment");
                }
                $scope.queryEvaluate(1, 10, curriculumId, obj);
                $($obj).attr("isClick", 1);
            }
        }

        $(function () {
            $(".courseType li").each(function () {
                $(this).click(function () {
                    $(".courseType li").removeClass("act");
                    $(this).addClass("act");
                    $scope.curriculumTypeId = $(this).attr("typeId");
                    $scope.getDataList(1, 10, $scope.tradeId, $scope.curriculumTypeId);
                });
            });

            $(".tradeType li").each(function () {
                $(this).click(function () {
                    $(".tradeType li").removeClass("act");
                    $(this).addClass("act");
                    $scope.tradeId = $(this).attr("tradeId");
                    if (Number($(this).attr("tradeId")) == 0) {
                        $scope.tradeId = null;
                    }
                    $scope.getDataList(1, 10, $scope.tradeId, $scope.curriculumTypeId);
                });
            });

        })

        $("#clickMore").click(function () {
            $("#clickMore").hide();
            $("#loader").show();
            $scope.pageSize = $scope.pageSize + $scope.addSize;
            $scope.getDataList(1, $scope.pageSize, $scope.tradeId, null, $scope.searchParams);
        });

        config.hideShade();

    });
    //富文本过滤器
    webApp.filter('trustHtml', ['$sce',function($sce) {
        return function(val) {
            return $sce.trustAsHtml(val);
        };
    }]);

    //默认显示第一个tab
    function eachAct(box){
        $(box).each(function(){
            $(this).children().eq(0).addClass("act");
        })
    }
    eachAct('.ctab');
    eachAct('.ctabBox');

    //课程tab切换
    $("body").on("click",".ctab>div",function(){
        $(this).addClass("act").siblings().removeClass("act");
        $(this).parent().next().children().eq($(this).index()).addClass("act").siblings().removeClass("act");
    });


</script>

</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>课程详情</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/index.css"/>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/course/course.css"/>
    <style>
        html,body{background: #FFF;}
        .ctabBox{overflow: inherit}
        .courseDetail .courseBot{margin-bottom: 50px;}
        .bottom-bar{margin-top: 0;}
    </style>
</head>
<body ng-app="aiMaiApp" ng-controller="controller" ng-cloak>
<%@include file="../common/top.jsp" %>
<div class="ai-content">

    <div class="container">
        <div class="position">
            <span><a href="<%=request.getContextPath()%>/page/index">首页</a></span><span>></span><span><a href="javascript:history.back();">课程</a></span><span>></span><span>课程名称</span>
        </div>
    </div>

    <div class="courseDetail">
        <div class="courseDetailBg">
            <div class="container">
                <div class="courseBox clearfix ovh">
                    <div class="courseFace">
                        <a href="javascript:void(0)" ng-click="courseDetail(curriculum.id)"><img src="{{ipImg}}{{curriculum.cover}}" alt="" /></a>
                    </div>
                    <div class="courseInfo">
                        <div class="mainName rel">
                            <h4 class="rel">{{curriculum.curriculumName}}<a ng-show="userInfo.roleId == 4" href="javascript:void(0)" ng-click="collect()" class="courseCollect">收藏</a></h4>
                            <div class="courseTag">
                                <span>{{curriculum.year | date:'yyyy'}}年</span>|<i>{{curriculum.stageName}}</i>
                            </div>
                            <p>
                                <a>{{curriculum.videoNum}}</a>个视频课<span class="courseTime">
                                <img src="<%=request.getContextPath()%>/resources/img/time.png" />{{curriculum.lowSeconds}}</span>
                            </p>
                            <span class="courseMoney">￥{{curriculum.price | number : 2}}</span><br />
                            <button class="buyBtn" ng-hide="userInfo.roleId == 2" ng-if="curriculum.price <= 0" ng-click="purchase()">免费购买</button>
                            <button class="buyBtn" ng-hide="userInfo.roleId == 2" ng-if="curriculum.price > 0" ng-click="purchase()">立即购买</button>

                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="courseDetail">
            <div class="container">
                <div class="layui-tab layui-tab-brief">
                    <ul class="layui-tab-title">
                        <li class="layui-this"><i class="icon-inro"></i>介绍</li>
                        <li><i class="icon-list"></i>目录</li>
                        <li><i class="icon-comment"></i>评论</li>
                    </ul>
                    <div class="layui-tab-content">
                        <div class="layui-tab-item layui-show">
                            <div class="courseIntro act" style="margin-bottom: 15px;">
                                <h5>课程介绍</h5>
                                <div ng-bind-html="curriculum.curriculumDescribe | trustHtml"></div>
                            </div>
                            <div class="courseIntro act" style="margin-bottom: 15px;">
                                <h5>讲师名称</h5>
                                <div ng-bind-html="curriculum.teacherName | trustHtml"></div>
                            </div>
                            <div class="courseIntro act" style="margin-bottom: 15px;">
                                <h5>讲师介绍</h5>
                                <div ng-bind-html="curriculum.teacherIntroduce | trustHtml"></div>
                            </div>
                            <div class="courseIntro act">
                                <h5>适用人群</h5>
                                <div ng-bind-html="curriculum.applyPerson | trustHtml"></div>
                            </div>
                        </div>
                        <div class="layui-tab-item">
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
                        </div>
                        <div class="layui-tab-item not-padding">
                            <div id="commentList" class="courseComment">
                                <ul>
                                    <li ng-repeat="evaluate in evaluateList" ng-cloak>
                                        <div class="user">
                                            <i>
                                                <img ng-show="evaluate.avatar == null" src="<%=request.getContextPath()%>/resources/img/default-head.png">
                                                <img ng-show="evaluate.avatar != null" src="{{ipImg}}{{evaluate.avatar}}">
                                            </i>
                                            <span ng-if="evaluate.userName.length < 2">{{evaluate.userName | limitTo : 1}}*</span>
                                            <span ng-if="evaluate.userName.length > 2">{{evaluate.userName | limitTo : 1}}*{{evaluate.userName | limitTo : - 1}}</span>
                                        </div>
                                        <div class="userComment">
                                            <span>{{evaluate.createTime | date:'yyyy-MM-dd HH:mm:ss'}}前</span>
                                            <p>{{evaluate.content}}</p>
                                        </div>
                                    </li>
                                </ul>
                                <div ng-show="evaluateList.length == 0" class="min-not-data">暂无评论</div>
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
        $scope.curriculumId = sessionStorage.getItem("curriculumId");
        $scope.curriculum = null;
        $scope.evaluateList = null; //评论列表
        $scope.orderId = 0; //存放下单订单ID
        $scope.interval = null; //定时器ID
        $scope.timeout = null; //定时器ID
        config.ajaxRequestData(false, "curriculum/queryCurriculumById", {curriculumId : $scope.curriculumId}, function (result) {
            $scope.curriculum = result.data;
            $scope.curriculum.lowSeconds = config.getFormat($scope.curriculum.lowSeconds);
            for (var i = 0; i < $scope.curriculum.courseWares.length; i++) {
                var courseWares = $scope.curriculum.courseWares[i];
                for (var j = 0; j < courseWares.videos.length; j++) {
                    var video = courseWares.videos[j];
                    video.highDefinitionSeconds = config.getFormatTime(video.highDefinitionSeconds);
                    video.lowDefinitionSeconds = config.getFormatTime(video.lowDefinitionSeconds);
                }
            }
        });

        //评论列表
        $scope.getDataList = function (pageNO, pageSize) {
            $scope.parameter = {
                pageNO: pageNO,
                pageSize: pageSize,
                curriculumId : $scope.curriculumId
            }
            config.ajaxRequestData(false, "evaluate/queryEvaluate", $scope.parameter, function (result) {
                $scope.evaluateList = result.data;
            });
        }
        $scope.getDataList(1, 10);

        //收藏
        $scope.collect = function () {
            var parameter = {
                type : 1,
                targetId : $scope.curriculumId
            }
            config.ajaxRequestData(false, "collect/addCollect", parameter, function (result) {
                layer.msg("收藏成功.");
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
        $scope.purchase = function () {
            if ($scope.userInfo == null) {
                location.href = config.ip + "page/login";
                return false;
            }

            if ($scope.orderId != 0) {
                $scope.openPayModal();
                return false;
            }
            config.ajaxRequestData(false, "curriculum/isBuy", {curriculumId : $scope.curriculumId}, function (result) {
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
                        if ($scope.orderId == 0) {
                            config.ajaxRequestData(false, "order/addOrder", parameter, function (result) {
                                if ($scope.curriculum.price <= 0) {
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
                if ($scope.orderId == 0) {
                    config.ajaxRequestData(false, "order/addOrder", parameter, function (result) {
                        if ($scope.curriculum.price <= 0) {
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
        }

        $scope.isBuy = function (curriculumId) {
            var status = 0;
            config.ajaxRequestData(false, "curriculum/isBuy", {curriculumId : curriculumId}, function (result) {
                status = result.data;
            });
            return status;
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
    $(".courseCollect").click(function(){
        $(this).addClass("act");
    });

</script>
</body>
</html>

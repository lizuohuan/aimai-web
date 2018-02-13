<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>注册</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/mui.min.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/login/registerPhone.css">
    <style>
        body,html{background: #F6F9FE}
    </style>
</head>
<body ng-app="aiMaiApp" ng-controller="controller" ng-cloak>

<div class="top">
    <div class="container">
        <div class="col-xs-12">
            <a href="<%=request.getContextPath()%>/page/index">
                <img id="companyLogo" class="logo" src="<%=request.getContextPath()%>/resources/img/logo2.png">
            </a>
            <a class="go-home" href="<%=request.getContextPath()%>/page/index">
                <span>去首页</span>
                <i></i>
            </a>
        </div>
    </div>
</div>
<div class="ai-content">

    <div class="container register-container">
        <form name="formData" novalidate>
            <div class="register-bar">
                <h2>注册</h2>
                <div class="row">
                    <div class="col-xs-3">
                        注册身份
                    </div>
                    <div class="col-xs-3">
                        <div class="mui-input-row mui-radio">
                            <label>
                                <input name="type" value="4" type="radio" checked>
                                个人
                            </label>
                        </div>
                    </div>
                    <div class="col-xs-3">
                        <div class="mui-input-row mui-radio">
                            <label>
                                <input name="type" value="3" type="radio" >
                                公司
                            </label>
                        </div>
                    </div>
                    <div class="col-xs-3">
                        <div class="mui-input-row mui-radio">
                            <label>
                                <input name="type" value="2" type="radio" >
                                政府
                            </label>
                        </div>
                    </div>
                </div>

                <div class="row position">
                    <div class="label-font">手机号</div>
                    <div class="col-xs-12">
                        <input type="text" class="input" name="phone" ng-model="user.phone" placeholder="请输入注册手机号"
                               autocomplete="off"
                               required
                               ng-pattern="/^(((13[0-9]{1})|(18[0-9]{1})|(17[6-9]{1})|(15[0-9]{1}))+\d{8})$/"
                               ng-blur
                               maxlength="11"
                        >
                    </div>
                    <%--<div class="col-xs-12 check-error" ng-show="formData.phone.$dirty && formData.phone.$invalid">
                        <span ng-show="formData.phone.$error.required">手机号不能为空!</span>
                        <span ng-show="formData.phone.$error.pattern">请输入11位正确的手机号码!</span>
                    </div>--%>
                </div>

                <div class="row position">
                    <div class="label-font">验证码</div>
                    <div class="col-xs-7">
                        <input type="text" class="input" name="code" ng-model="user.code" autocomplete="off" placeholder="请输入验证码" maxlength="4" required ng-blur>
                    </div>
                    <div class="col-xs-5">
                        <button class="blue-button qr-btn" ng-click="sendCode()">获取验证码</button>
                    </div>
                    <%--<div class="col-xs-12 check-error" ng-show="formData.code.$dirty && formData.code.$invalid">
                        <span ng-show="qrCode == null">请先获取验证码!</span>
                        <span ng-show="qrCode != null">
                            <span ng-show="formData.code.$error.required">验证码不能为空!</span>
                            <span ng-show="formData.code != qrCode">验证码错误,请重新输入!</span>
                        </span>
                    </div>--%>
                </div>

                <div class="row">
                    <div class="label-font">新密码</div>
                    <div class="col-xs-12">
                        <input type="password" class="input" name="password" ng-model="user.password"
                               autocomplete="off"
                               placeholder="请输入新密码（至少6位）"
                               maxlength="32"
                        >
                    </div>
                    <%--<div class="col-xs-12 check-error" style="position: relative;bottom: 0" ng-show="formData.password.$dirty && formData.password.$invalid">
                        <span ng-show="formData.password.$error.required">密码不能为空!</span>
                        <span ng-show="formData.password.$error.minlength || formData.password.$error.maxlength">请输入(6-20)位的密码!</span>
                    </div>--%>
                    <div class="col-xs-12" style="margin-top: 5px">
                        <input type="password" class="input" name="password2" ng-model="user.password2"
                               autocomplete="off"
                               placeholder="请输入一样的密码"
                               maxlength="32"
                        >
                    </div>
                    <%--<div class="col-xs-12 check-error" style="position: relative;bottom: 0" ng-show="formData.password2.$dirty && formData.password2.$invalid">
                        <span ng-show="user.password != password2">两次密码输入不一致!</span>
                    </div>--%>
                </div>

                <div class="row">
                    <div class="col-xs-12">
                        <button class="blue-button" ng-click="submit()">同意协议,去完善资料</button>
                    </div>
                    <div class="col-xs-12" style="margin: 10px 0 50px 0;text-align: center">
                        <a href="javascript: openMask()" class="agreement">《使用协议与条款》</a>
                    </div>
                </div>

            </div>
        </form>
    </div>
</div>


<!-- 注册协议 -->
<div class="whiteMask">
    <div class="modal-this" id="agreement" style="width: 600px">
        <div class="modal-title">
            {{content.name}}
            <span class="modal-close-btn" onclick="closeMask()">关闭</span>
        </div>
        <div class="row modal-context">
            <div class="col-xs-12" style="height: 400px; overflow-y: auto;">
                <div ng-bind-html="content.content | trustHtml"></div>
            </div>
            <div class="col-xs-12" style="text-align: center;padding-top: 20px;">
                <button class="blue-button" onclick="closeMask()" style="width: 50%;">同意并注册</button>
            </div>
        </div>
    </div>
</div>

<%@include file="../common/bottom.jsp" %>

<%@include file="../common/js.jsp" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/jQuery.md5.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/mui.min.js"></script>
<script>

    var webApp = angular.module('aiMaiApp', []);
    webApp.controller("controller", function($scope) {
        $scope.user = {};
        $scope.checkPhone = null; //存放已发送验证的手机号，避免篡改
        $scope.qrCode = null; //存放验证码
        $scope.isPhone = false; //存放手机号是否存在状态
        $scope.consent = function () {
            config.log($scope.phone);
            location.href = config.ip + "page/registerData";
        }

        config.ajaxRequestData(false, "content/info", {id : 6}, function (result) {
            $scope.content = result.data;
        });

        $scope.submit = function () {
            config.log($scope.user);
            if ($scope.user.phone == null || $scope.user.phone == "") {
                layer.msg("请输入手机号", {icon: 2,anim: 6});
                $("input[name='phone']").focus();
                return false;
            }
            else if (!config.isMobile.test($scope.user.phone)) {
                layer.msg("请输入正确的手机号", {icon: 2,anim: 6});
                $("input[name='phone']").focus();
                return false;
            }
            else if ($scope.qrCode == null) {
                layer.msg("请输入获取验证码", {icon: 2,anim: 6});
                return false;
            }
            else if ($scope.user.code == null || $scope.user.code == "") {
                layer.msg("请输入验证码", {icon: 2,anim: 6});
                $("input[name='code']").focus();
                return false;
            }
            else if ($scope.user.code != $scope.qrCode) {
                layer.msg("验证码错误,请重新输入", {icon: 2,anim: 6});
                $("input[name='code']").focus();
                return false;
            }
            else if ($scope.user.password == null || $scope.user.password == "") {
                layer.msg("请输入密码", {icon: 2,anim: 6});
                $("input[name='password']").focus();
                return false;
            }
            else if ($scope.user.password.length < 6 || $scope.user.password.length > 32) {
                layer.msg("请输入6-32位的密码", {icon: 2,anim: 6});
                $("input[name='password']").focus();
                return false;
            }
            else if ($scope.user.password2 == null || $scope.user.password2 == "") {
                layer.msg("请再次输入密码", {icon: 2,anim: 6});
                $("input[name='password2']").focus();
                return false;
            }
            else if ($scope.user.password != $scope.user.password2) {
                layer.msg("两次密码不一致", {icon: 2,anim: 6});
                $("input[name='password']").focus();
                return false;
            }
            else if($scope.checkPhone != $scope.user.phone) {
                layer.msg("您的手机号与验证码不匹配", {icon: 2,anim: 6});
                return false;
            }

            if ($scope.isPhone) {
                delete $scope.user.code;
                delete $scope.user.password2;
                $scope.user.password = $.md5($scope.user.password);
                $scope.user.roleId = $("input[type='radio']:checked").val();
                sessionStorage.setItem("userInfo", JSON.stringify($scope.user));
                location.href = config.ip + "page/registerData";
            }
        }

        //获取验证码
        $scope.sendCode = function() {
            if ($scope.user.phone == null || $scope.user.phone == "") {
                layer.msg("请输入手机号", {icon: 2,anim: 6});
                $("input[name='phone']").focus();
                return false;
            }
            else if (!config.isMobile.test($scope.user.phone)) {
                layer.msg("请输入正确的手机号", {icon: 2,anim: 6});
                $("input[name='phone']").focus();
                return false;
            }
            $scope.checkPhone = $scope.user.phone;
            config.ajaxRequestData("false", "user/sendMessageRegister", {phone: $scope.checkPhone}, function (result) {
                if (config.isDebug) {
                    layer.msg("验证码：" + result.data);
                }
                var count = 60;
                var resend;
                resend = setInterval(function() {
                    count--;
                    if(count > 0) {
                        $(".qr-btn").html(count + '秒后可重新获取').attr('disabled', true).css('cursor', 'not-allowed').css("fontSize", "12px");
                    } else {
                        clearInterval(resend);
                        $(".qr-btn").html("获取验证码").removeClass('disabled').removeAttr('disabled style').css("fontSize", "16px");
                    }
                }, 1000);
                $scope.qrCode = result.data;
                $scope.isPhone = true;
            });
        }
    });
    //富文本过滤器
    webApp.filter('trustHtml', ['$sce',function($sce) {
        return function(val) {
            return $sce.trustAsHtml(val);
        };
    }]);

    function openMask () {
        $(".whiteMask").fadeIn();
        $("#agreement").slideDown(200);
    }
    function closeMask () {
        $(".whiteMask").fadeOut();
        $("#agreement").slideUp(200);
    }

</script>
</body>
</html>

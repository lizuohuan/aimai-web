<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>登录</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/login/login.css">
</head>
<body ng-app="aiMaiApp" ng-controller="controller" ng-cloak>

<div class="top">
    <div class="container">
        <div class="col-xs-12">
            <a href="<%=request.getContextPath()%>/page/index">
                <img id="companyLogo" class="logo" src="<%=request.getContextPath()%>/resources/img/logo2.png">
            </a>
            <span class="name">欢迎登录</span>
        </div>
    </div>
</div>
<div class="ai-content">

    <div class="login-bar">
        <div class="container login-container">
            <div class="login-bg"></div>
            <form autocomplete="off">
                <div class="login-div">
                    <h2>欢迎使用爱麦培训</h2>
                    <div class="error-bar">
                        <div class="error-hint">
                            <i class="fa fa-minus-circle"></i>
                            <span></span>
                        </div>
                    </div>
                    <div class="input-group">
                        <label>用户名</label>
                        <input type="text" class="login-input" ng-model="phone" autocomplete="off" data-form-pw="1504061835469.479" placeholder="手机号" maxlength="11">
                    </div>
                    <div class="input-group code-group">
                        <label>验证码</label>
                        <input type="text" class="login-input" ng-model="code" autocomplete="off" data-form-pw="1504061835469.479" placeholder="验证码" maxlength="11">
                        <button class="blue-button qr-btn" ng-click="sendCode()">获取验证码</button>
                    </div>
                    <div class="input-group">
                        <label>密码</label>
                        <input type="password" autocomplete="off" style="display: none;">
                        <input type="password" class="login-input" ng-model="password" autocomplete="off" data-form-pw="1504061835469.479" placeholder="输入密码" maxlength="32">
                    </div>
                    <div class="forget-password">
                        <a href="<%=request.getContextPath()%>/page/retrievePassword">忘记密码</a>
                    </div>
                    <div class="button-bar">
                        <button class="blue-button" ng-click="login()">登录</button>
                    </div>
                    <div class="button-bar">
                        <a class="gray-button" href="<%=request.getContextPath()%>/page/registerPhone">立即注册</a>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>


<%@include file="../common/bottom.jsp" %>

<%@include file="../common/js.jsp" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/jQuery.md5.js"></script>
<script>

    var webApp = angular.module('aiMaiApp', []);
    webApp.controller("controller", function($scope) {
        $scope.phone = null;
        $scope.password = null;
        $scope.code = null;
        $scope.isPhone = false;
        $scope.login = function () {
            if ($scope.phone == null || $scope.phone == "") {
                $(".error-hint span").html("请输入手机号");
                $(".error-hint").fadeIn();
                return false;
            }
            if (!config.isMobile.test($scope.phone)) {
                $(".error-hint span").html("请输入正确的手机号");
                $(".error-hint").fadeIn();
                return false;
            }
            if (!$scope.isPhone) {
                $(".error-hint span").html("请获取验证码");
                $(".error-hint").fadeIn();
                return false;
            }
            if ($scope.code == null || $scope.code == "") {
                $(".error-hint span").html("请输入验证码");
                $(".error-hint").fadeIn();
                return false;
            }
            if ($scope.password == null || $scope.password == "") {
                $(".error-hint span").html("请输入密码");
                $(".error-hint").fadeIn();
                return false;
            }
            if ($scope.password.length < 6 || $scope.password.length > 32) {
                $(".error-hint span").html("请输入6-32位的密码");
                $(".error-hint").fadeIn();
                return false;
            }

            $scope.parameter = {
                phone : $scope.phone,
                password : $.md5($scope.password),
                code : $scope.code
            }
            config.ajaxRequestData(false, "user/login", $scope.parameter, function (result) {
                if (sessionStorage.getItem("url") != null && sessionStorage.getItem("url") != "") {
                    sessionStorage.setItem("aiMaiUser", JSON.stringify(result.data));
                    sessionStorage.removeItem("url");
                    window.history.back(); //TODO 此处有bug 导致回调页面出错
                }
                else {
                    var userInfo = result.data;
                    if (userInfo.roleId == 4) {
                        if (userInfo.faceId == null || userInfo.faceId == "") {
                            sessionStorage.setItem("complementUser", JSON.stringify(result.data));
                            location.href = config.ip + "page/complementData";
                        }
                        else {
                            sessionStorage.setItem("aiMaiUser", JSON.stringify(result.data));
                            location.href = config.ip + "page/person/myCourse";
                        }
                    }
                    else if (userInfo.roleId == 3 || userInfo.roleId == 5) {
                        if (userInfo.cityId == null || userInfo.licenseFile == "" || userInfo.licenseFile == null || userInfo.tradeId == null) {
                            sessionStorage.setItem("complementUser", JSON.stringify(result.data));
                            location.href = config.ip + "page/complementData";
                        }
                        else {
                            sessionStorage.setItem("aiMaiUser", JSON.stringify(result.data));
                            location.href = config.ip + "page/person/myCourseCompany";
                        }
                    }
                    else if (userInfo.roleId == 2) {
                        if (userInfo.cityId == null || userInfo.licenseFile == "" || userInfo.licenseFile == null) {
                            sessionStorage.setItem("complementUser", JSON.stringify(result.data));
                            location.href = config.ip + "page/complementData";
                        }else {
                            sessionStorage.setItem("aiMaiUser", JSON.stringify(result.data));
                            location.href = config.ip + "page/person/dataCount";
                        }
                    }
                }
            });
        }

        //获取验证码
        $scope.sendCode = function() {
            if ($scope.phone == null || $scope.phone == "") {
                $(".error-hint span").html("请输入手机号");
                $(".error-hint").fadeIn();
                return false;
            }
            if (!config.isMobile.test($scope.phone)) {
                $(".error-hint span").html("请输入正确的手机号");
                $(".error-hint").fadeIn();
                return false;
            }
            config.ajaxRequestData("false", "user/getLoginCode", {phone: $scope.phone}, function (result) {
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
                $scope.isPhone = true;
                $(".error-hint").fadeOut();
            });
        }

        document.onkeydown = function(event) {
            var code;
            if (!event) {
                event = window.event; //针对ie浏览器
                code = event.keyCode;
                if (code == 13) {
                    $scope.login();
                }
            }
            else {
                code = event.keyCode;
                if (code == 13) {
                    $scope.login();
                }
            }
        };
    });

</script>
</body>
</html>

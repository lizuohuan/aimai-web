<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>补全信息</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/login/registerPhone.css">

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
        <div class="register-bar">
            <form class="layui-form" id="formData">
                <marquee ng-show="userInfo.roleId == 4" direction="left" behavior="scroll" scrollamount="6" scrolldelay="0" loop="-1" hspace="5" vspace="5" style="margin-bottom: 46px;color: red;font-size: 14px;">
                    *请点击“允许”按钮，授权网页访问您的摄像头！
                    若您并未看到任何授权提示，则表示您的浏览器不支持webcam或您的机器没有连接摄像头设备。
                </marquee>
                <h2>补全信息</h2>
                <div class="row" ng-show="userInfo.roleId == 3 || userInfo.roleId == 5">
                    <div class="label-font">行业</div>
                    <div class="col-xs-12">
                        <select name="tradeId" lay-verify="required" lay-search class="company">
                            <option value="">选择行业</option>
                        </select>
                    </div>
                </div>

                <div class="row">
                    <div class="label-font">所在地</div>
                    <div class="col-xs-4">
                        <div class="layui-form-item">
                            <div class="layui-input-inline">
                                <select name="selectProvince" lay-verify="required" lay-search lay-filter="selectProvince">
                                    <option value="">选择省</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col-xs-4">
                        <div class="layui-form-item">
                            <div class="layui-input-inline">
                                <select name="selectCity" lay-search lay-filter="selectCity">
                                    <option value="">选择市</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col-xs-4">
                        <div class="layui-form-item">
                            <div class="layui-input-inline">
                                <select name="selectCounty" lay-search>
                                    <option value="">选择县/区</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-xs-12">
                        <div class="gather-bar">
                            <i ng-show="userInfo.roleId == 2">上传单位介绍信</i>
                            <i ng-show="userInfo.roleId == 3">上传营业执照</i>
                            <i ng-show="userInfo.roleId == 4">人像采集</i>
                            <span ng-show="userInfo.roleId == 4">*实名采集用于您观看视频时进行头像验证,所以必须采集。</span>
                        </div>
                        <div class="preview-head" ng-show="userInfo.roleId == 4">
                            <div class="preview-hint" ng-click="humanFace()">
                                <img class="previewImg" src="<%=request.getContextPath()%>/resources/img/icon_2.png">
                            </div>
                        </div>
                        <div class="preview-head" ng-show="userInfo.roleId != 4">
                            <div class="preview-hint" ng-click="photograph()">
                                <img class="previewImg" src="<%=request.getContextPath()%>/resources/img/add.png">
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-xs-12">
                        <button class="blue-button" lay-submit="" lay-filter="finish">提交</button>
                    </div>
                    <div class="col-xs-12" style="margin: 10px 0 50px 0;text-align: center">
                    </div>
                </div>

                <input name="licenseFile" type="hidden">
                <input name="veriFaceImages" type="hidden">
                <input name="faceId" type="hidden">

            </form>
        </div>
    </div>
</div>


<form id="newUpload" method="post" enctype="multipart/form-data">
    <input id="File" type="file" name="File" accept="image/*" class="hide">
    <input type="hidden" name="type" value="1">
</form>

<div class="photo-shade" id="photoShade">
    <div class="photo-video-bg">
        <i class="fa fa-close" onclick="closePhoto()"></i>
        <div class="human-face">
            <div id="my_camera"></div>
        </div>
        <div class="photo-btn-bar">
            <button class="min-blue-button" onclick="generateImages()">拍照</button>
            &nbsp;&nbsp;&nbsp;
            <button id="affirmBtn" class="min-blue-button yellow-button" ng-click="submitContrast()">确认采集</button>
        </div>
        <img class="previewImage">
    </div>
</div>

<input type="hidden" id="back64Img">
<input type="hidden" id="back64Codes">



<%@include file="../common/bottom.jsp" %>
<%@include file="../common/js.jsp" %>
<script src="<%=request.getContextPath()%>/resources/js/jquery.form.js" type="text/javascript" charset="UTF-8"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/webcamjs/webcam.min.js"></script>



<script>
    var roleId = 0;
    var webApp = angular.module('aiMaiApp', []);
    webApp.controller("controller", function($scope) {
        $scope.userInfo = JSON.parse(sessionStorage.getItem("complementUser"));
        config.log($scope.userInfo);
        if ($scope.userInfo == null) {
            location.href = config.ip + "page/login";
        }
        roleId = $scope.userInfo.roleId;

        //触发文件
        $scope.photograph = function () {
            $('#File').click();
        }

        //人脸采集
        $scope.humanFace = function () {
            initCamera();
            $("#photoShade").show();
        }

        layui.use(['form'], function(){
            var form = layui.form();
            selectProvince(0); //加载省
            tradeList(0); //加载行业
            //自定义验证规则
            form.verify({
                isIdentityCard: function(value) {
                    if(!config.isIdentityCard.test(value)) {
                        return "请输入正确的身份证号";
                    }
                },
            });

            if ($scope.userInfo.roleId == 2) {
                $(".company").removeAttr("lay-verify").removeAttr("name");
                $(".personage").removeAttr("lay-verify").removeAttr("name");
            }
            else if ($scope.userInfo.roleId == 3 || $scope.userInfo.roleId == 5) {
                $(".government").removeAttr("lay-verify").removeAttr("name");
                $(".personage").removeAttr("lay-verify").removeAttr("name");
            }
            else if ($scope.userInfo.roleId == 4) {
                $(".government").removeAttr("lay-verify").removeAttr("name");
                $(".company").removeAttr("lay-verify").removeAttr("name");
            }

            //监听省
            form.on('select(selectProvince)', function(data) {
                $("select[name='selectCity']").html("<option value=\"\">选择市</option>");
                $("select[name='selectCounty']").html("<option value=\"\">选择县/区</option>");
                selectCity(data.value);
                form.render();
            });

            //监听市
            form.on('select(selectCity)', function(data) {
                $("select[name='selectCounty']").html("<option value=\"\">选择县/区</option>");
                selectCounty(data.value);
                form.render();
            });

            form.render();

            //监听提交
            form.on('submit(finish)', function(data) {
                if (data.field.selectCounty == "") {
                    if (data.field.selectCity == "") {
                        data.field.cityId = data.field.selectProvince;
                    }
                    else {
                        data.field.cityId = data.field.selectCity;
                    }
                }
                else {
                    data.field.cityId = data.field.selectCounty;
                }
                if ($scope.userInfo.roleId == 4) {
                    if ($("#back64Img").val() == "" || data.field.veriFaceImages == "") {
                        layer.msg("请进行人像采集", {icon: 2,anim: 6});
                        return false;
                    }
                }
                else if ($scope.userInfo.roleId == 3 || $scope.userInfo.roleId == 5){
                    if (data.field.licenseFile == "") {
                        layer.msg("请上传营业执照", {icon: 2,anim: 6});
                        return false;
                    }
                }
                else if ($scope.userInfo.roleId == 2){
                    if (data.field.licenseFile == "") {
                        layer.msg("请上传单位介绍信", {icon: 2,anim: 6});
                        return false;
                    }
                }
                data.field.id = $scope.userInfo.id;
                config.log(data.field);
                $.ajax({
                    type : "post",
                    url : config.ip + "user/updateUser",
                    data : data.field,
                    headers: {
                        "token" : $scope.userInfo.token,
                    },
                    success : function (result) {
                        if(result.flag == 0 && result.code == 200){
                            $scope.parameter = {
                                phone : $scope.userInfo.phone,
                                password : $scope.userInfo.pwd,
                            }
                            $.ajax({
                                type: "post",
                                url: config.ip + "user/getInfo",
                                data: $scope.parameter,
                                headers: {
                                    "token": $scope.userInfo.token,
                                },
                                success: function (data) {
                                    if (data.flag == 0 && data.code == 200) {
                                        sessionStorage.removeItem("complementUser");
                                        sessionStorage.setItem("aiMaiUser", JSON.stringify(data.data));
                                        var userInfo = data.data;
                                        if (userInfo.roleId == 4) {
                                            location.href = config.ip + "page/person/myCourse";
                                        }
                                        else if (userInfo.roleId == 3 || $scope.userInfo.roleId == 5) {
                                            location.href = config.ip + "page/person/myCourseCompany";
                                        }
                                        else if (userInfo.roleId == 2) {
                                            location.href = config.ip + "page/person/dataCount";
                                        }
                                    }
                                    else {
                                        layer.msg(data.msg);
                                    }
                                }
                            });
                        }
                        else {
                            layer.msg(result.msg);
                        }
                    }
                });
            });
        });

        //确认采集
        $scope.submitContrast = function () {
            if ($("#back64Codes").val() == "") {
                layer.msg("请点击拍照.");
                return false;
            }
            $("body").append(config.showShade("正在识别,请稍等..."));
            $.ajax({
                type: "POST",
                url: "http://api.eyekey.com/face/Check/checking",
                data: {
                    app_id : config.eyeKeyAppId,
                    app_key : config.eyeKeyAppKey,
                    img : $("#back64Codes").val(),
                },
                success: function (json) {
                    json = JSON.parse(json);
                    config.log(json);
                    if (json.res_code == "0000") {
                        $("input[name='faceId']").val(json.face[0].face_id);
                        $.ajax({
                            type: "POST",
                            url : config.ipImg + 'res/uploadBase64',
                            data : {
                                base64 : $("#back64Img").val()
                            },
                            success : function (data) {
                                config.log(data);
                                $("input[name='veriFaceImages']").val(data.data.url);
                                $(".previewImg").attr("src", config.ipImg + data.data.url).css("width", "100px");
                                config.hideShade();
                                $("#photoShade").fadeOut();
                                $(".previewImage").attr("src", "").hide();
                                $("#affirmBtn").hide();
                            }
                        });
                    }
                    else if(json.res_code == "1067"){
                        config.hideShade();
                        layer.msg(json.message);
                    }
                    else{
                        config.hideShade();
                        layer.msg(json.message);
                    }
                }
            });
        }

    });


    //选择省
    var selectProvince = function (selectId) {
        config.ajaxRequestData(false, "city/queryCityByParentId", {levelType : 1}, function (result) {
            var html = "<option value=\"\">选择省</option>";
            if (selectId == 100000) {
                html += "<option selected=\"selected\" value=\"100000\">全国</option>";
            }
            else {
                html += "<option value=\"100000\">全国</option>";
            }
            for (var i = 0; i < result.data.length; i++) {
                if (result.data[i].id == selectId) {
                    html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].shortName + "</option>";
                }
                else {
                    html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].shortName + "</option>";
                }
            }
            $("select[name='selectProvince']").html(html);
        });
    }

    //选择市
    var selectCity = function (cityId, selectId) {
        config.ajaxRequestData(false, "city/queryCityByParentId", {cityId : cityId, levelType : 2}, function (result) {
            var html = "<option value=\"\">选择市</option>";
            for (var i = 0; i < result.data.length; i++) {
                if (result.data[i].id == selectId) {
                    html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].shortName + "</option>";
                }
                else {
                    html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].shortName + "</option>";
                }
            }
            $("select[name='selectCity']").html(html);
        });
    }

    //选择县
    var selectCounty = function (cityId, selectId) {
        config.ajaxRequestData(false, "city/queryCityByParentId", {cityId : cityId, levelType : 3}, function (result) {
            var html = "<option value=\"\">选择县/区</option>";
            for (var i = 0; i < result.data.length; i++) {
                if (result.data[i].id == selectId) {
                    html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].shortName + "</option>";
                }
                else {
                    html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].shortName + "</option>";
                }
            }
            $("select[name='selectCounty']").html(html);
        });
    }

    //行业
    var tradeList = function (selectId) {
        config.ajaxRequestData(false, "trade/queryTrade", {}, function (result) {
            var html = "<option value=\"\">选择行业</option>";
            for (var i = 0; i < result.data.length; i++) {
                if (result.data[i].id == selectId) {
                    html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].tradeName + "</option>";
                }
                else {
                    html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].tradeName + "</option>";
                }
            }
            $("select[name='tradeId']").html(html);
        });
    }

    //人脸采集/上传营业执照
    $('#File').change(function(){
        $("body").append(config.showShade("正在上传,请稍等..."));
        if ($('#File').val() == null || $('#File').val() == "") {
            return false;
        }
        var file = this.files[0];
        //判断是否是图片类型
        if (!/image\/\w+/.test(file.type)) {
            layer.alert("只能选择图片");
            return false;
        }
        var fr = new FileReader();
        if(window.FileReader) {
            fr.onloadend = function(e) {
                $("#newUpload").ajaxSubmit({
                    type: "POST",
                    url: config.ipImg + 'res/upload',
                    success: function(result) {
                        config.log(result);
                        if (result.code == 200) {
                            $('#File').val("");
                            config.hideShade();
                            $(".previewImg").attr("src", config.ipImg + result.data.url);
                            if (roleId != 4) {
                                $("input[name='licenseFile']").val(result.data.url);
                            }
                            else {
                                $("input[name='veriFaceImages']").val(result.data.url);
                            }
                        } else {
                            config.hideShade();
                            $('#File').val("");
                            layer.alert(result.msg);
                        }
                    }
                });
            };
            fr.readAsDataURL(file);
        }
    });

    /** 摄像头 **/
    function initCamera() {
        Webcam.set({
            width: 300,
            height: 200,
            image_format: 'jpeg',
            jpeg_quality: 90
        });
        Webcam.attach('#my_camera');
    }

    /** 生成图片 **/
    function generateImages() {
        Webcam.snap(function(data_uri) {
            $(".previewImage").attr("src", data_uri);
            $(".previewImage").fadeIn();
            $("#affirmBtn").fadeIn();
            var base64Codes = data_uri;
            $("#back64Img").val(base64Codes); //图片base64
            base64Codes = base64Codes.substring(22, base64Codes.length);
            $("#back64Codes").val(base64Codes);//纯base64编码
        });
    }

    /** 关闭摄像头弹窗 **/
    function closePhoto () {
        $("#photoShade").hide();
        $("#affirmBtn").hide();
        $(".previewImage").attr("src", "").hide();
        $("#back64Img").val(""); //图片base64
        $("#back64Codes").val("");//纯base64编码
    }

    var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串
    if (userAgent.indexOf("Chrome") > -1){
        $("marquee").html("通知：系统检测当前为Chrome谷歌浏览器,若您有摄像头设备并且连接不上摄像头，是因为最新Chrome谷歌浏览器Adobe Flash Player 插件已被屏蔽，解决方法：<a target='_blank' href='https://qzonestyle.gtimg.cn/qzone/photo/v7/js/module/flashDetector/flash_tutorial.pdf'>https://qzonestyle.gtimg.cn/qzone/photo/v7/js/module/flashDetector/flash_tutorial.pdf</a>");
    }

</script>
</body>
</html>

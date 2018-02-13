<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>学习课程</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/index.css"/>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/course/course.css"/>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/course/video.css"/>
    <style>
        .ctabBox>div.act{
            overflow: inherit;
        }
        .watchBox .courseInfo{
            height: inherit;
        }
        .courseInfo .col-xs-12{
            background: #FFF;
        }
        .watchList ul{
            overflow: auto;
            height: 250px;
        }
        .watchList ul li{
            margin-bottom: 0;
        }
        .watchList ul li a{
            margin-bottom: 10px;
        }
        .bottom-bar{
            position: inherit !important;
        }
        .courseComment{
            min-height: 400px;
        }
        .watchList ul::-webkit-scrollbar{
            width: 2px;
        }
        .watchList ul li a{
            padding-right: 10px;
        }
        .courseMenu{
            height: inherit !important;
        }
    </style>
</head>
<body ng-app="aiMaiApp" ng-controller="controller">
<%@include file="../common/top.jsp" %>
<div class="ai-content">

    <div class="courseWatch">
        <div class="container clearfix rel">
            <div class="courseVideo rel">
                <!-- 播放器开始 -->
                <div class="video-wrap">
                    <video id="video" class="video" preload="auto"></video>

                    <!--控制栏-->
                    <div class="video-control-bar">
                        <div class="theLeft">
                            <input id="startBtn" ng-click="clickPlay()" class="start-or-end-btn" type="image" src="<%=request.getContextPath()%>/resources/img/video/start.png" />
                            <input id="endBtn" ng-click="clickPause()" class="start-or-end-btn ai-hide" type="image" src="<%=request.getContextPath()%>/resources/img/video/pause.png" />
                            <span id="totalTime" class="video-time">00:00</span>
                        </div>
                        <div class="progress-out">
                            <div id="progressBar" class="video-progress-bar">
                                <!-- 滑条 -->
                                <div id="range" class="range">
                                    <!-- 缓冲进度条 -->
                                    <div id="bufferProgress" class="buffer-progress"></div>

                                    <!-- 已播放进度 -->
                                    <div id="cashProgress" class="cash-progress"></div>

                                    <!-- 滑动物 -->
                                    <span id="glider" class="glider"></span>
                                </div>
                            </div>
                        </div>
                        <div class="theRight">
                            <span id="currentTime" class="video-time">00:00</span>
                            <!-- 全屏 -->
                            <%--<input id="fullScreen" onclick="initVideo.openFullscreen()" class="full-screen" type="image" src="<%=request.getContextPath()%>/resources/img/video/fullScreen.png" />--%>
                        </div>
                    </div>

                    <!-- 视频遮罩 -->
                    <div class="video-shade">
                        <img id="videoCover" class="video-cover">
                        <img class="video-loading" src="<%=request.getContextPath()%>/resources/img/video/loading.png" ng-click="clickPlay()"/>
                    </div>

                </div>
                <!-- 播放器结束 -->
            </div>
            <div class="watchBox">
                <div class="courseInfo">
                    <div class="mainName rel" ng-cloak>
                        <h4 class="rel" ng-cloak>{{curriculum.curriculumName}}</h4>
                        <div class="courseTag" ng-cloak>
                            <span>{{curriculum.year | date : 'yyyy'}}年</span>|<i>{{curriculum.stageName}}</i>
                        </div>
                    </div>
                </div>
                <div class="watchList">
                    <p>目录</p>
                    <ul>
                        <li ng-repeat="video in videoList" ng-cloak>

                            <!-- 收费课程 -->
                            <a ng-show="(video.videoStatus != null || $index == 0) && curriculum.type != 0" href="javascript:void(0)" ng-click="clickVideo(video, $index, false)">
                                {{video.courseWare.courseWareName}}：{{video.name}}
                                <span class="watchTime" ng-if="userInfo == null ||userInfo.definition == 0">
                                    <span>{{video.lowDefinitionSeconds}}</span>
                                </span>
                                <span class="watchTime" ng-if="userInfo.definition == 1">
                                    <span>{{video.highDefinitionSeconds}}</span>
                                </span>
                            </a>
                            <a ng-show="(video.videoStatus == null && $index != 0) && curriculum.type != 0" class="not-study" ng-click="notClickVideo()">
                                {{video.courseWare.courseWareName}}：{{video.name}}
                                <span class="watchTime" ng-if="userInfo == null ||userInfo.definition == 0">
                                    <span>{{video.lowDefinitionSeconds}}</span>
                                </span>
                                <span class="watchTime" ng-if="userInfo.definition == 1">
                                    <span>{{video.highDefinitionSeconds}}</span>
                                </span>
                            </a>

                            <!-- 免费课程 -->
                            <a ng-show="curriculum.type == 0" href="javascript:void(0)" ng-click="clickVideo(video, $index, false)">
                                {{video.courseWare.courseWareName}}：{{video.name}}
                                <span class="watchTime" ng-if="userInfo == null ||userInfo.definition == 0">
                                    <span>{{video.lowDefinitionSeconds}}</span>
                                </span>
                                <span class="watchTime" ng-if="userInfo.definition == 1">
                                    <span>{{video.highDefinitionSeconds}}</span>
                                </span>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <div class="courseDetail">
        <div class="container">
            <div class="layui-tab layui-tab-brief">
                <ul class="layui-tab-title">
                    <li class="layui-this"><i class="icon-inro"></i>介绍</li>
                    <li><i class="icon-list"></i>讲义</li>
                    <li><i class="icon-comment"></i>评论</li>
                </ul>
                <div class="layui-tab-content" ng-cloak>
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
                        <div class="courseMenu" id="ppt">
                            <div class="not-data" style="display: block" ng-show="pptList.length == 0">没有讲义.</div>
                            <img ng-repeat="url in pptList" src="{{ipImg}}{{url}}" layer-src="{{ipImg}}{{url}}" style="cursor: pointer;"/>
                        </div>
                    </div>
                    <div class="layui-tab-item not-padding">
                        <div id="commentList" class="courseComment" style="padding: 15px;"></div>
                        <!-- 发表评论 -->
                        <div class="comment-bar">
                            <div ng-show="userInfo == null || userInfo.avatar == null" class="user-avatar" style="background: url('<%=request.getContextPath()%>/resources/img/default-head.png')"></div>
                            <div ng-show="userInfo.avatar != null" class="user-avatar" style="background: url('{{ipImg}}{{userInfo.avatar}}')"></div>
                            <input type="text" maxlength="200" placeholder="在这里评论···" ng-model="content">
                            <button type="button" style="background: #2E75B5;" ng-click="submitComment()">发送</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 去练习 -->
<div class="face-shade-bg" id="topicShade">
    <div class="face-shade-title">本课时已看完</div>
    <div class="face-shade-hint">您可以选择开始考核该课时，或者观看下个课时.</div>
    <div class="face-shade-btn">
        <div class="row">
            <div class="col-xs-6" style="text-align: left;padding-right: 15px">
                <button type="button" class="return-btn" ng-click="nextVideo()">观看下个视频</button>
            </div>
            <div class="col-xs-6" style="text-align: right;padding-left: 15px">
                <button type="button" ng-click="startEvaluation(0)" class="yellow-btn">去练习</button>
            </div>
        </div>
    </div>
</div>

<!-- 去模拟 -->
<div class="face-shade-bg" id="simulateShade">
    <div class="face-shade-title">本课程已看完</div>
    <div class="face-shade-hint">您可以选择去练习，或者去模拟.</div>
    <div class="face-shade-btn">
        <div class="row">
            <div class="col-xs-6" style="text-align: left;padding-right: 15px">
                <button type="button" ng-click="startEvaluation(0)" class="return-btn">去练习</button>
            </div>
            <div class="col-xs-6" style="text-align: right;padding-left: 15px">
                <button type="button" ng-click="startEvaluation(1)" class="yellow-btn">去模拟</button>
            </div>
        </div>
    </div>
</div>

<!-- 通过 -->
<div class="face-shade-bg" id="passShade">
    <div class="face-shade-title">本课程已看完</div>
    <div class="face-shade-hint">恭喜您已通过考试!</div>
    <div class="face-shade-btn">
        <div class="row">
            <div class="col-xs-12" style="text-align: center;">
                <button type="button" ng-click="picturePass()" class="return-btn">确认</button>
            </div>
        </div>
    </div>
</div>

<!-- 人脸识别提示窗 -->
<div class="face-shade"></div>
<div class="face-shade-bg" id="faceShade">
    <div class="face-shade-title">是否进行人脸对比</div>
    <div class="face-shade-hint">人脸对比成功了才能继续往下看.</div>
    <div class="face-shade-btn">
        <div class="row">
            <div class="col-xs-6" style="text-align: left;padding-right: 15px">
                <button ng-click="affirmFace()" class="return-btn">确认对比</button>
            </div>
            <div class="col-xs-6" style="text-align: right;padding-left: 15px">
                <button ng-click="cancelFace()" class="yellow-btn">取消对比</button>
            </div>
        </div>
    </div>
</div>

<div class="photo-shade" id="photoShade">
    <div class="photo-video-bg">
        <i class="fa fa-close" ng-click="closePhoto()"></i>
        <marquee direction="left" behavior="scroll" scrollamount="6" scrolldelay="0" loop="-1" hspace="5" vspace="5" style="color: red;font-size: 14px;width: 300px;">
            *请点击“允许”按钮，授权网页访问您的摄像头！
            若您并未看到任何授权提示，则表示您的浏览器摄像头链接或您的机器没有连接摄像头设备。
        </marquee>
        <div class="human-face">
            <div id="my_camera"></div>
        </div>
        <div class="photo-btn-bar">
            <button class="min-blue-button" onclick="generateImages()">拍照</button>
            &nbsp;&nbsp;&nbsp;
            <button id="affirmBtn" class="min-blue-button yellow-button" ng-click="submitContrast()">确认对比</button>
        </div>
        <img class="previewImage">
    </div>
</div>

<input type="hidden" id="back64Img">
<input type="hidden" id="back64Codes">


<%@include file="../common/bottom.jsp" %>
<%@include file="../common/js.jsp" %>
<script src="<%=request.getContextPath()%>/resources/js/video.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/webcamjs/webcam.min.js"></script>


<script>
    //$("body").append(config.showShade("正在加载,请稍等..."));

    config.reload();
    var curriculumId = sessionStorage.getItem("curriculumId");
    var orderId = sessionStorage.getItem("orderId");
    var isAudition = sessionStorage.getItem("isAudition");
    config.log(curriculumId);
    config.log(orderId);
    config.log(isAudition);
    if ((curriculumId == null || curriculumId == "") && (orderId == null || orderId == "")) {
        location.href = config.ip + "page/index";
    }
    var webApp = angular.module('aiMaiApp', []);
    webApp.controller("controller", function($scope, $timeout) {
        $scope.userInfo = config.aiMaiUser();
        $scope.ipImg = config.ipImg; //图片IP
        $scope.ipVideo = config.ipVideo; //视频IP
        $scope.content = ""; //存放评论内容

        $scope.curriculum = null; //课程对象
        $scope.video = null; //存放当前播放视频对象
        $scope.videoList = []; //存放所有的视频集合
        $scope.videoIndex = 0; //代表播放视频下标
        $scope.pptList = null; //存放ppt

        /** 获取课程信息 **/
        $scope.getCurriculum = function () {
            if (isAudition == 1) {
                isDrag = true; //免费课程可以拖动
                config.ajaxRequestData(false, "curriculum/queryCurriculumById", {curriculumId : curriculumId}, function (result) {
                    $scope.curriculum = result.data;
                    //分割PPT
                    for (var i = 0; i < $scope.curriculum.courseWares.length; i++) {
                        var obj = $scope.curriculum.courseWares[i];
                        if (obj.ppt != null && obj != "") {
                            obj.ppts = obj.ppt.split(",");
                        }
                    }

                    //格式化时间
                    for (var i = 0; i < $scope.curriculum.courseWares.length; i++) {
                        var courseWares = $scope.curriculum.courseWares[i];
                        for (var j = 0; j < courseWares.videos.length; j++) {
                            var video = courseWares.videos[j];
                            video.highDefinitionSeconds = config.getFormatTime(video.highDefinitionSeconds);
                            video.lowDefinitionSeconds = config.getFormatTime(video.lowDefinitionSeconds);
                        }
                    }
                });
            }
            else {
                isDrag = false; //收费课程不可以拖动
                config.ajaxRequestData(false, "curriculum/queryCurriculumByOrder", {orderId : orderId}, function (result) {
                    $scope.curriculum = result.data;
                    //分割PPT
                    for (var i = 0; i < $scope.curriculum.courseWares.length; i++) {
                        var obj = $scope.curriculum.courseWares[i];
                        if (obj.ppt != null && obj != "") {
                            obj.ppts = obj.ppt.split(",");
                        }
                    }

                    //格式化时间
                    for (var i = 0; i < $scope.curriculum.courseWares.length; i++) {
                        var courseWares = $scope.curriculum.courseWares[i];
                        for (var j = 0; j < courseWares.videos.length; j++) {
                            var video = courseWares.videos[j];
                            video.highDefinitionSeconds = config.getFormatTime(video.highDefinitionSeconds);
                            video.lowDefinitionSeconds = config.getFormatTime(video.lowDefinitionSeconds);
                        }
                    }
                });
            }
        }
        $scope.getCurriculum();

        /** 筛选视频集合 **/
        $scope.screenVideoList = function () {
            $scope.videoList = [];
            for (var i = 0; i < $scope.curriculum.courseWares.length; i++) {
                var courseWare = $scope.curriculum.courseWares[i];
                for (var j = 0; j < courseWare.videos.length; j++) {
                    var video = courseWare.videos[j];
                    video.courseWare = courseWare;
                    $scope.videoList.push(video);
                }
            }
        }
        $scope.screenVideoList();

        /** 筛选初始化视频**/
        $scope.firstVideo = function () {
            var isPayAll = false;
            for (var i = 0; i < $scope.videoList.length; i++) {
                var video = $scope.videoList[i];
                $scope.video = video; //赋值当前视频播放对象
                //寻找播放视频、判断是否有记录
                if (video.videoStatus == null) {
                    //设置播放清晰度
                    if ($scope.userInfo == null || $scope.userInfo.definition == 0) {
                        if (video.lowDefinition.indexOf("http") != -1 || video.lowDefinition.indexOf("https") != -1 ) {
                            initVideo.setSrc(video.lowDefinition);
                        }
                        else {
                            initVideo.setSrc($scope.ipVideo + video.lowDefinition);
                        }
                        initVideo.shadeShow();
                    }
                    else {
                        if (video.highDefinition.indexOf("http") != -1 || video.highDefinition.indexOf("https") != -1 ) {
                            initVideo.setSrc(video.highDefinition);
                        }
                        else {
                            initVideo.setSrc($scope.ipVideo + video.highDefinition);
                        }
                        initVideo.shadeShow();
                    }
                    $("#videoCover").attr("src", config.ipImg + video.cover);
                    $scope.videoIndex = i; //赋值播放下标
                    $scope.pptList = video.courseWare.ppts; //赋值ppts
                    isPayAll = true;
                    break;
                }
                else if (video.videoStatus.status == 0 || video.videoStatus.status == 1) {
                    //设置播放清晰度
                    if ($scope.userInfo == null || $scope.userInfo.definition == 0) {
                        if (video.lowDefinition.indexOf("http") != -1 || video.lowDefinition.indexOf("https") != -1 ) {
                            initVideo.setSrc(video.lowDefinition);
                        }
                        else {
                            initVideo.setSrc($scope.ipVideo + video.lowDefinition);
                        }
                        initVideo.shadeShow();
                    }
                    else {
                        if (video.highDefinition.indexOf("http") != -1 || video.highDefinition.indexOf("https") != -1 ) {
                            initVideo.setSrc(video.highDefinition);
                        }
                        else {
                            initVideo.setSrc($scope.ipVideo + video.highDefinition);
                        }
                        initVideo.shadeShow();
                    }
                    $("#videoCover").attr("src", config.ipImg + video.cover);
                    if (!!window.ActiveXObject || "ActiveXObject" in window) {
                        //IE特殊处理
                    }else {
                        initVideo.setCurrentTime($scope.video.videoStatus.seconds);
                    }
                    $scope.videoIndex = i; //赋值播放下标
                    $scope.pptList = video.courseWare.ppts; //赋值ppts
                    isPayAll = true;
                    break;
                }
            }
            if (!isPayAll && $scope.videoList.length > 0) { //表示已经看完所有视频
                //设置播放清晰度
                if ($scope.userInfo == null || $scope.userInfo.definition == 0) {
                    if ($scope.videoList[0].lowDefinition.indexOf("http") != -1 || $scope.videoList[0].lowDefinition.indexOf("https") != -1 ) {
                        initVideo.setSrc($scope.videoList[0].lowDefinition);
                    }
                    else {
                        initVideo.setSrc($scope.ipVideo + $scope.videoList[0].lowDefinition);
                    }
                    initVideo.shadeShow();
                }
                else {
                    if ($scope.videoList[0].highDefinition.indexOf("http") != -1 || $scope.videoList[0].highDefinition.indexOf("https") != -1 ) {
                        initVideo.setSrc($scope.videoList[0].highDefinition);
                    }
                    else {
                        initVideo.setSrc($scope.ipVideo + $scope.videoList[0].highDefinition);
                    }
                    initVideo.shadeShow();
                }
                $scope.pptList = $scope.videoList[0].courseWare.ppts; //赋值ppts
                $("#videoCover").attr("src", config.ipImg + $scope.videoList[0].cover);
                isDrag = true;
            }
        }
        $scope.firstVideo();

        /** 点击目录视频播放或者自动切换下一个 **/
        $scope.clickVideo = function (video, index, isSelfMotion) {
            $scope.video = video; //存入当前视频对象
            $scope.videoIndex = index; //存入下标
            //判断是否可以播放
            if ($scope.curriculum.type != 0 && !isSelfMotion) {
                var isBeBeing = false;
                var src = $("#video").attr("src");
                if ($scope.userInfo.definition == 0 && src.indexOf(video.lowDefinition) != -1) {
                    isBeBeing = true;
                }
                else if($scope.userInfo.definition == 1 && src.indexOf(video.highDefinition) != -1) {
                    isBeBeing = true;
                }
                if (video.videoStatus == null && !isBeBeing) {
                    layer.msg("该视频暂不能播放", {icon: 2,anim: 6});
                    return false;
                }
            }
            $timeout(function () { //更新PPT
                $scope.pptList = video.courseWare.ppts; //赋值ppts
            });
            config.log(video);
            if ($scope.userInfo == null || $scope.userInfo.definition == 0) {
                if (video.lowDefinition.indexOf("http") != -1 || video.lowDefinition.indexOf("https") != -1 ) {
                    initVideo.setSrc(video.lowDefinition);
                }
                else {
                    initVideo.setSrc($scope.ipVideo + video.lowDefinition);
                }
            }
            else {
                if (video.highDefinition.indexOf("http") != -1 || video.highDefinition.indexOf("https") != -1 ) {
                    initVideo.setSrc(video.highDefinition);
                }
                else {
                    initVideo.setSrc($scope.ipVideo + video.highDefinition);
                }
            }
            $("#videoCover").attr("src", config.ipImg + video.cover);
            initVideo.shadeShow();
            initVideo.restore(); //还原进度条
            seconds = 0; //播放完成把计时器清0
            initVideo.setTotalTime(); //重新给视频赋值总时间
            if ($scope.curriculum.type == 0 && isSelfMotion) {
                isDrag = true; //可拖动
                initVideo.play();
                initVideo.shadeHide();
            }
        }

        /** 点击播放按钮 **/
        $scope.clickPlay = function () {
            if ($scope.video == null) {
                layer.msg("暂无播放视频", {icon: 2,anim: 6});
                return false;
            }
            if (initVideo.getNetworkState() == 3) {
                layer.msg("视频播放失败", {icon: 2,anim: 6});
                return false;
            }
            if ($scope.curriculum.type != 0 && seconds != 0) { //判断是否是免费
                if ($scope.isFace && seconds == initVideo.getCurrentTime() && $scope.curriculum.type != 0) {
                    $(".face-shade").fadeIn();
                    $("#faceShade").slideDown(200);
                    return false;
                }
                //判断第一次开始播放插入记录
                else if ($scope.userInfo != null) {
                    config.ajaxRequestData(false, "videoStatus/queryNewVideoStatus", { videoId : $scope.video.id, orderId : orderId }, function (result) {
                        if (result.data == undefined) {
                            $scope.addVideoStatus($scope.video.id, 0, 0);
                        }
                    });
                    initVideo.play();
                    initVideo.shadeHide();
                }
            }
            else {
                initVideo.play();
                initVideo.shadeHide();
            }
        }

        /**点击不能播放视频**/
        $scope.notClickVideo = function () {
            layer.msg("该视频暂不能播放.");
            return false;
        }

        /** 点击暂停按钮 **/
        $scope.clickPause = function () {
            initVideo.pause();
        }

        /** 播放事件 **/
        initVideo.onTimeUpdate(function() {
            initVideo.startPlay(); //改变进度条
            if (seconds <= initVideo.getCurrentTime()) {
                if ($scope.curriculum.type != 0 && ($scope.video.videoStatus == null || $scope.video.videoStatus.status == 0 || $scope.video.videoStatus.status == 1)) {
                    isDrag = false; //不可拖动

                    if (seconds == 240) { // TODO 判断四分钟人脸识别
                        $scope.isFace = true;
                        $("#faceShade").fadeIn(100);
                        initVideo.pause();
                    }

                    /*var oneFace = parseInt(initVideo.getTotalTime() / 3); //第一次人脸识别值
                    var twoFace = parseInt(initVideo.getTotalTime() / 2); //第二次人脸识别值
                    if (initVideo.getTotalTime() < 180) {
                        if (oneFace == initVideo.getCurrentTime() && seconds != 0) {
                            if ($scope.getFace() == 0) {
                                $scope.isFace = true;
                                $(".face-shade").fadeIn();
                                $("#faceShade").slideDown(200);
                                initVideo.pause();
                            }
                        }
                        if (twoFace == initVideo.getCurrentTime() && seconds != 0) {
                            if ($scope.getFace() == 1) {
                                $scope.isFace = true;
                                $(".face-shade").fadeIn();
                                $("#faceShade").slideDown(200);
                                initVideo.pause();
                            }
                        }
                    }
                    else {
                        if (seconds == 60) { //TODO 纯属标记，比较关键
                            if ($scope.getFace() == 0) {
                                $scope.isFace = true;
                                $(".face-shade").fadeIn();
                                $("#faceShade").slideDown(200);
                                initVideo.pause();
                            }
                        }
                        if (oneFace == initVideo.getCurrentTime() && seconds != 0) {
                            if ($scope.getFace() == 1) {
                                $scope.isFace = true;
                                $(".face-shade").fadeIn();
                                $("#faceShade").slideDown(200);
                                initVideo.pause();
                            }
                        }
                        if (twoFace == initVideo.getCurrentTime() && seconds != 0) {
                            if ($scope.getFace() == 2) {
                                $scope.isFace = true;
                                $(".face-shade").fadeIn();
                                $("#faceShade").slideDown(200);
                                initVideo.pause();
                            }
                        }
                    }*/
                    seconds = initVideo.getCurrentTime();
                    config.log("播放时间：" + seconds);
                }
                else {
                    isDrag = true; //可拖动
                }
            }
            //判断是否播放结束
            if (initVideo.isEnded()) {
                config.log("播放结束了.");
                if ($scope.userInfo != null && $scope.curriculum.type != 0) {
                    if ($scope.video.videoStatus == null || $scope.video.videoStatus.status == 0 || $scope.video.videoStatus.status == 1) {
                        var result = $scope.addVideoStatus($scope.video.id, 2, seconds);
                        $timeout(function () { //重新请求刷新状态
                            $scope.getCurriculum();
                            $scope.screenVideoList();
                        });
                        //有模拟 -- 表示看完 -- 暂无用
                        /*if (result.isShowExercises == 1 && result.isSimulationExercise == 1) {
                            $(".face-shade").fadeIn();
                            $("#simulateShade").slideDown(200);
                        }*/
                        //没有题直接通过
                        if (result.isShowNote == 1) {
                            $(".face-shade").fadeIn();
                            $("#passShade").slideDown(200);
                        }
                        //有练习题
                        else if (result.isShowExercises == 1) {
                            $(".face-shade").fadeIn();
                            $("#topicShade").slideDown(200);
                        }
                        else {
                            //此处播放下一个
                            $scope.videoIndex ++;
                            if ($scope.videoIndex < $scope.videoList.length) {
                                $scope.clickVideo($scope.videoList[$scope.videoIndex], $scope.videoIndex, true);
                            }
                        }
                    }
                    else {
                        //此处播放下一个
                        $scope.videoIndex ++;
                        if ($scope.videoIndex < $scope.videoList.length) {
                            $scope.clickVideo($scope.videoList[$scope.videoIndex], $scope.videoIndex, true);
                        }
                    }
                }
                else {
                    //此处播放下一个
                    $scope.videoIndex ++;
                    if ($scope.videoIndex < $scope.videoList.length) {
                        $scope.clickVideo($scope.videoList[$scope.videoIndex], $scope.videoIndex, true);
                    }
                }
            }
        });

        /** 获取人脸识别记录 **/
        $scope.getFace = function () {
            var faceSize = 0;
            config.ajaxRequestData(false, "faceRecord/queryFaceRecord", { videoId : $scope.video.id, orderId : orderId }, function (result) {
                faceSize = result.data.length;
            });
            return faceSize;
        }

        /** 新增 播放记录 */
        $scope.addVideoStatus = function (videoId, status, second) {
            var parameter = {
                videoId : videoId,
                status : status,
                seconds : second,
                orderId : orderId
            }
            var data = null;
            if ($scope.userInfo != null) {
                config.ajaxRequestData(false, "videoStatus/addVideoStatus", parameter, function (result) {
                    data = result.data;
                });
            }
            return data;
        }

        /** 弹窗点击播放下一个 **/
        $scope.nextVideo = function () {
            $scope.videoIndex ++;
            if ($scope.videoIndex < $scope.videoList.length) {
                $scope.clickVideo($scope.videoList[$scope.videoIndex], $scope.videoIndex, true);
            }
            else {
                layer.msg("已经看完全部视频.");
            }
            $(".face-shade").fadeOut();
            $("#topicShade").slideUp(200);
        }

        /** 去练习或者去模拟 **/
        $scope.startEvaluation = function (examType) {
            sessionStorage.setItem("examType", examType);
            location.href = config.ip + "page/person/myExam";
        }

        /**通过考核--没有题的情况**/
        $scope.picturePass = function () {
            $(".face-shade").fadeOut();
            $("#passShade").slideUp(200);
        }

        /** 评论列表 **/
        $scope.queryEvaluate = function (pageNO, pageSize) {
            config.log(curriculumId);
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
                $(".courseComment").html(html);
            });
        }
        $scope.queryEvaluate(1, 10);

        /** 评论 **/
        $scope.submitComment = function () {
            if ($scope.userInfo == null) {
                layer.confirm('登录已失效，是否登录？', {
                    btn: ['确定','取消']
                    ,closeBtn: 0
                    ,anim: 1
                    ,title: "温馨提示"
                }, function(){
                    location.href = config.ip + "page/login";
                    sessionStorage.setItem("url", window.location.href);
                }, function(){});
                return false;
            }
            if ($scope.content.trim() == "") {
                layer.msg("请输入评论内容.", {icon: 2,anim: 6});
                return false;
            }
            var parameter = {
                content : $scope.content,
                curriculumId : curriculumId
            }
            config.ajaxRequestData(false, "evaluate/addEvaluate", parameter, function (result) {
                var html = "";
                $scope.avatar = $scope.userInfo.avatar == null ? config.ip + "resources/img/my/11.png" : config.ipImg + $scope.userInfo.avatar;
                html += '<li ng-repeat="evaluate in evaluateList">' +
                        '   <div class="user">' +
                        '       <i style="background: url(' + $scope.avatar + ')"></i>' +
                        '       <span>' + $scope.userInfo.showName + '</span>' +
                        '   </div>' +
                        '   <div class="userComment">' +
                        '       <span>1分钟前</span>' +
                        '       <p>' + $scope.content + '</p>' +
                        '    </div>' +
                        '</li>';
                var lis = $("#commentList").find("li");
                if (lis.length == 0) {
                    $("#commentList").html(html);
                }
                else {
                    $("#commentList li").eq(0).before(html);
                }
                $scope.content = "";
            });
        }

        /** 确认人脸对比 **/
        $scope.affirmFace = function () {
            initCamera();
            $scope.initPhoto();
            $(".face-shade").fadeOut();
            $("#faceShade").slideUp(200);
        }

        /** 取消人脸对比 **/
        $scope.cancelFace = function () {
            $(".face-shade").fadeOut();
            $("#faceShade").slideUp(200);
            $scope.addVideoStatus($scope.video.id, 1, seconds);
        }

        /** 显示摄像头弹窗 **/
        $scope.initPhoto = function () {
            $("#photoShade").show();
        }

        /** 关闭摄像头弹窗 **/
        $scope.closePhoto = function () {
            $("#photoShade").hide();
            $("#affirmBtn").hide();
            $(".previewImage").attr("src", "").hide();
            $("#back64Img").val(""); //图片base64
            $("#back64Codes").val("");//纯base64编码
        }

        /** 已经拍照确认对比 **/
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
                        var parameter = {
                            app_id : config.eyeKeyAppId,
                            app_key : config.eyeKeyAppKey,
                            face_id1 : $scope.userInfo.faceId,
                            face_id2 : json.face[0].face_id
                        }
                        config.log(parameter);
                        $.ajax({
                            type : "GET",
                            url : "http://api.eyekey.com/face/Match/match_compare",
                            data : parameter,
                            success : function (result) {
                                result = JSON.parse(result);
                                config.log(result);
                                if (Number(result.similarity) >= 80) {
                                    $.ajax({
                                        type: "POST",
                                        url : config.ipImg + 'res/uploadBase64',
                                        data : {
                                            base64 : $("#back64Img").val()
                                        },
                                        success : function (data) {
                                            config.log(data);
                                            if (data.code == 200) {
                                                parameter = {
                                                    videoId : $scope.video.id,
                                                    status : 1,
                                                    videoSecond : seconds,
                                                    orderId : orderId,
                                                    faceImage : data.data.url
                                                }
                                                config.ajaxRequestData(false, "faceRecord/addRecord", parameter, function (result) {
                                                    //验证成功后重新获取识别次数
                                                    config.ajaxRequestData(false, "faceRecord/queryFaceRecord", { videoId : $scope.video.id, orderId : orderId }, function (result) {
                                                        $scope.faceSize = result.data.length;
                                                    });
                                                    $scope.isFace = false; //成功之后表示人脸识别成功
                                                    initVideo.play(); //上传成功继续播放
                                                    config.hideShade();
                                                    $scope.closePhoto(); //关闭摄像头
                                                });
                                            } else {
                                                config.hideShade();
                                                layer.msg(json.msg);
                                            }
                                        }
                                    });
                                }
                                else {
                                    config.hideShade();
                                    $(".previewImage").fadeOut();
                                    $("#affirmBtn").fadeOut();
                                    layer.msg("人脸识别失败，请再试一下");
                                    /*var index = layer.alert("人脸识别失败，请再试一下.", "", function () {
                                     //$("#faceShade").fadeIn(100);
                                     layer.close(index);
                                     });*/
                                }
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
        $(this).toggleClass("act");
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
            //把canvas图像转为img图片
            $(".previewImage").attr("src", data_uri);
            $(".previewImage").fadeIn();
            $("#affirmBtn").fadeIn();
            var base64Codes = data_uri;
            $("#back64Img").val(base64Codes); //图片base64
            base64Codes = base64Codes.substring(22, base64Codes.length);
            $("#back64Codes").val(base64Codes);//纯base64编码
        });
    }

    $(function () {
        $('#ppt img').on("click",function(){
            layer.photos({
                photos: '#ppt',
                shadeClose: true,
                closeBtn: 2,
                anim: 5 //0-6的选择，指定弹出图片动画类型，默认随机
            });
        })
    })

    var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串
    if (userAgent.indexOf("Chrome") > -1){
        $("marquee").html("通知：系统检测当前为Chrome谷歌浏览器,若您有摄像头设备并且连接不上摄像头，是因为最新Chrome谷歌浏览器Adobe Flash Player 插件已被屏蔽，解决方法：<a target='_blank' href='https://qzonestyle.gtimg.cn/qzone/photo/v7/js/module/flashDetector/flash_tutorial.pdf'>https://qzonestyle.gtimg.cn/qzone/photo/v7/js/module/flashDetector/flash_tutorial.pdf</a>");
    }

</script>
</body>
</html>

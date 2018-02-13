<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>考题</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/person/exam.css">
</head>
<body ng-app="aiMaiApp" ng-controller="controller" ng-cloak>

<%@include file="../common/top.jsp" %>
<div class="ai-content">

    <div class="container">

        <div class="location-bar">
            <a href="javascript:history.back()">我的考题</a>
            <i class="fa fa-chevron-right"></i>
            <%--<a href="javascript:history.back()">上个位置</a>
            <i class="fa fa-chevron-right"></i>--%>
            <span>当前位置</span>
        </div>

        <div class="exam-bar">
            <div class="course-title">
                <h2>{{courseIds.curriculumName}}</h2>
                <div class="row time-bar">
                    <div class="col-xs-2" ng-show="courseIds.type == 1 || courseIds.type == 2">
                        <span class="totalTime">考试时间：{{courseIds.useTime / 60 / 60}}小时</span>
                    </div>
                    <div class="col-xs-2" ng-show="courseIds.type == 1 || courseIds.type == 2">
                        <i ng-show="isPause && courseIds.type == 1" class="fa fa-play" ng-click="startTime()"></i>
                        <i ng-show="!isPause && courseIds.type == 1" class="fa fa-pause" ng-click="endTime()"></i>
                        <i ng-show="courseIds.type == 2" class="fa fa-clock-o"></i>
                        <span id="examTime" class="exam-time">00:00:00</span>
                    </div>
                </div>
                <div class="answer-car">
                    <i></i>
                    <span>答题卡</span>
                </div>
                <div class="row answer-modal">
                    <i class="triangle-up"></i>
                    <div class="col-xs-12" id="answerList">
                        <div class="topic-item" ng-repeat="examination in paper">
                            <span class="sort-num">{{$index + 1}}</span>
                            <span id="answer_{{examination.id}}"></span>
                            <input type="hidden" examinationId="{{examination.id}}">
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-xs-12 submit-bar">
                            <button class="min-blue-button" ng-click="submitPaper()">提交考题</button>
                        </div>
                    </div>

                </div>
            </div>
            <div class="exam-item" ng-repeat="examination in paper">
                <i class="fa fa-heart-o" ng-click="collect(examination.id, $event)"></i>
                <span ng-show="examination.type == 0" class="topic-type">单选题</span>
                <span ng-show="examination.type == 1" class="topic-type">多选题</span>
                <span ng-show="examination.type == 2" class="topic-type">判断题</span>
                <span class="topic-title">{{$index + 1}}、{{examination.title}}（）</span>
                <p class="topic-answer" ng-repeat="item in examination.examinationItemsList">
                    <label for="topic_{{examination.id}}_{{$index}}">
                        <input
                                id="topic_{{examination.id}}_{{$index}}"
                                ng-if="examination.type == 0 || examination.type == 2"
                               type="radio"
                               name="topic_{{examination.id}}"
                               value="{{examination.id}}"
                               ng-click="selectAnswer(examination.id, item.id, $index, examination.type, $event)"
                               class="fa my-radio"
                        >
                        <input
                                id="topic_{{examination.id}}_{{$index}}"
                                ng-if="examination.type == 1"
                               type="checkbox"
                               name="topic_{{examination.id}}"
                               value="{{item.id}}"
                               index="{{$index}}"
                               ng-click="selectAnswer(examination.id, item.id, $index, examination.type, $event)"
                               class="fa my-checkbox"
                        >
                        <span ng-show="$index == 0">A</span>
                        <span ng-show="$index == 1">B</span>
                        <span ng-show="$index == 2">C</span>
                        <span ng-show="$index == 3">D</span>
                        <span ng-show="$index == 4">E</span>
                        <span ng-show="$index == 5">F</span>
                        <span ng-show="$index == 6">G</span>
                        <span ng-show="$index == 7">H</span>
                        <span ng-show="$index == 8">I</span>
                        <span ng-show="$index == 9">J</span>
                        <span ng-show="$index == 10">K</span>
                        、{{item.itemTitle}}
                    </label>
                </p>
            </div>
        </div>

    </div>
</div>

<!-- 提示窗 -->
<div class="popover-shade"></div>
<div class="popover-shade-bg" id="popoverShade">
    <div class="popover-shade-title">您的答题时间已到!</div>
    <div class="popover-shade-hint">
        <span id="fiveSeconds">5</span>
        秒之后我们将自动为您提交答案
    </div>
    <div class="popover-shade-btn">
        <div class="row">
            <div class="col-xs-6" style="text-align: left;padding-right: 15px">
                <button class="popover-btn-ok" ng-click="submitPaper()">提交并查看</button>
            </div>
            <div class="col-xs-6" style="text-align: right;padding-left: 15px">
                <button class="popover-btn-cancel" ng-click="cancelSubmit()">返回检阅</button>
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
        $scope.courseIds = JSON.parse(sessionStorage.getItem("courseIds"));
        config.log($scope.courseIds);
        $scope.paperId = sessionStorage.getItem("paperId");
        config.log($scope.paperId);
        $scope.paper = null; //试卷
        $scope.seconds = 0; //考试计时器
        $scope.isSelfMotion = false; //是否是自动提交
        //获取试卷
        if ($scope.courseIds == null) {
            window.history.back();
            return false;
        }
        else if ($scope.courseIds.type == 0) {
            $scope.parameter = {
                targetId : $scope.courseIds.courseWareId,
                type : $scope.courseIds.type
            }
        }
        else if ($scope.courseIds.type == 1 || $scope.courseIds.type == 2) {
            $scope.parameter = {
                targetId : $scope.courseIds.curriculumId,
                type : $scope.courseIds.type
            }
        }
        config.ajaxRequestData(false, "paper/queryPaperById", {paperId : $scope.paperId}, function (result) {
            $scope.paper = result.data;
        });

        //添加答案
        $scope.selectAnswer = function (examinationId, examinationItemsId, sortNum, type, $event) {
            var obj = $event.target;
            if (type == 1) {
                $scope.answers = [];
                $scope.answerLetter = [];
                $(obj).parent().parent().parent().find("input[type='checkbox']").each(function () {
                    if ($(this).is(':checked')) {
                        $scope.answers.push($(this).val());
                        $scope.answerLetter.push(letter($(this).attr("index")));
                    }
                });
                $("#answer_" + examinationId).html($scope.answerLetter.toString());
                $("#answer_" + examinationId).next().val($scope.answers.toString());
            }
            else {
                $("#answer_" + examinationId).html(letter(sortNum));
                $("#answer_" + examinationId).next().val(examinationItemsId);
            }
            $("#answer_" + examinationId).parent().addClass("topic-item-active");

        }

        //提交答案
        $scope.submitPaper = function () {
            $scope.answers = [];
            $scope.isFinish = false;
            $("#answerList").find("input").each(function () {
                if ($(this).val() == "") {
                    $scope.isFinish = true;
                }
                var ids = $(this).val().split(",");
                for (var i = 0; i < ids.length; i++) {
                    if (!isNaN(parseInt(ids[i]))) {
                        ids[i] = parseInt(ids[i]);
                    }
                }
                $scope.answers.push({
                    examinationId : $(this).attr("examinationId"),
                    answers : ids
                });
            });

            $scope.parameter = {
                answers : JSON.stringify($scope.answers),
                paperId : $scope.paperId,
                orderId : $scope.courseIds.orderId,
                seconds : $scope.seconds
            }
            config.log($scope.parameter);
            if ($scope.isFinish && !$scope.isSelfMotion) {
                var index = layer.confirm('系统检查到您有未做题,您确认要提交？', {
                    btn: ['确定','取消']
                    ,closeBtn: 0
                    ,anim: 1
                    ,title: "温馨提示"
                }, function(){
                    config.ajaxRequestData(false, "paper/submitPaper", $scope.parameter, function () {
                        layer.alert('提交成功.', {
                            title: "温馨提示",
                            closeBtn: 0
                            ,anim: 3
                        }, function(){
                            location.href = config.ip + "page/person/myExam";
                        });
                    });
                    layer.close(index);
                }, function(){

                });
            }
            else {
                $(".popover-shade").fadeOut();
                $("#popoverShade").slideUp(200);
                config.ajaxRequestData(false, "paper/submitPaper", $scope.parameter, function () {
                    layer.alert('提交成功.', {
                        title: "温馨提示",
                        closeBtn: 0
                        ,anim: 3
                    }, function(){
                        location.href = config.ip + "page/person/myExam";
                    });
                });
            }

        }

        //返回检阅
        $scope.cancelSubmit = function () {
            $(".popover-shade").fadeOut();
            $("#popoverShade").slideUp(200);
        }

        //收藏
        $scope.collect = function (paperId,event) {
            var parameter = {
                type : 2,
                targetId : paperId
            }
            config.ajaxRequestData(false, "collect/addCollect", parameter, function () {
                layer.msg("收藏成功.");
                //$(event.target).removeClass("fa-heart-o").addClass("fa-heart");
            });
        }

        $(".answer-car").click(function (event) {
            event.stopPropagation();
            $(".answer-modal").toggle("slow");
        });

        $(".answer-modal").click(function (event) {
            //阻止事件冒泡
            event.stopPropagation();
        });

        //点击body关闭弹出
        $('body').on('click', function(){
            $(".answer-modal").hide("slow");
        });

        $scope.countDown = $scope.courseIds.useTime - 1; //存放倒计时总时间
        $("#examTime").html(config.getFormatTime($scope.courseIds.useTime));
        if (sessionStorage.getItem("countDown") == null) {
            if (sessionStorage.getItem("countDown") != "NaN") {
                sessionStorage.setItem("countDown", $scope.countDown); //存本地倒计时
            }
        }
        else {
            $scope.countDown = sessionStorage.getItem("countDown") == "NaN" ? $scope.courseIds.useTime : sessionStorage.getItem("countDown");
            $scope.seconds = sessionStorage.getItem("seconds") == null ? 0 : sessionStorage.getItem("seconds");
        }
        config.log(sessionStorage.getItem("countDown"));

        $scope.timerId = 0; //定时器ID
        $scope.isPause = true; //是否暂停
        $scope.startTime = function () {
            $scope.isPause = false;
            $scope.timerId = setInterval(function () {
                //时间到了停止
                if ($scope.countDown == 5) {
                    $(".popover-shade").fadeIn();
                    $("#popoverShade").slideDown(200);
                }
                else if ($scope.countDown < 5 && $scope.countDown > 0) {
                    $("#fiveSeconds").html($scope.countDown);
                    sessionStorage.setItem("countDown", $scope.countDown);
                    $("#examTime").html(config.getFormatTime($scope.countDown));
                    $scope.seconds++;
                    sessionStorage.setItem("seconds", $scope.seconds);
                }
                else if ($scope.countDown == 0) {
                    config.log("时间到了.");
                    clearInterval($scope.timerId);
                    if($scope.courseIds.type == 1 || $scope.courseIds.type == 2) $scope.endTime();
                    $scope.isSelfMotion = true;
                    $scope.submitPaper();
                }
                else {
                    sessionStorage.setItem("countDown", $scope.countDown);
                    $("#examTime").html(config.getFormatTime($scope.countDown));
                    $scope.seconds++;
                    sessionStorage.setItem("seconds", $scope.seconds);
                }
                $scope.countDown--;
            }, 1000);
        }
        if ($scope.courseIds.type != 0) $scope.startTime(); //判断是否是默认启动

        $scope.endTime = function () {
            clearInterval($scope.timerId);
            $scope.isPause = true;
        }

        config.hideShade();

    });

    //字母
    function letter (sortNum) {
        if (sortNum == 0) return "A";
        if (sortNum == 1) return "B";
        if (sortNum == 2) return "C";
        if (sortNum == 3) return "D";
        if (sortNum == 4) return "E";
        if (sortNum == 5) return "F";
        if (sortNum == 6) return "G";
        if (sortNum == 7) return "H";
        if (sortNum == 8) return "I";
        if (sortNum == 9) return "J";
        if (sortNum == 10) return "K";
    }

    //暂无用
    function RunOnBeforeUnload() {
        window.onbeforeunload = function(){
            return '将丢失未保存的数据!';
        }
    }
</script>
</body>
</html>

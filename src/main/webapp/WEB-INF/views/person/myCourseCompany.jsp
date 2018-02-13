<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>我的课程</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/person/myCourseCompany.css">
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
                                    <li class="layui-this">已购课程</li>
                                    <li>未购课程</li>
                                </ul>
                            </div>

                            <div class="courseList">
                                <div class="not-data" ng-show="courseList== null || courseList.length == 0">暂无数据</div>
                                <div class="course-item" ng-repeat="course in courseList">
                                    <div class="course-cover" ng-click="courseDetail(course.id)" style="background: url('{{ipImg}}{{course.cover}}')"></div>
                                    <div class="row course-info">
                                        <div class="col-xs-10">
                                            <div class="course-title">
                                                {{course.curriculumName}}
                                            </div>
                                            <div class="course-label">
                                                <span class="year-label">{{course.year | date : 'yyyy'}}年</span>
                                                <span class="erect"></span>
                                                <span class="type-label">{{course.stageName}}</span>
                                            </div>
                                            <div class="row time-bar">
                                                <div class="col-xs-12">
                                                    <div class="time-div">
                                                        <i class="icon-study"></i>
                                                        <span class="icon-font">{{course.videoNum}}个视频课</span>
                                                    </div>
                                                    <div class="time-div">
                                                        <i class="icon-add"></i>
                                                        <span class="icon-font">{{course.videoSeconds}}</span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="status-bar" ng-if="isPayment == 0">
                                                <span ng-click="queryUserStudyStatus(course.orderId, 0)">{{course.watchNum == null ? 0 : course.watchNum}}人已观看</span>
                                                <span style="cursor: default">{{course.countUser - course.watchNum}}人未观看</span>
                                                <span ng-click="queryUserStudyStatus(course.orderId, 1)">{{course.finishExamine == null ? 0 : course.finishExamine}}人已考核</span>
                                            </div>
                                            <div class="button-bar" ng-if="isPayment == 0">
                                                <button ng-show="course.allocationNum != course.number" class="min-blue-button" ng-click="distributionCourse(course.orderId, course.id)">分配课程<span>(已分配{{course.allocationNum}}份)</span></button>
                                                <button ng-show="course.allocationNum != course.number" class="min-blue-border-button" ng-click="importUserExcel()">导入人员名单</button>
                                                <button class="min-gray-button" ng-show="course.allocationNum == course.number">已分配完</button>
                                            </div>
                                        </div>
                                        <div class="col-xs-2 price-bar" ng-if="isPayment == 0">
                                            <div class="course-price"><span>￥</span>{{course.price | number : 2}}</div>
                                            <div class="course-num">{{course.number}}份</div>
                                        </div>
                                    </div>
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
</div>

<!-- 用户列表模态窗 -->
<div class="whiteMask"></div>
<div class="modal-this" id="userList">
    <div class="modal-title">
        查看学习列表<span class="modal-title-hint">(共{{userList.length}}位同事{{userType}})</span>
        <span class="modal-close-btn" id="closeUser">关闭</span>
    </div>
    <div class="row modal-context">
        <div class="col-xs-12 max-width">
            <div ng-show="userList.length == 0" class="min-not-data">暂无员工</div>
            <div class="user-item" ng-repeat="user in userList">
                <div ng-show="user.avatar == null" class="head" avatar="{{user.avatar}}" style="background: url('<%=request.getContextPath()%>/resources/img/default-head.png')"></div>
                <div ng-show="user.avatar != null" class="head" avatar="{{user.avatar}}" style="background: url('{{ipImg}}{{user.avatar}}"></div>
                <div class="name">{{user.showName}}</div>
                <div class="phone">{{user.phone}}</div>
                <div ng-show="user.isPass != 1">
                    <span class="status">考核未通过</span>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 选择人员模态窗 -->
<div class="modal-this select-user" id="selectUserList">
    <div class="modal-title">
        选择人员<span class="modal-title-hint">({{userList.length}}位)</span>
        <span class="modal-close-btn" ng-click="closeSelectUser()">关闭</span>
        <span class="modal-ok-btn" ng-click="confirmSelectUser()">确定</span>
    </div>
    <div class="row modal-context row-context">
        <div class="col-xs-4">
            <div class="sub-search-bar">
                <input id="search" type="text" class="search" placeholder="搜索人员">
                <i class="icon-search"></i>
            </div>
            <div class="all-select">
                <label>
                    <input class="fa my-checkbox" type="checkbox" id="allSelectUser" ng-click="allSelectUser($event)">
                    全选
                </label>
            </div>
            <div class="search-user-list" id="searchUser">
                <div class="row">
                    <div ng-show="userList == null || userList.length == 0" class="col-xs-12 min-not-data">暂无员工</div>
                    <div class="col-xs-12" ng-repeat="user in userList">
                        <label class="row">
                            <div class="col-xs-2">
                                <input id="checkbox_{{user.id}}" name="userName" class="fa my-checkbox" type="checkbox" onclick="clickUser(this, event)">
                                <input type="hidden" name="userId" value="{{user.id}}">
                            </div>
                            <div class="col-xs-10">
                                <div class="user-item">
                                    <div ng-show="user.avatar == null" class="head" avatar="{{user.avatar}}" style="background: url('<%=request.getContextPath()%>/resources/img/default-head.png')"></div>
                                    <div ng-show="user.avatar != null" class="head" avatar="{{user.avatar}}" style="background: url('{{ipImg}}{{user.avatar}}"></div>
                                    <div class="name">{{user.showName}}</div>
                                    <div class="phone">{{user.phone}}</div>
                                </div>
                            </div>
                        </label>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xs-5 selected-user-list" id="selectUserListHtml">

        </div>
        <div class="col-xs-3">
            <div class="title">
                已分配人员<span>({{allotUserList.length}}位)</span>
            </div>
            <div class="allocation-user-list">
                <div ng-repeat="user in allotUserList" class="user-item" id="user_{{user.id}}">
                    <%--<i class="fa fa-close" onclick="removeUser(this, '{{user.id}}')"></i>--%>
                    <div ng-if="user.avatar == null" class="head" style="background: url('<%=request.getContextPath()%>/resources/img/default-head.png')"></div>
                    <div ng-if="user.avatar != null" class="head" style="background: url('{{ipImg}}{{user.avatar}}')"></div>
                    <div class="name">{{user.showName}}</div>
                    <div class="phone">{{user.phone}}</div>
                    <input type="hidden" name="userId" value="{{user.id}}">
                </div>
            </div>
        </div>
    </div>
</div>

<div class="popover-shade"></div>
<div class="modal-this addUserModal" id="addUserModal">
    <div class="modal-title">
        导入人员
        <span class="modal-close-btn" id="closeAddUser">关闭</span>
    </div>
    <div class="modal-context">
        <div class="modal-row">
            <label>请选择导入文件：</label>
            <div class="modal-item">
                <p><button class="info-bg-btn" onclick="$('#File').click()">选择文件</button></p>
                <p class="hint-name">文件名字</p>
                <p><a href="<%=request.getContextPath()%>/resources/template/template.xls" class="info-btn">下载模版</a></p>
            </div>
        </div>
    </div>
</div>

<form id="newUpload" method="post" enctype="multipart/form-data">
    <input id="File" type="file" name="File" accept="application/vnd.ms-excel" class="hide">
    <input type="hidden" name="type" value="1">
</form>

<%@include file="../common/bottom.jsp" %>
<%@include file="../common/js.jsp" %>
<script src="<%=request.getContextPath()%>/resources/js/jquery.form.js" type="text/javascript" charset="UTF-8"></script>

<script>
    $("body").append(config.showShade("正在加载,请稍等..."));

    var webApp = angular.module('aiMaiApp', []);
    webApp.controller("controller", function($scope, $timeout) {
        $scope.userInfo = config.aiMaiUser();
        $scope.ipImg = config.ipImg;
        $scope.isFirst = false; //是否加载过第一次了
        $scope.courseList = null; //课程类别
        $scope.userList = null; //人员列表
        $scope.orderId = null; //存放订单ID
        $scope.userType = "";
        $scope.isPayment = 0; //是否查询购买课程
        $scope.allotUserList = null; //已分配的人员

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
                        if(!first){
                            $scope.getDataList(obj.curr, 30);
                        }
                    }
                });
                form.render();
            }
        });

        $scope.getDataList = function (pageNO, pageSize) {
            $scope.parameter = {
                pageNO : pageNO,
                pageSize : pageSize
            }
            if ($scope.isPayment == 0) {
                config.ajaxRequestData(false, "curriculum/queryCurriculumStudy", $scope.parameter, function (result) {
                    if (!$scope.isFirst) {
                        $timeout(function () {
                            $scope.courseList = result.data.dataList == null ? [] : result.data.dataList;
                            for (var i = 0; i < $scope.courseList.length; i++) {
                                var course = $scope.courseList[i];
                                course.videoSeconds = course.videoSeconds == null ? '0秒' : config.getFormat(course.videoSeconds);
                            }
                        });
                        $scope.isFirst = true;
                        $scope.changePage(result.data.count);
                    }
                    else {
                        $timeout(function () {
                            $scope.courseList = result.data.dataList == null ? [] : result.data.dataList;
                            for (var i = 0; i < $scope.courseList.length; i++) {
                                var course = $scope.courseList[i];
                                course.videoSeconds = course.videoSeconds == null ? '0秒' : config.getFormat(course.videoSeconds);
                            }
                        });
                    }
                });
            }
            else {
                $scope.parameter = {
                    pageNO : pageNO,
                    pageSize : pageSize,
                    companyId : $scope.userInfo.id
                }
                config.ajaxRequestData(false, "curriculum/getCurriculumNotBuy", $scope.parameter, function (result) {
                    if (!$scope.isFirst) {
                        $timeout(function () {
                            $scope.courseList = result.data.dataList == null ? [] : result.data.dataList;
                            for (var i = 0; i < $scope.courseList.length; i++) {
                                var course = $scope.courseList[i];
                                course.videoSeconds = course.videoSeconds == null ? '0秒' : config.getFormat(course.videoSeconds);
                            }
                        });
                        $scope.isFirst = true;
                        $scope.changePage(result.data.count);
                    }
                    else {
                        $timeout(function () {
                            $scope.courseList = result.data.dataList == null ? [] : result.data.dataList;
                            for (var i = 0; i < $scope.courseList.length; i++) {
                                var course = $scope.courseList[i];
                                course.videoSeconds = course.videoSeconds == null ? '0秒' : config.getFormat(course.videoSeconds);
                            }
                        });
                    }
                });
            }

        }
        $scope.getDataList(1, 30);

        //筛选条件
        $(".layui-tab-title li").click(function () {
            if ($(this).index() == 0) $scope.isPayment = 0;
            if ($(this).index() == 1) $scope.isPayment = 1;
            $scope.isFirst = false;
            $scope.getDataList(1, 30);
        });

        //企业用户获取课程下 已观看 和 已考核 人列表
        $scope.queryUserStudyStatus = function (orderId, flag) {
            if (flag == 0) $timeout(function () {$scope.userType = "学习";});
            if (flag == 1) $timeout(function () {$scope.userType = "考核";});
            $scope.parameter = {
                orderId : orderId,
                flag : flag,
                pageNO : 1,
                pageSize : 1000
            }
            config.ajaxRequestData(false, "user/queryUserStudyStatus", $scope.parameter, function (result) {
                $timeout(function () {
                    $scope.userList = result.data;
                });
            });
            openUser();
        }

        //课程分配
        $scope.distributionCourse = function (orderId, curriculumId) {
            $scope.queryUserForAllocation(null, curriculumId);
            $scope.getAllocationedUser(curriculumId);
            $scope.orderId = curriculumId; //TODO
            $scope.openSelectUser();
        }

        // 公司用户获取公司下的用户列表
        $scope.queryUserForAllocation = function (searchParam, orderId) {
            $scope.parameter = {
                searchParam : searchParam,
                curriculumId : orderId,
                isAllocation : 1,
                pageNO : 1,
                pageSize : 1000
            }
            config.ajaxRequestData(false, "user/queryUserForAllocation", $scope.parameter, function (result) {
                $timeout(function () {
                    $scope.userList = result.data.dataList;
                });
            });
        }

        // 公司用户获取公司下的用户列表
        $scope.getAllocationedUser = function (curriculumId) {
            $scope.parameter = {
                curriculumId : curriculumId,
                pageNO : 1,
                pageSize : 1000
            }
            config.ajaxRequestData(false, "user/getAllocationedUser", $scope.parameter, function (result) {
                $timeout(function () {
                    $scope.allotUserList = result.data;
                });
            });
        }


        //点击全选
        $scope.allSelectUser = function (event) {
            var obj = event.target;
            var checkbox = $(obj).is(':checked');
            config.log(checkbox);
            if (checkbox) {
                var html = "";
                for (var i = 0; i < $scope.userList.length; i++) {
                    var user = $scope.userList[i];
                    var avatar = user.avatar == null ? config.ip + "resources/img/default-head.png" : config.ipImg + user.avatar;
                    var style = "background: url('" + avatar + "')";
                    html += '<div class="user-item" id="user_' + user.id + '">' +
                            '       <i class="fa fa-close" onclick="removeUser(this, ' + user.id + ')"></i>' +
                            '       <div class="head" style="' + style + '"></div>' +
                            '       <div class="name">' + user.showName + '</div>' +
                            '       <div class="phone">' + user.phone + '</div>' +
                            '       <input type="hidden" name="userId" value="' + user.id + '">' +
                            '   </div>';
                }
                $("#searchUser").find("input[type='checkbox']:checkbox").prop("checked", true); //TODO prop很有用
                $("#selectUserListHtml").html(html);
            }
            else {
                for (var i = 0; i < $scope.userList.length; i++) {
                    var user = $scope.userList[i];
                    $("#selectUserListHtml").find("#user_" + user.id).remove();
                }
                $("#searchUser").find("input[type='checkbox']:checkbox").prop("checked", false);
            }
        }

        //提交已选用户
        $scope.confirmSelectUser = function () {
            $scope.userIds = [];
            $("#selectUserListHtml").find("input[name='userId']").each(function () {
                $scope.userIds.push($(this).val());
            });
            config.log($scope.userIds);
            config.log($scope.userIds.length);
            if ($scope.userIds.length == 0) {
                layer.msg("请勾选员工.");
                return false;
            }
            $scope.parameter = {
                userIds : $scope.userIds.toString(),
                curriculumId : $scope.orderId,
                number : 1
            }
            config.ajaxRequestData(false, "allocation/addAllocation", $scope.parameter, function (result) {
                config.log(result);
                if (result.data.length > 0) {
                    var msg = "<p>以下失败：";
                    for (var i = 0; i < result.data.length; i++) {
                        var obj = result.data[i];
                        msg += obj.showName + "、";
                    }
                    msg += "</p>";
                    var index = layer.alert(msg, {
                        title: "温馨提示",
                        closeBtn: 0
                        ,anim: 3
                    }, function(){
                        location.reload();
                    });
                }
                else {
                    layer.msg("分配成功.");
                    location.reload();
                    //$scope.closeSelectUser();
                }
            });
        }


        //详情
        $scope.courseDetail = function (curriculumId) {
            sessionStorage.setItem("curriculumId", curriculumId);
            window.open(config.ip + "page/course/courseDetail");
        }

        //导入
        $scope.importUserExcel = function () {
            $(".popover-shade").fadeIn();
            $("#addUserModal").slideDown(200);
        }

        $(function () {
            $("#closeUser").bind("click", closeUser);
            $("#closeAddUser").bind("click", closeAddUserModal);
            //给搜索框绑定改变事件
            $('#search').bind('input propertychange', function() {
                $("#selectUserListHtml").html("");
                $("#searchUser").find("input[type='checkbox']:checkbox").prop("checked", false);
                $scope.queryUserForAllocation($("#search").val(), $scope.orderId);
            });
        })

        //打开选择人员弹窗
        $scope.openSelectUser = function () {
            $(".whiteMask").fadeIn();
            $("#selectUserList").slideDown(200);
        }
        //关闭选择人员弹窗
        $scope.closeSelectUser = function () {
            $("#selectUserListHtml").html("");
            $("#searchUser").find("input[type='checkbox']:checkbox").prop("checked", false);
            $("#allSelectUser").prop("checked", false);
            $("#search").val("");
            $(".whiteMask").fadeOut();
            $("#selectUserList").slideUp(200);
        }

        config.hideShade();

    });

    function clickUser (obj, event) {
        /*if($(event.target).is('input')){
            return; //阻止自定义CheckBox 单击两次
        }*/
        event.stopPropagation();
        var userId = $(obj).parent().parent().find("input[name='userId']").val();
        var userName = $(obj).parent().parent().find(".name").html();
        var avatar = $(obj).parent().parent().find(".head").attr("avatar");
        var phone = $(obj).parent().parent().find(".phone").html();
        avatar = avatar == null || avatar == "" ? config.ip + "resources/img/default-head.png" : config.ipImg + avatar;
        var checkbox = $(obj).parent().parent().find("input[type='checkbox']").is(':checked');
        config.log("checkbox:" + checkbox);
        if (checkbox) {
            var style = "background: url('" + avatar + "')";
            var html = '<div class="user-item" id="user_' + userId + '">' +
                    '       <i class="fa fa-close" onclick="removeUser(this, ' + userId + ')"></i>' +
                    '       <div class="head" style="' + style + '"></div>' +
                    '       <div class="name">' + userName + '</div>' +
                    '       <div class="phone">' + phone + '</div>' +
                    '       <input type="hidden" name="userId" value="' + userId + '">' +
                    '   </div>';
            $("#selectUserListHtml").append(html);
        }
        else {
            $("#selectUserListHtml").find("#user_" + userId).remove();
        }

        var isAll = false;
        $("input[name=userName]").each(function () {
            if (!$(this).is(":checked")) {
                isAll = true;
            }
        });

        if (isAll) {
            $("#allSelectUser").prop("checked", false);
        }
        else {
            $("#allSelectUser").prop("checked", true);
        }

    }

    //删除已选用户
    function removeUser (obj, userId) {
        $("#searchUser").find("#checkbox_" + userId + ":checkbox").attr("checked", false);
        $("#allSelectUser:checkbox").attr("checked", false); //设置全选不可选中
        $(obj).parent().remove();
    }

    //打开用户列表弹窗
    function openUser () {
        $(".whiteMask").fadeIn();
        $("#userList").slideDown(200);
    }
    //关闭用户列表弹窗
    function closeUser () {
        $(".whiteMask").fadeOut();
        $("#userList").slideUp(200);
    }

    //关闭弹窗
    function closeAddUserModal () {
        $(".popover-shade").fadeOut();
        $("#addUserModal").slideUp(200);
    }


    //上传 .xls
    $('#File').change(function(){
        $("body").append(config.showShade("正在上传,请稍等..."));
        var file = this.files[0];
        var fr = new FileReader();
        $(".hint-name").html(file.name);
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
                            config.ajaxRequestData(false, "user/importUserExcel", {url : config.ipImg + result.data.url}, function (result) {
                                var msg = "<p>成功：" + result.data.successNum + "个</p>";
                                msg += "<p>失败：" + result.data.failNum + "个</p>";
                                msg += "<p>失败原因：" + JSON.stringify(result.data.unExistUser) + "</p>";
                                var index = layer.alert(msg, {
                                    title: "温馨提示",
                                    closeBtn: 0
                                    ,anim: 3
                                }, function(){
                                    layer.close(index);
                                });
                                closeAddUserModal ();
                            });
                            $.ajax({
                                type: "POST",
                                url: config.ipImg + "res/delete",
                                data: { url : result.data.url },
                                success: function () {config.log("delete.");}
                            });
                        } else {
                            config.hideShade();
                            $('#File').val("");
                            layer.alert(result.msg);
                            closeAddUserModal ();
                        }
                    }
                });
            };
            fr.readAsDataURL(file);
        }
    });
</script>
</body>
</html>

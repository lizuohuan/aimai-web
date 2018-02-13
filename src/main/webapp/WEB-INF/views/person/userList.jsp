<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>人员列表</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/person/userList.css">
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
                                        人员列表
                                        <span>(共{{totalPage}}位员工)</span>
                                        <span class="add-user" ng-click="addUser()">添加员工</span>
                                        <div class="sub-search-bar">
                                            <i class="search-icon"></i>
                                            <input id="search" type="text" class="sub-search-input" placeholder="搜索员工">
                                        </div>
                                    </div>
                                </div>

                                <div class="layui-tab layui-tab-brief" ng-if="userInfo.roleId == 5">
                                    <ul class="layui-tab-title">
                                        <li class="layui-this">已分配用户</li>
                                        <li>未分配用户</li>
                                    </ul>
                                </div>

                                <div class="company-list">
                                    <table class="company-table">
                                        <thead>
                                        <tr>
                                            <th width="50px"></th>
                                            <th>用户</th>
                                            <th>职位</th>
                                            <th>身份证</th>
                                            <th>学习课程</th>
                                            <th class="center">学习情况</th>
                                            <th class="center">操作</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                            <tr ng-repeat="user in userList">
                                                <td>
                                                    <input name="user" ng-checked="isChecked(user.id)" ng-click="updateSelection($event,user.id)" type="checkbox" value="{{user.id}}" class="fa my-checkbox">
                                                </td>
                                                <td>
                                                    <div class="table-head">
                                                        <i ng-show="user.avatar == null" class="user-head" style="background: url('<%=request.getContextPath()%>/resources/img/default-head.png')"></i>
                                                        <i ng-hide="user.avatar == null" class="user-head" style="background: url('{{ipImg}}{{user.avatar}}')"></i>
                                                        <p class="company-name">{{user.showName}}</p>
                                                        <p class="company-hint">{{user.phone}}</p>
                                                    </div>
                                                </td>
                                                <td>{{user.jobTitle == null ? '暂无' : user.jobTitle}}</td>
                                                <td>{{user.pid == null ? '暂无' : user.pid}}</td>
                                                <td>
                                                    <span class="course-name" ng-click="courseDetail(user.curriculumId)" ng-show="user.curriculumName != null && user.curriculumName != ''">
                                                        {{user.curriculumName == null || user.curriculumName == '' ? '暂无' : user.curriculumName}}
                                                    </span>
                                                    <span class="course-name-not" ng-show="user.curriculumName == null || user.curriculumName == ''">
                                                        暂无
                                                    </span>
                                                </td>
                                                <td class="center">
                                                    <span ng-show="user.isPass == 1" class="orange-badge">考试通过</span>
                                                    <div class="time-bar" ng-show="user.isPass == 1">
                                                        <span>{{user.passTime | date : 'yyyy-MM-dd'}}</span>
                                                        <p>{{user.passTime | date : 'hh:mm'}}</p>
                                                    </div>
                                                    <div ng-show="user.isPass != 1">
                                                        <span class="num">{{user.finishCourseWareNum == null ? 0 : user.finishCourseWareNum}}</span>
                                                        <p>课程</p>
                                                    </div>
                                                </td>
                                                <td class="center">
                                                    <button class="info-btn" ng-click="queryWaitAllocationCurriculum(user.id)">分配课程</button>
                                                    <button class="delete-btn" ng-click="deleteUser(user.id, $event)">删除</button>
                                                </td>
                                            </tr>

                                        </tbody>
                                        <tfoot>
                                            <tr ng-show="userList.length == 0 || userList == null">
                                                <td class="not-data" colspan="99">暂无数据</td>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </div>

                                <div class="page-bar row">
                                    <a href="<%=request.getContextPath()%>/resources/template/template.xls" class="downloadTemplate"><i class="fa fa-file-excel-o"></i>&nbsp;下载人员模版</a>
                                    <div class="col-xs-4">
                                        <label class="checkAll">
                                            <input ng-click="checkAll($event)" type="checkbox" class="fa my-checkbox">
                                            全选
                                        </label>
                                        <button class="min-blue-button export-btn" ng-click="export()">导出人员列表</button>
                                        <button class="min-blue-border-button export-btn" ng-click="importUserExcel()">导入人员名单</button>
                                    </div>
                                    <div class="col-xs-8">
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

    <div class="popover-shade"></div>
    <div class="modal-this allotModal" id="allotModal">
        <div class="modal-title">
            分配课程
            <span class="modal-close-btn" id="closeBtn">关闭</span>
            <span class="modal-ok-btn" ng-click="confirmSelectCourse()">确定</span>
        </div>
        <div class="modal-context" id="selectCourse">
            <div class="row">
                <div class="col-xs-12 not-data" ng-show="curriculumList.length == 0 || curriculumList == null">暂无课程</div>
                <div class="col-xs-12 course-item" ng-repeat="course in curriculumList">
                    <div class="row">
                        <label style="cursor: pointer;">
                            <div class="col-xs-1">
                                <input value="{{course.id}}" class="fa my-checkbox course-checkbox" type="checkbox">
                            </div>
                            <div class="col-xs-11">
                                <div class="course-cover" style="background: url('{{ipImg}}{{course.cover}}"></div>
                                <div class="course-title">
                                    {{course.curriculumName}}
                                </div>
                                <div class="course-label">
                                    <span class="">{{course.year | date : 'yyyy'}}年</span>
                                    <span class="">|</span>
                                    <span class="">{{course.stageName}}</span>
                                </div>
                                <div class="course-time-bar">
                                    <div class="time-div">
                                        <i class="icon-study"></i>
                                        <span class="icon-font"><span>{{course.videoNum}}</span>个视频课</span>
                                    </div>
                                    <div class="time-div">
                                        <span class="icon-font"><span>{{course.number}}</span>份</span>
                                    </div>
                                </div>
                            </div>
                        </label>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 员工列表弹窗 -->
    <div class="modal-this addUserModal" id="addUserModal">
        <div class="modal-title">
            添加员工
            <div class="sub-search-bar">
                <i class="search-icon"></i>
                <input id="search2" type="text" class="sub-search-input" placeholder="搜索员工">
            </div>
            <span class="modal-close-btn" id="closeUserBtn">关闭</span>
        </div>
        <div class="modal-context">
            <table class="company-table">
                <thead>
                <tr>
                    <th>用户</th>
                    <th class="center">身份证</th>
                    <th class="center">公司</th>
                    <th class="center">职位</th>
                    <th class="center">部门</th>
                    <th class="center">操作</th>
                </tr>
                </thead>
                <tbody>
                <tr ng-repeat="user in colleagueUserList">
                    <td>
                        <div class="table-head">
                            <i ng-show="user.avatar == null" class="user-head" style="background: url('<%=request.getContextPath()%>/resources/img/default-head.png')"></i>
                            <i ng-hide="user.avatar == null" class="user-head" style="background: url('{{ipImg}}{{user.avatar}}')"></i>
                            <p class="company-name">{{user.showName}}</p>
                            <p class="company-hint">{{user.phone}}</p>
                        </div>
                    </td>
                    <td class="center">{{user.pid}}</td>
                    <td class="center">{{user.companyName == null ? '暂无' : user.companyName}}</td>
                    <td class="center">{{user.jobTitle == null ? '暂无' : user.jobTitle}}</td>
                    <td class="center">{{user.departmentName == null ? '暂无' : user.departmentName}}</td>
                    <td class="center">
                        <button class="info-btn" ng-click="openAddColleague(user)">添加员工</button>
                    </td>
                </tr>
                </tbody>
                <tfoot>
                <tr ng-show="colleagueUserList.length == 0 || colleagueUserList == null">
                    <td class="not-data" colspan="99">暂无数据</td>
                </tr>
                </tfoot>
            </table>
        </div>
    </div>

    <!-- 添加员工信息 -->
    <div class="modal-this addUserInfoModal" id="addUserInfoModal">
        <div class="modal-title">
            添加员工
            <span class="modal-close-btn" id="closeUserInfoBtn">关闭</span>
            <span class="modal-ok-btn" ng-click="addColleague()">确定</span>
        </div>
        <div class="modal-context">
            <div class="layui-form-item">
                <label class="layui-form-label">头像</label>
                <div class="layui-input-inline">
                    <div ng-show="tempUser.avatar == null" class="head-div" style="background: url('<%=request.getContextPath()%>/resources/img/default-head.png')"></div>
                    <div ng-show="tempUser.avatar != null" class="head-div" style="background: url('{{ipImg}}{{tempUser.avatar}}')"></div>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">姓名</label>
                <div class="layui-input-inline">
                    <input class="layui-input" type="text" value="{{tempUser.showName}}" readonly>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">部门</label>
                <div class="layui-input-inline">
                    <input class="layui-input" type="text" ng-model="departmentName" placeholder="请输入部门">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">职位</label>
                <div class="layui-input-inline">
                    <input class="layui-input" type="text" ng-model="jobTitle" placeholder="请输入职位">
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
            $scope.userList = null;
            $scope.curriculumList = null;
            $scope.userId = null; //用户ID
            $scope.totalPage = 0;
            $scope.colleagueUserList = null; //游离用户
            $scope.selected = []; //存放已选userId
            $scope.isAllot = 0; //是否是游离用户


            //给搜索框绑定改变事件
            $('#search').bind('input propertychange', function() {
                $scope.searchParams = $("#search").val();
                config.log($scope.searchParams);
                $scope.getDataList(1, 30, $scope.searchParams);
            });

            //分配
            $scope.allocation = function () {
                openAllotModal();
            }

            //判断Id是否已经存在
            $scope.isChecked = function(id){
                return $scope.selected.indexOf(id) >= 0 ;
            }

            //装载Id
            $scope.updateSelection = function($event,id){
                var checkbox = $event.target ;
                var checked = checkbox.checked ;
                if(checked){
                    $scope.selected.push(id) ;
                }else{
                    var idx = $scope.selected.indexOf(id) ;
                    $scope.selected.splice(idx,1) ;
                }
            }

            //导出
            $scope.export = function () {

                var ids = [];
                $("input[name=user]").each(function () {
                    if ($(this).is(':checked')) {
                        ids.push($(this).val());
                    }
                });
                console.log(ids);
                if (ids.length == 0) {
                    layer.msg("请选择员工");
                    return false;
                }
                $scope.searchParams = $scope.searchParams == null ? "" : $scope.searchParams;
                window.location.href = config.ip + "/user/exportExcelUser?searchParams="
                        + $scope.searchParams
                        + "&userIds=" + ids
                        + "&companyId=" + config.aiMaiUser().id;
            }

            $scope.checkAll = function (event) {
                if ($(event.target).is(':checked')) {
                    $("input[name=user]").prop("checked", true);
                }
                else {
                    $("input[name=user]").prop("checked", false);
                }
            }

            //导入
            $scope.importUserExcel = function () {
                $('#File').click();
            }

            //删除员工
            $scope.deleteUser = function (userId, event) {
                var index = layer.confirm('确认删除该员工？', {
                    btn: ['确定','取消']
                    ,closeBtn: 0
                    ,anim: 1
                    ,title: "温馨提示"
                }, function(){
                    config.ajaxRequestData(false, "user /removeParentId", {id : userId}, function () {
                        $(event.target).parent().parent().fadeOut("slow");
                        $scope.getDataList(1, 30, $scope.searchParams);
                    });
                    layer.close(index);
                }, function(){

                });
            }

            layui.use(['laypage', 'layer'], function(){
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
                            //config.log(obj);
                            if(!first){
                                $scope.getDataList(obj.curr, 30, $scope.searchParams);
                            }
                        }
                    });
                    form.render();
                }
            });

            //获取用户列表
            $scope.getDataList = function (pageNO, pageSize, searchParam) {
                $scope.parameter = {
                    searchParam : searchParam,
                    pageNO : pageNO,
                    pageSize : pageSize
                }
                if ($scope.isAllot == 0) {
                    config.ajaxRequestData(false, "user/queryUserForAllocation", $scope.parameter, function (result) {
                        if (!$scope.isFirst) {
                            $timeout(function () {
                                $scope.totalPage = result.data.count;
                                $scope.userList = result.data.dataList;
                            });
                            $scope.isFirst = true;
                            $scope.changePage(result.data.count);
                        }
                        else {
                            $timeout(function () {
                                $scope.totalPage = result.data.count;
                                $scope.userList = result.data.dataList;
                            });
                        }
                    });
                }
                else {
                    config.ajaxRequestData(false, "user/getFreeUser", $scope.parameter, function (result) {
                        if (!$scope.isFirst) {
                            $timeout(function () {
                                $scope.totalPage = result.data.count;
                                $scope.userList = result.data.dataList;
                            });
                            $scope.isFirst = true;
                            $scope.changePage(result.data.count);
                        }
                        else {
                            $timeout(function () {
                                $scope.totalPage = result.data.count;
                                $scope.userList = result.data.dataList;
                            });
                        }
                    });
                }

            }
            //默认调用
            $scope.getDataList(1, 30, null);

            //筛选条件
            $(".layui-tab-title li").click(function () {
                if ($(this).index() == 0) $scope.isAllot = 0;
                if ($(this).index() == 1) $scope.isAllot = 1;
                $scope.isFirst = false;
                $scope.getDataList(1, 30, null);
            });



            //公司或者代理商 通过用户 获取待分配的课程列表
            $scope.queryWaitAllocationCurriculum = function (userId) {
                $scope.userId = userId;
                $scope.parameter = {
                    userId : userId,
                    pageNO : 1,
                    pageSize : 1000
                }
                config.ajaxRequestData(false, "curriculum/queryWaitAllocationCurriculum", $scope.parameter, function (result) {
                    $timeout(function () {
                        $scope.curriculumList = result.data;
                    });
                });
                openAllotModal();
            }

            //获取游离状态下的用户
            $scope.queryUserNoCompany = function (searchParam) {
                $scope.parameter = {
                    searchParam : searchParam,
                    pageNO : 1,
                    pageSize : 1000
                }
                config.ajaxRequestData(false, "user/queryUserNoCompany", $scope.parameter, function (result) {
                    $timeout(function () {
                        $scope.colleagueUserList = result.data;
                    });
                });
            }

            //提交已选课程
            $scope.confirmSelectCourse = function () {
                $scope.orderIds = [];
                $("#selectCourse").find("input[type='checkbox']").each(function () {
                    if ($(this).is(':checked')) {
                        $scope.orderIds.push($(this).val());
                    }
                });
                config.log($scope.orderIds);
                config.log($scope.orderIds.length);
                if ($scope.orderIds.length == 0) {
                    layer.msg("请勾选课程.");
                    return false;
                }
                $scope.parameter = {
                    curriculumIds : $scope.orderIds.toString(),
                    userId : $scope.userId,
                    number : 1
                }
                config.ajaxRequestData(false, "allocation/batchAddAllocation", $scope.parameter, function (result) {
                    layer.msg("分配成功.");
                    location.reload();
                    closeAllotModal();
                });
            }

            //打开弹窗
            $scope.addUser = function () {
                $scope.queryUserNoCompany(null);
                openAddUserModal();
            }

            //给员工弹窗搜索框绑定改变事件
            $('#search2').bind('input propertychange', function() {
                $scope.queryUserNoCompany($("#search2").val());
            });

            $scope.tempUser = null;
            $scope.departmentName = null;
            $scope.jobTitle = null;
            $scope.openAddColleague = function (user) {
                openAddUserInfoModal();
                $scope.tempUser = user;
            }

            //添加用户
            $scope.addColleague = function () {
                if ($scope.departmentName == null) {
                    layer.msg("请输入部门.");
                    return false;
                }
                else if ($scope.jobTitle == null) {
                    layer.msg("请输入职位.");
                    return false;
                }
                $scope.parameter = {
                    userId : $scope.tempUser.id,
                    departmentName : $scope.departmentName,
                    jobTitle : $scope.jobTitle,
                }
                config.ajaxRequestData(false, "user/addColleague", $scope.parameter, function (result) {
                    layer.msg("添加成功.");
                    $scope.tempUser = null;
                    $scope.departmentName = null;
                    $scope.jobTitle = null;
                    location.reload();
                });
            }

            //课程详情
            $scope.courseDetail = function (curriculumId) {
                sessionStorage.setItem("curriculumId", curriculumId);
                window.open(config.ip + "page/course/courseDetail");
            }

            config.hideShade();

        });

        $(function () {
            $("#closeBtn").bind("click", closeAllotModal);
            $("#closeUserBtn").bind("click", closeAddUserModal);
            $("#closeUserInfoBtn").bind("click", closeAddUserInfoModal);
        })

        //打开弹窗
        function openAllotModal () {
            $(".popover-shade").fadeIn();
            $("#allotModal").slideDown(200);
        }
        //关闭弹窗
        function closeAllotModal () {
            $(".popover-shade").fadeOut();
            $("#allotModal").slideUp(200);
        }

        //打开弹窗
        function openAddUserModal () {
            $(".popover-shade").fadeIn();
            $("#addUserModal").slideDown(200);
        }
        //关闭弹窗
        function closeAddUserModal () {
            $("#search2").val("");
            $(".popover-shade").fadeOut();
            $("#addUserModal").slideUp(200);
        }

        //打开弹窗
        function openAddUserInfoModal () {
            closeAddUserModal ();
            $(".popover-shade").fadeIn();
            $("#addUserInfoModal").slideDown(200);
        }
        //关闭弹窗
        function closeAddUserInfoModal () {
            $(".popover-shade").fadeOut();
            $("#addUserInfoModal").slideUp(200);
        }

        //上传 .xls
        $('#File').change(function(){
            $("body").append(config.showShade("正在上传,请稍等..."));
            var file = this.files[0];
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
                                config.ajaxRequestData(false, "user/importUserExcel", {url : config.ipImg + result.data.url}, function (result) {
                                    var msg = "<p>成功：" + result.data.successNum + "个</p>";
                                    msg += "<p>失败：" + result.data.failNum + "个</p>";
                                    if (result.data.failNum != 0) {
                                        msg += "<p>失败原因：" + JSON.stringify(result.data.unExistUser) + "</p>";
                                    }
                                    var index = layer.alert(msg, {
                                        title: "温馨提示",
                                        closeBtn: 0
                                        ,anim: 3
                                    }, function(){
                                        if (result.data.successNum == 0) {
                                            layer.close(index);
                                        }
                                        else {
                                            location.reload();
                                        }
                                    });
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

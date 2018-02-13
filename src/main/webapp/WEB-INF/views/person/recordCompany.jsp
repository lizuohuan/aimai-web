<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>统计数据</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/person/dataCountCompany.css">

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
                                        数据统计
                                    </div>
                                    <div class="screen-bar">
                                        <form class="layui-form" id="formData">
                                            <div class="layui-form-item">
                                                <label class="layui-form-label">高级筛选：</label>
                                                <div class="layui-input-inline">
                                                    <input type="text" ng-model="pid" class="layui-input" placeholder="请输入身份证">
                                                </div>
                                                <div class="layui-input-inline">
                                                    <input type="text" ng-model="phone" class="layui-input" placeholder="请输入手机号">
                                                </div>
                                                <div class="layui-input-inline">
                                                    <input type="text" ng-model="companyName" class="layui-input" placeholder="请输入公司名称">
                                                </div>
                                            </div>
                                            <div class="layui-form-item">
                                                <label class="layui-form-label"></label>
                                                <div class="layui-input-inline">
                                                    <input id="begin" ng-model="startTimes" readonly type="text" class="layui-input" placeholder="请选择开始时间">
                                                </div>
                                                <div class="layui-input-inline">
                                                    <input id="end" ng-model="endTimes" readonly type="text" class="layui-input" placeholder="请选择结束时间">
                                                </div>
                                            </div>
                                            <div class="layui-form-item">
                                                <label class="layui-form-label"></label>
                                                <div class="layui-input-inline">
                                                    <button type="button" ng-click="search()" class="min-blue-button export-btn">搜索</button>
                                                    <button type="button" ng-click="reset()" class="min-blue-border-button export-btn">清空</button>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>

                                <div class="company-list">
                                    <table class="company-table">
                                        <thead>
                                        <tr>
                                            <th width="30px"></th>
                                            <th class="center">人脸识别<br>采集</th>
                                            <th class="center">姓名<br>联系方式</th>
                                            <th width="70px" class="center">所在地</th>
                                            <th class="center">行业</th>
                                            <th class="center">身份证</th>
                                            <th class="center">所属公司<br>部门<br>职位</th>
                                            <th width="70px" class="center">创建时间</th>
                                            <th class="center">操作</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                            <tr ng-repeat="user in userList">
                                                <td class="center">
                                                    <input name="user" ng-checked="isChecked(user.id)" ng-click="updateSelection($event,user.id)" type="checkbox" value="{{user.id}}" class="fa my-checkbox">
                                                </td>
                                                <td>
                                                    <div class="portrait" style="background: url('{{ipImg}}{{user.veriFaceImages}}')"></div>
                                                </td>
                                                <td class="center">
                                                    <p class="company-name">{{user.showName}}</p>
                                                    <p class="company-name">{{user.phone}}</p>
                                                </td>
                                                <td class="center">
                                                    <p class="company-name">{{user.city.mergerName}}</p>
                                                </td>
                                                <td class="center">{{user.tradeName}}</td>
                                                <td class="center">{{user.pid}}</td>
                                                <td class="center">
                                                    <p class="company-name" ng-if="user.companyName != null && user.companyName != ''">{{user.companyName}}</p>
                                                    <p class="company-hint" ng-if="user.companyName == null || user.companyName == ''">暂无</p>
                                                    <p class="company-name" ng-if="user.departmentName != null && user.departmentName != ''">{{user.departmentName}}</p>
                                                    <p class="company-hint" ng-if="user.departmentName == null || user.departmentName == ''">暂无</p>
                                                    <p class="company-name" ng-if="user.departmentName != null && user.departmentName != ''">{{user.departmentName}}</p>
                                                    <p class="company-hint" ng-if="user.departmentName == null || user.departmentName == ''">暂无</p>
                                                </td>
                                                <td class="center">{{user.createTime | date : 'yyyy-MM-dd hh:mm:ss'}}</td>
                                                <td class="center">
                                                    <p><button class="info-btn" ng-click="findDetail(user.id)">查看信息</button></p>
                                                    <br>
                                                    <p><button class="info-btn" ng-click="curriculumList(user.id)">学习情况列表</button></p>
                                                    <br>
                                                    <p><button class="info-btn" ng-click="examList(user.id)">考试记录列表</button></p>
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
                                    <div class="col-xs-4">
                                        <label class="checkAll">
                                            <input ng-click="checkAll($event)" type="checkbox" class="fa my-checkbox">
                                            全选
                                        </label>
                                        <button class="min-blue-button export-btn" ng-click="export()">导出用户</button>
                                        <button class="min-blue-button export-btn" ng-click="export2()">导出考试结果</button>
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

    <%@include file="../common/bottom.jsp" %>
    <%@include file="../common/js.jsp" %>

    <script>
        $("body").append(config.showShade("正在加载,请稍等..."));

        var webApp = angular.module('aiMaiApp', []);
        webApp.controller("controller", function($scope, $timeout) {
            $scope.userInfo = config.aiMaiUser();
            $scope.ipImg = config.ipImg;
            $scope.userList = null;
            $scope.curriculumList = null;
            $scope.totalPage = 0;
            $scope.selected = []; //存放已选userId
            $scope.pid = null, $scope.phone = null, $scope.companyName = null, $scope.startTimes = "", $scope.endTimes = "";

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
                window.location.href = config.ip + "/user/exportExcelUser?companyId=" + config.aiMaiUser().id
                        + "&userIds=" + ids.toString();
            };
            //导出考试结果
            $scope.export2 = function () {
                window.location.href = config.ip + "/excel/excelUser2?userIds=" + $scope.selected.toString();
            }

            $scope.checkAll = function (event) {
                if ($(event.target).is(':checked')) {
                    $("input[name=user]").prop("checked", true);
                }
                else {
                    $("input[name=user]").prop("checked", false);
                }
            }

            //搜索
            $scope.search = function () {
                $scope.startTimes = $("#begin").val();
                $scope.endTimes = $("#end").val();
                // if ($scope.startTimes != null) {
                //     $scope.startTimes = config.getTimeStamp($scope.startTimes);
                // }
                // if ($scope.endTimes != null) {
                //     $scope.endTimes = config.getTimeStamp($scope.endTimes);
                // }
                $scope.getDataList(1, 30, $scope.pid, $scope.phone, $scope.companyName, $scope.startTimes, $scope.endTimes);
            }

            //重置
            $scope.reset = function () {
                $scope.pid = null, $scope.phone = null, $scope.companyName = null, $scope.startTimes = "", $scope.endTimes = "";
            }

            layui.use(['laypage', 'layer'], function(){
                var laypage = layui.laypage,form = layui.form();

                var start = {
                    max: '2099-06-16 23:59:59'
                    ,istoday: false
                    ,choose: function(datas){
                        end.min = datas; //开始日选好后，重置结束日的最小日期
                        end.start = datas //将结束日的初始值设定为开始日
                    }
                };
                var end = {
                    max: '2099-06-16 23:59:59'
                    ,istoday: false
                    ,choose: function(datas){
                        start.max = datas; //结束日选好后，重置开始日的最大日期
                    }
                };
                document.getElementById('begin').onclick = function(){
                    start.elem = this;
                    laydate(start);
                }
                document.getElementById('end').onclick = function(){
                    end.elem = this
                    laydate(end);
                }

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
                                $scope.getDataList(obj.curr, 30, $scope.pid, $scope.phone, $scope.companyName, $scope.startTimes, $scope.endTimes);
                            }
                        }
                    });
                    form.render();
                }
            });

            //获取用户列表
            $scope.getDataList = function (pageNO, pageSize, pid, phone, companyName, startTimes, endTimes) {
                $scope.parameter = {
                    pid : pid,
                    phone : phone,
                    companyName : companyName,
                    startTimes : startTimes,
                    endTimes : endTimes,
                    pageNO : pageNO,
                    pageSize : pageSize
                }
                config.ajaxRequestData(false, "record/listForWebRecord", $scope.parameter, function (result) {
                    if (!$scope.isFirst) {
                        $scope.totalPage = result.data.count;
                        $scope.userList = result.data.dataList;
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
            //默认调用
            $scope.getDataList(1, 30, $scope.pid, $scope.phone, $scope.companyName,
               $("#begin").val(),$("#end").val());

            /**查看详情**/
            $scope.findDetail = function (id) {
                location.href = config.ip + "page/person/recordUserDetail?userId=" + id
            }

            /**学习情况列表**/
            $scope.curriculumList = function (id) {
                location.href = config.ip + "page/person/recordStudy?userId=" + id
            }

            /**考试记录列表**/
            $scope.examList = function (id) {
                location.href = config.ip + "page/person/recordExamRecord?userId=" + id
            }

            config.hideShade();

        });

    </script>
</body>
</html>

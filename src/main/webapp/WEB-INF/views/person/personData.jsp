<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>个人资料</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/person/personData.css">
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
                                    个人资料
                                </div>
                            </div>

                            <div class="user-info">
                                <form class="layui-form">

                                    <div class="layui-form-item">
                                        <label class="layui-form-label">头像</label>
                                        <div class="layui-input-inline">
                                            <div ng-show="userInfo.avatar == null" onclick="$('#File').click()" class="head-div" style="background: url('<%=request.getContextPath()%>/resources/img/default-head.png')">
                                                <div class="head-shade">修改头像</div>
                                            </div>
                                            <div ng-show="userInfo.avatar != null" onclick="$('#File').click()" class="head-div" style="background: url('{{ipImg}}{{userInfo.avatar}}')">
                                                <div class="head-shade">修改头像</div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="layui-form-item">
                                        <label class="layui-form-label" ng-if="userInfo.roleId == 4">姓名</label>
                                        <label class="layui-form-label" ng-if="userInfo.roleId == 3 || userInfo.roleId == 5">企业名称</label>
                                        <label class="layui-form-label" ng-if="userInfo.roleId == 2">机构名称</label>
                                        <div class="layui-input-inline">
                                            <input ng-if="userInfo.roleId == 4" class="layui-input personage" type="text" lay-verify="required|isEmoji" name="showName" value="{{userInfo.showName}}" placeholder="请输入您的姓名">
                                            <input ng-if="userInfo.roleId == 3 || userInfo.roleId == 5" class="layui-input company" type="text" lay-verify="required|isEmoji" name="showName" value="{{userInfo.showName}}" placeholder="请输入企业名称">
                                            <input ng-if="userInfo.roleId == 2" class="layui-input government" type="text" lay-verify="required|isEmoji" name="showName" value="{{userInfo.showName}}" placeholder="请输入机构名称">
                                        </div>
                                    </div>

                                    <div class="layui-form-item">
                                        <label class="layui-form-label" ng-if="userInfo.roleId == 4">身份证号</label>
                                        <label class="layui-form-label" ng-if="userInfo.roleId == 3 || userInfo.roleId == 5">营业执照编码</label>
                                        <label class="layui-form-label" ng-if="userInfo.roleId == 2">机构代码</label>
                                        <div class="layui-input-inline">
                                            <input class="layui-input" type="text" value="{{userInfo.pid}}" readonly>
                                        </div>
                                    </div>

                                    <div class="layui-form-item">
                                        <label class="layui-form-label">手机号码</label>
                                        <div class="layui-input-inline">
                                            <input class="layui-input" type="text" value="{{userInfo.phone}}" readonly>
                                        </div>
                                    </div>

                                    <div class="layui-form-item">
                                        <label class="layui-form-label">所在地</label>
                                        <div class="layui-input-inline layui-input-address">
                                            <select name="selectProvince" lay-verify="required" lay-search lay-filter="selectProvince">
                                                <option value="">选择省</option>
                                            </select>
                                        </div>
                                        <div class="layui-input-inline layui-input-address">
                                            <select name="selectCity" lay-search lay-filter="selectCity">
                                                <option value="">选择市</option>
                                            </select>
                                        </div>
                                        <div class="layui-input-inline layui-input-address">
                                            <select name="selectCounty" lay-search>
                                                <option value="">选择县/区</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="layui-form-item" ng-show="userInfo.roleId == 3  || userInfo.roleId == 5">
                                        <label class="layui-form-label">行业</label>
                                        <div class="layui-input-inline">
                                            <input class="layui-input" type="text" value="{{userInfo.tradeName}}" readonly>
                                        </div>
                                    </div>

                                    <div class="layui-form-item" ng-show="userInfo.roleId == 4">
                                        <label class="layui-form-label">所属公司</label>
                                        <div class="layui-input-inline">
                                            <input class="layui-input" type="text" ng-show="userInfo.companyName != null" value="{{userInfo.companyName}}" readonly>
                                            <input class="layui-input" type="text" ng-show="userInfo.companyName == null" value="暂无" readonly>
                                        </div>
                                    </div>

                                    <div class="layui-form-item" ng-show="userInfo.roleId == 4">
                                        <label class="layui-form-label">部门</label>
                                        <div class="layui-input-inline">
                                            <input class="layui-input" type="text" ng-show="userInfo.departmentName != null" value="{{userInfo.departmentName}}" readonly>
                                            <input class="layui-input" type="text" ng-show="userInfo.departmentName == null" value="暂无" readonly>
                                        </div>
                                    </div>

                                    <div class="layui-form-item" ng-show="userInfo.roleId == 4">
                                        <label class="layui-form-label">职位</label>
                                        <div class="layui-input-inline">
                                            <input class="layui-input" type="text" ng-show="userInfo.jobTitle != null" value="{{userInfo.jobTitle}}" readonly>
                                            <input class="layui-input" type="text" ng-show="userInfo.jobTitle == null" value="暂无" readonly>
                                        </div>
                                    </div>

                                    <div class="layui-form-item">
                                        <label class="layui-form-label">介绍</label>
                                        <div class="layui-input-inline">
                                            <textarea class="layui-textarea" lay-verify="isEmoji" name="introduce" placeholder="请输入介绍" maxlength="200">{{userInfo.introduce}}</textarea>
                                        </div>
                                    </div>

                                    <div class="layui-form-item">
                                        <label class="layui-form-label"></label>
                                        <div class="layui-input-inline">
                                            <button class="min-blue-button" lay-submit lay-filter="personInfo">保存</button>
                                        </div>
                                    </div>

                                    <input type="hidden" name="avatar" value="{{userInfo.avatar}}">

                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


<form id="newUpload" method="post" enctype="multipart/form-data">
    <input id="File" type="file" name="File" accept="image/*" class="hide">
    <input type="hidden" name="type" value="1">
</form>

<%@include file="../common/bottom.jsp" %>
<%@include file="../common/js.jsp" %>
<script src="<%=request.getContextPath()%>/resources/js/jquery.form.js" type="text/javascript" charset="UTF-8"></script>

<script>
    $("body").append(config.showShade("正在加载,请稍等..."));
    var roleId = 0;
    var webApp = angular.module('aiMaiApp', []);
    webApp.controller("controller", function($scope, $timeout) {
        $scope.userInfo = config.aiMaiUser();
        if ($scope.userInfo == null) {
            location.href = config.ip + "page/index";
        }
        $scope.ipImg = config.ipImg;
        roleId = $scope.userInfo.roleId;
        layui.use(['laypage', 'layer'], function() {
            var laypage = layui.laypage,form = layui.form();
            if ($scope.userInfo.cityJsonAry != null) {
                if ($scope.userInfo.cityJsonAry[0] == 0) {
                    selectProvince(100000); //加载省
                }
                else {
                    selectProvince($scope.userInfo.cityJsonAry[0]); //加载省
                }
                selectCity($scope.userInfo.cityJsonAry[0], $scope.userInfo.cityJsonAry[1]); //加载市
                selectCounty($scope.userInfo.cityJsonAry[1], $scope.userInfo.cityJsonAry[2]); //加载区
            }
            else {
                selectProvince(0);
            }

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

            //自定义验证规则
            form.verify({
                isEmoji: function(value) {
                    if(config.isEmoji.test(value)) {
                        return "不支持Emoji表情";
                    }
                },
            });

            form.render();

            //监听提交
            form.on('submit(personInfo)', function(data) {
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
                data.field.id = $scope.userInfo.id;
                config.log(data.field);
                config.ajaxRequestData(false, "user/updateUser", data.field, function (result) {
                    config.ajaxRequestData(false, "user/getInfo", null, function (result) {
                        sessionStorage.setItem("aiMaiUser", JSON.stringify(result.data));
                        $(".border-nei .userAvatar").css("background", "url(" + $scope.ipImg + data.field.avatar + ")"); //修改菜单上面的头像
                        $(".user-name").html(data.field.showName); //修改菜单上面的名字
                        layer.msg('保存成功.');
                    });
                });
            });

        });

        config.hideShade();

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
                            $(".head-div").css("background", "url(" + config.ipImg + result.data.url + ")");
                            $("input[name='avatar']").val(result.data.url);
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

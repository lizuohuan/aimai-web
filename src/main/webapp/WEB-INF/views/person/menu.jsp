<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/person/index.css">
<!-- left -->
<div class="float-left menu-left" ng-cloak>
    <div class="menu-bar">
        <div class="head-bar-div">
            <div class="user-head">
                <div class="border-wai">
                    <div class="border-nei">
                        <div ng-show="userInfo.avatar == null" class="userAvatar" style="background: url('<%=request.getContextPath()%>/resources/img/default-head.png')"></div>
                        <div ng-show="userInfo.avatar != null" class="userAvatar" style="background: url('{{ipImg}}{{userInfo.avatar}}')"></div>
                    </div>
                </div>
                <div class="user-name">{{userInfo.showName}}</div>
                <div ng-if="userInfo.roleId == 4" class="user-integral">我的积分：{{userInfo.accumulate}}</div>
            </div>
        </div>
        <ul class="tab-view">
            <li ng-show="userInfo.roleId == 2 || userInfo.roleId == 5">
                <a href="<%=request.getContextPath()%>/page/person/dataCount" url="person/dataCount">
                    <i class="icon-count"></i>
                    <span>统计数据</span>
                </a>
            </li>
            <li ng-show="userInfo.roleId == 3 || userInfo.roleId == 5">
                <a href="<%=request.getContextPath()%>/page/person/myCourseCompany" url="person/myCourseCompany">
                    <i class="icon-course"></i>
                    <span>我的课程</span>
                </a>
            </li>
            <li ng-show="userInfo.roleId == 3">
                <a href="<%=request.getContextPath()%>/page/person/recordCompany"
                   url="person/recordCompany,person/recordStudy,person/recordUserDetail,person/recordCourseware,person/recordFace,person/recordExamRecord">
                    <i class="icon-count"></i>
                    <span>统计数据</span>
                </a>
            </li>
            <li ng-show="userInfo.roleId == 5">
                <a href="<%=request.getContextPath()%>/page/person/recordCompany"
                   url="person/recordCompany,person/recordStudy,person/recordUserDetail,person/recordCourseware,person/recordFace,person/recordExamRecord">
                    <i class="icon-count"></i>
                    <span>档案管理</span>
                </a>
            </li>
            <li ng-show="userInfo.roleId == 4">
                <a href="<%=request.getContextPath()%>/page/person/myCourse" url="person/myCourse">
                    <i class="icon-course"></i>
                    <span>我的课程</span>
                </a>
            </li>
           <%-- <li ng-show="userInfo.roleId == 4">
                <a href="<%=request.getContextPath()%>/page/person/courseStudy" url="person/courseStudy">
                    <i class="icon-course"></i>
                    <span>课程学习</span>
                </a>
            </li>--%>
            <li ng-show="userInfo.roleId == 4">
                <a href="<%=request.getContextPath()%>/page/person/myExam" url="person/myExam">
                    <i class="icon-exam"></i>
                    <span>我的考题</span>
                </a>
            </li>
            <li ng-show="userInfo.roleId == 2 || userInfo.roleId == 5">
                <a href="<%=request.getContextPath()%>/page/person/companyList" url="person/companyList">
                    <i class="icon-list"></i>
                    <span>公司列表</span>
                </a>
            </li>
            <li ng-show="userInfo.roleId == 3 || userInfo.roleId == 5">
                <a href="<%=request.getContextPath()%>/page/person/userList" url="person/userList">
                    <i class="icon-list"></i>
                    <span>人员列表</span>
                </a>
            </li>
            <li ng-show="userInfo.roleId != 2">
                <a href="<%=request.getContextPath()%>/page/person/myOrder" url="person/myOrder">
                    <i class="icon-order"></i>
                    <span>我的订单</span>
                </a>
            </li>
            <li>
                <a href="<%=request.getContextPath()%>/page/person/myNews" url="person/myNews">
                    <i class="icon-news"></i>
                    <span>我的消息</span>
                </a>
            </li>
            <li ng-show="userInfo.roleId == 4">
                <a href="<%=request.getContextPath()%>/page/person/myCollect" url="person/myCollect">
                    <i class="icon-collect"></i>
                    <span>我的收藏</span>
                </a>
            </li>
            <%--<li ng-show="userInfo.roleId == 4">
                <a href="<%=request.getContextPath()%>/page/person/certificate" url="person/certificate">
                    <i class="icon-collect"></i>
                    <span>我的证书</span>
                </a>
            </li>--%>
            <li>
                <a href="<%=request.getContextPath()%>/page/person/personData" url="person/personData">
                    <i class="icon-data"></i>
                    <span>个人资料</span>
                </a>
            </li>
        </ul>
    </div>
</div>
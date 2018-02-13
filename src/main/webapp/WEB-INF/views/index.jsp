<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>首页</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <%@include file="common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/swiper.min.css"/>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/index.css"/>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/return.css"/>
    <style>
        .courseMenu{height: 190px !important}
        .more-type{position: absolute;top: 90px;z-index: 9;left: 50%;transform: translate(-50%, 0);height:0; }
    </style>
</head>
<body ng-app="aiMaiApp" ng-controller="controller">
<%@include file="common/top.jsp" %>
<div class="ai-content">

    <!--bannerWrap-->
    <div class="bannerWrap">
        <div class="banner">
            <div class="swiper-container">
                <div class="swiper-wrapper">
                    <div class="swiper-slide" ng-repeat="banner in bannerList">
                        <img ng-click="bannerInfo(banner)" src="{{ipImg}}{{banner.pcImage}}" ng-cloak/>
                    </div>
                    <%--<div class="swiper-slide" ng-repeat="banner in bannerList" ng-click="bannerInfo(banner)" style="background: url({{ipImg}}{{banner.pcImage}})">--%>
                    <%--</div>--%>
                </div>
                <div class="swiper-pagination"></div>
                <%--<div class="swiper-button-prev swiper-button-white"></div>--%>
                <%--<div class="swiper-button-next swiper-button-white"></div>--%>
            </div>
            <div class="container clearfix more-type">
                <div class="bannerNav">
                    <div class="clearfix">
                        <h3>全员培训</h3>
                        <hr />
                        <div class="bNavItem" ng-cloak>
                            <a href="javascript:void(0)" ng-repeat="trade in tradeList" ng-click="clickTrade(trade.id)" ng-if="$index < 5">{{trade.tradeName}}</a>
                            <a href="<%=request.getContextPath()%>/page/course/courseIndex?notTrade=1" target="_blank">更多</a>
                        </div>
                    </div>
                    <div class="clearfix">
                        <h3>三项培训</h3>
                        <hr />
                        <div class="bNavItem" ng-cloak>
                            <a href="javascript:void(0)" ng-repeat="trade in tradeList" ng-click="clickTrade(trade.id)" ng-if="$index < 5">{{trade.tradeName}}</a>
                            <a href="<%=request.getContextPath()%>/page/course/courseIndex?notTrade=1" target="_blank">更多</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!--试听课程-->
    <div class="courses">
        <div class="container">
            <div class="indexTitle">
                <h3>试听课程<br />
                    <span>Audition course</span>
                </h3>
            </div>
            <div class="swiper-container course-swiper">
                <div class="swiper-wrapper">
                    <div class="swiper-slide" ng-repeat="curriculum in curriculumByAudition" ng-cloak>
                        <a class="audition" href="javascript:void(0)" ng-click="courseVideo(curriculum.id)">
                            <div class="audition-course-cover" style="background: url('{{ipImg}}{{curriculum.cover}}');"></div>
                        </a>
                        <div class="coursesName">
                            <span class="duration">{{curriculum.lowSeconds}}</span>
                            <p><a href="#" alt="">{{curriculum.curriculumName}}</a></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- 课程列表 -->
    <div class="courseList" ng-cloak>
        <div class="container">
            <div class="indexTitle" style="margin-top: 30px;">
                <h3>推荐课程<br />
                    <span>Recommended course</span>
                </h3>
            </div>
            <div class="max-not-data" ng-show="recommendCurriculumList.length == 0">暂无推荐课程</div>
            <div class="courseBox clearfix ovh" ng-repeat="curriculum in recommendCurriculumList">
                <div class="courseFace">
                    <a href="javascript:void(0)" ng-click="courseDetail(curriculum.id)">
                        <i class="course-cover" style="background: url('{{ipImg}}{{curriculum.cover}}')"></i>
                    </a>
                </div>
                <div class="courseInfo">
                    <div class="mainName rel">
                        <h4>{{curriculum.curriculumName}}</h4>
                        <p><a>{{curriculum.videoNum}}</a>个视频课</p>
                        <span class="courseMoney">￥{{curriculum.price | number : 2}}</span>
                    </div>
                    <div class="ctab clearfix">
                        <div>
                            <i class="icon-inro"></i><span>介绍</span>
                        </div>
                        <div>
                            <i class="icon-list"></i><span>目录</span>
                        </div>
                        <div ng-click="clickEvaluate(curriculum.id, $event, 0)">
                            <i class="icon-comment" ng-click="clickEvaluate(curriculum.id, $event, 1)"></i>
                            <span ng-click="clickEvaluate(curriculum.id, $event, 1)">评论</span>
                        </div>
                    </div>
                    <div class="ctabBox rel">
                        <div class="courseIntro">
                            <h5>课程介绍</h5>
                            <div ng-bind-html="curriculum.curriculumDescribe | trustHtml"></div>
                            <p style="margin-bottom: 15px;">
                            <h5>讲师名称</h5>
                            <div ng-bind-html="curriculum.teacherName | trustHtml"></div>
                            </p>
                            <p style="margin-bottom: 15px;">
                            <h5>讲师介绍</h5>
                            <div ng-bind-html="curriculum.teacherIntroduce | trustHtml"></div>
                            </p>
                            <p>
                            <h5>适用人群</h5>
                            <div ng-bind-html="curriculum.applyPerson | trustHtml"></div>
                            </p>
                        </div>
                        <div class="courseMenu">
                            <ul>
                                <li ng-repeat="course in curriculum.courseWares">
                                    <a ng-repeat="video in course.videos">
                                        {{course.courseWareName}}：{{video.name}}
                                        <span>{{video.lowDefinitionSeconds}}</span>
                                    </a>
                                </li>
                            </ul>
                            <div class="min-not-data" ng-show="curriculum.courseWares == null || curriculum.courseWares.length == 0">暂无目录</div>
                        </div>
                        <div class="courseComment">

                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="container">
            <div class="indexTitle">
                <h3>全员安全认证证书<br />
                    <span>Total safety certification</span>
                </h3>
            </div>
            <div class="max-not-data" ng-show="curriculumAll.length == 0">暂无相关课程</div>
            <div class="courseBox clearfix ovh" ng-repeat="curriculum in curriculumAll">
                <div class="courseFace">
                    <a href="javascript:void(0)" ng-click="courseDetail(curriculum.id)">
                        <i class="course-cover" style="background: url('{{ipImg}}{{curriculum.cover}}')"></i>
                    </a>
                </div>
                <div class="courseInfo">
                    <div class="mainName rel">
                        <h4>{{curriculum.curriculumName}}</h4>
                        <p><a>{{curriculum.videoNum}}</a>个视频课</p>
                        <span class="courseMoney">￥{{curriculum.price | number : 2}}</span>
                    </div>
                    <div class="ctab clearfix">
                        <div>
                            <i class="icon-inro"></i><span>介绍</span>
                        </div>
                        <div>
                            <i class="icon-list"></i><span>目录</span>
                        </div>
                        <div ng-click="clickEvaluate(curriculum.id, $event, 0)">
                            <i class="icon-comment" ng-click="clickEvaluate(curriculum.id, $event, 1)"></i>
                            <span ng-click="clickEvaluate(curriculum.id, $event, 1)">评论</span>
                        </div>
                    </div>
                    <div class="ctabBox rel">
                        <div class="courseIntro">
                            <h5>课程介绍</h5>
                            <div ng-bind-html="curriculum.curriculumDescribe | trustHtml"></div>
                        </div>
                        <div class="courseMenu">
                            <ul>
                                <li ng-repeat="course in curriculum.courseWares">
                                    <a ng-repeat="video in course.videos">
                                        {{course.courseWareName}}：{{video.name}}
                                        <span>{{video.lowDefinitionSeconds}}</span>
                                    </a>
                                </li>
                            </ul>
                            <div class="min-not-data" ng-show="curriculum.courseWares == null || curriculum.courseWares.length == 0">暂无目录</div>
                        </div>
                        <div class="courseComment">

                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="container">
            <div class="indexTitle">
                <h3>三项认证<br />
                    <span>Three certifications</span>
                </h3>
            </div>
            <div class="max-not-data" ng-show="curriculumThreeNape.length == 0">暂无相关课程</div>
            <div class="courseBox clearfix ovh" ng-repeat="curriculum in curriculumThreeNape">
                <div class="courseFace">
                    <a href="javascript:void(0)" ng-click="courseDetail(curriculum.id)">
                        <i class="course-cover" style="background: url('{{ipImg}}{{curriculum.cover}}')"></i>
                    </a>
                </div>
                <div class="courseInfo">
                    <div class="mainName rel">
                        <h4>{{curriculum.curriculumName}}</h4>
                        <p><a>{{curriculum.videoNum}}</a>个视频课</p>
                        <span class="courseMoney">￥{{curriculum.price | number : 2}}</span>
                    </div>
                    <div class="ctab clearfix">
                        <div>
                            <i class="icon-inro"></i><span>介绍</span>
                        </div>
                        <div>
                            <i class="icon-list"></i><span>目录</span>
                        </div>
                        <div ng-click="clickEvaluate(curriculum.id, $event, 0)">
                            <i class="icon-comment" ng-click="clickEvaluate(curriculum.id, $event, 1)"></i>
                            <span ng-click="clickEvaluate(curriculum.id, $event, 1)">评论</span>
                        </div>
                    </div>
                    <div class="ctabBox rel">
                        <div class="courseIntro">
                            <h5>课程介绍</h5>
                            <div ng-bind-html="curriculum.curriculumDescribe | trustHtml"></div>
                        </div>
                        <div class="courseMenu">
                            <ul>
                                <li ng-repeat="course in curriculum.courseWares">
                                    <a ng-repeat="video in course.videos">
                                        {{course.courseWareName}}：{{video.name}}
                                        <span>{{video.lowDefinitionSeconds}}</span>
                                    </a>
                                </li>
                            </ul>
                            <div class="min-not-data" ng-show="curriculum.courseWares == null || curriculum.courseWares.length == 0">暂无目录</div>
                        </div>
                        <div class="courseComment">

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- 广告位 advertising-->
    <div class="container advertising rel">
        <div class="adTop" style="background: url('{{ipImg}}{{adTop.pcImage}}');" ng-click="bannerInfo(adTop)"></div>
        <div class="del abs"></div>
    </div>
    <!--新闻 news-->
    <div class="news">
        <div class="container rel">
            <div class="indexTitle">
                <h3>新闻资讯<br />
                    <span>Latest News</span>
                </h3>
            </div>
            <a href="<%=request.getContextPath()%>/page/news/news"><p class="more">查看更多</p></a>
        </div>
        <div class="container" ng-cloak>
            <ul class="newsMain clearfix">
                <li ng-repeat="news in newsList">
                    <a href="javascript:void(0)" ng-click="newsDetail(news)" class="news-cover-a block">
                        <div class="news-cover" style="background: url('{{ipImg}}{{news.image}}')"></div>
                    </a>
                    <div>
                        <h4>{{news.title}}</h4>
                        <p><a>{{news.digest}}</a></p>
                        <span>{{news.createTime | date : 'yyyy-MM-dd HH:mm:ss'}}</span>
                    </div>
                </li>
            </ul>
        </div>
    </div>
</div>

<!-- 广告位 advertising-->
<div class="container advertising rel">
    <div class="adTop" style="background: url('{{ipImg}}{{adBottom.pcImage}}');" ng-click="bannerInfo(adBottom)"></div>
    <div class="del abs"></div>
</div>
<!-- 广告位 advertising-->
<div class="advertising fixed">
    <div class="adLeft" style="background: url('{{ipImg}}{{adLeft.pcImage}}');" ng-click="bannerInfo(adLeft)"></div>
    <div class="del abs"></div>
</div>

<div class="index-menu">
    <span class="ribbon"></span>
    <div class="index-menu-item">
        <div class="subitem">
            <a href="<%=request.getContextPath()%>/page/about/aboutUs" target="_blank">
                <i class="cu-icon"></i>
                <p><span style="display: block">联系<br>我们</span></p>
            </a>
        </div>
    </div>
    <div class="index-menu-item">
        <div class="subitem">
            <i class="phone-icon"></i>
            <p><span>APP</span></p>
        </div>
        <div class="show-modal">
            <div id="qrCode"></div>
            <p>扫描下载客户端APP</p>
            <span class="triangle"></span>
        </div>
    </div>
    <div class="index-menu-item">
        <div class="subitem">
            <i class="wechat-icon"></i>
            <p><span>微信</span></p>
        </div>
        <div class="show-modal">
            <img src="<%=request.getContextPath()%>/resources/img/wechat-qr.jpg"/>
            <p>扫描关注微信公众号</p>
            <span class="triangle"></span>
        </div>
    </div>
    <div class="index-menu-item">
        <div class="subitem">
            <a id="officialWebsite" href="" target="_blank">
                <i class="ie-icon"></i>
                <p><span>官网</span></p>
            </a>
        </div>
    </div>
    <div id="returnBtn" class="return-btn">
        <span>返回<br>顶部</span>
    </div>
</div>

<%@include file="common/bottom.jsp" %>
<%@include file="common/js.jsp" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/swiper.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/jquery.qrcode.icon.js"></script>
<script>

    var webApp = angular.module('aiMaiApp', []);
    webApp.controller("controller", function($scope, $timeout) {
        $scope.userInfo = config.aiMaiUser();
        $scope.ipImg = config.ipImg;
        $scope.bannerList = null; //轮播列表
        $scope.adTop = null; //广告
        $scope.adLeft = null; //广告
        $scope.adBottom = null; //广告
        $scope.curriculumByAudition = null; //试听课程
        $scope.recommendCurriculumList = null; //推荐课程
        $scope.curriculumAll = null; //全员课程
        $scope.curriculumThreeNape = null; //三项课程
        $scope.tradeList = null; //行业
        var parameter = {
            pageNO : 1,
            pageSize : 1000
        }
        //获取课程
        config.ajaxRequestData(false, "curriculum/queryCurriculumByItems", parameter, function (result) {
            $scope.curriculumByAudition = result.data.curriculumByAudition;
            for (var i = 0; i < $scope.curriculumByAudition.length; i++) {
                var obj = $scope.curriculumByAudition[i];
                obj.lowSeconds = config.getFormatTime(obj.lowSeconds);
            }
            $scope.recommendCurriculumList = result.data.recommendCurriculumList;
            if ($scope.recommendCurriculumList.courseWares != null) {
                for (var i = 0; i < $scope.recommendCurriculumList.courseWares.length; i++) {
                    var courseWares = $scope.recommendCurriculumList.courseWares[i];
                    for (var j = 0; j < courseWares.videos.length; j++) {
                        var video = courseWares.videos[j];
                        video.highDefinitionSeconds = config.getFormatTime(video.highDefinitionSeconds);
                        video.lowDefinitionSeconds = config.getFormatTime(video.lowDefinitionSeconds);
                    }
                }
            }
            $scope.curriculumAll = result.data.curriculumTypes[0].curriculumList;
            if ($scope.curriculumAll.courseWares != null) {
                for (var i = 0; i < $scope.curriculumAll.courseWares.length; i++) {
                    var courseWares = $scope.curriculumAll.courseWares[i];
                    for (var j = 0; j < courseWares.videos.length; j++) {
                        var video = courseWares.videos[j];
                        video.highDefinitionSeconds = config.getFormatTime(video.highDefinitionSeconds);
                        video.lowDefinitionSeconds = config.getFormatTime(video.lowDefinitionSeconds);
                    }
                }
            }
            $scope.curriculumThreeNape = result.data.curriculumTypes[1].curriculumList;
            if ($scope.curriculumThreeNape.courseWares != null) {
                for (var i = 0; i < $scope.curriculumThreeNape.courseWares.length; i++) {
                    var courseWares = $scope.curriculumThreeNape.courseWares[i];
                    for (var j = 0; j < courseWares.videos.length; j++) {
                        var video = courseWares.videos[j];
                        video.highDefinitionSeconds = config.getFormatTime(video.highDefinitionSeconds);
                        video.lowDefinitionSeconds = config.getFormatTime(video.lowDefinitionSeconds);
                    }
                }
            }
        });

        //获取行业
        config.ajaxRequestData(false, "trade/queryTrade", parameter, function (result) {
            $scope.tradeList = result.data;
        });

        //获取banner
        config.ajaxRequestData(false, "banner/queryBannerList", parameter, function (result) {
            $scope.bannerList = result.data;
        });

        //获取广告
        config.ajaxRequestData(false, "banner/adList", parameter, function (result) {
            for (var i = 0; i < result.data.length; i++) {
                var obj = result.data[i];
                if (obj.location == 1) $scope.adTop = obj;
                if (obj.location == 2) $scope.adLeft = obj;
                if (obj.location == 3) $scope.adBottom = obj;
            }
        });

        //免费课程跳转视频播放
        $scope.courseVideo = function (curriculumId) {
            sessionStorage.setItem("curriculumId", curriculumId);
            sessionStorage.setItem("isAudition", 1);
            window.open(config.ip + "page/course/courseWatch");
        }

        //课程详情
        $scope.courseDetail = function (curriculumId) {
            config.ajaxRequestData(false, "curriculum/isBuy", {curriculumId : curriculumId}, function (result) {
                if (result.data == 0) {
                    sessionStorage.setItem("curriculumId", curriculumId);
                    window.open(config.ip + "page/course/courseDetail");
                }
                else if (result.data == -1) {
                    if ($scope.userInfo.roleId == 4) {
                        layer.alert('您已经购买过该课程，可以直接观看', {
                            title: "温馨提示",
                            skin: 'layui-layer-molv' //样式类名
                            ,closeBtn: 0
                            ,anim: 3 //动画类型
                        }, function(){
                            location.href = config.ip + "page/person/myCourse";
                        });
                    }
                    else {
                        window.open(config.ip + "page/course/courseDetail");
                    }
                }
                else if (result.data == -2) {
                    layer.alert('该课程订单已存在，请直接付款', {
                        title: "温馨提示",
                        skin: 'layui-layer-molv' //样式类名
                        ,closeBtn: 0
                        ,anim: 3 //动画类型
                    }, function(){
                        location.href = config.ip + "page/person/myOrder";
                    });
                }
            });
        }

        //筛选培训
        $scope.clickTrade = function (tradeId) {
            sessionStorage.setItem("tradeId", tradeId);
            window.open(config.ip + "page/course/courseIndex");
        }

        //评论列表
        $scope.queryEvaluate = function (pageNO, pageSize, curriculumId, element) {
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
                $(element).html(html);
            });
        }

        //单击获取评论
        $scope.clickEvaluate = function (curriculumId, event, type) {
            var $obj = event.target;
            if ($($obj).attr("isClick") != 1){
                var obj = null;
                if (type == 0) {
                    obj = $($obj).parent().parent().find(".courseComment");
                }
                else {
                    obj = $($obj).parent().parent().parent().find(".courseComment");
                }
                $scope.queryEvaluate(1, 10, curriculumId, obj);
                $($obj).attr("isClick", 1);
            }
        }

        $scope.newsList = null;
        $scope.getDataList = function (pageNO, pageSize) {
            $scope.parameter = {
                pageNO : pageNO,
                pageSize : pageSize
            }
            config.ajaxRequestData(false, "news/queryNewsList", $scope.parameter, function (result) {
                $scope.newsList = result.data.dataList;
            });
        }
        //默认调用
        $scope.getDataList(1, 4);

        //资讯详情
        $scope.newsDetail = function (news) {
            if (news.isLink == 0) {
                window.open(config.ip + "page/news/newsDetail?newsId=" + news.id);
            }
            else {
                window.open(news.linkUrl);
            }
        }

        //banner详情
        $scope.bannerInfo = function (banner) {
            sessionStorage.removeItem("curriculumId");
            sessionStorage.removeItem("isAudition");
            if (banner.isLink == 0) {
                window.open(config.ip + "page/news/newsDetail?bannerId=" + banner.id + "&type=1");
            }
            else {
                window.open(banner.linkUrl);
            }
        }


    });
    //富文本过滤器
    webApp.filter('trustHtml', ['$sce',function($sce) {
        return function(val) {
            return $sce.trustAsHtml(val);
        };
    }]);

    /*/!**加载loading**!/
    $(document).ready(function(){
        $("body").append(config.showShade("正在加载,请稍等..."));
    });
    /!**加载完成关闭**!/
    window.onload = function () {
        config.hideShade();
    }*/

    var swiperBanner = new Swiper('.banner .swiper-container', {
        pagination: '.banner .swiper-pagination',
        paginationClickable: '.banner .swiper-pagination',
        centeredSlides: true,
        autoplay: 3000,
        //nextButton: '.swiper-button-next',
        //prevButton: '.swiper-button-prev',
        observer:true,//修改swiper自己或子元素时，自动初始化swiper
        observeParents:true,//修改swiper的父元素时，自动初始化swiper
        onlyExternal: true //禁止滑动
    });

    var swiperCourses = new Swiper('.courses .swiper-container', {
        slidesPerView: 3,
        paginationClickable: true,
        autoplay: 3000 ,
        autoplayDisableOnInteraction: false,
        spaceBetween:45,
        grabCursor: true,
        observer:true,//修改swiper自己或子元素时，自动初始化swiper
        observeParents:true,//修改swiper的父元素时，自动初始化swiper
    });
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
    //删除广告
    $(".advertising").on("click",".del",function(){
        $(this).parent().animate({height:0},300,"swing");
        var ad = $(this).parent();
        setTimeout(function(){
            ad.remove();
        },299);
    });


    /*返回顶部特效*/
    $(function() {
        $(window).on('scroll', function() {
            var scrollTop = $(document).scrollTop();
            if(scrollTop > 0) {
                $("#returnBtn span").fadeIn();
            } else {
                $("#returnBtn span").fadeOut();
            }
        });

        //单击返回顶部
        $('#returnBtn').on('click', function() {
            $('html,body').animate({
                'scrollTop': 0
            }, 300);
        });

        $(".index-menu-item").each(function () {
            $(this).mouseover(function () {
                $(".index-menu-item .subitem p span").hide();
                $(this).find(".subitem p span").show();
                $(".ribbon").stop();
                $(".ribbon").animate({
                    top: $(this).height() * ($(this).index() - 1)
                }, 200);
            });
        });
    });

    /**生成二维码**/
    $(document).ready(function() {
        $('#qrCode').qrcode({
            text: config.ipApi + "page/app/download",
            height: 120,
            width: 120,
            src: config.ip + "resources/img/qr-logo.png",
        });
    });

</script>
</body>
</html>

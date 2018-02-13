<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>新闻详情</title>
    <%@include file="../common/css.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/news/news.css"/>
</head>
<body ng-app="aiMaiApp" ng-controller="controller" ng-cloak>
<%@include file="../common/top.jsp" %>
<div class="ai-content">

    <!--新闻 news-->
    <div class="news">
        <div class="container">
            <div class="position">
                <span><a href="<%=request.getContextPath()%>/page/index">首页</a></span><span>></span><span><a href="<%=request.getContextPath()%>/page/news/news">新闻列表</a></span><span>></span><span>新闻标题</span>
            </div>
        </div>
        <div class="container clearfix">
            <div class="newsMainDetail">
                <div class="newsTop rel">
                    <h3>{{news.title}}</h3>
                    <div class="clearfix">
                        <span>{{news.createTime | date : 'yyyy-MM-dd HH:mm:ss'}}</span>
                        <span>{{news.source}}</span>
                        <span class="blue">{{news.editor}}</span>
                    </div>
                    <div class="operate abs">
                        <div class="collect" ng-click="collect()" ng-show="userInfo.roleId == 4 && type != 1 || userInfo == null">
                            <i></i>
                            <p>收藏</p>
                        </div>
                        <div id="share">
                            <i></i>
                            <p>分享</p>
                            <div class="bshare-custom" style="opacity: 1;">
                                <a title="分享到QQ" class="bshare-qqim">QQ</a>
                                <a title="分享到QQ空间" class="bshare-qzone">QQ空间</a>
                                <a title="分享到微信" class="bshare-weixin">微信</a>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="content">
                    <!--富文本编辑内容-->
                    <div id="editor" style="font-size: 14px;line-height: 1.6em;">
                        <div ng-bind-html="news.content | trustHtml"></div>
                    </div>
                </div>
            </div>
            <div class="newsRightList newsMain">
                <h3>推荐新闻</h3>
                <div class="not-data" ng-show="newsList == null || newsList.length == 0">暂无推荐新闻</div>
                <ul>
                    <li ng-repeat="news in newsList">
                        <div>
                            <a href="javascript:void(0)" ng-click="newsDetail(news)" class="block">
                                <div class="news-cover" style="background: url('{{ipImg}}{{news.image}}')"></div>
                                <h4>{{news.title}}</h4>
                            </a>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</div>

<%@include file="../common/bottom.jsp" %>
<%@include file="../common/js.jsp" %>
<script type="text/javascript" charset="utf-8" src="http://static.bshare.cn/b/buttonLite.js#uuid=&amp;&style=-1"></script>
<script type="text/javascript" charset="utf-8" src="http://static.bshare.cn/b/bshareC1.js"></script>

<script>
    $("body").append(config.showShade("正在加载,请稍等..."));

    var webApp = angular.module('aiMaiApp', []);
    webApp.controller("controller", function($scope, $timeout) {
        $scope.userInfo = config.aiMaiUser();
        $scope.ipImg = config.ipImg;
        $scope.newsId = config.getUrlParam("newsId");
        $scope.type = config.getUrlParam("type");
        $scope.bannerId = config.getUrlParam("bannerId");
        $scope.news = null;
        $scope.newsList = null;
        $scope.parameter = {
            isRecommend : 1,
            pageNO : 1,
            pageSize : 10
        }
        //获取推荐列表
        config.ajaxRequestData(false, "news/queryNewsOfIsRecommend", $scope.parameter, function (result) {
            $scope.newsList = result.data;
        });

        //获取详情
        $scope.newsInfo = function (newsId) {
            config.ajaxRequestData(false, "news/info", {id : newsId}, function (result) {
                $timeout(function () {
                    $scope.news = result.data;
                    setTimeout(function () {
                        $("#content").find("video").attr("controls", "controls");
                        $("#editor").find("img").each(function () {
                            $(this).attr("src", "http://icloud.aimaiap.com/" + $(this).attr("src"));
                        });
                        $("#editor").find("video").each(function () {
                            $(this).attr("src", "http://icloud.aimaiap.com/" + $(this).attr("src"));
                        });
                    }, 100);
                });
            });
        }
        if ($scope.type == null && $scope.bannerId == null && $scope.newsId != null) {
            $scope.newsInfo($scope.newsId);
        }

        //获取banner详情
        if ($scope.type == 1 && $scope.newsId == null) {
            config.ajaxRequestData(false, "banner/queryBannerById", {bannerId : $scope.bannerId}, function (result) {
                $scope.news = result.data;
            });
        }

        //收藏
        $scope.collect = function () {
            var parameter = {
                type : 0,
                targetId : $scope.newsId
            }
            config.ajaxRequestData(false, "collect/addCollect", parameter, function () {
                $(".collect").click(function(){
                    $(this).addClass("act");
                })
                layer.msg("收藏成功.");
            });
        }

        //推荐点击
        $scope.newsDetail = function (news) {
            if (news.isLink == 0) {
                $scope.newsInfo(news.id);
            }
            else {
                window.open(news.linkUrl);
            }
        }

        $(function () {

        });

        config.hideShade();

    });
    //富文本过滤器
    webApp.filter('trustHtml', ['$sce',function($sce) {
        return function(val) {
            $("#editor").html(val);
            return $sce.trustAsHtml(val);
        };
    }]);

</script>
</body>
</html>

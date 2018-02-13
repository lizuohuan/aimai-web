<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/jquery-2.1.0.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/bootstrap.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/layui/lay/dest/layui.all.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/angular.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/config.js"></script>

<script>
    console.log('%c欢迎使用爱麦安培', 'background-image:-webkit-gradient( linear, left top, right top, color-stop(0, #f22), color-stop(0.15, #f2f), color-stop(0.3, #22f), color-stop(0.45, #2ff), color-stop(0.6, #2f2),color-stop(0.75, #2f2), color-stop(0.9, #ff2), color-stop(1, #f22) );color:transparent;-webkit-background-clip: text;font-size:5em;');
    config.log("******************登录人信息*********************");
    config.log(config.aiMaiUser());
    config.log("******************登录人信息*********************");

    $(function() {
        //设置右侧高度和左侧菜单统一
        $(".content-right").css("minHeight", $(".menu-bar").height());

        //选中个人中心菜单
        var path = window.location.href;
        $(".tab-view a").each(function () {
            var url = $(this).attr("url").split(",");
            for (var i = 0; i < url.length; i++) {
                if (path.indexOf(url[i]) != -1) {
                    $(this).addClass("menu-left-active");
                    break;
                }
            }
        });
        //选中导航条
        $(".layui-nav-item").each(function () {
            var url = $(this).attr("url");
            if (path.indexOf(url) != -1) {
                $(this).addClass("layui-this");
            }
        });

        //导航条个人中心
        $(".topbar-info").mouseover(function () {
            $(this).find(".user-menu").stop(); //避免闪动
            $(this).addClass("user-active");
            $(this).find(".user-menu").slideDown(200);
        }).mouseout(function () {
            $(this).find(".user-menu").stop();
            $(this).removeClass("user-active");
            $(this).find(".user-menu").slideUp(200);
        });

        //设置logo
        config.ajaxRequestData(false, "company/info", {}, function (result) {
            $("#companyLogo").attr("src", config.ipImg + result.data.logo);
            $("#officialWebsite").attr("href", result.data.url);
        });

        //解决底部问题 -- 减去top or bottom height and margin
        $(".ai-content").css("min-height", (document.documentElement.clientHeight - 240) + "px");

    });
</script>

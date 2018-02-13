var config = function () {};
config.prototype = {
	ip: 'http://' + window.location.host + '/web/',
	//ipImg: 'http://multimedia.aimaiap.com/images/',
	//ipVideo: 'http://multimedia.aimaiap.com/video/',
	ipImg: 'http://192.168.31.110:8080/images/',
	ipVideo: 'http://192.168.31.110:8080/video/',
	ipAdmin: 'http://icloud.aimaiap.com/admin/',
	ipApi: 'http://app.aimaiap.com/api/',
	ipUrl: location.href.split('#')[0],
	//是否开启测试模式
	isDebug : true,
	//手机号码正则表达式
	isMobile : /^(((13[0-9]{1})|(18[0-9]{1})|(17[6-9]{1})|(15[0-9]{1}))+\d{8})$/,
	//电话号码正则表达式
	isPhone : /[0-9-()（）]{7,18}/,
	//身份证正则表达式
	isIdentityCard :   /^\d{15}(\d{2}[\d|X])?$/,
	//6-16的密码
	isPwd : /[A-Za-z0-9]{6,16}/,
	//输入的是否为数字
	isNumber : /^[0-9]*$/,
	//检查小数
	isDouble : /^\d+(\.\d+)?$/,
	//输入的只能为数字和字母
	isNumberChar: /[A-Za-z0-9]{3,16}/,
	//用户名
	isUserName : /[\w\u4e00-\u9fa5]/,
	//emoji 表情正则
	isEmoji : /\uD83C[\uDF00-\uDFFF]|\uD83D[\uDC00-\uDE4F]/g,
	//验证邮箱
	isEmail : /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/,
	//只能输入汉字
	isChinese : /[\u4e00-\u9fa5]/gm,
	//EyeKey APP ID
	eyeKeyAppId : "290e756d69154ba4b82e88d99c7e4740",
	//EyeKey APP KEY
	eyeKeyAppKey : "e656befe4be64bd8836e707ab5cbc76d",
	//控制台打印输出
	log : function (obj) {
		if (config.isDebug) console.log(obj);
	},
	//获取url中的参数
	getUrlParam : function(name) {
		var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
		var r = window.location.search.substr(1).match(reg); //匹配目标参数
		if(r != null){
			return unescape(r[2]);
		}else{
			return null; //返回参数值
		}
	},
	//时间戳转日期
	timeStampConversion : function (timestamp){
		var d = new Date(timestamp);    //根据时间戳生成的时间对象
		var date = (d.getFullYear()) + "-" +
			(d.getMonth() + 1) + "-" +
			(d.getDate())+ " " +
			(d.getHours()) + ":" +
			(d.getMinutes()) + ":" +
			(d.getSeconds());
		return date;
	},
	//日期转换为时间戳
	getTimeStamp : function (time){
		time=time.replace(/-/g, '/');
		var date=new Date(time);
		return date.getTime();
	},
	//秒计算出分钟数
	getFormatTime: function(time) {
		var time = time;
		var h = parseInt(time / 3600),
			m = parseInt(time % 3600 / 60),
			s = parseInt(time % 60);
		h = h < 10 ? "0" + h : h;
		m = m < 10 ? "0" + m : m;
		s = s < 10 ? "0" + s : s;

		h = h == NaN ? "00" : h;
		m = m == NaN ? "00" : m;
		s = s == NaN ? "00" : s;
		if (h == "00") {
			return m + ":" + s;
		}
		return h + ":" + m + ":" + s;
	},
	//秒计算出分钟数--汉字
	getFormat: function (value) {
		var theTime = parseInt(value);// 秒
		var theTime1 = 0;// 分
		var theTime2 = 0;// 小时
		if(theTime > 60) {
			theTime1 = parseInt(theTime/60);
			theTime = parseInt(theTime%60);
			if(theTime1 > 60) {
				theTime2 = parseInt(theTime1/60);
				theTime1 = parseInt(theTime1%60);
			}
		}
		var result = ""+parseInt(theTime)+"秒";
		if(theTime1 > 0) {
			result = ""+parseInt(theTime1)+"分"+result;
		}
		if(theTime2 > 0) {
			result = ""+parseInt(theTime2)+"小时"+result;
		}
		return result;
	},
	//获取时间格式
	getCountTime : function (createTime, dateTimeStamp) {
		var minute = 1000 * 60;
		var hour = minute * 60;
		var day = hour * 24;
		var halfamonth = day * 15;
		var month = day * 30;
		var result = "";
		var now = dateTimeStamp;
		var diffValue = now - createTime;
		/*if(diffValue < 0){
			alert("时间计算出错！");
		}*/
		var monthC =diffValue/month;
		var weekC =diffValue/(7*day);
		var dayC =diffValue/day;
		var hourC =diffValue/hour;
		var minC =diffValue/minute;
		if(monthC>=1){
			result = parseInt(monthC) + "个月前";
		}
		else if(weekC>=1){
			result = parseInt(weekC) + "周前";
		}
		else if(dayC>=1){
			result = parseInt(dayC) +"天前";
		}
		else if(hourC>=1){
			result = parseInt(hourC) +"小时前";
		}
		else if(minC>=1){
			result = parseInt(minC) +"分钟前";
		}else
			result="1分钟前";
		return result;

	},
	//自定义四舍五入
	getRound : function (floatvar) {
		var f_x = parseFloat(floatvar);
		if (isNaN(f_x)){
			return '0.00';
		}
		var f_x = Math.round(f_x*100)/100;
		var s_x = f_x.toString();
		var pos_decimal = s_x.indexOf('.');
		if (pos_decimal < 0){
			pos_decimal = s_x.length;
			s_x += '.';
		}
		while (s_x.length <= pos_decimal + 2){
			s_x += '0';
		}
		return s_x;
	},
	//返回上一页并刷新，在需要刷新的页面调用
	reload : function () {
		window.onpageshow = function (event) {
			if (event.persisted) {
				window.location.reload();
			}
		}
	},
	//显示遮罩
	showShade : function (context) {
		var loading = '<div class="loader-inner ball-clip-rotate-multiple"><div></div><div></div></div>';
		var html = 	"<div class=\"loading-whiteMask\" style=\"display: block\">" +
				"	<div class=\"loading-bar\">" +
				"		<div class=\"mui-row\">" +
				"			<div class=\"mui-col-xs-12 mui-col-sm-12\">" +
				"				<div class=\"loadingImg\">" + loading + "</div>" +
				"				<span class=\"loading-hint\">" + context + "</span>" +
				"			</div>" +
				"		</div>" +
				"	</div>" +
				"</div>";
		return html;
	},
	//关闭遮罩
	hideShade : function () {
		$(".loading-whiteMask").remove();
	},
	//判断是否是json对象
	isJson : function (obj){
		var isjson = typeof(obj) == "object" && Object.prototype.toString.call(obj).toLowerCase() == "[object object]" && !obj.length;
		return isjson;
	},
	//获取登录人信息
	aiMaiUser : function () {
		var aiMaiUser = JSON.parse(sessionStorage.getItem("aiMaiUser"));
		return aiMaiUser;
	},
	//输入框输入只保留两位小数
	clearNoNum : function (obj) {
		//先把非数字的都替换掉，除了数字和.
		obj.value = obj.value.replace(/[^\d.]/g,"");
		//保证只有出现一个.而没有多个.
		obj.value = obj.value.replace(/\.{2,}/g,".");
		//必须保证第一个为数字而不是.
		obj.value = obj.value.replace(/^\./g,"");
		//保证.只出现一次，而不能出现两次以上
		obj.value = obj.value.replace(".","$#$").replace(/\./g,"").replace("$#$",".");
		//只能输入两个小数
		obj.value = obj.value.replace(/^(\-)*(\d+)\.(\d\d).*$/,'$1$2.$3');
	},
	//ajax请求数据  get/post方式
	ajaxRequestData : function(async, requestUrl, arr, callback){
		if (arr != null) arr.isWechat = 0;
		config.log("************请求参数**************");
		config.log(arr);
		config.log("************请求参数**************");
		$.ajax({
			type: "POST",
			async: async,
			url: config.ip + requestUrl,
			data: arr,
			//dataType:"jsonp",    //跨域json请求一定是jsonp
			headers: {
				"token" : config.aiMaiUser() == null ? null : config.aiMaiUser().token,
			},
			success:function(json){
				if (!config.isJson(json)) {
					json = JSON.parse(json);
				}
				config.log("************config  --接口地址： "+ requestUrl +"-- **************");
				config.log(json);
				config.log("************config**************");
				if(json.flag == 0 && json.code == 200){
					if (callback) {
						callback(json);
					}
				}
				else if(json.code == 1005){
					sessionStorage.removeItem("aiMaiUser");
					var index = layer.confirm('未登录，是否跳转登录页面？', {
						btn: ['确定','取消']
						,closeBtn: 0
						,anim: 1
						,title: "温馨提示"
					}, function(){
						location.href = config.ip + "page/login";
						sessionStorage.setItem("url", window.location.href);
						layer.close(index);
					}, function(){
						location.href = config.ip + "page/index";
					});
				}
				else if (json.code == 1010) {
					layer.msg(json.msg);
				}
				else {
					layer.msg(json.msg);
				}
			},
			error: function(json) {
				layer.msg(json.responseText);
			}
		})
	},
};

var config = new config();

//转时间戳
Date.prototype.format = function (fmt) { //author: meizz
	var o = {
		"M+": this.getMonth() + 1, //月份
		"d+": this.getDate(), //日
		"h+": this.getHours(), //小时
		"m+": this.getMinutes(), //分
		"s+": this.getSeconds(), //秒
		"q+": Math.floor((this.getMonth() + 3) / 3), //季度
		"S": this.getMilliseconds() //毫秒
	};
	if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
	for (var k in o)
		if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
	return fmt;
}

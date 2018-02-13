package com.magic.aimai.controller;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 *  页面控制器
 */
@Controller
@RequestMapping("/page")
@Api(hidden = true)
public class PageController {


    /***************************************首页模块**************************************/

    /**
     *首页
     * @return
     */
    @RequestMapping("/index")
    @ApiOperation(value = "",hidden = true)
    public String index () { return "/index"; }

    /**
     *新闻列表
     * @return
     */
    @RequestMapping("/news/news")
    @ApiOperation(value = "",hidden = true)
    public String news () { return "/news/news"; }

    /**
     *新闻详情
     * @return
     */
    @RequestMapping("/news/newsDetail")
    @ApiOperation(value = "",hidden = true)
    public String newsDetail () { return "/news/newsDetail"; }

    /**
     *课程详情
     * @return
     */
    @RequestMapping("/course/courseDetail")
    @ApiOperation(value = "",hidden = true)
    public String courseDetail () { return "/course/courseDetail"; }

    /**
     *查找课程
     * @return
     */
    @RequestMapping("/course/courseIndex")
    @ApiOperation(value = "",hidden = true)
    public String courseIndex () { return "/course/courseIndex"; }

    /**
     *查看课程
     * @return
     */
    @RequestMapping("/course/courseWatch")
    @ApiOperation(value = "",hidden = true)
    public String courseWatch () { return "/course/courseWatch"; }

    /**
     *test
     * @return
     */
    @RequestMapping("/course/test")
    @ApiOperation(value = "",hidden = true)
    public String test () { return "/course/test"; }

    /**
     *支付回调
     * @return
     */
    @RequestMapping("/course/paymentResult")
    @ApiOperation(value = "",hidden = true)
    public String paymentResult () { return "/course/paymentResult"; }

    /***************************************首页模块**************************************/



    /***************************************关于我们模块**************************************/

    /**
     *关于我们
     * @return
     */
    @RequestMapping("/about/aboutUs")
    @ApiOperation(value = "",hidden = true)
    public String aboutUs () { return "/about/aboutUs"; }

    /**
     *资质
     * @return
     */
    @RequestMapping("/about/honor")
    @ApiOperation(value = "",hidden = true)
    public String honor () { return "/about/honor"; }

    /**
     *平台
     * @return
     */
    @RequestMapping("/about/terrace")
    @ApiOperation(value = "",hidden = true)
    public String terrace () { return "/about/terrace"; }

    /**
     *安巡
     * @return
     */
    @RequestMapping("/about/polling")
    @ApiOperation(value = "",hidden = true)
    public String polling () { return "/about/polling"; }

    /**
     *意见反馈
     * @return
     */
    @RequestMapping("/about/suggest")
    @ApiOperation(value = "",hidden = true)
    public String suggest () { return "/about/suggest"; }

    /***************************************关于我们模块**************************************/



    /***************************************登录模块**************************************/

    /**
     * 登录页面
     * @return
     */
    @RequestMapping("/login")
    @ApiOperation(value = "",hidden = true)
    public String login () { return "/login/login"; }

    /**
     * 注册 -- 1
     * @return
     */
    @RequestMapping("/registerPhone")
    @ApiOperation(value = "",hidden = true)
    public String registerPhone () { return "/login/registerPhone"; }

    /**
     * 注册 -- 2
     * @return
     */
    @RequestMapping("/registerData")
    @ApiOperation(value = "",hidden = true)
    public String registerData () { return "/login/registerData"; }

    /**
     * 找回密码
     * @return
     */
    @RequestMapping("/retrievePassword")
    @ApiOperation(value = "",hidden = true)
    public String retrievePassword () { return "/login/retrievePassword"; }

    /**
     * 补全信息
     * @return
     */
    @RequestMapping("/complementData")
    @ApiOperation(value = "",hidden = true)
    public String complementData () { return "/login/complementData"; }


    /***************************************登录模块**************************************/


    /***************************************个人中心模块**************************************/

    /**
     * 公司详情
     * @return
     */
    @RequestMapping("/person/companyInfo")
    @ApiOperation(value = "",hidden = true)
    public String personCompanyInfo () { return "/person/companyInfo"; }

    /**
     * 公司列表
     * @return
     */
    @RequestMapping("/person/companyList")
    @ApiOperation(value = "",hidden = true)
    public String personCompanyList () { return "/person/companyList"; }

    /**
     * 统计数据
     * @return
     */
    @RequestMapping("/person/dataCount")
    @ApiOperation(value = "",hidden = true)
    public String personDataCount () { return "/person/dataCount"; }

    /**
     * 我的课程
     * @return
     */
    @RequestMapping("/person/myCourse")
    @ApiOperation(value = "",hidden = true)
    public String personMyCourse () { return "/person/myCourse"; }

    /**
     * 我的课程--公司
     * @return
     */
    @RequestMapping("/person/myCourseCompany")
    @ApiOperation(value = "",hidden = true)
    public String personMyCourseCompany () { return "/person/myCourseCompany"; }

    /**
     * 课程学习
     * @return
     */
    @RequestMapping("/person/courseStudy")
    @ApiOperation(value = "",hidden = true)
    public String personCourseStudy () { return "/person/courseStudy"; }

    /**
     * 我的考题
     * @return
     */
    @RequestMapping("/person/myExam")
    @ApiOperation(value = "",hidden = true)
    public String personMyExam () { return "/person/myExam"; }

    /**
     * 人员列表
     * @return
     */
    @RequestMapping("/person/userList")
    @ApiOperation(value = "",hidden = true)
    public String personUserList () { return "/person/userList"; }

    /**
     * 我的订单
     * @return
     */
    @RequestMapping("/person/myOrder")
    @ApiOperation(value = "",hidden = true)
    public String personMyOrder () { return "/person/myOrder"; }

    /**
     * 我的消息
     * @return
     */
    @RequestMapping("/person/myNews")
    @ApiOperation(value = "",hidden = true)
    public String personMyNews () { return "/person/myNews"; }

    /**
     * 个人资料
     * @return
     */
    @RequestMapping("/person/personData")
    @ApiOperation(value = "",hidden = true)
    public String personPersonData () { return "/person/personData"; }

    /**
     * 我的收藏
     * @return
     */
    @RequestMapping("/person/myCollect")
    @ApiOperation(value = "",hidden = true)
    public String personMyCollect () { return "/person/myCollect"; }

    /**
     * 考试
     * @return
     */
    @RequestMapping("/person/exam")
    @ApiOperation(value = "",hidden = true)
    public String exam () { return "/person/exam"; }

    /**
     * 错题库
     * @return
     */
    @RequestMapping("/person/errorExam")
    @ApiOperation(value = "",hidden = true)
    public String errorExam () { return "/person/errorExam"; }

    /**
     * 证书
     * @return
     */
    @RequestMapping("/person/certificate")
    @ApiOperation(value = "",hidden = true)
    public String certificate () { return "/person/certificate"; }

    /**
     * 公司和分销商统计数据
     * @return
     */
    @RequestMapping("/person/recordCompany")
    @ApiOperation(value = "",hidden = true)
    public String recordCompany () { return "/person/recordCompany"; }

    /**
     * 公司和分销商统计数据 -- 查看详情
     * @return
     */
    @RequestMapping("/person/recordUserDetail")
    @ApiOperation(value = "",hidden = true)
    public String recordUserDetail () { return "/person/recordUserDetail"; }

    /**
     * 公司和分销商统计数据 -- 学习情况列表
     * @return
     */
    @RequestMapping("/person/recordStudy")
    @ApiOperation(value = "",hidden = true)
    public String recordStudy () { return "/person/recordStudy"; }

    /**
     * 公司和分销商统计数据 -- 考试记录列表
     * @return
     */
    @RequestMapping("/person/recordExamRecord")
    @ApiOperation(value = "",hidden = true)
    public String recordExamRecord () { return "/person/recordExamRecord"; }

    /**
     * 公司和分销商统计数据 -- 课件列表
     * @return
     */
    @RequestMapping("/person/recordCourseware")
    @ApiOperation(value = "",hidden = true)
    public String recordCourseware () { return "/person/recordCourseware"; }

    /**
     * 公司和分销商统计数据 -- 人脸识别列表
     * @return
     */
    @RequestMapping("/person/recordFace")
    @ApiOperation(value = "",hidden = true)
    public String recordFace () { return "/person/recordFace"; }

    /***************************************个人中心模块**************************************/




}

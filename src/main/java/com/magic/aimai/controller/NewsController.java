package com.magic.aimai.controller;

import com.magic.aimai.business.entity.News;
import com.magic.aimai.business.enums.Common;
import com.magic.aimai.business.service.NewsService;
import com.magic.aimai.business.util.CommonUtil;
import com.magic.aimai.business.util.StatusConstant;
import com.magic.aimai.util.ViewData;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * Created by Eric Xie on 2017/7/21 0021.
 */
@RestController
@RequestMapping("/news")
@Api(value = "资讯接口列表",description = "资讯接口列表")
public class NewsController extends BaseController {


    @Resource
    private NewsService newsService;


    /**
     * 获取 推荐新闻列表
     * @param isRecommend 固定传参 1
     * @param pageNO 页码
     * @param pageSize 页码
     * @return
     */
    @RequestMapping(value = "/queryNewsOfIsRecommend",method = RequestMethod.POST)
    public ViewData queryNewsByItems(Integer isRecommend,Integer pageNO,Integer pageSize){
        if(CommonUtil.isEmpty(isRecommend,pageNO,pageSize)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        if(Common.NO.ordinal() != isRecommend && Common.YES.ordinal() != isRecommend){
            return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"参数异常");
        }
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                newsService.queryNewsByItems(isRecommend,pageNO,pageSize));
    }



    @RequestMapping(value = "/queryNewsList",method = RequestMethod.POST)
    @ApiOperation(value = "获取资讯列表",response = News.class)
    @ApiImplicitParams({
            @ApiImplicitParam(name = "pageNO",value = "分页参数",required = true,dataType = "Integer.class"),
            @ApiImplicitParam(name = "pageSize",value = "分页参数",required = true,dataType = "Integer.class")
    })
    public ViewData queryNewsList(Integer pageNO,Integer pageSize){
        if(CommonUtil.isEmpty(pageNO,pageSize)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                newsService.queryNewsOfWeb(pageNO,pageSize));
    }


    @RequestMapping(value = "/info",method = RequestMethod.POST)
    @ApiOperation(value = "获取资讯详情",response = News.class)
    @ApiImplicitParams({
            @ApiImplicitParam(name = "id",value = "资讯id",required = true,dataType = "Integer.class")
    })
    public ViewData info(Integer id){
        if(CommonUtil.isEmpty(id)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                newsService.info(id));
    }


}

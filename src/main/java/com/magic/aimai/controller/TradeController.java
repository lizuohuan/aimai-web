package com.magic.aimai.controller;

import com.magic.aimai.business.entity.Trade;
import com.magic.aimai.business.service.TradeService;
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
 * 行业
 * Created by Eric Xie on 2017/7/17 0017.
 */
@RestController
@RequestMapping("/trade")
@Api(value = "行业相关 API")
public class TradeController extends BaseController {


    @Resource
    private TradeService tradeService;

    /**
     * 获取行业列表
     * @return
     */
    @RequestMapping(value = "/queryTrade",method = RequestMethod.POST)
    public ViewData queryTrade(Integer pageNO,Integer pageSize){
        return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                tradeService.queryAllTrade(pageNO,pageSize));
    }





}

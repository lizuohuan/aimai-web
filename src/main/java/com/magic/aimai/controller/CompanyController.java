package com.magic.aimai.controller;

import com.magic.aimai.business.entity.Curriculum;
import com.magic.aimai.util.ViewData;
import com.magic.aimai.business.entity.Company;
import com.magic.aimai.business.service.CompanyService;
import com.magic.aimai.business.util.StatusConstant;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * 安培公司信息
 * @author lzh
 * @create 2017/8/3 20:03
 */
@RestController
@RequestMapping("/company")
public class CompanyController extends BaseController {

    @Resource
    private CompanyService companyService;


    /**
     * 安培公司信息详情
     * @return
     */
    @RequestMapping(value = "/info",method = RequestMethod.POST)
    @ApiOperation(value = "安培公司信息详情",response = Curriculum.class)
    public ViewData info() {
        try {
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"更新成功",companyService.info());
        } catch (Exception e) {
            e.printStackTrace();
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，更新失败");
        }
    }

}

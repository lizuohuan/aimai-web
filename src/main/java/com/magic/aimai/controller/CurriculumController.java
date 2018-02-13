package com.magic.aimai.controller;

import com.magic.aimai.business.entity.*;
import com.magic.aimai.business.enums.RoleEnum;
import com.magic.aimai.business.exception.InterfaceCommonException;
import com.magic.aimai.business.service.CurriculumService;
import com.magic.aimai.business.service.OrderService;
import com.magic.aimai.business.util.CommonUtil;
import com.magic.aimai.business.util.LoginHelper;
import com.magic.aimai.business.util.StatusConstant;
import com.magic.aimai.util.ViewData;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by Eric Xie on 2017/8/3 0003.
 */
@RestController
@RequestMapping("/curriculum")
public class CurriculumController extends BaseController {



    @Resource
    private CurriculumService curriculumService;
    @Resource
    private OrderService orderService;

    /**
     * 通过公司ID 获取 公司没有购买的课程列表
     * @param pageNO
     * @param pageSize
     * @return
     */
    @RequestMapping(value = "/getCurriculumNotBuy",method = RequestMethod.POST)
    public ViewData getCurriculumNotBuy(Integer pageNO,Integer pageSize,Integer companyId){
        if(CommonUtil.isEmpty(pageNO,pageSize,companyId)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            User user = LoginHelper.getCurrentUserOfAPI();
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                    curriculumService.getCurriculumNotBuy(companyId,pageNO,pageSize));
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }

    }

    /**
     * 通过公司ID 获取 公司下的课程列表
     * @param pageNO
     * @param pageSize
     * @return
     */
    @RequestMapping(value = "/queryCurriculumByCompany",method = RequestMethod.POST)
    public ViewData queryCurriculumByCompany(Integer pageNO,Integer pageSize,Integer companyId){
        if(CommonUtil.isEmpty(pageNO,pageSize,companyId)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            User user = LoginHelper.getCurrentUserOfAPI();
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                    curriculumService.queryCurriculumByCompany(companyId,pageNO,pageSize));
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }

    }



    @RequestMapping(value = "/queryWaitAllocationCurriculum",method = RequestMethod.POST)
    @ApiOperation(value = "公司或者代理商 通过用户 获取待分配的课程列表")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "userId",value = "用户ID",required = true,dataType = "path",paramType = "Integer.class"),
            @ApiImplicitParam(name = "pageNO",value = "分页参数",required = true,dataType = "path",paramType = "Integer.class"),
            @ApiImplicitParam(name = "pageSize",value = "分页参数",required = true,dataType = "path",paramType = "Integer.class")
    })
    public ViewData queryWaitAllocationCurriculum(Integer userId,Integer pageNO,Integer pageSize){
        if(CommonUtil.isEmpty(userId,pageNO,pageSize)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            User companyUser = LoginHelper.getCurrentUserOfAPI();
            if(RoleEnum.COMPANY_USER.ordinal() != companyUser.getRoleId() &&
                    RoleEnum.BUSINESS_USER.ordinal() != companyUser.getRoleId()){
                return buildFailureJson(StatusConstant.NOT_AGREE,"没有权限");
            }
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                    curriculumService.queryWaitAllocationCurriculumByUser(companyUser.getId(),
                            userId,pageNO,pageSize));
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }
    }


    @RequestMapping(value = "/queryCurriculumError",method = RequestMethod.POST)
    @ApiOperation(value = "学习模块  获取 错题库课程 列表接口",response = CurriculumStudy.class)
    @ApiImplicitParams({
            @ApiImplicitParam(name = "pageNO",value = "分页参数",required = true,dataType = "path",paramType = "Integer.class"),
            @ApiImplicitParam(name = "pageSize",value = "分页参数",required = true,dataType = "path",paramType = "Integer.class")
    })
    public ViewData queryCurriculumError(Integer pageNO,Integer pageSize){
        try {
            User user = LoginHelper.getCurrentUserOfAPI();
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                    curriculumService.queryCurriculumErrorOfWeb(user.getId(),pageNO,pageSize));
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }
    }

    @RequestMapping(value = "/queryCurriculumPass",method = RequestMethod.POST)
    @ApiOperation(value = "学习模块  获取 考试题列表接口",response = CurriculumStudy.class)
    @ApiImplicitParams({
            @ApiImplicitParam(name = "pageNO",value = "分页参数",required = true,dataType = "path",paramType = "Integer.class"),
            @ApiImplicitParam(name = "pageSize",value = "分页参数",required = true,dataType = "path",paramType = "Integer.class")
    })
    public ViewData queryCurriculumPass(Integer pageNO,Integer pageSize){
        try {
            User user = LoginHelper.getCurrentUserOfAPI();
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                    curriculumService.queryCurriculumPassOfWeb(user.getId(),pageNO,pageSize));
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }
    }



    @RequestMapping(value = "/queryCurriculumStudyForExamination",method = RequestMethod.POST)
    @ApiOperation(value = "学习模块  获取 模拟题列表接口",response = CurriculumStudy.class)
    @ApiImplicitParams({
            @ApiImplicitParam(name = "pageNO",value = "分页参数",required = true,dataType = "path",paramType = "Integer.class"),
            @ApiImplicitParam(name = "pageSize",value = "分页参数",required = true,dataType = "path",paramType = "Integer.class")
    })
    public ViewData queryCurriculumStudyForExamination(Integer pageNO,Integer pageSize){
        if(CommonUtil.isEmpty(pageNO,pageSize)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            User user = LoginHelper.getCurrentUserOfAPI();
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                    curriculumService.queryCurriculumStudyForExaminationOfWeb(user.getId(),pageNO,pageSize));
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }
    }

    @RequestMapping(value = "/statisticsCurriculum",method = RequestMethod.POST)
    @ApiOperation(value = "统计用户 最新一次 考题记录得分情况",response = StatisticsExamination.class)
    public ViewData statisticsCurriculum(){
        try {
            User user = LoginHelper.getCurrentUserOfAPI();
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                    curriculumService.statisticsCurriculum(user.getId()));
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }

    }


    @RequestMapping(value = "/queryCurriculumByOrder",method = RequestMethod.POST)
    @ApiOperation(value = "通过订单ID获取课程详情",notes = "个人学习模块以及订单中心入口访问",response = Curriculum.class)
    @ApiImplicitParam(name = "orderId",value = "订单ID",required = true,paramType = "Integer.class",dataType = "path")
    public ViewData queryCurriculumByOrder(Integer orderId){
        if(null == orderId){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            User user = LoginHelper.getCurrentUserOfAPI();
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                    curriculumService.queryCurriculumByOrderId(user.getId(), orderId,user.getRoleId()));
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }
    }


    @RequestMapping(value = "/queryCurriculumStudy",method = RequestMethod.POST)
    @ApiOperation(value = "学习模块，课程列表",notes = "暂只支持 个人|企业用户",response = CurriculumStudy.class)
    @ApiImplicitParams({
            @ApiImplicitParam(value = "分页参数 参数类型:int",name = "pageNO",paramType = "int",required = true,dataType = "Integer.class"),
            @ApiImplicitParam(value = "分页参数 参数类型:int",name = "pageSize",paramType = "int",required = true,dataType = "Integer.class")})
    public ViewData queryCurriculumStudy(Integer pageNO,Integer pageSize){
        if(CommonUtil.isEmpty(pageNO,pageSize)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            User user = LoginHelper.getCurrentUserOfAPI();
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功 ",
                    curriculumService.queryCurriculumStudyByItemsOfWeb(user.getRoleId(),user.getId(),pageNO,pageSize));
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }
    }


    /**
     * 通过ID 查询 课程
     * @param curriculumId 课程ID
     * @return
     */
    @RequestMapping(value = "/queryCurriculumById",method = RequestMethod.POST)
    @ApiOperation(value = "通过课程ID 查询课程详情,不能用于视频播放详情",response = Curriculum.class)
    @ApiImplicitParam(name = "curriculumId",value = "课程ID 参数类型:int",required = true,paramType = "int",dataType = "Integer.class")
    public ViewData queryCurriculumById(Integer curriculumId){
        if(CommonUtil.isEmpty(curriculumId)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            User user = LoginHelper.getCurrentUser();
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                    curriculumService.queryCurriculumById(curriculumId,null == user? null : user.getId()));
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        }catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }
    }



    /**
     * 通过培训阶段ID 查询 课程
     * @param isRecommend 可为空
     * @param pageNO
     * @param pageSize
     * @return
     */
    @RequestMapping(value = "/queryCurriculumByType",method = RequestMethod.POST)
    public ViewData queryCurriculumByType(Integer isRecommend,Integer pageNO,Integer pageSize,Integer curriculumTypeId,
                                          Integer tradeId,String searchParam){
        if(CommonUtil.isEmpty(pageNO,pageSize)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            User user = LoginHelper.getCurrentUser();
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                    curriculumService.queryCurriculumByTypeOfWeb(user,isRecommend,pageNO,pageSize,null,curriculumTypeId,tradeId ,searchParam));
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        }catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }
    }



    /**
     * 通过行业类型ID 查询 课程
     *  暂时不用
     * @param tradeId
     * @param pageNO
     * @param pageSize
     * @return
     */
    @RequestMapping(value = "/queryCurriculumByTradeId",method = RequestMethod.POST)
    @ApiOperation(value = "通过行业类型ID 查询 课程",hidden = true)
    public ViewData queryCurriculumByTradeId(Integer tradeId,Integer pageNO,Integer pageSize){
        if(CommonUtil.isEmpty(tradeId,pageNO,pageSize)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            User user = LoginHelper.getCurrentUserOfAPI();
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                    curriculumService.queryCurriculumByTradeId(user,tradeId,pageNO,pageSize));
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        }catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }

    }


    /**
     *  课程首页列表获取
     * @param pageNO
     * @param pageSize
     * @return
     */
    @RequestMapping(value = "/queryCurriculumByItems",method = RequestMethod.POST)
    @ApiOperation(value = "课程首页列表获取",response = Curriculum.class)
    @ApiImplicitParams({
            @ApiImplicitParam(name = "pageNO",value = "分页参数 参数类型:int",paramType = "int" ,required = true,dataType = "Integer.class"),
            @ApiImplicitParam(name = "pageNO",value = "分页参数 参数类型:int",paramType = "int",required = true,dataType = "Integer.class")
    })
    public ViewData queryCurriculumByItems(Integer pageNO,Integer pageSize){
        User currentUser = LoginHelper.getCurrentUser();
        return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                curriculumService.queryCurriculumByItems(currentUser,pageNO,pageSize));

    }


    /**
     *  获取课程列表 并返回试卷集合
     * @param pageNO
     * @param pageSize
     * @return
     */
    @RequestMapping(value = "/listForPC",method = RequestMethod.POST)
    @ApiOperation(value = "课程首页列表获取",response = Curriculum.class)
    @ApiImplicitParams({
            @ApiImplicitParam(name = "pageNO",value = "分页参数 参数类型:int",paramType = "int" ,required = true,dataType = "Integer.class"),
            @ApiImplicitParam(name = "pageSize",value = "分页参数 参数类型:int",paramType = "int",required = true,dataType = "Integer.class"),
            @ApiImplicitParam(name = "type",value = "0：练习题  1：模拟题 2：考试题 3：错题库 其他参数无效 参数类型:int",paramType = "int",required = true,dataType = "Integer.class")
    })
    public ViewData listForPC(Integer pageNO,Integer pageSize ,Integer type){
        User currentUser = LoginHelper.getCurrentUser();
        if (null == currentUser) {
            return buildFailureJson(StatusConstant.NOTLOGIN,"未登录");
        }
        PageArgs pageArgs = null;
        if (null != pageNO && null != pageSize) {
            pageArgs = new PageArgs(pageNO-1,pageSize);
        }
        return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                curriculumService.listForPC(pageArgs,currentUser.getId(),type));

    }



    /**
     * 用户是否购买过此课程
     * @param curriculumId
     * @return
     */
    @RequestMapping(value = "/isBuy",method = RequestMethod.POST)
    @ApiOperation(value = "用户是否购买过此课程",response = Curriculum.class)
    @ApiImplicitParams({
            @ApiImplicitParam(name = "curriculumId",value = "课程id 参数类型:int",paramType = "int",required = true,dataType = "Integer.class")
    })
    public ViewData isBuy(Integer curriculumId){
        User currentUser = LoginHelper.getCurrentUser();
        if (null == currentUser) {
            return buildFailureJson(StatusConstant.NOTLOGIN,"未登录");
        }
        if ( null == curriculumId ) {
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }

        if(!currentUser.getRoleId().equals(RoleEnum.USER.ordinal()) && !currentUser.getRoleId().equals(RoleEnum.COMPANY_USER.ordinal())
            && !currentUser.getRoleId().equals(RoleEnum.BUSINESS_USER.ordinal())){
            return buildFailureJson(StatusConstant.NOT_AGREE,"没有权限");
        }
        int buy = 0;
        List<Order> orders = orderService.queryOrderByUser(currentUser.getId(), curriculumId);
        if(null != orders && orders.size() > 0){
            // 判断订单购买状态
            if(currentUser.getRoleId().equals(RoleEnum.USER.ordinal())){
                // 如果是用户
                if(orders.get(0).getPayStatus() == 0){
                    buy = -2; // 未支付
                }
                else if(orders.get(0).getPayStatus() == 1){
                    buy = -1; // 已经支付
                }else{
                    buy = orders.size();
                }
            }
            else if(currentUser.getRoleId().equals(RoleEnum.COMPANY_USER.ordinal()) ||
                        currentUser.getRoleId().equals(RoleEnum.BUSINESS_USER.ordinal())){
                for (Order order : orders) {
                    if(order.getPayStatus() == 0){
                        buy = -2; // 未支付
                        break;
                    }
                }
            }
        }
        return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                buy);

    }



}

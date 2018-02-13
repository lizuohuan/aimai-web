package com.magic.aimai.controller;

import com.magic.aimai.business.entity.*;
import com.magic.aimai.business.enums.RoleEnum;
import com.magic.aimai.business.service.*;
import com.magic.aimai.business.util.LoginHelper;
import com.magic.aimai.business.util.StatusConstant;
import com.magic.aimai.business.util.Timestamp;
import com.magic.aimai.util.ViewData;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.*;

/**
 * Created by Eric Xie on 2018/1/18 0018.
 */
@RestController
@RequestMapping("/record")
public class RecordController extends BaseController {


    @Resource
    private UserService userService;
    @Resource
    private CurriculumService curriculumService;
    @Resource
    private CourseWareService courseWareService;
    @Resource
    private FaceRecordService faceRecordService;
    @Resource
    private PaperRecordService paperRecordService;
    @Resource
    private CityService cityService;

    /**
     * 获取用户(档案管理)
     * @param phone 手机号
     * @param roleId 角色id
     * @param startTimes 开始时间
     * @param endTimes 结束时间
     * @param companyName 公司名
     * @return
     */
    @RequestMapping("/listForWebRecord")
    public ViewData listForAdminRecord(String phone , Integer roleId , String pid, Integer pageNO, Integer pageSize,
                                       String companyName, String startTimes , String endTimes, Integer companyId) {
        try {
            Date startTime = null;
            Date endTime = null;
            if (null != startTimes && !startTimes.equals("")) {
                startTime = Timestamp.parseDate(Timestamp.timesStr(startTimes,"yyyy-MM-dd").toString(),"yyyy-MM-dd HH:mm:ss");
            }
            if (null != endTimes && !endTimes.equals("")) {
                endTime = Timestamp.parseDate(Timestamp.timesStr(endTimes,"yyyy-MM-dd").toString(),"yyyy-MM-dd HH:mm:ss");
            }
            User user = LoginHelper.getCurrentUser();
            if (null != user && user.getRoleId() == RoleEnum.COMPANY_USER.ordinal()) {
                companyId = user.getId();
            }
            Set<Integer> cityIdSet = null;
            if (null != user.getCityId() && !user.getCityId().equals(10000)) {
                cityIdSet = new HashSet<Integer>();
                City city = cityService.queryCity(user.getCityId());
                List<Integer> cityIdList = new ArrayList<Integer>();
                cityIdList.add(city.getId());
                List<City> cityList = cityService.queryCityByParentIds(cityIdList,city.getLevelType());
                cityIdSet.add(city.getId());
                for (City city1 : cityList) {
                    cityIdSet.add(city1.getId());
                }
            }


            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                    userService.listForWebRecord(pageNO,pageSize, phone, roleId, pid,
                            companyName,  startTime,  endTime, companyId,cityIdSet));
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }


    /**
     * 查询用户的基础信息
     * @param id
     * @return
     */
    @RequestMapping("/info")
    public ViewData info(Integer id){
        try {
            if (null == id) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功 ",userService.info(id));
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }


    /**
     * 分页获取用户课程 (档案管理)
     * @param userId 用户id、
     * @return 课程列表
     */
    @RequestMapping("/listForWebUser")
    public ViewData listForAdminUser(Integer pageNO,Integer pageSize , Integer userId ) {
        try {
            if (null  == userId) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                    curriculumService.listForWebUser(pageNO,pageSize, userId));
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }



    /**
     *  分页获取用户课时分类
     * @param orderId 订单id
     * @param curriculumId 课程id
     * @return
     */
    @RequestMapping("/listForWebUserOfCourseWare")
    public ViewData listForWebUserOfCourseWare(Integer pageNO,Integer pageSize, Integer orderId , Integer curriculumId ,Integer userId) {
        try {
            if (null == curriculumId || null == orderId || null == userId) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                    courseWareService.listForWebUser(pageNO,pageSize, orderId ,curriculumId,userId));
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }



    /**
     *  分页获取人脸识别验证记录
     * @param courseWareId 课时id
     * @param orderId 订单id
     * @param videoName 视频名
     * @param courseWareName 课时名
     * @param startTimes 开始时间
     * @param endTimes 结束时间
     * @return
     */
    @RequestMapping("/faceRecordList")
    public ViewData faceRecordList(Integer pageNO,Integer pageSize, Integer courseWareId ,
                             Integer orderId, String videoName,
                             String courseWareName , String startTimes , String endTimes ,Integer userId) {
        try {
            Date startTime = null;
            Date endTime = null;
            if (null != startTimes && !startTimes.equals("")) {
                startTime = Timestamp.parseDate(startTimes,"yyyy-MM-dd HH:mm:ss");
            }
            if (null != endTimes && endTimes.equals("")) {
                endTime = Timestamp.parseDate(endTimes,"yyyy-MM-dd HH:mm:ss");
            }
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                    faceRecordService.listForAdmin(pageNO,pageSize,
                            courseWareId, orderId, videoName, courseWareName, startTime, endTime,userId));
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }



    /**
     *
     * @return
     */
    @RequestMapping("/updateIsPass")
    public ViewData updateIsPass(PaperRecord record) {
        try {
            if (null == record.getId() || null == record.getResultScore() ){
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            paperRecordService.updateIsPass(record);
            return buildFailureJson(StatusConstant.SUCCESS_CODE,"操作成功");
        } catch (Exception e) {
            logger.error("服务器超时，操作失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，操作失败");
        }
    }

    /**
     * 获取考试记录
     * @return
     */
    @RequestMapping("/paperRecordList")
    public ViewData paperRecordList(Integer pageNO,Integer pageSize , Integer userId) {
        try {
            if (null == userId ){
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                    paperRecordService.listForWeb(pageNO,pageSize, userId));
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }





}

package com.magic.aimai.controller;

import com.magic.aimai.business.entity.CourseWare;
import com.magic.aimai.business.entity.Curriculum;
import com.magic.aimai.business.entity.User;
import com.magic.aimai.business.enums.RoleEnum;
import com.magic.aimai.business.service.OperationLogService;
import com.magic.aimai.business.service.StaticService;
import com.magic.aimai.business.service.UserService;
import com.magic.aimai.business.util.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.*;

/**
 * 导出
 * @author lzh
 * @create 2017/8/30 17:02
 */
@Controller
@RequestMapping("/excel")
public class ExcelController extends BaseController {

    @Resource
    private UserService userService;
    @Resource
    private StaticService staticService;
    @Resource
    private OperationLogService operationLogService;

    private ServletContext servletContext;


    public void setServletContext(ServletContext servletContext) {
        this.servletContext = servletContext;
    }

    /**
     * 导出用户 及 课程
     * @param phone 手机号
     * @param startTimes 开始时间
     * @param endTimes 结束时间
     * @param companyName 公司名
     * @return
     */
    @RequestMapping("/excelUser2")
    public void excelUser2(HttpServletResponse response, String phone , String pid,
                              String companyName, String startTimes , String endTimes,
                           Integer companyId,String userIds,Integer roleId) throws Exception {
        if (null == servletContext) {
            servletContext = SpringUtils.getBean(ServletContext.class);
        }
        Date startTime = null;
        Date endTime = null;
        if (null != startTimes && !startTimes.equals("")) {
            startTime = Timestamp.parseDate(Timestamp.timesStr(startTimes,"yyyy-MM-dd").toString(),"yyyy-MM-dd HH:mm:ss");
        }
        if (null != endTimes && !endTimes.equals("")) {
            endTime = Timestamp.parseDate(Timestamp.timesStr(endTimes,"yyyy-MM-dd").toString(),"yyyy-MM-dd HH:mm:ss");
//            endTime = Timestamp.parseDate2(endTimes,"yyyy-MM-dd HH:mm:ss");
        }
        User user = LoginHelper.getCurrentUser();
        if (null != user && user.getRoleId() == RoleEnum.COMPANY_USER.ordinal()) {
            companyId = user.getId();
        }
        List<Integer> userIdList = null;
        if(!CommonUtil.isEmpty(userIds)){
            userIdList = Arrays.asList(ClassConvert.strToIntegerGather(userIds.split(",")));
        }
        List<User> list = userService.excelUser(phone,roleId,pid,companyName,startTime,endTime,companyId,userIdList);
        Calendar ca = Calendar.getInstance();
        for (User user1 : list) {
            //返回mapd
            Map<String,Object> resultMap = new HashMap<String, Object>();
            //课程集合
            List<Map<String,Object>> curriculumList = new ArrayList<Map<String,Object>>();
            for (Curriculum curriculum : user1.getCurriculumList()) {
                if (null != curriculum.getResultScore() && null != curriculum.getPassScore()) {
                    if (curriculum.getResultScore() > curriculum.getPassScore()) {
                        curriculum.setIsPass(1);
                    }
                }
                resultMap.put("user",user1);
                //课程map
                Map<String , Object> curriculumMap = new HashMap<String, Object>();
                curriculumMap.put("curriculumName",null == curriculum.getCurriculumName() ? "--" : curriculum.getCurriculumName());
                if (null != curriculum.getFaceRecordList() && curriculum.getFaceRecordList().size() > 0) {
                    curriculumMap.put("time1",curriculum.getFaceRecordList().size() >= 1 ? Timestamp.DateTimeStamp(curriculum.getFaceRecordList().get(0).getCreateTime(),"yyyy/MM/dd HH:mm") : "--");
                    curriculumMap.put("time2",curriculum.getFaceRecordList().size() >= 2 ? Timestamp.DateTimeStamp(curriculum.getFaceRecordList().get(1).getCreateTime(),"yyyy/MM/dd HH:mm") : "--");
                    curriculumMap.put("time3",curriculum.getFaceRecordList().size() >= 3 ? Timestamp.DateTimeStamp(curriculum.getFaceRecordList().get(2).getCreateTime(),"yyyy/MM/dd HH:mm") : "--");
                    curriculumMap.put("time4",curriculum.getFaceRecordList().size() >= 4 ? Timestamp.DateTimeStamp(curriculum.getFaceRecordList().get(3).getCreateTime(),"yyyy/MM/dd HH:mm") : "--");
                    curriculumMap.put("imgUrl1",curriculum.getFaceRecordList().size() >= 1 ? curriculum.getFaceRecordList().get(0).getFaceImage() : "--");
                    curriculumMap.put("imgUrl2",curriculum.getFaceRecordList().size() >= 2 ? curriculum.getFaceRecordList().get(1).getFaceImage() : "--");
                    curriculumMap.put("imgUrl3",curriculum.getFaceRecordList().size() >= 3 ? curriculum.getFaceRecordList().get(2).getFaceImage() : "--");
                    curriculumMap.put("imgUrl4",curriculum.getFaceRecordList().size() >= 4 ? curriculum.getFaceRecordList().get(3).getFaceImage() : "--");
                } else {
                    curriculumMap.put("time1","--");
                    curriculumMap.put("time2","--");
                    curriculumMap.put("time3","--");
                    curriculumMap.put("time4","--");
                    curriculumMap.put("imgUrl1",null);
                    curriculumMap.put("imgUrl2",null);
                    curriculumMap.put("imgUrl3",null);
                    curriculumMap.put("imgUrl4",null);
                }

                //课件名
                List<String> wareNameList = new ArrayList<String>();
                //进度
                List<String> scheduleList = new ArrayList<String>();
                //每4个课件一次循环
                List<Map<String ,Object>> courseWareList = new ArrayList<Map<String, Object>>();
                //课件map
                Map<String,Object> courseWareMap = new HashMap<String, Object>();
                int i = 1;
                if (curriculum.getCourseWares().size() == 0) {
                    for (int j = 0; j < 4; j++) {
                        wareNameList.add("--");
                        scheduleList.add("--");
                    }
                    courseWareMap.put("courseWareName",wareNameList);
                    courseWareMap.put("schedule",scheduleList);
                }
                curriculumMap.put("courseWare",courseWareList);
                for (CourseWare ware : curriculum.getCourseWares()) {
                    wareNameList.add(ware.getCourseWareName());
                    scheduleList.add(String.valueOf(new BigDecimal(ware.getExpendSeconds() / ware.getHdSeconds() * 100).setScale(2, RoundingMode.UP).doubleValue()));
                    if (wareNameList.size() / 4  == 1 || curriculum.getCourseWares().size() == i) {
                        if (wareNameList.size() < 4) {
                            int num = 4 - wareNameList.size();
                            for (int j = 0; j < num; j++) {
                                wareNameList.add("--");
                                scheduleList.add("--");
                            }
                        }
                        courseWareMap.put("courseWareName",wareNameList);
                        courseWareMap.put("schedule",scheduleList);
                        courseWareList.add(courseWareMap);
                        scheduleList = new ArrayList<String>();
                        wareNameList = new ArrayList<String>();
                        courseWareMap = new HashMap<String, Object>();
                    }
                    i++;
                }
                curriculumMap.put("courseWare",courseWareList);
                curriculumList.add(curriculumMap);
            }
            resultMap.put("currMap",curriculumList);
            staticService.build("/ftl/aiam.ftl","/upload/"+ca.get(Calendar.YEAR) + "/" + ca.get(Calendar.MONTH) + "/"+ ca.get(Calendar.DATE) + "/"+user1.getShowName()+".doc",resultMap);

            System.out.println("恭喜，生成成功~~");
        }
        try {
            String path = servletContext.getRealPath("/upload/"+ca.get(Calendar.YEAR) + "/" + ca.get(Calendar.MONTH) + "/"+ ca.get(Calendar.DATE));
            String uploadPath = servletContext.getRealPath("/upload/"+ca.get(Calendar.YEAR) + "/" + ca.get(Calendar.MONTH));
            String fileName = Timestamp.DateTimeStamp(new Date(),"yyyyMMdd");

            FileToZip.fileToZip(path, uploadPath, fileName);
            fileName = fileName + ".zip";
            File file = new File(uploadPath+"/"+fileName);
            response.setCharacterEncoding("UTF-8");
            response.setHeader("Content-Disposition",
                    "attachment; filename=" + new String(fileName.getBytes("ISO8859-1"), "UTF-8"));
            response.setContentLength((int) file.length());
            response.setContentType("application/zip");// 定义输出类型
            FileInputStream fis = new FileInputStream(file);
            BufferedInputStream buff = new BufferedInputStream(fis);
            byte[] b = new byte[1024];// 相当于我们的缓存
            long k = 0;// 该值用于计算当前实际下载了多少字节
            OutputStream myout = response.getOutputStream();// 从response对象中得到输出流,准备下载
            // 开始循环下载
            while (k < file.length()) {
                int j = buff.read(b, 0, 1024);
                k += j;
                myout.write(b, 0, j);
            }
            myout.flush();
            buff.close();
            file.delete();
            //操作日志
            operationLogService.save2(user.getId(),user.getRoleId(),"导出了用户");
        } catch (Exception e) {
            System.out.println(e);
        }
    }



}

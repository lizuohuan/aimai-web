package com.magic.aimai.controller;



import com.alipay.api.AlipayClient;
import com.alipay.api.DefaultAlipayClient;
import com.alipay.api.request.AlipayTradePagePayRequest;
import com.magic.aimai.business.entity.Order;
import com.magic.aimai.business.entity.User;
import com.magic.aimai.business.enums.PayMethodEnum;
import com.magic.aimai.business.exception.InterfaceCommonException;
import com.magic.aimai.business.pay.AliPayConfig;
import com.magic.aimai.business.pay.SignUtils;
import com.magic.aimai.business.service.OrderService;
import com.magic.aimai.business.util.CommonUtil;
import com.magic.aimai.business.util.LoginHelper;
import com.magic.aimai.business.util.StatusConstant;
import com.magic.aimai.util.ViewData;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiOperation;
import net.sf.json.JSONObject;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.*;


/**
 * 支付宝 签名 回调接口 控制层
 *
 * @author QimouXie
 */
@Controller
@RequestMapping("/aliPay")
@Api(value = "支付宝 签名 接口列表", description = "支付宝 签名 接口列表")
public class AliPayController extends BaseController {

    /**
     * 日志类
     */
    private Logger logger = Logger.getLogger(AliPayController.class);
    @Resource
    private OrderService orderService;


    /**
     * AliPay支付成功后 回调接口
     *
     * @param req
     * @return
     */
    @RequestMapping("/aliPayCallBack")
    @ResponseBody
    @ApiOperation(value = "AliPay支付成功 回调接口", hidden = true)
    public void aliPayCallBack(HttpServletRequest req, HttpServletResponse resp) {
        logger.debug("PC支付回调开始......");
        Map parameterMap = req.getParameterMap();
        Set set = parameterMap.keySet();
        Iterator iterator = set.iterator();
        while (iterator.hasNext()){
            logger.debug(parameterMap.get(iterator.next().toString()));
        }
        try {
            String payStatus = req.getParameter("trade_status");
            if (!"TRADE_SUCCESS".equals(payStatus)) {
                return;
            }
            // 获取订单ID
            String passback_params = URLDecoder.decode(req.getParameter("passback_params"), "utf-8");
            JSONObject jsonObj = JSONObject.fromObject(passback_params);
            logger.debug(jsonObj.toString());

            Integer orderId = jsonObj.getInt("orderId");
            String out_trade_no = req.getParameter("trade_no");
            Order order = orderService.queryBaseOrder(orderId);
            if (null == order) {
                return;
            }
            // 支付宝回调 业务处理
			orderService.paySuccess(order, PayMethodEnum.AliPay.ordinal(),out_trade_no);
            resp.getWriter().print("success");
        } catch (Exception e) {
            logger.debug("支付宝回调业务处理失败.........", e);
        }
    }


    @RequestMapping("/pcSign")
    public void signPC(HttpServletRequest request, HttpServletResponse response, Integer orderId) {


        String localPath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + "/web";
        try {
            if (CommonUtil.isEmpty(orderId)) {
                response.setContentType("text/html;charset=utf-8");
                response.getWriter().print(JSONObject.fromObject(buildFailureJson(StatusConstant.FIELD_NOT_NULL, "参数不能为空")).toString());
                response.getWriter().flush();
                response.getWriter().close();
                return;
            }
//			LoginHelper.getCurrentUserOfAPI();
            Order order = orderService.queryBaseOrder(orderId);
            if (null == order) {
                response.setContentType("text/html;charset=utf-8");
                response.getWriter().print(JSONObject.fromObject(buildFailureJson(StatusConstant.OBJECT_NOT_EXIST, "订单不存在")).toString());
                response.getWriter().flush();
                response.getWriter().close();
                return;
            }
            if (!StatusConstant.NO_PAY.equals(order.getPayStatus())) {
                response.getWriter().print(JSONObject.fromObject(buildFailureJson(StatusConstant.ORDER_STATUS_ABNORMITY, "订单状态异常")).toString());
                response.getWriter().flush();
                response.getWriter().close();
                return;
            }
            //获得初始化的AlipayClient
            AlipayClient alipayClient = new DefaultAlipayClient(AliPayConfig.GATE_WAY_URL, AliPayConfig.APP_ID, AliPayConfig.PRIVATE_KEY_PC,
                    "json", AliPayConfig.CHARSET, AliPayConfig.PUBLIC_KEY_PC, AliPayConfig.SIGN_TYPE);

            //设置请求参数
            AlipayTradePagePayRequest alipayRequest = new AlipayTradePagePayRequest();
            alipayRequest.setReturnUrl(localPath + "/page/course/paymentResult?isSucceed=1");
            alipayRequest.setNotifyUrl(localPath + "/aliPay/aliPayCallBack");
            Map<String, Object> extendParams = new HashMap<String, Object>();

            String out_trade_no = AliPayConfig.buildNumber();
			String total_amount = order.getPrice()+"";
//            String total_amount = 0.01 + "";
            String subject = "爱麦支付";
            String body = "爱麦商品购买";
            extendParams.put("orderId", orderId);
            extendParams.put("out_trade_no", out_trade_no);

            alipayRequest.setBizContent("{\"out_trade_no\":\"" + out_trade_no + "\","
                    + "\"total_amount\":\"" + total_amount + "\","
                    + "\"subject\":\"" + subject + "\","
                    + "\"body\":\"" + body + "\","
                    + "\"passback_params\":\"" + URLEncoder.encode(JSONObject.fromObject(extendParams).toString(), "utf-8") + "\","
                    + "\"product_code\":\"FAST_INSTANT_TRADE_PAY\"}");

            //请求
            String result = alipayClient.pageExecute(alipayRequest).getBody();
            response.setContentType("text/html;charset=utf-8");
            //输出
            response.getWriter().print(result);
            response.getWriter().flush();
            response.getWriter().close();
        } catch (InterfaceCommonException e) {
            try {
                response.getWriter().print(JSONObject.fromObject(buildFailureJson(e.getErrorCode(), e.getMessage())).toString());
                response.getWriter().flush();
                response.getWriter().close();
            } catch (IOException e1) {
                e1.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }


}

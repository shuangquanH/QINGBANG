//
//  SQApiUrlFile.h
//  QingYouProject
//
//  Created by qwuser on 2018/5/23.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#ifndef SQApiUrlFile_h
#define SQApiUrlFile_h
/*************************** 接口名称 *****************************************************/

// 本地服务器

#define YGSocketPort 6488

#define YGSocketURL @"192.168.51.12"

#define YGMainServer @"http://192.168.51.103:8080/app/"
//#define YGMainServer @"http://192.168.51.12:8080/"

//#define YGMainServer @"http://suzf123.imwork.net/"

#define YGWebURL [YGMainServer stringByAppendingString:@"huoban1.0/view/"]

#define YGQNURL @"http://pic.huobanchina.com/"

/********************************************首页*************************************************/
//首页
#define REQUEST_IndexInformationDetail                      @"IndexInformationDetail"               //首页


//一起玩儿
#define REQUEST_createAlliance                      @"createAlliance"               //创建联盟
#define REQUEST_dissolveAlliance                      @"dissolveAlliance"               //解散联盟
#define REQUEST_viewAlliance                      @"viewAlliance"               //联盟信息展示
#define REQUEST_updateAlliance                      @"updateAlliance"               //改联盟信息
#define REQUEST_updateAllianceNotice                     @"updateAllianceNotice"               //改联盟公告信息
#define REQUEST_getAllianceList                      @"getAllianceList"               //联盟列表
#define REQUEST_getMineAllianceList                      @"getMineAllianceList"               //我的联盟列表
#define REQUEST_getAllianceAttention                     @"getAllianceAttention"               //我的关注联盟列表
#define REQUEST_attentionAlliance                      @"attentionAlliance"               //关注、取消联盟
#define REQUEST_collectAlliance                      @"collectAlliance"               //收藏、取消联盟
#define REQUEST_operateAllianceMember                      @"operateAllianceMember"               //加入退出移除联盟
#define REQUEST_AllianceIndex                      @"AllianceIndex"               //联盟圈主页
#define REQUEST_AllianceActivity                      @"AllianceActivity"               //联盟活动
#define REQUEST_allianceMemberList                      @"allianceMemberList"               //联盟成员列表
#define REQUEST_AllianceDetail                      @"AllianceDetail"               //联盟全详情页
#define REQUEST_postedDynamic                      @"postedDynamic"               //发布动态
#define REQUEST_getDynamic                      @"getDynamic"               //动态列表
#define REQUEST_getAllianceActivity                    @"getAllianceActivity"               // 联盟圈活动列表
#define REQUEST_likeAllianceDynamic                      @"likeAllianceDynamic"               //点赞/取消联盟圈动态
#define REQUEST_getDynamicComment                      @"getDynamicComment"               //获取联盟圈动态评论
#define REQUEST_getActiveTag                      @"getActiveTag"               //获取活动标签
#define REQUEST_getActivityByTagId                     @"getActivityByTagId"               //  获取活动列表
#define REQUEST_addActive                    @"addActive"               //  添加活动
#define REQUEST_getActiveMessage                     @"getActiveMessage"               // 添加活动--报名设置--获取常用信息
#define REQUEST_getActiveTag                     @"getActiveTag"               // 获取青网推荐
#define REQUEST_postedDynamicComment                    @"postedDynamicComment"               //发布动态评论


#define REQUEST_ActivityOrderList                    @"ActivityOrderList"               //  订单列表
#define REQUEST_ActivityOrderDetail                   @"ActivityOrderDetail"               //  订单详情

#define REQUEST_getAllianceSign                   @"getAllianceSign"               //获取联盟成员签到信息
#define REQUEST_AllianceRankingList                   @"AllianceRankingList"               // 获取联盟成员签到排行榜
#define REQUEST_AllianceUserSign                  @"AllianceUserSign"               //  联盟成员签到
#define REQUEST_AllianceOrderDelete                  @"AllianceOrderDelete"               //  删除订单
#define REQUEST_AllianceOrderCancel                  @"AllianceOrderCancel"               //  取消活动







//二手置换
#define REQUEST_MerchandiseClassification                    @"MerchandiseClassification"               //商品分类
#define REQUEST_ReleaseGoods                    @"ReleaseGoods"               //发布商品
#define REQUEST_ReplacementInformation                    @"ReplacementInformation"               //基本信息

#define REQUEST_userInformation                    @"userInformation"               //认证信息查询
#define REQUEST_getDozenDis                    @"getDozenDis"               //兜底
#define REQUEST_editMyMerchandise                    @"editMyMerchandise"               // 我发布的编辑






//项目申报
#define REQUEST_DeclarePicture                      @"DeclarePicture"               //项目申报首页
#define REQUEST_DeclareFund                      @"DeclareFund"               //项目申报子页面
#define REQUEST_SearchGrade                      @"SearchGrade"               //项目申报
#define REQUEST_AddGradeProject                      @"AddGradeProject"               //项目申报
#define REQUEST_SearchApplicationOrder                      @"SearchApplicationOrder"               //查看项目申报列表
#define REQUEST_SearchApplicationDetail                     @"SearchApplicationDetail"               //查看项目申报列表详情
#define REQUEST_DeletApplication                     @"DeletApplication"               // 删除订单/取消申请
#define REQUEST_SeachGradeProject                     @"SeachGradeProject"               // 查看添加申报基金项目详情




//预约看房
#define REQUEST_otSelectList                      @"otSelectList"               //预约看房过滤查询列表
#define REQUEST_OtDegreeSelectList                       @"OtDegreeSelectList"                    //装修选择查询
#define REQUEST_OtPriceSelectList                     @"OtPriceSelectList"                      //价格选择查询
#define REQUEST_OtProportionSelectList                      @"OtProportionSelectList"                        //面积选择查询
#define REQUEST_OtNameSelectList               @"OtNameSelectList"               //预约看房过滤查询列表(放大镜搜索)
#define REQUEST_OtDetails               @"OtDetails"              //房源详情
#define REQUEST_OtSaveReservation                @"OtSaveReservation"               //预约单
#define REQUEST_MyReservation                @"MyReservation"               //我的预约单
#define REQUEST_CancelReservation                @"CancelReservation"               //取消预约


/********************************************管家*************************************************/
//管家首页
//预定会议室
#define REQUEST_getArea                   @"getArea"   //预定会议室请求区域
#define REQUEST_getRoomByArea              @"getRoomByArea"   //请求区域下会议室
#define REQUEST_getBoardRoom               @"getBoardRoom"   //请求会议室详情
#define REQUEST_getHasOrderDateByRoomId             @"getHasOrderDateByRoomId"   //请求会议室约满日期
#define REQUEST_getHasOrderTime               @"getHasOrderTime"   //请求会议室已预约时间
#define REQUEST_commit               @"commit"   //提交订单
#define REQUEST_underLinePay               @"underLinePay"   //线下支付
#define REQUEST_refund               @"refund"   //申请退款
#define REQUEST_myOrder               @"myOrder"   //我的订单
#define REQUEST_delOrder               @"delOrder"   //删除订单
#define REQUEST_onLinePay               @"onLinePay"   //线上支付
//装修直通车
//随手拍
#define REQUEST_AddSnapshotOrder               @"AddSnapshotOrder"   //随手拍添加
#define REQUEST_SearchSnapshotOrder               @"SearchSnapshotOrder"   //随手拍工单列表
#define REQUEST_SnapshotOrderDetail               @"SnapshotOrderDetail"   //随手拍工单详情
#define REQUEST_DeleteSnapshot               @"DeleteSnapshot"   //删除/取消 随手拍
#define REQUEST_StochasticIntegral               @"StochasticIntegral"   //随手拍青币




//网络管家
#define REQUEST_NetServiceRecord                        @"NetServiceRecord"               //交易记录
#define REQUEST_NetServiceComment                        @"NetServiceComment"               //服务评价
#define REQUEST_NetServiceInfo                        @"NetServiceInfo"               //服务介绍
//办公采购
//广告位
#define REQUEST_AdsIndex               @"AdsIndex"   //广告首页
#define REQUEST_AdsGarden               @"AdsGarden"   //选择园区广告
#define REQUEST_AdsDetail               @"AdsDetail"   //广告详情
#define REQUEST_AdsCooperationDetail               @"AdsCooperationDetail"   //合作详情
#define REQUEST_AdsOrderCreate               @"AdsOrderCreate"   //生成订单
#define REQUEST_AdsOrder               @"AdsOrder"   //广告订单列表
#define REQUEST_AdsOrderDelete               @"AdsOrderDelete"   //广告订单删除
//物业报修






//人才招聘

#define REQUEST_ChooseGarden                        @"ChooseGarden"               //选择园区
#define REQUEST_RecruitmentIndexList                        @"RecruitmentIndexList"               //人才招聘首页
#define REQUEST_PostJob                        @"PostJob"               //发布招聘信息
#define REQUEST_FindJobList                        @"FindJobList"               //选择招聘职位
#define REQUEST_FindSalaryList                        @"FindSalaryList"               // 选择薪资待遇
#define REQUEST_FindEducationalList                        @"FindEducationalList"               //选择学历要求
#define REQUEST_FindExperienceList                        @"FindExperienceList"               //选择工作经验
#define REQUEST_FindBenefitsList                        @"FindBenefitsList"               //选择福利待遇
#define REQUEST_MyRecruitmentList                        @"MyRecruitmentList"               //我的招聘列表
#define REQUEST_RecruitmentQueryFiltering                        @"RecruitmentQueryFiltering"               //招聘信息过滤查询
#define REQUEST_RecruitmentDetails                        @"RecruitmentDetails"               //招聘信息详情
#define REQUEST_RecruitmentDel                       @"RecruitmentDel"               //招聘信息删除
#define REQUEST_Resumedeliver                       @"Resumedeliver"               //简历投递
#define REQUEST_DeliverRecord                        @"DeliverRecord"               //投递记录
#define REQUEST_FindResumes                       @"FindResumes"               //查询简历详情
#define REQUEST_ResumeQueryFiltering                       @"ResumeQueryFiltering"               //简历信息过滤查询
#define REQUEST_ApplicationRelationJober                       @"ApplicationRelationJober"               //申请联系求职者
#define REQUEST_AddOutsourcingApplyAudit                       @"AddOutsourcingApplyAudit"               //岗位外包服务申请审核添加
#define REQUEST_MyOutsourcingApply                       @"MyOutsourcingApply"               //我的岗位外包服务申请
#define REQUEST_DelMyOutsourcingApply                       @"DelMyOutsourcingApply"               //撤销请求或删除我的岗位外包服务申请订单
#define REQUEST_OutsourcingIndexList                       @"OutsourcingIndexList"               //岗位外包服务首页
#define REQUEST_FindMyResume                       @"FindMyResume"               //查询我的简历
#define REQUEST_CreateResume                       @"CreateResume"               // 创建简历
#define REQUEST_RecruitmentSecondLevel                       @"RecruitmentSecondLevel"               // 员工招聘 二级页面 图片接口


#define REQUEST_MyDeliverRecord                      @"MyDeliverRecord"               // 个人招聘我的消息
#define REQUEST_AcceptInterview                      @"AcceptInterview"               // 接受面试
#define REQUEST_MyRecruitmentCounts                      @"MyRecruitmentCounts"               //  我的招聘投递条数
#define REQUEST_MyRecruitmentCounts                      @"MyRecruitmentCounts"               //  我的招聘投递条数





//资金扶持
#define REQUEST_ResolvePicture                        @"ResolvePicture"               //资金扶持首页图

#define REQUEST_AddProject                        @"AddProject"               //查询房屋缴纳审核
#define REQUEST_SelectiveType                     @"SelectiveType"            //认购选择类型
#define REQUEST_ServiceHall                        @"ServiceHall"               //服务大厅（为什么选择我们）
#define REQUEST_ServiceHall                        @"ServiceHall"               //服务大厅（能为您解决什么）
#define REQUEST_MoneyPagePicture                        @"MoneyPagePicture"               //服务大厅轮播图
#define REQUEST_Application                        @"Application"               //申请服务
#define REQUEST_CommunicationGroup                 @"CommunicationGroup"               //交流群
#define REQUEST_SearchInvestDetail                 @"SearchInvestDetail"               //查询我的投资项目详情
#define REQUEST_SearchInvest                       @"SearchInvest"               //查询我的投资项目
#define REQUEST_SearchProject                     @"SearchProject"               //查询我的路演
#define REQUEST_bpWanted                          @"bpWanted"                    //索要BP

#define REQUEST_getProType                          @"getProType"                    //请求众筹行业领域
#define REQUEST_getProjects                          @"getProjects"                    //请求众筹项目列表
#define REQUEST_getProjectDetails                   @"getProjectDetails"                    //请求众筹项目详情
#define REQUEST_getProjectSubscribe                  @"getProjectSubscribe"                    //请求项目认购方案
#define REQUEST_gaddSubscribeScheme                  @"addSubscribeScheme"                    //用户认购


#define REQUEST_proCollect                          @"proCollect"                    //收藏
#define REQUEST_authentication                          @"authentication"                    //认证状态获取
#define REQUEST_isManager                          @"isManager"                    //是否为盟主




#define REQUEST_getTrade                          @"getTrade"                    //请求路演行业领域
#define REQUEST_applyRoadShow                     @"applyRoadShow"               //申请路演
#define REQUEST_getRoadShow                    @"getRoadShow"               //请求路演列表
#define REQUEST_getRoadShowDetails                     @"getRoadShowDetails"               //请求路演详情


//房租缴纳
#define REQUEST_userid                            @"302999baff2044229f7ee892a22a155c"

#define REQUEST_HouserAudit                       @"HouserAudit"               //查询房屋缴纳审核
#define REQUEST_SubmitHouserAudit                 @"SubmitHouserAudit"               //提交房屋缴纳审核信息
#define REQUEST_sendSMS                           @"sendSMS"               //房屋缴纳查询信息获取验证码
#define REQUEST_ValidationHouserPay               @"ValidationHouserPay"               //房屋缴纳查询验证
#define REQUEST_FindMyHouserContract              @"FindMyHouserContract"               //房屋缴纳查询我的信息

#define REQUEST_HouserPayDetails                  @"HouserPayDetails"               //房租待支付账单详情
#define REQUEST_HouserPayList                       @"HouserPayList"               // 房租待支付账单列表
#define REQUEST_BillingDetails                      @"BillingDetails"               //房屋缴纳立即支付账单详情

#define REQUEST_HistoryInvoiceList                      @"HistoryInvoiceList"               //历史发票信息列表
#define REQUEST_InvoiceMailingAddress                      @"InvoiceMailingAddress"               //选择发票邮寄地址
#define REQUEST_InvoiceInformationManagement                      @"InvoiceInformationManagement"               //发票信息管理查询
#define REQUEST_SaveInvoiceInformationManagement                      @"SaveInvoiceInformationManagement"               //发票信息管理添加与编辑
#define REQUEST_breachOfContract                      @"breachOfContract"               //违约账单查询
#define REQUEST_PaymentRecordss                       @"PaymentRecordss"               //历史缴费记录
#define REQUEST_DemandPaymentInvoice                       @"DemandPaymentInvoice"               //索要发票列表
#define REQUEST_PaymentRecords                       @"PaymentRecords"               //索要发票
#define REQUEST_HistoryIssueInvoice                       @"HistoryIssueInvoice"               //历史记录--开具发票

#define REQUEST_PushHistoryIssueInvoice                       @"PushHistoryIssueInvoice"               //历史记录已开具了--开具发票

#define REQUEST_IssueInvoice                       @"IssueInvoice"               //开具发票

#define REQUEST_HousePay                          @"HousePay"               //房屋缴纳支付
#define REQUEST_HousePayIndexImg                          @"HousePayIndexImg"               //房屋缴纳首页轮播
#define REQUEST_PaymentRecordsDetail                         @"PaymentRecordsDetail"               //我的历史缴费记录详情

/********************************************抢购*************************************************/
#define REQUEST_falshsaleBanner                          @"falshsaleBanner"               //抢购轮播
#define REQUEST_falshsaleRound                          @"falshsaleRound"               //抢购场次
#define REQUEST_falshsaleByRound                         @"falshsaleByRound"               //根据场次获取商品 (抢好货)
#define REQUEST_falshsaleClassify                          @"falshsaleClassify"               //获取分类信息
#define REQUEST_falshsaleReminding                          @"falshsaleReminding"               //用户提醒记录添加/取消
#define REQUEST_getFalshsaleCommodity                          @"getFalshsaleCommodity"               //获取商品信息
#define REQUEST_falshsaleCollect                          @"falshsaleCollect"               //用户收藏记录添加/取消
#define REQUEST_falshsaleCommoditySize                          @"falshsaleCommoditySize"               //商品规格
#define REQUEST_createFalshsaleOrder                          @"createFalshsaleOrder"               //创建订单
#define REQUEST_payFalshsaleOrder                          @"payFalshsaleOrder"               //订单支付
#define REQUEST_getFalshsaleCommodityYQG                          @"getFalshsaleCommodityYQG"               //易企购商品列表
#define REQUEST_getFalshsaleOrderList                          @"getFalshsaleOrderList"               //获取订单列表
#define REQUEST_getFalshsaleOrder                          @"getFalshsaleOrder"               //获取订单详情
#define REQUEST_outFalshsaleOrder                          @"outFalshsaleOrder"               //申请退款
#define REQUEST_checkedFalshsaleOrder                          @"checkedFalshsaleOrder"               //确认收货
#define REQUEST_deleteFalshsaleOrder                         @"deleteFalshsaleOrder"               //删除订单
#define REQUEST_continueFalshsaleOrder                          @"continueFalshsaleOrder"               //继续付款
#define REQUEST_cancelFalshsaleOrder                          @"cancelFalshsaleOrder"               //取消订单

/********************************************我的*************************************************/
//资金扶持
#define REQUEST_myInvestment                          @"myInvestment"               //我的投资
#define REQUEST_investDetails                         @"investDetails"               //我的投资项目详情
#define REQUEST_revokeInvest                         @"revokeInvest"               //我的投资项目详情
#define REQUEST_uploadProof                         @"uploadProof"               //我的投资项目详情
#define REQUEST_SearchApplication                         @"SearchApplication"               // 查询我的服务
#define REQUEST_YiJianYanZheng                         @"YiJianYanZheng"               // 一键认证
#define REQUEST_zhiMaXinYongHuiDiao                        @"zhiMaXinYongHuiDiao"               // 芝麻灰调参数
#define REQUEST_SearchInvestDetail                       @"SearchInvestDetail"               //查询我的项目详情

#define REQUEST_Renewed                       @"Renewed"               //续期投资
#define REQUEST_Termination                       @"Termination"               //终止投资








//地址（公用）
#define REQUEST_AddAddress                       @"AddAddress"               //添加地址
#define REQUEST_AddressEdit                       @"AddressEdit"               //编辑地址
#define REQUEST_SetDefAddress                       @"SetDefAddress"               //设置默认地址
#define REQUEST_DeteleAddress                      @"DeteleAddress"               // 删除地址
#define REQUEST_AddressDetail                      @"AddressDetail"               // 地址详情
#define REQUEST_AddressList                     @"AddressList"               // 地址列表



/********************************************登录注册*************************************************/


//登录注册
#define REQUEST_sendSMS                         @"sendSMS"                          //获取验证码
#define REQUEST_newUserRegistration                        @"newUserRegistration"                     //注册
#define REQUEST_checkPassword                       @"checkPassword"                        //微信绑定
#define REQUEST_forgetPassword                    @"forgetPassword"                    //忘记密码
#define REQUEST_smsLogin                       @"smsLogin"                        //短信登录
#define REQUEST_otherLogin                       @"otherLogin"                        //第三方登录存在直接登录(带判断)
#define REQUEST_userLogin                      @"userLogin"                        //登录
#define REQUEST_userCheck                      @"userCheck"                        //验证手机号是否注册
#define REQUEST_checkSMS                      @"checkSMS"                        // 验证短信短信验证码
#define REQUEST_Binding                         @"Binding"                          //绑定



#define REQUEST_WXLOGIN                         @"WxLogin"                          //微信登录
#define REQUEST_WXBINDING                       @"WxBinding"                        //微信绑定
#define REQUEST_getUserAgreement                       @"getUserAgreement"                        //清网协议




/********************************************* 新版本新增接口  ********************************************/
#define KAPI_INDEXPAGE      @"getIndexPage"//首页
#define KAPI_CUSBANN        @"getCusBann"//首页定制功能
#define KAPI_WEATHER        @"getWeatherInfo"//获取天气
#define KAPI_ORDERNUM       @"getOrderNum"//首页获取订单数量

#define KAPI_MYDECORATION_ORDERLIST    @"getOrderList"//我的装修订单列表
#define KAPI_DECORATIONORDERDETAIL     @"getOrderInfo"//装修订单详情
#define KAPI_INVOICELIST               @"getInvoiceInfo"//发票抬头列表

#endif /* SQApiUrlFile_h */

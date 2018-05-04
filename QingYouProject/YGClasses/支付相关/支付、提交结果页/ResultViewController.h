//
//  ResultViewController.h
//  FrienDo
//
//  Created by zhangkaifeng on 2017/9/26.
//  Copyright © 2017 ccyouge. All rights reserved.
//

#import "RootViewController.h"

typedef NS_ENUM(NSUInteger, ResultPageType) {
    ResultPageTypeOnlinePayResult,
    ResultPageTypeOfflinePayResult,
    ResultPageTypeNetVIPOfflinePayResult,
    ResultPageTypeSubmitResult,

    ResultPageTypeMeetingResult, //会议室青币
    ResultPageTypeSubmitOfficeResult, //青币办公采购
    ResultPageTypeSubmitNetmanagerResult,//青币网络管家翻一页
    ResultPageTypeSubmitPurchsePayResult,//青币抢购
    ResultPageTypeIndustryFinancialResult, //青币财务工商青币
    ResultPageTypeNetVIPPayResult, //青币网络管家

    ResultPageTypeSubmitHousePayResult,//房租缴纳
    ResultPageTypeSubmitPlayTogether,//一起玩儿
};

@interface ResultViewController : RootViewController

@property (nonatomic, assign) ResultPageType pageType;
@property (nonatomic, assign) int earnPoints;

@end

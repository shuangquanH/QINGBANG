//
// Created by zhangkaifeng on 2017/9/29.
// Copyright (c) 2017 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AddressAskConfig : NSObject

typedef UIView *(^SectionFooterViewBlock)(NSInteger section,NSArray *listArray);
typedef double (^SectionFooterHeightBlock)(NSInteger section,NSArray *listArray);

typedef NS_ENUM(NSUInteger, AddressAskSubPageType) {
    AddressAskSubPageTypeOne,   //分栏1
    AddressAskSubPageTypeTwo,   //分栏2
    AddressAskSubPageTypeThree  //分栏3
};

typedef NS_ENUM(NSUInteger, AddressAskPageType) {
    AddressAskPageTypeAddressAsk,               //地址咨询
    AddressAskPageTypeFinancialAccounting,      //财务
    AddressAskPageTypeCommercialRegistration,   //工商注册
    AddressAskPageTypeAddressAskAndRegister,    //地址咨询&工商注册
    AddressAskPageTypeADManager,                //广告管家
    AddressAskPageTypeNetManager,                //网络管家
    AddressAskPageTypeVIPServiceManager               //VIP包月网络管理
};



+ (NSDictionary *)infoDicWithPageType:(int)pageType subPageType:(int)subPageType target:(id)target;

@end
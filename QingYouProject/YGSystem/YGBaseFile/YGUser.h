//
//  YGUser.h
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 16/8/9.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGUser : NSObject

@property (nonatomic,copy) NSString * userId;
@property (nonatomic,copy) NSString * userName;
@property (nonatomic,copy) NSString * phone;
@property (nonatomic,copy) NSString * sex;
@property (nonatomic,copy) NSString * userImg;
@property (nonatomic,copy) NSString * province; //省
@property (nonatomic,copy) NSString * autograph; //
@property (nonatomic,copy) NSString * city;
@property (nonatomic,copy) NSString * address; //地址
@property (nonatomic,copy) NSString * gion; //园区
@property (nonatomic,copy) NSString * code;
@property (nonatomic,copy) NSString * description; //描述
@property (nonatomic,copy) NSString * company;
@property (nonatomic,copy) NSString * point; //青币

@property (nonatomic,assign) BOOL  isCertified; //是否已认证

//以下预留
@property (nonatomic,copy) NSString * allianceID;

@property (nonatomic,assign) BOOL  isUploadBaseInfoForSeccondHand; //是否已认证


@property (nonatomic,copy) NSString * onlineL;
@property (nonatomic,copy) NSString * userid;
@property (nonatomic,copy) NSString * grade;
@property (nonatomic,copy) NSString * gifts;
@property (nonatomic,copy) NSString * bean;
@property (nonatomic,copy) NSString * givingGifts;
@property (nonatomic,copy) NSString * detailAddress;
@property (nonatomic,copy) NSString * badge;
@property (nonatomic,copy) NSString * onePointsWorth;

//合同预留手机号
@property (nonatomic,copy) NSString * myContractPhoneNumber;

/** 是否在园区中  yes  /  no */ 
@property (nonatomic, copy) NSString       *isInGarden;

@end

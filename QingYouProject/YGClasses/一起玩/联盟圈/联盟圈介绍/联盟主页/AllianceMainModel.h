//
//  AllianceMainModel.h
//  QingYouProject
//
//  Created by nefertari on 2017/11/29.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllianceMainModel : NSObject
@property (nonatomic,strong) NSString * activityImg;
@property (nonatomic,strong) NSString * activityName;
@property (nonatomic,strong) NSString * activityAddress;
@property (nonatomic,strong) NSString * activityBeginTime;
@property (nonatomic,strong) NSString * activityEndTime;
@property (nonatomic,strong) NSString * activityID;
@property (nonatomic,strong) NSString * allianceNotice;
@property (nonatomic,strong) NSString * isAttention;
@property (nonatomic,strong) NSString * official;



@property (nonatomic,strong) NSString * userImg;
@property (nonatomic,strong) NSString * userName;
//@property (nonatomic,strong) NSString * certifySign;
@property (nonatomic,strong) NSString * allianceInfo;
@property (nonatomic,strong) NSString * activityCount;//活动数量
@property (nonatomic,strong) NSString * memberCount;//参数人数
@property (nonatomic,strong) NSString * attentionCount; //粉丝数量
//@property (nonatomic,strong) NSString * picture;
@property (nonatomic,strong) NSString * isEnd; //0 没结束 1已结束



@end

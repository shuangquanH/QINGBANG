//
//  WKMyOrderUnreadCountModel.h
//  QingYouProject
//
//  Created by mac on 2018/6/6.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKMyOrderUnreadCountModel : NSObject
/* 会议室预定提示数 **/
@property (nonatomic, assign) NSInteger meetingRoom_badgeNum;
/* 财税代理提示数 **/
@property (nonatomic, assign) NSInteger taxation_badgeNum;
/* 办公采购提示数 **/
@property (nonatomic, assign) NSInteger procurementOfOffice_badgeNum;
/* 工商代办提示数 **/
@property (nonatomic, assign) NSInteger industrial_badgeNum;
/* 水电缴费提示数 **/
@property (nonatomic, assign) NSInteger houserAudit_badgeNum;
/* 办公装修订单提示数 **/
@property (nonatomic, assign) NSInteger decorate_badgeNum;
/* 人才招聘提示数 **/
@property (nonatomic, assign) NSInteger recruitment_badgeNum;
/* 项目申报提示数 **/
@property (nonatomic, assign) NSInteger projectApplication_badgeNum;

@end

//
//  MeetingBookingModel.h
//  QingYouProject
//
//  Created by zhaoao on 2017/10/24.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeetingBookingModel : NSObject

@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *expense;//园区价格
@property(nonatomic,strong)NSString *imgUrl;//图片
@property(nonatomic,strong)NSString *createDate;//创建时间
@property(nonatomic,strong)NSString *roomName;//会议室名
@property(nonatomic,strong)NSString *notes;//须知
@property(nonatomic,strong)NSString *endTime;//结束开放时间
@property(nonatomic,strong)NSString *updateDate;//
@property(nonatomic,strong)NSString *personCount;//可容纳人数
@property(nonatomic,strong)NSString *imgUrlMany;
@property(nonatomic,strong)NSString *areaName;//所属园区
@property(nonatomic,strong)NSString *beginTime;//开始开放时间
@property(nonatomic,strong)NSString *remarks;//备注
@property(nonatomic,strong)NSString *roomEquip;//设备
@property(nonatomic,strong)NSString *address;//详细地址
@property(nonatomic,strong)NSString *tel;//电话

@end
